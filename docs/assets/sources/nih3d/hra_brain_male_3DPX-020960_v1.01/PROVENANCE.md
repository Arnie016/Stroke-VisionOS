# Geometry and import provenance

Blender 5.2.0 LTS imported the source GLB successfully with no missing external
files.

- Mesh objects: 283, plus 3 empties
- Geometry: 324,855 vertices and 653,212 triangles
- Materials: 2 (`brain_mat`, `retina`); no textures or UV layers
- World bounds after import: 0.136377 × 0.167040 × 0.146096 m
- World-bounds center: (-0.000090, 0.001155, 0.829567) m
- Naming: 282 Allen atlas structures split into `_L`/`_R`, plus
  `VH_M_optic_chiasm`

The dimensions are anatomically plausible in metres, but the model retains its
Visible Human whole-body vertical placement. For a standalone visionOS asset,
translate the hierarchy by the negative bounds center before authoring pivots.

The file contains both broad structures and nested substructures. Do not render
all 283 meshes as a single opaque surface: many represent overlapping semantic
levels. Build an external-brain layer from the cortical gyri plus cerebellum and
brainstem, and keep deep nuclei, white matter, and ventricles as separately
toggleable teaching layers. The exact 283 object names and per-object geometry
are recorded in `../inspection_blender_5.2.0.json`.
