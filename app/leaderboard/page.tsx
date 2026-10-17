import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { levelOf, rankOf } from "@/lib/game";
import { Reveal } from "@/components/Reveal";
import { Avatar } from "@/components/Avatar";

type Row = {
  id: string;
  username: string;
  avatar: string;
  xp: number;
  plays: number;
  wins: number;
};

export default async function LeaderboardPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data } = await supabase
    .from("profiles")
    .select("id, username, avatar, xp, plays, wins")
    .order("xp", { ascending: false })
    .limit(100);
  const rows = (data ?? []) as Row[];

  // Weekly XP derived from attempts in the last 7 days.
  const { data: weekly } = await supabase
    .from("weekly_xp")
    .select("user_id, xp_week");
  const weekMap = new Map(
    (weekly ?? []).map((w) => [w.user_id as string, w.xp_week as number]),
  );

  return (
    <div className="lbwrap">
      <h1 className="logo" style={{ fontSize: 26 }}>
        🏆 LEADERBOARD
      </h1>
      <p className="tagline">
        Peringkat total XP tongkrongan. XP tidak pernah direset — yang rajin
        main, yang di atas.
      </p>
      {rows.length === 0 ? (
        <div className="empty">
          <div className="big">🌀</div>
          Belum ada pemain. Jadilah yang pertama{" "}
          <Link href="/register" style={{ color: "var(--cyan)" }}>
            daftar
          </Link>{" "}
          dan naik level!
        </div>
      ) : (
        <Reveal>
        <table className="lb">
          <thead>
            <tr>
              <th>#</th>
              <th>Pemain</th>
              <th>Level</th>
              <th>XP Minggu Ini</th>
              <th>Total XP</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.id} className={user && r.id === user.id ? "me" : ""}>
                <td className="rk">{i + 1}</td>
                <td>
                  <span
                    style={{ display: "inline-flex", alignItems: "center", gap: 8 }}
                  >
                    <Avatar value={r.avatar} size={30} />
                    <b>{r.username}</b>
                  </span>
                  <br />
                  <small style={{ color: "var(--dim)" }}>
                    {rankOf(r.xp)} · {r.wins}/{r.plays} menang
                  </small>
                </td>
                <td>LV {levelOf(r.xp)}</td>
                <td>{weekMap.get(r.id) ?? 0}</td>
                <td>
                  <b style={{ color: "var(--gold)" }}>{r.xp}</b>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        </Reveal>
      )}
      <p className="lbnote">
        Kolom minggu ini dihitung dari XP yang didapat 7 hari terakhir —
        peringkat utama tetap total XP selamanya.
      </p>
    </div>
  );
}
