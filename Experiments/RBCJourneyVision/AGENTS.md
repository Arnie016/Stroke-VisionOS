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
- Brainstem observatory: one upright midbrain–pons–medulla corridor around the
  stable wearer, three broken level contours, four folded environment walls,
  16 peripheral depth ribs, nine longitudinal and nine transverse pontine
  guides, 72 sparse tegmental points,
  and 17 qualitative vertebral/basilar/cerebellar/posterior routes with 23
  tangent fronts. The combined imported source is dim relational context—not
  segmentation, histology, nuclei mapping, tractography, fixed territory, CFD,
  or patient anatomy.
- Posterior voyage: only from Brainstem Flow, and only by explicit action.
  Converge → Bridge → Choose smoothly recomposes four existing route families
  around the stationary wearer. The final beat offers Cerebellum, Visual
  cortex, and Leave route—never more than three choices. Teal/violet halos are
  navigation accents around red arterial walls, not anatomy or oxygenation.
  Destination selection must reuse the normal region-threshold handoff.
- Circle crossroads: 26 continuous native arterial paths, 16 tangent-aligned
  qualitative flow fronts, and Whole circle / Anterior / Posterior focus. The
  communicating paths carry no fixed-direction arrows because this is not an
  individual's collateral-flow pattern.
- Anterior passage: only after explicit Anterior focus. Approach → Crossroads →
  Continue must reuse the Circle network, isolate one clearly named right-MCA
  teaching exemplar, and keep the opposite side as faint context. Three outer
  halos and one broken warm aperture are navigation accents, never vessel
  color or patient registration. The final beat offers only Enter artery, Open
  frontal field, and Leave passage; both destinations reuse their established
  fixed-wearer handoffs. The warm aperture is a standard RealityKit target:
  system hover plus one pinch enters the artery, while the labelled Enter
  artery button remains the accessible and Simulator-safe equivalent. Never
  read, store, or infer an eye-gaze vector for this interaction.
- MCA gateway handoff: entering the artery must be a continuous
  fixed-observation transition, not an instant scene replacement. Keep the
  selected Circle route and existing arterial corridor alive together while
  the source yields and the lumen grows from the same gateway locus. Preserve
  the 1.65-second default, the 480-millisecond Reduce Motion dissolve,
  deterministic progress flags, concise exact-caption copy, and the no-camera
  boundary. Do not introduce another threshold asset or floating control.
- Arterial ride: fixed wearer, native inward-facing fork, provenance-tracked
  PBR arterial-wall microtexture, ten rounded current volumes sharing one
  procedurally generated downstream-moving surface pulse, ten fixed route
  chevrons across the shared stem and two branch continuations, zero moving
  front geometry, and 42 authored biconcave cells distributed as one shared
  population before two branch populations with bounded qualitative lane
  variation. The default lesson is an automatic six-beat source → division →
  frontal branch → arteriole → capillary journey. During playback expose only
  Pause/Resume; defer manual route controls until the completed learner chooses
  Explore. Keep scene, caption, optional exact-copy voice, and a stationary
  anterior-view 3D locator on one phase source of truth. Fork/right-M1 markers
  derive from named USD geometry; label the cortical capillary marker as a
  representative proxy, never patient registration. The blood cues stay
  crimson/coral/amber; teal is destination navigation only. This is direction
  choreography, never a velocity profile, hematocrit model, or CFD.
- Frontal destination: constellation outline around an authored artery →
  penetrating arteriole → 34-node capillary-field scale transition with sparse
  tangent-aligned arrow fronts. The wearer may pinch the field or use one
  fallback control to let it expand while the wearer stays still, then return
  to the artery. Six faint tissue-facing rings illustrate exchange while red
  cells and arrows remain intravascular. It is an orientation/exchange lesson,
  not measured flow, diffusion, oxygen concentration, or patient anatomy.
- Family guide: the guided arterial journey always presents reviewed captions;
  an optional voice may read only that exact visible copy through a loopback proxy. The same
  opt-in companion can read a selected region's visible title and explanation.
  It is off by default and never a clinician default. Reject returned audio if
  its transcript word sequence differs from the reviewed copy. Entering the
  capillary field advances the guide to the matching arrival explanation. If
  the companion is already on when a new region is chosen, it reads the short
  visible threshold before the destination copy; the flow ambience ducks under
  active narration and a bounded timeout prevents a failed provider from
  holding the spatial transfer.

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
