# Endovascular tools v3 — source provenance

Validated record date: 2026-08-09 SGT

## Source declaration

All geometry, materials, object metadata, layouts, and previews in
`endovascular_tools_v3` were authored procedurally for this project in Blender
5.2.0 LTS. The module does not incorporate a downloaded model, FAB asset,
manufacturer CAD file, product photograph, trademark, logo, texture, or
manufacturer-specific product design.

The models represent broad tool categories rather than marketed products. Their
dimensions, connector forms, colors, control layouts, tubing routes, and
relative arrangements are presentation choices for a generic educational
prototype and are not specifications.

## Authored deliverables

| Deliverable | Path | Role |
|---|---|---|
| Procedural generator | `source/build_endovascular_tools_v3.py` | Recreates geometry, PBR materials, metadata, USD exports, previews, manifest, and editable source |
| Editable Blender source | `blender/endovascular_tools_educational_v3.blend` | Master editable scene containing independent collections and duplicate review assemblies |
| Manifest | `asset_manifest_endovascular_tools_v3.json` | Machine-readable IDs, stage associations, safety state, relationships, exclusions, sizes, and package hashes |
| Independent/review USD | `exports/usdc/<asset-id>.usdc` | Editable/layerable authoring interchange |
| visionOS packages | `exports/usdz/<asset-id>.usdz` | Self-contained RealityKit delivery packages |
| Preview set | `previews/endovascular_tools_v3/` | Twelve rendered-material QA frames, one per package |

## Asset authorship inventory

The generator creates the following ten independent packages:

1. `vascular_access_needle_educational_v3`
2. `vascular_access_wire_educational_v3`
3. `introducer_sheath_dilator_set_educational_v3`
4. `guide_catheter_hemostatic_valve_educational_v3`
5. `aspiration_pump_canister_tubing_educational_v3`
6. `contrast_manifold_syringe_flush_educational_v3`
7. `torque_device_y_connector_accessories_educational_v3`
8. `puncture_site_hemostasis_options_educational_v3`
9. `sterile_endovascular_instrument_tray_educational_v3`
10. `angiography_suite_controls_educational_v3`

It also creates two duplicate-geometry review packages:

11. `vascular_access_setup_review_assembly_v3`
12. `endovascular_tools_workflow_review_assembly_v3`

No aggregate is a hidden source of additional unique tool geometry. The access
assembly duplicates four independent packages, and the complete workflow
assembly duplicates all ten. The manifest defines transitive co-load
exclusions.

## Geometry construction

The source uses Blender primitives and project-authored curve paths:

- beveled boxes for equipment housings, trays, dressings, and controls;
- cylinders, cones, and toroidal collars for connectors, cannulas, ports,
  syringe barrels, valve hubs, and equipment details;
- converted Bezier tubes for wires, catheters, cables, and tubing;
- UV spheres for generic compression pads;
- procedural duplication with explicit transforms for the two review
  assemblies.

Every exported object is a mesh. Camera, lights, background plane, and preview
staging remain in a presentation-only collection and are excluded from the
asset exports.

## Material construction

Materials use Blender Principled BSDF nodes and USD Preview Surface export.
They are solid-color, procedural PBR approximations for:

- surgical steel and dark steel;
- gold-toned marker accents;
- generic teal, blue, blue-gray, frosted, and equipment polymers;
- rubber, gauze, dressing, and sterile-drape context;
- abstract screen emission;
- static illustrative canister/syringe contents and tubing.

No bitmap, normal map, image texture, environment map, linked library, or
external file reference is required by the assets. Color accents are not
manufacturer coding, medication labels, standardized control colors, or
compatibility indicators.

## Coordinate and packaging contract

- Blender authoring units: metres.
- USD `metersPerUnit`: 1.
- USD up axis: Y.
- Root prim path: `/Asset`.
- Curves are converted to meshes before export.
- Export excludes animation, cameras, lights, and world material.
- Every USDZ contains exactly one root USDC and no external dependency.
- Accessibility descriptions carry the generic/non-clinical safety boundary.

## Reproducibility

From the kit root, run:

```bash
/Applications/Blender.app/Contents/MacOS/Blender \
  --background --factory-startup \
  --python source/build_endovascular_tools_v3.py
```

The generator writes into existing shared `exports/usdc`, `exports/usdz`, and
`blender` folders but only uses the twelve IDs owned by this module. It does not
modify any other manifest or module.

## Final source-record hashes

These hashes identify the handoff files, not a public release signature:

```text
asset_manifest_endovascular_tools_v3.json
b692a80eb7d6685e86656a7d5265c04cc67bfc2303445aa79d61dd84985ca4da

source/build_endovascular_tools_v3.py
96074901c5841a17f69e8af3d4397f06a0d998a88730614bdfdb68a78915e232

blender/endovascular_tools_educational_v3.blend
6ce7f2a6dc07f273fb5f2521cebfe05a4a21a1e1a18203d85bbc9f13c74326e2
```

The per-package USDZ hashes are authoritative in
`asset_manifest_endovascular_tools_v3.json` and repeated in
`validation/ENDOVASCULAR_TOOLS_VALIDATION_V3.md`.

## Rights and release note

This provenance record establishes that the module was generated without an
external asset dependency. It is not a legal opinion about the repository's
overall licence or release obligations. The project owner must select and apply
the appropriate project licence and preserve this provenance record.

## Clinical and regulatory boundary

Source provenance does not establish clinical validity, training suitability,
completeness, device equivalence, compatibility, regulatory status, or patient
safety. This module remains `REQUIRES_SPECIALIST_REVIEW` and
`NOT_VALIDATED_FOR_PROCEDURAL_TRAINING`.
