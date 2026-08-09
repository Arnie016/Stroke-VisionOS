# Intracranial detail source and gap audit

Date: 2026-08-08
Scope: original 65 manifest-backed assets and the local sources that could
support a high-detail generic head/intracranial expansion
Status: read-only source audit and build plan; no assets were created by this
audit

## Decision summary

There is enough properly identified geometry on disk to make a much richer
**generic educational atlas**, especially for cortical gyri, deep structures,
ventricles, cranial nerves, eyes, skull bones, muscles, major arteries, dural
sinuses, and head/neck lymph nodes. There is not enough evidence to call the
result patient-specific, clinically validated, microscopically complete, a
surgical plan, or a quantitative simulation.

The best defensible production path is:

1. Keep the original 65 assets as the compatibility baseline.
2. Use the local HRA Brain as the primary intracranial registration anchor. It
   contains 283 named meshes and 653,212 source triangles under CC BY 4.0.
3. Split its 102 named cortical-region meshes into independently toggleable
   regions and a clinician-reviewed lobe map rather than replacing them with a
   smooth procedural brain.
4. Use HRA deep structures, white matter, ventricles, cerebellum, and brainstem
   before equivalent Z-Anatomy geometry when both exist. HRA has a clearer CC
   BY 4.0 redistribution path.
5. Use Z-Anatomy for structures not present in the HRA brain—most notably the
   24 bilateral cranial-nerve trunks, falx/tentorium, major cerebral arteries,
   dural venous sinuses, eye internals, ossicles, muscles, and lymph nodes—but
   preserve ShareAlike obligations and review component-specific provenance.
6. Do **not** distribute the bundled inner-ear derivatives as ordinary
   hospital/commercial assets without a specific licensing decision. The
   bundled notice identifies that source as CC BY-NC-SA 4.0.
7. Do **not** use the bundled Z-Anatomy white matter as the production source
   until its University of Washington provenance is resolved. Use the local
   HRA white-matter meshes or reacquire current BodyParts3D meshes directly.
8. Treat capillaries, blood cells, artery-wall layers, thrombus composition,
   blood-brain-barrier scenes, and cellular ischemia as separate magnified
   teaching stages. They must never be presented as one-to-one geometry inside
   the life-size brain.
9. Provide named Houdini replacement sockets for patient-authorized DICOM
   segmentations. Generic atlas geometry remains the fallback, never the
   patient model.

“Every minute detail” cannot honestly be delivered as a single model. The
requested scope spans a life-size head, sub-millimetre vessels, micrometre-scale
cells, dynamic physiology, and individual patient variation. Those require
different sources, display scales, uncertainty labels, and validation paths.
Visual polish is not clinical validation.

## Reproducible evidence

The complete machine-readable inventory is
`intracranial_detail_source_audit.json`. It records exact object names,
collections, source/evaluated triangle counts, bounds, hashes, registration
notes, and licence cautions. The reusable read-only generator is
`../source/audit_intracranial_detail_sources.py`.

Run it from the kit root with Blender 5.2 or later:

```sh
/Applications/Blender.app/Contents/MacOS/Blender \
  --background vendor/z_anatomy/Z-Anatomy/Startup.blend \
  --disable-autoexec \
  --python source/audit_intracranial_detail_sources.py -- \
  --output research/intracranial_detail_source_audit.json
```

The audit uses source mesh triangles when an object has no modifiers and
evaluated, triangulated geometry for modified meshes and bevelled curves. This
distinction is recorded per object as `count_mode`.

## Original 65-asset baseline

The six active manifests contain exactly 65 unique IDs with no duplicates.
The rejected perioperative expansion under `archive/` is not counted.

| Manifest | Assets | Manifest triangle sum | Role |
| --- | ---: | ---: | --- |
| `vision_pro_stroke_kit/asset_manifest.json` | 29 | 37,042 | Original prototype anatomy, procedure, and environment assets |
| `asset_manifest_v2.json` | 7 | 859,715 | HRA brain, NIH skull, Z-Anatomy arterial tree, clot, registered hero |
| `asset_manifest_head_details_v2.json` | 9 | 534,667 | Scalp, eyes, conceptual dura, falx/tentorium, layered cutaway |
| `asset_manifest_cranial_vascular_v2.json` | 7 | 275,968 | Dural sinuses, jugulars, head/neck veins and access arteries |
| `asset_manifest_bloodflow_v2.json` | 8 | 264,058 | Magnified conceptual vessel wall, cells, microcirculation and flow cues |
| `asset_manifest_devices_v2.json` | 5 | 109,072 | Generic thrombectomy device concepts |

The v1 set contains several open-cranial assets. Those can represent selected
haemorrhage/neurosurgical pathways but must not be inserted into an ordinary
endovascular mechanical-thrombectomy sequence.

## Local authoritative/reference sources

### NIH 3D and HRA sources on disk

