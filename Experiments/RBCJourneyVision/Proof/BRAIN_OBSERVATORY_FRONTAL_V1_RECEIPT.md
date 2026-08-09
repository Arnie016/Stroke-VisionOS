# Brain Observatory — Frontal V1 Receipt

Date: 2026-08-09 (Asia/Singapore)

Verdict: **PASS — bounded Simulator composition and motion proof**

This receipt proves one native visionOS frontal-region R&D slice. It does not
prove XCAT hand/gaze behavior, wearer comfort, binocular depth, teaching
efficacy, anatomical segmentation, clinical accuracy, or medical utility.

## Implemented

- One local prefrontal constellation inside the existing cortical vault; no
  second whole brain model.
- User-controlled Locate, X-ray, and Flow views of the same locus.
- An irregular local outline with 13 guide stars and a restrained inner arc.
- A tapered 13-branch teaching hierarchy at varied depths.
- Eighteen moving flow glints with short trails; Pause and Reduce Motion still
  hold animation.
- Glanceable title, paragraph, bounded fact, Save, Return, and Exit controls.
- Deterministic --proof-region-6, --proof-region-mode-xray, and
  --proof-region-mode-flow launch routes.

## Verification

- python3 Tests/verify_contract.py: RBC_JOURNEY_CONTRACT=PASS
  (44 named checks).
- Xcode 26.6, build 17F113.
- Generic visionOS Simulator Debug build: BUILD SUCCEEDED.
- Product:
  /tmp/rbc-journey-inside-brain-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app
- Product size: 53,504 KiB.
- Binary: Mach-O universal x86_64 + arm64.
- Clean Simulator: Apple Vision Pro visionOS 26.5,
  F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777.

## Accepted local proof

- 62-brain-observatory-locate-final.png
  - SHA-256 f57c8870f9feec3a117c2a991ed19193edb3a596e93b2c852e834a05c8c0bb83
- 64-brain-observatory-flow-clean-final.png
  - SHA-256 1acbd40b333ec36e967d19e29323ac519316e87998fdc21a54f1327d75efa162
- 65-brain-observatory-flow-clean-motion.mov
  - SHA-256 461654678fb7f78e025de7132b0f6b5e4d0fdd960e510bc16dfaeb90ed77d3c6
  - H.264, 3840 × 2160, 893 frames, 14.873333 seconds,
    16,757,501 bytes.
- 66-brain-observatory-flow-clean-motion-sheet.png
  - Six one-second samples show the glints changing position on distinct
    branches while the cortical environment remains stable.

## Rejected evidence retained

- 52-inside-frontal-region-directional-flow.png: giant bilateral outline and
  uniform pipes; rejected as diagrammatic.
- 53-inside-brain-route-direction-arrows.png: one enlarged pipe; rejected as
  insufficiently sophisticated.
- 54-inside-frontal-region-canopy-v2.png: bilateral schematic remained too
  dominant.
- 55-brain-observatory-locate-prefrontal.png: black frame during stale scene
  state.
- 56-brain-observatory-locate-delayed.png: contaminated by a restored Stroke
  Care immersive scene.
- 63-brain-observatory-flow-final.png: blank Simulator room after a rapid
  immersive relaunch.

The Simulator was shut down and booted without erasing data before the accepted
clean captures. This was necessary because stale immersive sessions can produce
black, blank, or cross-app frames that are not valid app proof.

## Source hashes

- RBCJourneyScene.swift
  97a5da4c11fed480ea778e3aaa77b5dba1f7a170c34108ee713df9b6082a3869
- RBCJourneyModel.swift
  824f56feb50a900fd134163825e8bcd71a0670ed12d77e89ffcf9b57fbd088a6
- RBCJourneyHUD.swift
  5c0d438330aa32a6cdcf7fc3181e381c949fbc18fa3e3bbfa0485c4b66bd25a4
- RBCJourneyImmersiveView.swift
  54d4dc6d071ba1363fb547d81df3595dbe9804ef782b176fab99fc4b3dea9923

## Next gate

Run the three modes on physical XCAT. Confirm the local outline can be acquired
without visual search fatigue, the glints read as directional flow rather than
foreign bodies, and the title remains legible while the wearer turns. Any
medical language or region boundary remains pending specialist review.
