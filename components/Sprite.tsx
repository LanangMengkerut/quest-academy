import type { CSSProperties } from "react";

export const CHAR_SPRITES: Record<string, string> = {
  wizard: "/sprites/wizard.png",
  knight: "/sprites/knight.png",
  elf: "/sprites/elf.png",
};

export const CHAR_NAMES: Record<string, string> = {
  wizard: "Sage",
  knight: "Knight",
  elf: "Archer",
};

export const BOSS_SPRITES: Record<string, { src: string; aspect: string }> = {
  orc: { src: "/sprites/boss-orc.png", aspect: "684/912" },
  lich: { src: "/sprites/boss-lich.png", aspect: "684/912" },
  dragon: { src: "/sprites/boss-dragon.png", aspect: "800/800" },
};

type SpriteProps = {
  src: string;
  /** jumlah baris animasi di sheet (3 = idle/attack/run, 1 = idle saja) */
  rows?: number;
  /** baris aktif: 0 = idle, 1 = attack, 2 = run */
  row?: number;
  /** rasio bingkai, mis. "480/426" */
  frameAspect?: string;
  /** lebar tampil (px) */
  size?: number;
  /** cerminkan horizontal (hadap kiri) */
  flip?: boolean;
  /** mainkan sekali saja (untuk attack) */
  playOnce?: boolean;
  /** durasi satu putaran (detik) */
  speed?: number;
};

/**
 * Animator sprite sheet pixel-art via CSS steps().
 * Sheet: `cols` bingkai per baris (selalu 4), `rows` baris.
 */
export function Sprite({
  src,
  rows = 3,
  row = 0,
  frameAspect = "480/426",
  size = 96,
  flip = false,
  playOnce = false,
  speed = 0.9,
}: SpriteProps) {
  const y = rows > 1 ? `${(row / (rows - 1)) * 100}%` : "0%";
  const style = {
    "--sp-fw": `${size}px`,
    "--sp-dur": `${speed}s`,
    width: size,
    aspectRatio: frameAspect,
    backgroundImage: `url(${src})`,
    backgroundSize: `400% ${rows * 100}%`,
    backgroundPositionY: y,
    transform: flip ? "scaleX(-1)" : undefined,
    animationIterationCount: playOnce ? 1 : "infinite",
  } as CSSProperties;
  return <div className="sprite" style={style} aria-hidden />;
}
