import {
  ShaderFitOptions,
  ShaderMount,
  getShaderColorFromString,
  meshGradientFragmentShader
} from "./vendor/paper-shaders/index.js";

const element = document.querySelector("#paperShader");
const frequencyDepth = document.querySelector("#frequencyDepth");
const wandLayer = document.querySelector("#wandLayer");
const centerText = document.querySelector("#centerText");
const shaderState = document.querySelector("#shaderState");
let shaderSettings = {
  colors: ["#0B1E23", "#245C61", "#69B8AD", "#E8B9A5", "#FFF2DF"],
  speed: 0.14,
  distortion: 0.30,
  swirl: 0.34,
  grain: 0.055,
  scale: 1.08,
  rotation: -4,
  originX: 0.48,
  originY: 0.52,
  wandMode: false,
  soundMode: false,
  depthMode: false,
  displayText: "",
  displayFont: "rounded"
};

let mount;
let frame = 0;
let pointer = { x: 0, y: 0 };
let wand = {
  active: false,
  path: null,
  points: [],
  lastX: 0,
  lastY: 0,
  lastTime: 0,
  energy: 0
};
let audio = {
  context: null,
  master: null,
  lastToneTime: 0
};

function setupWandLayer() {
  if (!wandLayer) return;
  wandLayer.innerHTML = `
    <defs>
      <linearGradient id="wandGradient" x1="0%" x2="100%" y1="0%" y2="100%">
        <stop offset="0%" stop-color="#52f0c2"/>
        <stop offset="45%" stop-color="#2296ff"/>
        <stop offset="78%" stop-color="#f4c430"/>
        <stop offset="100%" stop-color="#ffffff"/>
      </linearGradient>
    </defs>
  `;
}

function buildFrequencyDepth() {
  if (!frequencyDepth) return;

  const fragment = document.createDocumentFragment();
  const core = document.createElement("span");
  core.className = "portal-core";
  fragment.appendChild(core);

  for (let index = 0; index < 8; index += 1) {
    const sheet = document.createElement("span");
    const depth = index + 1;
    const alpha = Math.max(0.06, 0.32 - index * 0.026);
    sheet.className = "depth-sheet";
    sheet.style.setProperty("--sheet-width", `${58 + index * 15}%`);
    sheet.style.setProperty("--sheet-height", `${30 + index * 9}%`);
    sheet.style.setProperty("--sheet-hue", 166 + (index % 5) * 16);
    sheet.style.setProperty("--sheet-alpha", `${alpha}`);
    sheet.style.setProperty("--sheet-shadow-alpha", `${alpha * 0.52}`);
    sheet.style.setProperty("--sheet-inner-alpha", `${alpha * 0.36}`);
    sheet.style.setProperty("--sheet-blur", `${5 + index * 1.6}px`);
    sheet.style.setProperty("--sheet-blur-far", `${3.6 + index * 1.15}px`);
    sheet.style.setProperty("--sheet-x", `${(index % 2 === 0 ? -1 : 1) * (2 + index * 1.6)}%`);
    sheet.style.setProperty("--sheet-y", `${-3 + index * 1.2}%`);
    sheet.style.setProperty("--sheet-x-far", `${(index % 2 === 0 ? -1 : 1) * (4.5 + index * 1.6)}%`);
    sheet.style.setProperty("--sheet-y-far", `${-5 + index * 1.2}%`);
    sheet.style.setProperty("--sheet-z", `${depth * -54}px`);
    sheet.style.setProperty("--sheet-rx", `${64 + index * 2}deg`);
    sheet.style.setProperty("--sheet-ry", `${-14 + index * 4}deg`);
    sheet.style.setProperty("--sheet-rz", `${-24 + index * 8}deg`);
    sheet.style.setProperty("--sheet-scale", `${0.88 + index * 0.035}`);
    sheet.style.setProperty("--sheet-rx-far", `${71 + index * 2}deg`);
    sheet.style.setProperty("--sheet-ry-far", `${-19 + index * 4}deg`);
    sheet.style.setProperty("--sheet-rz-far", `${-16 + index * 8}deg`);
    sheet.style.setProperty("--sheet-scale-far", `${(0.88 + index * 0.035) * 1.04}`);
    sheet.style.setProperty("--sheet-delay", `${index * -0.42}s`);
    sheet.style.setProperty("--sheet-duration", `${8.4 + index * 0.52}s`);
    fragment.appendChild(sheet);
  }

  for (let index = 0; index < 5; index += 1) {
    const horizon = document.createElement("span");
    const depth = index + 1;
    const alpha = 0.11 + depth * 0.028;
    horizon.className = "depth-horizon";
    horizon.style.setProperty("--horizon-top", `${38 + index * 8}%`);
    horizon.style.setProperty("--horizon-hue", 176 + index * 14);
    horizon.style.setProperty("--horizon-alpha", `${alpha}`);
    horizon.style.setProperty("--horizon-shadow-alpha", `${alpha * 0.68}`);
    horizon.style.setProperty("--horizon-z", `${depth * -32}px`);
    horizon.style.setProperty("--horizon-z-far", `${depth * -52}px`);
    horizon.style.setProperty("--horizon-scale", `${0.74 + depth * 0.12}`);
    horizon.style.setProperty("--horizon-scale-far", `${(0.74 + depth * 0.12) * 1.12}`);
    horizon.style.setProperty("--horizon-delay", `${index * -0.5}s`);
    horizon.style.setProperty("--horizon-duration", `${7.8 + index * 0.56}s`);
    fragment.appendChild(horizon);
  }

  frequencyDepth.replaceChildren(fragment);
}

