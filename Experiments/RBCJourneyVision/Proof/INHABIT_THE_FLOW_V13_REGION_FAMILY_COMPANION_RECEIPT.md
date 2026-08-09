# Inhabit the Flow V13 — region family companion receipt

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — bounded native implementation, 60 contract checks, transcript-integrity self-test, generic visionOS Simulator build, loopback health, and two deterministic Simulator states. LIMITED — no paid narration request, returned provider audio, XCAT playback, wearer test, family-comprehension study, specialist review, or clinical proof.**

## Product decision

The general inside-brain view now has one opt-in **Family companion**. It reads the exact title and explanation already visible for the selected destination; it does not generate a parallel medical answer. The default view remains unchanged and voice-free. The control adds one compact row to the existing region surface—no new window, ornament, or floating dashboard.

The existing route journey keeps its authored parent pacing: **Notice → Follow → Connect**. Region views are intentionally simpler: selecting a region or changing Whole Circle / Anterior / Posterior changes the reviewed utterance, and **Hear again** repeats it without changing the scene.

## Trust boundary

- Model configured by the secure local proxy: `gpt-realtime-2.1`; voice: `marin`.
- The visionOS app has no `OPENAI_API_KEY`, direct OpenAI URL, or microphone permission.
- The permanent provider key remains in macOS Keychain and was exposed only to the loopback proxy process.
- The proxy collects `response.output_audio_transcript.delta` events and rejects audio with `realtime_transcript_mismatch` unless the punctuation-insensitive transcript word sequence matches the reviewed caption.
- Before playback, the app verifies the returned model, exact-copy SHA-256, and transcript SHA-256.
- `node Scripts/rbc_realtime_narration_proxy.mjs --integrity-self-test`: `RBC_NARRATION_INTEGRITY_SELF_TEST=PASS cases=2`. Case/casing punctuation changes pass; a changed medical claim fails.
- Loopback `GET /health`: `status=ready`, model `gpt-realtime-2.1`, voice `marin`, `keyAvailable=true`.
- No `POST /narrate` request was made. No inference-credit spend or live provider-audio claim is attached to this receipt.

Official implementation references checked on 2026-08-10:

- [GPT-Realtime-2.1 model](https://developers.openai.com/api/docs/models/gpt-realtime-2.1)
- [Realtime WebRTC and ephemeral-key guidance](https://developers.openai.com/api/docs/guides/realtime-webrtc)
- [Realtime audio and transcript events](https://developers.openai.com/api/docs/guides/realtime-conversations)

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS`, **60/60**.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: PASS.
- `zsh -n Scripts/run_rbc_realtime_proxy.zsh`: PASS.
- Xcode 26.6 (17F113), generic visionOS Simulator, unsigned Debug: `** BUILD SUCCEEDED **`.
- Product: `/tmp/rbc-family-region-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`.
- Executable: universal Mach-O x86_64 and arm64; app bundle 56,024 KiB.
- Deterministic flag: `--proof-region-family-companion`; combine with `--proof-willis-route-anterior` or `--proof-willis-route-posterior` to verify focus-aware copy.

## Accepted local proof

| Artifact | SHA-256 | Bounded observation |
|---|---|---|
| `150-circle-family-companion-overview-accepted.png` | `a5c9f78dd73d7673bc6c5d34c4f536944664799091596277457fe8c3c5c7fe1d` | Whole-Circle explanation with the opt-in companion active and the honest local-guide-required status. |
| `151-circle-family-companion-anterior-accepted.png` | `2799dcb82e9de744159c9fcf25fef2bccbca05bbb27f9f60addc4857d8a15659` | User-selected Anterior focus changes both the spatial emphasis and the visible reviewed explanation while the companion remains secondary. |

Codex visual verdict: **PROMOTE locally.** The 3D arterial network remains dominant and the new affordance stays inside the existing information hierarchy. The screenshots do not prove physical scale, text comfort, gaze targeting, audio, or comprehension.

## Source hashes

- `Sources/RBCJourneyModel.swift`: `9f54c1a41045f10738b1e24efb6727e34670dd8039e675e51fe3cb551f51fa86`
- `Sources/RBCJourneyHUD.swift`: `89b701a0d4e40e2d410207596a1e1449e03b9e00b012d108dd90b8631dd24b9a`
- `Sources/RBCFamilyNarrationEngine.swift`: `2cfa747bbdd46138c1bb5032506d69db48c6bcf88d6fda741fc9413de6e6f67d`
- `Scripts/rbc_realtime_narration_proxy.mjs`: `ad4a66ab6d1427f9b73471ac9f340404e986dd4439045950f09d982e7c1bcc18`
- `Tests/verify_contract.py`: `12b9873be772eabbd72233df260747f0d9ab21e78b188c2b7b9d30087b05ab9e`

## Next honest gate

After explicit approval for one paid request, start the loopback proxy and request one reviewed Whole-Circle caption. Measure time-to-first-playback, verify the transcript gate, then test **End voice** during playback. Only if that succeeds should the same build be tried on XCAT with one family-background reviewer. The model must not receive authority over region selection, scene movement, diagnosis, or medical copy.
