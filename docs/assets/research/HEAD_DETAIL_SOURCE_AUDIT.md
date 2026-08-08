# Head-detail anatomy source audit

Date: 2026-08-08
Scope: generic head anatomy for the Vision Pro Stroke Patient Education Kit v2
Status: source and licensing audit only; no geometry was extracted or built by
this audit.

## Decision summary

The next polished head pass can be built mostly from sources already on disk.
The strongest near-term combination is:

1. Use the acquired current **HRA Skin, Male** model to derive a neutral bald
   head and upper-neck shell. Its closed, artifact-free surface and shared HRA
   frame make it preferable to repairing the coarse Z-Anatomy regional surface
   or the bilateral teaching cutaway in the NIH bust.
2. Extract Z-Anatomy's exact **falx cerebri**, **tentorium cerebelli**, dural
   venous sinuses, head/neck veins, common/internal/external carotids, vertebral
   arteries, eye anatomy, selected muscles, and selected cranial nerves.
3. Keep the existing HRA brain and NIH semantic skull/eyes as the registration
   anchors.
4. If the application cannot accept ShareAlike assets, reacquire equivalent
   artery/skull geometry directly from the current BodyParts3D archive, which
   now publishes its direct database under CC BY 4.0. Geometry copied or
   modified from the Z-Anatomy blend remains subject to Z-Anatomy's CC BY-SA
   4.0 terms.

No source discovered here should be represented as patient-specific anatomy,
a surgical plan, a navigation model, or a validated prediction of blood flow.

## Files inspected

- `../vendor/nih3d/inspection_blender_5.2.0.json`
- `../vendor/nih3d/hra_skin_male_3DPX-021016_v2/inspection_blender_5.2.0.json`
- `../vendor/nih3d/hra_skin_male_3DPX-021016_v2/registration_crop_inspection_blender_5.2.0_final.json`
- `z_anatomy_extraction_map.json`
- `z_anatomy_focused_inventory.json`
- `../vendor/z_anatomy/Z-Anatomy/Startup.blend`
- `../vendor/z_anatomy/LICENSE.txt`
- `../vendor/nih3d/*/{SOURCE,PROVENANCE,LICENSE}.md`

The focused read-only audit script is
`../source/audit_z_anatomy_head_detail.py`; its complete machine-readable output
is `z_anatomy_head_detail_audit.json`. Counts below are Blender 5.2 evaluated
polygon counts. Curves are counted after the atlas bevel is evaluated, so they
are suitable for estimating cost but are not source control-point counts.

## Existing NIH/HRA sources on disk

| Source | Geometry and scale found locally | Best use | License / review status |
| --- | --- | --- | --- |
| HRA Brain, Male, NIH 3D 3DPX-020960 v1.01 | 283 named meshes; 653,212 triangles; 0.136377 x 0.167040 x 0.146096 m | Existing brain, ventricles, deep structures, cerebellum and brainstem | CC BY 4.0; HRA generic reference anatomy. HRA describes its reference objects as created by medical illustrators and approved by organ experts, but this is not patient-specific clinical validation. |
| HRA Skin, Male, NIH 3D 3DPX-021016 v2 | One closed mesh; 829,184 triangles; 1.043153 x 0.325631 x 1.824276 m whole-body extent; no textures or UVs | Clean external head/face/ear/neck source; derive a non-destructive head crop | CC BY 4.0; HRA generic Visible Human-derived reference anatomy. The exact file, entry version and hash are preserved locally. |
| Skull and Eyes - Visible Human Male, NIH 3D 3DPX-020591 v1.03 | 17 meshes; 53,745 triangles; normalized size about 0.2579 x 0.1728 x 0.2804 m; four embedded 2K PBR maps | Existing semantic cranial bones, teeth and polished contextual eyes | CC BY 4.0; generic Visible Human-derived anatomy. |
| Visible Human Male Skull, NIH 3D 3DPX-012260 v3 | One mesh; 580,286 triangles; normalize source by 0.1 to about 0.2379 x 0.3316 x 0.3565 m | Optional very-high-detail skull close-up and normal-map baking | CC BY 4.0; generic Visible Human-derived anatomy. |
| Visible Human Male Bust, NIH 3D 3DPX-023209 v1 | One mesh; 498,902 triangles; 0.5300 x 0.3478 x 0.3500 m | Context/reference only | CC BY 4.0. It is a bilateral skin-versus-deroofed teaching sculpt, not a clean full scalp shell; the local GLB is one untextured mesh despite the entry description's separated-source intent. |

