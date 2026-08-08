# Cranial detail asset validation v3

> **Scope note:** this report validates the complete 18-package source build.
> The publishing runtime tree intentionally contains only the 16 non-held
> packages. The validated ear package and ear-containing support assembly are
> not release candidates and their binaries are absent here.

Validated: 2026-08-08 SGT
Manifest: `asset_manifest_cranial_detail_v3.json`
Scope: 18 USDZ packages in module `cranial_detail_v3`

## Verdict

**Technical and visual gate: PASS (18/18).** Every scoped package returned
`Success!` and exit code 0 from `/usr/bin/usdchecker --arkit --strict`. Every
package loaded through RealityKit `Entity.load(contentsOf:)` with nonzero entity,
model, mesh, material, and positive finite visual-bound results. Final manifest
byte counts and SHA-256 values match the generated packages.

**Clinical gate: NOT PASSED.** The assets are generic atlas-derived anatomy and
require specialist review. They are not patient-specific and must not be used
for diagnosis, planning, navigation, rehearsal, device sizing, or clinical
decisions.

**Licence gate:** the ear asset and complete cranial-support assembly are
`HOLD_FOR_INNER_EAR_LICENSE_REVIEW`; see
`CRANIAL_DETAIL_SOURCE_PROVENANCE_V3.md`.

## Manifest and strict-USD results

| Asset ID | Source meshes | Triangles | Source dimensions X × Y × Z (m) | USDZ bytes | SHA-256 |
|---|---:|---:|---|---:|---|
| `cranial_nerve_olfactory_i_bilateral_v3` | 2 | 18,216 | 0.046698 × 0.051270 × 0.017926 | 845,380 | `222751ff3420111e4fc680efe168ae9b96298e0b6e48abae2c6e5aa75efde0fa` |
| `cranial_nerve_optic_ii_bilateral_v3` | 2 | 1,176 | 0.060942 × 0.042505 × 0.016705 | 57,124 | `2ce252f5fbc702e41dd5d78408c2b8fb36d4fa768de10fd5035b2e72b7c59851` |
| `cranial_nerves_ocular_motor_iii_iv_vi_v3` | 6 | 11,760 | 0.078170 × 0.087945 × 0.034125 | 544,722 | `6586e0763466725163778984f533f14ab59d73fed441e193897af182e59aabdf` |
| `cranial_nerve_trigeminal_v_expanded_v3` | 26 | 43,064 | 0.152444 × 0.122068 × 0.163540 | 2,027,779 | `0991327783330ecb3a757a5eeb27e753188dea9868b7a4970cb00d8b163d558d` |
| `cranial_nerve_facial_vii_bilateral_v3` | 4 | 19,512 | 0.131133 × 0.104146 × 0.116136 | 903,057 | `b259bc55203fe30902bb50e22e88e3456a29869ec50a7de4a3248fa89b029f50` |
| `cranial_nerve_vestibulocochlear_viii_v3` | 6 | 6,426 | 0.081114 × 0.018404 × 0.006931 | 317,943 | `4b60eda8eda199a8d4759377cdf399d784786d3c86c47c534d735d26fa2d3630` |
| `cranial_nerves_glossopharyngeal_ix_vagus_x_v3` | 4 | 29,304 | 0.110508 × 0.088611 × 0.472361 | 1,398,498 | `90cc617c8880692036abcac63899696528ebcebafcad26762fe5c35162d513b4` |
| `cranial_nerve_accessory_xi_bilateral_v3` | 2 | 10,320 | 0.119082 × 0.124349 × 0.279543 | 479,737 | `2929783ef71dc8675b30e1389096be0d416fc9aaa751d8040852a1db5bf0440c` |
| `cranial_nerve_hypoglossal_xii_bilateral_v3` | 2 | 10,944 | 0.055947 × 0.075729 × 0.064531 | 508,373 | `3b32c8d8d671b54f27800dc80e322e5b3ab06c5f48497fe62aae79dc176d569a` |
| `extraocular_muscles_orbital_support_v3` | 18 | 22,952 | 0.088227 × 0.047763 × 0.033713 | 1,010,371 | `29892dd0e248e5ab85ba5c1b97ac9890143bb191d835b3de81f6a092467d115a` |
| `pituitary_adenohypophysis_neurohypophysis_v3` | 2 | 1,272 | 0.011900 × 0.009157 × 0.012560 | 62,692 | `076c35f64353d68cb87b412934597a5f3f4993444e23cc8da83d1165941f3e6d` |
| `middle_inner_ear_bilateral_v3` | 14 | 58,032 | 0.101245 × 0.028627 × 0.016506 | 2,758,630 | `8098e7e729a86efe2b81a01a251681bca54055fedf1ca7e55e15ad9bf8c7250e` |
| `nasal_cavity_paranasal_spaces_v3` | 14 | 19,526 | 0.050386 × 0.093663 × 0.082993 | 996,676 | `1e0953d8e64cbbbc477f56494c4de1d56c3e0991e11eb7b887412038758c8c66` |
| `pharyngeal_upper_airway_context_v3` | 5 | 14,112 | 0.065618 × 0.075948 × 0.134842 | 706,671 | `80adae2469199f81c028f23f622e4dd53f029d1978f1de8f32a2e9a75c7190cd` |
| `muscles_of_mastication_bilateral_v3` | 12 | 27,412 | 0.153665 × 0.113909 × 0.149787 | 1,214,277 | `bdb377b4fd1c98929993f035207084ec4701378a5f4836053dbf784269414f4b` |
| `head_neck_orientation_muscles_v3` | 18 | 39,332 | 0.122872 × 0.194217 × 0.292629 | 1,726,173 | `96a8e100ac32d45333d8c41c8ad8c7c251109e68073c5f195a6e44df1e6a5984` |
| `cranial_nerves_complete_assembly_v3` | 54 | 150,722 | 0.152444 × 0.200312 × 0.559504 | 7,059,481 | `fd31b4ff3aa99443bf73df8e769cd1c684e18aa668118efb66c216ff627c40ae` |
| `cranial_support_registered_assembly_v3` | 137 | 333,360 | 0.153665 × 0.228075 × 0.569423 | 15,516,164 | `b3c150bb1126b0bee1a7e94bd1e8f3e55062d7be892c711689984f717883742d` |

