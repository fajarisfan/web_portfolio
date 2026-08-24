"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function Projects() {
  const { lang, projects, editing, deleteProject } = usePortfolio();

  return (
    <section id="projects" className="section projects-section">
      <div className="punk-tag-wrap">
        <span className="punk-tag">{T.proj_tag[lang]}</span>
      </div>
      <h2
        className="section-title"
        dangerouslySetInnerHTML={{ __html: T.proj_title[lang] }}
      />
      <p className="section-subtitle">
        {lang === "id" ? "YANG UDEH JADI" : "WHAT I BUILT"}
      </p>
      <div className="projects-grid">
        {projects.map((proj, i) => (
          <div key={i} className="pcard">
            {editing && (
              <div className="pcard-actions">
                <button
                  className="punk-btn-sm edit-btn"
                  onClick={() => {
                    window.dispatchEvent(
                      new CustomEvent("edit-project", { detail: i })
                    );
                  }}
                >
                  {T.e_edit[lang]}
                </button>
                <button
                  className="punk-btn-sm del-btn"
                  onClick={() => deleteProject(i)}
                >
                  {T.e_del[lang]}
                </button>
              </div>
            )}
            <div className="pcard-head">
              <span className="pcard-icon">{'>'}_</span>
              <span className="pcard-name">{proj.name}</span>
            </div>
            <p className="pcard-desc">{proj.desc[lang]}</p>
            <div className="pcard-tags">
              {proj.tags.map((tag) => (
                <span key={tag} className="tag">
                  {tag}
                </span>
              ))}
            </div>
            <div className="pcard-foot">
              <span className="pcard-lang">{proj.lang}</span>
              {proj.url && proj.url !== "#" && (
                <a href={proj.url} target="_blank" rel="noopener" className="pcard-link">
                  source &rarr;
                </a>
              )}
              {proj.download && (
                <a href={proj.download} className="pcard-link">
                  download &rarr;
                </a>
              )}
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
