import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Isfan Fajar Anugrah // Web Portfolio",
  description: "Isfan Fajar Anugrah - Python Developer. Healthcare IT, automation, data tools.",
  keywords: ["Python", "Flutter", "Healthcare IT", "Automation", "Developer", "Portfolio", "BPJS", "Streamlit"],
  authors: [{ name: "Isfan Fajar Anugrah" }],
  openGraph: {
    title: "Isfan Fajar Anugrah // Web Portfolio",
    description: "Python Developer. Healthcare IT, automation, data tools. No buzzwords, just code.",
    url: "https://isfanfajar.dev",
    siteName: "Isfan Fajar Anugrah Portfolio",
    type: "website",
  },
  twitter: {
    card: "summary",
    title: "Isfan Fajar Anugrah // Web Portfolio",
    description: "Python Developer. Healthcare IT, automation, data tools.",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
