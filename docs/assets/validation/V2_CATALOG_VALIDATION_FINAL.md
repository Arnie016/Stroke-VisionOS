# Final v2 catalogue validation

Validated: 2026-08-08 SGT

## Verdict

**PASS: 36/36 v2 USDZ packages.** The five v2 manifests contain 36 unique
asset IDs, every declared USDZ exists, every final SHA-256 matches its recorded
manifest or the core validation report, all packages pass Apple strict ARKit
validation, and all packages load through RealityKit with nonzero visual models.

This is a technical asset gate, not clinical validation or a device-performance
sign-off.

## Catalogue integrity

- Manifests: `asset_manifest_v2.json`, `asset_manifest_devices_v2.json`,
  `asset_manifest_bloodflow_v2.json`,
  `asset_manifest_cranial_vascular_v2.json`, and
  `asset_manifest_head_details_v2.json`.
- Asset IDs: 36 total, 36 unique, no missing declared USDZs, and no unmanifested
  v2 USDZs in `exports/usdz`.
- Hashes: 29 package hashes match their current manifests. The seven original
  core-anatomy packages predate the hash fields in their manifest; their current
  hashes match `../research/V2_USDZ_VALIDATION.md` exactly.

## Apple and RealityKit checks

- `/usr/bin/usdchecker --arkit --strict`: **36 pass, 0 fail**.
- `Entity.load(contentsOf:)` catalogue probe: **36 pass, 0 fail**.
- Nonzero RealityKit `ModelComponent` instances across the catalogue: **664**.
- `cerebral_bloodflow_animation_v2.usdz`: **PASS**, 26 entities and 24
  RealityKit animation resources.

The complete head, blood-flow, cranial-vascular, device, and core package-level
evidence remains in the adjacent validation reports and
`../research/V2_USDZ_VALIDATION.md`.

## Runtime boundary

Combined assemblies are review conveniences and should be lazy-loaded. Use the
separate opaque layers for the patient sequence, profile the assembled experience
on Apple Vision Pro with RealityKit Trace, and retain all generic/conceptual,
licensing, and specialist-review warnings.
