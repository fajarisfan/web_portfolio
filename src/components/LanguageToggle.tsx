"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { Lang } from "@/lib/types";

export function LanguageToggle() {
  const { lang, setLang } = usePortfolio();

  return (
    <div className="lang-btns">
      <button
        className={`lang-btn ${lang === "en" ? "active" : ""}`}
        onClick={() => setLang("en")}
      >
        EN
      </button>
      <button
        className={`lang-btn ${lang === "id" ? "active" : ""}`}
        onClick={() => setLang("id")}
      >
        ID
      </button>
    </div>
  );
}
