"use client";

import { useState, useEffect, useRef } from "react";
import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function EditSlideModal() {
  const { lang, slides, updateSlide } = usePortfolio();
  const [open, setOpen] = useState(false);
  const [idx, setIdx] = useState(-1);
  const [title, setTitle] = useState("");
  const [desc, setDesc] = useState("");
  const [url, setUrl] = useState("");
  const [type, setType] = useState<"image" | "video">("image");
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const handler = (e: CustomEvent) => {
      const i = e.detail as number;
      const s = slides[i];
      if (!s) return;
      setIdx(i);
      setTitle(s.title);
      setDesc(s.desc);
      setUrl(s.url);
      setType(s.type);
      setOpen(true);
    };
    window.addEventListener("edit-slide" as any, handler);
    return () => window.removeEventListener("edit-slide" as any, handler);
  }, [slides]);

  const handleFile = (file: File | undefined) => {
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      setUrl(reader.result as string);
      setType(file.type.startsWith("video") ? "video" : "image");
    };
    reader.readAsDataURL(file);
  };

  const handleSave = () => {
    if (idx < 0 || !title.trim() || !url) return;
    updateSlide(idx, { title: title.trim(), desc, url, type });
    setOpen(false);
  };

  if (!open) return null;

  return (
    <div className="modal-bg" onClick={() => setOpen(false)}>
      <div className="modal-box" onClick={(e) => e.stopPropagation()}>
        <h3 className="modal-title">{T.m_edit_slide[lang]}</h3>
        <input
          className="punk-input"
          placeholder={T.m_title[lang]}
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <input
          className="punk-input"
          placeholder={T.m_desc[lang]}
          value={desc}
          onChange={(e) => setDesc(e.target.value)}
        />
        <div
          className="upload-zone"
          onClick={() => fileRef.current?.click()}
          onDragOver={(e) => e.preventDefault()}
          onDrop={(e) => {
            e.preventDefault();
            handleFile(e.dataTransfer.files[0]);
          }}
        >
          {url
            ? type === "video"
              ? "Video selected"
              : "Image selected"
            : T.m_upload_img[lang]}
        </div>
        <input
          ref={fileRef}
          type="file"
          accept="image/*,video/*"
          hidden
          onChange={(e) => handleFile(e.target.files?.[0])}
        />
        <div className="modal-btns">
          <button
            className="punk-btn-sm cancel-btn"
            onClick={() => setOpen(false)}
          >
            {T.m_cancel[lang]}
          </button>
          <button className="punk-btn-sm save-btn" onClick={handleSave}>
            {T.m_save[lang]}
          </button>
        </div>
      </div>
    </div>
  );
}