function updateDepthVars() {
  const root = document.documentElement;
  root.style.setProperty("--flow-speed", shaderSettings.speed);
  root.style.setProperty("--depth-warp", shaderSettings.distortion);
  root.style.setProperty("--portal-energy", Math.max(0, Math.min(1, wand.energy * 0.72)));
  root.style.setProperty("--portal-size", `${12 + wand.energy * 13}%`);
  root.style.setProperty("--portal-blur", `${3 + wand.energy * 4}px`);
  root.style.setProperty("--portal-opacity", `${0.18 + wand.energy * 0.34}`);
  root.style.setProperty("--portal-glow", `${28 + wand.energy * 32}px`);
  root.style.setProperty("--portal-inner-glow", `${30 + wand.energy * 24}px`);
  root.style.setProperty("--horizon-duration", `${Math.max(4.2, 9 - shaderSettings.speed * 2.6)}s`);
  document.body.dataset.motion = shaderSettings.speed === 0 ? "paused" : "playing";
  document.body.dataset.wand = shaderSettings.wandMode ? "on" : "off";
  document.body.dataset.sound = shaderSettings.soundMode ? "on" : "off";
  document.body.dataset.depth = shaderSettings.depthMode ? "on" : "off";
  document.body.dataset.displayFont = shaderSettings.displayFont || "rounded";
  if (centerText) centerText.textContent = shaderSettings.displayText || "";
}

function makeDistortionCurve(amount = 0.3) {
  const samples = 256;
  const curve = new Float32Array(samples);
  const drive = amount * 90 + 8;
  for (let index = 0; index < samples; index += 1) {
    const x = (index * 2) / samples - 1;
    curve[index] = ((3 + drive) * x * 20 * Math.PI / 180) / (Math.PI + drive * Math.abs(x));
  }
  return curve;
}

function ensureAudio() {
  if (!shaderSettings.soundMode) return null;
  if (audio.context) {
    if (audio.context.state === "suspended") audio.context.resume();
    return audio.context;
  }

  const AudioContextCtor = window.AudioContext || window.webkitAudioContext;
  if (!AudioContextCtor) return null;

  const context = new AudioContextCtor();
  const master = context.createGain();
  master.gain.value = 0.18;
  master.connect(context.destination);
  audio.context = context;
  audio.master = master;
  return context;
}

function playWandTone(point, energy, speed) {
  const context = ensureAudio();
  if (!context || !audio.master) return;

  const now = context.currentTime;
  if (now - audio.lastToneTime < 0.045) return;
  audio.lastToneTime = now;

  const frequency = 96 + (1 - point.ny) * 620 + energy * 260;
  const oscillator = context.createOscillator();
  const gain = context.createGain();
  const filter = context.createBiquadFilter();
  const shaper = context.createWaveShaper();

  oscillator.type = energy > 0.68 ? "sawtooth" : "triangle";
  oscillator.frequency.setValueAtTime(frequency, now);
  oscillator.frequency.exponentialRampToValueAtTime(Math.max(70, frequency * (0.74 + speed * 0.08)), now + 0.18);
  filter.type = "bandpass";
  filter.frequency.value = 360 + point.nx * 1500 + energy * 900;
  filter.Q.value = 4.5 + energy * 11;
  shaper.curve = makeDistortionCurve(energy);
  shaper.oversample = "2x";
  gain.gain.setValueAtTime(0.0001, now);
  gain.gain.exponentialRampToValueAtTime(0.035 + energy * 0.11, now + 0.018);
  gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.22 + energy * 0.12);

  oscillator.connect(shaper);
  shaper.connect(filter);
  filter.connect(gain);
  gain.connect(audio.master);
  oscillator.start(now);
  oscillator.stop(now + 0.42);
}

