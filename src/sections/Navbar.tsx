import { useState } from "react";

const Navbar = () => {

  const [isOpen, setIsOpen] = useState(false);

  const handleToggle = () => {
    setIsOpen((prevValue) => !prevValue);
  }

  return (
    <header className = "fixed top-0 left-0 z-50 bg-black/90 w-full">
            <div className = "max-w-7xl mx-auto">
                <div className = "flex items-center justify-between py-5 mx-auto c-space">
                    {/* Brand link: clickable home link with muted text, bold styling,
                       larger text size, white hover color, and smooth color transition. */}
                    <a href = "/" className = "text-neutral-400 font-bold text-xl hover:text-white transition-colors">Abhishek</a>
                            <button 
                            className = 'text-neutral-400 hover:  focus:outline-none sm:hidden flex' aria-label="Toggle menu" onClick={handleToggle}>
                                <img src = {isOpen?'./assets/close.svg':'./assets/menu.svg'} alt = "menu" className = "w-6 h-6"/>
                            </button>

                            <nav className = 'sm:flex hidden'></nav>
                </div>

            </div>
    </header>
  )
}

export default Navbar