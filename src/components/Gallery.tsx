"use client";

import { useState, useEffect, useRef } from "react";
import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function Gallery() {
  const { lang, slides, editing, deleteSlide } = usePortfolio();
  const [current, setCurrent] = useState(0);
  const [animKey, setAnimKey] = useState(0);
  const [mounted, setMounted] = useState(false);
  const timerRef = useRef<ReturnType<typeof setInterval>>(null);

  useEffect(() => setMounted(true), []);

  const goTo = (i: number) => {
    setCurrent(i);
    setAnimKey((k) => k + 1);
  };

  useEffect(() => {
    if (!mounted || slides.length <= 1) return;
    timerRef.current = setInterval(() => {
      setCurrent((c) => {
        const next = (c + 1) % slides.length;
        setAnimKey((k) => k + 1);
        return next;
      });
    }, 5000);
    return () => clearInterval(timerRef.current!);
  }, [mounted, slides.length]);

  if (!mounted || slides.length === 0) {
    return (
      <section id="gallery" className="section gallery-section">
        <div className="punk-tag-wrap">
          <span className="punk-tag">{T.gal_tag[lang]}</span>
        </div>
        <h2
          className="section-title"
          dangerouslySetInnerHTML={{ __html: T.gal_title[lang] }}
        />
        <div className="gallery-empty">
          <pre>{`// NO MEDIA YET
// add slides in edit mode`}</pre>
        </div>
      </section>
    );
  }

  const slide = slides[current];

  return (
    <section id="gallery" className="section gallery-section">
      <div className="punk-tag-wrap">
        <span className="punk-tag">{T.gal_tag[lang]}</span>
      </div>
      <h2
        className="section-title"
        dangerouslySetInnerHTML={{ __html: T.gal_title[lang] }}
      />
      <div className="gallery-wrap">
        {editing && (
          <div className="gal-edit-bar">
            <button
              className="punk-btn-sm edit-btn"
              onClick={() =>
                window.dispatchEvent(
                  new CustomEvent("edit-slide", { detail: current })
                )
              }
            >
              {T.e_edit[lang]}
            </button>
            <button
              className="punk-btn-sm del-btn"
              onClick={() => {
                deleteSlide(current);
                if (current >= slides.length - 1 && current > 0) {
                  setCurrent(current - 1);
                }
              }}
            >
              {T.e_del[lang]}
            </button>
          </div>
        )}
        <div className="gallery-viewport">
          {slide.type === "video" ? (
            <video
              key={animKey}
              src={slide.url}
              autoPlay
              loop
              muted
              playsInline
              className="gal-media gal-enter"
              onCanPlay={(e) => {
                e.currentTarget.classList.remove("gal-enter");
                e.currentTarget.classList.add("gal-active");
              }}
            />
          ) : (
            <img
              key={animKey}
              src={slide.url}
              alt={slide.title}
              className="gal-media gal-enter"
              onLoad={(e) => {
                e.currentTarget.classList.remove("gal-enter");
                e.currentTarget.classList.add("gal-active");
              }}
            />
          )}
        </div>
        <div className="gal-caption">
          <span className="gal-title">{slide.title}</span>
          <span className="gal-desc">{slide.desc}</span>
        </div>
        <div className="gal-dots">
          {slides.map((_, i) => (
            <button
              key={i}
              className={`gal-dot ${i === current ? "active" : ""}`}
              onClick={() => goTo(i)}
            />
          ))}
        </div>
      </div>
    </section>
  );
}
