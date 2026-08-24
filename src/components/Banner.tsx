"use client";

import { usePortfolio } from "@/context/PortfolioContext";

export function Banner() {
  const { lang } = usePortfolio();
  const text = "DO IT YOURSELF // PUNK IS ATTITUDE // 1.3.1.2 // A.C.A.B // DIY OR DIE // "
  const repeated = text.repeat(6);

  return (
    <div className="punk-banner">
      <span className="marquee">{repeated}</span>
    </div>
  );
}
