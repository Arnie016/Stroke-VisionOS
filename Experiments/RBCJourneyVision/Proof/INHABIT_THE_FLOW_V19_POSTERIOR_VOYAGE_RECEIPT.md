# Inhabit the Flow V19 — posterior circulation voyage

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — bounded native interaction, 66/66 contract checks, generic
visionOS Simulator build, transcript-integrity self-test, three reviewed
Simulator compositions, and a distinct-motion screenshot pair. LIMITED — no
XCAT/wearer, provider-audio, paid inference, anatomical registration, CFD,
clinical, or family-comprehension proof.**

## What changed

Brainstem **Flow** now contains an opt-in, wearer-stable voyage:

1. **Converge** isolates the paired vertebral approaches as they meet.
2. **Bridge** brings the basilar trunk and small pontine approaches forward.
3. **Choose** reveals only **Cerebellum**, **Visual cortex**, and **Leave
   route**.

The journey reuses the observatory's 17 authored teaching paths and 23 moving
fronts. It does not add a second vascular model. Those paths are reorganized
under four semantic RealityKit roots—convergence, pontine, cerebellar, and
visual—and interpolate position, scale, yaw, and opacity over 1.1 seconds
around a stationary wearer. Eight faint destination halos distinguish the two
final route families. Arterial walls remain red; teal and violet are navigation
accents, not anatomy, oxygenation, territory, pressure, or measured flow.

## Family companion experiment

The optional Family companion is off by default. When enabled, the existing
exact-caption narration pipeline observes the voyage's visible title and
explanation. It therefore reads the same reviewed copy at Converge, Bridge,
and Choose instead of inventing a hidden answer. Advancing the scene changes
both the spatial composition and the caption that is offered to narration.

The configured model remains `gpt-realtime-2.1`. The visionOS app never
receives a permanent provider key. Its developer-controlled loopback proxy
rejects returned audio unless the model header, exact-copy SHA-256, and
punctuation-insensitive transcript SHA-256 match the reviewed request. The
model has no authority over scene movement, destination choice, diagnosis, or
medical copy. There is no microphone permission and no open-ended medical
chat. With no proxy or sound, the visible journey still works.

OpenAI's current model page identifies `gpt-realtime-2.1` as an audio-input and
audio-output Realtime model with improved silence, noise, and interruption
behavior. The Realtime guide recommends a live session for low-latency voice
agents, but bounded speech generation for fixed text that does not need a live
conversation. This prototype deliberately preserves its stricter fixed-copy
proxy rather than expanding the feature into a conversational agent.

- <https://developers.openai.com/api/docs/models/gpt-realtime-2.1>
- <https://developers.openai.com/api/docs/guides/realtime>

No provider request or paid inference was run for this receipt.

## Visual review

All accepted screenshots are 3840 × 2160:

- `200-posterior-voyage-convergence-accepted.png`
  - SHA-256: `3688a6671b6039d66ec1b6c7d26bb5c198a2ae95683e8b8ff463ae37f23fc363`
  - The paired approaches and their meeting dominate while the information
    layer stays legible.
- `201-posterior-voyage-bridge-accepted.png`
  - SHA-256: `6d591f31ccf800e6e8005fcccc484a447db08a5a1faca4dccb401f7d904c7387`
  - The basilar bridge becomes the principal route and the next action is
    explicit.
- `202-posterior-voyage-destinations-accepted.png`
  - SHA-256: `28fa1c848a1e25a8b4fa6a4734e77b68acb36b2a6cd56d39a386950605a306eb`
  - Teal cerebellar and violet visual-cortex continuations occupy distinct
    spatial layers; only three actions are presented.
- `203-posterior-voyage-destinations-motion-b-accepted.png`
  - SHA-256: `c069b142d0137f54c29c743467c0e7bd497b053d5b8838f3690c5561cf0a6816`
  - Captured two seconds after the preceding frame. Its distinct hash and
    visibly advanced fronts demonstrate ongoing motion, not a still diagram.
- `204-posterior-voyage-family-companion-accepted.png`
  - SHA-256: `f56b55e0c21c09b0b3fe828e7af540796d99ddf166c06fe1170565ff3b02751d`
  - Holds the Bridge phase with the optional Family companion active. The
    visible caption remains identical and the UI states honestly that audio
    still needs the local guide. This is interface proof, not played-audio
    proof.

The first visual pass (`194`–`196`) was rejected because the basilar trunk was
too close to the information layer and the destination families were not
distinct. The second pass (`197`–`199`) established the corrected layout. Only
`200`–`204` are promoted as V19 acceptance evidence.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 66/66**.
- `git diff --check`: **PASS**.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: **PASS**.
- `node Scripts/rbc_realtime_narration_proxy.mjs --integrity-self-test`:
  `RBC_NARRATION_INTEGRITY_SELF_TEST=PASS cases=2`.
- `zsh -n Scripts/run_rbc_realtime_proxy.zsh`: **PASS**.
- Generic build:

  ```text
  xcodebuild -project RBCJourneyVision.xcodeproj \
    -scheme RBCJourneyVision \
    -sdk xrsimulator \
    -destination 'generic/platform=visionOS Simulator' \
    -derivedDataPath /tmp/rbc-journey-v19-derived \
    CODE_SIGNING_ALLOWED=NO build
  ** BUILD SUCCEEDED **
  ```

- SDK: `xrsimulator26.5`; deployment target: visionOS 2.0.
- Product: universal arm64 + x86_64 Simulator app; 57,012 KiB.
- Installed and launched on booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` with each of:
  - `--proof-posterior-voyage-convergence`
  - `--proof-posterior-voyage-bridge`
  - `--proof-posterior-voyage-choice`

## Source receipts

- `RBCJourneyModel.swift`: `4416ffe5b975b9c9f3866b53c9096f79d56d9af237b6a5c96059af65ebb96264`
- `RBCJourneyHUD.swift`: `91abd4a622a454316728551b89b58fa1b522a906f841d44bae19afce4651b48f`
- `RBCJourneyScene.swift`: `6457eec5787f354aa85dbe8997409e5b36884744dcef50e19c1124b671b4fff3`
- `RBCJourneyImmersiveView.swift`: `5b10265044473e4f8a191e4ee35f50e44b2a01db3dfab375e9a550ccde1e391c`
- `verify_contract.py`: `497bb33b50a4dbcfe08f5cca4c4cb9e0488d8687bba6c48563e7676e26c11685`

## Evidence boundary and next gate

The vessel paths are an educational spatial relationship model. Their
transforms are a storytelling device, not anatomical motion, segmentation,
patient data, a complete vascular atlas, physiological timing, perfusion, or
CFD. The screenshot pair proves Simulator rendering and frame change only; it
does not establish flow realism or wearer comfort.

The next decisive gate is one signed XCAT session with a wearer: test whether
Converge → Bridge → Choose is understood without explanation, then enable the
Family companion for one reviewed line and measure intelligibility,
interruption, ambience ducking, and added comprehension. Provider audio should
only be exercised with explicit approval for that bounded paid request.
