"use client";

import { useState, useEffect, useRef } from "react";
import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function AddSlideModal() {
  const { lang, addSlide } = usePortfolio();
  const [open, setOpen] = useState(false);
  const [title, setTitle] = useState("");
  const [desc, setDesc] = useState("");
  const [url, setUrl] = useState("");
  const [type, setType] = useState<"image" | "video">("image");
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const handler = () => setOpen(true);
    window.addEventListener("open-add-slide", handler);
    return () => window.removeEventListener("open-add-slide", handler);
  }, []);

  const handleFile = (file: File | undefined) => {
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      setUrl(reader.result as string);
      setType(file.type.startsWith("video") ? "video" : "image");
    };
    reader.readAsDataURL(file);
  };

  const reset = () => { setTitle(""); setDesc(""); setUrl(""); setType("image"); };

  const handleAdd = () => {
    if (!title.trim() || !url) return;
    addSlide({ title: title.trim(), desc, url, type });
    reset();
    setOpen(false);
  };

  if (!open) return null;

  return (
    <div className="modal-bg" onClick={() => setOpen(false)}>
      <div className="modal-box" onClick={(e) => e.stopPropagation()}>
        <h3 className="modal-title">{T.m_add_slide[lang]}</h3>
        <input className="punk-input" placeholder={T.m_title[lang]} value={title} onChange={(e) => setTitle(e.target.value)} />
        <input className="punk-input" placeholder={T.m_desc[lang]} value={desc} onChange={(e) => setDesc(e.target.value)} />
        <div
          className="upload-zone"
          onClick={() => fileRef.current?.click()}
          onDragOver={(e) => e.preventDefault()}
          onDrop={(e) => { e.preventDefault(); handleFile(e.dataTransfer.files[0]); }}
        >
          {url ? (type === "video" ? "Video selected" : "Image selected") : T.m_upload_img[lang]}
        </div>
        <input ref={fileRef} type="file" accept="image/*,video/*" hidden onChange={(e) => handleFile(e.target.files?.[0])} />
        <div className="modal-btns">
          <button className="punk-btn-sm cancel-btn" onClick={() => setOpen(false)}>{T.m_cancel[lang]}</button>
          <button className="punk-btn-sm save-btn" onClick={handleAdd}>{T.m_add[lang]}</button>
        </div>
      </div>
    </div>
  );
}
