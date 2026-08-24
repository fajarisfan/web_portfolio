"use client";

import { useState, useEffect, useRef } from "react";
import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";
import type { Project, MediaItem } from "@/lib/types";

export function AddProjectModal() {
  const { lang, addProject } = usePortfolio();
  const [open, setOpen] = useState(false);
  const [name, setName] = useState("");
  const [descEn, setDescEn] = useState("");
  const [descId, setDescId] = useState("");
  const [langTag, setLangTag] = useState("Python");
  const [tags, setTags] = useState("");
  const [url, setUrl] = useState("");
  const [download, setDownload] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);
  const [media, setMedia] = useState<MediaItem[]>([]);

  useEffect(() => {
    const handler = () => setOpen(true);
    window.addEventListener("open-add-project", handler);
    return () => window.removeEventListener("open-add-project", handler);
  }, []);

  const handleFiles = (files: FileList | null) => {
    if (!files) return;
    Array.from(files).forEach((f) => {
      const reader = new FileReader();
      reader.onload = () => {
        setMedia((prev) => [
          ...prev,
          { type: f.type.startsWith("video") ? "video" : "image", url: reader.result as string },
        ]);
      };
      reader.readAsDataURL(f);
    });
  };

  const reset = () => {
    setName(""); setDescEn(""); setDescId(""); setLangTag("Python");
    setTags(""); setUrl(""); setDownload(""); setMedia([]);
  };

  const handleAdd = () => {
    if (!name.trim()) return;
    addProject({
      name: name.trim(),
      desc: { en: descEn, id: descId },
      lang: langTag,
      tags: tags.split(",").map((t) => t.trim()).filter(Boolean),
      url,
      download: download || undefined,
      media,
    });
    reset();
    setOpen(false);
  };

  if (!open) return null;

  return (
    <div className="modal-bg" onClick={() => setOpen(false)}>
      <div className="modal-box" onClick={(e) => e.stopPropagation()}>
        <h3 className="modal-title">{T.m_add_proj[lang]}</h3>
        <input
          className="punk-input"
          placeholder={T.m_name[lang]}
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <textarea
          className="punk-input punk-textarea"
          placeholder={T.m_desc[lang]}
          value={descEn}
          onChange={(e) => setDescEn(e.target.value)}
        />
        <textarea
          className="punk-input punk-textarea"
          placeholder={T.m_desc_id[lang]}
          value={descId}
          onChange={(e) => setDescId(e.target.value)}
        />
        <input
          className="punk-input"
          placeholder={T.m_lang[lang]}
          value={langTag}
          onChange={(e) => setLangTag(e.target.value)}
        />
        <input
          className="punk-input"
          placeholder={T.m_tags[lang]}
          value={tags}
          onChange={(e) => setTags(e.target.value)}
        />
        <input
          className="punk-input"
          placeholder={T.m_url[lang]}
          value={url}
          onChange={(e) => setUrl(e.target.value)}
        />
        <input
          className="punk-input"
          placeholder={T.m_download[lang]}
          value={download}
          onChange={(e) => setDownload(e.target.value)}
        />
        <div
          className="upload-zone"
          onClick={() => fileRef.current?.click()}
          onDragOver={(e) => e.preventDefault()}
          onDrop={(e) => {
            e.preventDefault();
            handleFiles(e.dataTransfer.files);
          }}
        >
          {media.length > 0
            ? `${media.length} file(s) selected`
            : T.m_upload[lang]}
        </div>
        <input
          ref={fileRef}
          type="file"
          multiple
          accept="image/*,video/*"
          hidden
          onChange={(e) => handleFiles(e.target.files)}
        />
        <div className="modal-btns">
          <button className="punk-btn-sm cancel-btn" onClick={() => setOpen(false)}>
            {T.m_cancel[lang]}
          </button>
          <button className="punk-btn-sm save-btn" onClick={handleAdd}>
            {T.m_add[lang]}
          </button>
        </div>
      </div>
    </div>
  );
}
