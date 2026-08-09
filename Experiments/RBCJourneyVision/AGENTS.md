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
- Cortical microarchitecture: a room-scale six-layer teaching fold with five
  explicitly simplified radial guides and pial → penetrating → capillary Flow;
  it is not uniform functional modules, histology, CFD, or patient anatomy.
- Cerebellar observatory: one registered environmental reference, a peripheral
  hemisphere-and-vermis constellation, 47 illustrative folia bands, 13
  arbor-vitae guides, and 15 qualitative vertebrobasilar/SCA/AICA/PICA paths
  with 22 tangent fronts. Locate/X-ray/Flow reveal one stable place; it is not
  histology, territory segmentation, complete vasculature, CFD, or patient
  anatomy.
- Deep-structures observatory: one combined registered source retained as dim
  context, six relational nucleus guides, 192 sparse volume points, ten
  internal-capsule fibers, and 18 qualitative perforator approaches with 20
  moving fronts. Treat Locate/X-ray/Flow as relationship views—not semantic
  segmentation, tractography, fixed territories, CFD, or patient anatomy.
- Occipital observatory: one selected medial wall inside the registered cortex,
  three broken constellation arcs, 168 sparse points, 28 irregular fold
  fragments, six calcarine-bank layers, and ten qualitative posterior routes
  with 12 moving fronts. It is not segmentation, a sulcal atlas, retinotopy,
  visual-field mapping, fixed territories, CFD, or patient anatomy.
- Circle crossroads: 26 continuous native arterial paths, 16 tangent-aligned
  qualitative flow fronts, and Whole circle / Anterior / Posterior focus. The
  communicating paths carry no fixed-direction arrows because this is not an
  individual's collateral-flow pattern.
- Arterial ride: fixed wearer, native inward-facing fork, continuous route
  meshes, provenance-tracked PBR arterial-wall microtexture, sparse directional
  chevrons, tumbling/deforming authored cells, user-selected branch transfers,
  Pause, Leave, and Exit.
- Frontal destination: constellation outline around an authored artery →
  penetrating arteriole → 34-node capillary-field scale transition with sparse
  tangent-aligned arrow fronts. The wearer may pinch the field or use one
  fallback control to let it expand while the wearer stays still, then return
  to the artery. Six faint tissue-facing rings illustrate exchange while red
  cells and arrows remain intravascular. It is an orientation/exchange lesson,
  not measured flow, diffusion, oxygen concentration, or patient anatomy.
- Family guide: optional three-beat orientation → passage → arrival captions;
  voice may read only the exact visible copy through a loopback proxy. The same
  opt-in companion can read a selected region's visible title and explanation.
  It is off by default and never a clinician default. Reject returned audio if
  its transcript word sequence differs from the reviewed copy. Entering the
  capillary field advances the guide to the matching arrival explanation.

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
