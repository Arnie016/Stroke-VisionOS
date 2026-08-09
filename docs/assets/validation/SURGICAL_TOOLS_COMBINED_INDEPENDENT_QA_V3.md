# Surgical tools v3 — combined independent QA

Validated: 2026-08-09 SGT

Scope: `endovascular_tools_v3` and `open_cranial_tools_v3`

Baseline collision set: 110 existing manifest records

Tools under test: 26 packages (22 independent packages and 4 review assemblies)

## Verdict

**Independent technical, visual, manifest, and workflow-contract gate: PASS
(26/26 packages; 0 technical blockers).**

- 26/26 USDZ packages passed `/usr/bin/usdchecker --arkit --strict` with exit
  code 0.
- 26/26 sibling USDC stages also passed the same strict check.
- 26/26 USDZ packages loaded through RealityKit
  `Entity.load(contentsOf:)` with nonzero entity, model, mesh, and material
  counts and finite positive bounds on every axis.
- All 26 recorded byte counts and SHA-256 values match the current files.
- All 26 USDC and USDZ paths exist, use the exact asset ID as the filename, and
  use lowercase snake-case versioned IDs.
- All 26 packages contain exactly one embedded USDC, declare
  `defaultPrim = "Asset"`, `metersPerUnit = 1`, and `upAxis = "Y"`, and contain
  no camera, light, absolute asset path, external reference, payload, or other
  file dependency.
- The 26 new IDs are unique internally and have no collision with the existing
  110-record catalog; the combined namespace is 136/136 unique IDs.
- All 20 supplied final previews were inspected at original resolution: twelve
  1400 x 950 endovascular frames and eight 1500 x 1050 open-cranial frames.

**Clinical-validity gate: NOT PASSED and outside this technical asset audit.**
These are generic educational concepts. They are not validated procedure
models, operative instructions, device replicas, patient-specific anatomy,
training simulators, planning/navigation tools, or evidence that any procedure
or instrument is suitable for a patient. Specialist and institutional review
remains mandatory before patient-facing deployment.

## Evidence and environment

- Apple USD Tools: 0.25.2
- RealityKit probe: `research/realitykit_load_probe.swift`
- Swift: Apple Swift 6.4, arm64 macOS target
- Host: macOS 26.6 (25G72)
- Authoring source version recorded by the manifests: Blender 5.2.0 LTS
- Endovascular manifest SHA-256:
  `b692a80eb7d6685e86656a7d5265c04cc67bfc2303445aa79d61dd84985ca4da`
- Open-cranial manifest SHA-256:
  `32be4a4a1cf789bdfa636f4279604fd71dc8a9fe2546569ecef8c179cd0cd8ff`
- Stage-map SHA-256:
  `cf87429ff74193558dec5faad3963a254c7595c1d36040c6a6ccd8bcd51a9d4d`

The strict checks and RealityKit loads in this report were run independently of
the module builders' own validation reports.

## Count, naming, and catalog audit

| Module | Independent | Review assemblies | Total | Packaged triangles | USDZ bytes |
|---|---:|---:|---:|---:|---:|
| Endovascular tools | 10 | 2 | 12 | 315,872 | 5,105,172 |
| Conditional open-cranial tools | 12 | 2 | 14 | 167,360 | 3,231,063 |
| **Combined** | **22** | **4** | **26** | **483,232** | **8,336,235** |

The packaged totals include duplicate geometry inside the four review
assemblies. They are catalog/package sums, not a simultaneous runtime budget.
The 22 independent packages alone total 223,028 triangles and 4,108,559 USDZ
bytes.

Every ID:

- is lowercase snake case and ends in `_v3`;
- is unique across the new modules;
- is absent from the prior 110 IDs (29 prototype-v1, 36 realistic-v2, and 45
  intracranial-detail-v3 records);
- has matching `<id>.usdc` and `<id>.usdz` basenames;
- has a nonempty title, description, stage association, and explicit safety
  status.

## Package integrity ledger

All paths below are relative to `vision_pro_stroke_kit_v2/`. Full SHA-256 values
were recomputed from the USDZ bytes and compared with the manifests.

