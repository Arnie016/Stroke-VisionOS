#!/usr/bin/env node

import { createHash } from "node:crypto";
import http from "node:http";

const MODEL = "gpt-realtime-2.1";
const VOICE = "marin";
const SAMPLE_RATE = 24_000;
const MAX_TEXT_LENGTH = 800;
const HOST = process.env.RBC_REALTIME_PROXY_HOST ?? "127.0.0.1";
const PORT = Number.parseInt(process.env.RBC_REALTIME_PROXY_PORT ?? "8792", 10);

function json(response, status, body) {
  const payload = Buffer.from(JSON.stringify(body));
  response.writeHead(status, {
    "Content-Type": "application/json",
    "Content-Length": payload.length,
    "Cache-Control": "no-store",
  });
  response.end(payload);
}

function readJSON(request) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    let length = 0;
    request.on("data", (chunk) => {
      length += chunk.length;
      if (length > 16_384) {
        reject(new Error("request_too_large"));
        request.destroy();
        return;
      }
      chunks.push(chunk);
    });
    request.on("end", () => {
      try {
        resolve(JSON.parse(Buffer.concat(chunks).toString("utf8")));
      } catch {
        reject(new Error("invalid_json"));
      }
    });
    request.on("error", reject);
  });
}

function pcm16MonoToWAV(pcm) {
  const header = Buffer.alloc(44);
  const byteRate = SAMPLE_RATE * 2;
  header.write("RIFF", 0);
  header.writeUInt32LE(36 + pcm.length, 4);
  header.write("WAVE", 8);
  header.write("fmt ", 12);
  header.writeUInt32LE(16, 16);
  header.writeUInt16LE(1, 20);
  header.writeUInt16LE(1, 22);
  header.writeUInt32LE(SAMPLE_RATE, 24);
  header.writeUInt32LE(byteRate, 28);
  header.writeUInt16LE(2, 32);
  header.writeUInt16LE(16, 34);
  header.write("data", 36);
  header.writeUInt32LE(pcm.length, 40);
  return Buffer.concat([header, pcm]);
}

function sha256(text) {
  return createHash("sha256").update(text, "utf8").digest("hex");
}

function canonicalNarration(text) {
  return text
    .normalize("NFKD")
    .replace(/\p{M}/gu, "")
    .toLocaleLowerCase("en-US")
    .replace(/[^\p{L}\p{N}]+/gu, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function canonicalNarrationSHA256(text) {
  return sha256(canonicalNarration(text));
}

async function createClientSecret(apiKey) {
  const response = await fetch("https://api.openai.com/v1/realtime/client_secrets", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "OpenAI-Safety-Identifier": "rbc-journey-reviewed-family-caption",
    },
    body: JSON.stringify({
      session: {
        type: "realtime",
        model: MODEL,
        output_modalities: ["audio"],
        audio: {
          output: {
            format: { type: "audio/pcm", rate: SAMPLE_RATE },
            voice: VOICE,
            speed: 0.90,
          },
        },
        instructions:
          "Read only the user's exact caption. Do not add, remove, explain, diagnose, advise, or paraphrase. " +
          "Use a calm, warm museum-guide cadence for a patient or family audience. Avoid urgency and drama.",
        max_output_tokens: 256,
      },
    }),
  });

  if (!response.ok) throw new Error(`client_secret_http_${response.status}`);
  const body = await response.json();
  if (typeof body.value !== "string" || body.value.length === 0) {
    throw new Error("client_secret_missing");
  }
  return body.value;
}

