"use client";

import { useState, useEffect, useRef } from "react";
import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";
import type { MediaItem } from "@/lib/types";

export function EditProjectModal() {
  const { lang, projects, updateProject } = usePortfolio();
  const [open, setOpen] = useState(false);
  const [idx, setIdx] = useState(-1);
  const [name, setName] = useState("");
  const [descEn, setDescEn] = useState("");
  const [descId, setDescId] = useState("");
  const [langTag, setLangTag] = useState("");
  const [tags, setTags] = useState("");
  const [url, setUrl] = useState("");
  const [download, setDownload] = useState("");
  const [media, setMedia] = useState<MediaItem[]>([]);
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const handler = (e: CustomEvent) => {
      const i = e.detail as number;
      const p = projects[i];
      if (!p) return;
      setIdx(i);
      setName(p.name);
      setDescEn(p.desc.en);
      setDescId(p.desc.id);
      setLangTag(p.lang);
      setTags(p.tags.join(", "));
      setUrl(p.url);
      setDownload(p.download || "");
      setMedia(p.media || []);
      setOpen(true);
    };
    window.addEventListener("edit-project" as any, handler);
    return () => window.removeEventListener("edit-project" as any, handler);
  }, [projects]);

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

  const handleSave = () => {
    if (idx < 0 || !name.trim()) return;
    updateProject(idx, {
      name: name.trim(),
      desc: { en: descEn, id: descId },
      lang: langTag,
      tags: tags.split(",").map((t) => t.trim()).filter(Boolean),
      url,
      download: download || undefined,
      media,
    });
    setOpen(false);
  };

  if (!open) return null;

  return (
    <div className="modal-bg" onClick={() => setOpen(false)}>
      <div className="modal-box" onClick={(e) => e.stopPropagation()}>
        <h3 className="modal-title">{T.m_edit_proj[lang]}</h3>
        <input className="punk-input" placeholder={T.m_name[lang]} value={name} onChange={(e) => setName(e.target.value)} />
        <textarea className="punk-input punk-textarea" placeholder={T.m_desc[lang]} value={descEn} onChange={(e) => setDescEn(e.target.value)} />
        <textarea className="punk-input punk-textarea" placeholder={T.m_desc_id[lang]} value={descId} onChange={(e) => setDescId(e.target.value)} />
        <input className="punk-input" placeholder={T.m_lang[lang]} value={langTag} onChange={(e) => setLangTag(e.target.value)} />
        <input className="punk-input" placeholder={T.m_tags[lang]} value={tags} onChange={(e) => setTags(e.target.value)} />
        <input className="punk-input" placeholder={T.m_url[lang]} value={url} onChange={(e) => setUrl(e.target.value)} />
        <input className="punk-input" placeholder={T.m_download[lang]} value={download} onChange={(e) => setDownload(e.target.value)} />
        <div
          className="upload-zone"
          onClick={() => fileRef.current?.click()}
          onDragOver={(e) => e.preventDefault()}
          onDrop={(e) => { e.preventDefault(); handleFiles(e.dataTransfer.files); }}
        >
          {media.length > 0 ? `${media.length} file(s) selected` : T.m_upload_img[lang]}
        </div>
        <input ref={fileRef} type="file" multiple accept="image/*,video/*" hidden onChange={(e) => handleFiles(e.target.files)} />
        <div className="modal-btns">
          <button className="punk-btn-sm cancel-btn" onClick={() => setOpen(false)}>{T.m_cancel[lang]}</button>
          <button className="punk-btn-sm save-btn" onClick={handleSave}>{T.m_save[lang]}</button>
        </div>
      </div>
    </div>
  );
}