The NIH files are educational/illustrative assets. NIH 3D explicitly states
that models are not intended for medical diagnosis or treatment and that users
must independently verify scientific conclusions:
<https://3d.nih.gov/terms>.

## Exact Z-Anatomy candidates already on disk

| Proposed extraction group | Objects | Raw evaluated polygons | Source dimensions (m) | Assessment |
| --- | ---: | ---: | --- | --- |
| `scalp_shell` | 8 | 768 | 0.163750 x 0.201877 x 0.152118 | Exact epicranial patches only. Too coarse and too fragmented for the polished outer head. Retain only as a registration reference. |
| `outer_head_regions` | 87 | 16,459 | 0.196317 x 0.248347 x 0.255603 | Broad regional face/head surface. Useful for labels and registration, not as the final skin render without major remesh and seam repair. |
| `skull_core` | 22 | 105,785 | 0.148676 x 0.203647 x 0.209157 | Independently toggleable principal skull/facial bones. The current NIH semantic skull remains more visually polished. |
| `meningeal_partitions` | 3 | 11,926 | 0.120674 x 0.174804 x 0.119539 | Good source for internal dura partitions. No complete cranial dura, arachnoid or pia shell was found. |
| `cerebral_veins_and_dural_sinuses` | 18 | 27,152 | 0.121950 x 0.177174 x 0.289950 | Strong source for dural venous drainage and internal jugular outflow. No superficial/deep cerebral cortical-vein tree was found. |
| `head_and_neck_veins` | 56 | 71,216 | 0.157804 x 0.191816 x 0.293012 | Dural sinuses plus ophthalmic, facial/scalp, vertebral, external/anterior/internal jugular veins. Excludes the bony frontal and sphenoid air sinuses. |
| `neck_access_arteries` | 8 | 10,512 | 0.091912 x 0.057196 x 0.208726 | Common, internal and external carotids plus vertebral arteries; appropriate for a head/neck access overview. It does not extend to femoral or radial access. |
| `cerebral_arterial_tree` | 40 | 172,736 | 0.142000 x 0.152413 x 0.280298 | Existing major intracranial artery source, including Circle of Willis, MCA/ACA/PCA and cerebellar/pontine branches. Down-resolve bevels before mesh conversion. |
| `eye_detail_z` | 32 | 66,884 | 0.101012 x 0.059934 x 0.036655 | Both eyes: globe segments, cornea, iris, lens, retina, sclera, vitreous, lacrimal gland, six extraocular muscles and optic nerves. |
| `stroke_relevant_muscles` | 20 | 90,852 | 0.282406 x 0.194217 x 0.295988 | Temporalis, masseter layers, pterygoids, sternocleidomastoid, platysma, frontalis, occipitalis and temporoparietalis. Use as optional teaching/context layers. |
| `cranial_nerves_main` | 24 | 154,600 | 0.135405 x 0.199017 x 0.519454 | Bilateral cranial nerves I-XII. The long z extent is caused by vagus/accessory paths into the neck. Load only for an anatomy-exploration mode. |

### Exact meningeal objects

- `Falx cerebri`
- `Tentorium cerebelli.l`
- `Tentorium cerebelli.r`

The blend contains no complete `cranial dura`, `arachnoid` or `pia mater`
surface. `Choroid plexus.l` and `Choroid plexus.r` are present in the
`Cranial pia` collection, but they are ventricular structures and should not be
misrepresented as a pia shell.

A whole dura/arachnoid/pia presentation therefore needs either a separately
licensed source or a clearly labelled **conceptual covering** generated from
registered skull/brain offsets. Such generated shells should use exaggerated
visual spacing/thickness for legibility and must not claim measured anatomy.

### Exact dural-sinus and jugular objects

