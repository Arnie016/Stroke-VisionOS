# Internal Brain Experience

## Product promise

At high exterior zoom, **Enter the brain** moves the learner into a room-scale,
generic teaching environment inside the same Stroke Care app. The internal
journey is an explorable anatomy exhibit—not a patient scan, diagnostic tool,
physiology simulator, or operative rehearsal.

## What is working now

- A continuous exterior-to-interior handoff and an always-visible **Return to
  Stroke Care** action.
- Five wearer-controlled systems: **Cortex**, **Vessels**, **Deep structures**,
  **Ventricles**, and an optional **Neural activity** abstraction. Each can be
  focused, shown, hidden, isolated, or opened as a related authored lesson.
- Room-scale arterial routing with qualitative flow, a lumen/cell journey, and
  an authored pause at an example blockage to compare the route with the
  downstream territory. This teaches relationships; it does not predict harm
  or outcomes.
- Discoverable destinations for the arterial lumen, Circle of Willis, cortical
  exchange, cerebellum, deep structures, frontal lobe, occipital lobe,
  brainstem, ventricular system, and cortical microarchitecture. The exterior
  Atlas has a temporal-lobe chapter; it is not yet a separate internal room.
- A cortical-microarchitecture room with six curved laminar bands, 93 sparse
  illustrative cell markers, five radial guides, nine qualitative vascular
  paths, and 13 moving direction arrows. Locate, Layers, and Flow provide three
  distinct readings; the system controls remain available inside the room.
- A separate schematic pulse network can be enabled in the cortical lesson.
  It does not claim to simulate membrane voltage, neurotransmission, spike
  timing, ion exchange, or a person's functional connectivity.
- A dedicated ventricular-system exhibit that enlarges the bundled ventricular
  geometry and animates four connected-space guide points. The cyan guides show
  spatial continuity only; they do not claim to simulate cerebrospinal-fluid
  flow or pressure.
- A persistent systems lens, saved-learning action, short explanations, and
  generic-teaching disclosures in the same visible control surface.

## Animation grammar

The internal world uses slow directional flow, traveling neural pulses,
breathing highlights, and region transitions. Motion pauses when requested and
respects reduced-motion settings. Neural activity is off in the normal quiet
opening and can be explicitly enabled; the deterministic proof route enables it
to verify that the layer renders.

## Truth boundary

The current “what can go wrong” lesson is deliberately bounded to one example:
an arterial blockage changes downstream supply. It does not diagnose stroke,
rank treatment, infer prognosis, model hemorrhage, or promise an outcome. Any
future disease scenario needs a named source, clinical review, and separate
language/animation approval before it enters the learner route.

## Verification

- Contract: `python3 Tests/verify_contract.py`
- Build: generic visionOS Simulator build of `StrokeTime`
- Deterministic route: `--proof-integrated-interior`
- Fresh visual: `/tmp/strokecare-integrated-interior-systems-late.png`
- Ventricular route: `--proof-integrated-ventricles`
- Ventricular visual: `/tmp/strokecare-integrated-ventricles-proof.png`
- Cortex route: `--proof-integrated-cortex`
- Cortex visuals: `/tmp/strokecare-integrated-cortex-proof-a.png` and
  `/tmp/strokecare-integrated-cortex-proof-b.png`

The Simulator proof confirms composition and visible controls only. It does not
prove headset comfort, hand targeting, comprehension, anatomical registration,
clinical validity, or App Store readiness.
