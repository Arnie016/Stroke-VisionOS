# Inhabit the Flow V20 — anterior circulation passage

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — bounded native interaction, 67/67 contract checks, generic
visionOS Simulator build, narration-integrity self-test, three reviewed
Simulator compositions, and a distinct-motion screenshot pair. LIMITED — no
XCAT/wearer, provider-audio, paid inference, anatomical registration, CFD,
clinical, or family-comprehension proof.**

## What changed

The Circle's existing 26-path network is now one continuous anterior lesson:

1. **Approach** isolates the paired internal-carotid approaches.
2. **Crossroads** restores the Circle connections without assigning one fixed
   direction to communicating arteries.
3. **Continue** keeps one explicitly named example right MCA route bright,
   recedes the contralateral route as context, and reveals a downstream entry
   aperture.

This is a semantic recomposition of the existing network, not a second vessel
model. Six RealityKit roots separate carotid, crossroads, selected right MCA,
contralateral MCA, anterior-cerebral context, and the entry threshold. Three
faint coral halos sit outside only the selected route's red vessel walls. A
three-contour broken warm aperture pulses downstream. Moving arrow fronts are
enabled only for the current beat; the wearer remains at the stable teaching
origin.

The final beat has exactly three actions: **Enter artery**, **Open frontal
field**, and **Leave passage**. Enter artery reuses the existing inhabited
lumen ride. Open frontal field uses the normal stationary region threshold.
Neither action introduces camera locomotion.

## Family companion boundary

The existing optional Family companion observes `activeWillisTitle` and
`activeWillisSubtitle`, so each passage beat offers the exact visible copy to
the same transcript-locked `gpt-realtime-2.1` proxy. It is off by default. The
model cannot select a route, advance the passage, move the world, change
medical copy, diagnose, or answer open-ended medical questions. Captions and
the spatial sequence work without audio. No provider request or paid
inference was run for this receipt.

## Visual review

All accepted screenshots are 3840 × 2160:

- `212-anterior-passage-carotid-accepted.png`
  - SHA-256: `07a6aec9def1be1070f478c388e69335f4411bb2bf6ced2f61b870f425f80404`
  - The paired approaches dominate and four tangent fronts visibly rise toward
    the Circle.
- `213-anterior-passage-crossroads-accepted.png`
  - SHA-256: `7fc5cfb8764db239cbb00f6c7486bdf953e63b64eb925a6be56bbb8e8e6d0561`
  - Central crossings and their connections become the spatial subject while
    unrelated continuations recede.
- `214-anterior-passage-mca-gateway-accepted.png`
  - SHA-256: `005133ee58522d69bf2269cc464296a1831366eabf381a42e6ded0bf3b2cade5`
  - The Circle begins at left, one right-MCA exemplar crosses the room, and a
    complete downstream aperture is visible without obscuring the environment.
- `215-anterior-passage-mca-motion-b-accepted.png`
  - SHA-256: `ddd1409ad442b588937ece703367682e9781ea98599d75826661ae8103cec474`
  - Captured two seconds later. The distinct image and visibly advanced front
    demonstrate ongoing motion, not a static diagram.

The first pass (`205`–`207`) was rejected because both MCA sides remained
equally bright and the handoff existed only as a button. `208`–`210` iterated
the selected-route framing and aperture placement; the early threshold was
off-screen, then oversized and clipped. `211` established the accepted
composition. Only `212`–`215` are promoted as V20 evidence.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 67/67**.
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
    -derivedDataPath /tmp/rbc-journey-v20-derived \
    CODE_SIGNING_ALLOWED=NO build
  ** BUILD SUCCEEDED **
  ```

- SDK: `xrsimulator26.5`; deployment target: visionOS 2.0.
- Product: universal arm64 + x86_64 Simulator app; 57,388 KiB.
- Installed and launched on booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` with each of:
  - `--proof-anterior-passage-carotid`
  - `--proof-anterior-passage-crossroads`
  - `--proof-anterior-passage-mca`

## Source receipts

- `RBCJourneyModel.swift`: `aa13bd5ae919611d0d82726833d7a64a2463cc55488cfd9ca3517a03adf6366d`
- `RBCJourneyHUD.swift`: `641d53f4445b1f857fe7249556c0da2b75cee94a7c460eee2bb0d24e6a8c2e99`
- `RBCJourneyScene.swift`: `954a9d5b182d995398266328baec205fbc12f7117c9be08f7161de1bb9395f5a`
- `RBCJourneyImmersiveView.swift`: `9a578d6f0d44c41c00223ec55848193c4d8290a403628b51d6d06545d8e6cbde`
- `verify_contract.py`: `1337a4fe64dada32fc308665e57e008b998b32b41762dab95336660b7cecb332`
- `README.md`: `e04eaef9645fd47c7d4ff8ad4fcd1268432aa9faf43ec8b13680b55c27264d01`
- `AGENTS.md`: `2dc2febe4aa910cb64c4df80f195230f6b543c70de4e261ba120444c831e89fb`
- `medical-content-canon.md`: `641d7c1f248acf9a46e20a41c3396457d9b3ee9c4254ab2b6afe81925a4bd3c2`

## Evidence boundary and next gate

The right-MCA route is an enlarged generic teaching exemplar. Its side,
geometry, thickness, arrows, cadence, halos, and aperture do not represent a
patient, complete vascular atlas, measured haemodynamics, collateral flow,
perfusion, territory, CFD, diagnosis, prognosis, or treatment guidance.

The next decisive gate is one signed XCAT wearer session: ask a participant to
perform Approach → Crossroads → Continue without coaching, identify which side
is the selected exemplar, and choose either the lumen or frontal destination.
Then test one reviewed Family-companion line for comfort and comprehension.
Provider audio requires a separate explicit paid-request approval.
