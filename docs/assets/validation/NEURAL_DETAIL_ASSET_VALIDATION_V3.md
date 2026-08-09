# Neural-detail asset validation v3

Validated: 2026-08-08 SGT
Manifest: `asset_manifest_neural_detail_v3.json`
Module: `neural_detail_v3`

## Verdict

**Technical asset gate: PASS (15/15).** The manifest contains 14 independently
loadable anatomy assets plus one registered review assembly. Every declared USDC
and USDZ exists; all USDZ byte counts and SHA-256 values match the manifest;
strict Apple USD/ARKit checking passes; each package has positive geometry and
bounds; and RealityKit loads every package with nonzero model, mesh, material,
and visual-bound counts.

**Source-faithfulness gate: PASS for the scoped generic atlas derivative.** The
unmodified HRA source has 283 meshes. The build selects 275 and explicitly records
the eight overlapping broad/alternate meshes it omits. No pituitary, choroid
plexus, CSF dynamics, microscopic neural geometry, patient anatomy, or inferred
missing anatomy was fabricated.

**Visual-polish gate: PASS for the labelled atlas prototype.** Seven 1400 × 1400
previews show coherent cortical, medial, cerebellar/brainstem, deep-nucleus,
ventricular/pathway, white-matter, and unilateral-review presentations. Original-
resolution review found no missing-material magenta, black geometry, exploded
transforms, NaN-style corruption, transparent-layer sorting, or packaged preview
lighting.

This is technical and visual QA, not clinical validation. Nothing in this report
clears the assets for diagnosis, treatment planning, navigation, device placement,
clinical decision support, or unsupervised patient counselling.

## Environment and method

- Blender 5.2.0 LTS
- Apple USD Tools `/usr/bin/usdchecker`
- Strict check: `usdchecker --arkit --strict <asset.usdz>`
- Stage inspection: `/usr/bin/usdcat`
- Archive inspection: `unzip -Z1`
- Runtime decode: `research/realitykit_load_probe.swift`, compiled with Foundation
  and RealityKit and run on an isolated directory containing only these 15 USDZs
- Preview inspection: seven 1400 × 1400 PNGs at original resolution

## Manifest and geometry results

The independent packages retain 275 named source meshes and total 512,015 runtime
triangles after group-aware LOD. The unilateral assembly contains 219 model meshes
and 279,788 triangles. All 15 USDZs total 37,449,313 bytes.

| Asset ID | Models | Triangles | USDZ bytes | Source dimensions X × Y × Z (m) |
|---|---:|---:|---:|---|
| `frontal_cortex_parcellation_v3` | 28 | 89,970 | 4,268,919 | 0.124971 × 0.146673 × 0.118115 |
| `parietal_cortex_parcellation_v3` | 14 | 59,992 | 2,848,864 | 0.132402 × 0.093535 × 0.078698 |
| `temporal_cortex_parcellation_v3` | 16 | 54,982 | 2,610,969 | 0.136377 × 0.104001 × 0.062709 |
| `occipital_cortex_parcellation_v3` | 12 | 44,988 | 2,136,386 | 0.106952 × 0.072703 × 0.066561 |
| `insular_opercular_cortex_v3` | 12 | 9,320 | 442,994 | 0.096223 × 0.059442 × 0.045596 |
| `cingulate_parahippocampal_cortex_v3` | 22 | 25,208 | 1,193,587 | 0.084600 × 0.124213 × 0.080052 |
| `cerebellar_substructures_v3` | 14 | 42,856 | 2,035,606 | 0.107867 × 0.061186 × 0.063270 |
| `brainstem_substructures_v3` | 22 | 7,838 | 371,178 | 0.040171 × 0.031542 × 0.067652 |
| `basal_ganglia_deep_nuclei_v3` | 22 | 24,626 | 1,163,832 | 0.070410 × 0.062569 × 0.046680 |
| `thalamic_hypothalamic_nuclei_v3` | 42 | 15,502 | 727,356 | 0.048535 × 0.043197 × 0.034063 |
| `hippocampal_amygdala_limbic_nuclei_v3` | 30 | 11,228 | 528,357 | 0.069425 × 0.050388 × 0.048891 |
| `ventricular_spaces_v3` | 18 | 16,602 | 786,951 | 0.074908 × 0.128477 × 0.101773 |
| `major_white_matter_regions_v3` | 4 | 89,997 | 4,210,537 | 0.129587 × 0.159888 × 0.134726 |
| `commissural_sensory_pathways_v3` | 19 | 18,906 | 889,515 | 0.065321 × 0.099860 × 0.050886 |
| `neural_detail_registered_review_assembly_v3` | 219 | 279,788 | 13,234,262 | 0.120612 × 0.166051 × 0.146118 |

