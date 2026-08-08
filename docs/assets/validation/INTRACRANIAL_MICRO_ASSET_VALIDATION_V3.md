# Intracranial micro-detail asset validation v3

Validated: 2026-08-08 SGT
Manifest: `asset_manifest_intracranial_micro_v3.json`
Module: `intracranial_micro_v3`
Scope: 12 USDZ packages and 12 supplied preview PNGs

## Verdict

**Technical package gate: PASS (12/12).** Every declared USDC and USDZ exists.
All declared USDZ byte counts and SHA-256 values match the files. All twelve
invocations of `/usr/bin/usdchecker --arkit --strict` returned exit code 0 and
`Success!`. Every package has `defaultPrim = "Asset"`, `metersPerUnit = 1`, and
`upAxis = "Y"`; contains one root USDC; has no camera, light, world/EXR member,
absolute file reference, or unresolved external dependency; and loads through
RealityKit with nonzero models, meshes, materials, and finite positive bounds.

**Supplied-preview visual gate: PASS for gross geometry and material integrity.**
All twelve 1600 × 1100 PNGs were inspected at original resolution. The supplied
views show no missing-material magenta, black or NaN-style corruption, exploded
transforms, clipped hero geometry, transparent-layer sorting error, camera/light
object, or obvious texture failure. The vessel and synapse cutaways expose their
interior teaching cues cleanly.

**Per-package preview-coverage gate: PASS (12/12).** Dedicated original-resolution
close-ups now cover the capillary-endothelium/tight-junction, astrocyte/endfeet,
and myelinated-axon/node-of-Ranvier packages. Their target structures are readable
without material failure, transform corruption, or clinically misleading
photorealism. Together with the original nine frames, every package now has
independent close-range or assembly-level visual evidence appropriate to this
conceptual teaching scope.

**Patient-facing interpretation and clinical gate: HOLD.** The assets correctly
declare themselves generic, magnified, scale-separated, non-patient,
non-histologic, and non-quantitative. The geometry is visibly illustrative rather
than microscopy. However, none of the twelve supplied PNGs visibly renders the
required magnification/nonquantitative warning. The textured thrombus, repeated
blood elements, CSF arrows, and nested ischemic zones could still be read as
literal composition, counts, direction, spatial extent, or patient findings if a
viewer hides the manifest/accessibility metadata. Do not clear these assets for
patient presentation until the consuming experience persistently displays
“magnified teaching model — not to anatomical scale” and “conceptual,
nonquantitative, not patient-specific,” and the named specialist reviews in the
manifest are complete. This report does not validate anatomy, histology,
pathology, physiology, diagnosis, treatment planning, or clinical safety.

## Method and environment

- Blender provenance recorded by the USD stages: 5.2.0 LTS.
- Manifest integrity: `jq`, `stat`, and `/usr/bin/shasum -a 256`.
- Strict Apple USD/ARKit validation:
  `/usr/bin/usdchecker --arkit --strict <package.usdz>`.
- Stage inspection: `/usr/bin/usdcat`.
- Package-member inspection: `unzip -Z1` and `unzip -p`.
- Runtime decode: `research/realitykit_load_probe.swift`, compiled with macOS
  Foundation and RealityKit, then run against an isolated directory containing
  only the twelve scoped USDZs.
- Visual inspection: all twelve PNGs in `previews/intracranial_micro_v3/` at their
  original 1600 × 1100 resolution.

## Manifest, identity, and hash evidence

The manifest has twelve unique IDs, twelve unique USDC paths, twelve unique USDZ
paths, twelve unique package filenames, and twelve unique USDZ hashes. Every USDZ
basename equals its asset ID. All required semantic and integrity fields are
present; all dimensions, byte counts, and triangle counts are positive. Every
asset consistently declares:

- `module = "intracranial_micro_v3"`
- `scale_domain = "microscopic_conceptual_separate"`
- `magnification_label_required = true`
- `registered_to_head = false`
- `patient_specific = false`
- `histology_validated = false`
- `quantitative = false`
- `clinical_review_status = "REQUIRES_SPECIALIST_REVIEW"`