- `Superior sagittal sinus`, `Inferior sagittal sinus`, `Straight sinus`,
  `Occipital sinus`
- `Transverse sinus.l`, `Transverse sinus.r`, `Sigmoid sinus.l`,
  `Sigmoid sinus.r`
- `Cavernous sinus.l`, `Cavernous sinus.r`
- `Superior petrosal sinus.l`, `Superior petrosal sinus.r`,
  `Inferior petrosal sinus.l`, `Inferior petrosal sinus.r`
- `Anterior intercavernous sinus`, `Posterior intercavernous sinus`
- `Internal jugular vein.l`, `Internal jugular vein.r`

The broader 56-object head/neck venous set additionally contains bilateral
angular, facial, retromandibular, maxillary, superficial temporal, occipital,
posterior auricular, labial, lingual, submental, ophthalmic, anterior/external
jugular, vertebral and superior thyroid veins. The complete exact list and
per-object geometry are in `z_anatomy_head_detail_audit.json` under
`head_and_neck_veins_discovery`.

### Exact proximal arterial access objects

- `Left common carotid artery`, `Right common carotid artery`
- `Internal carotid artery.l`, `Internal carotid artery.r`
- `External carotid artery.l`, `External carotid artery.r`
- `Vertebral artery.l`, `Vertebral artery.r`

The existing exact 40-object intracranial list is already maintained in
`z_anatomy_extraction_map.json` under `cerebral_arterial_tree`. Keep that file as
the extraction authority instead of rediscovering vessels by fuzzy names.

### Exact bilateral cranial-nerve group

Use `.l` and `.r` objects for each of:

`Olfactory nerve (I)`, `Optic nerve (II)`, `Oculomotor nerve (III)`,
`Trochlear nerve (IV)`, `Trigeminal nerve (V)`, `Abducens nerve (VI)`,
`Facial nerve (VII)`, `Vestibulocochlear nerve (VIII)`,
`Glossopharyngeal nerve (IX)`, `Vagus nerve (X)`, `Accessory nerve (XI)`, and
`Hypoglossal nerve (XII)`.

Do not pull the inner-ear collection as part of this extraction. Z-Anatomy's
license file identifies the included inner-ear reference as CC BY-NC-SA 4.0,
which is a different and more restrictive provenance path.

## Additional official open sources evaluated

### HRA Skin, Male — acquired and inspected

- Current NIH 3D entry: **3DPX-021016, version 2**
  <https://3d.nih.gov/entries/21016?version=2>
- Official NIH download endpoint used:
  <https://3d.nih.gov/api/submissions/29079/files/input/741555>
- HRA library: <https://humanatlas.io/3d-reference-library>
- HRA states that all its 3D reference objects are CC BY 4.0.
- The current entry states that its head was adjusted in HRA skin v2.3 to more
  closely resemble the original Visible Human Male skin and make room for the
  mouth and landmarks.

The exact unmodified file is preserved at
`../vendor/nih3d/hra_skin_male_3DPX-021016_v2/source/3d-vh-m-skin.glb`:
19,901,928 bytes, SHA-256
`4764602f0866fbdad19382e7f12ba148ee33141677153b556f7238116bc33c2a`.
The NIH entry version is **2**. The page description calls the current anatomy
HRA skin v2.3, while the GLB's embedded anatomical identifier still reads
`#VHMSkinV1.2`; all three labels are preserved in the source record rather than
being silently conflated.

Blender 5.2.0 LTS imported one object/mesh, `VH_M_skin`, with 414,594 vertices
and 829,184 triangles. It is one closed connected component with zero boundary,
wire, non-manifold, or zero-area faces (Euler characteristic 2). It has one
authored display material, no image textures, no UV layer and no color
attributes. The 1.824276 m body height and approximately 1.043153 m lateral
extent indicate that the GLB is already in metres. No disconnected accessories or
floating fragments were found.

The best starting crop for a head plus restrained upper neck is native
`Z >= 0.660 m`: 29,553 retained vertices, 58,840 triangles fully above the
plane, 529 triangles crossing it, and bounds of approximately
0.195671 x 0.242102 x 0.251168 m. `Z >= 0.640 m` retains a broader
0.247938 m-wide lower-neck/shoulder transition; `Z >= 0.700 m` produces a
shorter 49,860-triangle floating-head option. Any crop opens a neck ring, which
must be capped or hidden under a presentation collar in the derived asset.

