# Intracranial detail asset catalog v3

This document catalogs **only the 45 newly built intracranial-detail packages**.
It does not repeat the existing 65-package baseline catalog.

## Exact inventory

| Module | Independently loadable packages | Review assemblies | New packages |
|---|---:|---:|---:|
| HRA neural detail | 14 | 1 | 15 |
| Cranial support detail | 16 | 2 | 18 |
| Conceptual microscopic detail | 11 | 1 | 12 |
| **Total** | **41** | **4** | **45** |

The build inventory is therefore **65 original + 45 new = 110 uniquely named
packages**. This is a file count, not a claim that all 110 should be loaded at
once or released for clinical use. Two of the new cranial packages, C12 and C18,
are on a licence hold and must be excluded from hospital, commercial, and
runtime release until the inner-ear provenance and permissions are cleared.
That leaves at most 43 non-held new packages for further technical and
specialist review; it does not make those packages clinically approved.

The publishing tree's authoritative machine-readable inventories are:

- `asset_manifest_neural_detail_v3.json` — 14 HRA anatomy layers plus one
  registered review assembly;
- `asset_manifest_cranial_detail_v3.json` — the release-safe subset of 15
  non-held cranial layers plus the cranial-nerve review assembly; and
- `asset_manifest_intracranial_micro_v3.json` — 11 conceptual microscopic
  vignettes plus one review assembly.

For each release-eligible entry below, the value shown under **ID / file
basename** is also the exact filename stem. Its runtime file is
`exports/usdz/<ID>.usdz`, and its editable interchange companion is
`exports/usdc/<ID>.usdc`. All packages use metres and Y-up USD. C12 and C18 are
retained only as full-build audit records in this catalog: their USDZ binaries
and their records were deliberately omitted from the release manifest.

## Safety and release boundary

These assets are generic education and design-review material. They are not
patient-specific segmentations and are not validated for diagnosis, treatment
planning, navigation, procedural rehearsal, device sizing, perfusion
assessment, pathology classification, prognosis, or clinical decisions. A
hospital deployment requires patient-specific imaging where applicable,
specialist review, source and licence clearance, registration and measurement
validation, human-factors testing, privacy/security controls, software lifecycle
controls, and regulatory assessment.

Colors are teaching-layer identifiers. They do not encode function, deficit,
conduction, perfusion, oxygenation, viability, stiffness, density, pressure, or
any measured physiological value. Atlas anatomy should be static reference
geometry. Do not infer tissue physics from the meshes; interaction requires
separately reviewed proxy colliders or simulation layers.

## Shared source, scale, and status contracts

### HRA-N — neural-detail contract

- **Source:** NIH 3D / Human Reference Atlas *Brain, Male*, entry
  `3DPX-020960` v1.01, HRA reference-organ brain male v1.3.
- **Licence:** CC BY 4.0. Retain source title, creator, entry/version, licence,
  attribution, and the recorded modification notice.
- **Processing:** 275 exact source semantic meshes were selected into 14 groups;
  no missing neural anatomy was invented. Eight overlapping broad/alternate
  source meshes were deliberately omitted in favor of their detailed children.
- **Registration:** native HRA metre frame, centered by translation
  `(-0.000090, -0.001155, -0.829567)` m. This is the established project brain
  frame used by the original realistic brain and registered head layers. Do not
  normalize, recenter, auto-fit, or apply the offset again in Houdini.
- **Runtime semantics:** preserve named child prims and ontology properties. Use
  visibility/cutaway states rather than transparent stacks. Bind interaction to
  semantic names, not vertex indices.
- **Clinical status N-REVIEW:**
  `REQUIRES_NEUROANATOMY_AND_CLINICAL_SPECIALIST_REVIEW`; generic,
  non-patient-specific, and not validated for diagnosis or planning.

### Z-C — cranial-detail contract

- **Source:** 137 exactly named Z-Anatomy / BodyParts3D source objects from the
  audited local atlas: 49 curves and 88 meshes. Missing anatomy was not inferred,
  mirrored, bridged, or relabeled.
- **Licence:** Z-Anatomy CC BY-SA 4.0 and BodyParts3D CC BY-SA 2.1 Japan;
  attribution and ShareAlike obligations apply. Retain the bundled University of
  Dundee CAHID cranial-nerve attribution under CC BY 4.0 pending definitive
  per-object provenance review.
- **Registration:** all packages use the shared Z-Anatomy source-frame center
  `[0.0, 0.008782502, 1.640712023]` m and are already aligned to the established
  v2 cranial frame. Apply the same world transform as the original registered
  head layers and do not add another center offset.
- **Runtime semantics:** preserve `userProperties:anatomical_name`; keep the 16
  independent layers as separate payloads/variants; treat anatomy as static;
  use only coarse UI-picking proxies, never surgical-boundary colliders.
- **Clinical status C-REVIEW:** `REQUIRES_SPECIALIST_REVIEW`; generic,
  non-patient-specific, not clinically validated, and prohibited for diagnosis,
  planning, navigation, rehearsal, device sizing, or clinical decisions.
