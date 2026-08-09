# Neural-detail asset notes v3

This module adds source-faithful macroscopic neural anatomy to the Vision Pro
stroke-education kit. It contains **14 independently loadable anatomy assets** and
one registered review assembly. The anatomy comes only from the unmodified NIH
3D / Human Reference Atlas *Brain, Male* source; no neural structure was invented
to fill a source gap.

Every asset is generic, non-patient-specific atlas anatomy and is not validated
for diagnosis, treatment planning, navigation, device placement, or clinical
decision-making. Specialist review is required before supervised education or
clinical-environment evaluation.

## Asset inventory

| Asset ID | Named source children | Role |
|---|---:|---|
| `frontal_cortex_parcellation_v3` | 28 | Bilateral named frontal gyri and lobules |
| `parietal_cortex_parcellation_v3` | 14 | Bilateral named parietal gyri and lobules |
| `temporal_cortex_parcellation_v3` | 16 | Bilateral temporal gyri, auditory planes, poles, and temporal fusiform cortex |
| `occipital_cortex_parcellation_v3` | 12 | Bilateral occipital gyri, poles, cuneus, lingual, and occipital fusiform cortex |
| `insular_opercular_cortex_v3` | 12 | Bilateral short/long insular gyri, limen, agranular insula, and frontal operculum |
| `cingulate_parahippocampal_cortex_v3` | 22 | Bilateral cingulate, parahippocampal, perirhinal, piriform, and related medial cortex |
| `cerebellar_substructures_v3` | 14 | Cerebellar hemispheres, paravermis, vermis, deep nuclei, and peduncles |
| `brainstem_substructures_v3` | 22 | Midbrain, pons, medulla, colliculi, peduncles, olives, and red nuclei |
| `basal_ganglia_deep_nuclei_v3` | 22 | Caudate segments, putamen, pallidum, accumbens, subthalamic region, substantia nigra, claustrum, and zona incerta |
| `thalamic_hypothalamic_nuclei_v3` | 42 | Detailed thalamic nuclei, hypothalamic regions, geniculate/habenular nuclei, mammillary region, and pineal body |
| `hippocampal_amygdala_limbic_nuclei_v3` | 30 | Hippocampal segments, source amygdala nuclei, basal forebrain, bed nucleus, and septal nuclei |
| `ventricular_spaces_v3` | 18 | Lateral-ventricle segments, third/fourth ventricles, aqueduct, and central canal |
| `major_white_matter_regions_v3` | 4 | Broad bilateral forebrain and hindbrain white-matter source volumes |
| `commissural_sensory_pathways_v3` | 19 | Corpus callosum, fornix, anterior commissure, mammillothalamic, optic, and olfactory structures |
| `neural_detail_registered_review_assembly_v3` | 219 | Opaque unilateral cortical reveal of registered cortical, deep, ventricular, pathway, cerebellar, and brainstem layers |

The exact object-by-object allocation is recorded in
`research/hra_neural_detail_semantic_audit_v3.json`. The manifest retains every
source semantic mesh name for each independent package.

## Registration and transform contract

- Source frame: native HRA metre frame.
- Centering translation: `(-0.000090, -0.001155, -0.829567)` metres.
- Runtime units: metres.
- USD up axis: Y.
- Asset root prim: `/Asset`.
- Individual mesh object transforms are baked to identity in Blender before USD
  orientation conversion.
- This is the same HRA brain frame used by the existing v2 realistic brain and
  registered head layers. Do not independently normalize, recentre, or auto-fit
  these assets in Houdini if they must align with the existing head and vessels.

Each child carries `userProperties:source_semantic_name`,
`userProperties:anatomical_group`, `userProperties:laterality`,
`userProperties:registration`, `userProperties:patient_specific`, and retained
HRA/Allen ontology metadata where supplied by the source.

## Assembly and visibility logic

The review assembly is an **opaque source-backed reveal**, not a transparent
brain. It keeps left cortical parcels, omits right cortical parcels, and includes
bilateral deep anatomy. Broad forebrain/hindbrain white-matter parent volumes are
excluded from the assembly so that they do not occlude the detailed pathways and
deep nuclei.

Recommended Houdini/RealityKit logic:

1. Import USD as a hierarchy and preserve named child prims; do not flatten the
   semantic children into one mesh.
2. Use visibility toggles or authored cutaway sets, not alpha-blended stacks, for
   cortex, white matter, ventricles, pathways, and deep nuclei.
3. Treat `major_white_matter_regions_v3` and
   `commissural_sensory_pathways_v3` as alternative hierarchy levels. The source
   volumes overlap and must not be interpreted as disjoint tissue compartments.
4. Disable physics collisions and rigid-body simulation on atlas anatomy unless
   a separately reviewed interaction proxy is added. These surfaces do not encode
   stiffness, density, anisotropy, deformation, or tissue contact mechanics.
5. Bind highlights by semantic prim name or ontology property. Avoid vertex-index
   addressing because runtime LOD decimation changes topology.
6. Keep patient data in a separate, access-controlled layer. Never imply that an
   atlas prim is a patient's segmentation, lesion, vessel, or operative target.

## Deliberate hierarchy choices

The HRA GLB contains broad parent volumes and more detailed child volumes that
occupy overlapping space. To avoid exporting opaque duplicates inside a single
asset, this module omits eight source meshes:

- bilateral broad `amygdaloid_complex`, retaining detailed amygdala nuclei;
- bilateral broad `thalamus`, retaining detailed thalamic nuclei;
- bilateral broad `hypothalamus`, retaining detailed hypothalamic regions; and
- bilateral `posteroventral_putamen`, retaining the named putamen volume.

These omissions are recorded explicitly in the semantic audit and are not claims
that the structures are absent from anatomy.

## Source gaps and boundaries

The source contains no pituitary, choroid plexus, CSF flow/pressure data,
microscopic neurons, glia, synapses, axons, or myelin microstructure. The
ventricular meshes are atlas space surfaces only. Do not attach fluid parameters,
pressure values, perfusion, tissue viability, lesion outcome, or surgical
navigation meaning without a separately sourced, clinically reviewed model.

## Source and licence

- Work: *HRA Brain, Male*
- NIH 3D entry/version: `3DPX-020960` v1.01
- HRA source label: reference-organ brain male v1.3
- Licence: CC BY 4.0
- Unmodified source SHA-256:
  `2b9ad5b53e40e9f0936da74f7be38d2eed15604e26358c3870a0ea13499b9a35`

Redistribution must retain the source title, creator, entry/version, licence,
attribution, and modification notice. See
`research/NEURAL_DETAIL_PROVENANCE_V3.md` and the vendored source record.
