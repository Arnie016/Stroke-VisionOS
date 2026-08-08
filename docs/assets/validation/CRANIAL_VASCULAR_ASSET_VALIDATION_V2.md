# Cranial vascular asset validation v2

Validated: 2026-08-08 15:32 SGT
Manifest: `asset_manifest_cranial_vascular_v2.json`
Scope: seven USDZ assets in module `cranial_vascular_v2`

## Verdict

**Technical and visual asset gate: PASS (7/7).** Every scoped package returned
`Success!` and exit code 0 from `/usr/bin/usdchecker --arkit --strict`. Every
package also loaded through RealityKit `Entity.load(contentsOf:)` with nonzero
model, mesh, material, and finite positive visual-bound results. Manifest byte
counts and SHA-256 values match the final packages exactly.

Final rendered-material previews 13-18 were inspected at 1600 x 1200. The former
flat-gray source-atlas compositor output is gone. The previews now use a dark
clinical stage, opaque restrained purple/burgundy venous UI materials, and red
arterial materials. Preview 15 uses a presentation-only key/fill lift so the full
neck-access arterial continuity remains readable; lights are not included in any
runtime asset. Preview 17 adds a muted registered brain silhouette for spatial
context, but that silhouette remains presentation-only and is not included in the
vascular exports.

This is technical/visual QA, not anatomical or clinical validation. The anatomy is
generic atlas-derived content, not patient-specific imaging or a clinical
segmentation. It must not be used for diagnosis, treatment planning, navigation,
device sizing, access assessment, outcome prediction, or unsupervised counselling.

## Manifest integrity and strict USD results

The manifest contains exactly seven unique asset IDs. Its top-level module and
every asset module are `cranial_vascular_v2`. Every asset declares a description,
clinical note, byte count, SHA-256, triangle count, and positive three-axis source
dimensions.

| Asset ID | Triangles | Source dimensions X x Y x Z (m) | USDZ bytes | SHA-256 | Strict USD |
|---|---:|---|---:|---|---|
| `dural_venous_sinuses_realistic_v2` | 31,872 | 0.121879 x 0.177172 x 0.139085 | 4,084,762 | `da64f23a4c4327e15cc0d9cc54c7473b14d6b2fd7c2baf3551fb2e9d8aa0237b` | PASS |
| `internal_jugular_veins_realistic_v2` | 3,072 | 0.079378 x 0.043633 x 0.162612 | 2,700,693 | `33b0fc32e4c69e6cfe38b6499aec0a0b1ce6a5c68e5ba254c6e86b860554bb80` | PASS |
| `dural_sinuses_jugulars_realistic_v2` | 34,944 | 0.121879 x 0.177172 x 0.289924 | 4,224,442 | `bfdebeefacacc6f32687c54159673b9dc42cf15b2b1ef705399b9346a3276a09` | PASS |
| `head_neck_veins_supplemental_v2` | 39,168 | 0.157773 x 0.191820 x 0.263109 | 4,338,685 | `81999e4cff0a0c0f56ba5bfb87b52fdf797948ec1e6cb4c22b687a9d8f8259c0` | PASS |
| `head_neck_veins_expanded_realistic_v2` | 74,112 | 0.157773 x 0.191820 x 0.292950 | 6,002,492 | `279fd1eaee77dd68472c2409695f1e45807c5663a208b198cfd8b2800d8d9f74` | PASS |
| `neck_access_arteries_realistic_v2` | 9,344 | 0.091741 x 0.057200 x 0.208724 | 429,271 | `5d64487b8f1beb9a8affa1ecf9820c4b7db8147c44458c93c93dce444762f9fe` | PASS |
| `cranial_vascular_registered_assembly_v2` | 83,456 | 0.157773 x 0.191820 x 0.306253 | 6,429,160 | `45080b42e09cd61cdcb1215d3ad69868d4dfa08d273ee6d9aa318c3b0f6229d6` | PASS |

Apple USD Tools intermittently emits its schema-registration `Coding Error`
diagnostic before a successful result. No validator rule failed, every invocation
returned 0, and all final packages subsequently decoded in RealityKit.

