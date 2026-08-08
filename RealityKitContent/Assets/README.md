# Stroke VisionOS asset catalog

This directory contains **65 unique, manifest-backed runtime USDZ assets**:

- **36 higher-detail v2 assets** across five manifests.
- **29 prototype-v1 assets** in one manifest.
- **180,427,924 bytes** of runtime USDZ payload.

The count refers only to independently loadable USDZ packages. Manifests,
preview renders, material maps, and documentation are supporting files and are
not counted as additional runtime assets. Composite assemblies are counted
because they are separately loadable packages, although they duplicate geometry
from their component layers.

The historical review-only `stroke_kit_asset_gallery.usdz` is deliberately not
included. It is an unmanifested composite of prototype geometry, not a 66th
independent asset.

GitHub does not permit a public fork to upload new LFS objects into its parent
repository's LFS store. Consequently, this cross-fork pull request stores the
USDZ packages as ordinary binary Git objects; every individual package is below
GitHub's 50 MiB warning threshold. A maintainer with upstream write access may
migrate them to LFS in a coordinated follow-up.

## Naming and layout

Runtime filenames use stable lowercase `snake_case` IDs. Higher-detail assets
use the `_v2` suffix; combined review files say `assembly`, `hero`, or `set`;
conceptual and educational files say so explicitly. The prototype filenames
remain unchanged because their manifest and existing viewer code reference
those exact IDs. Human-facing display names below provide readable labels
without breaking runtime references.

```text
Assets/
├── vision_pro_stroke_kit/
│   ├── asset_manifest.json
│   └── exports/usdz/                 # 29 prototype-v1 packages
└── vision_pro_stroke_kit_v2/
    ├── asset_manifest_v2.json
    ├── asset_manifest_head_details_v2.json
    ├── asset_manifest_cranial_vascular_v2.json
    ├── asset_manifest_bloodflow_v2.json
    ├── asset_manifest_devices_v2.json
    ├── exports/usdz/                 # 36 higher-detail packages
    ├── previews/                     # supporting renders
    └── textures/source/              # supporting material maps
```

All stages use metres and Y-up. The models are generic and non-patient-specific.
See [licences](../../docs/assets/LICENSES.md),
[provenance](../../docs/assets/PROVENANCE.md), and
[validation](../../docs/assets/VALIDATION.md) before redistribution or use.

## Higher-detail v2 assets (36)

### Core registered anatomy (7)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 1 | [brain_anatomy_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/brain_anatomy_realistic_v2.usdz) | **Realistic generic brain anatomy.** Cortex, cerebellum, and brainstem hero layer in a common metre-scale frame. Generic anatomy requiring specialist review. |
| 2 | [brain_deep_structures_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/brain_deep_structures_v2.usdz) | **Generic deep brain structures.** Separately loadable semantic deep-anatomy reveal for guided explanations. |
| 3 | [brain_ventricles_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/brain_ventricles_v2.usdz) | **Generic ventricular system.** Independently toggleable ventricular anatomy for spatial orientation. |
| 4 | [skull_semantic_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/skull_semantic_realistic_v2.usdz) | **Semantic Visible Human skull.** Named cranial and facial bones suitable for isolated inspection and cutaway teaching. |
| 5 | [cerebral_arteries_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/cerebral_arteries_realistic_v2.usdz) | **Generic cerebral arterial tree.** Major cerebral pathways registered to the brain frame; ShareAlike source terms apply. |
| 6 | [ischemic_mca_clot_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/ischemic_mca_clot_v2.usdz) | **Conceptual right-M1 ischemic clot.** A teaching marker for an occlusion state, not a measured lesion or patient finding. |
| 7 | [thrombectomy_registered_hero_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/thrombectomy_registered_hero_v2.usdz) | **Registered thrombectomy anatomy hero set.** Combined review assembly; load individual layers for patient-facing interactions and performance control. |

