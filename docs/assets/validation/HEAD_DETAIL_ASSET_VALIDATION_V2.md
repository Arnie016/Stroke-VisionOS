# Head-detail asset validation v2

Validated: 2026-08-08 15:40 SGT
Manifest: `asset_manifest_head_details_v2.json`
Scope: the nine assets whose manifest module is `head_details_v2`

## Verdict

**Technical asset gate: PASS (9/9).** Every declared USDC and USDZ file exists;
all USDZ byte counts and SHA-256 values match the manifest exactly; all manifest
IDs are unique; every asset declares `module = head_details_v2`; triangle counts
and all three dimensions are positive; strict Apple USD/ARKit validation passes;
the stages contain nonzero meshes; all packaged texture references resolve; and
RealityKit loads every package with nonzero model, mesh, material, and visual-bound
results.

**Polished patient-facing visual gate: PASS for the labelled generic prototype.**
The approximate cross-source skull has been removed from the convenience assembly
and remains available only as the separate selectable
`skull_semantic_realistic_v2` asset. Original-resolution inspection of the revised
preview 08 confirms that the pale frontotemporal/orbital sliver and fragmented
craniofacial bone boundary are gone. The scalp/dura reveal is continuous, and no
missing-texture magenta, black/world environment, exploded mesh, gross hole, or
NaN-style render corruption is visible in previews 07-10.

This report is technical and visual QA, not anatomical or clinical validation.
Nothing here clears the assets for diagnosis, treatment planning, navigation,
device sizing, outcome prediction, or unsupervised patient counselling.

## Environment and method

- macOS 26.6 (25G72)
- Xcode 27.0 (27A5228h)
- Apple USD Tools 0.25.2
- Strict validation: `/usr/bin/usdchecker --arkit --strict <asset.usdz>`
- Stage inspection: `/usr/bin/usdcat`, archive-member inspection, prim/type and
  asset-path checks
- Runtime decode: `../research/realitykit_load_probe.swift`, compiled
  against macOS Foundation and RealityKit, loading copies of only the nine scoped
  USDZs with `Entity.load(contentsOf:)`
- Preview inspection: final 1600 x 1200 PNGs 07-10 at original resolution

Runtime load times below are one local warm/cold-mixed run and are not performance
benchmarks. RealityKit reports bounds in runtime X/Y/Z order. The manifest's source
dimensions reflect the pre-export source ordering, so its second and third values
appear swapped in the Y-up RealityKit bounds; the values otherwise agree to the
reported precision.

## Manifest and integrity results

The manifest contains exactly nine assets and nine unique IDs. Its top-level module
and every per-asset module are `head_details_v2`. All 18 declared file paths (nine
USDC and nine USDZ) exist. All triangle counts are greater than zero (minimum 6,000;
maximum 333,642), and every dimension component is greater than zero.

| Asset ID | USDC exists | USDZ bytes | Manifest bytes | SHA-256 match |
|---|---:|---:|---:|---|
| `external_head_scalp_realistic_v2` | yes | 7,900,991 | 7,900,991 | PASS |
| `external_head_scalp_cutaway_v2` | yes | 7,970,496 | 7,970,496 | PASS |
| `eyes_context_realistic_v2` | yes | 1,625,622 | 1,625,622 | PASS |
| `dura_mater_conceptual_v2` | yes | 6,727,477 | 6,727,477 | PASS |
| `dura_mater_cutaway_conceptual_v2` | yes | 6,869,866 | 6,869,866 | PASS |
| `falx_cerebri_atlas_v2` | yes | 381,136 | 381,136 | PASS |
| `tentorium_cerebelli_atlas_v2` | yes | 266,048 | 266,048 | PASS |
| `meningeal_partitions_atlas_v2` | yes | 644,124 | 644,124 | PASS |
| `layered_head_cutaway_registered_v2` | yes | 29,527,080 | 29,527,080 | PASS |

### Final observed USDZ SHA-256 values

