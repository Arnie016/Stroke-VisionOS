# Open-cranial neurosurgery tools v3

This module contains **12 independent generic instrument sets** and **2
review-only assemblies** for a clinician-selected hemorrhage/decompression
patient-education branch. It is separate from the endovascular thrombectomy
module.

These are original, unbranded visual concepts. They are not marketed products,
complete operating-room sets, device specifications, operative instructions,
surgical training, treatment plans, navigation aids, or recommendations that a
particular approach or instrument is appropriate for a patient.

## Hard pathway gate

Every record carries all of the following controls:

- `procedure_scope = open_neurosurgery_only`
- `narrative_gate = clinician_selected_hemorrhage_or_decompression_only`
- `default_thrombectomy_pathway_allowed = false`
- `prohibited_pathways` includes `default_endovascular_thrombectomy`
- `patient_specific = false`
- `device_specific = false`
- `clinical_review_status = REQUIRES_SPECIALIST_REVIEW`
- `not_for_surgical_training = true`
- `not_for_navigation = true`
- `not_for_device_selection_or_sizing = true`
- `no_force_depth_trajectory_energy_claims = true`

Ordinary ischemic-stroke/endovascular-thrombectomy experiences must not load or
offer this module. A clinician-reviewed hemorrhage or decompression narrative is
required before the module can become selectable.

## Asset catalogue and relationships

Stage tags describe an association for presentation filtering only. They do not
encode clinical necessity, an operative sequence, or technique.

| ID | Visual contents | Descriptive stage tags | Suggested anatomical context |
|---|---|---|---|
| `surface_marking_ruler_set_open_neurosurgery_v3` | Generic marker, cap, clip, flexible ruler, and non-calibrated illustrative ticks | `surface_preparation`, `orientation_context` | `external_head_scalp_realistic_v2` |
| `scalpel_dissector_set_open_neurosurgery_v3` | Generic scalpel silhouette and double-ended blunt dissector | `soft_tissue_access` | `external_head_scalp_realistic_v2` |
| `scalp_retractor_hemostat_set_open_neurosurgery_v3` | Self-retaining retractor visual concept and two hemostat concepts | `soft_tissue_exposure`, `surface_hemostasis` | scalp and skull context |
| `perforator_craniotome_system_open_neurosurgery_v3` | Unbranded handpiece, perforator silhouette, craniotome attachment, footplate silhouette, and abbreviated cable | `cranial_opening`, `bone_access` | `skull_semantic_realistic_v2` |
| `bone_flap_fixation_set_open_neurosurgery_v3` | Three generic plate concepts, illustrative apertures, and eight generic screw concepts | `cranial_reconstruction`, `closure_context` | `skull_semantic_realistic_v2` |
| `dural_scissors_hooks_forceps_set_open_neurosurgery_v3` | Fine scissors, rounded hook, and spring-forceps concepts | `dural_exposure`, `intradural_access_context` | dura and meningeal context |
| `bipolar_forceps_irrigation_set_open_neurosurgery_v3` | Bayonet-style paired arms, illustrative irrigation path, handle, connector, and abbreviated cable | `microsurgical_hemostasis`, `irrigation_context` | vascular/dural context only after specialist review |
| `suction_microdissector_set_open_neurosurgery_v3` | Curved suction-tube concept, handle/port silhouette, and blunt microdissector | `field_management`, `microsurgical_handling` | brain and vessel context only after specialist review |
| `brain_spatula_retractor_set_open_neurosurgery_v3` | Three blunt spatula/retractor silhouettes with visibly distinct display widths | `tissue_protection_context`, `exposure_context` | brain context; never model pressure or placement |
| `microscope_microinstrument_tray_open_neurosurgery_v3` | Presentation tray, microforceps, microscissors, and rounded probe silhouettes | `microsurgical_instrumentation`, `review_layout` | neural-detail review context |
| `dural_closure_suture_patch_set_open_neurosurgery_v3` | Needle holder, curved-needle silhouette, abbreviated suture, and patch concept | `dural_closure`, `reconstruction_context` | dura and meningeal context |
| `conditional_csf_access_instrument_set_open_neurosurgery_v3` | Generic ventricular-catheter, sheath, clamp, and dressing concepts | `conditional_csf_access`, `postoperative_monitoring_context` | ventricles only in a separately reviewed conditional narrative |
| `cranial_access_tools_review_assembly_open_neurosurgery_v3` | Comparison layout duplicating the first five independent sets | `review_assembly`, `surface_and_cranial_access_context` | review table only |
| `intradural_closure_tools_review_assembly_open_neurosurgery_v3` | Comparison layout duplicating six dural, microsurgical, protection, tray, and closure sets | `review_assembly`, `intradural_and_closure_context` | review table only |