| Asset ID | USDZ path | Bytes | SHA-256 |
|---|---|---:|---|
| `vascular_access_needle_educational_v3` | `exports/usdz/vascular_access_needle_educational_v3.usdz` | 118,892 | `8f081d4418d4aaf64f15dd26f91c3a9cecd9ee8de51b4841b0262eaeb26ea145` |
| `vascular_access_wire_educational_v3` | `exports/usdz/vascular_access_wire_educational_v3.usdz` | 128,172 | `50453ce07f6f767b31d1eca52a75f805b2f83c92f816fd8a431d721c6c78b1b1` |
| `introducer_sheath_dilator_set_educational_v3` | `exports/usdz/introducer_sheath_dilator_set_educational_v3.usdz` | 244,844 | `22fa743e25d2b56f617776fa23affeea819133293f98c540e9b9725beec0464b` |
| `guide_catheter_hemostatic_valve_educational_v3` | `exports/usdz/guide_catheter_hemostatic_valve_educational_v3.usdz` | 236,332 | `e984cb7c7a7a531431745221028f7965b904973e95c2678b0861ce4afa15759e` |
| `aspiration_pump_canister_tubing_educational_v3` | `exports/usdz/aspiration_pump_canister_tubing_educational_v3.usdz` | 255,062 | `8eca2d303e7f9f9ae4e79785a4cc88176a7f4440bff0a5b4b361a8f4844c9748` |
| `contrast_manifold_syringe_flush_educational_v3` | `exports/usdz/contrast_manifold_syringe_flush_educational_v3.usdz` | 332,780 | `734924e487c4c7c32b257be9832454cd98ed8f49bf9741faf3499a47a1d39249` |
| `torque_device_y_connector_accessories_educational_v3` | `exports/usdz/torque_device_y_connector_accessories_educational_v3.usdz` | 318,849 | `b94e43ff505a2257c313bf25b2538c1ff3400aab29de875421d017484e32729c` |
| `puncture_site_hemostasis_options_educational_v3` | `exports/usdz/puncture_site_hemostasis_options_educational_v3.usdz` | 282,390 | `83798a963dab5d983be8dc1eb7afa19eefa6f9e14645f11fb9d32b73e1269dd2` |
| `sterile_endovascular_instrument_tray_educational_v3` | `exports/usdz/sterile_endovascular_instrument_tray_educational_v3.usdz` | 296,056 | `d5aa8497a8d0f8bc0d890deee11d5463e86580ec55742e789b17236a1f904fa2` |
| `angiography_suite_controls_educational_v3` | `exports/usdz/angiography_suite_controls_educational_v3.usdz` | 77,649 | `cf5971a2e99191a2f94313aacdac47b7be60832594012761bd30427fe890de3c` |
| `vascular_access_setup_review_assembly_v3` | `exports/usdz/vascular_access_setup_review_assembly_v3.usdz` | 722,963 | `00b47c24bb0b2ab15e6790695e213489ba7346b874be86f07fb80ee5380ac492` |
| `endovascular_tools_workflow_review_assembly_v3` | `exports/usdz/endovascular_tools_workflow_review_assembly_v3.usdz` | 2,091,183 | `624602f7429d77e4b6768b67bc308b5890a8a1dd8193957f506662a89c80ab76` |
| `surface_marking_ruler_set_open_neurosurgery_v3` | `exports/usdz/surface_marking_ruler_set_open_neurosurgery_v3.usdz` | 111,024 | `2f7aefb347a3eb87c4fe921eca8d00ca418ebe65d8a2b3ca6f4847cfc55043d6` |
| `scalpel_dissector_set_open_neurosurgery_v3` | `exports/usdz/scalpel_dissector_set_open_neurosurgery_v3.usdz` | 77,294 | `456df6dae1e5241c4535e4f6bcb4ac3e5c193974ec2496b592bb47abef03900a` |
| `scalp_retractor_hemostat_set_open_neurosurgery_v3` | `exports/usdz/scalp_retractor_hemostat_set_open_neurosurgery_v3.usdz` | 211,467 | `efb8e92c00b788969c5239a214c57e8d0626bda530aefc9f79a9d31a1d1bed38` |
| `perforator_craniotome_system_open_neurosurgery_v3` | `exports/usdz/perforator_craniotome_system_open_neurosurgery_v3.usdz` | 230,127 | `14407122ef78a7f5a3b37908140de71f9022a880bd9c5dca98ff74a63357077e` |
| `bone_flap_fixation_set_open_neurosurgery_v3` | `exports/usdz/bone_flap_fixation_set_open_neurosurgery_v3.usdz` | 101,911 | `217c36a70010bc4afb9df40d70c8a36dfae01c1f02160f788b9d3a9a20ac97b9` |
| `dural_scissors_hooks_forceps_set_open_neurosurgery_v3` | `exports/usdz/dural_scissors_hooks_forceps_set_open_neurosurgery_v3.usdz` | 137,957 | `4a076849cf44ca737ba53ca2093d8df793129b0a11b003c448e1f809434f1b8d` |
| `bipolar_forceps_irrigation_set_open_neurosurgery_v3` | `exports/usdz/bipolar_forceps_irrigation_set_open_neurosurgery_v3.usdz` | 67,468 | `66a0bf8cd1209e9903cd1689a42caa70b30832b910f2f2f80823c2a0fda367bf` |
| `suction_microdissector_set_open_neurosurgery_v3` | `exports/usdz/suction_microdissector_set_open_neurosurgery_v3.usdz` | 109,288 | `07bebc78c548b9e7971cfe6c250b6280414d3de23fe80915a58f5192bc0302d3` |
| `brain_spatula_retractor_set_open_neurosurgery_v3` | `exports/usdz/brain_spatula_retractor_set_open_neurosurgery_v3.usdz` | 73,239 | `261c2b6880d256686776b83c4393520d372d3c320d763d286829130e977ced84` |
| `microscope_microinstrument_tray_open_neurosurgery_v3` | `exports/usdz/microscope_microinstrument_tray_open_neurosurgery_v3.usdz` | 216,537 | `2702a95c5211fb74d733ad0d174811b87ac7125e64c90b6843919e40914ec85c` |
| `dural_closure_suture_patch_set_open_neurosurgery_v3` | `exports/usdz/dural_closure_suture_patch_set_open_neurosurgery_v3.usdz` | 249,623 | `63ce6d2930de6b05658e6b748058d4a2a7e71c0488e72139d3ab6213497e907c` |
| `conditional_csf_access_instrument_set_open_neurosurgery_v3` | `exports/usdz/conditional_csf_access_instrument_set_open_neurosurgery_v3.usdz` | 231,598 | `b5bdb73b68a4bc182b33b82a7eabae66d694255cd938cd176affbc1bca171d68` |
| `cranial_access_tools_review_assembly_open_neurosurgery_v3` | `exports/usdz/cranial_access_tools_review_assembly_open_neurosurgery_v3.usdz` | 718,226 | `6226e220345561f40990920846912ae4516bc2ce426c97d069613aeec943bc3c` |
| `intradural_closure_tools_review_assembly_open_neurosurgery_v3` | `exports/usdz/intradural_closure_tools_review_assembly_open_neurosurgery_v3.usdz` | 695,304 | `769e3dff8befa9b8c774df8f860258db977f943c46ec14c7f107785e298cbbae` |