- **Clinical/licence status C-HOLD:** includes C-REVIEW and
  `HOLD_FOR_INNER_EAR_LICENSE_REVIEW`. The bundled atlas documentation cites an
  adapted University of Dundee inner-ear source under CC BY-NC-SA 4.0 without a
  sufficient per-object provenance ledger. Held packages are excluded from
  hospital, commercial, and runtime release until provenance and licence
  compatibility are confirmed or the geometry is replaced.

### MICRO-P — microscopic conceptual contract

- **Source:** original procedural Blender teaching geometry plus three
  project-owned ImageGen base-color appearance references. The images are not
  microscopy, histology, anatomy, pathology, or clinical evidence.
- **Licence:** the manifest declares no separate public licence for these
  project-owned materials; apply the repository's project-distribution policy
  and do not infer rights beyond it.
- **Scale:** all 12 packages use the
  `microscopic_conceptual_separate` domain. They are deliberately magnified,
  scale-separated, and **not registered to the metre-scale head**. Every view
  must show a prominent “not to anatomical scale” label. Never overlay them
  inside the head as if dimensions, counts, spacing, or placement were real.
- **Evidence boundary:** all 12 are non-histologic, non-quantitative,
  non-patient-specific, and not measured physiology. Geometry, thickness,
  spacing, cell counts, channels, flow cues, composition, and tissue zones are
  illustrative.
- **Runtime:** use one vignette at a time as a separately staged explanatory
  zoom. Do not use micro-package metres as biological dimensions or connect
  their coordinates to macroscopic anatomy.
- **Clinical status M-REVIEW:** `REQUIRES_SPECIALIST_REVIEW`; requires
  neuroanatomy, neuropathology, hematology, neuroradiology, accessibility, and
  patient-communications review before any patient-facing evaluation.

## Neural detail — 14 HRA packages plus one assembly

### N01 — Frontal cortical parcellation

- **ID / file basename:** `frontal_cortex_parcellation_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 28 bilateral named frontal gyri and lobules, including frontal
  pole, orbital, inferior/middle/superior frontal, precentral, rectus, and
  rostral regions.
- **Relationship to the original 65:** adds selectable semantic frontal cortex
  beneath or instead of the opaque cortex in `brain_anatomy_realistic_v2`; it is
  a higher-detail semantic alternative to `brain_structures_generic`, not a
  second opaque shell. Use a cutaway or disable the original cortex when this
  layer is the focus.
- **Runtime / geometry:** independent payload; 28 semantic children, 89,970
  triangles, approximately 0.124971 × 0.146673 × 0.118115 m. Preserve children
  for labels and selection.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N02 — Parietal cortical parcellation

- **ID / file basename:** `parietal_cortex_parcellation_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 14 bilateral named parietal gyri and lobules, including
  postcentral, precuneus, supramarginal, angular, opercular, and association
  regions.
- **Relationship to the original 65:** refines the parietal portion of
  `brain_anatomy_realistic_v2` and supersedes the coarse teaching detail of
  `brain_structures_generic` when selected. Avoid coincident opaque cortical
  surfaces.
- **Runtime / geometry:** independent payload; 14 semantic children, 59,992
  triangles, approximately 0.132402 × 0.093535 × 0.078698 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N03 — Temporal cortical parcellation

- **ID / file basename:** `temporal_cortex_parcellation_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 16 bilateral temporal gyri, poles, Heschl gyri, auditory planes,
  and temporal fusiform cortex.
- **Relationship to the original 65:** provides selectable temporal semantics in
  the frame of `brain_anatomy_realistic_v2`; use it as a focused replacement for
  the hero cortex or `brain_structures_generic`, not as an overlapping opaque
  copy.
- **Runtime / geometry:** independent payload; 16 semantic children, 54,982
  triangles, approximately 0.136377 × 0.104001 × 0.062709 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N04 — Occipital cortical parcellation

- **ID / file basename:** `occipital_cortex_parcellation_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 12 bilateral occipital gyri, poles, cuneus, lingual, and
  occipital fusiform regions.
- **Relationship to the original 65:** adds named occipital selection to
  `brain_anatomy_realistic_v2`; disable or clip the corresponding hero cortex
  when visible and treat `brain_structures_generic` only as a legacy fallback.
- **Runtime / geometry:** independent payload; 12 semantic children, 44,988
  triangles, approximately 0.106952 × 0.072703 × 0.066561 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N05 — Insular and opercular cortex

- **ID / file basename:** `insular_opercular_cortex_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 12 bilateral short/long insular gyri, limen insulae, agranular
  insular regions, and frontal opercula.
- **Relationship to the original 65:** supplies deep cortical semantics not
  independently exposed by `brain_anatomy_realistic_v2`; reveal it by hiding or
  clipping overlying cortical parcels rather than using alpha-stacked shells.
- **Runtime / geometry:** independent payload; 12 semantic children, 9,320
  triangles, approximately 0.096223 × 0.059442 × 0.045596 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N06 — Cingulate and parahippocampal cortex

- **ID / file basename:** `cingulate_parahippocampal_cortex_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** 22 bilateral cingulate, parahippocampal, perirhinal, piriform,
  paracingulate, subcallosal, and related medial cortical regions.
- **Relationship to the original 65:** adds separately selectable medial cortex
  inside `brain_anatomy_realistic_v2`; coordinate visibility with the original
  cortex and `brain_deep_structures_v2` so the layer remains readable.