| Asset ID | USDZ bytes | SHA-256 | Strict check |
|---|---:|---|---|
| `blood_brain_barrier_neurovascular_unit_conceptual_v3` | 549,906 | `303d5f0d62876abaa5443cf825eb4e5830ae9497e642576b6b94ca5a6ab6c22d` | PASS |
| `capillary_endothelium_tight_junctions_conceptual_v3` | 124,893 | `d750fe1c6b434e803266adc0872a3200322d822f202c7853d6a110feb705966b` | PASS |
| `formed_blood_elements_magnified_v3` | 351,257 | `0e4830d646b7abe696e5d458161206eb43680632eb284622539f9c157a6ab18a` | PASS |
| `platelet_fibrin_thrombus_microstructure_conceptual_v3` | 5,058,520 | `a107c72697e061b9a51582bb045b642d5fc3c702de092b124d61f6a9b8c5c897` | PASS |
| `multipolar_neuron_detailed_conceptual_v3` | 213,065 | `11aa857a443a4cbfd80288032017c4807b4631a5d83f69094ed3c6f195f3ae68` | PASS |
| `astrocyte_capillary_endfeet_conceptual_v3` | 136,178 | `717c6d7aa439f6ecc5f283e99151244356f2c81dad7dde650aa9ca0e714380fb` | PASS |
| `oligodendrocyte_myelinated_axons_conceptual_v3` | 1,918,864 | `d06c34d6b52f81be510d4e5a813ef6935989a79f0b2d990669c74a6ee000a6e7` | PASS |
| `myelinated_axon_node_of_ranvier_conceptual_v3` | 1,906,402 | `8430d771e3c263a10f35af845eda1468841d7381f125fe3c7f9c673778d57601` | PASS |
| `chemical_synapse_closeup_conceptual_v3` | 175,142 | `69b7ce4d7e8e332abc83d871fa4cedd5149c1e54241b8acebc0b5622a73df203` | PASS |
| `choroid_plexus_csf_interface_conceptual_v3` | 147,495 | `7a318a4e4f2030b42cc52e064bb91d83599a685d2305199298970f4e5ed9753a` | PASS |
| `ischemic_tissue_zones_conceptual_v3` | 2,522,734 | `ee9c47fb7ccf62078a5fb5064d931951d87a0f74ac1bd3c59a7df3a3e68c3c25` | PASS |
| `intracranial_micro_teaching_set_v3` | 11,199,963 | `2812f5a93502e68481a2a07bfbd597acfd8dbe0a1d7e6a19a48adb4352655198` | PASS |

Total scoped USDZ size is **24,304,419 bytes**.

The eleven independent packages contain 114,092 declared triangles in total.
The review assembly also declares 114,092 triangles and 424 model meshes, exactly
the sum of those eleven packages. This is intentional transitive duplication,
not a duplicate-ID/hash failure. The manifest's `prohibited_combinations` entry
correctly excludes all eleven individual assets when the assembly is loaded.
That exclusion must be enforced by the viewer/Houdini composition layer.

## USD stage and package evidence

| Asset ID | Mesh prims | Material definitions | USDZ members |
|---|---:|---:|---|
| `blood_brain_barrier_neurovascular_unit_conceptual_v3` | 29 | 7 | 1 USDC |
| `capillary_endothelium_tight_junctions_conceptual_v3` | 17 | 5 | 1 USDC |
| `formed_blood_elements_magnified_v3` | 20 | 6 | 1 USDC |
| `platelet_fibrin_thrombus_microstructure_conceptual_v3` | 96 | 5 | 1 USDC + 1 PNG |
| `multipolar_neuron_detailed_conceptual_v3` | 49 | 5 | 1 USDC |
| `astrocyte_capillary_endfeet_conceptual_v3` | 22 | 2 | 1 USDC |
| `oligodendrocyte_myelinated_axons_conceptual_v3` | 27 | 3 | 1 USDC + 1 PNG |
| `myelinated_axon_node_of_ranvier_conceptual_v3` | 47 | 4 | 1 USDC + 1 PNG |
| `chemical_synapse_closeup_conceptual_v3` | 50 | 6 | 1 USDC |
| `choroid_plexus_csf_interface_conceptual_v3` | 58 | 4 | 1 USDC |
| `ischemic_tissue_zones_conceptual_v3` | 9 | 5 | 1 USDC + 1 PNG |
| `intracranial_micro_teaching_set_v3` | 424 | 33 | 1 USDC + 3 PNGs |