The HRA brain and skin share the same native Visible Human/HRA frame. Centering
both by the brain-bounds translation
`(0.000090, -0.001155, -0.829567) m` is the correct initial registration for
the current centered brain. At the brain-center slice, the skin is about
0.162562 x 0.214027 m versus the brain's overall
0.136377 x 0.167040 x 0.146096 m bounds, giving plausible external clearance.
The current semantic skull was normalized and centered independently; it
extends roughly 28.6 mm above and 32.3 mm beyond the simply centered skin
bounds along one horizontal axis. Register that skull with cranial-vault,
orbital, nasal/maxillary and occipital landmarks before use rather than applying
an undocumented uniform scale.

**Replacement decision:** yes, this is a cleaner external-shell source than the
bust-derived scalp. It is bilateral, complete, closed, artifact-free and
natively co-registered with the HRA brain. It is not production-ready as-is:
the derived crop still needs a neck treatment, UVs, skin PBR/subsurface
materials, curvature-aware LODs, and visual QA of eyelids, nares, lips, ears and
chin. It remains generic educational anatomy, not a clinically reviewed
patient-specific surface. This audit found no named clinical-review record on
the versioned NIH entry for this exact skin file, so it must not be marketed as
clinically validated; any patient-facing use still needs independent clinician
review.

### HRA Eye, Male, Left/Right — recommended for a detailed-eye mode

Official HRA v1.2 eye assets are CC BY 4.0 and list three specialist reviewers.
The left asset has 23 semantic meshes and 20 materials, including cornea,
conjunctiva, iris, lens, retina, macula/fovea, optic disc/choroid, ciliary body,
vitreous and aqueous humor. The official left GLB is 27,462,180 bytes and has an
estimated 346,630 indexed source triangles before LOD processing; the right GLB
is 20,697,112 bytes.

- Left source metadata:
  <https://cdn.humanatlas.io/hra-releases/v2.0/markdown/ref-organs/3d-vh-m-eye-l.md>
- HRA library: <https://humanatlas.io/3d-reference-library>

These eyes are more semantically complete than the two-eye PBR shell in the
existing NIH skull asset, but much heavier. Use the NIH semantic skull eyes for
normal viewing and lazy-load a decimated HRA eye only when the user selects an
eye detail mode.

### HRA Blood Vasculature, Male — useful but not a cerebral replacement

The official v1.2 HRA blood-vasculature GLB is CC BY 4.0 and has named expert
reviewers. Remote inspection found 104 meshes, about 359,598 indexed triangles,
three materials and a 7,436,204-byte file. Its head-relevant coverage includes
the left common carotid, ophthalmic/central-retinal vessels and ophthalmic
veins, but it does **not** provide the detailed internal-carotid/Circle of
Willis/MCA tree already present in Z-Anatomy. It is therefore useful for
whole-body context, not as the new head arterial source.

Official metadata and data link:
<https://cdn.humanatlas.io/hra-releases/v2.0/markdown/ref-organs/3d-vh-m-blood-vasculature.md>.

### Direct BodyParts3D — recommended licensing-clean replacement route

The official BodyParts3D archive currently states that its database is CC BY
4.0 (license page last updated 2025-02-27):
<https://dbarchive.biosciencedbc.jp/en/bodyparts3d/lic.html>.

Its official download page provides the 99%-reduced v4 polygon archives and the
FMA-to-model-ID tables:
<https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html>.

Examples confirmed in the current PART-OF table include:

- right/left common carotids: `BP9519`, `BP9517`
- right/left internal carotids: `BP9518`, `BP9516`
- right/left vertebral arteries: `BP9432`, `BP9323`
- right/left anterior cerebral arteries: `BP9915`, `BP10243`
- right MCA: `BP9813`; basilar artery: `BP9431`
- anterior communicating artery: `BP6762`
- right/left posterior communicating arteries: `BP7710`, `BP9658`
- right/left posterior cerebral arteries: `BP7696`, `BP9430`
- frontal/occipital/sphenoid bones: `BP9668`, `BP10180`, `BP9806`
- right/left temporal bones: `BP10032`, `BP9536`
- right/left parietal bones: `BP10121`, `BP10199`
- right/left eyeballs: `BP7094`, `BP7110`