- **Runtime / geometry:** independent payload; 22 semantic children, 25,208
  triangles, approximately 0.084600 × 0.124213 × 0.080052 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N07 — Cerebellar substructures

- **ID / file basename:** `cerebellar_substructures_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 14 bilateral lateral hemispheres, paravermis, vermis, deep
  nuclei, and inferior/middle/superior cerebellar peduncles.
- **Relationship to the original 65:** refines the cerebellar component already
  present in `brain_anatomy_realistic_v2`; use focused visibility instead of
  double-rendering the source-equivalent cerebellar surfaces.
- **Runtime / geometry:** independent payload; 14 semantic children, 42,856
  triangles, approximately 0.107867 × 0.061186 × 0.063270 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N08 — Brainstem substructures

- **ID / file basename:** `brainstem_substructures_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 22 bilateral midbrain, pontine, medullary, collicular,
  peduncular, olivary, tegmental, and red-nucleus structures.
- **Relationship to the original 65:** expands the brainstem representation in
  `brain_anatomy_realistic_v2` and `brain_deep_structures_v2`; load as the
  focused semantic layer while disabling any coincident opaque parent surface.
- **Runtime / geometry:** independent payload; 22 semantic children, 7,838
  triangles, approximately 0.040171 × 0.031542 × 0.067652 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N09 — Basal ganglia and adjacent deep nuclei

- **ID / file basename:** `basal_ganglia_deep_nuclei_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 22 caudate segments, putamina, internal/external pallidal
  segments, accumbens, subthalamic nuclei, substantiae nigrae, claustra, and
  zonae incertae.
- **Relationship to the original 65:** is a more granular semantic alternative
  to the relevant volumes in `brain_deep_structures_v2` and
  `brain_structures_generic`; avoid coincident parent/child opaque rendering.
- **Runtime / geometry:** independent payload; 22 semantic children, 24,626
  triangles, approximately 0.070410 × 0.062569 × 0.046680 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N10 — Thalamic and hypothalamic nuclei

- **ID / file basename:** `thalamic_hypothalamic_nuclei_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 42 detailed thalamic nuclei, hypothalamic regions, geniculate
  and habenular nuclei, mammillary regions, and pineal body; overlapping broad
  thalamus/hypothalamus parents are intentionally absent.
- **Relationship to the original 65:** refines the thalamic/hypothalamic content
  of `brain_deep_structures_v2`. Select this detailed hierarchy instead of an
  opaque broad parent layer.
- **Runtime / geometry:** independent payload; 42 semantic children, 15,502
  triangles, approximately 0.048535 × 0.043197 × 0.034063 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N11 — Hippocampal, amygdala, and limbic nuclei

- **ID / file basename:** `hippocampal_amygdala_limbic_nuclei_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** 30 hippocampal head/body/tail meshes, source-backed amygdala
  nuclei, basal forebrain, bed nuclei of the stria terminalis, and septal
  nuclei; broad amygdaloid parents are omitted.
- **Relationship to the original 65:** refines limbic/deep anatomy associated
  with `brain_deep_structures_v2`; do not imply memory, behavior, or deficit
  mapping from visibility or color.
- **Runtime / geometry:** independent payload; 30 semantic children, 11,228
  triangles, approximately 0.069425 × 0.050388 × 0.048891 m.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N12 — Ventricular spaces and connecting channels

- **ID / file basename:** `ventricular_spaces_v3` (`.usdz` runtime, `.usdc`
  interchange).
- **Contains:** 18 lateral-ventricle segments, third and fourth ventricles,
  cerebral aqueduct, and central canal source surfaces.
- **Relationship to the original 65:** is the detailed semantic alternative to
  `brain_ventricles_v2`; do not double-render the two ventricular layers. It may
  be spatially reviewed with `optional_evd_system`, but it supplies no catheter
  target, safe corridor, CSF pressure, or flow boundary.
- **Runtime / geometry:** independent payload; 18 semantic children, 16,602
  triangles, approximately 0.074908 × 0.128477 × 0.101773 m. Surfaces represent
  atlas spaces, not a fluid simulation or measured CSF volume.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N13 — Major forebrain and hindbrain white-matter regions

- **ID / file basename:** `major_white_matter_regions_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** four broad bilateral forebrain and hindbrain white-matter source
  volumes.
- **Relationship to the original 65:** adds a selectable white-matter parent
  layer within `brain_anatomy_realistic_v2`; it has no validated tractography or
  patient connectivity. Use it as an alternative hierarchy level to N14, not as
  a disjoint compartment.
- **Runtime / geometry:** independent payload; four semantic children, 89,997
  triangles, approximately 0.129587 × 0.159888 × 0.134726 m. Keep off when
  detailed pathways must remain visible.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N14 — Major commissural and sensory pathways

