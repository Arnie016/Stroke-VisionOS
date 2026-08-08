# Houdini → Stroke Care spatial pipeline

The app already has a real on-device RealityKit rig. Houdini is the upstream
authoring lane for a higher-detail brain shell, cerebral vessel network,
occlusion profile, penumbra volume, and reviewed USD export. It is not a headset
dependency and it is not a clinical solver.

## Procedural graph

```text
REVIEWED_BRAIN_SOURCE
  → NORMALIZE_METERS
  → AUTHOR_HEMISPHERE_ID
  → BRAIN_REVEAL_RIG
       left/right pivot · reveal · focus fade
  → OUT_BRAIN_REVEAL

REVIEWED_VESSEL_CURVES
  → RESAMPLE_ARCLENGTH
  → AUTHOR_CURVE_U
  → OCCLUSION_RADIUS_PROFILE
       clot_u · stenosis_width · radius_floor
  → SWEEP_VESSEL_TUBES
  → FLOW_POINTS_ON_CURVE
       stop/fade downstream of clot_u
  → OUT_VESSEL_AND_FLOW

PENUMBRA_GUIDE
  → VDB_FROM_POLYGONS
  → LOW_FREQUENCY_VOLUME_NOISE
  → REVIEWABLE_ISOSURFACE
  → OUT_PENUMBRA_CUE

OUT_* → Solaris composition → USD validation → USDZ package → RealityKit
```

`Scripts/build_houdini_stroke_graph.py` creates the inspectable SOP networks.
The graph separates three meanings that must not be collapsed:

- anatomy context (brain and vessel geometry),
- qualitative teaching motion (flow points and reveal pivots),
- clinical interpretation (never produced by the graph).

## Physics policy

| Question | Houdini method | Runtime result | Evidence boundary |
| --- | --- | --- | --- |
| How does the model open? | Packed hemisphere transforms or blend shapes | Baked USD animation plus current transform fallback | Not an incision or surgery simulation |
| Where is the vessel narrow? | Curve-radius attribute around `clot_u` | Named occlusion prim and stable focus anchor | Not derived from CTA/MRA |
| How does supply appear interrupted? | Curve-following particles with downstream attenuation | Point cache or deterministic RealityKit droplets | Not CFD, pressure, collateral flow, or perfusion measurement |
| How does tissue at risk read volumetrically? | VDB guide + art-directed noise | Small cached surface/volume or current lobe fallback | Not infarct segmentation or outcome prediction |
| What does Plan B show? | One conceptual catheter guide curve | Cyan question anchor | Not access planning, device simulation, or procedural eligibility |

Do not use FLIP merely because blood is a liquid. For this app, a bounded
curve-following flow cue is smaller, more controllable, and more truthful. A
future CFD/FLIP study belongs in a research branch with geometry, boundary
conditions, validation data, and domain review—not in the patient-facing app.

## Export gate

1. Confirm source provenance, license, units, orientation, anatomical region,
   and whether geometry is educational or patient-derived.
2. Inspect the rest pose, hemisphere seam, pivot location, clot anchor, vessel
   intersections, normals, and reduced-motion state.
3. Bake a short loop and one reversible reveal. Keep separate named prims for
   `brain_left`, `brain_right`, `vessels`, `occlusion`, `penumbra`, and
   `catheter_question_anchor`.
4. Run `usdchecker`, inspect in Reality Composer Pro, then compare on the same
   Simulator camera against the deterministic fallback.
5. On XCAT, measure load time, stable frame rate, readable scale, reach, comfort,
   and reset. These are physical checks, not inferred from the cache.

## Current status

Houdini/hython is unavailable to this Codex runtime. The graph builder is
**Houdini-ready, not Houdini-executed**. No `.hip`, cook, VDB, particle cache,
or Houdini-authored USD is claimed. The shipped Simulator proof uses the native
RealityKit rig in `StrokeSceneFactory.swift`.