### Head layers and meningeal context (9)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 8 | [external_head_scalp_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/external_head_scalp_realistic_v2.usdz) | **Generic external head and scalp.** Closed HRA-derived head/upper-neck exterior with a project-created skin material. |
| 9 | [external_head_scalp_cutaway_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/external_head_scalp_cutaway_v2.usdz) | **External-head cutaway.** Smooth educational cranial viewing window for revealing deeper layers without stacked transparency. |
| 10 | [eyes_context_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/eyes_context_realistic_v2.usdz) | **Bilateral eye context.** Separately toggleable Visible Human eye structures for orientation; omitted from the default layered assembly. |
| 11 | [dura_mater_conceptual_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/dura_mater_conceptual_v2.usdz) | **Conceptual dura mater shell.** Thin brain-hull-derived teaching surface; not a measured meningeal thickness. |
| 12 | [dura_mater_cutaway_conceptual_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/dura_mater_cutaway_conceptual_v2.usdz) | **Conceptual dura cutaway.** Dura shell with a rounded viewing window coordinated with the head reveal. |
| 13 | [falx_cerebri_atlas_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/falx_cerebri_atlas_v2.usdz) | **Falx cerebri atlas layer.** Independently toggleable named partition derived from atlas geometry. |
| 14 | [tentorium_cerebelli_atlas_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/tentorium_cerebelli_atlas_v2.usdz) | **Bilateral tentoria atlas layer.** Left and right tentorium structures for explaining compartment relationships. |
| 15 | [meningeal_partitions_atlas_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/meningeal_partitions_atlas_v2.usdz) | **Combined meningeal partitions.** Falx plus bilateral tentoria in one registered review layer. |
| 16 | [layered_head_cutaway_registered_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/layered_head_cutaway_registered_v2.usdz) | **Registered layered-head cutaway.** Scalp cutaway, conceptual dura, partitions, and brain. Skull and eyes remain optional separate assets to avoid cross-source intersections. |

### Cranial vascular detail (7)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 17 | [dural_venous_sinuses_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/dural_venous_sinuses_realistic_v2.usdz) | **Dural venous sinuses.** Sixteen named sinus structures. Purple/blue is a display convention and does not represent actual blood colour or oxygenation. |
| 18 | [internal_jugular_veins_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/internal_jugular_veins_realistic_v2.usdz) | **Bilateral internal jugular veins.** Separately toggleable cranial venous-outflow context. |
| 19 | [dural_sinuses_jugulars_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/dural_sinuses_jugulars_realistic_v2.usdz) | **Sinus and jugular teaching layer.** Combined dural-sinus and bilateral internal-jugular review package. |
| 20 | [head_neck_veins_supplemental_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/head_neck_veins_supplemental_v2.usdz) | **Supplemental head and neck veins.** Thirty-eight additional facial, scalp, ophthalmic, vertebral, jugular, and neck structures. |
| 21 | [head_neck_veins_expanded_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/head_neck_veins_expanded_realistic_v2.usdz) | **Expanded venous layer.** Complete 56-structure venous selection for contextual review. |
| 22 | [neck_access_arteries_realistic_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/neck_access_arteries_realistic_v2.usdz) | **Carotid and vertebral neck-access arteries.** Eight named artery structures connecting neck access context with the cranial circulation. |
| 23 | [cranial_vascular_registered_assembly_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/cranial_vascular_registered_assembly_v2.usdz) | **Registered cranial vascular assembly.** Combined 56-structure veins and eight access arteries; intended for review rather than simultaneous default loading. |