- **ID / file basename:** `commissural_sensory_pathways_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 19 source meshes for corpus callosum, fornices, anterior
  commissures, mammillothalamic tracts, optic radiations/tracts/chiasm, and
  olfactory bulbs/tracts/nuclei.
- **Relationship to the original 65:** adds source-backed pathway landmarks
  inside `brain_anatomy_realistic_v2`; optic structures can be oriented with
  `eyes_context_realistic_v2`. It is not diffusion tractography and must not be
  used as a surgical avoidance map.
- **Runtime / geometry:** independent payload; 19 semantic children, 18,906
  triangles, approximately 0.065321 × 0.099860 × 0.050886 m. Do not render with
  N13 as if both were non-overlapping tissue volumes.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

### N15 — Registered neural-detail unilateral reveal assembly

- **ID / file basename:** `neural_detail_registered_review_assembly_v3`
  (`.usdz` review package, `.usdc` interchange).
- **Contains:** 219 source-semantic children in an opaque unilateral reveal:
  left cortical parcels plus bilateral deep, ventricular, pathway, cerebellar,
  and brainstem anatomy. Right cortical parcels and broad white-matter parent
  volumes are intentionally omitted.
- **Relationship to the original 65:** registration/QC view for the established
  brain frame. Hide or cut away `brain_anatomy_realistic_v2` and
  `brain_deep_structures_v2` when inspecting it; registered arteries, clot,
  meningeal, skull, eye, and scalp layers may be enabled selectively for context.
- **Runtime / geometry:** review assembly, not an always-on payload; 279,788
  triangles, approximately 0.120612 × 0.166051 × 0.146118 m. Prefer the
  independent N-series packages for interactive states.
- **Transitive exclusion:** keep N01–N14 off while this review assembly is
  active. N01–N12 and N14 are wholly or partly duplicated; N13 was deliberately
  omitted and would overlap/occlude the detailed pathway hierarchy retained in
  the reveal.
- **Scale / registration:** HRA-N. **Source / licence:** HRA-N. **Clinical
  status:** N-REVIEW.

## Cranial support — 16 packages plus two assemblies

### C01 — Cranial nerve I — bilateral olfactory nerves

- **ID / file basename:** `cranial_nerve_olfactory_i_bilateral_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** two exact bilateral olfactory-nerve source objects.
- **Relationship to the original 65:** adds nerve paths to the original
  `brain_anatomy_realistic_v2`, `skull_semantic_realistic_v2`, and
  `external_head_scalp_cutaway_v2` context; pair with C13 only for supervised
  spatial explanation, not a smell-function simulation.
- **Runtime / geometry:** independent payload; two source-semantic children,
  18,216 triangles, approximately 0.046698 × 0.051270 × 0.017926 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C02 — Cranial nerve II — bilateral optic nerves

- **ID / file basename:** `cranial_nerve_optic_ii_bilateral_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** two bilateral optic-nerve source meshes; eyeballs are
  deliberately excluded.
- **Relationship to the original 65:** register with
  `eyes_context_realistic_v2`, which remains the globe/eye layer, and with the
  original brain/skull cutaway context. Do not duplicate the original eyes.
- **Runtime / geometry:** independent payload; two semantic children, 1,176
  triangles, approximately 0.060942 × 0.042505 × 0.016705 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C03 — Cranial nerves III, IV and VI — ocular motor group

- **ID / file basename:** `cranial_nerves_ocular_motor_iii_iv_vi_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** bilateral oculomotor, trochlear, and abducens paths as six
  separately named children.
- **Relationship to the original 65:** spatially complements
  `eyes_context_realistic_v2` and C10. It is a static anatomical path set, not an
  eye-motion, conduction, palsy, or deficit simulation.
- **Runtime / geometry:** independent payload; six semantic children, 11,760
  triangles, approximately 0.078170 × 0.087945 × 0.034125 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C04 — Cranial nerve V — expanded trigeminal pathways

- **ID / file basename:** `cranial_nerve_trigeminal_v_expanded_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** 26 bilateral roots, ophthalmic/maxillary/mandibular divisions,
  and available named distal branches.
- **Relationship to the original 65:** adds peripheral nerve orientation around
  `skull_semantic_realistic_v2`, `external_head_scalp_realistic_v2`, and the
  layered head cutaway. It does not encode sensory territories, pain, motor
  status, foramina, or safe surgical corridors.
- **Runtime / geometry:** independent payload; 26 semantic children, 43,064
  triangles, approximately 0.152444 × 0.122068 × 0.163540 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C05 — Cranial nerve VII — bilateral facial nerves

- **ID / file basename:** `cranial_nerve_facial_vii_bilateral_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** bilateral facial nerves plus bilateral chorda tympani branches.
- **Relationship to the original 65:** provides a selectable nerve layer within
  the original scalp/skull cutaway context. It is not a facial-expression rig
  and has no motor grading or deficit meaning.
- **Runtime / geometry:** independent payload; four semantic children, 19,512
  triangles, approximately 0.131133 × 0.104146 × 0.116136 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C06 — Cranial nerve VIII — vestibulocochlear group