Direct BodyParts3D acquisition is the preferred long-term replacement for any
equivalent Z-derived structures when a proprietary distribution cannot accept
ShareAlike. A license change on the upstream database does not automatically
relicense Z-Anatomy's own edits or compilation.

### Official sources rejected or held

| Source | Decision |
| --- | --- |
| NIH 3D 3DPX-002604, *Cranial arteries* | Reject for this product path: NIH displays CC BY-NC, and the model includes a PCOM aneurysm rather than generic stroke anatomy. |
| NIH 3D 3DPX-001277, *Partial Brain Vascular Network* | Reject for this product path: NIH displays CC BY-NC and provenance is a user-contributed CT segmentation rather than an expert-reviewed generic reference object. |
| NIH 3D 3DPX-014739, temporal bone/sigmoid model | Reject: CC BY-NC-SA and focused on otologic drilling. |
| NIH 3D 3DPX-017774, FDA Circle-of-Willis aneurysm phantom | Hold. It includes dura tent, cranial nerves and arteries, but it is a pathological aneurysm/ICG phantom and the entry's license was not exposed clearly enough during this audit to authorize acquisition. |

Nothing was purchased, no candidate source was added to the project, and no
source with unclear licensing was acquired.

## Licensing boundary

### NIH/HRA assets

The audited NIH/HRA brain, skull, eyes, bust, skin and HRA reference-object
candidates are CC BY 4.0 when used from the exact identified entries. Preserve
creator, title, version, entry/DOI, license URL and modification notes. NIH 3D
also warns that each entry can have different licensing, so the entry-specific
license must be captured at acquisition time.

### Z-Anatomy assets

The local `Startup.blend` is distributed by Z-Anatomy under CC BY-SA 4.0 and
requires attribution to both Z-Anatomy and its stated BodyParts3D source. Z's
repository states that derivative works based on its content must use the same
license:
<https://github.com/Z-Anatomy/Models-of-human-anatomy>.

It also identifies the cranial-nerves/foramina reference as University of
Dundee CC BY 4.0, but the distributed Z compilation and Z modifications still
need Z's attribution/ShareAlike treatment unless provenance is reconstructed
from a direct upstream asset.

### Generic versus reviewed

- **HRA reference objects:** generic reference anatomy with named reviewers;
  still not a clinical or patient-specific model.
- **Visible Human/NIH user entries:** generic or donor-derived educational
  anatomy; NIH does not guarantee accuracy and prohibits diagnostic/treatment
  use.
- **Z-Anatomy/BodyParts3D:** generic atlas geometry. This audit did not find
  evidence that the exact Z extraction groups were clinically reviewed for
  thrombectomy education.
- **Conceptual generated shells/flow overlays:** production illustrations only;
  never call them measured anatomy or computational fluid dynamics.

## Prioritized production plan

### P0 — highest impact on the head experience

1. **Outer head and neck shell**
   - Derive a non-destructive `Z >= 0.660 m` bald head/upper-neck crop from the
     preserved HRA Skin, Male source.
   - Cap or hide the crop ring and register it to the existing HRA brain first,
     then landmark-register the independently normalized NIH skull.
   - Target high/medium/low LODs of roughly 80-120k / 35-60k / 12-25k
     triangles.
   - Use ImageGen only for seamless skin base-color/roughness microtexture and
     subtle subsurface-color reference. Do not use image generation to invent
     anatomical geometry.

2. **Meningeal teaching layers**
   - Extract the exact falx and tentorium objects.
   - Build separately toggleable conceptual dura, arachnoid and pia envelopes
     from registered offsets only if no appropriately licensed full-shell
     source is acquired. Label the spacing/thickness as illustrative.
   - Target 10-15k triangles for falx/tentorium and 15-30k per conceptual shell.