| Local source | Exact geometry | Native bounds | Registration | Licence and permitted claim |
| --- | --- | --- | --- | --- |
| HRA Brain, Male; NIH 3D `3DPX-020960` v1.01, HRA brain v1.3 | 283 meshes; 653,212 triangles | 0.136378 × 0.167040 × 0.146096 m; centre (-0.000090, 0.001155, 0.829567) m | Native HRA/Visible Human frame; translate by the negative bounds centre for the current brain-centred stage | CC BY 4.0. Generic reference brain derived from the Allen human brain atlas and fitted to Visible Human reference bodies; not patient-specific |
| HRA Skin, Male; NIH 3D `3DPX-021016` entry v2 | One closed whole-body mesh; 829,184 triangles | 1.043153 × 0.325632 × 1.824276 m | Shares the native HRA frame with the brain. Source crop `Z >= 0.660 m` gives a head/upper-neck start of about 58,840 triangles | CC BY 4.0. Generic external surface, not a patient face or scan |
| Visible Human semantic skull and eyes; NIH 3D `3DPX-020591` v1.03 | 17 meshes; 53,745 triangles; exact names listed below | 25.790966 × 17.275880 × 28.036027 imported units | Normalize the complete root by 0.01, then landmark-register. It is not natively co-registered to HRA | CC BY 4.0; generic Visible Human-derived teaching anatomy |
| Visible Human high-detail skull; NIH 3D `3DPX-012260` v3 | One mesh, `VHM_Skull_0.ply`; 580,286 triangles | 2.379214 × 3.315710 × 3.564519 imported units | Normalize root by 0.1, then landmark-register | CC BY 4.0. High-detail outer skull, but no separate bones or named foramina |
| Visible Human Male Bust; NIH 3D `3DPX-023209` v1 | One mesh; 498,902 triangles | 0.5300 × 0.3478 × 0.3500 m | Independent bilateral cutaway sculpt; context only | CC BY 4.0; not a clean scalp or registration anchor |
| Archived HRA Blood Vasculature, Male; NIH 3D `3DPX-020997` v1.01, HRA v1.2 | 104 meshes; 359,592 triangles | 0.236199 × 0.187426 × 0.871836 m | HRA/Visible Human frame candidate; verify landmarks before reuse | CC BY 4.0, but it lives only under the user-rejected perioperative archive and is not an active asset/source dependency |

The exact source files, SHA-256 values, and per-object rows are in the JSON.
The HRA brain page states that 141 anatomical structures were mirrored to form
a whole brain and that v1.3 changed the model to CC BY 4.0:
<https://3d.nih.gov/entries/20960?version=1.01>. The HRA library states that its
reference objects are CC BY 4.0:
<https://humanatlas.io/3d-reference-library>.

NIH 3D explicitly says its models are illustrative/educational, are not
intended for diagnosis or treatment, and require independent verification of
scientific conclusions: <https://3d.nih.gov/terms>.

The archived HRA vasculature is useful only as optional systemic/ophthalmic
context. It has central retinal arteries/veins, ophthalmic veins, aortic-arch
structures, and only segmented left common-carotid parts in the head/neck
region. It has no detailed ICA–Circle-of-Willis–MCA/PCA tree and no radial or
femoral arterial access route. It must not replace the local 40-structure
cerebral arterial tree or be counted among the active 65 assets.

### Exact semantic skull-and-eye mesh names

The lighter NIH skull contains:

- `Ethmoid bone` — 1,647 triangles
- `Frontal bone` — 828
- `Lacrimal bone` — 328
- `Mandible` — 1,912
- `Maxilla` — 4,586
- `Nasal bone` — 204
- `Occipital bone` — 1,984
- `Palatine bone` — 3,332
- `Pareital bone` — 1,838; source spelling retained
- `Sphenoid bone` — 6,637
- `Temporal bone` — 2,242
- `Vomer` — 866
- `Zygomatic bone` — 880
- `Lower teeth` — 2,288; `Upper teeth` — 2,592
- `Eyes.001` — 6,029; `Eyes_Surface` — 15,552

It is polished and efficient, but the eye pair is not a full semantic ocular
atlas and the bones are not a named-foramina model.

### Z-Anatomy source on disk

The local `Startup.blend` has 7,184 objects, 1,944 collections, and 188
materials. Its scene is metric and Z-up. The current generic registration
translates selected anatomy by the negative Z-Anatomy brain centre:

```text
(0.000000000, 0.008782502, 1.640712023) m
```

No scale or rotation is applied. This is centre alignment between atlases, not
patient image registration or a navigation transform.

The upstream repository places Z-Anatomy content under CC BY-SA 4.0 and lists
BodyParts3D attribution. It separately identifies cranial nerves/foramina as
University of Dundee CC BY 4.0, inner ear as University of Dundee CC BY-NC-SA
4.0, and “Brainder”/white matter as University of Washington without a precise
licence in the bundled notice:
<https://github.com/Z-Anatomy/Models-of-human-anatomy>.

Treat every extraction from the blend as a Z-Anatomy derivative subject to
ShareAlike unless legal/provenance review establishes a different direct-source
path. Do not infer that BodyParts3D’s newer licence automatically relicenses
Z-Anatomy edits.

## Exact intracranial coverage

### Cerebral cortex and lobes

The local HRA brain has **102 named cortical-region meshes / 382,682
triangles**. It is the strongest source for a high-detail parcellated cortex.
The complete exact list is in:

```text
sources.nih_hra.hra_brain_male.categories.named_cortical_regions.objects
```

A deterministic, mutually exclusive name-based candidate lobe map produces:

| Candidate group | Exact objects | Triangles | Examples |
| --- | ---: | ---: | --- |
| Frontal | 30 | 144,082 | bilateral precentral, superior/middle/inferior frontal, orbital, frontal pole, frontomarginal and gyrus rectus meshes |
| Parietal | 14 | 83,924 | bilateral postcentral, supraparietal, supramarginal, angular, precuneus, parietal operculum and caudal paracentral meshes |
| Temporal | 18 | 68,448 | bilateral superior/middle/inferior temporal, Heschl, planum, temporal pole, fusiform and perirhinal meshes |
| Occipital | 12 | 55,032 | bilateral cuneus, lingual, inferior/superior occipital, occipital pole and occipital fusiform meshes |
| Insula | 10 | 6,660 | bilateral short/long insular gyri, limen insula and agranular insular regions |
| Limbic/medial | 18 | 24,536 | bilateral cingulate, paracingulate, parahippocampal, piriform, subcallosal, gyrus ambiens and lateral olfactory meshes |

All 102 objects map, but this mapping is based on source names and must be
approved by a neuroanatomist before becoming a clinical-facing taxonomy. The
JSON includes every exact object name in each proposed group under
`candidate_cortical_lobe_mapping`.

Z-Anatomy separately offers 126 exact `Neo-cortex` tiles / 111,026 evaluated
triangles. It is useful for cross-checking contours and labels, but the HRA
brain is preferred for redistribution and native registration.

### Deep nuclei and limbic structures

The HRA brain yields **62 named meshes / 54,736 triangles** for a broad deep
nuclei and limbic selection. Exact bilateral structures include:

- caudate head, body and tail;
- putamen and posteroventral putamen;
- internal and external globus pallidus;
- nucleus accumbens and claustrum;
- thalamus plus named anterior, lateral dorsal, lateral posterior,
  mediodorsal, reuniens, pulvinar, ventral anterior/lateral, centromedian,
  parafascicular and habenular regions;
- hippocampal head, body and tail;
- amygdaloid complex and named subdivisions;
- hypothalamus, subthalamic nucleus, substantia nigra, red nucleus and zona
  incerta.

Several broad shells overlap their named subparts. The Houdini assembly must
use parent-shell versus subnucleus display modes; rendering every mesh opaque
at once would imply false additive anatomy.

Z-Anatomy has 15 comparable discovered meshes / 27,982 evaluated triangles,
but its `Hypothalamus` object has an implausible 0.475763 m superior–inferior
extent caused by a source topology/artifact tail. Exclude or repair it; never
use its unreviewed bounds as anatomy. Prefer the HRA hypothalamus pair.

### White matter and tracts

The HRA brain has **25 meshes / 136,396 triangles** in the conservative
white-matter/major-tract selection:

- `Allen_white_matter_of_forebrain_L/R` — 87,166 triangles combined;
- `Allen_white_matter_of_hindbrain_L/R` — 28,324 combined;
- `Allen_corpus_callosum_L/R` — 12,068 combined;
- `Allen_fornix_L/R` — 1,288 combined;
- `Allen_anterior_commissure_L/R` — 548 combined;
- `Allen_mammillothalamic_tract_L/R` — 248 combined;
- `Allen_optic_tract_L/R`, `Allen_optic_radiation_L/R`, and
  `VH_M_optic_chiasm`;
- bilateral inferior, middle and superior cerebellar peduncle regions and
  cerebral peduncles.

This is **not a tractography atlas**. It does not provide an independently
validated corticospinal tract, arcuate fasciculus, superior/inferior
longitudinal fasciculi, uncinate fasciculus, inferior fronto-occipital
fasciculus, optic-radiation fibres, or patient-specific streamline uncertainty.
Those require a separately licensed tract atlas or patient DTI processing and
specialist review.

Z-Anatomy has 14 selected white-matter/tract meshes / 313,714 evaluated
triangles, including bilateral telencephalic white matter, corpus callosum,
fornices, commissures, optic tracts, stria medullaris and superior cerebellar
peduncles. Do not distribute those as production assets until the bundled
University of Washington provenance is resolved.

### Ventricles, choroid plexus and CSF

The HRA brain provides **18 named ventricular/canal meshes / 16,602 triangles**:

- bilateral anterior, body, atrium, posterior and inferior portions of the
  lateral ventricles;
- bilateral halves of the third ventricle;
- bilateral cerebral-aqueduct halves;
- bilateral fourth-ventricle halves;
- small bilateral central-canal meshes.

Z-Anatomy provides five whole-space meshes / 16,369 evaluated triangles:
`Lateral ventricle.l`, `Lateral ventricle.r`, `Third ventricle`, `Aqueduct of
midbrain`, and `Fourth ventricle`, plus `Choroid plexus.l/r` / 5,294 triangles.

Neither local source contains a complete, independently toggleable
subarachnoid space, arachnoid granulations, or named basal cistern system.
“CSF flow” can only be a clearly labelled conceptual animation unless derived
from appropriate patient imaging and a validated model. The ventricle surfaces
are anatomical-space representations, not fluid simulation volumes with
measured boundary conditions.