## USD and RealityKit audit

For each of the 26 USDZ packages:

1. `/usr/bin/usdchecker --arkit --strict` returned success and exit code 0.
2. The ZIP directory contains one safe relative member named `<id>.usdc` and
   no texture, nested package, absolute path, or traversal entry.
3. The composed stage has an `/Asset` default prim, metre units, and Y-up
   orientation.
4. USDA inspection found no `Camera` or light prim and no authored external
   reference/payload or absolute asset literal.
5. RealityKit loaded the package with nonzero renderable content and finite,
   positive bounds.
6. Parsed mesh counts and triangle counts match the sibling USDC and the
   manifest. Material and Xform counts also match between the sibling USDC and
   packaged root.

### Separate-export serialization observation

The Blender generators export the sibling USDC and USDZ in separate export
operations. Twelve packaged roots are byte-identical to their sibling USDC;
fourteen are not byte-identical because auto-numbered child prim order/names can
serialize differently between the two operations.

This is **not a current blocker**:

- all 26 sibling and packaged stages have matching mesh, triangle, material,
  and Xform counts;
- the parsed triangle count equals the manifest for all 26;
- `usdrecord` produced byte-identical reference renders for every one of the 14
  serialization-divergent pairs;
- both forms pass strict USD validation.

Downstream Houdini or RealityKit logic should bind to each package's stable
`/Asset` root and semantic manifest ID. Do not treat auto-numbered child prim
paths as a stable API. A future reproducibility cleanup may package the already
exported USDC instead of invoking a second exporter pass.

