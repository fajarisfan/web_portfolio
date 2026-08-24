"use client";

import { useState, useEffect } from "react";

export function Footer() {
  const [year, setYear] = useState(2025);

  useEffect(() => {
    setYear(new Date().getFullYear());
  }, []);

  return (
    <footer className="punk-footer">
      <div className="footer-line" />
      <div className="footer-content">
        <span className="footer-copy">
          Dibuat oleh Isfan Fajar Anugrah. {year}
        </span>
        <span className="footer-ascii">
          {'// DIY'}
        </span>
      </div>
    </footer>
  );
}
