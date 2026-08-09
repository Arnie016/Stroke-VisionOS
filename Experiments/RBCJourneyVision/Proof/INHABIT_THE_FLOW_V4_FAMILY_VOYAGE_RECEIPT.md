# Inhabit the Flow V4 — paced family voyage receipt

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — bounded native implementation, 51 contract checks, generic
visionOS Simulator build, deterministic guide states, and a three-frame local
timing proof. LIMITED — no OpenAI audio request, paid inference, XCAT/wearer
test, family-comprehension study, medical review, CFD, or clinical proof.**

## What changed

- The optional Family guide is now a three-beat voyage: **orientation → passage
  → arrival**.
- Overview, Frontal route, and Neighbor route each have three short, versioned
  title-and-caption pairs. The nine cues distinguish what is visible, what the
  direction cue means, and what is illustrative.
- The guide reuses the one existing information surface. It does not add a new
  window, dashboard, ornament, or world-space card.
- Selecting a route restarts the guide at orientation. The sequence advances
  every 7.5 seconds of unpaused ride time; Pause holds the guide clock and audio
  player, and End guide cancels the active sequence.
- Captions no longer depend on voice configuration. A missing local proxy is
  stated plainly while the caption journey remains usable.
- The old proof-only shortcut that displayed voice as configured without an
  endpoint was removed.

## Voice and provider boundary

- Requested model interpretation: `gpt-realtime-2.1`; voice: `marin`.
- The model currently supports audio input/output and `/v1/realtime`. OpenAI's
  server-side WebSocket guidance keeps the standard API key on the backend; the
  visionOS client therefore continues to call only the developer-controlled
  loopback proxy.
- The proxy and app preserve the existing exact-copy contract: the returned
  model header and SHA-256 of the visible title-plus-caption must match before
  WAV playback.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: PASS.
- No key was loaded for this run and no request was sent to OpenAI. Audio
  quality, latency, interruption behavior, cadence, cost, and family
  comprehension are **NOT RUN**.

Official references checked for this pass:

- [GPT-Realtime-2.1 model card](https://developers.openai.com/api/docs/models/gpt-realtime-2.1)
- [Realtime API with WebSocket](https://developers.openai.com/api/docs/guides/realtime-websocket)

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (51 checks).
- `xcodegen generate`: PASS.
- Xcode 26.6 (17F113), XRSimulator 26.5.
- Unsigned generic visionOS Simulator Debug build: `** BUILD SUCCEEDED **`.
- Product:
  `/tmp/rbc-family-voyage-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`
- Bundle allocated size: 54,800 KiB.
- Executable: universal Mach-O, x86_64 and arm64.
- Simulator: Apple Vision Pro
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- Physical Apple Vision Pro `XCAT`: `unavailable` at this verification point.

## Accepted local visual and timing proof

- `122-family-voyage-orientation-accepted.png`: 3840 × 2160; overview guide
  `01 / 03`; SHA-256
  `144e068df2ba0f49e642ebe8168fefebdad622af14eedc92884347af1caa8906`.
- `123-family-voyage-frontal-arrival-accepted.png`: 3840 × 2160; selected
  frontal route guide `03 / 03`; SHA-256
  `a7e001759e47fc1f44ac265fb6281543a1b24d956ddf57220d44e82e15e547ae`.
- `124-family-voyage-auto-progression-contact-sheet.png`: three screenshots
  from one unlocked Simulator launch taken after approximately 5, 13, and 21
  seconds. The visible state progresses `01 / 03 → 02 / 03 → 03 / 03` while
  cells and route light change position; SHA-256
  `830fb1436bdaa878dd1a7effe4cf295797cbaa61324c84171249b2e0a6499cc5`.

Codex visual verdict: **PROMOTE locally.** The changing guide copy remains
inside the existing compact lesson hierarchy and the 3D fork stays dominant.
The captions are readable in the full-resolution stills. The contact sheet is
temporal evidence, not a readability reference.

## Source hashes

- `Sources/RBCJourneyModel.swift`:
  `d7eeb2e54cdb8b0a1a96bcabcd3c92893b54812a6fde0221967a6416d7846509`
- `Sources/RBCJourneyImmersiveView.swift`:
  `ca420702761efb75236d8fb0807107acc29d133c2b13ab3e1f971ae8242371a7`
- `Sources/RBCJourneyHUD.swift`:
  `3f67b3de32a88d82addf623fbe86059438608b5f92d441082b68d6c83c0ad957`
- `Sources/RBCFamilyNarrationEngine.swift` (unchanged):
  `c7bc033464ac0c73d2f996dd0c6511ea789c84577e1a9bb2f27a4a041642d8d8`
- `Scripts/rbc_realtime_narration_proxy.mjs` (unchanged):
  `5d02698450dbc1a1ba80519fe02737e03ea2837d1a622e77b1ab233b9e14fbb6`

## Next honest gate

Run this branch on XCAT with the proxy absent and ask one family-background
reviewer to complete Overview → Frontal route → End guide. Confirm that the
captions are readable, the 7.5-second pacing does not compete with looking, and
Pause/End remain obvious. Only after explicit approval to spend one provider
request should the loopback proxy be started to evaluate live voice latency,
interruption, and whether narration adds clarity beyond the visible copy.