- **ID / file basename:** `cranial_nerve_vestibulocochlear_viii_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** bilateral VIII trunks and source-available vestibular/cochlear
  subdivisions; the unlatered cochlear mesh and left-labelled curve retain their
  original identities.
- **Relationship to the original 65:** adds a nerve layer near the original
  brainstem/skull context. The held C12 source-build record is not present in
  this publishing tree; do not restore it as context or a runtime dependency.
- **Runtime / geometry:** independent payload; six semantic children, 6,426
  triangles, approximately 0.081114 × 0.018404 × 0.006931 m. Do not infer
  hearing, balance, conduction, or laterality beyond the exact source labels.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C07 — Cranial nerves IX and X — lower cranial pathways

- **ID / file basename:** `cranial_nerves_glossopharyngeal_ix_vagus_x_v3`
  (`.usdz` runtime, `.usdc` interchange).
- **Contains:** bilateral glossopharyngeal and vagus paths at the full
  atlas-provided extents into the neck.
- **Relationship to the original 65:** provides nerve orientation alongside
  `neck_access_arteries_realistic_v2`, `internal_jugular_veins_realistic_v2`,
  external scalp, and C14. It is not a swallowing, autonomic, voice, or airway
  function simulation.
- **Runtime / geometry:** independent payload; four semantic children, 29,304
  triangles, approximately 0.110508 × 0.088611 × 0.472361 m. Its long inferior
  extent is source-derived and should not be auto-fit to the cranial vault.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C08 — Cranial nerve XI — bilateral accessory nerves

- **ID / file basename:** `cranial_nerve_accessory_xi_bilateral_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** bilateral accessory-nerve paths through the atlas-provided neck
  extent.
- **Relationship to the original 65:** adds nerve orientation to the original
  scalp and neck-vessel layers and can be staged with C16. Visibility must not
  imply motor testing or shoulder/neck function.
- **Runtime / geometry:** independent payload; two semantic children, 10,320
  triangles, approximately 0.119082 × 0.124349 × 0.279543 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C09 — Cranial nerve XII — bilateral hypoglossal nerves

- **ID / file basename:** `cranial_nerve_hypoglossal_xii_bilateral_v3`
  (`.usdz` runtime, `.usdc` interchange).
- **Contains:** two exact bilateral hypoglossal-nerve paths.
- **Relationship to the original 65:** adds static nerve orientation within the
  original head/neck cutaway and can be reviewed with C14/C16. It does not model
  tongue motion, speech, swallowing, or neurological deficit.
- **Runtime / geometry:** independent payload; two semantic children, 10,944
  triangles, approximately 0.055947 × 0.075729 × 0.064531 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C10 — Extraocular muscles and orbital support

- **ID / file basename:** `extraocular_muscles_orbital_support_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** 18 bilateral recti, obliques, levator palpebrae, common
  tendinous rings, and trochleae.
- **Relationship to the original 65:** complements, but does not duplicate,
  `eyes_context_realistic_v2`; pair selectively with C02/C03 for orientation.
  No muscle contraction or ocular-motor physics is encoded.
- **Runtime / geometry:** independent payload; 18 semantic children, 22,952
  triangles, approximately 0.088227 × 0.047763 × 0.033713 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C11 — Pituitary gland — anterior and posterior lobes

- **ID / file basename:** `pituitary_adenohypophysis_neurohypophysis_v3`
  (`.usdz` runtime, `.usdc` interchange).
- **Contains:** separate adenohypophysis and neurohypophysis source meshes.
- **Relationship to the original 65:** fills a documented source gap in the HRA
  neural module and adds orientation near `brain_deep_structures_v2` and
  `brain_ventricles_v2`; it does not encode endocrine function or disease.
- **Runtime / geometry:** independent payload; two semantic children, 1,272
  triangles, approximately 0.011900 × 0.009157 × 0.012560 m. Keep visible only
  in close-up states because of its small macroscopic size.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C12 — Bilateral middle and inner ear anatomy — HOLD

- **ID / source-build file basename:** `middle_inner_ear_bilateral_v3`.
  **The binary is not present in this publishing repository.**
- **Contains:** 14 bilateral ossicles, cochleae, vestibular labyrinth meshes,
  tympanic membranes, and auditory tubes.
- **Relationship to the original 65:** adds ear context near
  `skull_semantic_realistic_v2` and C06, but is not required by any original
  package and must not become a released runtime dependency while held.
- **Runtime / geometry:** independent geometry only for internal provenance and
  licence review; 14 semantic children, 58,032 triangles, approximately
  0.101245 × 0.028627 × 0.016506 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C plus unresolved
  inner-ear CC BY-NC-SA 4.0 provenance. **Clinical/licence status:** C-HOLD;
  excluded from hospital, commercial, and runtime release until cleared or
  replaced.

### C13 — Nasal cavity and available paranasal spaces

- **ID / file basename:** `nasal_cavity_paranasal_spaces_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 14 nasal mucosa/septal structures, bilateral inferior conchae,
  anterior/middle/posterior ethmoid cells, and available frontal and sphenoid
  sinus spaces. No maxillary sinus was invented.
- **Relationship to the original 65:** provides internal orientation beneath
  `external_head_scalp_cutaway_v2` and `skull_semantic_realistic_v2`; it can
  contextualize C01 without implying airflow, smell, infection, or drainage.
- **Runtime / geometry:** independent payload; 14 semantic children, 19,526
  triangles, approximately 0.050386 × 0.093663 × 0.082993 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C14 — Pharyngeal and upper-airway context