3. **Venous drainage**
   - Extract the 18-object dural-sinus/internal-jugular group first.
   - Add the 56-object head/neck venous group as an optional expanded layer.
   - Preserve separate sinuses, jugular outflow and superficial veins so they
     can be introduced progressively rather than rendered as one blue mass.
   - Target about 25-45k triangles for the core sinus layer and 50-80k for the
     expanded venous layer after curve resampling.

4. **Neck inflow and cerebral arterial detail**
   - Add common/external carotids and vertebral arteries to the existing
     internal-carotid/Circle-of-Willis tree.
   - Retain vessel identities and centerlines before mesh conversion; flow
     overlays and catheter paths should reference those centerlines.
   - Keep the eight proximal vessels near 8-15k triangles and the intracranial
     tree near 80-120k high LOD.

5. **Blood-flow presentation assets**
   - Derive lumen/centerline proxies from the registered arteries and veins.
   - Use moving shader bands, sparse instanced cells or particles and directional
     arrows for education. Do not imply that their speed, pressure, turbulence
     or collateral perfusion is patient-specific or CFD-derived.
   - Author separate normal-flow, occluded-flow and restored-flow states rather
     than destructively changing the source vessel mesh.

### P1 — polish and explanatory depth

6. **Eyes and orbital structures:** keep the existing PBR eyes for normal view;
   add decimated HRA eye detail only on demand. Pair target: 70-120k high LOD,
   20-40k medium.
7. **Cranial bones and cutaway mechanics:** preserve bone identities and add
   clean non-destructive frontal/parietal cutaway states. Use the 580k skull only
   to bake close-up surface detail into the lighter semantic skull.
8. **Selected head/neck muscles:** extract the 20-object group as a 60-100k
   optional layer. It should support surface-to-deep orientation, not distract
   from the stroke flow.

### P2 — specialist anatomy mode

9. **Cranial nerves I-XII:** export separate semantic groups with a 40-80k
   visible LOD and lazy-load them. Have a neuroanatomist review exits,
   laterality and overlaps before publication.
10. **Scalp/face superficial vessels and labels:** add only after the outer skin
    registration is stable; use progressive reveal and local callouts rather
    than simultaneous full visibility.

## Registration and clinical QA gates

Before any new layer is called finished:

- Confirm metre scale, coordinate handedness, anterior/posterior orientation and
  `.l`/`.r` laterality in Blender and RealityKit.
- Register external skin, skull, brain and vessels from common landmarks; do not
  assume HRA, NIH Visible Human and Z-Anatomy source origins coincide.
- Check for skull/brain penetration, eye/orbit mismatch, arteries leaving the
  expected foramina, and sinuses sitting outside the cranial vault.
- Preserve object names and source IDs through USD/USDZ export.
- Keep each large layer independently loadable; do not ship the full skin,
  skull, brain, artery, vein, muscle and nerve set as one always-on entity.
- Validate every USDZ with Apple's USD/RealityKit tools and inspect transparent
  shells on-device because blend order can differ from Blender.
- Obtain clinician review for laterality, named-vessel continuity, clot location,
  access-path narrative, meninges presentation and the normal/occluded/restored
  flow sequence.
- Display an in-experience notice that the anatomy and flow are generic patient
  education, not individual treatment planning or a forecast of outcome.

## Recommended next acquisition/extraction order

1. **Completed:** the current HRA Skin, Male was downloaded from official NIH
   3D, preserved with license/hash records, and inspected in Blender 5.2. The
   next step is a separate non-destructive head crop and landmark registration;
   this audit did not build geometry.
2. Extract Z `Falx cerebri`, both `Tentorium cerebelli` objects, the exact
   dural-sinus group and the eight neck access arteries into separate source
   collections.
3. Extract the expanded head/neck vein group and produce cleaned centerline and
   lumen derivatives for flow animation.
4. Acquire HRA eyes only if the eye detail mode is approved; the current PBR
   contextual eyes are already sufficient for the main stroke story.
5. Decide whether shipping Z-derived assets under ShareAlike is acceptable. If
   not, start the direct BodyParts3D ID-based replacement before investing in
   final materials or animation on those meshes.
