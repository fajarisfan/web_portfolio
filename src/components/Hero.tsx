"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function Hero() {
  const { lang } = usePortfolio();

  return (
    <section id="top" className="hero-section">
      <div className="hero-inner">
        <div className="hero-text">
          <div className="hero-status">
            <span className="punk-dot" /> {T.t_status[lang]}
          </div>
          <h1
            className="hero-title"
            dangerouslySetInnerHTML={{ __html: T.hero_title[lang] }}
          />
          <p
            className="hero-sub"
            dangerouslySetInnerHTML={{ __html: T.hero_sub[lang] }}
          />
          <a href="#projects" className="punk-btn hero-btn">
            {T.hero_cta[lang]}
          </a>
        </div>
        <div className="hero-ascii">
          <pre>{`
 ___ ___ ___ _   _ _  _ _  __
|_ _/ __| _ \\ | | | \\| | |/ /
 | |\\__ \\  __/ |_| | .\` | ' < 
|___|___/_|   \\___/|_|\\_|_|\\_\\

  >_ python
  >_ flutter
  >_ automation
  >_ healthcare it
  `}</pre>
        </div>
      </div>
    </section>
  );
}