The only asset references found in the USD stages are these package-local paths:

- `./textures/cerebral_microtissue_albedo_v1.png`
- `./textures/myelin_white_matter_albedo_v1.png`
- `./textures/thrombus_fibrin_albedo_v1.png`

Every referenced member exists in its package. Each embedded PNG hash exactly
matches the corresponding source PNG. The manifest's three appearance-reference
hashes also match the source files:

| Appearance reference | SHA-256 | Result |
|---|---|---|
| `cerebral_microtissue_albedo_v1.png` | `db9a0383316c47fab2913af9742ad622e425c109b1ee0b1b3b0b85d3394c7a9c` | PASS |
| `myelin_white_matter_albedo_v1.png` | `04ef16d985825d46a3c9d98c1cdd2cd130c404b1ebb9f9a02918a57250a67359` | PASS |
| `thrombus_fibrin_albedo_v1.png` | `ca6682ff45f7b4f75cb5b45a55ecdff18fdd7551f5701a89f0881addc741c4fc` | PASS |

No package contains a Camera prim, USD light prim, world/backdrop member, EXR,
absolute local path, HTTP(S) reference, or unresolved external reference. Every
root `Asset` prim carries an accessibility label and this explicit description:
“Generic magnified microanatomy teaching vignette. Not histology,
patient-specific anatomy, quantitative physiology, diagnosis, treatment planning,
or a clinical simulation.” Every model Xform carries false patient-specific,
histology-validated, and quantitative flags.

## RealityKit runtime evidence

All packages loaded through `Entity.load(contentsOf:)`. Model and mesh counts are
identical and material counts are nonzero. Runtime dimensions are in RealityKit
X/Y/Z order; they match manifest X/Z/Y after Blender-to-Y-up conversion to the
reported six-decimal precision (one thrombus component differs by 0.000001 m due
to rounding). Load times below are diagnostic observations from one mixed
cold/warm macOS run, not performance benchmarks and not evidence of Vision Pro
frame-rate, memory, or thermal suitability.

| Package | Entities | Models / meshes / materials | Runtime dimensions X × Y × Z (m) | Load (ms) |
|---|---:|---:|---|---:|
| `astrocyte_capillary_endfeet_conceptual_v3.usdz` | 46 | 22 / 22 / 22 | 0.140000 × 0.074277 × 0.096940 | 440.6 |
| `blood_brain_barrier_neurovascular_unit_conceptual_v3.usdz` | 60 | 29 / 29 / 29 | 0.120000 × 0.057608 × 0.072065 | 44.9 |
| `capillary_endothelium_tight_junctions_conceptual_v3.usdz` | 36 | 17 / 17 / 17 | 0.145011 × 0.036500 × 0.055334 | 27.1 |
| `chemical_synapse_closeup_conceptual_v3.usdz` | 102 | 50 / 50 / 50 | 0.115546 × 0.073797 × 0.037703 | 59.6 |
| `choroid_plexus_csf_interface_conceptual_v3.usdz` | 118 | 58 / 58 / 58 | 0.137719 × 0.066499 × 0.067058 | 68.4 |
| `formed_blood_elements_magnified_v3.usdz` | 42 | 20 / 20 / 20 | 0.145295 × 0.046601 × 0.062857 | 31.5 |
| `intracranial_micro_teaching_set_v3.usdz` | 850 | 424 / 424 / 424 | 0.566976 × 0.045384 × 0.324533 | 847.0 |
| `ischemic_tissue_zones_conceptual_v3.usdz` | 20 | 9 / 9 / 9 | 0.147024 × 0.048100 × 0.100381 | 61.8 |
| `multipolar_neuron_detailed_conceptual_v3.usdz` | 100 | 49 / 49 / 49 | 0.190216 × 0.048539 × 0.121083 | 54.1 |
| `myelinated_axon_node_of_ranvier_conceptual_v3.usdz` | 96 | 47 / 47 / 47 | 0.170000 × 0.022300 × 0.022300 | 82.8 |
| `oligodendrocyte_myelinated_axons_conceptual_v3.usdz` | 56 | 27 / 27 / 27 | 0.142000 × 0.054400 × 0.069192 | 62.5 |
| `platelet_fibrin_thrombus_microstructure_conceptual_v3.usdz` | 194 | 96 / 96 / 96 | 0.150000 × 0.062000 × 0.053363 | 143.4 |