## RealityKit runtime results

Runtime bounds use RealityKit X/Y/Z ordering; source-manifest dimensions are stored
in the pre-export source ordering, so the second and third values swap under the
Y-up export. Load times are one local warm/cold-mixed run, not performance
benchmarks.

| Package | Entities | Models / meshes / materials | Runtime dimensions X x Y x Z (m) | Load time | Result |
|---|---:|---|---|---:|---|
| `cranial_vascular_registered_assembly_v2.usdz` | 130 | 64 / 64 / 64 | 0.157773 x 0.306253 x 0.191820 | 2030.0 ms | PASS |
| `dural_sinuses_jugulars_realistic_v2.usdz` | 38 | 18 / 18 / 18 | 0.121879 x 0.289924 x 0.177172 | 412.0 ms | PASS |
| `dural_venous_sinuses_realistic_v2.usdz` | 34 | 16 / 16 / 16 | 0.121879 x 0.139085 x 0.177172 | 368.8 ms | PASS |
| `head_neck_veins_expanded_realistic_v2.usdz` | 114 | 56 / 56 / 56 | 0.157773 x 0.292950 x 0.191820 | 702.0 ms | PASS |
| `head_neck_veins_supplemental_v2.usdz` | 78 | 38 / 38 / 38 | 0.157773 x 0.263109 x 0.191820 | 618.5 ms | PASS |
| `internal_jugular_veins_realistic_v2.usdz` | 6 | 2 / 2 / 2 | 0.079378 x 0.162612 x 0.043633 | 175.3 ms | PASS |
| `neck_access_arteries_realistic_v2.usdz` | 18 | 8 / 8 / 8 | 0.091741 x 0.208724 x 0.057200 | 89.0 ms | PASS |

## Selection and source-identity checks

- Sixteen named dural venous sinus objects, two named internal jugular veins,
  thirty-eight supplemental head/neck veins, and eight neck-access arteries are
  preserved in the registered v2 head coordinate frame.
- `Sinus of frontal bone` and `Sinus of sphenoid bone` are explicitly rejected as
  bony air sinuses, not veins.
- The bulbous bilateral regions are the source objects `Cavernous sinus.l` and
  `Cavernous sinus.r`. They are confirmed named Z-Anatomy cardiovascular anatomy,
  not eyes, helpers, or generated substitutes. Preview 18 isolates them as visual
  identity evidence.
- Geometry QC accepted 64 unique named source structures. The build does not bridge
  gaps or invent replacement vascular anatomy.

## Preview inspection

| Preview | Observation | Result |
|---|---|---|
| `13_dural_sinuses_jugulars_realistic.png` | Core sinus/jugular layer is visible with differentiated purple/burgundy materials and continuous named outflow structures. | PASS |
| `14_head_neck_veins_expanded_realistic.png` | Expanded 56-structure venous layer is legible against the dark stage without missing-material or gray-compositor corruption. | PASS |
| `15_neck_access_arteries_realistic.png` | All eight access-artery structures remain readable through their inferior segments after a presentation-only light lift. | PASS |
| `16_cranial_vascular_registered_assembly.png` | Venous and arterial layers remain visually distinct in the combined registered assembly. | PASS |
| `17_cranial_vascular_brain_context.png` | Muted registered cortex establishes spatial context; brain is presentation-only and absent from runtime vascular exports. | PASS |
| `18_cavernous_sinuses_source_identity.png` | Isolated bilateral bulbous source structures match the named cavernous-sinus objects, not eye/helper geometry. | PASS |

## Licence and use boundary

All selected vascular geometry is derived from Z-Anatomy / BodyParts3D. The build
and redistributed derivatives retain Z-Anatomy CC BY-SA 4.0 and BodyParts3D CC
BY-SA 2.1 Japan attribution and ShareAlike obligations. The optional venous normal
and roughness maps are project visual polish, not measured tissue data. Purple/blue
veins are a UI convention only; venous blood is dark red, not blue, and the colors
encode no flow, pressure, oxygenation, stenosis, perfusion, or collateral state.
