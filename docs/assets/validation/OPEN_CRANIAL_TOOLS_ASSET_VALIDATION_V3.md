# Open-cranial tool asset validation v3

Validation date: 2026-08-08

## Outcome

**14/14 packages pass; 0 fail.**

Each package passed `/usr/bin/usdchecker --arkit --strict`, contains exactly one
embedded USD stage, declares `metersPerUnit = 1` and `upAxis = "Y"`, matches
the byte count and SHA-256 stored in the manifest, and loads through RealityKit
with nonzero model/material counts and finite positive visual bounds.

| Asset | Triangles | USDZ bytes | RK models | RK materials | RealityKit dimensions X × Y × Z (m) | Result |
|---|---:|---:|---:|---:|---:|---|
| `surface_marking_ruler_set_open_neurosurgery_v3` | 7,592 | 111,024 | 39 | 39 | 0.165606 × 0.014000 × 0.080500 | PASS |
| `scalpel_dissector_set_open_neurosurgery_v3` | 6,956 | 77,294 | 37 | 37 | 0.180397 × 0.005825 × 0.063000 | PASS |
| `scalp_retractor_hemostat_set_open_neurosurgery_v3` | 12,004 | 211,467 | 29 | 29 | 0.158718 × 0.004535 × 0.106574 | PASS |
| `perforator_craniotome_system_open_neurosurgery_v3` | 10,460 | 230,127 | 17 | 17 | 0.203174 × 0.032000 × 0.086779 | PASS |
| `bone_flap_fixation_set_open_neurosurgery_v3` | 11,796 | 101,911 | 33 | 33 | 0.148463 × 0.004875 × 0.080916 | PASS |
| `dural_scissors_hooks_forceps_set_open_neurosurgery_v3` | 3,936 | 137,957 | 12 | 12 | 0.160296 × 0.005797 × 0.106369 | PASS |
| `bipolar_forceps_irrigation_set_open_neurosurgery_v3` | 1,192 | 67,468 | 6 | 6 | 0.188360 × 0.014761 × 0.083312 | PASS |
| `suction_microdissector_set_open_neurosurgery_v3` | 4,288 | 109,288 | 18 | 18 | 0.171899 × 0.013648 × 0.066192 | PASS |
| `brain_spatula_retractor_set_open_neurosurgery_v3` | 8,616 | 73,239 | 15 | 15 | 0.179399 × 0.006097 × 0.084780 | PASS |
| `microscope_microinstrument_tray_open_neurosurgery_v3` | 5,888 | 216,537 | 17 | 17 | 0.190000 × 0.012700 × 0.108000 | PASS |
| `dural_closure_suture_patch_set_open_neurosurgery_v3` | 7,464 | 249,623 | 13 | 13 | 0.147586 × 0.004806 × 0.108998 | PASS |
| `conditional_csf_access_instrument_set_open_neurosurgery_v3` | 6,976 | 231,598 | 11 | 11 | 0.164000 × 0.011000 × 0.096364 | PASS |
| `cranial_access_tools_review_assembly_open_neurosurgery_v3` | 48,808 | 718,226 | 155 | 155 | 0.642017 × 0.032000 × 0.248000 | PASS |
| `intradural_closure_tools_review_assembly_open_neurosurgery_v3` | 31,384 | 695,304 | 81 | 81 | 0.629399 × 0.015800 × 0.279698 | PASS |

RealityKit load times were captured as diagnostic observations only. They are not
performance benchmarks and do not establish Apple Vision Pro frame-rate,
thermal, memory, accessibility, or interaction performance.

## Visual QA

Eight 1500 × 1050 PNG previews in `previews/open_cranial_tools_v3/` were
individually inspected. The corrected assembly renders keep all duplicated
component groups within frame. Materials remain visually distinct, working-end
silhouettes are readable, and the conditional CSF-access set is clearly isolated
from both assemblies.

## Assembly and pathway QA

- Independent packages: 12.
- Review-only assemblies: 2.
- Each assembly lists its direct components in both `component_asset_ids` and
  `transitive_exclusions`; applications must never co-load those components.
- The conditional CSF-access set is absent from both assemblies.
- Every record is `open_neurosurgery_only`, requires the
  `clinician_selected_hemorrhage_or_decompression_only` narrative gate, sets
  `default_thrombectomy_pathway_allowed = false`, and prohibits the default
  endovascular thrombectomy pathway.

## SHA-256

```text
2f7aefb347a3eb87c4fe921eca8d00ca418ebe65d8a2b3ca6f4847cfc55043d6  surface_marking_ruler_set_open_neurosurgery_v3.usdz
456df6dae1e5241c4535e4f6bcb4ac3e5c193974ec2496b592bb47abef03900a  scalpel_dissector_set_open_neurosurgery_v3.usdz
efb8e92c00b788969c5239a214c57e8d0626bda530aefc9f79a9d31a1d1bed38  scalp_retractor_hemostat_set_open_neurosurgery_v3.usdz
14407122ef78a7f5a3b37908140de71f9022a880bd9c5dca98ff74a63357077e  perforator_craniotome_system_open_neurosurgery_v3.usdz
217c36a70010bc4afb9df40d70c8a36dfae01c1f02160f788b9d3a9a20ac97b9  bone_flap_fixation_set_open_neurosurgery_v3.usdz
4a076849cf44ca737ba53ca2093d8df793129b0a11b003c448e1f809434f1b8d  dural_scissors_hooks_forceps_set_open_neurosurgery_v3.usdz
66a0bf8cd1209e9903cd1689a42caa70b30832b910f2f2f80823c2a0fda367bf  bipolar_forceps_irrigation_set_open_neurosurgery_v3.usdz
07bebc78c548b9e7971cfe6c250b6280414d3de23fe80915a58f5192bc0302d3  suction_microdissector_set_open_neurosurgery_v3.usdz
261c2b6880d256686776b83c4393520d372d3c320d763d286829130e977ced84  brain_spatula_retractor_set_open_neurosurgery_v3.usdz
2702a95c5211fb74d733ad0d174811b87ac7125e64c90b6843919e40914ec85c  microscope_microinstrument_tray_open_neurosurgery_v3.usdz
63ce6d2930de6b05658e6b748058d4a2a7e71c0488e72139d3ab6213497e907c  dural_closure_suture_patch_set_open_neurosurgery_v3.usdz
b5bdb73b68a4bc182b33b82a7eabae66d694255cd938cd176affbc1bca171d68  conditional_csf_access_instrument_set_open_neurosurgery_v3.usdz
6226e220345561f40990920846912ae4516bc2ce426c97d069613aeec943bc3c  cranial_access_tools_review_assembly_open_neurosurgery_v3.usdz
769e3dff8befa9b8c774df8f860258db977f943c46ec14c7f107785e298cbbae  intradural_closure_tools_review_assembly_open_neurosurgery_v3.usdz
```

## Scope of this result

This is technical and visual validation of generic, unbranded educational assets.
It does not validate surgical accuracy, completeness of an instrument tray,
sterility, compatibility, device performance, clinical sequence, patient
comprehension, or suitability for any patient. The assets are not instructions,
training, planning, navigation, sizing, or clinical-decision tools. Specialist
and institutional review remains required before patient-facing use.
