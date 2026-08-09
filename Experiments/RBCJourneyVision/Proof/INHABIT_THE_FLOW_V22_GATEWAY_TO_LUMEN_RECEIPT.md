# Inhabit the Flow V22 — MCA gateway to lumen

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — user-triggered route-to-place state, 69/69 contract checks,
generic visionOS Simulator build, transcript-integrity self-test, and three
reviewed deterministic Simulator compositions. LIMITED — no XCAT hover/pinch,
wearer comfort, physical scale, provider-audio, paid inference, medical-
specialist, or clinical proof.**

## What changed

The selected right-MCA threshold no longer swaps immediately to the arterial
ride:

- A dedicated `isAnteriorGatewayTransitionActive` state holds the Circle and
  existing arterial corridor together for one transition.
- The live path lasts 1.65 seconds. The warm aperture expands, the selected
  Circle network yields, and the lumen grows from the same gateway locus while
  the observation origin and app camera remain unchanged.
- Once progress reaches 84 percent, the already-faded Circle source is removed
  so its dark arterial silhouettes cannot remain over the lumen.
- The exact visible caption is: **The route becomes a place. The branch opens
  around you. Your body stays still.** The existing exact-caption family voice
  may read that copy; it gains no state or scene authority.
- Reduce Motion uses a bounded 480-millisecond, nearly static dissolve. It does
  not simulate forward travel or rotate a tunnel around the wearer.
- The lower region reel is hidden during the handoff. No new window, asset,
  camera, recognizer, provider request, or paid generation was added.
- `--proof-anterior-gateway-transition-N` freezes any progress from 0 through
  100 without committing the destination, making compositional review
  reproducible.

The widening gateway and changing relative scale are spatial storytelling.
They are not vessel dilation, endoscopy, anatomical motion, measured flow,
hemodynamics, CFD, patient anatomy, diagnosis, or treatment guidance.

## Visual review

- `220-anterior-gateway-transition-early-accepted.png`
  - 3840 × 2160
  - SHA-256: `086ac1e582d1becf215af8a3bc5777a45b5bbcc8d017d3024e76aabfb507652a`
  - Circle-dominant: the selected arterial route remains legible and the warm
    aperture marks the right-side handoff before the room-scale lumen arrives.
- `221-anterior-gateway-transition-mid-accepted.png`
  - 3840 × 2160
  - SHA-256: `7612f480ace35dc1de004a8310189656fee72d46c1659c921c7c25143c2f4b85`
  - Mixed: the lumen wall, authored cells, destination openings, and fading
    source route coexist; the aperture fragments frame the handoff rather than
    replacing it with a flat wipe.
- `222-anterior-gateway-transition-lumen-accepted.png`
  - 3840 × 2160
  - SHA-256: `4c11eaff55bc186392c477ebbfc9f10a70ec766ec925d13512be61965c52a324`
  - Lumen-dominant: the Circle network is cleanly absent and the established
    branching arterial interior surrounds the stable observation origin.

These screenshots prove Simulator composition at three fixed progress values.
They do not prove temporal smoothness, stereo depth, collision comfort, system
hover, pinch success, motion comfort, or wearer understanding.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 69/69**.
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
    -derivedDataPath /tmp/rbc-journey-v22-derived \
    CODE_SIGNING_ALLOWED=NO build
  ** BUILD SUCCEEDED **
  ```

- SDK: `xrsimulator26.5`; deployment target: visionOS 2.0.
- Product: universal arm64 + x86_64 Simulator app; 57,448 KiB.
- Installed and launched on Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` with deterministic progress values
  28, 62, and 88. Each accepted capture followed a clean Simulator boot to
  avoid stale immersive-space compositor state.
- Build retained one non-fatal, unrelated warning for the pre-existing unused
  `outlineMaterial` local in the cerebellar source path.

## Source receipts

- `RBCJourneyModel.swift`: `4ddd204037789464bd5f17f9553fa98198c7c4799be483c0d0479a32f8365451`
- `RBCJourneyScene.swift`: `98ad944219ec248b0d904bce410564e294c10633dd838545f1f0d746f0a728ce`
- `RBCJourneyImmersiveView.swift`: `bf2b6bc931c896f66e9962cd8a6a02dd3eaf21400d53a3aece93220689f01ece`
- `verify_contract.py`: `1aa255d19b864358375a5e2587206d8862421bdb950627ab3bfb14fde806b09a`
- `README.md`: `507d0182632c3a75d28de1bc8b54d017e11d2d6e22a741bbbb70b0463189a334`
- `AGENTS.md`: `2fe4f21a641e0c1998f7270e0eb0bae892adf0b0e69aaafdf96ddc36042b8b0d`
- `medical-content-canon.md`: `1e7aecfb844af2abb60d81dcd696d15c72080c2f3c384dbfcff42c0096a533e9`

## Next gate

On XCAT, stand at the normal origin, select the right-MCA gateway five times,
and record: target acquisition, accidental activation, perceived continuity,
comfort during the 1.65-second expansion, whether the source appears to move
the wearer, and whether Reduce Motion feels like a clear handoff. That physical
wearer test is the only basis for claiming the transition is comfortable or
for retiming its scale curve.