### Meninges

Exact locally available anatomical partitions are:

- `Falx cerebri` — 14,724 evaluated triangles;
- `Tentorium cerebelli.l` — 4,480;
- `Tentorium cerebelli.r` — 4,480.

No complete cranial dura, arachnoid, or pia shell was found. The existing v2
dura is correctly marked conceptual. Offset shells can improve teaching
legibility but must carry `conceptual=true`, `thickness_not_to_scale=true`, and
must not be represented as measured meninges. The two `Choroid plexus` objects
are ventricular structures, not pia shells.

### Cranial nerves I–XII

Z-Anatomy contains the 24 exact bilateral main trunks / **305,800 evaluated
triangles**:

```text
Olfactory nerve (I).l/.r
Optic nerve (II).l/.r
Oculomotor nerve (III).l/.r
Trochlear nerve (IV).l/.r
Trigeminal nerve (V).l/.r
Abducens nerve (VI).l/.r
Facial nerve (VII).l/.r
Vestibulocochlear nerve (VIII).l/.r
Glossopharyngeal nerve (IX).l/.r
Vagus nerve (X).l/.r
Accessory nerve (XI).l/.r
Hypoglossal nerve (XII).l/.r
```

These are main teaching trunks, not a complete distal branch atlas. The long
0.519454 m group extent is caused by vagus/accessory continuation into the
neck. Export each pair independently and provide a 12-pair assembly; do not
force all nerves into every stroke scene.

### Pituitary and pineal

Z-Anatomy contains **two exact pituitary source meshes / 1,272 evaluated
triangles** in its `Endocrine glands` collection under `8: Visceral systems`:

- `Adenohypophysis` — 680 triangles;
- `Neurohypophysis` — 592 triangles.

Their combined source bounds are 0.011900 × 0.009156 × 0.012559 m. They are
registered in the same generic Z-Anatomy cranial frame even though their
collection ancestry does not contain the words `Head` or `Brain`. That
collection fact caused the first broad name-and-context discovery pass to miss
them; the reusable audit now uses these two exact object names and deliberately
excludes zero-area annotation helpers such as `Hypophysis.j` and text labels.
They are atlas-derived generic educational anatomy under Z-Anatomy's
ShareAlike/provenance constraints, not patient-specific segmentation.

The HRA brain contains `Allen_pineal_body_L/R`, 196 triangles combined.
It contains no pituitary mesh.

For a direct upstream alternative, the current BodyParts3D PART-OF table identifies
`FMA13889 / BP6711` as `pituitary gland`:
<https://dbarchive.biosciencedbc.jp/data/bodyparts3d/LATEST/partof_parts_list_e.txt>.
Acquire and inspect that source if a direct current BodyParts3D CC BY route is
preferred; its presence in the upstream mapping table does not relicense the
two Z-Anatomy derivatives.

### Eyes and orbits

The curated Z-Anatomy set has **32 exact structures / 102,756 evaluated
triangles**:

- bilateral anterior chamber, cornea, iris, lens, posterior segment, retina,
  sclera and vitreous body;
- bilateral lacrimal gland;
- bilateral superior/inferior/medial/lateral rectus and superior/inferior
  oblique muscles;
- bilateral optic nerves.

The NIH semantic skull adds polished contextual eye surfaces but fewer semantic
parts. A high-detail eye mode should lazy-load the semantic structures rather
than keep them in the default stroke assembly. The existing HRA eye models are
a potential future CC BY 4.0 acquisition, but they were not on disk and are not
counted as local geometry here.

No audited local source establishes a complete orbital fascia, orbital fat,
lacrimal drainage tree, eyelid lamellae, or retinal microvasculature.

### Ears

Locally available middle-ear ossicles are `Malleus.l/r`, `Incus.l/r`, and
`Stapes.l/r`: six objects / 21,712 evaluated triangles.

Nine discovered inner-ear/cochlear meshes total 33,558 evaluated triangles,
including `Cochlea.l/r`, `Vestibule.l/r`, cochlear nuclei and a cochlear-nerve
mesh. They are not a complete labyrinth audit, and the Z-Anatomy notice ties
the included inner-ear source to CC BY-NC-SA 4.0. Mark this group
`BLOCKED_LICENSE_FOR_ORDINARY_COMMERCIAL_DISTRIBUTION` pending legal review or
replace it with a separately licensed source.

The HRA skin provides external ears only as part of the complete skin surface,
not as separate semantic auricles.

### Sinonasal structures and airway

Thirteen local Z-Anatomy meshes / 7,102 evaluated triangles cover bilateral
nasal bones, inferior conchae, nasal septal cartilage, lateral septal
cartilage, coarse nasal regions, nasalis muscles, and the frontal/sphenoid air
sinus meshes.

The audit found no complete independently toggleable maxillary sinuses,
ethmoid labyrinth, nasal mucosa, turbinates beyond the inferior conchae,
nasopharyngeal/oropharyngeal airway volume, larynx, or oral airway volume in the
selected local head source. Do not claim a complete airway or paranasal sinus
model.

### Skull bones, sutures and foramina

