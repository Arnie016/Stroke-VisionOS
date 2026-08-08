# Head-detail module notes

Module: `head_details_v2`

These assets are generic patient-education artwork for the Vision Pro Stroke
Patient Education Kit v2. They are not patient-specific, are not derived from a
patient's CT/MRI, and are not validated for diagnosis, treatment planning,
navigation, device sizing, outcome prediction, or procedural training.

## Recommended layer use

- Use `external_head_scalp_realistic_v2` as the intact exterior orientation
  view.
- Switch to `external_head_scalp_cutaway_v2` when internal layers need to be
  visible. The viewing window is illustrative and is not a surgical incision or
  planned craniotomy.
- Use `dura_mater_cutaway_conceptual_v2` in the default internal reveal. Do not
  stack the intact opaque scalp and intact opaque dura when the brain must remain
  visible.
- Load `falx_cerebri_atlas_v2` and
  `tentorium_cerebelli_atlas_v2` independently when teaching the named
  meningeal partitions, or use `meningeal_partitions_atlas_v2` to load all three
  named meshes together.
- Keep `eyes_context_realistic_v2` disabled in the default cranial cutaway. It
  is an optional opaque orbit-detail layer; the separate transparent corneal
  source overlay is intentionally omitted for reliable RealityKit rendering.
- Keep `skull_semantic_realistic_v2` separate from the convenience layered
  cutaway. Its cross-source fit is approximate, so it should be loaded only as
  an independently selectable, specialist-reviewed anatomy layer.
- `layered_head_cutaway_registered_v2` is a convenience/QA assembly. For the
  production viewer, lazy-load the smaller independently toggleable assets when
  possible.

## Registration and fidelity

- The scalp is cropped from the official watertight HRA Skin Male v2 source,
  capped at the upper-neck crop, and centered in the native HRA brain frame.
- The brain and skin share the HRA frame. The separately selectable Visible
  Human skull and eyes are approximate cross-source fits and must not be
  presented as an individual's anatomy.
- The falx and bilateral tentorium retain named Z-Anatomy/BodyParts3D atlas
  geometry and are registered by cortical-center alignment to the HRA brain.
- The cranial dura is original conceptual geometry derived from a smoothed,
  registered cerebral hull. Its thickness and viewing window are deliberately
  illustrative, not measurements of real dura.
- Every export uses metres, Y-up USD orientation, opaque simple-PBR materials,
  and separate toggleable meshes. No default transparency stack is required.

## Clinical and accessibility boundary

Before patient-facing use, the complete experience requires review by a stroke
neurologist/neurosurgeon, neuroradiologist where relevant, clinical educator,
accessibility specialist, and local consent/governance owners. The presentation
must clearly distinguish generic anatomy from the patient's own imaging and
must avoid implying guaranteed procedure steps or outcomes.

## Licensing

The HRA skin, HRA brain, and Visible Human skull/eyes are licensed CC BY 4.0.
The Z-Anatomy/BodyParts3D meningeal derivatives carry CC BY-SA 4.0 / CC BY-SA
2.1 Japan ShareAlike obligations. Retain `ATTRIBUTION.md`, the corresponding
`vendor/` metadata and license files, and the source-specific audit records with
distributed builds.