### Cerebral blood-flow teaching assets (8)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 24 | [artery_wall_cutaway_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/artery_wall_cutaway_v2.usdz) | **Magnified layered artery-wall cutaway.** Opened three-layer wall with deliberately exaggerated thickness for readability. |
| 25 | [artery_interior_bloodflow_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/artery_interior_bloodflow_v2.usdz) | **Illustrative lumen, blood, cells, and flow cues.** Magnified RBCs, streamlines, and arrows; non-CFD and non-quantitative. |
| 26 | [artery_cutaway_complete_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/artery_cutaway_complete_v2.usdz) | **Complete artery cutaway.** Combined wall, lumen, cells, and directional teaching cues. |
| 27 | [circle_of_willis_flow_overlay_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/circle_of_willis_flow_overlay_v2.usdz) | **Conceptual Circle-of-Willis flow overlay.** Simplified major-pathway directions for narrative sequencing, not perfusion analysis. |
| 28 | [red_blood_cells_closeup_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/red_blood_cells_closeup_v2.usdz) | **Magnified biconcave red-blood-cell close-up.** Two-sided central depressions designed to read clearly at educational scale. |
| 29 | [microcirculation_arterial_venous_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/microcirculation_arterial_venous_v2.usdz) | **Arteriole-capillary-venule vignette.** Conceptual route-following cells and vessel transition for microcirculation teaching. |
| 30 | [cerebral_bloodflow_animation_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/cerebral_bloodflow_animation_v2.usdz) | **Baked cerebral-flow marker animation.** Four-second posterior-to-right-MCA transform sequence with 24 RealityKit animation resources; non-CFD. |
| 31 | [cerebral_bloodflow_teaching_set_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/cerebral_bloodflow_teaching_set_v2.usdz) | **Combined blood-flow teaching set.** Static cutaway, flow overlay, RBC close-up, and microcirculation review collection. |

### Generic thrombectomy-device concepts (5)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 32 | [guidewire_educational_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/guidewire_educational_v2.usdz) | **Generic educational guidewire.** Metallic segment with curved distal tip and marker; unbranded and not dimensioned for device selection. |
| 33 | [microcatheter_educational_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/microcatheter_educational_v2.usdz) | **Generic educational microcatheter.** Hollow body, shaped tip, lumen, transition, and marker band. |
| 34 | [aspiration_catheter_educational_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/aspiration_catheter_educational_v2.usdz) | **Generic educational aspiration catheter.** Hollow large-bore concept with reinforcement and marker bands. |
| 35 | [stent_retriever_educational_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/stent_retriever_educational_v2.usdz) | **Generic educational stent retriever.** Deployed lattice, crowns, pusher, and markers; not a manufacturer-specific device. |
| 36 | [thrombectomy_device_set_educational_v2.usdz](vision_pro_stroke_kit_v2/exports/usdz/thrombectomy_device_set_educational_v2.usdz) | **Four-device comparison set.** Guidewire, microcatheter, aspiration catheter, and stent-retriever concepts arranged for review, not as a registered procedure configuration. |

## Prototype-v1 assets (29)

These assets are intentionally retained for sequencing, interaction, and
fallback testing. They are lower-detail prototypes and should not be presented
as the preferred patient-facing visual layer when a v2 equivalent exists.

### Shared anatomy (4)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 37 | [head_skin_generic.usdz](vision_pro_stroke_kit/exports/usdz/head_skin_generic.usdz) | **Generic head and scalp.** Neutral, non-identifying low-poly outer-head layer. |
| 38 | [skull_cranium_generic.usdz](vision_pro_stroke_kit/exports/usdz/skull_cranium_generic.usdz) | **Generic skull and cranium.** Simplified cranial shell and landmarks. |
| 39 | [brain_structures_generic.usdz](vision_pro_stroke_kit/exports/usdz/brain_structures_generic.usdz) | **Generic brain structures.** Simplified hemispheres, cerebellum, and brainstem. |
| 40 | [cerebral_arteries_generic.usdz](vision_pro_stroke_kit/exports/usdz/cerebral_arteries_generic.usdz) | **Generic cerebral arteries.** Simplified Circle of Willis and principal branches. |

