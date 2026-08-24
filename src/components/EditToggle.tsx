"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function EditToggle() {
  const { editing, toggleEdit } = usePortfolio();

  return (
    <button className="edit-toggle" onClick={toggleEdit}>
      {editing ? T.e_save["en"] : "EditMode"}
    </button>
  );
}
