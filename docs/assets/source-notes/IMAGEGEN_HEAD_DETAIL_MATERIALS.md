# ImageGen head-detail material sources

Generated on 2026-08-08 with the built-in OpenAI ImageGen tool for the generic
Vision Pro patient-education prototype. These are original visual material maps,
not photographs of a patient, diagnostic data, histology, or clinically
validated tissue measurements.

All four files are 1254 × 1254 RGB PNG base-color maps. Treat them as sRGB.
They intentionally contain no baked directional light, labels, anatomy,
identifiers, wounds, or graphic content. Roughness, normal, subsurface, and
optical parameters are authored separately in Blender.

## `source/head_skin_albedo_v1.png`

- SHA-256: `a94a4937b7fd8abe345d0c7dd6e74b2310ac61a8796022cfa602df4fd64108f0`
- Intended use: generic scalp/outer-head surface material.
- Prompt summary: seamless photorealistic healthy adult craniofacial skin
  albedo, neutral medium-light tone, fine pores and vellus microtexture, even
  cross-polarized-style lighting, no identifiable features, hair, marks,
  wounds, text, or watermark.

## `source/dura_albedo_v1.png`

- SHA-256: `39ec4cbf3c7ecf20730712bf744e0b6cbabd5d040621611ce5cd40694511f813`
- Intended use: clearly conceptual dura/meningeal teaching shell.
- Prompt summary: seamless pale ivory-pink fibrous membrane albedo with fine
  collagen variation, flat even lighting, patient-friendly and non-gory, no
  vessels, blood, specimen edges, text, or watermark.

## `source/arterial_wall_albedo_v1.png`

- SHA-256: `dc3ecf92b3d4ca1c2db36a763b3d5b2863f588670c562ba72cc67bcbbba31ae9`
- Intended use: close-up cerebral arterial-wall teaching surfaces.
- Prompt summary: seamless deep-muted-crimson elastic tissue albedo with fine
  longitudinal/circumferential fiber variation, flat even lighting, no lumen,
  cells, clot, blood pool, specimen edge, text, or watermark.

## `source/venous_wall_albedo_v1.png`

- SHA-256: `d5c553b4bff73b02a78da4a3291608e95026166a9f949b6292517a561dc9d102`
- Intended use: generic cranial venous-wall and dural-sinus teaching surfaces.
- Prompt summary: seamless muted deep-burgundy connective-tissue albedo with
  a restrained cool-plum undertone and fine longitudinal collagen variation,
  under uniform cross-polarized-style lighting; no vessel tube, lumen, blood
  cells, clot, wound, anatomy, text, or watermark.
- Derived OpenGL normal: `source/venous_wall_normal_gl_v1.png`, SHA-256
  `ce1b5090995df0c103038686821e8b22e54e62d38d0a5c041b46b5ae3a4521bb`.
- Derived roughness: `source/venous_wall_roughness_v1.png`, SHA-256
  `2f034b5ec00428a3839b80b53e2b91152ab4805f242ed73b8972cefc4aed343b`.

## Use boundary

These maps add visual polish only. They must not be interpreted as tissue
pathology, patient phenotype, quantitative anatomy, material properties, or
evidence of clinical accuracy. Any patient-facing color, scale, or tissue-layer
claim still requires specialist and human-factors review.
