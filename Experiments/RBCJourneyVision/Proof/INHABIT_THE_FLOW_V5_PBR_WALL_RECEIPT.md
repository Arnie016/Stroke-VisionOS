# Inhabit the Flow V5 — PBR arterial-wall receipt

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — bounded native material integration, 52 contract checks,
generic visionOS Simulator build, and matched local A/B review. LIMITED — the
wall remains a stylized teaching surface; no XCAT/wearer, specialist, CFD,
histology, patient, or clinical proof.**

## What changed

- The native inward-facing main corridor and both branches now receive a thin
  PBR microtexture overlay while retaining the existing translucent intima and
  media layers.
- The runtime extracts only a `PhysicallyBasedMaterial` that contains albedo,
  normal, and roughness textures from the packaged authored arterial cutaway.
  If any map is missing, the extra layer is omitted.
- The generated tube duplicates its radial seam and supplies UVs, tangents, and
  bitangents. The overlay reads depth but does not write it, preserving cells,
  traveling light, route outlines, and the fixed-wearer composition.
- No external asset, network request, patient data, camera motion, or new UI
  surface was added.

## Provenance

The reused generic arterial-wall material is documented in
`docs/assets/source-notes/IMAGEGEN_HEAD_DETAIL_MATERIALS.md` and validated in
`docs/assets/validation/BLOODFLOW_ASSET_VALIDATION_V2.md`. It is an authored
teaching texture, not a photograph, patient scan, histology slide, or clinical
measurement.

- `artery_cutaway_complete_v2.usdz` SHA-256:
  `d8c8dc03ce6f430153c0fb764308077a8ddb30c64cd74749c1cee1e4871f22f9`
- Albedo SHA-256:
  `dc3ecf92b3d4ca1c2db36a763b3d5b2863f588670c562ba72cc67bcbbba31ae9`
- OpenGL normal SHA-256:
  `fa7207ad71610d32c0196c6b1e07de2ccff4af8413865d8ce4a49044ff183d8f`
- Roughness SHA-256:
  `06d2f99b77486a995ef01d4b26668dea4d943a8c920386e0ce37eee30657f989`

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (52 checks).
- Xcode 26.6 (17F113), XRSimulator 26.5.
- Unsigned generic visionOS Simulator Debug build: `** BUILD SUCCEEDED **`.
- Product:
  `/tmp/rbc-wall-pbr-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`
- Physical Apple Vision Pro `XCAT`: not run for this pass.

## Accepted local visual proof

- `125-pbr-wall-overview-accepted.png`: 3840 × 2160; SHA-256
  `096e51c5a1ccfb7183e6a3f62beb5d719fae207ac8ac9f88b6c69557edd19388`.
- `126-pbr-wall-frontal-accepted.png`: 3840 × 2160; SHA-256
  `9a337af6b9fd1c14e993f83da3708b96efef3c8da210eaa694d6914e314130a2`.
- `127-pbr-wall-ab-contact-sheet-accepted.png`: top row Overview and bottom row
  Frontal, with pre-pass on the left and PBR pass on the right; 3840 × 2160;
  SHA-256
  `41634a5387bee00cb73aeea6d63894b43bd81e184fddffb6b39778628f786b60`.

Codex visual verdict: **PROMOTE locally, modest improvement.** The wall gains
subtle fibrous and roughness breakup without a visible UV seam, z-fighting, or
loss of route readability. The A/B does not justify a photoreal or biological
fidelity claim.

## Source receipt

- `Sources/RBCJourneyScene.swift` SHA-256:
  `1a8f4ee21ba8c88735037aabe47f57008d17804922e72c823a00f88940a06fc7`

## Next honest gate

On XCAT, inspect the wall at the Overview fork and after Frontal transfer. Reject
or reduce the overlay if binocular viewing makes the surface too pale, reveals
the seam, or competes with the flow light. Only a wearer review can promote the
current material beyond Simulator composition proof.
