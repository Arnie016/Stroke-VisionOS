# Stroke Care — durable context

## Product promise

**One fictional case. One blocked vessel. One clearer care conversation.**

This is a standalone stroke-patient/family communication app. Do not route the
work back into Heart Field. The controlling reference is the team sketch and
Figma flow: choose a case → zoom/reveal the 3D problem → open Plan A / Plan B →
create a discussion summary.

## Three-step contract

1. `Choose`: select `CASE-078`, explicitly fictional and free of patient data.
2. `Inspect`: one slider separates the two procedural hemispheres; tap/focus
   anchors the occlusion, penumbra, core, and qualitative perfusion cue.
3. `Discuss`: Plan A opens a medicine-review conversation and Plan B opens a
   thrombectomy-review conversation. They are not ranked or exclusive. Family
   and Clinician lenses change wording, not anatomy or recommendation.

## Scene grammar

- Grey — anatomical context.
- Amber — tissue at risk.
- Dark red — occlusion/core.
- Cyan — discussion-path preview, never treatment success.

## Performance guardrails

- `StrokeSceneFactory` stays `@MainActor`; background mesh creation previously
  caused a RealityKit crash.
- Continue using the quantised material cache. Rebuilding materials across the
  scene every frame caused hitches.
- All animation is deterministic entity transforms and a fixed droplet pool.
- XCAT/device proof, wearer comfort, and clinician review remain separate gates.

## Clinical boundary

Schematic teaching model. Not a scan, diagnosis, emergency instruction,
treatment recommendation, eligibility calculator, procedure simulation,
consent form, or medical record. The catheter line is a conceptual question
anchor—not an incision or accurate access route.