```text
deb9218ed3fb8e6556c1ad4772f56153010cfd7f93453a3820f8d434df42ed38  external_head_scalp_realistic_v2.usdz
bc2c021f026d8204180cc04e139f9482a5e2633ebb4c1497b747037191298856  external_head_scalp_cutaway_v2.usdz
032529aff7b9ab3d65f7dc91352cb1c51ca39c97096176aba7218fa12466c45b  eyes_context_realistic_v2.usdz
4071f7383ff7e94c253bd57aecc3a33f408d649bdb134ed08b970443c9fc3c6d  dura_mater_conceptual_v2.usdz
6411ecc9e58dc2f3322459cab8cea13d6c7e9fd532a33a88b84eb3cb7985b809  dura_mater_cutaway_conceptual_v2.usdz
388037dfbac68efae5bd21102cdd44f210da3764fb469ffe272abccc63309a79  falx_cerebri_atlas_v2.usdz
0603001f07b03ad219fc7173a9cda185e030c4b456f4d0ccdc6f91913968722f  tentorium_cerebelli_atlas_v2.usdz
05340e8b17e9e5a6037902b00033a922b4ee92bfeb4cfc6d33d0efa5c5810134  meningeal_partitions_atlas_v2.usdz
7cc6b39274fbd124791c70fa040deab1962e8d19693100101859a8983461afc7  layered_head_cutaway_registered_v2.usdz
```

## USD/ARKit and package inspection

All nine invocations of `usdchecker --arkit --strict` returned exit code 0 and
`Validation Result ... Success!`.

Apple USD Tools intermittently printed its known schema-registration `Coding Error`
diagnostic before four successful checks. It did not emit a validator rule failure,
did not change the exit status, and the same packages subsequently decoded in
RealityKit. It is recorded here rather than hidden, but is not treated as an asset
failure.

| Asset ID | Strict checker | `defaultPrim` | metres | up axis | Mesh prims | Texture refs | Camera/light prims | EXR/world payload |
|---|---|---|---:|---|---:|---:|---:|---|
| `external_head_scalp_realistic_v2` | PASS | `Asset` | 1 | Y | 1 | 3/3 resolved | 0/0 | none |
| `external_head_scalp_cutaway_v2` | PASS | `Asset` | 1 | Y | 1 | 3/3 resolved | 0/0 | none |
| `eyes_context_realistic_v2` | PASS | `Asset` | 1 | Y | 1 | 2/2 resolved | 0/0 | none |
| `dura_mater_conceptual_v2` | PASS | `Asset` | 1 | Y | 1 | 3/3 resolved | 0/0 | none |
| `dura_mater_cutaway_conceptual_v2` | PASS | `Asset` | 1 | Y | 1 | 3/3 resolved | 0/0 | none |
| `falx_cerebri_atlas_v2` | PASS | `Asset` | 1 | Y | 1 | 0 | 0/0 | none |
| `tentorium_cerebelli_atlas_v2` | PASS | `Asset` | 1 | Y | 2 | 0 | 0/0 | none |
| `meningeal_partitions_atlas_v2` | PASS | `Asset` | 1 | Y | 3 | 0 | 0/0 | none |
| `layered_head_cutaway_registered_v2` | PASS | `Asset` | 1 | Y | 9 | 7/7 resolved | 0/0 | none |

The texture references resolve to package-local PNG members. No camera, DomeLight,
DistantLight, RectLight, DiskLight, SphereLight, CylinderLight, GeometryLight, or
PortalLight prim was found. No EXR, `color_0C0C0C`, or world/environment payload was
packaged.

## RealityKit runtime results

| Package | Runtime | Entities | Models / meshes / materials | Runtime dimensions X x Y x Z (m) | Load time |
|---|---|---:|---|---|---:|
| `dura_mater_conceptual_v2.usdz` | PASS | 4 | 1 / 1 / 1 | 0.143225 x 0.153582 x 0.173276 | 505.5 ms |
| `dura_mater_cutaway_conceptual_v2.usdz` | PASS | 4 | 1 / 1 / 1 | 0.134716 x 0.153572 x 0.173276 | 111.0 ms |
| `external_head_scalp_cutaway_v2.usdz` | PASS | 4 | 1 / 1 / 1 | 0.192628 x 0.251173 x 0.242102 | 154.0 ms |
| `external_head_scalp_realistic_v2.usdz` | PASS | 4 | 1 / 1 / 1 | 0.195671 x 0.251174 x 0.242102 | 146.4 ms |
| `eyes_context_realistic_v2.usdz` | PASS | 4 | 1 / 1 / 1 | 0.097353 x 0.025702 x 0.042658 | 57.6 ms |
| `falx_cerebri_atlas_v2.usdz` | PASS | 4 | 1 / 1 / 1 | 0.005866 x 0.119539 x 0.174806 | 9.6 ms |
| `layered_head_cutaway_registered_v2.usdz` | PASS | 20 | 9 / 9 / 9 | 0.192628 x 0.251173 x 0.242102 | 933.9 ms |
| `meningeal_partitions_atlas_v2.usdz` | PASS | 8 | 3 / 3 / 3 | 0.120674 x 0.119539 x 0.174806 | 16.0 ms |
| `tentorium_cerebelli_atlas_v2.usdz` | PASS | 6 | 2 / 2 / 2 | 0.120674 x 0.030922 x 0.090475 | 8.1 ms |

