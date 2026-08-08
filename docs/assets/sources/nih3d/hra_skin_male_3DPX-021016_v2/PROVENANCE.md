# Geometry, topology and registration inspection

Blender 5.2.0 LTS imported the unmodified source GLB cleanly with no missing
external files.

## Source geometry

- Mesh objects: 1 (`VH_M_skin`)
- Vertices: 414,594
- Edges: 1,243,776
- Polygons/triangles: 829,184
- World bounds after glTF import:
  1.043153 x 0.325631 x 1.824276 m
- World-bounds center: (-0.002881, 0.005049, -0.000964) m
- Materials: 1, authored as a translucent blue HRA display material
- UV layers: none
- Color attributes: none
- Texture images: none

The dimensions and 1.824 m body height show that the glTF imports at plausible
metre scale. No unit normalization is required. glTF Y-up is converted by
Blender to Z-up as expected.

## Topology and disconnected-artifact audit

- Connected components: **1**
- Boundary edges: **0**
- Non-manifold edges: **0**
- Wire edges: **0**
- Zero-area faces: **0**
- Euler characteristic: **2**

This is an unusually clean, closed, connected whole-body surface. No loose
head/face fragments or disconnected internal artifacts were found.

## Head-crop candidates

Raw counts below retain only source vertices at/above the stated Z plane and
count triangles wholly above that plane. A real crop must split the straddling
triangles and cap or conceal the resulting neck boundary.

| Source Z plane | Vertices above | Triangles wholly above | Straddling triangles | Bounds above plane (m) | Assessment |
| ---: | ---: | ---: | ---: | --- | --- |
| 0.620 | 37,138 | 73,923 | 704 | 0.365069 x 0.246412 x 0.291173 | Includes shoulder flare; too broad for a standalone head. |
| 0.640 | 33,144 | 66,000 | 573 | 0.247938 x 0.242102 x 0.271162 | Head plus broad lower neck. Usable if the lower boundary is hidden by a collar. |
| **0.660** | **29,553** | **58,840** | **529** | **0.195671 x 0.242102 x 0.251168** | Recommended clean head/upper-neck starting crop. |
| 0.680 | 27,009 | 53,758 | 518 | 0.195671 x 0.242102 x 0.231166 | Shorter neck; safer for a floating-head presentation. |
| 0.700 | 25,049 | 49,860 | 472 | 0.195671 x 0.242102 x 0.211167 | Primarily head; least useful for cervical access context. |

The source has no UVs or skin texture, and the face is a generic soft-surface
reference rather than a photoreal scan. A production asset still needs a
non-destructive crop, boundary treatment, curvature-aware LODs, UVs, a PBR skin
material and visual QA around the eyelids, nares, lips, ears and chin.

## Registration with the HRA brain

The existing HRA brain source has bounds center
(-0.000090, 0.001155, 0.829567) m. In the native HRA/Visible Human frame, the
brain already occupies the correct head region of the skin. Translating the
skin and brain by `(0.000090, -0.001155, -0.829567)` m is the correct starting
transform for the v2 brain-centered scene.

For the recommended source crop `Z >= 0.660 m`, that translation yields:

- registered crop bounds:
  min (-0.096826, -0.145414, -0.169561) m,
  max (0.098845, 0.096688, 0.081607) m
- registered crop dimensions:
  0.195671 x 0.242102 x 0.251168 m
- registered crop center:
  (0.001009, -0.024363, -0.043977) m

At the brain-center horizontal slice, the skin is approximately
0.162562 x 0.214027 m while the brain's complete maximum dimensions are
0.136377 x 0.167040 m. This confirms useful external clearance and a coherent
shared source frame. Surface-to-brain clearance still needs anatomical and
visual review; bounding boxes are not a substitute for landmark or thickness
validation.

## Registration with the current semantic skull

The current runtime semantic skull was independently centered and normalized;
it is not in the HRA skin's native transform. Its runtime bounds are:

- min (-0.086379, -0.128955, -0.170180) m
- max (0.086379, 0.128955, 0.110180) m
- dimensions 0.172759 x 0.257910 x 0.280360 m

With only the HRA brain-center translation, the skull would extend about
28.6 mm above the skin's superior bound and about 32.3 mm beyond the skin's
positive-Y bound. Therefore the skin is **not** a drop-in match for the current
skull transform. Register the skull to the skin/brain pair using cranial vault,
orbital, nasal, maxillary and occipital landmarks; then repeat containment and
intersection QA. Do not solve the mismatch with an undocumented arbitrary
scale.

## Comparison with the bust-derived option

This HRA skin is the cleaner replacement for a bust-derived scalp shell:

- It provides a complete bilateral bald head, face, ears and neck rather than
  a one-side-skin/one-side-deroofed teaching sculpt.
- It is a single closed manifold surface with no disconnected pieces.
- It already shares a coherent native frame with the HRA brain.
- A head crop is roughly 49k-59k source triangles depending on the selected
  neck plane, which is practical for a high-detail visionOS layer before LOD
  creation.

It is **not polished out of the box**: it has no texture, no UVs and relatively
soft generic facial detail. Use it as the anatomical shell source, then author
the production PBR/LOD treatment.

## Inspection artifacts

- `inspection_blender_5.2.0.json`: clean-import and geometry report
- `registration_crop_inspection_blender_5.2.0_final.json`: topology, crop and
  registration measurements
- `previews_final/hra_skin_head_front_source.png`: temporary clay front QA
- `previews_final/hra_skin_head_side_source.png`: temporary clay side QA
- `../../../source/inspect_hra_skin_registration.py`: reproducible read-only
  inspection script
