"use client";

/**
 * Procedural "dungeon ambience" background music, generated with WebAudio.
 * No audio files: a low detuned drone through a slowly sweeping lowpass,
 * a soft wind noise loop, and sparse echoing plucks in A minor pentatonic.
 * Singleton engine; the MusicEngine component owns start/stop based on the
 * user's stored preference. Browsers require a user gesture before audio
 * may start, so start() is only effective after interaction.
 */

type Engine = {
  ctx: AudioContext;
  master: GainNode;
  nodes: OscillatorNode[];
  drone: OscillatorNode[];
  bp: BiquadFilterNode;
  timer: number | null;
};

let engine: Engine | null = null;
let starting = false;

/**
 * Music moods per world (course id). Each world gets its own root,
 * scale, echo and pluck cadence so browsing the world picker audibly
 * changes the atmosphere. "default" is the original dungeon mood.
 */
type Mood = {
  drone: [number, number, number];
  plucks: number[];
  bells: [number, number, number];
  delay: number;
  gapMin: number;
  gapMax: number;
  bp: number;
};

const MOODS: Record<string, Mood> = {
  default: {
    drone: [55, 65.41, 82.41], // A1 C2 E2
    plucks: [220, 261.63, 293.66, 329.63, 392, 440], // A C D E G A
    bells: [110, 130.81, 164.81],
    delay: 0.34,
    gapMin: 2600,
    gapMax: 7800,
    bp: 480,
  },
  jarkom: {
    // cyan — network dungeon: same A root, tighter echo, busier plucks
    drone: [55, 65.41, 82.41],
    plucks: [220, 261.63, 293.66, 329.63, 392, 440, 523.25],
    bells: [110, 130.81, 164.81],
    delay: 0.27,
    gapMin: 2000,
    gapMax: 5600,
    bp: 540,
  },
  ib: {
    // magenta — mysterious AI: D minor, sparse, long echo
    drone: [73.42, 87.31, 110], // D2 F2 A2
    plucks: [293.66, 349.23, 392, 440, 523.25, 587.33], // D F G A C D
    bells: [146.83, 174.61, 220],
    delay: 0.46,
    gapMin: 3400,
    gapMax: 9000,
    bp: 380,
  },
  pemweb: {
    // orange — bright code world: G major, lively cadence
    drone: [98, 123.47, 146.83], // G2 B2 D3
    plucks: [392, 440, 493.88, 587.33, 659.25, 783.99], // G A B D E G
    bells: [196, 246.94, 293.66],
    delay: 0.23,
    gapMin: 1700,
    gapMax: 4600,
    bp: 620,
  },
};

let currentMoodId = "default";
const mood = (): Mood => MOODS[currentMoodId] ?? MOODS.default;

/** Switch the music mood (world picker calls this per focused world). */
export function setMusicMood(id: string) {
  currentMoodId = MOODS[id] ? id : "default";
  if (!engine) return;
  const m = mood();
  const t = engine.ctx.currentTime;
  engine.drone.forEach((o, i) => {
    try {
      o.frequency.cancelScheduledValues(t);
      o.frequency.setValueAtTime(o.frequency.value, t);
      o.frequency.linearRampToValueAtTime(m.drone[i], t + 1.4);
    } catch {
      /* ignore */
    }
  });
  try {
    engine.bp.frequency.cancelScheduledValues(t);
    engine.bp.frequency.setValueAtTime(engine.bp.frequency.value, t);
    engine.bp.frequency.linearRampToValueAtTime(m.bp, t + 1.4);
  } catch {
    /* ignore */
  }
}

export function getMusicMood() {
  return currentMoodId;
}

function schedulePluck(ctx: AudioContext, master: GainNode) {
  if (!engine) return;
  const m = mood();
  const now = ctx.currentTime;
  const isBell = Math.random() < 0.22;
  const freq = isBell
    ? m.bells[Math.floor(Math.random() * m.bells.length)]
    : m.plucks[Math.floor(Math.random() * m.plucks.length)];

  const osc = ctx.createOscillator();
  osc.type = isBell ? "sine" : "triangle";
  osc.frequency.value = freq;

  const gain = ctx.createGain();
  const peak = isBell ? 0.16 : 0.1;
  const decay = isBell ? 2.4 : 1.4;
  gain.gain.setValueAtTime(0, now);
  gain.gain.linearRampToValueAtTime(peak, now + 0.02);
  gain.gain.exponentialRampToValueAtTime(0.0001, now + decay);

  // simple dungeon echo: feedback delay, shared per note to keep it cheap
  const delay = ctx.createDelay(1);
  delay.delayTime.value = m.delay;
  const feedback = ctx.createGain();
  feedback.gain.value = 0.32;
  const wet = ctx.createGain();
  wet.gain.value = 0.25;
  osc.connect(gain);
  gain.connect(master);
  gain.connect(delay);
  delay.connect(feedback);
  feedback.connect(delay);
  delay.connect(wet);
  wet.connect(master);

  osc.start(now);
  osc.stop(now + decay + 0.1);

  engine.timer = window.setTimeout(
    () => schedulePluck(ctx, master),
    m.gapMin + Math.random() * (m.gapMax - m.gapMin),
  );
}