### Pathology concepts (3)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 41 | [ischemic_lvo_clot.usdz](vision_pro_stroke_kit/exports/usdz/ischemic_lvo_clot.usdz) | **Ischemic large-vessel-occlusion clot.** Conceptual intraluminal obstruction marker. |
| 42 | [ich_hematoma.usdz](vision_pro_stroke_kit/exports/usdz/ich_hematoma.usdz) | **Intracerebral haemorrhage collection.** Conceptual escaped-blood volume; not a measured haematoma. |
| 43 | [edema_swelling.usdz](vision_pro_stroke_kit/exports/usdz/edema_swelling.usdz) | **Conceptual oedema and swelling.** Simplified pressure/swelling state inside the skull. |

### Procedure-room context (5)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 44 | [patient_supine_generic.usdz](vision_pro_stroke_kit/exports/usdz/patient_supine_generic.usdz) | **Generic supine patient.** Neutral silhouette and drape without identifying features. |
| 45 | [angiography_operating_table.usdz](vision_pro_stroke_kit/exports/usdz/angiography_operating_table.usdz) | **Angiography/operating table.** Simplified reusable procedure-room table. |
| 46 | [vital_sign_monitor.usdz](vision_pro_stroke_kit/exports/usdz/vital_sign_monitor.usdz) | **Vital-sign monitor.** Stylised procedure monitor without quantitative patient data. |
| 47 | [iv_pole_and_bag.usdz](vision_pro_stroke_kit/exports/usdz/iv_pole_and_bag.usdz) | **IV pole and bag.** Generic room-context prop. |
| 48 | [clinical_team_generic.usdz](vision_pro_stroke_kit/exports/usdz/clinical_team_generic.usdz) | **Generic clinical team.** Two neutral staff silhouettes for scale and role context. |

### Mechanical-thrombectomy sequence (7)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 49 | [angiography_c_arm.usdz](vision_pro_stroke_kit/exports/usdz/angiography_c_arm.usdz) | **Angiography C-arm.** Simplified imaging gantry for room orientation. |
| 50 | [arterial_access_site.usdz](vision_pro_stroke_kit/exports/usdz/arterial_access_site.usdz) | **Arterial access site.** Conceptual introducer sheath and guidewire entering an artery. |
| 51 | [catheter_body_to_brain_route.usdz](vision_pro_stroke_kit/exports/usdz/catheter_body_to_brain_route.usdz) | **Body-to-brain catheter route.** Conceptual intravascular path for explaining access sequence. |
| 52 | [guidewire_microcatheter_set.usdz](vision_pro_stroke_kit/exports/usdz/guidewire_microcatheter_set.usdz) | **Guidewire and microcatheter set.** Separated components suitable for simple transform animation. |
| 53 | [stent_retriever.usdz](vision_pro_stroke_kit/exports/usdz/stent_retriever.usdz) | **Prototype stent retriever.** Stylised retrieval cage with captured-clot cue. |
| 54 | [aspiration_catheter.usdz](vision_pro_stroke_kit/exports/usdz/aspiration_catheter.usdz) | **Prototype aspiration catheter.** Simplified alternative treatment-path concept. |
| 55 | [angiography_contrast_flow.usdz](vision_pro_stroke_kit/exports/usdz/angiography_contrast_flow.usdz) | **Angiography contrast-flow overlay.** Conceptual before/after vessel-filling comparison. |

