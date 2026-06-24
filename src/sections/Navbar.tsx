import { useState } from "react";
import {navLinks} from '../constants/index'

/*
 * NavItems
 *
 * Renders a list of navigation links from the `navLinks` array
 * (imported from `../constants/index`).
 *
 * Expected shape of each `navLinks` item:
 *   { id: string | number, name: string, href: string }
 *
 * Behavior:
 * - Maps over `navLinks` and renders a <li> containing an <a> for
 *   each entry.
 * - Uses `link.id` as the React `key`.
 * - This component only handles rendering; layout and responsive
 *   visibility are controlled by the parent `Navbar` and CSS.
 *
 * Usage:
 *   <nav><NavItems /></nav>
 */
const NavItems = () => {
  return(<>
    <div className = "nav-ul">
      {navLinks.map((link) => (
        <li key={link.id}   className="nav-li">
          <a href={link.href} className="nav-li_a">
                      {link.name}
            </a>
        </li>
      ))}
    </div>
  </>)
}

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

                            <nav className = 'sm:flex hidden'>
                              <NavItems />
                            </nav>
                </div>

            </div>
            <div className = {`nav-sidebar ${isOpen ? 'max-h-screen' : 'max-h-0'}`}>
              <nav className = 'p-5'>
                <NavItems />
              </nav>
            </div>
    </header>
  )
}

export default Navbar