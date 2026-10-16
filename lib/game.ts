export const RANKS = [
  "Newbie",
  "Pelajar",
  "Pejuang",
  "Ksatria",
  "Master",
  "Legenda",
  "Mitos",
] as const;

export const xpForLevel = (n: number) => (100 * n * (n - 1)) / 2;

export function levelOf(xp: number): number {
  let n = 1;
  while (xp >= xpForLevel(n + 1)) n++;
  return n;
}

export function rankOf(xp: number): string {
  const lvl = levelOf(xp);
  return RANKS[Math.min(lvl - 1, RANKS.length - 1)];
}

export function starsForScore(score: number): number {
  if (score >= 100) return 3;
  if (score >= 80) return 2;
  if (score >= 60) return 1;
  return 0;
}

export const BADGES = [
  { id: "first_blood", icon: "🩸", name: "First Blood", desc: "Menangkan 1 battle" },
  { id: "scholar", icon: "📖", name: "Kutu Buku", desc: "Baca 3 materi" },
  { id: "perfect", icon: "💯", name: "Perfect Clear", desc: "Nilai 100 di battle" },
  { id: "warrior", icon: "⚔️", name: "Petarung", desc: "Menangkan 5 battle" },
  { id: "streak3", icon: "🔥", name: "On Fire", desc: "Streak 3 jawaban benar" },
  { id: "marathon", icon: "🏁", name: "Maraton", desc: "Mainkan 10 battle" },
] as const;

/** Domain for synthetic login emails. Never shown to users. */
export const USERNAME_EMAIL_DOMAIN = "users.quest-academy.local";

export function usernameToEmail(username: string): string {
  return `${username.trim().toLowerCase()}@${USERNAME_EMAIL_DOMAIN}`;
}

export function normalizeUsername(raw: string): string {
  return raw.trim().toLowerCase();
}

export function isValidUsername(username: string): boolean {
  return /^[a-z0-9_]{3,20}$/.test(username);
}
