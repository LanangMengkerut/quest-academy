"use client";

import { useState } from "react";
import { createPortal } from "react-dom";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Sprite, CHAR_SPRITES, CHAR_NAMES } from "./Sprite";

const ORDER = ["wizard", "knight", "elf"];

export function AvatarPicker({
  current,
  onClose,
}: {
  current: string;
  onClose: () => void;
}) {
  const router = useRouter();
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState("");

  const pick = async (key: string) => {
    if (key === current || busy) {
      onClose();
      return;
    }
    setBusy(true);
    setErr("");
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      router.push("/login");
      return;
    }
    const { error } = await supabase
      .from("profiles")
      .update({ avatar: key })
      .eq("id", user.id);
    if (error) {
      setErr(error.message);
      setBusy(false);
      return;
    }
    router.refresh();
    onClose();
  };

  return createPortal(
    <div className="modalback" onClick={onClose}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <h2>⚔️ PILIH KARAKTERMU</h2>
        <div className="charpick">
          {ORDER.map((key) => (
            <button
              key={key}
              className={`charopt${current === key ? " active" : ""}`}
              onClick={() => pick(key)}
              disabled={busy}
            >
              <Sprite
                src={CHAR_SPRITES[key]}
                rows={3}
                row={0}
                frameAspect="480/426"
                size={72}
              />
              <span>{CHAR_NAMES[key]}</span>
            </button>
          ))}
        </div>
        {err && <p className="err">⚠️ {err}</p>}
        <button className="btn ghost" onClick={onClose}>
          Tutup
        </button>
      </div>
    </div>,
    document.body
  );
}
