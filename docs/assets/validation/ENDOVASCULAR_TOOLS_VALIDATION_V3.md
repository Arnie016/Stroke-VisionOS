# Endovascular tools asset validation v3

Validated: 2026-08-09 SGT

Manifest: `asset_manifest_endovascular_tools_v3.json`

Module: `endovascular_tools_v3`

Scope: 10 independent tool packages and 2 review-only assemblies

## Verdict

**Technical and visual gate: PASS (12/12).** Every USDZ returned `Success!`
and exit code 0 from `/usr/bin/usdchecker --arkit --strict`. Every package
loaded using RealityKit `Entity.load(contentsOf:)` with nonzero entity, model,
mesh, and material counts and positive finite visual bounds. Final file sizes
and SHA-256 values match the manifest for all twelve packages.

**Clinical gate: NOT PASSED.** These are generic, non-branded visual categories
that require specialist review. They are not patient-specific,
manufacturer-specific, or validated for device selection, compatibility,
sizing, navigation, procedural training, sterile-field setup,
medication/contrast preparation, treatment planning, or outcome prediction.

**Workflow gate:** endovascular branch only. Do not activate this module in a
craniotomy, open cranial surgery, or post-craniotomy head-dressing state.

## Package results

| Asset ID | Kind | Triangles | Blender bounds X × Y × Z (m) | USDZ bytes | RealityKit models | Strict USD | Runtime load |
|---|---|---:|---|---:|---:|---|---|
| `vascular_access_needle_educational_v3` | independent | 6,380 | 0.127100 × 0.034000 × 0.015000 | 118,892 | 13 | PASS | PASS |
| `vascular_access_wire_educational_v3` | independent | 2,500 | 0.265476 × 0.054120 × 0.062800 | 128,172 | 4 | PASS | PASS |
| `introducer_sheath_dilator_set_educational_v3` | independent | 18,284 | 0.226000 × 0.067337 × 0.030470 | 244,844 | 28 | PASS | PASS |
| `guide_catheter_hemostatic_valve_educational_v3` | independent | 19,632 | 0.313014 × 0.057564 × 0.031564 | 236,332 | 28 | PASS | PASS |
| `aspiration_pump_canister_tubing_educational_v3` | independent | 9,928 | 0.283000 × 0.094500 × 0.129516 | 255,062 | 24 | PASS | PASS |
| `contrast_manifold_syringe_flush_educational_v3` | independent | 14,712 | 0.188043 × 0.179000 × 0.045500 | 332,780 | 32 | PASS | PASS |
| `torque_device_y_connector_accessories_educational_v3` | independent | 33,352 | 0.260021 × 0.099050 × 0.034338 | 318,849 | 47 | PASS | PASS |
| `puncture_site_hemostasis_options_educational_v3` | independent | 16,988 | 0.286376 × 0.096445 × 0.045050 | 282,390 | 27 | PASS | PASS |
| `sterile_endovascular_instrument_tray_educational_v3` | independent | 10,492 | 0.300000 × 0.205000 × 0.043250 | 296,056 | 25 | PASS | PASS |
| `angiography_suite_controls_educational_v3` | independent | 3,592 | 0.338806 × 0.133369 × 0.085000 | 77,649 | 16 | PASS | PASS |
| `vascular_access_setup_review_assembly_v3` | review assembly | 44,152 | 0.283840 × 0.218200 × 0.051444 | 722,963 | 72 | PASS | PASS |
| `endovascular_tools_workflow_review_assembly_v3` | review assembly | 135,860 | 0.789139 × 0.482192 × 0.083676 | 2,091,183 | 244 | PASS | PASS |

The ten independent packages total 135,860 triangles and 2,291,026 USDZ
bytes. Counting duplicate review packages, all twelve total 315,872 packaged
triangles and 5,105,172 USDZ bytes. These totals are catalog/package sums, not
a recommended simultaneous runtime load.

## SHA-256

