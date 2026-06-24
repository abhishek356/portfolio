import { Html, useProgress } from '@react-three/drei'
const CanvasLoader = () => {
  const { progress } = useProgress()
  return (
    <Html as= "div" center style={{display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center'}}>
        <span className = "canvas-loader">
            <p style = {{color: 'white', fontSize: 14, fontWeight: 800, marginTop: 40}}>{progress !== 0 ? `${progress.toFixed(2)}%` : "Loading..."}</p>
        </span>
    </Html>
  )
}

export default CanvasLoader