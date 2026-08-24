"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function EditBar() {
  const { editing, lang, toggleEdit, saveAll } = usePortfolio();

  if (!editing) return null;

  return (
    <div className="edit-bar">
      <span className="edit-bar-label">{T.e_active[lang]}</span>
      <button
        className="punk-btn-sm"
        onClick={() =>
          window.dispatchEvent(new CustomEvent("open-add-project"))
        }
      >
        {T.e_add_proj[lang]}
      </button>
      <button
        className="punk-btn-sm"
        onClick={() =>
          window.dispatchEvent(new CustomEvent("open-add-slide"))
        }
      >
        {T.e_add_slide[lang]}
      </button>
      <button className="punk-btn-sm save-btn" onClick={saveAll}>
        {T.e_save[lang]}
      </button>
      <button className="punk-btn-sm cancel-btn" onClick={toggleEdit}>
        {T.e_cancel[lang]}
      </button>
    </div>
  );
}