export function startDungeonMusic() {
  if (engine || starting || typeof window === "undefined") return;
  starting = true;
  try {
    const ctx = new (window.AudioContext ||
      (window as unknown as { webkitAudioContext: typeof AudioContext })
        .webkitAudioContext)();
    const master = ctx.createGain();
    master.gain.value = 0;
    master.gain.linearRampToValueAtTime(0.55, ctx.currentTime + 2.5);
    master.connect(ctx.destination);

    const nodes: OscillatorNode[] = [];
    const m = mood();

    // low drone triad (per current mood) through a sweeping lowpass filter
    const filter = ctx.createBiquadFilter();
    filter.type = "lowpass";
    filter.frequency.value = 260;
    filter.Q.value = 2;
    const droneGain = ctx.createGain();
    droneGain.gain.value = 0.055;
    filter.connect(droneGain);
    droneGain.connect(master);
    const drone: OscillatorNode[] = [];
    m.drone.forEach((f, i) => {
      const o = ctx.createOscillator();
      o.type = i === 0 ? "sine" : "triangle";
      o.frequency.value = f;
      o.detune.value = i * 4 - 4;
      o.connect(filter);
      o.start();
      nodes.push(o);
      drone.push(o);
    });
    const lfo = ctx.createOscillator();
    lfo.frequency.value = 0.05;
    const lfoGain = ctx.createGain();
    lfoGain.gain.value = 110;
    lfo.connect(lfoGain);
    lfoGain.connect(filter.frequency);
    lfo.start();
    nodes.push(lfo);

    // wind: looped noise through a bandpass with slow gain breathing
    const noiseLen = 2 * ctx.sampleRate;
    const noiseBuf = ctx.createBuffer(1, noiseLen, ctx.sampleRate);
    const data = noiseBuf.getChannelData(0);
    for (let i = 0; i < noiseLen; i++) data[i] = Math.random() * 2 - 1;
    const noise = ctx.createBufferSource();
    noise.buffer = noiseBuf;
    noise.loop = true;
    const bp = ctx.createBiquadFilter();
    bp.type = "bandpass";
    bp.frequency.value = m.bp;
    bp.Q.value = 0.6;
    const windGain = ctx.createGain();
    windGain.gain.value = 0.012;
    noise.connect(bp);
    bp.connect(windGain);
    windGain.connect(master);
    noise.start();
    const windLfo = ctx.createOscillator();
    windLfo.frequency.value = 0.07;
    const windLfoGain = ctx.createGain();
    windLfoGain.gain.value = 0.008;
    windLfo.connect(windLfoGain);
    windLfoGain.connect(windGain.gain);
    windLfo.start();
    nodes.push(windLfo);

    engine = { ctx, master, nodes, drone, bp, timer: null };
    engine.timer = window.setTimeout(() => schedulePluck(ctx, master), 1200);
  } catch {
    /* audio unsupported */
  } finally {
    starting = false;
  }
}

export function stopDungeonMusic() {
  if (!engine) return;
  const { ctx, master, nodes, timer } = engine;
  engine = null;
  if (timer !== null) window.clearTimeout(timer);
  try {
    master.gain.cancelScheduledValues(ctx.currentTime);
    master.gain.setValueAtTime(master.gain.value, ctx.currentTime);
    master.gain.linearRampToValueAtTime(0, ctx.currentTime + 0.6);
    window.setTimeout(() => {
      nodes.forEach((n) => {
        try {
          n.stop();
        } catch {
          /* already stopped */
        }
      });
      void ctx.close();
    }, 700);
  } catch {
    /* ignore */
  }
}

export function isDungeonMusicPlaying() {
  return engine !== null;
}