Every manifest row above passed strict USD validation. Each USDZ contains one
root USDC and no bundled camera, light, backdrop, label, texture, absolute path,
or external file reference. The USDC stages declare `metersPerUnit = 1` and
`upAxis = "Y"`.

The editable Blender file contains no linked libraries and no external image
references; the atlas UI's unrelated `CheatSheet.png` datablock was removed.

## RealityKit runtime results

RealityKit returned PASS for all 18 packages. Per-package model counts equal the
manifest source-mesh counts: 2–137 nonzero model/mesh/material components. Visual
bounds are finite and positive on all three axes. One local warm/cold-mixed run
ranged from approximately 83 ms for the two-mesh pituitary asset to 8.4 seconds
for the 137-mesh complete support assembly; these are diagnostic observations,
not performance benchmarks.

The two assemblies are authoring/review packages. Runtime experiences should
stream independent phase-relevant assets rather than loading the complete
333,360-triangle assembly by default.

## Source and semantic QC

- 137 unique exact source objects accepted: 49 curves and 88 meshes.
- Missing names are hard failures in the generator.
- Every mesh retains `userProperties:anatomical_name` with the unsanitized
  source identity.
- Curves are tessellated at a capped source resolution; no path is redrawn,
  mirrored, bridged, or procedurally invented.
- Foramina, suture seams, maxillary sinuses, and separately named semicircular
  canals were omitted when the source contained only helpers/labels or no
  defensible mesh.
- Existing eyes, skull, cerebral arteries, dural sinuses, brain, ventricles,
  meninges, and scalp are not duplicated in this module.

## Visual review

Seven 1400 × 1050 rendered-material frames were inspected in
`previews/cranial_detail_v3/`. The final pass has readable silhouettes and
materials, no missing-material magenta, no atlas helper labels, no flat-gray
compositor corruption, and no dither noise in the presentation-only context.
The full-length I–XII frame intentionally shows the long atlas vagus extent; the
additional head close-up provides a readable cranial view.

Technical/visual validation does not establish anatomical correctness, clinical
validity, patient safety, regulatory readiness, or licence suitability.
