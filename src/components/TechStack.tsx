"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

const TECHS = [
  { name: "Python", desc: "main lang", icon: "🐍" },
  { name: "Flutter", desc: "mobile", icon: "💙" },
  { name: "PowerShell", desc: "automation", icon: "⚡" },
  { name: "Streamlit", desc: "data apps", icon: "📊" },
  { name: "PostgreSQL", desc: "database", icon: "🐘" },
  { name: "API", desc: "integrations", icon: "🌐" },
  { name: "Replit", desc: "cloud coding", icon: "🌀" },
  { name: "Supabase", desc: "backend", icon: "🔥" },
  { name: "Git", desc: "vcs", icon: "🌿" },
  { name: "Linux", desc: "server", icon: "🐧" },
];

export function TechStack() {
  const { lang } = usePortfolio();

  return (
    <section id="tech" className="section tech-section">
      <div className="punk-tag-wrap">
        <span className="punk-tag">{T.tech_tag[lang]}</span>
      </div>
      <h2
        className="section-title"
        dangerouslySetInnerHTML={{ __html: T.tech_title[lang] }}
      />
      <p className="section-subtitle">
        {lang === "id" ? "YANG GUE PAKE" : "WHAT I USE"}
      </p>
      <div className="tech-grid">
        {TECHS.map((t) => (
          <div key={t.name} className="tech-item">
            <span className="tech-icon">{t.icon}</span>
            <span className="tech-name">{t.name}</span>
            <span className="tech-desc">{t.desc}</span>
          </div>
        ))}
      </div>
    </section>
  );
}
