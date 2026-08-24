"use client";

import { createContext, useContext, useCallback, useState, useEffect, type ReactNode } from "react";
import type { Project, Slide, Lang } from "@/lib/types";
import { defaultProjects } from "@/lib/defaultProjects";
import { defaultSlides } from "@/lib/defaultSlides";
import { useLocalStorage } from "@/hooks/useLocalStorage";

interface PortfolioCtx {
  lang: Lang;
  setLang: (l: Lang) => void;
  darkMode: boolean;
  toggleDarkMode: () => void;
  projects: Project[];
  setProjects: (p: Project[] | ((prev: Project[]) => Project[])) => void;
  slides: Slide[];
  setSlides: (s: Slide[] | ((prev: Slide[]) => Slide[])) => void;
  editing: boolean;
  toggleEdit: () => void;
  addProject: (p: Project) => void;
  updateProject: (i: number, p: Project) => void;
  deleteProject: (i: number) => void;
  addSlide: (s: Slide) => void;
  updateSlide: (i: number, s: Slide) => void;
  deleteSlide: (i: number) => void;
  saveAll: () => void;
}

const PortfolioContext = createContext<PortfolioCtx | null>(null);

export function PortfolioProvider({ children }: { children: ReactNode }) {
  const [lang, setLangState] = useLocalStorage<Lang>("p_lang", "en");

  // Version bump — clears stale localStorage data when defaults change
  useEffect(() => {
    const DATA_VERSION = "v3";
    if (typeof window !== "undefined" && window.localStorage.getItem("p_data_version") !== DATA_VERSION) {
      window.localStorage.removeItem("p_projs");
      window.localStorage.removeItem("p_slides");
      window.localStorage.setItem("p_data_version", DATA_VERSION);
    }
  }, []);

  const [projects, setProjects] = useLocalStorage<Project[]>(
    "p_projs",
    defaultProjects
  );
  const [slides, setSlides] = useLocalStorage<Slide[]>("p_slides", defaultSlides);
  const [editing, setEditing] = useState(false);

  const [darkMode, setDarkModeState] = useLocalStorage<boolean>("p_dark", true);

  // Sync dark mode class on <html>
  useEffect(() => {
    if (typeof document !== "undefined") {
      document.documentElement.classList.toggle("light", !darkMode);
    }
  }, [darkMode]);

  const toggleDarkMode = useCallback(() => {
    setDarkModeState((prev) => !prev);
  }, [setDarkModeState]);

  const setLang = useCallback((l: Lang) => {
    setLangState(l);
    if (typeof window !== "undefined") {
      window.localStorage.setItem("p_lang", l);
    }
  }, [setLangState]);

  const toggleEdit = useCallback(() => setEditing((e) => !e), []);

  const addProject = useCallback(
    (p: Project) => {
      setProjects((prev) => {
        const next = [...prev, p];
        window.localStorage.setItem("p_projs", JSON.stringify(next));
        return next;
      });
    },
    [setProjects]
  );

  const updateProject = useCallback(
    (i: number, p: Project) => {
      setProjects((prev) => {
        const next = [...prev];
        next[i] = p;
        window.localStorage.setItem("p_projs", JSON.stringify(next));
        return next;
      });
    },
    [setProjects]
  );

  const deleteProject = useCallback(
    (i: number) => {
      if (!confirm("Delete?")) return;
      setProjects((prev) => {
        const next = prev.filter((_, idx) => idx !== i);
        window.localStorage.setItem("p_projs", JSON.stringify(next));
        return next;
      });
    },
    [setProjects]
  );

  const addSlide = useCallback(
    (s: Slide) => {
      setSlides((prev) => {
        const next = [...prev, s];
        window.localStorage.setItem("p_slides", JSON.stringify(next));
        return next;
      });
    },
    [setSlides]
  );

  const updateSlide = useCallback(
    (i: number, s: Slide) => {
      setSlides((prev) => {
        const next = [...prev];
        next[i] = s;
        window.localStorage.setItem("p_slides", JSON.stringify(next));
        return next;
      });
    },
    [setSlides]
  );

  const deleteSlide = useCallback(
    (i: number) => {
      setSlides((prev) => {
        const next = prev.filter((_, idx) => idx !== i);
        window.localStorage.setItem("p_slides", JSON.stringify(next));
        return next;
      });
    },
    [setSlides]
  );

  const saveAll = useCallback(() => {
    if (typeof window !== "undefined") {
      window.localStorage.setItem("p_projs", JSON.stringify(projects));
      window.localStorage.setItem("p_slides", JSON.stringify(slides));
      alert("Saved!");
      setEditing(false);
    }
  }, [projects, slides]);

  return (
    <PortfolioContext.Provider
      value={{
        lang,
        setLang,
        darkMode,
        toggleDarkMode,
        projects,
        setProjects,
        slides,
        setSlides,
        editing,
        toggleEdit,
        addProject,
        updateProject,
        deleteProject,
        addSlide,
        updateSlide,
        deleteSlide,
        saveAll,
      }}
    >
      {children}
    </PortfolioContext.Provider>
  );
}

export function usePortfolio() {
  const ctx = useContext(PortfolioContext);
  if (!ctx) throw new Error("usePortfolio must be used within PortfolioProvider");
  return ctx;
}