The Z-Anatomy `skull_core` contains **22 exact bones / 112,343 evaluated
triangles**:

```text
Frontal bone
Parietal bone.l/.r
Temporal bone.l/.r
Occipital bone
Sphenoid bone
Ethmoid bone
Maxilla.l/.r
Mandible
Zygomatic bone.l/.r
Nasal bone.l/.r
Lacrimal bone.l/.r
Palatine bone.l/.r
Vomer
Inferior nasal concha bone.l/.r
```

No independent suture or foramen meshes were found. Some sutures are material
regions and foramina are holes in bone surfaces, but neither constitutes a
validated named-foramina data layer. The high-detail NIH skull may preserve
more external surface detail but remains a single mesh. Use annotation anchors
only after an anatomist verifies each landmark; do not infer foramina from
cranial-nerve paths alone.

### Muscles

The exact Z-Anatomy selector found 46 primary head-muscle bellies / 102,012
evaluated triangles, including bilateral facial-expression muscles,
temporalis, pterygoids, genioglossus/hyoglossus, extraocular muscles, and scalp
muscles. Its exact object list is in the JSON.

This selector does not represent every neck muscle or fascial compartment.
Load face/scalp, mastication, orbit, tongue/floor-of-mouth, and cervical groups
separately. Muscles are context for facial weakness, swallowing, access, and
orientation; the generic atlas cannot predict an individual patient's motor
deficit.

### Arteries

The audited cerebral arterial tree contains **40 exact structures / 345,418
evaluated triangles**. It includes bilateral ICA, vertebral, ACA, MCA M1/M2/M3,
PCA, PCom, callosomarginal/pericallosal, major cortical branches, AICA/PICA/SCA,
pontine branches, basilar, and the anterior communicating artery. The exact
names and triangle counts are in the JSON.

The separate neck-access set has eight exact objects / 21,024 triangles:
bilateral common, internal and external carotids plus vertebral arteries.

Coverage gaps:

- no honest full perforator network such as complete lenticulostriate,
  thalamoperforating, choroidal, or medullary arteries;
- no pial arteriole or capillary geometry;
- no patient stenosis, tortuosity, aneurysm, occlusion, collateral grade, vessel
  diameter, or access suitability;
- no measured wall thickness, compliance or plaque;
- no quantitative pressure, velocity, shear stress, or contrast transport.

### Veins and dural sinuses

The curated Z-Anatomy selection contains **56 objects / 142,432 evaluated
triangles**:

- 16 named dural sinuses, including superior/inferior sagittal, straight,
  transverse, sigmoid, occipital, cavernous, petrosal, and intercavernous
  structures;
- bilateral internal jugular veins;
- 38 additional ophthalmic, facial, scalp, retromandibular, maxillary,
  lingual, thyroid, vertebral, anterior jugular and external jugular veins.

The source does not provide a complete superficial cortical-vein tree, deep
cerebral venous system, internal cerebral veins, vein of Galen network, or
patient venous variants. Dural sinuses must not be conflated with the frontal
and sphenoid **air** sinuses.

### Lymphatics

The local atlas has 26 head lymphoid-node/tonsil meshes / 11,760 evaluated
triangles, including bilateral buccinator, infra-auricular, parotid,
mandibular, mastoid, nasolabial, occipital, pre-auricular, retropharyngeal,
submandibular and submental nodes plus palatine tonsils.

It contains no audited lymphatic-vessel tree and no defensible intracranial
meningeal-lymphatic or “glymphatic flow” geometry. Do not animate a literal
brain lymph-flow network from these node meshes.

### Cellular and microvascular teaching scale

The original 65 already include these procedural—not atlas-derived—assets:

| Existing asset | Triangles | Honest status |
| --- | ---: | --- |
| `artery_wall_cutaway_v2` | 20,508 | Layer thicknesses exaggerated; conceptual |
| `artery_interior_bloodflow_v2` | 16,170 | Illustrative blood volume, RBCs and direction cues; no quantitative hemodynamics |
| `red_blood_cells_closeup_v2` | 41,984 | Magnified biconcave teaching cells |
| `microcirculation_arterial_venous_v2` | 22,072 | Simplified arteriole–capillary–venule vignette |

No local authoritative geometry was found for a complete endothelial cell,
pericyte, astrocyte end-foot, basement membrane, neuron/glia network,
platelet/fibrin clot ultrastructure, blood-brain barrier, or histologically
validated infarct cascade. Those may be built as explicitly stylized concepts
using primary scientific references, but image generation can only help with
visual reference/material design; it cannot create clinical ground truth.

## Concrete asset plan

The plan below is intentionally split into buildable, conditional, and blocked
groups. “Build” means a generic educational asset; it does not mean approved
clinical software.

### Tier A — build from local CC BY 4.0 HRA/NIH geometry