```text
vascular_access_needle_educational_v3.usdz
8f081d4418d4aaf64f15dd26f91c3a9cecd9ee8de51b4841b0262eaeb26ea145

vascular_access_wire_educational_v3.usdz
50453ce07f6f767b31d1eca52a75f805b2f83c92f816fd8a431d721c6c78b1b1

introducer_sheath_dilator_set_educational_v3.usdz
22fa743e25d2b56f617776fa23affeea819133293f98c540e9b9725beec0464b

guide_catheter_hemostatic_valve_educational_v3.usdz
e984cb7c7a7a531431745221028f7965b904973e95c2678b0861ce4afa15759e

aspiration_pump_canister_tubing_educational_v3.usdz
8eca2d303e7f9f9ae4e79785a4cc88176a7f4440bff0a5b4b361a8f4844c9748

contrast_manifold_syringe_flush_educational_v3.usdz
734924e487c4c7c32b257be9832454cd98ed8f49bf9741faf3499a47a1d39249

torque_device_y_connector_accessories_educational_v3.usdz
b94e43ff505a2257c313bf25b2538c1ff3400aab29de875421d017484e32729c

puncture_site_hemostasis_options_educational_v3.usdz
83798a963dab5d983be8dc1eb7afa19eefa6f9e14645f11fb9d32b73e1269dd2

sterile_endovascular_instrument_tray_educational_v3.usdz
d5aa8497a8d0f8bc0d890deee11d5463e86580ec55742e789b17236a1f904fa2

angiography_suite_controls_educational_v3.usdz
cf5971a2e99191a2f94313aacdac47b7be60832594012761bd30427fe890de3c

vascular_access_setup_review_assembly_v3.usdz
00b47c24bb0b2ab15e6790695e213489ba7346b874be86f07fb80ee5380ac492

endovascular_tools_workflow_review_assembly_v3.usdz
624602f7429d77e4b6768b67bc308b5890a8a1dd8193957f506662a89c80ab76
```

Manifest/source records at this handoff:

```text
asset_manifest_endovascular_tools_v3.json
b692a80eb7d6685e86656a7d5265c04cc67bfc2303445aa79d61dd84985ca4da

source/build_endovascular_tools_v3.py
96074901c5841a17f69e8af3d4397f06a0d998a88730614bdfdb68a78915e232

blender/endovascular_tools_educational_v3.blend
6ce7f2a6dc07f273fb5f2521cebfe05a4a21a1e1a18203d85bbc9f13c74326e2
```

## Strict USD and package audit

- All twelve `/usr/bin/usdchecker --arkit --strict` invocations returned exit
  code 0 and `Success!`.
- Stages declare `metersPerUnit = 1` and `upAxis = "Y"`.
- Every USDZ contains exactly one root USDC.
- Packages contain no camera, light, preview floor, environment map, bitmap
  texture, absolute path, or external file dependency.
- Export explicitly disables animation, cameras, lights, MaterialX, and world
  material; it exports USD Preview Surface materials and triangulated meshes.
- Accessibility descriptions retain the generic-education and non-clinical
  safety boundary.

## RealityKit audit

RealityKit loaded all twelve packages. Per-package results contain:

- 10–490 nonzero entities;
- 4–244 nonzero model/mesh components;
- 4–244 nonzero material assignments;
- positive finite visual bounds on all three axes.

The runtime probe used
`research/realitykit_load_probe.swift` and
`Entity.load(contentsOf:)`. Load timings were deliberately omitted as product
claims because the run mixed cold and warm loads and is not a performance
benchmark.

Machine-readable counts are recorded in
`validation/endovascular_tools_validation_v3.json`.

## Aggregate/exclusion audit

- `vascular_access_setup_review_assembly_v3` duplicates four independent
  packages and excludes all four transitively.
- `endovascular_tools_workflow_review_assembly_v3` duplicates all ten
  independent packages and excludes all ten plus the access assembly.
- Independent packages reciprocally list the applicable review assembly in
  `prohibited_co_load_asset_ids`.
- The complete review assembly's 135,860 triangles equal the sum of the ten
  independent packages, confirming that it is an aggregate rather than a source
  of additional unique tool geometry.

Runtime experiences should stream independent packages by explanatory state.
The review assemblies are authoring/clinical-review conveniences only.

## Visual QA

All twelve 1400 × 950 rendered-material previews in
`previews/endovascular_tools_v3/` were inspected. The final pass includes:

- dark blue clinical-neutral staging with readable silhouettes;
- blue-gray/teal polymer separation without manufacturer coding;
- distinct metallic cannula, wire, clamp, tray, and bowl reflections;
- readable pump, canister, tubing, manifold, syringe, access, hemostasis, tray,
  and suite-control forms;
- no missing-material magenta, clipping, logos, product markings, numeric dose
  labels, functional control labels, or external imagery;
- tighter framing for the complete workflow review assembly.

Visual plausibility does not establish that the representations match a
specific product, compatibility system, access plan, clinical protocol, or
institutional setup.

## Physics and semantic QA

- All packages are static presentation geometry.
- Optional application motion may be kinematic only and must not be represented
  as validated clinical simulation.
- No fluid, pressure, pump, insertion, puncture, closure, vessel, tissue,
  device-vessel, clot, radiation, or sterile-field physics are encoded.
- Canister/syringe contents are static visual meshes.
- Manifest stage order and `narrative_may_*` relationships are explicitly
  descriptive rather than procedural requirements.
- Access route, anesthesia/sedation, reperfusion strategy, contrast/flush,
  controls, and hemostasis remain conditional.

Technical and visual validation does not establish clinical correctness,
completeness, procedural-training validity, regulatory readiness, or patient
safety.
