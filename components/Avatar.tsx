import { Sprite, CHAR_SPRITES } from "./Sprite";

/**
 * Avatar pemain: sprite karakter bila nilainya key yang dikenal
 * (elf/knight/wizard), fallback ke teks emoji untuk nilai lama.
 */
export function Avatar({ value, size = 40 }: { value: string; size?: number }) {
  const src = CHAR_SPRITES[value];
  if (src) {
    return (
      <Sprite src={src} rows={3} row={0} frameAspect="480/426" size={size} />
    );
  }
  return (
    <span style={{ fontSize: Math.round(size * 0.72), lineHeight: 1 }}>
      {value || "🧙"}
    </span>
  );
}
