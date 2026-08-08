# Intracranial microanatomy teaching module v3

This module adds eleven independent, magnified explanatory vignettes and one
review assembly. It fills scale domains that are intentionally absent from the
metre-scale head atlas: cellular neurovascular context, formed blood elements,
thrombus composition cues, neural/glial forms, a synapse, the choroid/CSF
interface, and a conceptual ischemic-zone explanation.

These packages are **not microscopy, histology, patient anatomy, measured
physiology, pathology classification, CFD, or clinical simulation**. Geometry,
spacing, counts, thickness, color, composition, channel markers, and tissue
zones are deliberately exaggerated for legibility. Every use must show
“Magnified educational view — not to anatomical scale.”

## Runtime contract

- Manifest: `asset_manifest_intracranial_micro_v3.json`
- Module: `intracranial_micro_v3`
- Editable source: `blender/intracranial_micro_teaching_v3.blend`
- Generator: `source/build_intracranial_micro_v3.py`
- Units: metres for engine interoperability, not real cell dimensions
- USD up axis: Y
- Registration: none; all assets belong under a separate
  `TeachingVignetteRoot/MicroScaleRoot`
- Scale domain: `microscopic_conceptual_separate`
- Runtime materials: opaque PBR; cutaways are modeled openings rather than
  stacked transparency
- Clinical state: `REQUIRES_SPECIALIST_REVIEW`

Never parent these assets beneath the registered head with an identity
transform. A vignette may be linked narratively to a selected artery, clot,
ventricle, or brain region, but it must appear beside the head with an explicit
scale break and caption.

## Independent assets

1. `blood_brain_barrier_neurovascular_unit_conceptual_v3` — opened capillary
   wall with an exaggerated endothelial layer, tight-junction seams, basement
   membrane, pericyte, astrocyte/endfoot cues, and magnified RBC context. It can
   explain the *components commonly discussed around the neurovascular unit*;
   it cannot show permeability, transport, edema formation, drug delivery, or
   measured barrier function.
2. `capillary_endothelium_tight_junctions_conceptual_v3` — flattened close-up
   of endothelial-cell tiles, nuclei, basement membrane, a pericyte cue, and
   highlighted intercellular seams. The seams are not molecular models and do
   not encode junction proteins, pore size, transport, or integrity.
3. `formed_blood_elements_magnified_v3` — biconcave RBC forms, a generic
   leukocyte cutaway with lobed-nucleus cue, and platelets with illustrative
   granules. Cell counts, proportions, subtype, activation, oxygenation, and
   laboratory values are not represented.
4. `platelet_fibrin_thrombus_microstructure_conceptual_v3` — opened vessel
   context with entrapped RBCs, platelet-rich cues, a fine fibrin network, and
   an ImageGen-textured clot volume. It must not be used to infer clot age,
   etiology, composition, device response, recanalization probability, or
   pathology.
5. `multipolar_neuron_detailed_conceptual_v3` — generic soma, nucleus,
   dendrites, enlarged spine cues, axon, and terminal branches. It is not a
   traced neuron, cell-type classification, connectome, electrophysiology, or
   lesion-response model.
6. `astrocyte_capillary_endfeet_conceptual_v3` — branching astrocyte with
   enlarged endfeet approaching an opaque capillary. Contact area, coverage,
   signaling, edema, and transport are not quantitative.
7. `oligodendrocyte_myelinated_axons_conceptual_v3` — one generic
   oligodendrocyte connected to several simplified internodes. It does not
   encode one cell’s true internode count, axon caliber, myelin thickness, or
   demyelination.
8. `myelinated_axon_node_of_ranvier_conceptual_v3` — continuous axon core,
   separated myelin internodes, surface-ring cues, and enlarged channel-location
   markers. The markers have no molecular identity, density, gating, voltage,
   timing, or conduction-speed meaning.
9. `chemical_synapse_closeup_conceptual_v3` — opaque cutaway presynaptic
   terminal, enlarged vesicles, cleft-particle cues, postsynaptic dendrite, and
   generic receptor-location markers. It does not identify a transmitter,
   receptor, concentration, release probability, or signal direction.
10. `choroid_plexus_csf_interface_conceptual_v3` — simplified capillary folds,
    epithelial-cell cues, an opaque CSF field, and direction markers. It cannot
    represent CSF production, pressure, composition, obstruction, circulation,
    hydrocephalus, or clearance.