## Assembly and duplicate-geometry audit

### Endovascular

- `vascular_access_setup_review_assembly_v3` contains four independent
  packages and excludes those four while active.
- `endovascular_tools_workflow_review_assembly_v3` contains all ten independent
  packages and excludes all ten plus the access review assembly.
- Every independent endovascular package reciprocally prohibits the relevant
  containing assembly.
- The complete workflow assembly's 135,860 triangles equal the sum of the ten
  independent packages; it adds no unique tool category.

### Open cranial

- `cranial_access_tools_review_assembly_open_neurosurgery_v3` lists five direct
  components, and its `component_asset_ids` exactly equal its
  `transitive_exclusions`.
- `intradural_closure_tools_review_assembly_open_neurosurgery_v3` lists six
  direct components, and its `component_asset_ids` exactly equal its
  `transitive_exclusions`.
- Each of those eleven independent components points back to the correct
  mutually exclusive review assembly.
- `conditional_csf_access_instrument_set_open_neurosurgery_v3` is not a member
  of either assembly and has no assembly back-reference.

The four review assemblies are review conveniences only. Runtime experiences
should load independent packages by explanatory state and must not co-load an
assembly with any direct or transitive component.

## Hard clinical pathway gate

### Ordinary endovascular thrombectomy

**Data-contract result: PASS.**

- The endovascular module contains ten generic independent support categories
  and two review assemblies; it contains no open-cranial tool, craniotomy,
  craniectomy, EVD, ventricular-catheter, or head-dressing asset.
- A word-boundary scan of all endovascular asset records and exported USD
  metadata found no open-cranial/EVD/head-dressing term or component.
- `surgical_tool_stage_map_v3.json` declares
  `ordinary_evt_has_craniotomy = false` and
  `ordinary_evt_has_head_dressing = false`.
- Its `EVT-09_POST_PROCEDURE` state deactivates `OpenCranialRoot`,
  `postoperative_head_dressing`, `optional_evd_system`, and all active procedure
  tools.
- All ten independent endovascular IDs are mapped to at least one EVT stage;
  no open-neurosurgery ID appears in any EVT candidate list.
- The puncture-site hemostasis package includes access-site dressings as
  alternatives/adjuncts. It is explicitly access-site—not a postoperative head
  dressing—and does not encode a mandatory closure method or sequence.

### Conditional open-neurosurgery branch

**Data-contract result: PASS (14/14 records).** Every open record has:

- `procedure_scope = open_neurosurgery_only`;
- `default_thrombectomy_pathway_allowed = false`;
- `narrative_gate = clinician_selected_hemorrhage_or_decompression_only`;
- both `default_endovascular_thrombectomy` and `ordinary_ischemic_evt` in
  `prohibited_pathways`;
- `patient_specific = false` and `device_specific = false`;
- `clinical_review_status = REQUIRES_SPECIALIST_REVIEW`;
- `not_for_surgical_training = true`;
- `not_for_navigation = true`;
- `not_for_device_selection_or_sizing = true`;
- `no_force_depth_trajectory_energy_claims = true`.