All visual-bound minima and maxima were finite, and every runtime dimension was
positive. The 29.5 MB layered assembly loaded successfully but should still be
profiled on the actual Apple Vision Pro target; this desktop run does not establish
device startup latency or memory suitability.

## Preview inspection

| Preview | Observation | Result |
|---|---|---|
| `07_head_scalp_exterior_realistic_v2.png` | Continuous head/neck shell, coherent skin material, facial and ear features intact; no floating scan labels, plinth fragments, missing texture, or gross holes visible. | PASS |
| `08_layered_head_cutaway_v2.png` | Scalp and dura windows are smooth and the brain is visible without texture loss. The approximate skull is intentionally omitted from this convenience assembly; the former pale skin intersection and fragmented craniofacial boundary are absent. | PASS for the labelled generic prototype |
| `09_dura_mater_conceptual_v2.png` | Brain-hull-shaped membrane and rounded cutaway are continuous and textured; no sphere-like placeholder, explosion, or missing material visible. Its thickness and window remain intentionally conceptual. | PASS as labelled conceptual art |
| `10_meningeal_partitions_atlas_v2.png` | Falx and bilateral tentorium are visibly separated for inspection with coherent surfaces; no missing parts, mesh explosion, or texture corruption visible. The exploded presentation is an atlas showcase, not an in-situ spatial relationship check. | PASS for asset inspection |

## Source, licence, and use boundaries

- **Exterior skin:** HRA *Skin, Male*, NIH 3D `3DPX-021016`, entry version 2,
  licensed CC BY 4.0. The shipped head is a crop/neck-cap/LOD/material derivative,
  so redistribution must retain the source, version, licence, attribution, and
  modification notice. It is generic reference anatomy, not patient-specific skin.
- **Brain:** HRA *Brain, Male*, NIH 3D `3DPX-020960` v1.01, CC BY 4.0. It provides
  generic atlas context and does not validate the conceptual dura or an optional
  separately loaded skull.
- **Skull and eyes:** NIH 3D *Visible Human Male Skull and Eyes*, `3DPX-020591`
  v1.03, CC BY 4.0. These are independently normalized and approximately registered
  across sources. Both remain separate optional assets and are omitted from the
  default layered assembly; neither the orbital alignment nor skull fit is
  patient-specific or planning-grade.
- **Falx and tentorium:** extracted/derived from the Z-Anatomy compilation, with
  Z-Anatomy CC BY-SA 4.0 and its stated BodyParts3D CC BY-SA 2.1 Japan attribution.
  The derived partition assets carry ShareAlike obligations; the complete Z source
  attribution and licence must travel with redistributed derivatives.
- **Dura shells and cutaway windows:** original procedural illustration derived
  from a smoothed registered brain hull, using project-generated PBR material maps.
  Geometry thickness, spacing, cutaway location, and the viewing window are
  non-physiologic/conceptual. They must not be described as a measured dura,
  surgical opening, patient segmentation, or operative plan.
- **Combined layered assembly:** combines the native-frame HRA skin/brain with
  conceptual dura and registered atlas partitions. The approximate skull and eye
  overlays are intentionally omitted and remain separate selectable assets. The
  assembly is acceptable only as a clearly labelled educational prototype after
  specialist review; it cannot support diagnosis, treatment planning, navigation,
  device selection, or outcome claims.

## Release decision

The nine files are technically sound USDZ/RealityKit assets at the observed hashes.
The corrected combined cutaway passes the scoped visual-polish gate because the
offending skull/skin intersection and fragmented facial-bone boundary are absent.
It may be integrated into the prototype behind the existing generic/conceptual
warnings. Full clinical, anatomy, accessibility, comfort, patient-comprehension,
and device-performance reviews remain outstanding.
