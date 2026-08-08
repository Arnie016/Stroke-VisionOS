# Cerebral blood-flow teaching module v2

This module is a set of polished, generic educational visuals for the Vision Pro stroke experience. It is designed to explain concepts to patients without presenting a graphic surgical scene.

## Included assets

- `artery_wall_cutaway_v2`: magnified three-layer wall with a longitudinal viewing window.
- `artery_interior_bloodflow_v2`: separate transparent lumen fill, magnified red blood cells, streamlines, and direction arrows.
- `artery_cutaway_complete_v2`: wall and interior cues combined.
- `circle_of_willis_flow_overlay_v2`: simplified major cerebral-flow routes in the same metre-scale origin frame as the v2 head assets.
- `red_blood_cells_closeup_v2`: magnified biconcave-cell teaching vignette.
- `microcirculation_arterial_venous_v2`: conceptual arteriole-to-capillary-to-venule transition.
- `cerebral_bloodflow_animation_v2`: a four-second, 30 fps baked transform-animation example.
- `cerebral_bloodflow_teaching_set_v2`: static comparison layout containing the main vignettes.

The wall and blood-volume packages are separate so the patient experience can reveal the vessel wall first, then add the lumen, cells, and flow cues. Individual packages should be lazy-loaded in the app; the combined package is for presentation and QA.

## RealityKit animation example

The animated USDZ stores transform time samples from frames 1–121 at 30 time codes per second. After loading the entity, play the first imported animation resource:

```swift
let entity = try await Entity(contentsOf: bloodflowAnimationURL)
if let animation = entity.availableAnimations.first {
    entity.playAnimation(animation.repeat())
}
```

The timing is intentionally explanatory. It does not represent a measured pulse wave, blood velocity, pressure, transit time, collateral flow, or perfusion.

## Scale and visual language

- USD stages use `metersPerUnit = 1` and `upAxis = "Y"`.
- The cerebral overlay is a real-world-scale placement guide; it remains a simplified route overlay rather than a segmented artery model.
- The vessel cutaway, RBC close-up, and microcirculation vignette are magnified teaching models. Do not compare their relative sizes with the head anatomy.
- Warm red/orange identifies arterial inflow and direction cues. The cool venous hue is an interface convention; venous blood is not literally blue.
- Emissive line width, arrow spacing, particle density, and animation timing have no quantitative meaning.

## Texture provenance

The media layer uses the synthetic texture set in `textures/source/`:

- `arterial_wall_albedo_v1.png`: ImageGen-created generic arterial-wall albedo.
- `arterial_wall_normal_gl_v1.png`: subtle OpenGL tangent-space normal map derived for the material.
- `arterial_wall_roughness_v1.png`: non-color roughness data.

These are illustrative PBR surface maps, not photographs, histology, pathology slides, or patient tissue. Blender packs the maps into the editable `.blend`, and USDZ packages contain the referenced maps.

## Required clinical review

Before any patient-facing release, an interventional neuroradiologist or vascular neurologist should review:

1. Route names, laterality, and placement of the Circle-of-Willis/MCA overlay.
2. The verbal explanation paired with each animation.
3. Whether the wall-layer simplification is appropriate for the intended audience.
4. The distinction between magnified vignettes and anatomical-scale assets.
5. Color language, accessibility, and the explicit statement that venous blood is dark red rather than blue.
6. Every claim about stroke, thrombectomy, perfusion, risk, benefit, and outcome.

## Prohibited interpretations

This module is not CFD, quantitative hemodynamics, patient-specific anatomy, perfusion analysis, or a medical device. It is not derived from CTA, MRA, DSA, Doppler, pressure, velocity, or perfusion measurements. Do not use it for diagnosis, treatment planning, navigation, collateral grading, vessel/device sizing, procedural rehearsal, outcome prediction, or any clinical decision.

The reproducible build script is `source/build_cerebral_bloodflow_v2.py`; the editable scene is `blender/cerebral_bloodflow_educational_v2.blend`; machine-readable metadata is in `asset_manifest_bloodflow_v2.json`.
