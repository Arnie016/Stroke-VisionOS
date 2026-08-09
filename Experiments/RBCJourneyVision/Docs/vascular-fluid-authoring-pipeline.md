# Vascular fluid authoring pipeline

## Technical thesis

Technical implementation does not require training a model. The defensible
technical story is a reproducible path from named anatomy to an interactive,
comfortable, evidence-labelled spatial lesson:

1. **USD anatomy contract:** preserve named anatomical entities, source hash,
   units, axis, license, and a specialist-review status.
2. **Houdini authoring:** derive a centerline graph, branch IDs, lumen radius,
   obstruction locus, flow direction, collision proxy, and LOD groups. Export
   those semantics with the geometry rather than baking meaning into filenames.
3. **Blender look development:** validate vessel-wall normals, UVs, PBR maps,
   lighting, camera-independent readability, and USDZ fidelity.
4. **Bounded Mantaflow experiment:** simulate only one local magnified lumen
   segment for visual communication. Blood is non-Newtonian and Mantaflow is
   not a clinical hemodynamics solver; the output remains illustrative.
5. **RealityKit runtime:** stream a compact baked sequence or velocity-driven
   markers, keep user position stationary, and apply lesson state to actual
   animation playback. Do not run an expensive fluid solve on the headset.
6. **Evidence ladder:** source checks, asset checks, generic arm64 build,
   Simulator composition, XCAT install, wearer comfort, teaching study, and
   specialist review are separate gates.

## Bounded experiment contract: VFLOW-LAB-001

- **Question:** Does a local baked liquid close-up communicate flow arrest more
  clearly than the current animated lumen without becoming visually noisy?
- **Input:** one generic 0.40 m teaching vessel with a named obstruction zone;
  no patient data.
- **Compute:** local Apple GPU only; no cloud credits or uploads.
- **Bake:** 48 frames, one second pre-roll, 12–24 fps proof, low resolution
  first. Record simulation, meshing, rendering, and export time separately.
- **Output ceiling:** one promoted USD/mesh-sequence bundle at or below 15 MiB;
  no raw cache in the app target.
- **Required views:** lumen entry, obstruction close-up, downstream pullback,
  plus a contact sheet and motion proof.
- **Quality gates:** no domain box, no popping loop, no wall penetration, stable
  scale/orientation, readable obstruction, no metallic water, no asset-license
  ambiguity, and no clinical or CFD claim.
- **Promotion rule:** promote only if two reviewers prefer it to the existing
  route for clarity and the Simulator stays within the agreed frame/storage
  budget. Otherwise retain the current lightweight route.

## Where generative workflows help

Generative image or texture tools can propose vessel-wall and tissue material
variants, but only through a contact-sheet batch: deduplicate, inspect seams,
verify normal/roughness direction, reject implausible anatomy, record model and
license provenance, and promote at most five variants. A generated texture is
never evidence of anatomical or clinical accuracy.
