"use client";

import { useState } from "react";
import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function Navbar() {
  const { lang } = usePortfolio();
  const [menuOpen, setMenuOpen] = useState(false);
  const links = ["about", "gallery", "projects", "tech", "contact"] as const;

  return (
    <nav className="punk-nav">
      <div className="nav-left">
        <a href="#top" className="punk-logo">
          {`IS PUNK`}
        </a>
      </div>
      {/* Desktop links */}
      <div className="nav-right nav-desktop">
        {links.map((l) => {
          const key = `nav_${l}`;
          return (
            <a key={l} href={`#${l}`} className="nav-link">
              {T[key]?.[lang] ?? l}
            </a>
          );
        })}
      </div>
      {/* Hamburger button - mobile */}
      <button
        className="nav-hamburger"
        onClick={() => setMenuOpen((o) => !o)}
        aria-label="Toggle menu"
        aria-expanded={menuOpen}
      >
        <span /><span /><span />
      </button>
      {/* Mobile dropdown */}
      {menuOpen && (
        <div className="nav-mobile-menu">
          {links.map((l) => {
            const key = `nav_${l}`;
            return (
              <a
                key={l}
                href={`#${l}`}
                className="nav-link"
                onClick={() => setMenuOpen(false)}
              >
                {T[key]?.[lang] ?? l}
              </a>
            );
          })}
        </div>
      )}
    </nav>
  );
}
