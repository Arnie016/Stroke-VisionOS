# Attribution and provenance

Retain this file, the source-specific records under `../sources/`, and the relevant
license text with every distributed build that contains the corresponding
geometry.

## NIH 3D / Human Reference Atlas brain

- Work: **HRA Brain, Male**, NIH 3D entry **3DPX-020960**, version **1.01**
- Source: <https://3d.nih.gov/entries/20960?version=1.01>
- Reference library: <https://humanatlas.io/3d-reference-library>
- License: Creative Commons Attribution 4.0 International (CC BY 4.0)
- Local unmodified source SHA-256:
  `2b9ad5b53e40e9f0936da74f7be38d2eed15604e26358c3870a0ea13499b9a35`
- Modifications: selected external cortex/cerebellum/brainstem and optional deep
  structures; recentered; joined semantic regions; curvature-aware decimation;
  smoothed; UV-mapped; and assigned project PBR materials for USD export.

## NIH 3D / Visible Human skull and eyes

- Work: **Visible Human Male Skull and Eyes**, NIH 3D entry **3DPX-020591**,
  version **1.03**
- Source: <https://3d.nih.gov/entries/20591?version=1.03>
- License: Creative Commons Attribution 4.0 International (CC BY 4.0)
- Local unmodified source SHA-256:
  `7ff9dd022ded5867806a4fccb3ad85010d39edb6d7eaf9c8f66a49e36be522ac`
- Modifications: normalized from source centimetre-like scale to metres;
  recentered; reoriented; transforms baked; geometry decimated for runtime;
  and converted to USD/USDZ while preserving semantic bone separation.

NIH 3D's terms and the complete local CC BY 4.0 text are stored under
`../sources/nih3d/`. NIH 3D describes its models as illustrative/educational rather
than intended for diagnosis or treatment.

## NIH 3D / Human Reference Atlas skin

- Work: **Skin, Male**, NIH 3D entry **3DPX-021016**, version **2**
- Source: <https://3d.nih.gov/entries/21016?version=2>
- Reference library: <https://humanatlas.io/3d-reference-library>
- License: Creative Commons Attribution 4.0 International (CC BY 4.0)
- Local unmodified source SHA-256:
  `4764602f0866fbdad19382e7f12ba148ee33141677153b556f7238116bc33c2a`
- Derived modifications: cropped the full-body watertight skin surface to the
  head and upper neck, capped the crop boundary, recentered in the matching HRA
  brain frame, created UVs and runtime LOD geometry, and applied project PBR
  maps.

The exact official download endpoint, version metadata, source inspection, and
registration audit are retained under
`../sources/nih3d/hra_skin_male_3DPX-021016_v2/`.

## Z-Anatomy / BodyParts3D cerebral arteries

Required source attributions:

- **“Z-Anatomy - The libre 3D atlas of anatomy - CC-BY-SA 4.0”**
  — <https://github.com/Z-Anatomy/Models-of-human-anatomy>
- **“BodyParts3D - The Database Center for Life Science - CC-BY-SA 2.1 Japan”**
  — <https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html>

Modifications: selected 40 named major cerebral-artery curves; reduced curve
resolution; converted curves to mesh; joined and decimated the runtime surface;
registered it to the generic NIH brain by anatomical bounds; applied a PBR
arterial material; and exported USD/USDZ derivatives.

The derived cerebral-artery files must be handled as ShareAlike material. The
source license is stored at `../sources/z_anatomy/LICENSE.txt`; extraction details
and exact selected names are in `../research/Z_ANATOMY_EXTRACTION_NOTES.md` and
`../research/z_anatomy_extraction_map.json`.

## Z-Anatomy / BodyParts3D meningeal partitions

Required source attributions:

- **“Z-Anatomy - The libre 3D atlas of anatomy - CC-BY-SA 4.0”**
  — <https://github.com/Z-Anatomy/Models-of-human-anatomy>
- **“BodyParts3D - The Database Center for Life Science - CC-BY-SA 2.1 Japan”**
  — <https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html>

Modifications: selected the exact named `Falx cerebri`,
`Tentorium cerebelli.l`, and `Tentorium cerebelli.r` objects; registered the
atlas by cortical-center alignment to the generic HRA brain; applied practical
runtime decimation and an opaque PBR material; and exported the structures as
independently toggleable USD/USDZ layers.

These derivatives must retain the applicable ShareAlike notices. The selected
object inventory is retained under `../research/`.

## Original project work

- Conceptual thrombus and unbranded procedure-device geometry: created for this
  project as generic patient-education illustrations.
- Cortex PBR base-color texture: generated for this project using OpenAI
  ImageGen from a prompt requesting a seamless, non-gory, healthy-cortex
  material without anatomy labels or vessel detail.
- Arterial-wall PBR albedo: generated for this project using OpenAI ImageGen
  from a prompt requesting a seamless, non-gory, generic arterial-wall surface.
  The subtle OpenGL normal and roughness maps in
  `../../../RealityKitContent/Assets/vision_pro_stroke_kit_v2/textures/source/`
  were created
  as supporting data maps. They are illustrative materials, not histology or
  patient tissue.
- Generic head-skin, dura, and venous-wall PBR albedos: generated for this
  project using OpenAI ImageGen from prompts requesting seamless, non-gory,
  non-identifying material swatches under flat illumination. Subtle OpenGL
  normal and roughness maps were derived locally. Prompt summaries, hashes, and
  the intended-use boundary are in `IMAGEGEN_HEAD_DETAIL_MATERIALS.md`.
- Layered artery cutaway, blood-volume cue, biconcave RBC models,
  microcirculation vignette, simplified cerebral-flow overlay, direction
  markers, and baked transform animation: original procedural project work.
  The existing cerebral-artery asset was used as a visual coordinate reference;
  its source mesh is not duplicated in the blood-flow module.

These original elements do not convert third-party generic anatomy into
patient-specific or clinically validated content.
