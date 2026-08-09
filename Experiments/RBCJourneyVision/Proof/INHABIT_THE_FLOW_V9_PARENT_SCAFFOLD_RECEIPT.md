# Inhabit the Flow V9 — Parent-Paced Family Scaffold

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — local contract, generic visionOS Simulator build, and two
Simulator composition states.** Live provider audio, button-pinch causality,
XCAT, wearer comprehension, medical-specialist review, and clinical value are
**NOT RUN / NOT PROVEN**.

## Product decision

The voice layer remains an optional patient/family mode, off by default and
absent from any clinician-default workflow. It is not an open medical chatbot.
It reads only the exact visible, versioned caption through the existing local
proxy boundary.

The three-beat family lesson is now a parent-paced scaffold:

1. **Notice** names the visible spatial cue.
2. **Follow** relates that cue to travel through the arterial lumen.
3. **Connect** explains why the capillary arrival matters.

The wearer can choose **Next idea** or **Hear again** without opening another
panel. Every caption receives a calm reading-time dwell. If narration is live,
the automatic guide cannot replace the caption while audio is loading or
playing, and the audio delegate returns the guide to a ready state when playback
finishes.

## Causal-order correction

The first Simulator review was rejected because the guide could reach “A
network meets the cortex” while the frontal capillary field was still closed.
That proof remained outside the repository and was removed.

For the frontal route, automatic pacing now stops at **Follow**. The next action
becomes **Enter field**. That action expands the capillary environment and only
then advances the guide to **Connect**. The duplicate standalone capillary
button is hidden while family mode is active, keeping one forward action.

## Provider boundary

- Requested model: `gpt-realtime-2.1`.
- Voice: `marin`.
- Permanent API key: server-side only; never present in Swift or the app bundle.
- The app verifies `X-RBC-Narration-Model` and the SHA-256 of the exact caption
  before playing returned audio.
- A keyless local health check returned model `gpt-realtime-2.1`, voice `marin`,
  and `keyAvailable=false`.
- A deliberately wrong model was rejected locally with HTTP 422.
- No `/narrate` request using a valid model was sent. No OpenAI audio was
  generated and no provider credits were consumed.

Official source checked for this run:

- [GPT-Realtime-2.1 model reference](https://developers.openai.com/api/docs/models/gpt-realtime-2.1)

The model reference confirms audio input/output, the Realtime endpoint, and
improved interruption behavior. This receipt does not infer live voice quality
from those capabilities.

## Verifiers

- `python3 Tests/verify_contract.py`: **PASS, 56/56 checks**.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: **PASS**.
- Generic unsigned visionOS Simulator build: **BUILD SUCCEEDED** with Xcode 26.6
  and XRSimulator 26.5.
- Product: universal Mach-O (`x86_64`, `arm64`), 55,268 KiB at
  `/tmp/rbc-family-scaffold-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`.
- Booted Simulator: Apple Vision Pro
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.

## Accepted composition evidence

- `140-parent-paced-family-follow-accepted.png`
  - SHA-256: `28f705a5de842aa348656a33c2574170670c3eda9025ed79e7bb4aa49fdc80c2`
  - Shows **Follow** inside the arterial route and one causal forward action,
    **Enter field**. It does not show or describe cortical arrival early.
- `141-parent-paced-family-connect-accepted.png`
  - SHA-256: `c6563c59db4c257e0ee07ecaf5b9e4716cfbf17115a394d565ae21dc2572f8ab`
  - Shows **Connect** only with the capillary field expanded around the stable
    observation origin.

Both are deterministic Simulator states. They prove composition only, not a
physical pinch transition or human understanding.

## Source hashes

- `RBCJourneyModel.swift`:
  `377321f1d66620101d97193487f56032b218003fcfdcde407a00a7dc10fd3268`
- `RBCJourneyHUD.swift`:
  `b1d31476229585619ddcdcc5df26e648a845d828dc4ba6dde4195399f3b7fe11`
- `RBCJourneyImmersiveView.swift`:
  `bf634b51553dfebfaf009d9ebab28450e462d78e8e58fcfd04c2e560b05bd296`
- `RBCFamilyNarrationEngine.swift`:
  `4b364c0455db7205bc8be4ab4b9bab0f76770d2c0a6ee4a7039d1e88ad2e5ff4`

## Next honest gate

With explicit approval for a paid provider call and XCAT available, run one
reviewed caption through the local proxy and judge latency, intelligibility,
interruption, replay, and whether the family can correctly explain the visual
transition afterward. Keep those results separate from this Simulator receipt.
