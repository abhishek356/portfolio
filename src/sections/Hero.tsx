import { Canvas } from "@react-three/fiber"
import { PerspectiveCamera } from "@react-three/drei"
import HackerRoom from "../components/HackerRoom"
import { Suspense } from "react"
import CanvasLoader from "../components/CanvasLoader"

export const Hero = () => { 
    return (<>
    <section className = " min-h-screen w-full  flex flex-col relative">
        <div className = 'w-full mx-auto flex flex-col sm:mt-36 mt-20 c-space gap-3'>
            <p className = "sm:text-3xl text-2xl font-medium text-white text-center font-generalsans">
                Hi, I am Abhishek <span className = "waving-hand">👋</span>
            </p>
            <p className = "hero_tag text-gray-gradient">Building Products & Solutions</p>

        </div>
        <div className = "w-full h-full absolute inset-0">
            {/**
             * Canvas is the root of a React Three Fiber scene.
             * It creates the WebGL renderer, manages the animation loop,
             * and mounts the 3D scene into the DOM.
             *
             * Common props:
             * - className: applies CSS/Tailwind sizing and layout styles.
             * - camera: overrides the default camera settings.
             * - shadows: enables shadow rendering.
             * - gl: custom WebGL renderer configuration.
             * - dpr: device pixel ratio for sharper or lighter rendering.
             * - frameloop: "always" | "demand" | "never" to control updates.
             * - onCreated: callback after the renderer/scene/camera are ready.
             */}
            <Canvas className= "w-full h-full">
                <Suspense fallback={<CanvasLoader />}>
                {/**
                 * PerspectiveCamera simulates a real-world camera with perspective.
                 * Objects farther away appear smaller, which is ideal for 3D scenes.
                 *
                 * Common props:
                 * - makeDefault: makes this the active camera for the scene.
                 * - position: [x, y, z] position in world space.
                 * - fov: field of view in degrees (default is usually 45).
                 * - near/far: clipping planes to control visible depth range.
                 * - aspect: width/height ratio, often set automatically.
                 * - rotation: camera orientation in radians.
                 */}
                <PerspectiveCamera makeDefault position={[0, 0, 30]}></PerspectiveCamera>
                <HackerRoom scale={0.07} position={[0, 0, 0]} rotation={[0, 280, 0]} />
                <ambientLight intensity={1} />
                <directionalLight position={[10, 10, 10]} intensity={1.5} />
                </Suspense>
            </Canvas>
        </div>

    </section>
    </>)
}








