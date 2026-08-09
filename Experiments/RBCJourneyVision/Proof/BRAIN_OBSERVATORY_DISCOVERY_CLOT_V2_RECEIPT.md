# Brain Observatory — Discovery + Occlusion V2 Receipt

Date: 2026-08-09 (Asia/Singapore)

Verdict: **PASS — bounded native implementation, Simulator composition, and motion proof**

This receipt proves one inside-the-brain RealityKit interaction slice. It does
not prove physical XCAT gaze/pinch acquisition, hand comfort, binocular depth,
teaching efficacy, anatomical segmentation, clinical accuracy, measured
hemodynamics, or medical utility.

## Implemented

- A small frontal constellation target exists in both the overview and the
  transferred frontal territory.
- The target has native `InputTargetComponent`, `CollisionComponent`, and
  `HoverEffectComponent`; standard gaze plus pinch enters the region, then
  cycles Locate → X-ray → Flow.
- No raw gaze vector is requested, captured, stored, or inferred.
- Flow has one opt-in **Place example clot** action, not a persistent dashboard.
- The obstruction is five overlapping irregular lobes with three thin teaching
  fibrin strands, a restrained warning field, collision, and native hover.
- Eighteen directional glints remain active across thirteen branches; glints on
  the single affected branch loop only upstream of the obstruction.
- Neighboring route visibility is context, not a claim of adequate collateral
  compensation.
- Deterministic launch: `--proof-region-6 --proof-region-mode-flow
  --proof-frontal-clot`.

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS`
  (46 named checks).
- Xcode 26.6, build 17F113.
- Generic visionOS Simulator Debug build: `BUILD SUCCEEDED`.
- Product:
  `/tmp/rbc-journey-inside-brain-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`
- Product size: 53,624 KiB.
- Binary: Mach-O universal x86_64 + arm64.
- Clean Simulator: Apple Vision Pro, visionOS 26.5,
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.

## Accepted local proof

- `69-brain-observatory-frontal-clot-final.png`
  - 3840 × 2160 clean Simulator frame.
  - SHA-256
    `a85cd8865e8de8a2644f5a94b10eeafd565e3798a17aa3259b6a054d410864a5`.
- `70-brain-observatory-frontal-clot-motion.mov`
  - H.264, 3840 × 2160, 26.03 seconds, 1,563 frames, 31,150,580 bytes.
  - Six one-second decoded samples have six distinct frame hashes.
  - SHA-256
    `86dc856605c376ba49ec26b03579cf576f4dd57fe0ad9af1a0e60358a3324947`.
- `71-brain-observatory-frontal-clot-motion-sheet.png`
  - Six one-second samples retain stable anatomy while flow darts and the
    irregular occlusion pulse change across time.
  - SHA-256
    `21efb151bef97b65d1350e9572afe739e44b5b8fa7497c7e14502f0fbfc6c92d`.

## Rejected evidence retained

- `67-brain-observatory-frontal-clot-candidate.png`: restored Stroke Care
  immersive session; cross-app frame, not RBCJourneyVision proof.
- `68-brain-observatory-frontal-clot-candidate.png`: correct app and composition,
  but the obstruction was too small at judge-demo distance.

The final candidate was captured only after terminating the stale Stroke Care
and RBCJourneyVision processes, installing the rebuilt app, and launching one
deterministic proof state. The Simulator was not erased.

## Source hashes

- `RBCJourneyScene.swift`
  `4c10c67b9c095f8779665c71986fb2c71af68764aa8d69ba32d924639e616fe2`
- `RBCJourneyModel.swift`
  `94363ca647c6c94d27bbc9530b589e70fd94074f396b929b744ce2a640249722`
- `RBCJourneyHUD.swift`
  `b8e18a488c1c5f3ad402d000dd62b17583a010ad80cdb4d8636fb121944d898d`
- `RBCJourneyImmersiveView.swift`
  `5bf30a500d31dd4a4770ca04123acaaf95b46aa983b16cdc3dc2597e069197ec`

## Research boundary

- Apple RealityKit gesture guidance requires input targets and collision shapes
  for entity gestures and uses system hover to communicate readiness.
- General stroke references support describing an occlusion as reduced or
  interrupted downstream supply and collateral circulation as variable. They
  do not justify quantitative flow, outcome, or treatment claims in this scene.

Sources:

- https://developer.apple.com/documentation/realitykit/responding-to-gestures-on-an-entity
- https://developer.apple.com/documentation/realitykit/inputtargetcomponent
- https://developer.apple.com/documentation/realitykit/hovereffectcomponent/
- https://www.ncbi.nlm.nih.gov/books/NBK27439/
- https://pmc.ncbi.nlm.nih.gov/articles/PMC10250877/

## Next gate

Run this slice on physical XCAT. Confirm that looking at the constellation gives
a calm, discoverable ready state; one pinch enters without false activation;
the affected branch reads as interrupted rather than decorative; and the top
caption remains legible while the wearer turns. Medical wording and geometry
remain pending specialist review.
