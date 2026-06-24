#!/usr/bin/env bash
set -euo pipefail

# Define the GitHub repository URL to clone from.
# If REPO_URL is not provided, it will be built from GITHUB_SERVER_URL and GITHUB_REPOSITORY.
REPO_URL="${REPO_URL:-${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-abhishek356/portfolio}.git}"

# Target folder on the remote VM where the project will live.
# This should be passed explicitly from the workflow via the GCP_DEPLOY_PATH value.
if [ -z "${DEPLOY_PATH:-}" ]; then
  echo "DEPLOY_PATH is not set. Please provide a writable directory on the VM." >&2
  exit 1
fi

# Application name used for the log file.
APP_NAME="${APP_NAME:-portfolio}"

# Branch to deploy from.
BRANCH="${BRANCH:-main}"

# Ensure the VM has the basic tools required for deployment.
if ! command -v git >/dev/null 2>&1; then
  echo "git not found. Installing git..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git
  else
    echo "apt-get not available. Please install git manually." >&2
    exit 1
  fi
fi

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  echo "node/npm not found. Installing Node.js..."
  if command -v apt-get >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
    sudo apt-get install -y nodejs
  else
    echo "apt-get not available. Please install nodejs/npm manually." >&2
    exit 1
  fi
fi

# Create the deployment directory if it does not already exist.
mkdir -p "$DEPLOY_PATH"

# Move into the deployment directory so the commands run there.
cd "$DEPLOY_PATH"

# If the target folder already contains a Git repository, update it.
# If it is empty, clone the project into it.
# If it contains files but is not a Git repo, reinitialize it as a fresh deployment folder.
if [ -d .git ]; then
  git fetch origin "$BRANCH"
  git checkout "$BRANCH"
  git pull origin "$BRANCH"
elif [ -z "$(find . -mindepth 1 -maxdepth 1 -print -quit)" ]; then
  git clone --branch "$BRANCH" "$REPO_URL" "$DEPLOY_PATH"
else
  echo "Deployment path '$DEPLOY_PATH' exists and is not empty. Reinitializing it as a fresh deployment folder..."
  rm -rf "$DEPLOY_PATH"
  mkdir -p "$DEPLOY_PATH"
  git clone --branch "$BRANCH" "$REPO_URL" "$DEPLOY_PATH"
fi

# Install Node.js dependencies only if the node_modules folder is missing.
# This saves time on later deployments.
if [ ! -d node_modules ]; then
  cd "$DEPLOY_PATH"
  npm install
fi

# Install PM2 globally if it is not already available.
if ! command -v pm2 >/dev/null 2>&1; then
  npm install -g pm2
fi

# Build the Vite app so the production files are generated.
npm run build

# Stop any existing PM2 process for this app before starting a new one.
pm2_process_name="${APP_NAME}-preview"
pm2 --silent delete "$pm2_process_name" >/dev/null 2>&1 || true

# Start the preview server through PM2 so it stays alive and can be managed easily.
pm2 start "npm run preview -- --host 0.0.0.0 --port 3000" \
  --name "$pm2_process_name" \
  --cwd "$DEPLOY_PATH" \
  --log "$DEPLOY_PATH/$APP_NAME.log"

# Make sure PM2 starts the process automatically on machine reboot.
pm2 startup systemd -u "$USER" --hp "$HOME" >/dev/null 2>&1 || true
pm2 save >/dev/null 2>&1 || true

# Inform the user that the deployment completed successfully.
echo "Deployment complete. App is running on port 3000 via PM2."