- **ID / file basename:** `pharyngeal_upper_airway_context_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** nasopharynx, oropharynx, laryngopharynx, soft palate, and
  epiglottis source structures.
- **Relationship to the original 65:** adds static orientation behind the
  original external head/neck and vessel layers; it may contextualize lower
  cranial nerves but is not a swallowing, ventilation, aspiration, or airway-
  flow model.
- **Runtime / geometry:** independent payload; five semantic children, 14,112
  triangles, approximately 0.065618 × 0.075948 × 0.134842 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C15 — Bilateral muscles of mastication

- **ID / file basename:** `muscles_of_mastication_bilateral_v3` (`.usdz`
  runtime, `.usdc` interchange).
- **Contains:** 12 bilateral temporalis, superficial/deep masseter, medial
  pterygoid, and superior/inferior lateral pterygoid components.
- **Relationship to the original 65:** adds muscle context between the original
  scalp and skull layers and around C04. It is static anatomy, not a chewing,
  jaw-force, deformation, or surgical-access simulation.
- **Runtime / geometry:** independent payload; 12 semantic children, 27,412
  triangles, approximately 0.153665 × 0.113909 × 0.149787 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C16 — Major head and neck orientation muscles

- **ID / file basename:** `head_neck_orientation_muscles_v3` (`.usdz` runtime,
  `.usdc` interchange).
- **Contains:** 18 selected bilateral sternocleidomastoid, digastric,
  mylohyoid, frontalis, occipitalis, and orbicularis-oculi components; this is
  not a complete myology atlas.
- **Relationship to the original 65:** gives spatial landmarks around
  `external_head_scalp_realistic_v2`, head/neck vessels, and lower cranial
  nerves. Do not add contraction, gravity, soft-tissue deformation, or access-
  corridor meaning without a separately reviewed model.
- **Runtime / geometry:** independent payload; 18 semantic children, 39,332
  triangles, approximately 0.122872 × 0.194217 × 0.292629 m.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C17 — Cranial nerves I–XII review assembly

- **ID / file basename:** `cranial_nerves_complete_assembly_v3` (`.usdz` review
  package, `.usdc` interchange).
- **Contains:** all nine cranial-nerve groups as 54 retained source-semantic
  children.
- **Relationship to the original 65:** provides a single registration/QC view
  against the original brain, skull, eye, scalp, and vascular context. It is not
  the preferred always-on runtime representation.
- **Runtime / geometry:** review assembly; 150,722 triangles, approximately
  0.152444 × 0.200312 × 0.559504 m. Stream the independent nerve groups for
  phase-specific interaction.
- **Transitive exclusion:** do not co-load C01–C09; they are all duplicated by
  this assembly.
- **Scale / registration:** Z-C. **Source / licence:** Z-C. **Clinical status:**
  C-REVIEW.

### C18 — Registered cranial support anatomy assembly — HOLD

- **ID / source-build file basename:** `cranial_support_registered_assembly_v3`.
  **The binary is not present in this publishing repository.**
- **Contains:** all 16 independent cranial layers and 137 semantic children:
  nerves, orbital support, pituitary, ear, nasal/airway anatomy, and selected
  muscles.
- **Relationship to the original 65:** dense registration/authoring review
  against the original registered head, brain, eye, skull, meningeal, and
  vascular layers. It is not an always-on immersive view or a runtime dependency.
- **Runtime / geometry:** internal review assembly; 333,360 triangles,
  approximately 0.153665 × 0.228075 × 0.569423 m.
- **Transitive exclusion:** do not co-load C01–C17. C01–C16 are directly
  duplicated; C17 duplicates the nine nerve groups already contained here.
- **Scale / registration:** Z-C. **Source / licence:** Z-C plus inherited
  unresolved inner-ear CC BY-NC-SA 4.0 provenance. **Clinical/licence status:**
  C-HOLD; excluded from hospital, commercial, and runtime release until the ear
  source is cleared or replaced.

## Conceptual microscopic detail — 11 vignettes plus one assembly

All M-series entries inherit MICRO-P: they are magnified, scale-separated,
unregistered, non-histologic, non-quantitative, and require an explicit “not to
anatomical scale” label. Their metre values describe only presentation-stage
geometry.

### M01 — Blood-brain barrier and neurovascular-unit teaching model

- **ID / file basename:** `blood_brain_barrier_neurovascular_unit_conceptual_v3`
  (`.usdz` runtime vignette, `.usdc` interchange).
- **Contains:** an opened capillary with endothelial layer, conceptual tight-
  junction seams, basement membrane, pericyte, astrocyte endfeet, and magnified
  red-cell context.
- **Relationship to the original 65:** explanatory zoom associated with
  `microcirculation_arterial_venous_v2`, `artery_wall_cutaway_v2`, and the brain
  layers. It must open in a separate teaching stage, never inside the registered
  head or vessel lumen at its authored scale.
- **Runtime / geometry:** independent vignette; 16,092 triangles,
  approximately 0.120000 × 0.072065 × 0.057608 presentation metres. No measured
  permeability, flow, barrier thickness, or transport behavior.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M02 — Capillary endothelium and tight-junction close-up

- **ID / file basename:** `capillary_endothelium_tight_junctions_conceptual_v3`
  (`.usdz` runtime vignette, `.usdc` interchange).
- **Contains:** flattened endothelial-cell sheets, nuclei, basement membrane,
  conceptual tight-junction seams, and pericyte context.
- **Relationship to the original 65:** a separate explanatory zoom from
  `microcirculation_arterial_venous_v2`; it does not replace the macroscopic
  vessel assets or provide a leakage/permeability simulation.
- **Runtime / geometry:** independent vignette; 6,360 triangles, approximately
  0.145011 × 0.055334 × 0.036500 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M03 — Magnified formed blood elements

- **ID / file basename:** `formed_blood_elements_magnified_v3` (`.usdz` runtime
  vignette, `.usdc` interchange).
- **Contains:** illustrative red blood cells, one generic leukocyte cue, platelet
  forms, and granule cues.
- **Relationship to the original 65:** extends the subject matter of
  `red_blood_cells_closeup_v2` with platelet/leukocyte teaching forms. Use it as
  an alternative staged close-up, not as a measured blood count, rheology model,
  or particle population inside the original flow animations.
- **Runtime / geometry:** independent vignette; 9,760 triangles, approximately
  0.145295 × 0.062857 × 0.046601 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M04 — Conceptual platelet-fibrin thrombus microstructure

- **ID / file basename:** `platelet_fibrin_thrombus_microstructure_conceptual_v3`
  (`.usdz` runtime vignette, `.usdc` interchange).
- **Contains:** opened vessel context, entrapped red-cell forms, platelet-rich
  cues, fibrin strands, and a project-owned textured clot-volume reference.
- **Relationship to the original 65:** a separate conceptual zoom related to
  `ischemic_mca_clot_v2` and `ischemic_lvo_clot`; it is not registered to either
  clot and must not imply patient thrombus composition, age, treatment response,
  or retrieval mechanics.
- **Runtime / geometry:** independent vignette; 29,296 triangles,
  approximately 0.150000 × 0.053364 × 0.062000 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P; conceptual
  thrombus appearance uses the project-owned ImageGen reference. **Clinical
  status:** M-REVIEW.

### M05 — Detailed multipolar-neuron teaching model

- **ID / file basename:** `multipolar_neuron_detailed_conceptual_v3` (`.usdz`
  runtime vignette, `.usdc` interchange).
- **Contains:** generic soma, nucleus, dendrites, enlarged spine cues, axon, and
  terminal branches.
- **Relationship to the original 65:** provides a scale-separated explanation
  connected narratively to `brain_anatomy_realistic_v2`, not a cell population
  embedded in its coordinates. It encodes no specific neuronal class, circuit,
  firing, or stroke deficit.
- **Runtime / geometry:** independent vignette; 9,012 triangles, approximately
  0.190216 × 0.121083 × 0.048539 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M06 — Astrocyte and capillary-endfeet teaching model

- **ID / file basename:** `astrocyte_capillary_endfeet_conceptual_v3` (`.usdz`
  runtime vignette, `.usdc` interchange).
- **Contains:** branching generic astrocyte morphology with enlarged endfeet
  approaching an opaque capillary context.
- **Relationship to the original 65:** narratively links brain tissue to
  `microcirculation_arterial_venous_v2` and complements M01. It is not registered
  to a vessel and does not model neurovascular coupling, edema, or transport.
- **Runtime / geometry:** independent vignette; 3,596 triangles, approximately
  0.140000 × 0.096940 × 0.074277 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M07 — Oligodendrocyte and myelinated-axon teaching model

- **ID / file basename:** `oligodendrocyte_myelinated_axons_conceptual_v3`
  (`.usdz` runtime vignette, `.usdc` interchange).
- **Contains:** a generic oligodendrocyte with processes connected to several
  simplified myelin internodes.
- **Relationship to the original 65:** gives a separate explanatory zoom for
  white matter within `brain_anatomy_realistic_v2`; it is not tractography,
  conduction, demyelination, or an anatomical count.
- **Runtime / geometry:** independent vignette; 2,584 triangles, approximately
  0.142000 × 0.069192 × 0.054400 presentation metres. The project-owned myelin
  image is only a non-histologic base-color reference.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M08 — Myelinated axon and node-of-Ranvier close-up

- **ID / file basename:** `myelinated_axon_node_of_ranvier_conceptual_v3`
  (`.usdz` runtime vignette, `.usdc` interchange).
- **Contains:** continuous axon core, separated myelin internodes, surface-ring
  cues, and enlarged conceptual channel-location markers.
- **Relationship to the original 65:** a separate teaching zoom associated with
  brain white matter; it does not provide conduction velocity, ion-channel
  distribution, electrophysiology, or a registered nerve pathway.
- **Runtime / geometry:** independent vignette; 9,124 triangles, approximately
  0.170000 × 0.022300 × 0.022300 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M09 — Chemical-synapse teaching close-up

- **ID / file basename:** `chemical_synapse_closeup_conceptual_v3` (`.usdz`
  runtime vignette, `.usdc` interchange).
- **Contains:** presynaptic terminal, enlarged vesicles, cleft particles,
  postsynaptic dendrite, and generic receptor-location cues.
- **Relationship to the original 65:** a narrative close-up for the original
  brain layers and M05, not a modeled circuit or synapse inside the head. It
  encodes no transmitter identity, release probability, timing, or deficit.
- **Runtime / geometry:** independent vignette; 8,708 triangles, approximately
  0.115546 × 0.037703 × 0.073797 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M10 — Choroid-plexus and CSF-interface teaching model

- **ID / file basename:** `choroid_plexus_csf_interface_conceptual_v3` (`.usdz`
  runtime vignette, `.usdc` interchange).
- **Contains:** simplified capillary folds, epithelial-cell cues, and non-
  quantitative CSF direction markers.
- **Relationship to the original 65:** supplies a separate conceptual
  explanation for `brain_ventricles_v2` and `optional_evd_system`; it is not a
  registered choroid-plexus atlas, CSF volume, pressure field, production rate,
  flow simulation, or catheter target.
- **Runtime / geometry:** independent vignette; 15,000 triangles, approximately
  0.137719 × 0.067058 × 0.066499 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M11 — Conceptual ischemic tissue-zone teaching model

- **ID / file basename:** `ischemic_tissue_zones_conceptual_v3` (`.usdz`
  runtime vignette, `.usdc` interchange).
- **Contains:** opaque layered surrounding, at-risk, and core teaching regions
  with non-quantitative microvessel context.
- **Relationship to the original 65:** an explanatory concept related to
  `ischemic_mca_clot_v2`, `ischemic_lvo_clot`, and `edema_swelling`; it is not
  patient perfusion imaging, a penumbra/core segmentation, a time-to-treatment
  model, an outcome map, or measured viability.
- **Runtime / geometry:** independent vignette; 4,560 triangles, approximately
  0.147024 × 0.100381 × 0.048100 presentation metres.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

### M12 — Intracranial microanatomy teaching-set review assembly

- **ID / file basename:** `intracranial_micro_teaching_set_v3` (`.usdz` review
  gallery, `.usdc` interchange).
- **Contains:** a review-only gallery of all 11 scale-separated vignettes.
- **Relationship to the original 65:** visual/QC contact sheet for the new
  explanatory zooms; it has no place in the registered head scene and should not
  be shipped as a substitute for phase-specific individual teaching states.
- **Runtime / geometry:** review assembly; 114,092 triangles, approximately
  0.566976 × 0.324533 × 0.045384 presentation metres.
- **Transitive exclusion:** do not co-load M01–M11; every individual vignette is
  duplicated in this gallery.
- **Scale / registration:** MICRO-P. **Source / licence:** MICRO-P. **Clinical
  status:** M-REVIEW.

## Aggregate loading and Houdini handoff rules

1. **Preserve separate composition domains.** Keep original-65 macroscopic
   anatomy, HRA-N neural detail, Z-C cranial detail, and MICRO-P vignettes in
   separate USD layers/payloads. Never merge all packages into one mesh.
2. **Keep patient data separate.** Patient CT/MR/angiography-derived meshes,
   lesions, centerlines, and measurements belong in access-controlled,
   versioned layers with their own registration/QC record. They replace or
   contextualize generic atlas layers; they do not inherit clinical validity
   from them.
3. **Honor aggregate exclusions.** N15 excludes N01–N14 while active. C17
   excludes C01–C09. C18 excludes C01–C17 and is held. M12 excludes M01–M11.
   These rules prevent direct and transitive duplicate geometry.
4. **Honor hierarchy overlap.** N13 and N14 are alternate source hierarchy
   levels. Do not interpret their overlap as separate tissue compartments.
5. **Use semantic keys.** Preserve HRA ontology/source metadata and Z-C
   `userProperties:anatomical_name`. Author interaction, labels, and visibility
   against stable semantic properties rather than sanitized prim paths or
   topology indices.
6. **Keep source payloads immutable.** Put clipping, presentation opacity,
   highlights, localization, animation, and app state in separate authored
   layers. Retain opaque source geometry for identity and registration QC.
7. **Do not invent physics.** Atlas meshes do not contain density, stiffness,
   anisotropy, deformation, pressure, flow, tissue contact, conduction, muscle
   contraction, or safe-margin data. Any such behavior requires an independently
   sourced, versioned, reviewed, and validated model.
8. **Stream by teaching phase.** Load only the anatomy needed for the current
   explanation. The four assemblies are review tools; use independent packages
   for interactive RealityKit states.
9. **Enforce the hold.** Build and deployment tooling must denylist C12 and C18
   until a recorded licence-clearance decision or verified replacement removes
   the hold.
10. **Retain prominent disclaimers.** Every experience must identify atlas
    versus patient-specific data. Every M-series view must additionally display
    “magnified conceptual view — not to anatomical scale; not histology or
    measured physiology.”

## Clinical status summary

- **15 HRA neural packages:** N-REVIEW; CC BY 4.0; generic atlas anatomy; no
  diagnosis/planning validation.
- **16 non-held cranial packages:** C-REVIEW; attribution and ShareAlike apply;
  generic atlas anatomy; no clinical validation.
- **Two held cranial packages:** C12 and C18 are C-HOLD and excluded from
  hospital, commercial, and runtime release pending inner-ear licence clearance.
- **12 microscopic packages:** M-REVIEW; project-owned conceptual teaching
  work; magnified, scale-separated, unregistered, non-histologic, non-
  quantitative, and not patient-specific.

No package in this catalog is described as hospital-ready, doctor-validated, or
fit for clinical decision-making.