async function generateNarration(text) {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) throw new Error("openai_key_unavailable");

  const ephemeralKey = await createClientSecret(apiKey);
  const url = `wss://api.openai.com/v1/realtime?model=${encodeURIComponent(MODEL)}`;
  const socket = new WebSocket(url, [
    "realtime",
    `openai-insecure-api-key.${ephemeralKey}`,
  ]);

  return await new Promise((resolve, reject) => {
    const pcmChunks = [];
    const transcriptChunks = [];
    let settled = false;
    const timeout = setTimeout(() => finish(new Error("realtime_timeout")), 30_000);

    function finish(error, value) {
      if (settled) return;
      settled = true;
      clearTimeout(timeout);
      try { socket.close(); } catch {}
      if (error) reject(error);
      else resolve(value);
    }

    socket.addEventListener("message", (message) => {
      let event;
      try {
        event = JSON.parse(String(message.data));
      } catch {
        return;
      }

      if (event.type === "session.created") {
        socket.send(JSON.stringify({
          type: "conversation.item.create",
          item: {
            type: "message",
            role: "user",
            content: [{ type: "input_text", text }],
          },
        }));
        socket.send(JSON.stringify({
          type: "response.create",
          response: { output_modalities: ["audio"] },
        }));
      } else if (event.type === "response.output_audio.delta") {
        pcmChunks.push(Buffer.from(event.delta, "base64"));
      } else if (event.type === "response.output_audio_transcript.delta") {
        transcriptChunks.push(event.delta ?? "");
      } else if (event.type === "response.output_audio_transcript.done" && typeof event.transcript === "string") {
        transcriptChunks.length = 0;
        transcriptChunks.push(event.transcript);
      } else if (event.type === "response.done") {
        if (event.response?.status !== "completed") {
          finish(new Error(`realtime_${event.response?.status ?? "incomplete"}`));
        } else if (pcmChunks.length === 0) {
          finish(new Error("realtime_audio_empty"));
        } else if (canonicalNarrationSHA256(transcriptChunks.join("")) !== canonicalNarrationSHA256(text)) {
          finish(new Error("realtime_transcript_mismatch"));
        } else {
          finish(null, {
            wav: pcm16MonoToWAV(Buffer.concat(pcmChunks)),
            transcriptSHA256: canonicalNarrationSHA256(text),
          });
        }
      } else if (event.type === "error") {
        finish(new Error(`realtime_${event.error?.code ?? "error"}`));
      }
    });
    socket.addEventListener("error", () => finish(new Error("realtime_socket_error")));
  });
}

const server = http.createServer(async (request, response) => {
  if (request.method === "GET" && request.url === "/health") {
    json(response, 200, {
      status: "ready",
      model: MODEL,
      voice: VOICE,
      keyAvailable: Boolean(process.env.OPENAI_API_KEY),
    });
    return;
  }

  if (request.method !== "POST" || request.url !== "/narrate") {
    json(response, 404, { error: "not_found" });
    return;
  }

  try {
    const body = await readJSON(request);
    if (body.model !== MODEL) {
      json(response, 422, { error: "model_must_be_gpt-realtime-2.1" });
      return;
    }
    if (typeof body.text !== "string" || body.text.trim().length === 0) {
      json(response, 422, { error: "text_required" });
      return;
    }
    const text = body.text.trim();
    if (text.length > MAX_TEXT_LENGTH) {
      json(response, 413, { error: "caption_too_long" });
      return;
    }

    const narration = await generateNarration(text);
    response.writeHead(200, {
      "Content-Type": "audio/wav",
      "Content-Length": narration.wav.length,
      "Cache-Control": "no-store",
      "X-RBC-Narration-Model": MODEL,
      "X-RBC-Narration-Copy-SHA256": sha256(text),
      "X-RBC-Narration-Transcript-SHA256": narration.transcriptSHA256,
    });
    response.end(narration.wav);
    console.log(`RBC_REALTIME_REQUEST=OK model=${MODEL} audioBytes=${narration.wav.length} transcriptGate=PASS`);
  } catch (error) {
    const reason = error instanceof Error ? error.message : "unknown_error";
    const status = reason === "openai_key_unavailable" ? 503 : 502;
    json(response, status, { error: reason });
  }
});

if (process.argv.includes("--integrity-self-test")) {
  const reviewed = "A crossroads at the brain's base. Follow the moving fronts.";
  const punctuationVariant = "A CROSSROADS at the brain’s base — follow the moving fronts!";
  const changedClaim = "A crossroads at the brain's base. Blood can always reroute safely.";
  if (canonicalNarrationSHA256(reviewed) !== canonicalNarrationSHA256(punctuationVariant)) {
    throw new Error("canonical_punctuation_case_failed");
  }
  if (canonicalNarrationSHA256(reviewed) === canonicalNarrationSHA256(changedClaim)) {
    throw new Error("canonical_changed_claim_failed");
  }
  console.log("RBC_NARRATION_INTEGRITY_SELF_TEST=PASS cases=2");
} else {
  server.listen(PORT, HOST, () => {
    console.log(`RBC_REALTIME_PROXY=READY url=http://${HOST}:${PORT}/narrate model=${MODEL} voice=${VOICE}`);
  });
}