1. `cortex_parcellation_102_region_assembly_v3` — all 102 HRA cortical meshes.
2. `frontal_lobe_named_regions_bilateral_v3` — 30 objects / 144,082 triangles.
3. `parietal_lobe_named_regions_bilateral_v3` — 14 / 83,924.
4. `temporal_lobe_named_regions_bilateral_v3` — 18 / 68,448.
5. `occipital_lobe_named_regions_bilateral_v3` — 12 / 55,032.
6. `insula_named_regions_bilateral_v3` — 10 / 6,660.
7. `limbic_medial_cortex_named_regions_v3` — 18 / 24,536.
8. `basal_ganglia_named_components_v3` — HRA caudate, putamen, pallidum,
   accumbens, claustrum, subthalamic and substantia-nigra components.
9. `thalamic_nuclei_named_components_v3` — broad shell and named-nuclei modes.
10. `hippocampal_formation_head_body_tail_v3`.
11. `amygdaloid_complex_named_components_v3`.
12. `hypothalamus_and_mammillary_regions_v3`.
13. `brainstem_named_regions_v3`.
14. `cerebellum_vermis_paravermis_hemispheres_v3` — eight HRA meshes / 41,452
    triangles including deep nuclei.
15. `cerebral_white_matter_bilateral_v3`.
16. `corpus_callosum_bilateral_v3`.
17. `fornix_commissures_mammillothalamic_v3`.
18. `optic_pathway_chiasm_tract_radiation_v3`.
19. `cerebellar_and_cerebral_peduncles_v3`.
20. `lateral_ventricles_segmented_parts_v3`.
21. `third_aqueduct_fourth_ventricle_v3`.
22. `pineal_body_generic_v3`.
23. `external_head_hra_crop_high_v3` with medium/low LODs.
24. `semantic_skull_eyes_context_v3`.
25. `high_detail_skull_surface_reference_v3` for close-up/normal baking only.

Before build, a neuroanatomist must approve the candidate lobe grouping and
the broad-shell versus nested-substructure display rules.

### Tier B — build only with Z-Anatomy ShareAlike/provenance controls

26–37. `cranial_nerve_01_olfactory_bilateral_v3` through
`cranial_nerve_12_hypoglossal_bilateral_v3`.
38. `cranial_nerves_12_pair_assembly_v3`.
39. `falx_tentorium_meningeal_partitions_v3`.
40. `eye_semantic_internal_bilateral_v3`.
41. `extraocular_muscles_and_optic_nerves_v3`.
42. `middle_ear_ossicles_bilateral_v3`.
43. `skull_22_bone_semantic_set_v3`.
44. `face_scalp_mastication_muscles_v3`.
45. `tongue_floor_of_mouth_muscles_v3`.
46. `cerebral_arteries_40_structure_high_v3`.
47. `circle_of_willis_core_v3`.
48. `anterior_circulation_aca_mca_segments_v3`.
49. `posterior_circulation_vertebrobasilar_cerebellar_v3`.
50. `dural_venous_sinuses_16_structure_v3`.
51. `head_neck_veins_56_structure_assembly_v3`.
52. `head_lymph_nodes_26_structure_v3`.
53. `sinonasal_partial_atlas_v3`, labelled incomplete.
54. `pituitary_adenohypophysis_neurohypophysis_v3` — exact Z-Anatomy meshes
    `Adenohypophysis` and `Neurohypophysis`, 1,272 triangles combined. Keep the
    two lobes independently addressable and label the result generic atlas
    anatomy, not endocrine physiology or patient segmentation.

Every derivative needs attribution and a ShareAlike-compatible distribution
decision. Where practical, reacquire the equivalent current BodyParts3D
objects directly under its current CC BY 4.0 terms.

### Tier C — reacquire, replace, or keep as an explicit placeholder

55. `cortical_lobes_bodyparts3d_direct_v3` — optional licensing-clean direct
    route. Current official IDs include right/left frontal `BP10514/BP10527`,
    temporal `BP10519/BP10505`, parietal `BP10537/BP10507`, occipital
    `BP10509/BP10550`, insula `BP10549/BP10554`, and limbic lobe
    `BP10502/BP10531`.
56. `internal_capsule_bodyparts3d_direct_v3` — `BP10516/BP10532`.
57. `ventricular_system_bodyparts3d_direct_v3` — lateral ventricles
    `BP10503/BP10543`, third `BP6685`, aqueduct `BP6684`, fourth `BP6686`.
58. `white_matter_bodyparts3d_direct_v3` — right/left cerebral white matter
    `BP10496/BP10489`.
59. `complete_paranasal_sinus_and_airway_v3` — no complete local source;
    acquire a properly licensed atlas or derive from approved patient imaging.
60. `named_skull_sutures_foramina_v3` — no independent local geometry; acquire
    and anatomist-validate rather than infer.
61. `superficial_and_deep_cerebral_veins_v3` — no complete local source;
    acquire a licensed atlas or derive from reviewed CTV/MRV.
62. `cerebral_perforator_arteries_v3` — no complete local source; do not
    procedurally claim exact anatomy.
63. `major_white_matter_tractography_v3` — use a licensed tract atlas or
    patient DTI with uncertainty metadata.
64. `complete_inner_ear_v3` — replace the NC-SA source or obtain an approved
    licensing path.

The current BodyParts3D download page publishes the mesh archives and mapping
tables: <https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html>. Its
licence page, updated 2025-02-27, states CC BY 4.0 and the required attribution:
<https://dbarchive.biosciencedbc.jp/en/bodyparts3d/lic.html>.

