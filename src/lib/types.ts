export interface MediaItem {
  type: "image" | "video";
  url: string;
}

export interface Project {
  name: string;
  desc: { en: string; id: string };
  lang: string;
  tags: string[];
  url: string;
  download?: string;
  media: MediaItem[];
}

export interface Slide {
  title: string;
  desc: string;
  url: string;
  type: "image" | "video";
}

export type Lang = "en" | "id";

export interface Translations {
  [key: string]: { en: string; id: string };
}
