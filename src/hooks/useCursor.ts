"use client";

import { useEffect, useRef } from "react";

export function useCursor() {
  const curRef = useRef<HTMLDivElement>(null);
  const trailRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const cur = curRef.current;
    const trail = trailRef.current;
    if (!cur || !trail) return;

    let mx = 0, my = 0, tx = 0, ty = 0;
    let raf: number;

    const onMove = (e: MouseEvent) => { mx = e.clientX; my = e.clientY; };
    const onDown = () => cur.classList.add("click");
    const onUp = () => cur.classList.remove("click");

    const anim = () => {
      tx += (mx - tx) * 0.15;
      ty += (my - ty) * 0.15;
      cur.style.left = mx + "px";
      cur.style.top = my + "px";
      trail.style.left = tx + "px";
      trail.style.top = ty + "px";
      raf = requestAnimationFrame(anim);
    };

    document.addEventListener("mousemove", onMove);
    document.addEventListener("mousedown", onDown);
    document.addEventListener("mouseup", onUp);
    raf = requestAnimationFrame(anim);

    return () => {
      document.removeEventListener("mousemove", onMove);
      document.removeEventListener("mousedown", onDown);
      document.removeEventListener("mouseup", onUp);
      cancelAnimationFrame(raf);
    };
  }, []);

  useEffect(() => {
    const addHover = (el: Element) => {
      el.addEventListener("mouseenter", () => {
        curRef.current?.classList.add("hover");
        trailRef.current?.classList.add("hover");
      });
      el.addEventListener("mouseleave", () => {
        curRef.current?.classList.remove("hover");
        trailRef.current?.classList.remove("hover");
      });
    };

    const selector = "a,button,.pcard,.upload-zone,.lang-btns button,.tag,.gal-dot,.edit-toggle,.tech-item";
    document.querySelectorAll(selector).forEach(addHover);

    const observer = new MutationObserver(() => {
      document.querySelectorAll(selector).forEach(addHover);
    });
    observer.observe(document.body, { childList: true, subtree: true });

    return () => observer.disconnect();
  }, []);

  return { curRef, trailRef };
}
