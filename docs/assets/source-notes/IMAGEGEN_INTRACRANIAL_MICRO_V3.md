# ImageGen intracranial micro-material references — v3

These three project-owned images were generated on 2026-08-08 with the built-in
ImageGen tool. They are visual base-color references for scale-separated Blender
teaching assets. They are not histology, microscopy, patient tissue, anatomical
evidence, diagnostic data, or measured PBR materials.

| File | Intended use | SHA-256 |
|---|---|---|
| `source/intracranial_micro_v3/cerebral_microtissue_albedo_v1.png` | Generic matte neural-tissue material reference | `db9a0383316c47fab2913af9742ad622e425c109b1ee0b1b3b0b85d3394c7a9c` |
| `source/intracranial_micro_v3/myelin_white_matter_albedo_v1.png` | Generic ivory myelin/white-matter material reference | `04ef16d985825d46a3c9d98c1cdd2cd130c404b1ebb9f9a02918a57250a67359` |
| `source/intracranial_micro_v3/thrombus_fibrin_albedo_v1.png` | Generic conceptual thrombus/fibrin material reference | `ca6682ff45f7b4f75cb5b45a55ecdff18fdd7551f5701a89f0881addc741c4fc` |

All sources are 1254 × 1254 RGB PNGs. Treat them as sRGB base-color inputs.
They contain no calibrated roughness, normal, displacement, scale, or clinical
measurement. Any runtime use must be explicitly labelled `conceptual material`.

## Cerebral microtissue prompt

```text
Use case: scientific-educational
Asset type: seamless PBR base-color texture reference for a high-detail Blender neuroanatomy teaching asset
Primary request: a perfectly seamless square tile of generic healthy cerebral microtissue surface at magnified educational scale
Scene/backdrop: the material fills the square edge to edge
Style/medium: photorealistic biomedical material study, visually polished but explicitly not histology
Composition/framing: orthographic top-down macro surface, uniform scale, exactly tileable on all four edges
Lighting/mood: perfectly even diffuse neutral lighting, no directional shadows, no highlights, no vignette
Color palette: restrained warm gray-pink neural tissue with very subtle mottling and fine organic microtexture
Materials/textures: soft matte hydrated tissue appearance, low contrast, no identifiable cells or vessels
Constraints: texture only; seamless; no labels; no text; no watermark; no blood; no lesions; no vessels; no recognizable anatomy; no large-scale folds; no baked lighting; no clinical claim
Avoid: gore, pathology, glossy plastic, brain gyri, microscopy imagery, repeating motifs, directional grain
```

## Myelin/white-matter prompt and refinement

Initial generation prompt:

```text
Use case: scientific-educational
Asset type: seamless PBR base-color texture reference for Blender white-matter and myelin teaching assets
Primary request: a perfectly seamless square tile suggesting clean generic myelin-rich white matter at magnified educational scale
Scene/backdrop: material fills the entire square edge to edge
Style/medium: photorealistic biomedical material study, polished but explicitly not histology or microscopy
Composition/framing: orthographic top-down macro surface, uniform scale, exactly tileable on every edge
Lighting/mood: completely even diffuse neutral illumination, no highlights, shadows, gradient, or vignette
Color palette: pearly warm ivory, pale cream, and very subtle cool-gray variation
Materials/textures: soft satin-matte hydrated tissue with fine restrained lamellar microtexture, low contrast
Constraints: texture only; seamless; no cells; no axon diagrams; no labels; no text; no watermark; no blood; no lesions; no anatomy silhouette; no large bands; no baked lighting; no clinical claim
Avoid: plastic, cheese-like pores, obvious fibers, microscopy imagery, directional grain, repeating motifs
```

The first draft appeared too fibrous, so it was edited once with this targeted
refinement; only the refined file is used:

```text
Use case: precise-object-edit
Input images: Image 1 is the myelin/white-matter base-color texture draft
Primary request: reduce the visible hair-like fibers and directional grain, making the surface smoother, denser, and softly lamellar while preserving the seamless square ivory material concept
Style/medium: photorealistic biomedical material study, explicitly not histology
Lighting/mood: retain perfectly even diffuse neutral lighting
Color palette: retain pearly warm ivory and very subtle cool-gray variation
Constraints: change only the microtexture; keep square edge-to-edge framing; visually seamless on all edges; no cells, axons, labels, text, blood, lesions, anatomy, large bands, shadows, highlights, or watermark
Avoid: fur, cotton, felt, hair, fabric, cheese-like pores, directional fibers, repeating motifs
```

## Conceptual thrombus/fibrin prompt

```text
Use case: scientific-educational
Asset type: seamless PBR base-color texture reference for a Blender conceptual thrombus-composition teaching asset
Primary request: a perfectly seamless square tile of a dense generic thrombus surface at magnified educational scale, suggesting interwoven fibrin and compact red-cell-rich material without showing identifiable cells
Scene/backdrop: material fills the square edge to edge
Style/medium: photorealistic biomedical material study, highly polished but explicitly not histology or patient tissue
Composition/framing: orthographic top-down macro surface, uniform scale, exactly tileable on all edges
Lighting/mood: perfectly even diffuse neutral illumination, no highlights, shadows, gradient, or vignette
Color palette: restrained deep burgundy, muted maroon, subtle dark crimson and small pale fibrin-toned variation
Materials/textures: dense matte hydrated material with fine interlaced microtexture, low-to-moderate contrast
Constraints: texture only; seamless; non-gory; no liquid blood; no identifiable cells; no labels; no text; no watermark; no vessel; no anatomy; no lesion outline; no baked lighting; no diagnostic claim
Avoid: gore, wet shine, open wound, microscopy image, large fibers, repeating motifs, directional grain
```
