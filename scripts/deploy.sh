#!/usr/bin/env bash
set -euo pipefail

# Define the GitHub repository URL to clone from.
# If REPO_URL is not provided, it will be built from GITHUB_SERVER_URL and GITHUB_REPOSITORY.
REPO_URL="${REPO_URL:-${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-abhishek356/portfolio}.git}"

# Target folder on the remote VM where the project will live.
# Use the current user's home directory so the path is always writable for that account.
DEFAULT_DEPLOY_PATH="${HOME:-/home/$USER}/app"
DEPLOY_PATH="${DEPLOY_PATH:-$DEFAULT_DEPLOY_PATH}"

# Application name used for the log file.
APP_NAME="${APP_NAME:-portfolio}"

# Branch to deploy from.
BRANCH="${BRANCH:-main}"

# Create the deployment directory if it does not already exist.
sudo mkdir -p "$DEPLOY_PATH"

# Move into the deployment directory so the commands run there.
cd "$DEPLOY_PATH"

# If this folder is not already a Git repository, clone the project.
# Otherwise, fetch the latest changes from the selected branch and update the working copy.
if [ ! -d .git ]; then
  git clone --branch "$BRANCH" "$REPO_URL" "$DEPLOY_PATH"
else
  git fetch origin "$BRANCH"
  git checkout "$BRANCH"
  git pull origin "$BRANCH"
fi

# Install Node.js dependencies only if the node_modules folder is missing.
# This saves time on later deployments.
if [ ! -d node_modules ]; then
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
