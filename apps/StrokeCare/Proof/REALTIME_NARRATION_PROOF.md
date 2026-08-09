# GPT-Realtime-2.1 narration proof

## 2026-08-09 12:03 SGT

- Target: remove macOS system speech and prove the remaining narration path can
  return app-playable audio from `gpt-realtime-2.1`.
- Key boundary: the permanent `OPENAI_API_KEY` was loaded into the loopback
  proxy process through `apikey`; it was not written to the app, repository,
  request body, proof output, or console.
- Request: one generic teaching caption with no patient data — “Blood flow
  slows at this example blockage.”
- Response: HTTP `200`, `Content-Type: audio/wav`,
  `X-Stroke-Narration-Model: gpt-realtime-2.1`.
- Audio inspection: RIFF/WAVE, PCM Int16, mono, 24,000 Hz, 147,080 bytes,
  estimated duration 3.063250 seconds.
- SHA-256: `870eb70237acb28b0519087f451c78b08f6391221ce02f19e7f90a6933345d18`.
- Voice: `marin`, locked inside the Realtime session. No macOS voice or speech
  synthesizer exists in this path.

This machine receipt proves API transport and audio-file generation only. It
does not prove Simulator or XCAT playback, spatial placement, audible quality,
wearer comfort, comprehension, accessibility, or clinical validity.

