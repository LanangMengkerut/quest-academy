"use client";

import { useEffect, useState } from "react";

const KEY = "qa-music";

/** Music preference: default ON, stored locally, shared via a window event. */
export function useMusic(): [boolean, () => void] {
  const [music, setMusic] = useState(true);

  useEffect(() => {
    const read = () => {
      try {
        setMusic(localStorage.getItem(KEY) !== "off");
      } catch {
        setMusic(true);
      }
    };
    read();
    window.addEventListener("qa-music-change", read);
    return () => window.removeEventListener("qa-music-change", read);
  }, []);

  const toggle = () => {
    const next = !music;
    setMusic(next);
    try {
      localStorage.setItem(KEY, next ? "on" : "off");
    } catch {
      /* ignore */
    }
    window.dispatchEvent(new Event("qa-music-change"));
  };

  return [music, toggle];
}
