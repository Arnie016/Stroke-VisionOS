# RBC Journey coding-agent context

## Promise

Build a native visionOS experience in which the wearer enters a generic brain
atlas, discovers named regions like constellations, and can inhabit a cerebral
arterial lesson. Spatial relationships should do explanatory work that a flat
video cannot.

## Current hierarchy

- Entry: threshold → anatomy → problem → invitation.
- Default story: route → blockage → consequence.
- Exploration: a lower region reel with exactly three visible destinations at
  once and one active transfer.
- Frontal observatory: Locate → X-ray → Flow → optional example clot.
- Arterial ride: fixed wearer, native inward-facing fork, continuous route
  meshes, sparse directional chevrons, tumbling/deforming authored cells,
  user-selected branch transfers, Pause, Leave, and Exit.
- Family guide: optional three-beat orientation → passage → arrival captions;
  voice may read only the exact visible copy through a loopback proxy. It is
  off by default and never a clinician default.

## Non-negotiable constraints

- Keep this experiment separate from `apps/StrokeCare` until Arnav explicitly
  requests integration.
- Use SwiftUI → RealityKit → ARKit in that order. Do not add UIKit casually.
- Never add an app camera or force locomotion. Transform the authored world
  around a stable observation origin.
- Never allow more than three open portals.
- Do not add another floating dashboard. Use one title, one concise paragraph,
  one bounded fact, and explicit controls only when they are needed.
- Preserve Reduce Motion, Pause, Leave/Return, Exit, accessibility labels, and
  Simulator-safe control fallbacks.
- Do not call qualitative movement CFD, perfusion, measured speed, pressure,
  patient anatomy, or clinical prediction.
- Do not place a permanent provider secret in Swift, source control, build
  settings, screenshots, or logs. Do not spend API credits without explicit
  approval.

## Before changing visuals

Inspect the current deterministic proof route and the latest receipt. Reject
near-field cables, giant arrows, sealed cutaways, decorative particles that
read as anatomy, unreadable dark scenes, and 2D panels that replace spatial
relationships. Add one coherent visual system and at most two accent techniques.

## Required verifier

```bash
python3 Tests/verify_contract.py
xcodebuild -project RBCJourneyVision.xcodeproj \
  -scheme RBCJourneyVision \
  -sdk xrsimulator \
  -destination 'generic/platform=visionOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Report build, Simulator, XCAT, wearer, medical-specialist, and clinical proof as
separate rungs. A screenshot or proof launch flag is never evidence for the
higher rungs.
