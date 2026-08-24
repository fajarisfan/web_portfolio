"use client";

import { PortfolioProvider } from "@/context/PortfolioContext";
import { useCursor } from "@/hooks/useCursor";
import { useReveal } from "@/hooks/useReveal";
import { Banner } from "@/components/Banner";
import { Navbar } from "@/components/Navbar";
import { Hero } from "@/components/Hero";
import { About } from "@/components/About";
import { Gallery } from "@/components/Gallery";
import { Projects } from "@/components/Projects";
import { TechStack } from "@/components/TechStack";
import { Contact } from "@/components/Contact";
import { Footer } from "@/components/Footer";
import { LanguageToggle } from "@/components/LanguageToggle";
import { EditToggle } from "@/components/EditToggle";
import { EditBar } from "@/components/EditBar";
import { DarkModeToggle } from "@/components/DarkModeToggle";
import { AddProjectModal } from "@/components/AddProjectModal";
import { EditProjectModal } from "@/components/EditProjectModal";
import { AddSlideModal } from "@/components/AddSlideModal";
import { EditSlideModal } from "@/components/EditSlideModal";

function CursorLayer() {
  const { curRef, trailRef } = useCursor();
  return (
    <>
      <div ref={curRef} className="punk-cursor" />
      <div ref={trailRef} className="punk-trail" />
    </>
  );
}

function RevealWrapper({ children }: { children: React.ReactNode }) {
  const ref = useReveal();
  return <div ref={ref}>{children}</div>;
}

export default function Home() {
  return (
    <PortfolioProvider>
      <CursorLayer />
      <Banner />
      <Navbar />
      <RevealWrapper>
        <Hero />
        <About />
        <Gallery />
        <Projects />
        <TechStack />
        <Contact />
      </RevealWrapper>
      <Footer />
      <LanguageToggle />
      <EditToggle />
      <DarkModeToggle />
      <EditBar />
      <AddProjectModal />
      <EditProjectModal />
      <AddSlideModal />
      <EditSlideModal />
    </PortfolioProvider>
  );
}
