"use client";

let AC: AudioContext | null = null;

function beep(
  freq: number,
  dur = 0.08,
  type: OscillatorType = "square",
  vol = 0.05,
  when = 0,
  muted = false,
) {
  if (muted) return;
  try {
    AC =
      AC ||
      new (window.AudioContext ||
        (window as unknown as { webkitAudioContext: typeof AudioContext })
          .webkitAudioContext)();
    const o = AC.createOscillator();
    const g = AC.createGain();
    o.type = type;
    o.frequency.value = freq;
    g.gain.value = vol;
    o.connect(g);
    g.connect(AC.destination);
    const s = AC.currentTime + when;
    o.start(s);
    g.gain.exponentialRampToValueAtTime(0.0001, s + dur);
    o.stop(s + dur + 0.02);
  } catch {
    /* audio unsupported */
  }
}

export const sfx = {
  click: (muted: boolean) => beep(600, 0.06, "square", 0.05, 0, muted),
  correct: (muted: boolean) => {
    beep(523, 0.09, "square", 0.05, 0, muted);
    beep(784, 0.12, "square", 0.05, 0.09, muted);
  },
  wrong: (muted: boolean) => beep(180, 0.22, "sawtooth", 0.06, 0, muted),
  win: (muted: boolean) =>
    [523, 659, 784, 1046].forEach((f, i) =>
      beep(f, 0.14, "square", 0.05, i * 0.12, muted),
    ),
  lose: (muted: boolean) =>
    [400, 300, 200].forEach((f, i) =>
      beep(f, 0.16, "sawtooth", 0.05, i * 0.14, muted),
    ),
  badge: (muted: boolean) => {
    beep(880, 0.1, "square", 0.05, 0, muted);
    beep(1174, 0.16, "square", 0.05, 0.1, muted);
  },
};
