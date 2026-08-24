"use client";

import { usePortfolio } from "@/context/PortfolioContext";
import { T } from "@/lib/translations";

export function Contact() {
  const { lang } = usePortfolio();

  return (
    <section id="contact" className="section contact-section">
      <div className="punk-tag-wrap">
        <span className="punk-tag">{T.c_tag[lang]}</span>
      </div>
      <h2
        className="section-title"
        dangerouslySetInnerHTML={{ __html: T.c_title[lang] }}
      />
      <p className="contact-sub">{T.c_sub[lang]}</p>
      <div className="contact-links">
        <a
          href="#"
          onClick={(e) => e.preventDefault()}
          className="punk-btn punk-btn--disabled"
          aria-disabled="true"
          title="GitHub — contact me directly"
        >
          GitHub
        </a>
        <a href="https://mail.google.com/mail/?view=cm&fs=1&to=isfanfajara@gmail.com" target="_blank" rel="noopener" className="punk-btn">
          Gmail
        </a>
        <a href="https://www.linkedin.com/in/isfan-fajar-anugrah-1b4191280/" target="_blank" rel="noopener" className="punk-btn">
          Linkedin
        </a>  
      </div>
      <div className="contact-ascii">
        <pre>{`
  >_ isfanfajara@gmail.com
  >_ linkedin/isfan-fajar-anugrah
        `}</pre>
      </div>
    </section>
  );
}