### Open-cranial treatment concepts (6)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 56 | [scalp_incision_flap.usdz](vision_pro_stroke_kit/exports/usdz/scalp_incision_flap.usdz) | **Scalp incision/flap concept.** Non-graphic layered reveal. Do not combine with a thrombectomy-only narrative. |
| 57 | [craniotomy_bone_flap.usdz](vision_pro_stroke_kit/exports/usdz/craniotomy_bone_flap.usdz) | **Craniotomy bone flap.** Removable teaching object for an open-cranial pathway. |
| 58 | [cranial_drill_generic.usdz](vision_pro_stroke_kit/exports/usdz/cranial_drill_generic.usdz) | **Generic cranial drill.** Stylised tool requiring procedure-specific specialist review. |
| 59 | [suction_and_forceps.usdz](vision_pro_stroke_kit/exports/usdz/suction_and_forceps.usdz) | **Suction and forceps.** Separated open-surgery instrument concepts. |
| 60 | [scalp_closure_sutures.usdz](vision_pro_stroke_kit/exports/usdz/scalp_closure_sutures.usdz) | **Scalp closure and sutures.** Non-graphic closed-incision state. |
| 61 | [dural_patch.usdz](vision_pro_stroke_kit/exports/usdz/dural_patch.usdz) | **Dural patch concept.** Configurable dural-expansion teaching object. |

### Haemorrhage-care concepts (2)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 62 | [minimally_invasive_evacuator_port.usdz](vision_pro_stroke_kit/exports/usdz/minimally_invasive_evacuator_port.usdz) | **Minimally invasive evacuator port.** Conceptual trajectory/evacuation port requiring specialist review. |
| 63 | [optional_evd_system.usdz](vision_pro_stroke_kit/exports/usdz/optional_evd_system.usdz) | **Optional external ventricular drain system.** Conceptual catheter and drainage chamber; not a default step. |

### Recovery and sequencing (2)

| # | Runtime file | Description and runtime note |
|---:|---|---|
| 64 | [postoperative_head_dressing.usdz](vision_pro_stroke_kit/exports/usdz/postoperative_head_dressing.usdz) | **Postoperative head dressing.** Generic bandage/dressing recovery state. |
| 65 | [spatial_step_markers.usdz](vision_pro_stroke_kit/exports/usdz/spatial_step_markers.usdz) | **Spatial step markers.** Eight numbered markers and arrows in one wide entity for guided sequencing. |

## Manifests

- [Prototype-v1 manifest](vision_pro_stroke_kit/asset_manifest.json)
- [Core realistic-v2 manifest](vision_pro_stroke_kit_v2/asset_manifest_v2.json)
- [Head-detail-v2 manifest](vision_pro_stroke_kit_v2/asset_manifest_head_details_v2.json)
- [Cranial-vascular-v2 manifest](vision_pro_stroke_kit_v2/asset_manifest_cranial_vascular_v2.json)
- [Blood-flow-v2 manifest](vision_pro_stroke_kit_v2/asset_manifest_bloodflow_v2.json)
- [Thrombectomy-device-v2 manifest](vision_pro_stroke_kit_v2/asset_manifest_devices_v2.json)

Manifest `usdz` paths are relative to the corresponding kit directory. Keep
the package layout intact or rewrite paths intentionally in the app's catalog
loader. The retained `usdc` fields describe upstream working/interchange
outputs; those duplicate working files are intentionally not committed in this
runtime-only asset pull request. Load the packaged `usdz` path.

## RealityKit loading guidance

Copy selected assets into the app bundle or an `.rkassets` package, resolve the
file URL from the matching manifest record, and load it asynchronously:

```swift
import RealityKit

let entity = try await Entity(contentsOf: assetURL)
entity.name = manifestRecord.id
```

Do not apply another axis correction: the exported USD stages already use Y-up
and metres. Center inspection views using visual bounds. Load combined hero
assemblies lazily, and use the separate opaque layers for reveal/toggle flows.

The blood-flow animation is a baked illustrative transform animation. Discover
its imported resource through `availableAnimations`, play it explicitly, and
offer a replay action. It is not a fluid solver, CFD output, perfusion estimate,
or patient measurement.

## Patient-use boundary

These assets must not be used for diagnosis, triage, treatment selection,
surgical planning, navigation, device sizing, haemodynamic calculation, or
outcome prediction. A specialist must review the selected anatomy, colours,
scale, labels, procedure sequence, and patient-facing language before use.