All byte counts and hashes were recomputed after the final lighting rebuild and
match the current manifest exactly (15 pass, 0 fail).

## Apple USD/ARKit and package inspection

All 15 `usdchecker --arkit --strict` invocations returned exit code 0 and
`Success!`. Stage inspection found `defaultPrim = "Asset"`, `metersPerUnit = 1`,
and `upAxis = "Y"` in every package. Mesh prim counts match the manifest model
counts. No Camera or light prim, absolute local asset reference, animation, world
payload, EXR, or external texture reference was found. Each USDZ contains exactly
one package-local USDC member.

## RealityKit runtime results

| Package | Result | Models/materials | Runtime dimensions X × Y × Z (m) | Load time (ms) |
|---|---|---:|---|---:|
| `basal_ganglia_deep_nuclei_v3.usdz` | PASS | 22 / 22 | 0.070410 × 0.046680 × 0.062569 | 7,919.2 |
| `brainstem_substructures_v3.usdz` | PASS | 22 / 22 | 0.040171 × 0.067652 × 0.031542 | 1,354.2 |
| `cerebellar_substructures_v3.usdz` | PASS | 14 / 14 | 0.107867 × 0.063270 × 0.061186 | 2,507.0 |
| `cingulate_parahippocampal_cortex_v3.usdz` | PASS | 22 / 22 | 0.084600 × 0.080052 × 0.124213 | 768.0 |
| `commissural_sensory_pathways_v3.usdz` | PASS | 19 / 19 | 0.065321 × 0.050886 × 0.099860 | 293.9 |
| `frontal_cortex_parcellation_v3.usdz` | PASS | 28 / 28 | 0.124971 × 0.118115 × 0.146673 | 396.1 |
| `hippocampal_amygdala_limbic_nuclei_v3.usdz` | PASS | 30 / 30 | 0.069425 × 0.048891 × 0.050388 | 222.1 |
| `insular_opercular_cortex_v3.usdz` | PASS | 12 / 12 | 0.096223 × 0.045596 × 0.059442 | 128.2 |
| `major_white_matter_regions_v3.usdz` | PASS | 4 / 4 | 0.129587 × 0.134726 × 0.159888 | 422.6 |
| `neural_detail_registered_review_assembly_v3.usdz` | PASS | 219 / 219 | 0.120612 × 0.146118 × 0.166051 | 3,490.8 |
| `occipital_cortex_parcellation_v3.usdz` | PASS | 12 / 12 | 0.106952 × 0.066561 × 0.072703 | 323.2 |
| `parietal_cortex_parcellation_v3.usdz` | PASS | 14 / 14 | 0.132402 × 0.078698 × 0.093535 | 515.8 |
| `temporal_cortex_parcellation_v3.usdz` | PASS | 16 / 16 | 0.136377 × 0.062709 × 0.104001 | 322.8 |
| `thalamic_hypothalamic_nuclei_v3.usdz` | PASS | 42 / 42 | 0.048535 × 0.034063 × 0.043197 | 692.4 |
| `ventricular_spaces_v3.usdz` | PASS | 18 / 18 | 0.074908 × 0.101773 × 0.128477 | 364.3 |

The probe loaded files alphabetically in one process. The first two cold loads are
not performance benchmarks. Desktop RealityKit success does not establish Vision
Pro startup time, peak memory, thermal behaviour, or frame-rate suitability.

## Preview review

| Preview | Visual check | Result |
|---|---|---|
| `30_cortical_parcellation_lateral_v3.png` | Complete bilateral cortical parcel surface, coherent sulcal separations and restrained tissue material | PASS |
| `31_medial_insular_cortex_v3.png` | Medial/insular pieces remain source-registered and individually readable without invented connecting tissue | PASS |
| `32_cerebellum_brainstem_v3.png` | Cerebellar and brainstem source pieces are coherent at the atlas registration and show no transform explosion | PASS |
| `33_deep_nuclei_limbic_v3.png` | Nested deep-source pieces remain distinguishable with opaque materials | PASS |
| `34_ventricles_pathways_v3.png` | Ventricular spaces and pathway surfaces are visually differentiated; no claim of fluid physics | PASS |
| `35_major_white_matter_v3.png` | Broad white-matter hierarchy level renders intact and is kept separate from tract interpretation | PASS |
| `36_registered_neural_review_assembly_v3.png` | Unilateral opaque cortex exposes deep anatomy without alpha sorting or broad-white-matter occlusion | PASS |

## Release boundary

The 15 assets are technically sound and suitable for integration into the generic
prototype behind explicit atlas/non-patient warnings. Before any hospital or
doctor-facing deployment they still require neuroanatomy review, stroke-team
workflow review, human-factors/accessibility testing, patient-comprehension review,
data-governance review, and profiling on the physical target hardware. A hospital
setting does not make these reference assets diagnostic or planning-grade.
