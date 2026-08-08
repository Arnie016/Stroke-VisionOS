# Asset provenance and transformation record

## Scope

The committed catalog contains 65 unique, manifest-backed runtime USDZ
packages: 36 higher-detail v2 assets and 29 low-poly prototype-v1 assets. The
unmanifested `stroke_kit_asset_gallery.usdz` review composite is intentionally
excluded because it duplicates the prototype geometry and is not an independent
runtime asset.

No raw scans, patient records, identifiers, private source archives, Blender
working files, or vendor GLBs are included in this pull request.

## Coordinate and export conventions

- Runtime unit: metres (`metersPerUnit = 1`).
- USD up axis: Y.
- Delivery format: USDZ containing USD-compatible geometry and PBR materials.
- Blender source orientation was converted and verified during USD export; the
  runtime packages must not receive an additional minus-90-degree correction.
- Combined assemblies are review conveniences. Prefer separately toggleable
  opaque layers in the patient-facing experience.

## NIH 3D / Human Reference Atlas sources

### Brain

- Work: HRA Brain, Male, NIH 3D `3DPX-020960`, version `1.01`.
- Source: <https://3d.nih.gov/entries/20960?version=1.01>
- Changes: semantic selection, recentering, region joining, practical runtime
  reduction, smoothing, UV preparation, project PBR materials, and USD export.

### Skull and eyes

- Work: Visible Human Male Skull and Eyes, NIH 3D `3DPX-020591`, version
  `1.03`.
- Source: <https://3d.nih.gov/entries/20591?version=1.03>
- Changes: scale normalization to metres, recentering, reorientation, baked
  transforms, practical runtime reduction, and USD export while preserving
  semantic separation.

### Skin

- Work: Skin, Male, NIH 3D `3DPX-021016`, version `2`.
- Source: <https://3d.nih.gov/entries/21016?version=2>
- Changes: head/upper-neck crop, capped crop boundary, registration in the HRA
  brain frame, UVs, runtime geometry, cutaway variant, and project PBR maps.

Exact source hashes and notices are retained under [`sources/nih3d`](sources/nih3d).

## Z-Anatomy / BodyParts3D sources

- Z-Anatomy source: <https://github.com/Z-Anatomy/Models-of-human-anatomy>
- BodyParts3D source: <https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html>
- Changes: selected named arterial, meningeal, venous, sinus, jugular, and neck
  access structures; reduced curve/mesh complexity; converted curves where
  needed; registered to the generic brain frame; applied project materials;
  and exported independently toggleable USDZ layers.
- Bony frontal and sphenoid air sinuses were explicitly excluded from the
  cranial-vascular selection.

## Original procedural and generated work

The thrombus, generic procedure devices, artery cutaway, lumen cues,
biconcave-cell teaching models, microcirculation vignette, direction markers,
and four-second transform animation are original project constructions.

The source texture folder includes project-created base-color maps and derived
OpenGL normal/roughness maps. The ImageGen prompt summaries and hashes are in
[`source-notes/IMAGEGEN_HEAD_DETAIL_MATERIALS.md`](source-notes/IMAGEGEN_HEAD_DETAIL_MATERIALS.md).

## Clinical meaning boundary

Every model is generic and non-patient-specific. Conceptual layers, clot size,
flow direction markers, magnified blood cells, cutaway thicknesses, colours,
and procedure-device proportions are educational abstractions. They are not
measurements, CFD results, a treatment recommendation, or evidence for a real
patient.
