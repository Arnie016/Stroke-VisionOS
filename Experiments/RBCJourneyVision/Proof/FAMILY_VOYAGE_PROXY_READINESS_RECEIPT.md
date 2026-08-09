# Family voyage — GPT Realtime proxy readiness receipt

Date: 2026-08-10 (Asia/Singapore)

Status: **READY — local secure transport metadata only. NOT RUN — narration
generation, paid inference, returned audio, latency, interruption, cadence,
XCAT playback, wearer comprehension, and medical review.**

## Bounded check

- `OPENAI_API_KEY` is available through the macOS Keychain `apikey` helper. Its
  value was not printed, copied to source, or written to a repository file.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: PASS.
- `zsh -n Scripts/run_rbc_realtime_proxy.zsh`: PASS.
- The launcher started a loopback-only server at `127.0.0.1:8792`.
- `GET /health` returned `status=ready`, model `gpt-realtime-2.1`, voice `marin`,
  and `keyAvailable=true`.
- The server was stopped immediately after the health check.

No `POST /narrate` request was sent. This receipt proves that the optional
family guide can reach its local secure boundary; it does not prove that OpenAI
generated or played any audio and consumed no inference credits in this check.

## Intended family mode

The voice remains opt-in, caption-first, and separate from clinician defaults.
It reads only the visible, versioned orientation → passage → arrival copy while
the wearer follows the arterial path. Navigation, route choice, Pause, End
guide, Leave, and Exit remain local user actions; the voice model receives no
authority over the scene.