11. `ischemic_tissue_zones_conceptual_v3` — irregular opaque surrounding,
    at-risk, and core teaching regions with microvessel context. The zones are
    not DWI, ADC, CTP, perfusion thresholds, volumetry, a clock, tissue
    viability, collateral status, prognosis, or a treatment-selection tool.

## Review assembly

`intracranial_micro_teaching_set_v3` places all eleven vignettes in a single
comparison gallery. It is for authoring review and presentation stills. It
duplicates every independent package and must never be loaded with any of them.
The manifest records this transitive exclusion.

The assembly contains 424 RealityKit model components and takes materially
longer to load than the independent packages. Stream one vignette at a time in
the patient experience.

## Relationship to the original 65 assets

The micro module explains selected concepts without modifying the original
registered assets:

| Existing asset or state | Optional v3 vignette | Relationship |
|---|---|---|
| `cerebral_arteries_realistic_v2` | BBB or endothelial close-up | Narrative zoom only; no geometric registration |
| `ischemic_mca_clot_v2` | thrombus microstructure | Conceptual composition explanation; not the same mesh or a sampled clot |
| `red_blood_cells_closeup_v2` | formed blood elements | Replaces the simpler RBC-only close-up when leukocyte/platelet context is needed |
| `microcirculation_arterial_venous_v2` | BBB/astrocyte/endothelial views | Adjacent lesson steps, never stacked at matched scale |
| `brain_anatomy_realistic_v2` or a neural v3 region | neuron/glia/axon/synapse | Semantic drill-down selected by lesson metadata, not spatial coordinates |
| `brain_ventricles_v2` or `ventricular_spaces_v3` | choroid/CSF interface | Conceptual explanation only; no ventricle-wall registration |
| ischemic lesson state | ischemic tissue zones | Optional explanation; must not be described as the patient’s core or penumbra |

## Houdini handoff

1. Reference each independent USDC as a payload beneath
   `/StrokeExperience/TeachingVignetteRoot/MicroScaleRoot/<asset_id>`.
2. Preserve `metersPerUnit = 1` and Y-up. Place and scale only the outer
   vignette container; never rewrite internal authored coordinates.
3. Require an app-owned `scaleBreak = true` and
   `magnificationLabelRequired = true` before a micro asset can become visible.
4. Keep the original PBR payload immutable. Put highlight, clipping, labels,
   animation, and lesson state in stronger presentation layers.
5. Treat every component as static or kinematic. Do not enable gravity,
   deformable-body solvers, adhesion, molecular dynamics, diffusion, conduction,
   permeability, pressure, or fluid solvers merely because component geometry
   is present.
6. If illustrative particle motion is added, store authored event times and
   meanings in an external lesson manifest. Mark timing, velocity, density, and
   direction as non-quantitative.
7. Generate coarse selection colliders only. They are input targets, not cell
   boundaries, wall-contact models, lesion margins, or physical interfaces.
8. Reject simultaneous visibility when the recursively expanded leaf set of
   `intracranial_micro_teaching_set_v3` intersects an active individual asset.
9. USDZ is the Vision Pro delivery package. Keep USDC/layered USD as the
   editable Houdini/Solaris source because USDZ is a final archive and does not
   carry Houdini VDB volumes.

## ImageGen appearance references

The generator uses three project-owned PNG base-color references:

- `textures/source/intracranial_micro_v3/cerebral_microtissue_albedo_v1.png`
- `textures/source/intracranial_micro_v3/myelin_white_matter_albedo_v1.png`
- `textures/source/intracranial_micro_v3/thrombus_fibrin_albedo_v1.png`

The exact built-in ImageGen prompts, output paths, hashes, and limitations are
recorded in `textures/IMAGEGEN_INTRACRANIAL_MICRO_V3.md`. These images are
surface-design inputs only. They are not microscopy, histology, anatomy,
pathology, patient tissue, or clinical evidence.

## Required review before any patient-facing pilot

- neuroanatomist or neurologist: neural/glial terminology and lesson mapping;
- neuropathologist or hematologist: formed-element and thrombus language;
- neuroradiologist/stroke specialist: ischemic-zone wording and separation from
  clinical imaging/perfusion concepts;
- accessibility and patient-communications reviewers: color, captions,
  magnification language, motion, and comprehension;
- RealityKit performance review on a physical Apple Vision Pro.

This technical asset pack is not cleared for diagnosis, treatment planning,
navigation, device selection, pathology classification, prognosis, or any
clinical decision.
