# Inhabit the Flow V2 — continuous direction field and family guide receipt

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — bounded native implementation, 49 contract checks, generic
visionOS Simulator build, deterministic launch, and Codex-reviewed local motion
proof. LIMITED — no OpenAI audio request, paid inference, XCAT/wearer test,
medical review, CFD, or realistic blood-rheology proof.**

## What changed

- The wearer stays physically still while an authored 9.2-metre arterial
  cutaway surrounds the forward view. No app camera or forced locomotion exists.
- Imported yellow arrows, streamlines, and the opaque blood volume are disabled.
- Three procedural intraluminal ribbon paths use 33 samples per lane and a
  travelling luminance front. Their narrow radius and deeper start keep the
  direction cue out of the near comfort volume.
- Authored disc-shaped red cells translate downstream, tumble, and deform mildly
  while the adventitia, media, and intima remain separate visual layers.
- Motion is driven by a retained `RealityKit.SceneEvents.Update` subscription.
  Pause holds the local ride clock; resume continues without a wall-clock jump.
- The ride offers an optional **Family guide**. It is off by default, is not a
  clinician control, and may read only the exact visible, versioned caption.

## Family guide boundary

- App model: `gpt-realtime-2.1`; voice: `marin`.
- The visionOS process connects only to a configured loopback proxy and never
  receives a permanent OpenAI key or calls the provider directly.
- The app verifies the returned model header and SHA-256 of the exact caption
  before playing WAV audio. There is deliberately no system-voice fallback.
- The proxy locks the model and copy, creates an ephemeral client secret, and
  converts streamed PCM16 audio into WAV.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: PASS.
- Bounded local proxy health check: ready with model `gpt-realtime-2.1` and voice
  `marin`; an intentionally wrong model was rejected with HTTP 422.
- No valid narration request was sent to OpenAI. Audio quality, latency, cost,
  cadence, medical comprehension, and live endpoint compatibility are NOT RUN.

Official API references used for the bounded architecture:

- [OpenAI model catalogue](https://developers.openai.com/api/docs/models/all)
- [GPT Realtime model reference](https://developers.openai.com/api/docs/models/gpt-realtime)
- [OpenAI Realtime API announcement](https://openai.com/index/advancing-voice-intelligence-with-new-models-in-the-api/)

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (49 checks).
- `xcodegen generate`: PASS.
- Xcode 26.6 (17F113), XRSimulator 26.5.
- Unsigned generic visionOS Simulator Debug build: `** BUILD SUCCEEDED **`.
- Product:
  `/tmp/rbc-journey-inside-brain-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`
- App file bytes: 55,519,511; allocated size: 54,264 KiB.
- Executable: universal Mach-O, x86_64 and arm64.
- Simulator: Apple Vision Pro
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- Physical Apple Vision Pro `XCAT`: `unavailable` at this verification point.

## Accepted local motion proof

- `98-realitykit-update-retry-a.png` and
  `99-realitykit-update-retry-b.png` are lossless Simulator frames from the same
  stable composition with visibly changed cells and luminance-front positions.
- `100-deforming-flow-family-guide-motion-final.mov`: H.264, 3840 × 2160,
  24.178333 seconds, 1,452 frames, 56,831,978 bytes; SHA-256
  `a53b6c5b5807c40ee7445caeb1338d98266e9599794026c5c51c3ef118fbd662`.
- Eight decoded samples at three-second intervals produced eight distinct
  SHA-256 hashes.
- `101-deforming-flow-family-guide-motion-sheet.png`: cropped 4 × 2 motion
  sheet, 3840 × 1080; SHA-256
  `6358a45eb4a9248b060c655d2f13d68fff49152daddd94133e0d5895176e270e`.
- `102-deforming-flow-family-guide-final.png`: final 3840 × 2160 full-frame
  still; SHA-256
  `549df6639ad01ddbdc212ce5b84a2ddc56bd9389c936c13931a3cdc2feef48f1`.

This proves visible local Simulator movement with a stable observation origin.
It does not prove stereoscopic readability, frame pacing on device, comfort,
spoken narration, scientific hemodynamics, or clinical usefulness.

## Rejected evidence retained locally, not promoted

- `88`: a line crossed the comfort space and read as a cable.
- `89`: the deeper revision was too dark to read.
- `90`–`91`: composition was useful but lossless frames were identical.
- `92`–`93`: encoded-frame hashes differed without visible motion; rejected as
  compression-only evidence.
- `94`–`95`: an explicit SwiftUI clock still produced identical renders.
- `96`–`97`: the RealityKit update subscription was installed before the root
  entered a scene. Retrying installation from `RealityView.update` fixed it.

## Source and asset hashes

- `Sources/RBCJourneyModel.swift`:
  `17934d724be0b2d80c34726fca9490abf1d783b58e4e646ce2a739c008877ff0`
- `Sources/RBCJourneyImmersiveView.swift`:
  `7cb1d6d805c01d837e29ec64670341e737b0d83a8583c09020aa2fac9872af08`
- `Sources/RBCJourneyHUD.swift`:
  `df5bd45784d2f41e9af78178420cb3c15c3ef80eded95c1944d5caba93c5e1f5`
- `Sources/RBCJourneyScene.swift`:
  `93c96036950514359bac0ea514fb6d7afafc3d9a095e045efe764afd55190e05`
- `Sources/RBCFamilyNarrationEngine.swift`:
  `c7bc033464ac0c73d2f996dd0c6511ea789c84577e1a9bb2f27a4a041642d8d8`
- `Scripts/rbc_realtime_narration_proxy.mjs`:
  `5d02698450dbc1a1ba80519fe02737e03ea2837d1a622e77b1ab233b9e14fbb6`
- `Resources/Models/artery_cutaway_complete_v2.usdz`:
  `d8c8dc03ce6f430153c0fb764308077a8ddb30c64cd74749c1cee1e4871f22f9`

## Next honest gate

Run the branch ride on XCAT with the proxy absent first. Confirm the caption,
Pause, Leave, Exit, and silent fallback are readable and comfortable. Then, only
with explicit approval to spend one provider request, connect the loopback proxy
and judge one exact-caption narration for latency, interruption, intelligibility,
and whether it helps a family member without becoming an unsolicited lecture.