The conditional CSF-access set is intentionally absent from both assemblies. It
must be hidden by default and may appear only if a specialist-reviewed narrative
explicitly requires that concept. Its catheter form contains no clinically
meaningful length, fenestration pattern, target, trajectory, insertion depth, or
placement logic.

## Assembly exclusion contract

The assemblies contain duplicate geometry, not references to the independent
USDZ packages. For each assembly:

1. Read `component_asset_ids` and `transitive_exclusions` from the manifest.
2. If the assembly is loaded, unload or suppress every listed component package.
3. If any listed component package is loaded, suppress the containing assembly.
4. Never interpret object placement within an assembly as an operating-room tray,
   spatial registration, procedural configuration, or sequence.

The access assembly excludes these five components transitively:

- `surface_marking_ruler_set_open_neurosurgery_v3`
- `scalpel_dissector_set_open_neurosurgery_v3`
- `scalp_retractor_hemostat_set_open_neurosurgery_v3`
- `perforator_craniotome_system_open_neurosurgery_v3`
- `bone_flap_fixation_set_open_neurosurgery_v3`

The intradural/closure assembly excludes these six components transitively:

- `dural_scissors_hooks_forceps_set_open_neurosurgery_v3`
- `bipolar_forceps_irrigation_set_open_neurosurgery_v3`
- `suction_microdissector_set_open_neurosurgery_v3`
- `brain_spatula_retractor_set_open_neurosurgery_v3`
- `microscope_microinstrument_tray_open_neurosurgery_v3`
- `dural_closure_suture_patch_set_open_neurosurgery_v3`

## RealityKit and Houdini behavior contract

- Import each independent USDZ under a separate payloadable asset root.
- Default physics mode is **static visual geometry**.
- Optional user pickup/rotation may use a kinematic presentation proxy with
  conservative non-clinical bounds. Do not infer weight, balance, stiffness,
  sharpness, contact response, or compatibility from the asset.
- Do not add rigid-body drop tests, deformable tissue interaction, cutting,
  drilling, suction, irrigation, electrosurgical energy, suture tension,
  catheter insertion, or tool-tissue collision behavior.
- Do not animate working ends through anatomy. Allowed animation is limited to
  non-clinical UI highlighting, opacity focus, exploded comparison layouts, and
  returning an object to its review-table pose.
- Treat `dimensions_m` as source display bounds, not product measurements.
- Preserve metre units and Y-up orientation through Houdini/Solaris; create USDZ
  only as a final delivery package after look-development and validation.
- Keep tool roots outside patient-anatomy registration transforms unless a
  specialist-approved explanatory scene intentionally places a static tool near
  a generic layer. Such placement remains illustrative and cannot be reused for
  patient-specific guidance.

## Visual system

The editable Blender source uses procedural meshes and Principled materials:

- surgical-steel and lighter/darker steel variants for working silhouettes;
- titanium and darker recess material for the fixation concepts;
- restrained dark blue and teal polymers for grip/handle differentiation;
- deep blue-gray tray materials;
- separate cable, suture, patch, ruler, marker-ink, and irrigation-path colors.

The preview lighting was deliberately reduced after visual QA so that pale
polymer, steel highlights, small jaws, and tips remain distinguishable without
introducing blood, wounds, tissue manipulation, or other graphic imagery.

## Files

- Generator: `source/build_open_cranial_tools_v3.py`
- Editable source: `blender/open_cranial_tools_generic_v3.blend`
- Manifest: `asset_manifest_open_cranial_tools_v3.json`
- USD sources: `exports/usdc/*_open_neurosurgery_v3.usdc`
- visionOS packages: `exports/usdz/*_open_neurosurgery_v3.usdz`
- Preview evidence: `previews/open_cranial_tools_v3/`
- Reproducible validator: `source/validate_open_cranial_tools_v3.py`
- Validation report: `validation/OPEN_CRANIAL_TOOLS_ASSET_VALIDATION_V3.md`
- Machine-readable evidence: `validation/open_cranial_tools_v3_validation.json`
- Source/provenance ledger: `OPEN_CRANIAL_TOOLS_SOURCE_PROVENANCE_V3.md`

## Required human review

Before any patient-facing use, obtain review from a neurosurgeon familiar with
the selected narrative, the perioperative team, infection-control and sterile-
processing stakeholders, human-factors/accessibility specialists, privacy and
security owners, and the institution's clinical-safety/regulatory governance.
Generic atlas and instrument concepts cannot establish that open surgery is
planned, appropriate, or likely for an individual patient.