## Original-resolution preview review

| Preview | Evidence | Result |
|---|---|---|
| `40_blood_brain_barrier_neurovascular_unit_v3.png` | Opened capillary wall, endothelial nuclei, junction seams, RBC context, pericyte wrap, and astrocyte/endfeet cues remain separated and readable; no cutaway occlusion | PASS |
| `40b_capillary_endothelium_tight_junctions_v3.png` | Five endothelial-cell cues, nuclei, basement-membrane surface, orange junction seams, and pericyte context are independently readable with clean material separation | PASS |
| `41_formed_blood_elements_v3.png` | Biconcave RBC forms, opened generic leukocyte cue, and platelet forms are visibly distinct; presentation is clearly illustrative, not a slide or blood count | PASS |
| `42_thrombus_microstructure_v3.png` | Vessel opening exposes the clot body, entrapped blood-element cues, and fibrin strands without hiding the lumen | PASS visual clarity; HOLD literal-composition interpretation without visible warning |
| `43_multipolar_neuron_v3.png` | Soma, processes, spine cues, axon, and terminal branch remain readable with no transform or material defect | PASS |
| `43b_astrocyte_capillary_endfeet_v3.png` | Astrocyte soma, radiating processes, four enlarged endfeet, and opaque capillary context are fully exposed without occlusion or alpha sorting | PASS |
| `44_oligodendrocyte_myelinated_axons_v3.png` | Three axons, simplified internodes, node gaps, oligodendrocyte soma, and connecting processes are visible without alpha sorting | PASS |
| `44b_myelinated_axon_node_of_ranvier_v3.png` | Continuous axon core, four myelin internodes, surface-ring cues, three node gaps, and orange channel-location markers remain crisp at close range; end cropping does not obscure the target nodes | PASS |
| `45_chemical_synapse_v3.png` | Presynaptic cutaway, vesicle cues, cleft particles, receptor-location cues, and postsynaptic form are cleanly separated | PASS |
| `46_choroid_plexus_csf_v3.png` | Repeated capillary/epithelial cues and blue CSF-direction markers are readable | PASS visual clarity; HOLD literal-flow interpretation without visible warning |
| `47_ischemic_tissue_zones_v3.png` | Three opaque nested teaching regions and microvessel context are unobscured | PASS visual clarity; HOLD any perfusion, time, extent, prognosis, or patient-specific interpretation |
| `48_intracranial_micro_teaching_set_v3.png` | All eleven vignettes are arranged without collision or exploded transforms and the assembly is recognizable as a review gallery | PASS overview |

The previews are polished explanatory renders, not realistic histology. That is
appropriate for the declared conceptual use. Their colors, object counts,
spacing, scale, directional markers, clot composition, and tissue-zone extents
must never be presented as measured values or patient data.

## Release boundary

The twelve packages pass technical integration into a generic prototype provided
the review assembly is not co-loaded with its eleven components. The following
remain required before any patient-facing or hospital evaluation:

1. Make the magnification, conceptual/nonquantitative, and non-patient warnings
   persistently visible in the consuming UI; USD accessibility metadata alone is
   not a visible patient warning.
2. Complete specialist neuroanatomy, neuropathology, hematology, neuroradiology,
   patient-communications, accessibility, and human-factors review.
3. Profile memory, load latency, thermals, and frame rate on the physical target;
   desktop RealityKit decode is not Vision Pro performance validation.
4. Keep these assets out of diagnosis, treatment planning, navigation, device
   selection, perfusion assessment, pathology classification, prognosis, and
   clinical decision support.
