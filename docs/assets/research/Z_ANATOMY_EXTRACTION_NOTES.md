# Z-Anatomy focused extraction map

Source: `../vendor/z_anatomy/Z-Anatomy/Startup.blend`

Generated with Blender 5.2 LTS using `../source/focused_inventory_z_anatomy.py`.
The script opens the atlas with auto-execution disabled and does not modify the
source blend.

## Recommended hero assembly

| Extraction group | Objects | Raw evaluated polygons | Source dimensions (m) | Recommended use |
| --- | ---: | ---: | --- | --- |
| `cerebral_cortex` | 126 | 102,586 | 0.138 x 0.181 x 0.118 | Tiled visible cortex; preserve all tiles and transforms |
| `cerebellum` | 33 | 150,509 | 0.098 x 0.091 x 0.057 | Detailed cerebellar surface; curvature-aware decimation |
| `brainstem_surface` | 6 | 44,682 | 0.041 x 0.044 x 0.079 | Midbrain, pons, and medulla outer form |
| `cranial_vault` | 8 | 68,117 | 0.149 x 0.190 x 0.157 | Transparent/cutaway cranial enclosure |
| `skull_core` | 22 | 105,785 | 0.149 x 0.204 x 0.209 | Principal skull bones plus mandible; excludes teeth/ossicles |
| `circle_of_willis_core` | 12 | 43,712 | 0.111 x 0.105 x 0.218 | Orientation/inflow vessel layer |
| `cerebral_arterial_tree` | 40 | 172,736 | 0.142 x 0.152 x 0.280 | Major intracranial vessels, including MCA and cerebellar branches |
| `mca_left_stroke_path` | 6 | 9,504 | 0.062 x 0.081 x 0.192 | Left ICA-to-MCA illustrative thrombectomy path |
| `mca_right_stroke_path` | 6 | 9,504 | 0.062 x 0.081 x 0.192 | Right ICA-to-MCA illustrative thrombectomy path |
| `scalp_shell` | 8 | 768 | 0.164 x 0.202 x 0.152 | Epicranial patches only; requires remesh/seam cleanup |
| `outer_head_regions` | 87 | 16,459 | 0.196 x 0.248 x 0.256 | Full regional head surface; requires substantial surface QA |

The authoritative exact object-name lists, target high/medium/low LOD budgets,
and processing notes are in `z_anatomy_extraction_map.json`. The larger
`z_anatomy_focused_inventory.json` is an audit/discovery file and intentionally
over-matches related anatomy.

## Selection decisions

- Cortex is exactly the non-helper geometry directly assigned to `Neo-cortex`.
- Cerebellum is exactly the non-helper geometry directly assigned to
  `Cerebellum`.
- The hero brainstem is limited to the bilateral midbrain, pons, and medulla;
  nuclei, ventricles, and annotation helpers are not part of that group.
- `cranial_vault` preserves eight bones independently so a frontal/parietal
  cutaway can be staged without destructively changing the source.
- `skull_core` adds principal facial bones and mandible but deliberately omits
  teeth, ear ossicles, sinus cavities, and nasal cartilage.
- The Circle of Willis and MCA groups use exact artery names. Curves should be
  down-resolved before mesh conversion because the atlas bevel settings inflate
  evaluated polygon counts.
- Label/helper objects ending in `.g`, `.j`, or `.t`, text, empties, cameras,
  lights, and zero-polygon meshes are excluded.

## License and clinical cautions

The bundled Z-Anatomy license requires these model attributions:

- “BodyParts3D - The Database Center for Life Science - CC-BY-SA 2.1 Japan”
- “Z-Anatomy - The libre 3D atlas of anatomy - CC-BY-SA 4.0”

Z-Anatomy states that copied or modified geometry must be distributed under the
same license. Therefore, derived USD/USDZ assets should be treated as CC BY-SA
material, with attribution carried into the app and distribution package. Have
licensing counsel confirm compatibility before incorporating these derivatives
into a proprietary commercial product.

The atlas license also lists several referenced/included third-party models.
This extraction deliberately excludes white matter, cranial nerves/foramina,
inner ear structures, and kidney content, but the precise provenance of every
selected mesh should still be reviewed before release.

These are general educational anatomy models. They are not patient-specific,
clinically validated segmentation, a surgical plan, or a navigation model. Use
patient-authorized DICOM-derived segmentation and clinical review for any
patient-specific visualization.
