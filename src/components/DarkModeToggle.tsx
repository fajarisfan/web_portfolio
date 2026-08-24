"use client";

import { usePortfolio } from "@/context/PortfolioContext";

export function DarkModeToggle() {
  const { darkMode, toggleDarkMode } = usePortfolio();

  return (
    <button
      className="dark-mode-toggle"
      onClick={toggleDarkMode}
      aria-label={darkMode ? "Switch to light mode" : "Switch to dark mode"}
      title={darkMode ? "Switch to light mode" : "Switch to dark mode"}
    >
      {darkMode ? "☀ Light" : "☾ Dark"}
    </button>
  );
}
