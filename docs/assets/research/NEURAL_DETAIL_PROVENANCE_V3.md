# Neural-detail module provenance v3

## Original source

- Title: **Brain, Male**
- Creator displayed by NIH 3D: **HRA (Human Reference Atlas)**
- NIH 3D entry: **3DPX-020960**, entry version **1.01**
- HRA source-file label: `hra-reference-organ-brain-male-v1.3.glb`
- Original filename: `3d-vh-m-allen-brain.glb`
- Entry page: <https://3d.nih.gov/entries/20960?version=1.01>
- Licence: **CC BY 4.0**
- Local unmodified source:
  `vendor/nih3d/hra_brain_male_3DPX-020960_v1.01/source/3d-vh-m-allen-brain.glb`
- Source bytes: 11,977,312
- Source SHA-256:
  `2b9ad5b53e40e9f0936da74f7be38d2eed15604e26358c3870a0ea13499b9a35`

The vendored source's `SOURCE.md`, `PROVENANCE.md`, and `LICENSE.md` remain the
canonical acquisition and licence record.

## Source geometry audit

Blender 5.2.0 LTS imports 283 mesh objects: 282 Allen-labelled left/right atlas
structures and the midline `VH_M_optic_chiasm`. Imported geometry totals 653,212
triangles and has metre-scale dimensions of approximately
0.136377 × 0.167040 × 0.146096 m. The recorded full-source bounds centre is
(-0.000090, 0.001155, 0.829567) m.

This module selects 275 source meshes into 14 nonempty runtime groups. Eight
overlapping broad/alternate meshes are omitted in favour of more detailed source
children: bilateral amygdaloid complex, thalamus, hypothalamus, and
posteroventral putamen. The exact selection, laterality, group assignment,
omission, and reason are machine-readable in
`hra_neural_detail_semantic_audit_v3.json`.

## Modifications

The project made the following modifications to the CC BY source:

- selected and grouped semantic meshes without renaming their anatomical source
  identity;
- translated native HRA coordinates by the negative recorded source bounds centre
  to match the existing project brain frame;
- baked mesh transforms and authored metre/Y-up USD packages;
- applied runtime-conscious collapse decimation to heavier groups while retaining
  each named object as an independent semantic child;
- enabled smooth shading and assigned restrained opaque PBR teaching materials;
- authored 14 independently loadable packages and one unilateral opaque review
  assembly; and
- generated seven presentation-only preview renders. Cameras, lights, and backdrop
  are not included in the runtime packages.

No external geometry, online marketplace model, ImageGen anatomy, procedural
neural structure, patient scan, or inferred missing anatomy was added.

## Known source absences

The GLB has no pituitary or choroid plexus. It has ventricular space surfaces but
no CSF particles, pressure, flow, or boundary conditions. It is macroscopic atlas
anatomy and has no validated microscopic neurons, glia, synapses, axonal bundles,
or myelin microstructure.

## Rebuild

From `vision_pro_stroke_kit_v2`:

```bash
/Applications/Blender.app/Contents/MacOS/Blender \
  --background \
  --python source/build_neural_detail_v3.py
```

Rebuilding rewrites only the v3 neural-detail manifest, its v3 assets, editable
blend, semantic audit, and preview directory. It does not edit prior manifests.