function bootShader() {
  try {
    mount = new ShaderMount(
      element,
      meshGradientFragmentShader,
      {
        u_fit: ShaderFitOptions.cover,
        u_scale: 1.2,
        u_rotation: shaderSettings.rotation,
        u_offsetX: 0,
        u_offsetY: 0,
        u_originX: shaderSettings.originX,
        u_originY: shaderSettings.originY,
        u_worldWidth: 0,
        u_worldHeight: 0,
        u_colors: shaderSettings.colors.map(getShaderColorFromString),
        u_colorsCount: shaderSettings.colors.length,
        u_distortion: shaderSettings.distortion,
        u_swirl: shaderSettings.swirl,
        u_grainMixer: shaderSettings.grain,
        u_grainOverlay: Math.min(0.18, shaderSettings.grain * 0.45)
      },
      { alpha: true, antialias: true },
      shaderSettings.speed,
      Math.random() * 1200,
      1,
      1920 * 1080 * 2
    );
    element.classList.remove("is-fallback");
    element.classList.add("is-live");
    document.body.dataset.shader = "live";
    if (shaderState) shaderState.textContent = "";
  } catch (error) {
    console.error("Paper Shader failed", error);
    element.classList.add("is-fallback");
    document.body.dataset.shader = "fallback";
    if (shaderState) shaderState.textContent = "";
  }
}

window.paperShaderUpdate = function paperShaderUpdate(nextSettings) {
  shaderSettings = {
    ...shaderSettings,
    ...nextSettings
  };
  updateDepthVars();

  if (!mount) return;

  mount.setSpeed(shaderSettings.speed);
  mount.setUniforms({
    u_scale: shaderSettings.scale,
    u_rotation: shaderSettings.rotation,
    u_originX: shaderSettings.originX,
    u_originY: shaderSettings.originY,
    u_colors: shaderSettings.colors.map(getShaderColorFromString),
    u_colorsCount: shaderSettings.colors.length,
    u_distortion: shaderSettings.distortion,
    u_swirl: shaderSettings.swirl,
    u_grainMixer: shaderSettings.grain,
    u_grainOverlay: Math.min(0.18, shaderSettings.grain * 0.45)
  });
};

function updatePointer(event) {
  const rect = element.getBoundingClientRect();
  pointer = {
    x: Math.max(-0.5, Math.min(0.5, (event.clientX - rect.left) / rect.width - 0.5)),
    y: Math.max(-0.5, Math.min(0.5, (event.clientY - rect.top) / rect.height - 0.5))
  };

  if (frame) return;
  frame = requestAnimationFrame(() => {
    frame = 0;
    if (!mount) return;
    mount.setUniforms({
      u_offsetX: pointer.x * 0.18,
      u_offsetY: pointer.y * 0.12,
      u_originX: shaderSettings.originX + pointer.x * 0.12,
      u_originY: shaderSettings.originY + pointer.y * 0.10
    });
  });
}

function svgPoint(event) {
  const rect = wandLayer.getBoundingClientRect();
  return {
    x: ((event.clientX - rect.left) / rect.width) * 1000,
    y: ((event.clientY - rect.top) / rect.height) * 600,
    nx: Math.max(0, Math.min(1, (event.clientX - rect.left) / rect.width)),
    ny: Math.max(0, Math.min(1, (event.clientY - rect.top) / rect.height))
  };
}

function pathData(points) {
  if (points.length < 2) return "";
  const [first, ...rest] = points;
  return rest.reduce((path, point, index) => {
    const previous = points[index];
    const cx = (previous.x + point.x) / 2;
    const cy = (previous.y + point.y) / 2;
    return `${path} Q ${previous.x.toFixed(1)} ${previous.y.toFixed(1)} ${cx.toFixed(1)} ${cy.toFixed(1)}`;
  }, `M ${first.x.toFixed(1)} ${first.y.toFixed(1)}`);
}

function createSpark(point, energy) {
  if (!wandLayer) return;
  const spark = document.createElementNS("http://www.w3.org/2000/svg", "circle");
  spark.setAttribute("class", "wand-spark");
  spark.setAttribute("cx", point.x.toFixed(1));
  spark.setAttribute("cy", point.y.toFixed(1));
  spark.setAttribute("r", (3.5 + Math.min(8, energy * 12)).toFixed(1));
  wandLayer.appendChild(spark);
  window.setTimeout(() => spark.remove(), 1300);
}