### Tier D — separate conceptual micro/physiology stages

65. `artery_wall_endothelium_media_adventitia_v3`.
66. `neurovascular_unit_bbb_v3` — endothelium, basement membrane, pericyte and
    astrocyte end-foot concept.
67. `capillary_exchange_and_rbc_deformation_v3`.
68. `blood_cell_set_rbc_platelet_leukocyte_v3`.
69. `thrombus_fibrin_platelet_rbc_composition_v3`.
70. `ischemic_cascade_cellular_teaching_v3`.
71. `cytotoxic_vasogenic_edema_comparison_v3`.
72. `collateral_flow_conceptual_comparison_v3`.
73. `clot_device_interaction_conceptual_v3`.

These are magnified educational concepts. Each must declare `display_scale`,
`physical_scale`, `conceptual=true`, `quantitative=false`, and
`clinical_review_status`. They must never be spatially composited into the
life-size head as if their visible size were anatomical.

## Scale and Houdini assembly rules

Use three independent USD stages or clearly separated variants:

| Stage | Coordinate/scale contract | Permitted content |
| --- | --- | --- |
| `MACRO_HEAD` | metres, life-size, `metersPerUnit=1` | skin, skull, brain, nerves, major vessels, lesion and device context |
| `MESO_VESSEL` | physical dimensions retained plus explicit presentation magnification | artery wall, lumen, thrombus-device cross-sections |
| `MICRO_CELLULAR` | physical micrometre metadata plus explicit display magnification | cells, capillary/BBB and ischemic-cascade teaching scenes |

Never pass visual display scale into a solver as physical scale. Houdini uses a
Y-up right-handed metre convention:
<https://www.sidefx.com/docs/houdini/unreal/coordinates.html>. Its dynamics use
SI base units, including metres:
<https://www.sidefx.com/docs/houdini/dyno/about.html>.

For generic flow FX:

- store arterial/venous direction as a categorical curve attribute, not a
  measured velocity;
- mark particles and RBC instancing as symbolic;
- do not infer pressure, wall shear, vessel compliance, contrast timing, or
  collateral adequacy from atlas radius;
- keep clot/device contact a conceptual animation unless the geometry,
  materials, boundary conditions, solver, and outputs are separately validated;
- preserve source vessel centreline IDs and branch names through resampling;
- never bridge missing vessel branches procedurally while retaining an
  “anatomical” claim.

Recommended primitive attributes:

```text
anatomical_id
anatomical_name
laterality
source_asset_id
source_object_name
source_version
source_sha256
source_license
source_kind = GENERIC_ATLAS | PATIENT_SEGMENTATION | CONCEPTUAL
patient_specific = 0|1
physical_scale_m
display_scale
registration_frame
registration_method
quantitative = 0|1
clinical_review_status
conceptual_reason
lod
```

## Patient-specific DICOM-to-Houdini replacement hooks

### Replacement slots

The generic assemblies should expose stable input slots:

| Houdini input | Generic fallback | Patient-specific replacement source |
| --- | --- | --- |
| `IN_HEAD_SKIN` | HRA skin crop | approved CT/MRI external-surface segmentation |
| `IN_SKULL` | NIH/Z-Anatomy skull | thin-slice CT bone segmentation |
| `IN_BRAIN_PARENCHYMA` | HRA brain | clinician-reviewed T1/T2/FLAIR segmentation |
| `IN_CORTEX_LABELS` | HRA named regions | approved patient parcellation, with algorithm/version |
| `IN_VENTRICLES` | HRA ventricles | reviewed CT/MRI segmentation |
| `IN_ARTERIAL_TREE` | Z-Anatomy arteries | CTA/MRA/3DRA/DSA-derived reviewed vessel segmentation |
| `IN_VENOUS_TREE` | Z-Anatomy dural/head veins | CTV/MRV reviewed segmentation |
| `IN_LESION_CORE` | generic clot/infarct teaching mesh | reviewed DWI/ADC or CT-derived lesion segmentation |
| `IN_PERFUSION_MAPS` | none | registered clinical parametric maps with provenance |
| `IN_DTI_TRACTS` | no patient fallback | reviewed tractography plus uncertainty metadata |
| `IN_DEVICE_PATH` | generic educational route | approved procedural-plan or recorded device centreline; never inferred from atlas |

Routine scans usually cannot resolve cranial nerves, pia/arachnoid, capillary
beds, cellular injury, or a complete perforator network. For those slots, use
the generic layer with a visible “generic atlas” label or omit the layer; do not
warp it and call it patient-specific.

### DICOM frame contract

Prefer DICOM Segmentation (SEG) or DICOM Surface Segmentation objects tied to
the source study and `FrameOfReferenceUID`. The DICOM standard defines image
position/orientation in the patient-based coordinate system and uses
millimetres. For a biped, +X is patient left, +Y posterior, +Z toward the head:
<https://dicom.nema.org/medical/dicom/current/output/chtml/part03/sect_c.7.6.2.html>.

For column-vector points in DICOM LPS millimetres, the explicit map to the
project's Houdini Y-up, right-handed metre frame is:

```text
x_h = -0.001 * x_lps
y_h =  0.001 * z_lps
z_h =  0.001 * y_lps

M_lps_mm_to_houdini_m =
[[-0.001,  0.000, 0.000, 0],
 [ 0.000,  0.000, 0.001, 0],
 [ 0.000,  0.001, 0.000, 0],
 [ 0.000,  0.000, 0.000, 1]]
```

If a tool exports RAS millimetres, use `(x_ras, z_ras, -y_ras) * 0.001`.
3D Slicer documents that DICOM uses LPS while its internal scene uses RAS and
supports DICOM SEG and several surface/model formats:
<https://slicer.readthedocs.io/en/latest/user_guide/data_loading_and_saving.html>.

Do not centre patient surfaces independently. Parent every structure under one
`PATIENT_FRAME` xform and retain:

```text
StudyInstanceUID (secured or hashed for downstream metadata)
SeriesInstanceUID
FrameOfReferenceUID
ImagePositionPatient
ImageOrientationPatient
PixelSpacing / slice spacing
segmentation algorithm and version
source series/modality
registration transform and transform hash
review status, reviewer role and timestamp
de-identification status
```

Keep raw DICOM and identifiable facial surfaces out of public repositories and
general asset bundles. NIH 3D's own terms prohibit uploads of protected health
information and restrict identifiable facial data without documented consent:
<https://3d.nih.gov/terms>. A hospital deployment additionally needs its own
privacy, cybersecurity, quality, clinical-validation and regulatory review.

### Replacement acceptance gates

Do not switch a slot from `GENERIC_ATLAS` to `PATIENT_SEGMENTATION` until all of
these pass:

1. Source series and Frame of Reference are identified.
2. Units and LPS/RAS conversion are verified with three or more landmarks.
3. No left/right reflection is present.
4. The surface has expected component count, bounds, normals, and manifold
   status or a documented reason for exceptions.
5. Registration residual/error is recorded; “looks aligned” is insufficient.
6. Segmentation algorithm, parameters and version are recorded.
7. A qualified reviewer approves the anatomy and lesion labels for the intended
   use.
8. The viewer visibly distinguishes patient data from generic overlays.
9. PHI is confined to the approved clinical environment.
10. Exported USD/USDZ carries no raw DICOM identifiers or hidden file paths.

## Claims that are not supportable

The current sources and proposed generic assets cannot honestly support these
claims:

- “complete anatomy” or “every vessel/cell”;
- patient-specific anatomy without patient-authorized image segmentation;
- clinical validation, diagnosis, prognosis, treatment recommendation, device
  sizing, access-route selection, or surgical navigation;
- accurate perfusion, collateral grade, pressure, velocity, wall shear,
  compliance, clot friction or procedural success prediction;
- accurate cellular or microvascular placement inside a particular patient's
  brain;
- complete perforator arteries, cortical/deep cerebral veins, meningeal
  lymphatics, white-matter tractography, cranial-nerve branches, named skull
  foramina, or full airway from the local geometry;
- a guaranteed outcome or recovery pathway;
- an implication that NIH, HRA, BodyParts3D, Z-Anatomy, or any cited institution
  endorses the product.

The correct product wording is “generic, clinician-reviewed educational
visualization with optional reviewed patient-specific overlays,” unless and
until a separate regulated clinical-validation programme establishes a broader
intended use.

## Source URLs and licence record

- NIH 3D Brain, Male `3DPX-020960` v1.01:
  <https://3d.nih.gov/entries/20960?version=1.01>
- HRA 3D Reference Object Library:
  <https://humanatlas.io/3d-reference-library>
- NIH 3D terms and medical disclaimer: <https://3d.nih.gov/terms>
- Z-Anatomy source and bundled attribution/licence notice:
  <https://github.com/Z-Anatomy/Models-of-human-anatomy>
- BodyParts3D current licence:
  <https://dbarchive.biosciencedbc.jp/en/bodyparts3d/lic.html>
- BodyParts3D downloads:
  <https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html>
- BodyParts3D current PART-OF ID/name table:
  <https://dbarchive.biosciencedbc.jp/data/bodyparts3d/LATEST/partof_parts_list_e.txt>
- DICOM current Image Plane / Patient-Based Coordinate System:
  <https://dicom.nema.org/medical/dicom/current/output/chtml/part03/sect_c.7.6.2.html>
- 3D Slicer loading, DICOM SEG and LPS/RAS guidance:
  <https://slicer.readthedocs.io/en/latest/user_guide/data_loading_and_saving.html>
- SideFX Houdini coordinate/units guidance:
  <https://www.sidefx.com/docs/houdini/unreal/coordinates.html>

## Audit outputs

- Human-readable report: `research/INTRACRANIAL_DETAIL_SOURCE_AUDIT.md`
- Machine-readable source inventory:
  `research/intracranial_detail_source_audit.json` (development/source kit;
  not duplicated in this runtime publishing tree)
- Reusable read-only audit script:
  `source/audit_intracranial_detail_sources.py` (development/source kit; not
  duplicated here)

The original read-only audit run did not modify a manifest, runtime viewer,
publishing repository, or source anatomy file; this report was copied later as
publishing documentation.