The stage map defaults the open-cranial root to unloaded, maps all 14 records to
the separate conditional branch, and requires
`clinician_selected_hemorrhage_or_decompression`. Metadata is not a substitute
for runtime enforcement: a patient-facing app must enforce this gate in its
state machine and must not merely display it as a caption.

### Conditional CSF-access set

**Isolation result: PASS.** The record is `conditional_only = true`, is absent
from both assemblies and all their transitive-exclusion/component lists, and is
mapped only to the optional CSF/EVD narrative. It must remain hidden by default,
must replace rather than duplicate any older optional EVD representation, and
must never appear in ordinary EVT.

## Endovascular generic/device-safety audit

All 12 endovascular records are:

- `patient_specific = false`;
- `device_specific = false`;
- `manufacturer_specific = false`;
- `training_status = NOT_VALIDATED_FOR_PROCEDURAL_TRAINING`;
- marked not for device selection, sizing, navigation, or treatment planning;
- described as visually plausible educational categories rather than cleared
  or marketed devices.

Every record states that its source bounds are not manufacturer dimensions.
Module rules keep access route, anesthesia/sedation, reperfusion technique,
contrast/flush protocol, imaging controls, and puncture-site hemostasis as
clinician-selected or locally dependent options. The models contain no brand,
logo, product label, dose, functional control legend, proprietary screen, or
manufacturer-specific dimension claim.

## Preview audit

### Endovascular previews — 12/12 inspected

- Resolution: 1400 x 950 RGB PNG.
- Silhouettes, material separation, small connectors, distal tips, tubing,
  manifold/syringe forms, tray, pump/canister, and controls are readable.
- No missing-material magenta, broken transparency, clipped package, external
  image, logo, brand marking, numeric dose, or functional UI label was visible.
- The access and complete-workflow assembly frames include the intended groups
  without implying a registered sterile field.
- The complete workflow layout is a category gallery, not an encoded procedure
  or required inventory.

### Open-cranial previews — 8/8 inspected

- Resolution: 1500 x 1050 PNG.
- Both assembly frames keep their component groups in frame and retain readable
  steel/polymer separation.
- Perforator/craniotome, dural instruments, bipolar/irrigation, microscope tray,
  closure set, and conditional CSF-access silhouettes are readable at original
  resolution.
- No blood, wound, tissue penetration, graphic manipulation, missing material,
  product logo, calibrated measurement claim, or commercial control interface
  was visible.
- The conditional CSF-access preview is separate and that set is visibly absent
  from both assembly previews.

The eight open-cranial previews are representative evidence rather than one
dedicated image for every one of the fourteen packages. This matches the
supplied preview set and is not a technical blocker, but a future catalog UI may
benefit from dedicated thumbnails for the six packages currently shown only in
an assembly or not given their own final frame.

## Physics and behavior boundary

- Default behavior is static presentation geometry.
- Optional app-owned transforms may be kinematic only and cannot be called
  validated device or tissue behavior.
- No puncture, insertion, wire/catheter navigation, aspiration, pressure, flow,
  contrast injection, radiation, drilling, cutting, retraction, electrosurgical
  energy, irrigation, suction, suture tension, catheter trajectory, tissue
  deformation, vessel contact, or sterile-field physics are encoded.
- Canister and syringe contents are static visual geometry.
- `dimensions_m` are generic source/presentation bounds, not clinical or
  manufacturer measurements.

## Blockers and release interpretation

### Asset commit / educational review catalog

**No technical blocker found.** The 26 packages and their current manifests are
internally consistent and suitable for inclusion as explicitly generic,
specialist-review-required educational assets, subject to the assembly and
branch gates above.

### Patient-facing or hospital deployment

**Blocked pending work outside this asset QA.** At minimum, deployment requires
specialist review of the selected narrative and visuals, institutional clinical
safety/governance, accessibility and human-factors testing, privacy/security
review, workflow-state enforcement testing, and any applicable regulatory
assessment. This report does not establish instrument completeness, operative
accuracy, sterile processing, device compatibility, training validity, patient
comprehension, or patient safety.