function createStrokeEchoes(points, energy) {
  if (!wandLayer || points.length < 3) return;
  const data = pathData(points);
  for (let index = 1; index <= 3; index += 1) {
    const echo = document.createElementNS("http://www.w3.org/2000/svg", "path");
    echo.setAttribute("class", "wand-echo");
    echo.setAttribute("d", data);
    echo.style.setProperty("--echo-scale", `${1 - index * 0.045}`);
    echo.style.setProperty("--echo-x", `${index * -9}px`);
    echo.style.setProperty("--echo-y", `${index * 12}px`);
    echo.style.setProperty("--echo-scale-far", `${(1 - index * 0.045) * 0.9}`);
    echo.style.setProperty("--echo-x-far", `${index * -11.25}px`);
    echo.style.setProperty("--echo-y-far", `${index * 15}px`);
    echo.style.setProperty("--echo-width", `${Math.max(1.5, 7 - index * 0.72)}px`);
    echo.style.setProperty("--echo-opacity", `${Math.max(0.08, 0.34 - index * 0.06 + energy * 0.10)}`);
    echo.style.setProperty("--echo-blur", `${index * 1.1}px`);
    wandLayer.insertBefore(echo, wandLayer.firstChild?.nextSibling ?? null);
    window.setTimeout(() => echo.remove(), 7000);
  }
}

function reactToWand(point, speed, strokeLength) {
  if (!mount) return;

  const energy = Math.max(0, Math.min(1, speed * 0.16 + strokeLength * 0.00075));
  wand.energy = Math.max(wand.energy * 0.84, energy);
  const root = document.documentElement;
  root.style.setProperty("--focus-x", `${point.nx * 100}%`);
  root.style.setProperty("--focus-y", `${point.ny * 100}%`);
  root.style.setProperty("--portal-energy", energy);
  root.style.setProperty("--portal-size", `${12 + energy * 18}%`);
  root.style.setProperty("--portal-blur", `${3 + energy * 6}px`);
  root.style.setProperty("--portal-opacity", `${0.18 + energy * 0.52}`);
  root.style.setProperty("--portal-glow", `${28 + energy * 42}px`);
  root.style.setProperty("--portal-inner-glow", `${30 + energy * 32}px`);
  mount.setUniforms({
    u_offsetX: (point.nx - 0.5) * (0.18 + energy * 0.34),
    u_offsetY: (point.ny - 0.5) * (0.12 + energy * 0.28),
    u_originX: point.nx,
    u_originY: point.ny,
    u_distortion: Math.min(1, shaderSettings.distortion + energy * 0.28),
    u_swirl: Math.min(1, shaderSettings.swirl + energy * 0.32),
    u_grainMixer: Math.min(0.75, shaderSettings.grain + energy * 0.20),
    u_grainOverlay: Math.min(0.26, shaderSettings.grain * 0.45 + energy * 0.12)
  });

  root.style.setProperty("--depth-warp", Math.min(1, shaderSettings.distortion + energy * 0.28));
  playWandTone(point, energy, speed);
  if (energy > 0.58) createSpark(point, energy);
}

function startWand(event) {
  if (!shaderSettings.wandMode || !wandLayer) return;
  ensureAudio();
  const point = svgPoint(event);
  const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
  path.setAttribute("class", "wand-stroke");
  wandLayer.appendChild(path);
  wand = {
    active: true,
    path,
    points: [point],
    lastX: point.x,
    lastY: point.y,
    lastTime: performance.now(),
    energy: 0
  };
  path.setAttribute("d", `M ${point.x.toFixed(1)} ${point.y.toFixed(1)}`);
  createSpark(point, 0.5);
  reactToWand(point, 1.2, 0);
}

function moveWand(event) {
  if (!wand.active || !shaderSettings.wandMode || !wand.path) return;
  const point = svgPoint(event);
  const now = performance.now();
  const dx = point.x - wand.lastX;
  const dy = point.y - wand.lastY;
  const distance = Math.hypot(dx, dy);
  const dt = Math.max(16, now - wand.lastTime);

  if (distance < 2.5) return;

  wand.points.push(point);
  if (wand.points.length > 80) wand.points.shift();
  wand.path.setAttribute("d", pathData(wand.points));
  wand.lastX = point.x;
  wand.lastY = point.y;
  wand.lastTime = now;
  reactToWand(point, distance / dt, wand.points.length * distance);
}

function endWand() {
  if (!wand.active) return;
  const finishedPath = wand.path;
  createStrokeEchoes(wand.points, wand.energy);
  window.setTimeout(() => finishedPath?.remove(), 5000);
  wand.active = false;
  wand.path = null;
}

window.addEventListener("pointermove", updatePointer, { passive: true });
window.addEventListener("pointerdown", updatePointer, { passive: true });
window.addEventListener("pointerdown", startWand, { passive: true });
window.addEventListener("pointermove", moveWand, { passive: true });
window.addEventListener("pointerup", endWand, { passive: true });
window.addEventListener("pointercancel", endWand, { passive: true });
document.addEventListener("visibilitychange", () => {
  if (!mount) return;
  mount.setSpeed(document.hidden ? 0 : shaderSettings.speed);
});

setupWandLayer();
buildFrequencyDepth();
updateDepthVars();
bootShader();
