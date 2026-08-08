# v2 USDZ validation

Validated: 2026-08-08 14:27 SGT
Asset directory: `vision_pro_stroke_kit_v2/exports/usdz`
Verdict: **PASS for USDZ/ARKit conformance and RealityKit loading at this checkpoint (12/12 packages).**

This is technical asset validation, not clinical validation. Anatomy, laterality, clot placement, device geometry, procedure sequence, and patient-facing claims still require specialist review. These generic assets are not suitable for diagnosis, planning, navigation, sizing, or outcome prediction.

## Test environment and method

- macOS 26.6 (25G72)
- Xcode 27.0 beta (27A5228h), visionOS 27.0 runtime installed
- Apple USD Tools 0.25.2
- Strict conformance: `usdchecker --arkit --strict <asset.usdz>`
- Runtime decode: RealityKit `Entity.load(contentsOf:)` from a compiled Swift probe
- Package inspection: archive members, referenced textures, USD stage metadata, nonzero mesh/model content, visual bounds

All stages have `defaultPrim = "Asset"`, `metersPerUnit = 1`, and `upAxis = "Y"`. All package-local texture references resolve. The dimensions below are RealityKit visual-bound dimensions in runtime X/Y/Z order; Blender's source Y/Z dimensions are expected to appear swapped after the Z-up to Y-up conversion.

## Results

| Package | Size (bytes) | `usdchecker --arkit --strict` | RealityKit | Model components | RealityKit dimensions (m) | One-run load time* |
|---|---:|---|---|---:|---|---:|
| `aspiration_catheter_educational_v2.usdz` | 803,363 | PASS | PASS | 9 | 0.172202 × 0.002858 × 0.006699 | 402.7 ms |
| `brain_anatomy_realistic_v2.usdz` | 14,051,264 | PASS | PASS | 4 | 0.136368 × 0.145723 × 0.167000 | 435.1 ms |
| `brain_deep_structures_v2.usdz` | 2,204,061 | PASS | PASS | 1 | 0.069519 × 0.081299 × 0.091225 | 54.6 ms |
| `brain_ventricles_v2.usdz` | 782,064 | PASS | PASS | 1 | 0.074908 × 0.101773 × 0.128477 | 18.2 ms |
| `cerebral_arteries_realistic_v2.usdz` | 4,246,138 | PASS | PASS | 1 | 0.142488 × 0.280877 × 0.152587 | 141.6 ms |
| `guidewire_educational_v2.usdz` | 238,023 | PASS | PASS | 2 | 0.198413 × 0.000430 × 0.008405 | 14.3 ms |
| `ischemic_mca_clot_v2.usdz` | 70,237 | PASS | PASS | 1 | 0.006171 × 0.001994 × 0.001495 | 5.3 ms |
| `microcatheter_educational_v2.usdz` | 385,101 | PASS | PASS | 3 | 0.159625 × 0.001440 × 0.007631 | 13.8 ms |
| `skull_semantic_realistic_v2.usdz` | 7,985,508 | PASS | PASS | 15 | 0.172759 × 0.280360 × 0.257910 | 177.8 ms |
| `stent_retriever_educational_v2.usdz` | 1,048,091 | PASS | PASS | 23 | 0.091055 × 0.004367 × 0.004370 | 52.3 ms |
| `thrombectomy_device_set_educational_v2.usdz` | 2,466,551 | PASS | PASS | 37 | 0.198413 × 0.004367 × 0.110052 | 177.8 ms |
| `thrombectomy_registered_hero_v2.usdz` | 32,482,833 | PASS | PASS | 25 | 0.172759 × 0.331046 × 0.257910 | 951.5 ms |

\*Single local macOS run only; compilation, filesystem caching, simulator load, device thermals, and app composition make these unsuitable as performance benchmarks.

## Material and package inspection

- Brain package: embedded 1254 × 1254 RGB cortex base-color PNG.
- Skull package: embedded 2048 × 2048 RGBA skull base-color and normal PNGs.
- Registered hero: embedded cortex, skull, and eye base-color/normal PNGs.
- Other packages contain only their USDC and use package-contained `UsdPreviewSurface` parameters without texture dependencies.
- Final 14:24 anatomy and 14:26 device exports contain no `DomeLight` prims or `color_0C0C0C.exr`; lighting is cleanly left to the app. This resolves the duplicate-environment-light issue found in the prior checkpoint.
- The 30.978 MiB registered hero is technically valid and loaded successfully, but should be profiled on the Vision Pro target. Loading individual/lazy layers is safer for startup latency and memory.

Apple USD Tools emitted intermittent schema-registration `Coding Error` diagnostics before some successful validations. Every strict invocation still produced `Validation Result ... Success!` and exit code 0; no validator rule warning or failure was reported.

## Defect caught and resolved during validation

The initial 14:17 exports of `brain_deep_structures_v2`, `brain_ventricles_v2`, and `skull_semantic_realistic_v2` were only about 2 KiB and contained no `Mesh` prims, even though `usdchecker` accepted the syntactically valid empty stages. The exporter selection/hidden-collection defect was fixed, then the final 14:24 packages above were revalidated with nonzero RealityKit `ModelComponent` counts. This is why conformance checking must be paired with content/runtime checks.

## Reproduce

```sh
for f in vision_pro_stroke_kit_v2/exports/usdz/*.usdz; do
  usdchecker --arkit --strict "$f"
done

xcrun --sdk macosx swiftc -O -framework Foundation -framework RealityKit \
  vision_pro_stroke_kit_v2/research/realitykit_load_probe.swift \
  -o /tmp/realitykit_load_probe

/tmp/realitykit_load_probe \
  RealityKitContent/Assets/vision_pro_stroke_kit_v2/exports/usdz
```

## SHA-256 checkpoint

```text
819193def17b52bf918353c4eb08df5d81a5a6ee73484912378fa12deb82c1e1  aspiration_catheter_educational_v2.usdz
6b02ec90e808d3e50a84a9b75239390be6ca8c5903c7212b96251b633e4f0622  brain_anatomy_realistic_v2.usdz
bd563ff3161ca63b4e466a1ae13423c7a6a919dd095d164e308abededfe19c6e  brain_deep_structures_v2.usdz
3c77f634526c8f830bce8bcd9a4a67b5ee24c4f68291d6ec2f0ea5f74904cd56  brain_ventricles_v2.usdz
9bc696f7b85e3dcccf0a45907cd91dbc5cc7d79b773c0fa2ac5bbbf827108aeb  cerebral_arteries_realistic_v2.usdz
50e86ae808c91aca059d29b4f2594a5c6a0ca21d31f2d46d0ba04aa0535fd471  guidewire_educational_v2.usdz
ba07bfb3d13a2ba73d951eda1266500fec037ad416ae72886ed4d4759ae854f0  ischemic_mca_clot_v2.usdz
105c732b3baa68676e6663c9c034ca7459827893599f2d6e8d4ccc5e54a30f9c  microcatheter_educational_v2.usdz
4f72afb1f9452cfdeb3263636da9805e1a1b40a6838660858ff4188f5ed7ce7d  skull_semantic_realistic_v2.usdz
462017c222abce6e15f45e6e8c13472cbc076941e5c651b3a62f891e08d4870b  stent_retriever_educational_v2.usdz
797ee01a6c301fc89bd296bcec741f710ee00dcb22efd03e9258a66431b4a7d7  thrombectomy_device_set_educational_v2.usdz
a933c7f391138a9caf4109061541bef38ad122f8e49d3ad81b83330fb7841d08  thrombectomy_registered_hero_v2.usdz
```
