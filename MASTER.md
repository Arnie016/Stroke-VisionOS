# MASTER — scene assembly, behavior, and Houdini handoff

This document is the implementation contract for assembling the repository's
108 release-catalog runtime assets into one coherent Apple Vision Pro
educational experience. The full source build has 110 unique package records;
two inner-ear-containing records are licence-held and not present as runtime
binaries in this publishing tree.
It is written for a coding agent, technical artist, Houdini artist, or
RealityKit engineer. The individual asset descriptions live in the
[asset catalog](RealityKitContent/Assets/README.md); this file defines how the
assets relate, which ones may coexist, what owns runtime behavior, and what
must be validated before a patient-facing pilot.

> [!CAUTION]
> This is a generic educational visualization, not a medical device, digital
> twin, fluid-dynamics model, surgical rehearsal, or representation of a
> particular patient. No animation, collision, scale cue, or device motion may
> be described as measured physiology or as predicting treatment or outcome.

## 1. Authority and sources of truth

When files disagree, use this order:

1. The nine release JSON manifests are authoritative for asset IDs, package paths,
   units, up axis, provenance notes, and prohibited combinations.
2. This file is authoritative for assembly, state, interaction, and pathway
   rules.
3. The [asset catalog](RealityKitContent/Assets/README.md) is authoritative for
   the human-readable inventory.
4. [Licensing](docs/assets/LICENSES.md),
   [provenance](docs/assets/PROVENANCE.md), and
   [validation](docs/assets/VALIDATION.md) are release gates, not optional
   background reading.
5. The [clinical review checklist](docs/assets/source-notes/V2_CLINICAL_REVIEW_CHECKLIST.md)
   must be signed for the exact build before any patient-facing pilot.
6. The [v3 detail catalog](docs/assets/INTRACRANIAL_ASSET_CATALOG_V3.md)
   preserves the 45 new build records one by one, including the two held records
   that are intentionally absent from the release manifest and binary tree.

The word **must** below means a release-blocking requirement. **Should** means
the default implementation unless a reviewed design decision says otherwise.

## 2. Coordinate, scale, and registration contract

- Every shipped stage is authored **Y-up** with `metersPerUnit = 1`.
- The working USD/RealityKit convention is right-handed: +X right, +Y up, and
  -Z forward. This still does not establish anatomical laterality without
  landmark review.
- Preserve the imported asset transform. Do **not** add another Blender-to-USD
  `-90°` correction in Houdini, Reality Composer Pro, or RealityKit.
- Put user placement, orbit, pan, and zoom on an outer
  `ExperiencePlacementRoot`. Never overwrite the authored transforms inside a
  model to implement view controls.
- The realistic-v2 registered anatomy, head layers, cerebral arteries, flow
  overlay, clot, and cranial vasculature are intended to share the authored
  head frame where their manifest says `registered`.
- The semantic skull and eye context come from different atlas sources. Their
  alignment is approximate. Keep them separately selectable and do not treat
  their surfaces as millimetre-accurate contact boundaries.
- The artery-wall cutaway, RBC close-up, and microcirculation vignette are
  **magnified, scale-separated teaching views**. They belong in a separate
  vignette root and must never be overlaid on the head as if their relative
  dimensions were anatomical. V2 device inspection assets use a separate,
  non-registered domain but default to 1:1 scale; label them as magnified only
  when an inspection view actually changes their root scale.
- The neural-detail and non-held cranial-detail v3 packages are macroscopic
  generic-atlas layers in their recorded project registration frames. Preserve
  their authored transforms and semantic children; never normalize each package
  independently.
- Every intracranial-micro-v3 package uses
  `microscopic_conceptual_separate`. Its metre dimensions describe a
  presentation stage, not biological dimensions. It must be placed under
  `MicroScaleRoot`, never under `HeadRegisteredRoot`, and must keep a visible
  magnification/conceptual/non-patient warning for its entire display time.
- The prototype-v1 room and body assets are staging aids, not a verified
  registration frame for v2 head anatomy. Align them visually under a separate
  parent and record the chosen transform.
- Never mirror an anatomical root to obtain the other side. Laterality is
  semantic and must be reviewed. The current ischemic v2 teaching marker is a
  conceptual **right-M1** occlusion.
- Do not infer anatomical left/right from a raw X coordinate until a clinician
  has verified the imported view and an explicit project-level laterality
  mapping has been recorded.

## 3. Canonical scene graph

Use one state owner and this logical hierarchy. Exact engine class names may
change, but ownership and separation must not.

```mermaid
flowchart TD
    R["StrokeExperienceRoot"] --> P["ExperiencePlacementRoot"]
    R --> UI["AppUIRoot"]
    P --> E["EnvironmentRoot"]
    P --> PT["PatientContextRoot"]
    P --> G["SpatialGuidanceRoot"]
    PT --> H["HeadRegisteredRoot"]
    PT --> LH["LegacyHeadRoot"]
    H --> X["ExteriorRoot"]
    H --> S["SkullRoot"]
    H --> M["MeningesRoot"]
    H --> B["BrainRoot"]
    B --> NS["NeuralSemanticRoot"]
    H --> A["ArterialRoot"]
    H --> V["VenousRoot"]
    H --> L["PathologyRoot"]
    H --> CN["CranialNerveRoot"]
    H --> OR["OrbitalSupportRoot"]
    H --> EN["EndocrineRoot"]
    H --> AW["AirwayRoot"]
    H --> MU["MuscleRoot"]
    LH --> O["OpenCranialRoot"]
    PT --> PR["ProcedureToolRoot"]
    P --> T["TeachingVignetteRoot"]
    P --> DI["DeviceInspectionRoot"]
    T --> VW["VesselWallVignetteRoot"]
    T --> MC["MicrocirculationVignetteRoot"]
    T --> RBC["RBCCloseupRoot"]
    T --> MS["MicroScaleRoot"]
```

Recommended engine names and responsibilities:

| Root | Responsibility | Transform rule |
|---|---|---|
| `StrokeExperienceRoot` | Lifecycle and lesson-state owner | Identity; never directly manipulated by gestures |
| `ExperiencePlacementRoot` | World placement, global orbit, zoom, reset | Only user-controlled spatial transform |
| `EnvironmentRoot` | Table, C-arm, monitor, IV pole, staff | World-scale; static or kinematic only |
| `PatientContextRoot` | Supine patient and all patient-relative content | One reviewed visual alignment to room context |
| `HeadRegisteredRoot` | All compatible v2 head-space content | Preserve authored child transforms |
| `LegacyHeadRoot` | Prototype-v1 head/pathology staging | Separate manual alignment; never assumed registered to v2 |
| `ExteriorRoot` | Intact or cutaway scalp variant | Exactly one exterior variant active |
| `SkullRoot` | Optional semantic skull | Off by default in the combined cutaway |
| `MeningesRoot` | Dura and falx/tentorium variants | Use opaque toggles/cutaways |
| `BrainRoot` | Cortex/brain hero, deep structures, ventricles | Components may be progressively revealed |
| `NeuralSemanticRoot` | v3 cortical parcels, cerebellum/brainstem, deep nuclei, ventricles, white matter, and pathways | Registered macroscopic atlas domain; use semantic variants/cutaways and hierarchy exclusions |
| `ArterialRoot` | Cerebral and neck-access arteries | Static anatomy plus optional illustrative overlay |
| `VenousRoot` | Sinuses, jugulars, supplemental veins | Choose components or one aggregate, never both |
| `PathologyRoot` | Registered v2 ischemic clot and future reviewed registered pathology | Pathway-exclusive state |
| `CranialNerveRoot` | Non-held v3 cranial-nerve groups or their nerve-only review assembly | Static generic atlas layers; components or assembly, never both |
| `OrbitalSupportRoot` | Extraocular-muscle support around the separate eye asset | Static; no ocular-motor simulation |
| `EndocrineRoot` | Source-backed anterior/posterior pituitary context | Static; no hormone or disease behavior |
| `AirwayRoot` | Nasal/paranasal and pharyngeal orientation context | Static; no airflow, swallowing, aspiration, or drainage solver |
| `MuscleRoot` | Mastication and selected head/neck orientation muscles | Static; no contraction, force, or tissue deformation |
| `ProcedureToolRoot` | Authored in-patient guidewire/catheter/tool poses | Kinematic narrative motion only; must have a reviewed placement |
| `DeviceInspectionRoot` | Detached v2 device inspection/comparison tray | Separate registration domain; 1:1 default, labelled if scaled; not a vessel path |
| `OpenCranialRoot` | Flap, drill, patch, evacuator, closure | Disabled for the thrombectomy pathway |
| `TeachingVignetteRoot` | Magnified, scale-separated explanations | Place beside the patient with a visible scale label |
| `MicroScaleRoot` | v3 conceptual BBB, blood, thrombus, neural-cell, myelin, synapse, CSF-interface, and ischemic-zone vignettes | Separate presentation stage; never registered to or nested inside the head |
| `SpatialGuidanceRoot` | World-space step markers and arrows | Inherits placement/orbit/scale with the experience |
| `AppUIRoot` | Captions, replay, warnings, non-spatial controls | App-owned UI; not transformed with world content |

## 4. Composition rules

### 4.1 Components versus convenience assemblies

Several packages repeat geometry from their component files. A convenience
assembly is a **replacement view**, not another layer to stack on top:

| Convenience asset | Replaces while active |
|---|---|
| `thrombectomy_registered_hero_v2.usdz` | Brain anatomy, deep structures, ventricles, semantic skull, embedded eyes, cerebral arteries, and right-M1 clot |
| `layered_head_cutaway_registered_v2.usdz` | Separate scalp cutaway, conceptual dura cutaway, meningeal partitions, and brain |
| `meningeal_partitions_atlas_v2.usdz` | Separate falx and tentorium packages |
| `dural_sinuses_jugulars_realistic_v2.usdz` | Separate dural sinuses and internal jugular packages |
| `head_neck_veins_expanded_realistic_v2.usdz` | Core sinuses/jugulars plus supplemental veins |
| `cranial_vascular_registered_assembly_v2.usdz` | Expanded venous layer plus neck-access arteries |
| `artery_cutaway_complete_v2.usdz` | Separate artery-wall and interior-flow packages |
| `cerebral_bloodflow_teaching_set_v2.usdz` | Complete cutaway, Circle-of-Willis overlay, RBC close-up, and microcirculation in a rearranged static comparison layout; it excludes the animation |
| `thrombectomy_device_set_educational_v2.usdz` | The four v2 device close-ups in a comparison layout |
| `neural_detail_registered_review_assembly_v3.usdz` | All 14 v3 neural-detail packages; while focused, also replace the opaque v2 brain/deep/ventricle layers that obscure or duplicate its source-backed review view |
| `cranial_nerves_complete_assembly_v3.usdz` | The nine independent cranial-nerve group packages |
| `intracranial_micro_teaching_set_v3.usdz` | All 11 independent scale-separated micro vignettes |

`cranial_support_registered_assembly_v3` would contain all 16 cranial
components and transitively overlap the nerve assembly, but it is a held
source-build record—not a release asset. A loader must fail closed if that ID
appears until its hold is formally cleared and a new release manifest is
reviewed.

Loading an aggregate and its parts together causes duplicate geometry,
z-fighting, unnecessary memory use, and ambiguous state ownership. Enforce
mutual exclusion in code rather than relying on an artist to remember it.

Exclusion must be **transitive**. Maintain a recursively expanded
`containedLeafAssetIDs` set for every component and aggregate. Before enabling
an asset, reject the transition if its leaf set intersects the leaf set of any
active asset. For example, the hero and layered-head aggregates both contain
the brain even though neither is the other's direct component; the vascular
assembly overlaps the expanded-veins aggregate; and the teaching set overlaps
the complete cutaway. All three pairs must be rejected.

Apply the same recursive rule to v3. The neural review assembly excludes
N01–N14; the cranial-nerve assembly excludes C01–C09; the micro teaching set
excludes M01–M11. Also enforce semantic-overlap groups that are not literal
package containment: broad `major_white_matter_regions_v3` and detailed
`commissural_sensory_pathways_v3` must not be presented as disjoint tissue
volumes, `ventricular_spaces_v3` replaces `brain_ventricles_v2` in a focused
view, and v3 cortical/deep layers require hiding or cutting any opaque v2 brain
surface that would duplicate or obscure them.

### 4.2 Reveal policy

- Use opaque layer swaps, cutaway geometry, and visibility toggles. Do not stack
  transparent skin, skull, dura, vessels, and brain.
- `external_head_scalp_realistic_v2` is the intact exterior. Swap it for
  `external_head_scalp_cutaway_v2` to reveal internal anatomy.
- The opaque intact scalp will hide the skull and brain; this is correct.
- Eyes are optional orientation context and are off by default in the layered
  cutaway.
- The semantic skull is an isolated inspection layer unless its approximate
  cross-source fit has been accepted for a specific shot.
- A cutaway window is an educational reveal, not a claimed incision,
  craniotomy, operative corridor, or planned opening.
- Neural detail follows an explicit drill-down, not an opacity pile:
  macroscopic brain context → one cortical/deep/ventricular/pathway focus →
  semantic child highlight. A transition to cell-scale teaching opens a
  separate `MicroScaleRoot` stage and never zooms the head geometry until it
  appears to become a literal cell model.

### 4.3 Pathway exclusivity

The experience has anatomy-only mode plus two distinct pathology pathways.
Within the haemorrhage pathway, management is an explicit clinician-approved
branch; open surgery is not the automatic next step. Never make these branches
appear to be successive steps of one operation.

```mermaid
stateDiagram-v2
    [*] --> Orientation
    Orientation --> HeadReveal
    HeadReveal --> AnatomyOnly: anatomy-only mode
    HeadReveal --> IschemicBaseline: choose ischemic pathway
    IschemicBaseline --> RightM1Occlusion
    RightM1Occlusion --> ArterialAccess
    ArterialAccess --> DeviceNavigation
    DeviceNavigation --> ClotEngagement
    ClotEngagement --> RetrievalOrAspiration
    RetrievalOrAspiration --> RestoredFlow
    RestoredFlow --> Recovery

    HeadReveal --> HemorrhageIntro: choose ICH pathway
    HemorrhageIntro --> ICHManagementGate
    ICHManagementGate --> MedicalMonitoring
    ICHManagementGate --> MinimallyInvasiveEvacuation
    ICHManagementGate --> OpenCraniotomyEvacuation
    ICHManagementGate --> DecompressiveCraniectomy
    ICHManagementGate --> EVDAdjunct: conditional
    MedicalMonitoring --> Recovery
    MinimallyInvasiveEvacuation --> ProcedureSpecificRecovery
    OpenCraniotomyEvacuation --> ProcedureSpecificRecovery
    DecompressiveCraniectomy --> ProcedureSpecificRecovery
    EVDAdjunct --> ProcedureSpecificRecovery
```

The app must require an explicit pathway choice before enabling intervention
assets. Changing pathway performs a full state reset.

## 5. Master relationship map — 110 build records / 108 release assets

The `Parent` column is the canonical scene slot. `Relationship / rule` tells an
agent how each package fits into the constructed experience. Records 1–65 are
the original release baseline; records 66–110 are the v3 build expansion.
Records 92 and 98 are held audit records with no published binary, leaving 108
release assets. Asset IDs, not sequence numbers, are the runtime keys.

### 5.1 Realistic v2 core anatomy

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 1 | `brain_anatomy_realistic_v2` | `BrainRoot` | Preferred brain context. Base for registered arterial, clot, meningeal, and vascular layers. Keep static. |
| 2 | `brain_deep_structures_v2` | `BrainRoot/DeepStructures` | Optional progressive reveal inside the main brain; do not imply every structure is visible through opaque cortex. |
| 3 | `brain_ventricles_v2` | `BrainRoot/Ventricles` | Optional internal orientation layer; reveal after hiding/cutting the obscuring brain surface. |
| 4 | `skull_semantic_realistic_v2` | `SkullRoot` | Optional named-bone inspection. Cross-source registration is approximate; keep off in the default cutaway assembly. |
| 5 | `cerebral_arteries_realistic_v2` | `ArterialRoot/Cerebral` | Preferred static cerebral arterial anatomy; spatial host for the right-M1 clot and conceptual flow overlay. |
| 6 | `ischemic_mca_clot_v2` | `PathologyRoot/Ischemic` | Conceptual right-M1 occlusion marker. Visible only in ischemic occlusion/engagement states; never used as a lesion measurement. |
| 7 | `thrombectomy_registered_hero_v2` | `HeadRegisteredRoot/ReviewVariant` | Heavy combined review asset. Use for QA/demo stills or a lazy-loaded overview; replace its duplicated individual layers while active. |

### 5.2 Head exterior and meningeal layers

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 8 | `external_head_scalp_realistic_v2` | `ExteriorRoot/Intact` | Default orientation exterior. Mutually exclusive with the cutaway scalp. |
| 9 | `external_head_scalp_cutaway_v2` | `ExteriorRoot/Cutaway` | Reveal variant for internal anatomy. The window is illustrative, not an operative opening. |
| 10 | `eyes_context_realistic_v2` | `HeadRegisteredRoot/Eyes` | Optional facial orientation cue. Off by default and never treated as precisely registered orbital anatomy. |
| 11 | `dura_mater_conceptual_v2` | `MeningesRoot/DuraIntact` | Conceptual opaque cerebral-hull shell. Mutually exclusive with the dura cutaway; thickness is non-physiologic. |
| 12 | `dura_mater_cutaway_conceptual_v2` | `MeningesRoot/DuraCutaway` | Reveal variant aligned with the educational head window. Not a planned dural opening. |
| 13 | `falx_cerebri_atlas_v2` | `MeningesRoot/Partitions/Falx` | Individual falx layer; hide when the combined partitions asset is active. |
| 14 | `tentorium_cerebelli_atlas_v2` | `MeningesRoot/Partitions/Tentorium` | Bilateral tentoria layer; hide when the combined partitions asset is active. |
| 15 | `meningeal_partitions_atlas_v2` | `MeningesRoot/Partitions/Combined` | Combined falx and tentoria review variant replacing assets 13–14. |
| 16 | `layered_head_cutaway_registered_v2` | `HeadRegisteredRoot/LayeredReviewVariant` | Preferred quick layered-head overview. Replaces separate scalp cutaway, dura cutaway, partitions, and main brain while active; skull/eyes remain separate. |

### 5.3 Cranial and neck vasculature

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 17 | `dural_venous_sinuses_realistic_v2` | `VenousRoot/Core/Sinuses` | Individual 16-structure sinus layer. Purple/blue is a UI convention, not blood colour or oxygenation. |
| 18 | `internal_jugular_veins_realistic_v2` | `VenousRoot/Core/Jugulars` | Bilateral outflow context; may pair with asset 17 unless their combined package is used. |
| 19 | `dural_sinuses_jugulars_realistic_v2` | `VenousRoot/Core/Combined` | Replaces assets 17–18 for a single progressive layer. |
| 20 | `head_neck_veins_supplemental_v2` | `VenousRoot/Supplemental` | Adds facial, scalp, ophthalmic, vertebral, jugular, and neck context to assets 17–19. Excludes the core group. |
| 21 | `head_neck_veins_expanded_realistic_v2` | `VenousRoot/Expanded` | Complete 56-structure venous variant replacing assets 17–20. |
| 22 | `neck_access_arteries_realistic_v2` | `ArterialRoot/NeckAccess` | Carotid/vertebral access context. May pair with cerebral arteries after reviewed registration; do not imply a patient-specific catheter route. |
| 23 | `cranial_vascular_registered_assembly_v2` | `HeadRegisteredRoot/VascularReviewVariant` | Combined expanded veins and neck-access arteries. Replaces assets 17–22 while active; intended for review, not the default patient scene. |

### 5.4 Blood-flow teaching views

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 24 | `artery_wall_cutaway_v2` | `TeachingVignetteRoot/VesselWall/Wall` | Magnified wall-only reveal. Pair with asset 25 or replace both with asset 26. |
| 25 | `artery_interior_bloodflow_v2` | `TeachingVignetteRoot/VesselWall/Interior` | Magnified lumen, cells, arrows, and streamlines. Illustrative only; may be added after asset 24. |
| 26 | `artery_cutaway_complete_v2` | `TeachingVignetteRoot/VesselWall/Combined` | Replaces assets 24–25 for a combined cutaway. |
| 27 | `circle_of_willis_flow_overlay_v2` | `ArterialRoot/FlowOverlay` | Conceptual directional overlay in the v2 head frame. It may accompany cerebral arteries but must not be called perfusion or CFD. |
| 28 | `red_blood_cells_closeup_v2` | `TeachingVignetteRoot/RBCCloseup` | Magnified cell-form vignette. Never compare its size directly with head or artery geometry. |
| 29 | `microcirculation_arterial_venous_v2` | `TeachingVignetteRoot/Microcirculation` | Scale-separated arteriole–capillary–venule explanation. It is not a continuation of the registered cranial vessel mesh. |
| 30 | `cerebral_bloodflow_animation_v2` | `ArterialRoot/AnimatedFlowCue` | Four-second baked transform cue with 24 imported animation resources. Explicitly play/replay; no physical time or velocity meaning. |
| 31 | `cerebral_bloodflow_teaching_set_v2` | `TeachingVignetteRoot/ReviewVariant` | Static comparison set replacing the relevant individual teaching vignettes while active. Keep outside the anatomical-scale head root. |

### 5.5 Generic v2 thrombectomy-device concepts

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 32 | `guidewire_educational_v2` | `DeviceInspectionRoot/Guidewire` | Generic detached close-up. It is not registered to the body or vessel. A procedural instance requires a separately authored path/pose layer. No sizing, force, or tip-behaviour claim. |
| 33 | `microcatheter_educational_v2` | `DeviceInspectionRoot/Microcatheter` | Detached delivery-catheter concept. It is not registered to the patient; do not infer wall contact from overlap. |
| 34 | `aspiration_catheter_educational_v2` | `DeviceInspectionRoot/AspirationCatheter` | Detached aspiration concept. Its lumen and construction are illustrative, not a product specification or registered pathway. |
| 35 | `stent_retriever_educational_v2` | `DeviceInspectionRoot/StentRetriever` | Detached conceptual deployed lattice. Use only in the ischemic arterial lesson and never for ICH evacuation. |
| 36 | `thrombectomy_device_set_educational_v2` | `DeviceInspectionRoot/Comparison` | Four-device comparison layout replacing assets 32–35 as close-ups. It is not registered inside the patient or vessel. |

### 5.6 Prototype-v1 anatomy and pathology

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 37 | `head_skin_generic` | `LegacyHeadRoot/Exterior` | Low-poly fallback only. Prefer v2 intact/cutaway exterior for patient-facing visuals. Do not overlay it on the v2 head frame. |
| 38 | `skull_cranium_generic` | `LegacyHeadRoot/Skull` | Low-poly sequencing fallback; do not stack with the v2 skull. |
| 39 | `brain_structures_generic` | `LegacyHeadRoot/Brain` | Low-poly brain fallback; do not combine with v2 brain as if complementary anatomy. |
| 40 | `cerebral_arteries_generic` | `LegacyHeadRoot/Arterial` | Low-poly arterial fallback; replace with v2 arteries where possible. |
| 41 | `ischemic_lvo_clot` | `LegacyHeadRoot/Pathology/Ischemic` | Prototype obstruction cue. Use instead of, not in addition to, the v2 right-M1 clot. |
| 42 | `ich_hematoma` | `LegacyHeadRoot/Pathology/Hemorrhage` | Conceptual escaped-blood volume for the separate haemorrhage pathway. Never remove it with a stent retriever. |
| 43 | `edema_swelling` | `LegacyHeadRoot/Pathology/Edema` | Conceptual swelling state. It may accompany a reviewed haemorrhage/decompression explanation, not a quantitative pressure simulation. |

### 5.7 Prototype-v1 room and patient context

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 44 | `patient_supine_generic` | `PatientContextRoot/Body` | Neutral body/context shell. Visually align the head root under it; do not claim anatomical registration. |
| 45 | `angiography_operating_table` | `EnvironmentRoot/Table` | Static room anchor; parent the patient context to a reviewed table transform if helpful. |
| 46 | `vital_sign_monitor` | `EnvironmentRoot/Monitor` | Static contextual prop. Never show fabricated patient measurements as real data. |
| 47 | `iv_pole_and_bag` | `EnvironmentRoot/IV` | Static contextual prop; no medication, dose, or infusion claim. |
| 48 | `clinical_team_generic` | `EnvironmentRoot/Staff` | Static/kinematic scale context. Avoid implying these silhouettes represent the actual treating team. |

### 5.8 Prototype-v1 mechanical-thrombectomy sequence

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 49 | `angiography_c_arm` | `EnvironmentRoot/Imaging` | Static/kinematic room context. A pose change is illustrative, not a collision-checked equipment motion. |
| 50 | `arterial_access_site` | `PatientContextRoot/AccessCue` | Conceptual entry-point vignette for the ischemic endovascular path; specialist must review terminology and position. |
| 51 | `catheter_body_to_brain_route` | `PatientContextRoot/RouteCue` | Conceptual route joining body context to head context. Do not call it a patient-specific vascular path. |
| 52 | `guidewire_microcatheter_set` | `ProcedureToolRoot/PrototypeDelivery` | Separated low-poly components suited to an authored transform sequence. Prefer v2 devices for detached close-up appearance. |
| 53 | `stent_retriever` | `ProcedureToolRoot/PrototypeRetriever` | Prototype captured-clot cue. Alternative to the v2 close-up, never combined with ICH. |
| 54 | `aspiration_catheter` | `ProcedureToolRoot/PrototypeAspiration` | Prototype alternative route. Do not show aspiration and retrieval as simultaneous unless narration explicitly compares techniques. |
| 55 | `angiography_contrast_flow` | `LegacyHeadRoot/Arterial/ContrastCue` | Conceptual before/after filling overlay for the prototype arterial frame. It is not an angiogram, dose, timing curve, or reperfusion grade. |

### 5.9 Prototype-v1 open-cranial and haemorrhage concepts

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 56 | `scalp_incision_flap` | `OpenCranialRoot/ScalpFlap` | Non-graphic open-cranial reveal. Prohibited in a thrombectomy-only sequence. |
| 57 | `craniotomy_bone_flap` | `OpenCranialRoot/BoneFlap` | Kinematic removable bone concept. If the state is labelled decompressive craniectomy, do not replace it at the end. |
| 58 | `cranial_drill_generic` | `OpenCranialRoot/Drill` | Stylised tool shown only in the reviewed open-cranial pathway; no cutting-force or trajectory claim. |
| 59 | `suction_and_forceps` | `OpenCranialRoot/Instruments` | Separated open-surgery concepts. Do not depict interaction with anatomy as validated tissue mechanics. |
| 60 | `scalp_closure_sutures` | `OpenCranialRoot/Closure` | Non-graphic closed-incision state for an applicable closure narrative. |
| 61 | `dural_patch` | `OpenCranialRoot/DuralPatch` | Configurable expansion/repair teaching object; only for a clinician-reviewed applicable procedure. |
| 62 | `minimally_invasive_evacuator_port` | `OpenCranialRoot/Evacuator` | Conceptual haemorrhage-evacuation trajectory. Keep distinct from arterial thrombectomy devices. |
| 63 | `optional_evd_system` | `OpenCranialRoot/EVD` | Optional ventricular drainage concept, never a universal/default stroke step. It has no assumed registration to the v2 ventricles; any combined view needs an authored, reviewed transform. |

### 5.10 Recovery and guidance

| # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 64 | `postoperative_head_dressing` | `LegacyHeadRoot/Recovery` | Generic v1 head-space dressing only after an applicable cranial-access procedure. Do not use after ordinary thrombectomy or monitoring-only care; any non-legacy placement needs a reviewed transform. It is not evidence of success. |
| 65 | `spatial_step_markers` | `SpatialGuidanceRoot/Markers` | Eight markers in one wide entity. Use as authored or create app-owned labels; do not place the entire package at head origin or imply that every pathway has eight steps. |

### 5.11 Neural-detail v3 — build records 66–80

These 15 packages are release-eligible generic HRA atlas layers. Build numbers
remain stable across the complete 110-record audit; runtime code must use the
asset ID, not the number.

| Build # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 66 | `frontal_cortex_parcellation_v3` | `NeuralSemanticRoot/Cortex/Frontal` | Semantic frontal alternative beneath/instead of opaque v2 cortex; use a cutaway or hide the obscuring brain surface. |
| 67 | `parietal_cortex_parcellation_v3` | `NeuralSemanticRoot/Cortex/Parietal` | Semantic parietal focus; preserve bilateral named children and never infer patient function or deficit. |
| 68 | `temporal_cortex_parcellation_v3` | `NeuralSemanticRoot/Cortex/Temporal` | Semantic temporal/auditory-plane focus; static atlas anatomy, not a functional map. |
| 69 | `occipital_cortex_parcellation_v3` | `NeuralSemanticRoot/Cortex/Occipital` | Semantic occipital focus; colour is a selection convention, not vision status. |
| 70 | `insular_opercular_cortex_v3` | `NeuralSemanticRoot/Cortex/InsularOpercular` | Internal focus requiring an opaque cutaway/hide state; do not stack it beneath an opaque whole brain. |
| 71 | `cingulate_parahippocampal_cortex_v3` | `NeuralSemanticRoot/Cortex/Medial` | Medial cortical focus; static atlas relationship only, with no cognition, memory, or outcome claim. |
| 72 | `cerebellar_substructures_v3` | `NeuralSemanticRoot/Cerebellum` | Detailed cerebellar alternative for the broader v2 cerebellar context; do not co-render overlapping opaque source levels. |
| 73 | `brainstem_substructures_v3` | `NeuralSemanticRoot/Brainstem` | Detailed brainstem focus; no pathway conduction, deficit, or procedural safe-margin meaning. |
| 74 | `basal_ganglia_deep_nuclei_v3` | `NeuralSemanticRoot/Deep/BasalGanglia` | Higher-detail alternative to broad `brain_deep_structures_v2`; reveal only after hiding/cutting obscuring tissue. |
| 75 | `thalamic_hypothalamic_nuclei_v3` | `NeuralSemanticRoot/Deep/ThalamicHypothalamic` | Detailed child nuclei with overlapping broad parents deliberately omitted; do not reconstruct the omitted parents as new anatomy. |
| 76 | `hippocampal_amygdala_limbic_nuclei_v3` | `NeuralSemanticRoot/Deep/Limbic` | Semantic limbic focus; atlas anatomy does not encode memory, emotion, seizure, prognosis, or patient findings. |
| 77 | `ventricular_spaces_v3` | `NeuralSemanticRoot/Ventricles` | Higher-detail replacement for `brain_ventricles_v2` in the focused state; a space surface, not CSF volume, flow, or pressure. |
| 78 | `major_white_matter_regions_v3` | `NeuralSemanticRoot/WhiteMatter/Broad` | Broad source volumes; alternate hierarchy level to asset 79, not a disjoint compartment or tractography result. |
| 79 | `commissural_sensory_pathways_v3` | `NeuralSemanticRoot/WhiteMatter/Pathways` | Named source pathways; do not present as patient DTI, connectivity, conduction, or a safe surgical route. |
| 80 | `neural_detail_registered_review_assembly_v3` | `HeadRegisteredRoot/NeuralReviewVariant` | Opaque unilateral review assembly. Replaces assets 66–79 and the obscuring/duplicated v2 brain, deep, and ventricle layers while active; lazy-load for review only. |

### 5.12 Cranial-support v3 — build records 81–98

Records 81–91 and 93–97 are in the release tree. Records 92 and 98 are audit
records only; their binaries and release-manifest entries are absent.

| Build # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 81 | `cranial_nerve_olfactory_i_bilateral_v3` | `CranialNerveRoot/I` | Pair optionally with nasal context for orientation; visibility/colour does not encode smell function. |
| 82 | `cranial_nerve_optic_ii_bilateral_v3` | `CranialNerveRoot/II` | Pair with the separate eye asset without duplicating eyeballs; approximate cross-source contact is not navigation geometry. |
| 83 | `cranial_nerves_ocular_motor_iii_iv_vi_v3` | `CranialNerveRoot/OcularMotor` | Pair with orbital support for static explanation only; no eye-motion, palsy, or conduction simulation. |
| 84 | `cranial_nerve_trigeminal_v_expanded_v3` | `CranialNerveRoot/V` | Semantic trigeminal roots/divisions/branches; not a complete peripheral map, pain map, block target, or surgical corridor. |
| 85 | `cranial_nerve_facial_vii_bilateral_v3` | `CranialNerveRoot/VII` | Static facial/chorda paths; not a facial-expression rig, deficit model, or monitoring system. |
| 86 | `cranial_nerve_vestibulocochlear_viii_v3` | `CranialNerveRoot/VIII` | Source-identity-preserving VIII pathways; may be shown without the held ear asset and encodes no hearing/balance function. |
| 87 | `cranial_nerves_glossopharyngeal_ix_vagus_x_v3` | `CranialNerveRoot/IX_X` | Long atlas-provided paths into the neck; static orientation, not swallowing, autonomic, airway, or stimulation logic. |
| 88 | `cranial_nerve_accessory_xi_bilateral_v3` | `CranialNerveRoot/XI` | Static neck pathway; no strength, range-of-motion, monitoring, or deficit inference. |
| 89 | `cranial_nerve_hypoglossal_xii_bilateral_v3` | `CranialNerveRoot/XII` | Static pathway; no tongue-motion, swallowing, deficit, or safe-margin claim. |
| 90 | `extraocular_muscles_orbital_support_v3` | `OrbitalSupportRoot/Muscles` | Pair with assets 82–83 and optional eyes; static anatomy with no contraction or gaze mechanics. |
| 91 | `pituitary_adenohypophysis_neurohypophysis_v3` | `EndocrineRoot/Pituitary` | Two exact source lobes; static generic atlas context with no endocrine function, lesion, or patient interpretation. |
| 92 | `middle_inner_ear_bilateral_v3` | `NOT_PUBLISHED` | `HOLD_FOR_INNER_EAR_LICENSE_REVIEW`; binary absent. Never create a fallback path to a local/quarantine copy. |
| 93 | `nasal_cavity_paranasal_spaces_v3` | `AirwayRoot/NasalParanasal` | Partial source-backed sinonasal context; no invented maxillary sinus, airflow, drainage, infection, or operative claim. |
| 94 | `pharyngeal_upper_airway_context_v3` | `AirwayRoot/Pharyngeal` | Static naso/oro/laryngopharyngeal orientation; no airflow, swallowing, aspiration, obstruction, or ventilation solver. |
| 95 | `muscles_of_mastication_bilateral_v3` | `MuscleRoot/Mastication` | Static context between scalp/skull and trigeminal paths; no chewing, jaw force, deformation, or approach simulation. |
| 96 | `head_neck_orientation_muscles_v3` | `MuscleRoot/HeadNeck` | Partial orientation set; not complete myology and contains no contraction, stiffness, or access-corridor meaning. |
| 97 | `cranial_nerves_complete_assembly_v3` | `CranialNerveRoot/ReviewVariant` | Nerve-only review assembly replacing assets 81–89; use individual payloads for interactive states. |
| 98 | `cranial_support_registered_assembly_v3` | `NOT_PUBLISHED` | Held, binary absent, and transitively duplicates assets 81–97 while also containing held asset 92. It must never resolve at runtime. |

### 5.13 Conceptual intracranial-micro v3 — build records 99–110

All 12 packages belong exclusively to `MicroScaleRoot`. They are magnified
presentation models, not histology, quantitative physiology, or head-registered
anatomy. Their displayed dimensions and object counts have no biological
measurement meaning.

| Build # | Asset ID | Parent | Relationship / rule |
|---:|---|---|---|
| 99 | `blood_brain_barrier_neurovascular_unit_conceptual_v3` | `MicroScaleRoot/BBB` | Conceptual opened capillary/NVU overview; complements v2 microcirculation but is not a continuation of its geometry. |
| 100 | `capillary_endothelium_tight_junctions_conceptual_v3` | `MicroScaleRoot/BBB/Endothelium` | Endothelium/junction close-up; do not infer real cell count, barrier permeability, thickness, or molecular mechanism. |
| 101 | `formed_blood_elements_magnified_v3` | `MicroScaleRoot/BloodElements` | Illustrative RBC/leukocyte/platelet forms; not a blood film, count, morphology finding, oxygenation cue, or pathology classification. |
| 102 | `platelet_fibrin_thrombus_microstructure_conceptual_v3` | `MicroScaleRoot/Thrombus` | Complements the macro clot markers without registration; composition, strand count, texture, and packing are illustrative. |
| 103 | `multipolar_neuron_detailed_conceptual_v3` | `MicroScaleRoot/NeuralCell/Neuron` | Generic teaching morphology; not a sampled cell, connectome, firing model, or patient tissue. |
| 104 | `astrocyte_capillary_endfeet_conceptual_v3` | `MicroScaleRoot/NeuralCell/Astrocyte` | Conceptual astrocyte/endfeet relationship; placement and coverage are not measured. |
| 105 | `oligodendrocyte_myelinated_axons_conceptual_v3` | `MicroScaleRoot/NeuralCell/Oligodendrocyte` | Conceptual glia/internode overview; counts, spacing, and connections are not histology. |
| 106 | `myelinated_axon_node_of_ranvier_conceptual_v3` | `MicroScaleRoot/NeuralCell/Node` | Enlarged node/internode close-up; no electrophysiology, channel density, conduction velocity, or nerve registration. |
| 107 | `chemical_synapse_closeup_conceptual_v3` | `MicroScaleRoot/NeuralCell/Synapse` | Conceptual terminal/vesicle/cleft/receptor-location cues; no neurotransmitter, kinetics, receptor density, or signaling solver. |
| 108 | `choroid_plexus_csf_interface_conceptual_v3` | `MicroScaleRoot/CSFInterface` | Conceptual interface/direction cues; not registered choroid plexus and contains no CSF production, pressure, composition, or flow rate. |
| 109 | `ischemic_tissue_zones_conceptual_v3` | `MicroScaleRoot/IschemicZones` | Qualitative nested teaching zones only; never map them to patient tissue, perfusion thresholds, time, prognosis, or treatment eligibility. |
| 110 | `intracranial_micro_teaching_set_v3` | `MicroScaleRoot/ReviewVariant` | Review gallery replacing assets 99–109. Never co-load with those components or use the gallery as an interactive patient view. |

## 6. Recommended lesson assembly

### 6.1 Orientation and layer reveal

1. Load the room context only if it materially helps the lesson: table, patient,
   monitor, IV pole, staff, and C-arm.
2. Load `external_head_scalp_realistic_v2` under `ExteriorRoot` and the brain
   asynchronously but keep internal layers disabled.
3. On **Reveal**, swap the intact scalp for
   `external_head_scalp_cutaway_v2`; do not fade multiple transparent shells
   through each other.
4. Progressively enable the conceptual dura cutaway, falx/tentorium or their
   combined variant, brain, arteries, and optional venous context.
5. Offer deep structures, ventricles, eyes, and skull as separately labelled
   optional inspection layers.
6. Reset restores the intact exterior, default camera/placement transform,
   ischemic/haemorrhage choice to `none`, and all optional layers to off.

### 6.2 Ischemic thrombectomy educational path

| State | Show | Hide / replace | App behavior |
|---|---|---|---|
| `ischemicBaseline` | Brain + cerebral arteries + optional flow overlay/animation | Clot and devices | Label flow cues illustrative |
| `rightM1Occlusion` | Add `ischemic_mca_clot_v2`; change overlay to restricted-flow styling in app | Restored-flow cue | Use a discrete lesson state, not simulated pressure |
| `arterialAccess` | Room C-arm, access-site cue, neck arteries, route cue | Open-cranial root | Add narration and a reviewed body-to-head path |
| `deviceNavigation` | Reviewed procedural guidewire/microcatheter pose sequence; v2 devices may appear in a detached close-up | Unused alternative device | Move a derived procedural instance kinematically along an authored guide path |
| `clotEngagement` | Stent-retriever **or** aspiration concept with clot visible | Haemorrhage assets | Use authored poses; no tissue/device force claim |
| `retrievalOrAspiration` | Animate selected device and clot cue to a completed state | Competing treatment animation | Reparent/hide the clot at a deterministic event marker |
| `restoredFlow` | Remove occlusion cue; replay a clearly labelled conceptual flow animation/contrast cue | Engaged-clot state | Never claim a reperfusion grade, velocity, or outcome |
| `recovery` | Neutral head/patient monitoring context | Intervention close-ups and cranial dressing | Ordinary thrombectomy does not create a cranial incision; explain uncertainty without guarantees |

The stent-retriever and aspiration options are alternative explanations. If
shown in one lesson, present them as a comparison with an explicit reset
between them.

### 6.3 Haemorrhage/open-cranial educational path

1. Reset and unload every endovascular clot-removal/device state.
2. Switch to `LegacyHeadRoot` and use the v1 brain/head context with
   `ich_hematoma` and, only if the reviewed lesson needs it,
   `edema_swelling`. These pathology assets are not registered to the v2 head.
   Disable `HeadRegisteredRoot` unless a derived v1-to-v2 transform has been
   explicitly authored and specialist-reviewed for the exact combined view.
3. Enter a management gate: medical monitoring, minimally invasive evacuation,
   open craniotomy evacuation, decompressive craniectomy, or a conditional EVD
   adjunct. Do not imply that every ICH receives surgery.
4. Use scalp flap, bone flap, drill, evacuator port, EVD, instruments, dural
   patch, closure, and dressing only in the sequence approved for the exact
   selected branch.
5. A decompressive craniectomy is not clot removal. If a step is labelled
   decompressive craniectomy, do not animate replacement of the bone flap.
6. Do not imply every haemorrhagic stroke needs open surgery, evacuation, EVD,
   patching, or the same recovery path.

### 6.4 Procedure-specific recovery

- Monitoring-only: no surgical closure or dressing.
- Ordinary thrombectomy: no cranial sutures, bone flap, or head dressing;
  return to monitoring/context and preserve uncertainty.
- Open craniotomy: a reviewed sequence may replace the bone flap, show scalp
  closure, then show a dressing.
- Decompressive craniectomy: the bone flap remains absent in that operation;
  a reviewed scalp closure/dressing may follow.
- Minimally invasive evacuation or EVD: show only the access/device/dressing
  approved for that branch.
- Never animate the brain instantly returning to normal, a neurological deficit
  disappearing, a recovery percentage, or a guaranteed outcome.

### 6.5 Intracranial semantic drill-down

Use one reversible presentation sequence:

1. Start from a macroscopic v2 brain/head orientation state.
2. Swap to exactly one v3 semantic focus: cortical region, deep nuclei,
   ventricles, broad white matter, detailed pathway, cranial nerve, orbital,
   pituitary, airway, or muscle context.
3. Preserve source semantic children for highlighting and labels. Hide or cut
   the opaque parent anatomy that would obscure or spatially duplicate the
   focus.
4. If a cellular explanation is selected, keep the macroscopic state as a
   labelled thumbnail/context cue and open one M-series asset under
   `MicroScaleRoot` in a separate stage. Do not animate a literal coordinate
   zoom from the head into the micro package.
5. Keep “magnified conceptual view — not to anatomical scale; not histology,
   quantitative physiology, or patient-specific” persistently visible.
6. Returning to macro context unloads the micro assembly/component, clears its
   highlights, and restores the prior reviewed macro variant exactly.

No v3 detail package changes the selected ischemic/haemorrhage treatment
branch. Anatomy exploration and intervention sequencing remain independent
state dimensions.

## 7. Runtime state and deterministic logic

One reducer/state machine must be the only writer of asset visibility. Scene
entities should not decide clinical sequence independently. The engine must
never infer treatment from geometry, a monitor display, symptoms, or user
gestures. A clinician-approved lesson configuration selects the branch;
otherwise only anatomy-only mode is available.

```swift
enum EducationPathway: String, Codable, Hashable {
    case none
    case ischemicThrombectomy
    case intracerebralHemorrhage
}

enum LessonStep: String, Codable {
    case orientation, headReveal, baselineFlow, occlusion
    case arterialAccess, deviceNavigation, clotEngagement
    case retrievalOrAspiration, restoredFlow
    case hemorrhageIntro, ichManagementGate, medicalMonitoring
    case minimallyInvasiveEvacuation, openCraniotomyEvacuation
    case decompressiveCraniectomy, evdAdjunct
    case procedureSpecificRecovery, recovery
}

enum FlowPresentation: String, Codable {
    case hidden, baselineIllustrative, restrictedIllustrative, restoredIllustrative
}

enum ICHManagementBranch: String, Codable {
    case none, medicalMonitoring, minimallyInvasiveEvacuation
    case openCraniotomyEvacuation, decompressiveCraniectomy, evdAdjunct
}

struct StrokeExperienceState: Equatable {
    var pathway: EducationPathway = .none
    var step: LessonStep = .orientation
    var visibleAssetIDs: Set<String> = []
    var selectedAggregateIDs: Set<String> = []
    var flow: FlowPresentation = .hidden
    var ichManagement: ICHManagementBranch = .none
    var magnifiedViewIsActive = false
    var activeScaleDomain: String = "macroscopic_generic_atlas"
    var semanticFocusAssetID: String? = nil
    var animationRevision = 0       // increment to replay deterministically
    var clinicalWarningsVisible = true
}

struct AssetAssemblyRule: Decodable {
    let assetID: String
    let canonicalParent: String
    let frameID: String              // registered_v2, neural_hra, cranial_z, legacy_v1, vignette, micro_separate, device_tray
    let directContainedAssetIDs: Set<String>
    let allowedPathways: Set<EducationPathway>
    let scaleMode: String            // anatomical_1_to_1, magnified, or detached_1_to_1
    let requiresClinicalApproval: Bool
}
```

Build `containedLeafAssetIDs` as the recursive closure of
`directContainedAssetIDs`; a non-composite asset's closure is the asset itself.
Cache that graph after validating that it is acyclic, then use it for every
visibility transition and duplication test.

Reducer invariants:

```text
if pathway changes:
    stop all animations
    clear device/clot/open-cranial states
    restore the reviewed default layer set

if an aggregate becomes visible:
    recursively expand its containedLeafAssetIDs
    reject if that set intersects any active asset's expanded leaf set

if license_review_status begins with "HOLD_" or assetID is a held build record:
    reject before resolving a file URL

if ischemicThrombectomy:
    OpenCranialRoot.isEnabled = false
    ich_hematoma and edema_swelling are disabled

if intracerebralHemorrhage:
    ProcedureToolRoot endovascular children are disabled
    DeviceInspectionRoot endovascular treatment comparison is disabled
    ischemic clot and arterial retrieval cues are disabled

if ichManagement == evdAdjunct and lesson configuration lacks EVD approval:
    reject the transition and keep the prior state

if magnified vignette is active:
    show “Magnified educational view — not to anatomical scale”

if activeScaleDomain == "microscopic_conceptual_separate":
    require parent == MicroScaleRoot
    require registered_to_head == false
    keep “conceptual, nonquantitative, not patient-specific” visible
    prevent head-space registration, shared bounds fitting, and physical-unit comparison

if DeviceInspectionRoot scale != 1:
    show “Magnified educational view” and an explicit scale indicator

on reset:
    restore placement/orbit/zoom, visibility, pathway, step, labels,
    animation time, highlights, and interaction selections
```

Asset entities should be keyed by the manifest ID, not an imported USD root
name. After loading, set the outer container's name to the manifest ID. Do not
assume every package has a unique internal `defaultPrim` name.

## 8. Physics and animation contract

“Physics” in this project means interaction classification and deterministic
visual logic. It does **not** mean a validated biomechanical or haemodynamic
simulation.

| Content | Runtime body | Collision use | Motion / solver rule |
|---|---|---|---|
| Brain, skull, scalp, dura, partitions | Static; no gravity | Input hit shape only when selectable | Visibility swap or rigid transform only; no tissue deformation claim |
| v3 neural parcels, deep nuclei, ventricles, white matter, and pathways | Static; no gravity | Coarse input proxy only | Semantic highlight/cutaway/variant only; no conduction, tractography, tissue, or lesion solver |
| v3 cranial nerves, orbital/pituitary/airway/muscle context | Static; no gravity | Coarse input proxy only | Selection/visibility only; no nerve conduction, contraction, swallowing, airflow, or endocrine behavior |
| Arteries, veins, sinuses | Static; no gravity | Usually none; broad selection trigger if needed | Never infer compliance, pressure, flow, or contact from the mesh |
| Clot | Kinematic state object | Optional trigger for authored engagement event | Discrete visible/engaged/removed states; no friction, adhesion, compression, or measured deformation |
| Guidewire and catheters | Kinematic | Optional coarse trigger, not physical vessel contact | Follow a pre-authored path/pose sequence; no force, torque, buckling, perforation, or navigation accuracy claim |
| Stent retriever | Kinematic | Optional authored event trigger | Swap/reveal deployed and withdrawn poses; do not claim self-expansion mechanics |
| Flow markers/arrows/RBCs | No rigid body | None | Transform or particle-cue animation; direction and timing are illustrative and dimensionless |
| Room equipment | Static or kinematic | Coarse safety/selection volumes only | No verified C-arm/table collision envelope |
| Patient/staff | Static | Input/comfort exclusion only if needed | No ragdoll or human biomechanics |
| Open-cranial tools/flaps | Kinematic | Optional trigger for lesson sequencing | Authored transforms only; no cutting, drilling, suction, tissue, or force simulation |
| v3 micro cells, thrombus, BBB, myelin, synapse, CSF interface, and tissue zones | Static; illustrative markers may be kinematic | None except coarse UI picking | Separate-stage visibility or qualitative cue motion only; no fluid, diffusion, electrophysiology, reaction, perfusion, histology, or viability solver |

Implementation rules:

- Disable gravity and dynamic rigid-body response for anatomy and procedural
  tools.
- For taps or gestures, use an input target plus a generated/coarse collision
  shape. If collision is only for input, use filtering that avoids unnecessary
  physics interaction.
- Use triggers only to advance a deterministic authored event; never let a
  collision decide a clinical outcome.
- Keep a separate `ViewerFitRoot`/placement parent for scaling and centering so
  baked animation channels remain untouched.
- Discover imported animation through `availableAnimations`, choose the
  reviewed clip deterministically, call `playAnimation`, and expose Replay.
- `cerebral_bloodflow_animation_v2` is a four-second explanatory transform
  sequence. Its duration is not cardiac-cycle, transit-time, velocity, or
  perfusion data.
- Describe a restriction only as “blood flow may be reduced.” Collateral
  circulation is not modeled, so the visualization must not guarantee zero
  downstream flow.
- Never assign tissue density/stiffness, nerve conductivity, membrane
  permeability, clot composition, CSF production, diffusion, reaction kinetics,
  channel density, perfusion threshold, or cell population values from v3 mesh
  appearance. Such metadata is absent.
- If a presentation arrow, particle, pulse, or colour transition is added to a
  v3 micro asset, keep it app-owned or in a separate behavior layer, mark it
  `conceptual=true` and `quantitative=false`, and expose no physical units.
- A future Houdini FLIP, FEM, Vellum, wire, or tissue solve is an **offline
  visual authoring aid only** until independently validated. It must be reduced
  to a supported baked representation and retain the conceptual label.

## 9. Houdini / Solaris assembly instructions

### 9.1 Non-destructive working layout

1. Work in Solaris/LOPs and keep each asset as a referenced or payloaded
   component. Do not merge the 108 release packages into one destructive mesh.
2. Prefer the source USDC interchange file when available. If only a USDZ is
   present in this repository, unpack it to a temporary working directory with
   USD tooling; never edit the committed package in place.
3. Create a root layer such as `stroke_experience_master.usda` containing only
   hierarchy, references/payloads, variants, visibility defaults, and metadata.
4. Keep geometry, materials, animation, and lesson metadata in separate USD
   layers so a later agent can replace one without rebuilding everything.
5. Use the manifest ID for each reference prim, for example
   `/StrokeExperience/Patient/Head/Brain/brain_anatomy_realistic_v2`.
6. Preserve `metersPerUnit = 1`, `upAxis = "Y"`, a valid `defaultPrim`, and the
   imported transform stack.
7. Author aggregate/component relationships as a variant set or app-side
   exclusivity rule. Do not author both visible by default.
8. Use payloads for phase-specific heavy anatomy/review packages and references
   for lightweight always-needed components. A payload load decision must not
   change clinical meaning.
9. Keep three explicit composition domains: `MACRO_HEAD` for registered
   generic atlas anatomy, `MESO_VESSEL` for magnified wall/device teaching,
   and `MICRO_CELLULAR` for M-series presentation models. Never pass a display
   scale or viewer-fit transform between domains.

Each publishable component should have one root `Xform`, `kind = "component"`,
and that root as the file's `defaultPrim`. The master root should use
`kind = "assembly"`; organizational scopes may use `kind = "group"`. Keep
render geometry below non-geometric containers, with optional low-resolution
`proxy` geometry kept distinct from `render` geometry.

For animated working layers, record `timeCodesPerSecond` and `framesPerSecond`
explicitly (30 for the current blood-flow clip). Houdini's Configure Layer
metadata does not rotate or scale geometry: convert a nonconforming source once
at SOP/LOP level, then author the correct metadata. Never hide the same unit or
axis conversion in several nested transforms.

Suggested Solaris graph:

```text
Sublayer/input manifests
    -> Component/reference LOPs per asset
    -> Canonical scope hierarchy
    -> Variant sets (intact/cutaway, component/aggregate, pathway)
    -> Material normalization/baked textures
    -> Animation layer
    -> Metadata and licensing customData
    -> USD ROP / USD Render ROP
    -> usdchecker
```

Recommended layer stack:

```text
00_source_payloads.usdc      # immutable geometry and semantic/source metadata
10_registration.usda         # project-frame or approved patient-frame xforms
20_look.usda                 # reviewed materials; no clinical state
30_presentation.usda         # cutaways, visibility variants, qualitative cues
40_lesson.usda               # IDs, captions/warnings, pathway bindings
90_master.usda               # composition only; no copied geometry
```

Use variant sets such as `anatomyDetail={broad,semantic}`,
`whiteMatterView={broad,pathways}`, `cranialNerves={components,assembly}`,
`microView={off,individual,review}`, and
`exterior={intact,cutaway}`. Invalid combinations must have no authored
variant, not merely rely on a default-off checkbox. Preserve HRA ontology/source
properties and Z-Anatomy `userProperties:anatomical_name`; do not flatten
semantic children or bind interaction to vertex indices.

### 9.2 Curves, devices, and procedural motion

- Store a reviewed access route as a dedicated guide curve, separate from the
  anatomy mesh and clearly named `conceptual_access_path`.
- In Houdini, generate guidewire/catheter poses from that curve, then bake a
  small number of reviewed transforms or deformed geometry samples. Do not
  expose a live procedural solver as a runtime medical simulation.
- Store semantic events such as `accessComplete`, `atOcclusion`, `engaged`,
  `withdrawalComplete`, and `flowCueRestored` in the app-owned lesson manifest,
  mapped to reviewed clip names/times. Alternatively, split them into named
  clips. Advance with deterministic app timing or RealityKit playback-complete
  handling; do not assume arbitrary custom USD event markers import into
  RealityKit.
- Keep stent-deployed, clot-engaged, and withdrawn states as explicit variants
  or clips. Avoid topology-changing runtime assumptions unless a RealityKit
  import test proves the exact representation.
- Preserve original device meshes as immutable source references; apply path
  deformation or pose generation in a derived layer.
- Do not simply reparent an unregistered v2 device close-up into
  `HeadRegisteredRoot`. A procedural instance must carry an explicitly reviewed
  registration transform/curve and remain distinguishable from the immutable
  inspection asset.

### 9.3 Fluid and blood-flow authoring

- The preferred patient-facing representation is sparse directional markers,
  arrows, emissive paths, or app particles—not a photoreal volumetric blood
  simulation.
- If Houdini FLIP is explored, cache it offline, keep the cache outside the
  runtime repository, and use it only to derive a lightweight visual cue.
- Do not package a VDB/volume-based blood effect in USDZ. USD volume prims
  reference external volume files, and the USDZ delivery path does not support
  that volume payload as a self-contained RealityKit fluid.
- Never export a dense FLIP cache, volumetric field, or changing high-resolution
  mesh as the default Vision Pro asset. Fluid caches grow quickly and do not
  establish physiological validity.
- Convert approved flow visuals to one of: baked rigid transforms, a small
  skeletal/point-marker animation proven to import, an optimized mesh sequence
  proven on device, or app-owned RealityKit particles.
- Document any visual parameter in qualitative language (`slow cue`,
  `restricted cue`, `restored cue`), not physical units. Do not expose pressure,
  velocity, wall shear, perfusion, collateral score, or reperfusion grade.
- Name authoring controls `presentationSpeed`, `illustrativeDensity`, and
  `sequenceProgress`; do not name them `bloodVelocity`, `pressure`, `flowRate`,
  `perfusion`, or `wallShear`.

### 9.4 Materials and export

- Target simple metallic-workflow PBR: base colour, metallic, roughness, normal,
  and optional ambient occlusion/emissive inputs.
- Base-colour textures are sRGB. Roughness, metallic, AO, and normal maps are
  linear/data. Normal maps must use the OpenGL tangent convention expected by
  the current Apple pipeline.
- Bake unsupported Houdini/Blender procedural networks to textures. Do not
  assume a custom shader or arbitrary MaterialX network will survive USDZ and
  RealityKit import.
- Treat the three ImageGen micro-v3 maps only as project-owned base-colour
  appearance references. They are not calibrated material measurements,
  microscopy, histology, anatomy, pathology, or a source for geometry/physics.
  Preserve their hashes and prompt record in
  [`IMAGEGEN_INTRACRANIAL_MICRO_V3.md`](docs/assets/source-notes/IMAGEGEN_INTRACRANIAL_MICRO_V3.md).
- Prefer opaque surfaces. Minimize alpha overlap and double-sided materials.
- Use USDC for geometry-heavy working layers and USDZ for self-contained
  delivery. Reality Composer Pro may compile the selected content into a
  `.reality` resource for the application.
- Each delivery package must contain all of its referenced textures and stay
  independently loadable.

### 9.5 Patient-specific DICOM replacement hooks

The generic assets remain the default educational content. A future
patient-authorized clinical environment may replace only named input slots; it
must not deform an atlas until it “looks patient-specific.” This hook is an
engineering interface, not evidence that the current app is suitable for
diagnosis, planning, navigation, or treatment.

| Houdini input | Generic fallback | Permitted patient-specific replacement |
|---|---|---|
| `IN_HEAD_SKIN` | HRA skin crop | Approved CT/MRI external-surface segmentation |
| `IN_SKULL` | NIH/Z-Anatomy skull context | Reviewed thin-slice CT bone segmentation |
| `IN_BRAIN_PARENCHYMA` | HRA brain | Clinician-reviewed T1/T2/FLAIR segmentation |
| `IN_CORTEX_LABELS` | HRA named regions | Approved patient parcellation with algorithm/version |
| `IN_VENTRICLES` | HRA ventricles | Reviewed CT/MRI segmentation |
| `IN_ARTERIAL_TREE` | Z-Anatomy arteries | Reviewed CTA/MRA/3DRA/DSA-derived vessel segmentation |
| `IN_VENOUS_TREE` | Z-Anatomy dural/head veins | Reviewed CTV/MRV segmentation |
| `IN_LESION_CORE` | Generic clot/infarct teaching cue | Reviewed DWI/ADC or CT-derived lesion segmentation |
| `IN_PERFUSION_MAPS` | None | Registered clinical parametric maps with provenance |
| `IN_DTI_TRACTS` | No patient fallback | Reviewed tractography plus uncertainty metadata |
| `IN_DEVICE_PATH` | Generic educational route | Approved plan/recorded centreline; never inferred from atlas anatomy |

Routine scans generally cannot resolve cranial nerves, pia/arachnoid,
capillary beds, cellular injury, or a complete perforator network. Keep those
layers visibly labelled “generic atlas/conceptual” or omit them; never warp and
relabel them as patient anatomy.

Prefer DICOM Segmentation (SEG) or DICOM Surface Segmentation tied to the source
study and `FrameOfReferenceUID`. Preserve one patient frame; never centre each
surface independently. For column-vector points in DICOM LPS millimetres, the
exact project conversion to Houdini Y-up, right-handed metres is:

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

If an approved tool exports RAS millimetres, use
`(x_ras, z_ras, -y_ras) * 0.001`. Parent all converted surfaces beneath one
`PATIENT_FRAME` xform and retain, inside the controlled clinical system:
`StudyInstanceUID`, `SeriesInstanceUID`, `FrameOfReferenceUID`,
`ImagePositionPatient`, `ImageOrientationPatient`, spacing, source
series/modality, segmentation algorithm/version, registration transform/hash,
review status/role/time, and de-identification status. Exported USD/USDZ must
not carry raw identifiers, private paths, or hidden DICOM metadata.

Before switching any slot from `GENERIC_ATLAS` to
`PATIENT_SEGMENTATION`, require all of:

1. source series and Frame of Reference identified;
2. unit and LPS/RAS conversion verified with at least three landmarks;
3. explicit left/right reflection check;
4. expected components, bounds, normals, and topology checked;
5. registration residual/error recorded—visual alignment alone is insufficient;
6. segmentation algorithm, parameters, and version recorded;
7. qualified reviewer approval for the intended use;
8. atlas, conceptual, and patient layers visibly distinguished;
9. PHI confined to the approved access-controlled environment; and
10. export scanned for identifiers and private paths.

Raw DICOM, identifiable facial surfaces, derived patient meshes, and PHI must
never enter this public repository or a generic app bundle. The detailed source
coverage, missing-anatomy audit, and replacement rationale are in
[`INTRACRANIAL_DETAIL_SOURCE_AUDIT.md`](docs/assets/research/INTRACRANIAL_DETAIL_SOURCE_AUDIT.md).

## 10. RealityKit integration contract

1. Decode the manifests and key records by `id`.
2. Load only the assets required for the current state, asynchronously.
3. Set the loaded container's `name` to the manifest ID.
4. Attach it beneath the canonical parent without changing its authored child
   transform.
5. Fit/center an isolated inspection view from visual bounds on a separate
   parent. Do not use manifest dimensions as lesion/device measurements.
6. Add `InputTargetComponent` and generated collision shapes only to entities
   that must accept input.
7. Drive visibility, highlighting, flow mode, playback, and pathway exclusivity
   from `StrokeExperienceState`.
8. Prefer `isEnabled`/visibility changes and resource reuse over destroy/reload
   on every step.
9. Stop old animations before switching state. Restart Replay from time zero.
10. Surface an explicit load/animation error instead of silently substituting a
    clinically different asset.
11. Reject any held ID/status before file resolution, even if a developer has a
    quarantine copy elsewhere on disk.
12. Route `microscopic_conceptual_separate` only to `MicroScaleRoot`; do not
    compare its bounds or metre values with head geometry.
13. Resolve labels/highlights from stable semantic properties, retain
    component/assembly and broad/pathway exclusions from each manifest, and
    fail catalog validation if a referenced exclusion ID is unknown.

The application, not a USD file, owns:

- pathway and step state;
- labels, warnings, captions, and accessibility text;
- aggregate/component mutual exclusion;
- reset/home behavior;
- gestures and selected highlights;
- clinical opt-out/pause behavior;
- qualitative baseline/restricted/restored-flow presentation.
- persistent magnification, conceptual/nonquantitative, atlas-versus-patient,
  licence-hold, and clinical-boundary warnings;
- scale-domain routing and release-manifest filtering.

The USD/Houdini layer owns:

- geometry, materials, pivots, and semantic prim names;
- authored registration transforms;
- simple reviewed animation clips or state variants;
- asset-level provenance/licensing metadata.

## 11. Performance and loading budget

- Start with a target of about **100,000 visible triangles** for the active
  teaching view until device profiling proves more headroom.
- Treat Apple's approximate guidance of 250,000 triangles in Shared Space and
  500,000 in an immersive scene as scene-level ceilings to profile, not a
  per-model entitlement.
- Also budget the whole active scene, not each file, around Apple's approximate
  Shared Space guidance of 250 draw calls/250,000 visible vertices and Full
  Space guidance of 500 draw calls/500,000 visible vertices.
- Do not preload all 108 release assets or display combined review assemblies with
  their individual components.
- `layered_head_cutaway_registered_v2` is 333,642 triangles and
  `thrombectomy_registered_hero_v2` is 440,648 triangles. Either asset alone is
  already beyond the Shared Space triangle guideline; treat it as a heavy,
  lazy-loaded review view and profile the exact Full Space presentation.
- `neural_detail_registered_review_assembly_v3` is 279,788 triangles,
  `cranial_nerves_complete_assembly_v3` is 150,722 triangles, and
  `intracranial_micro_teaching_set_v3` is 114,092 triangles across 424 model
  meshes. Each is a review/lazy-load variant, not a default layer; never
  co-load it with its components.
- The held `cranial_support_registered_assembly_v3` build record is 333,360
  triangles, but its binary is not a performance option because it is not in
  the release tree.
- Lazy-load expensive head/hero assemblies, cache reusable resources, and
  unload an inactive pathway when memory pressure requires it.
- Reduce mesh/entity/material/texture counts and merge only non-interactive
  subparts that share a material. Keep clinically toggleable layers separate.
- Prefer opaque cutaways over overlapping transparent anatomy.
- Profile the assembled scene on actual Vision Pro with RealityKit Trace. A
  simulator screenshot is useful evidence, not a physical-device performance
  result.

## 12. Prohibited combinations and claims

These are hard failures:

- No scalp incision, bone flap, drill, or exposed-brain asset in a
  thrombectomy-only sequence.
- No arterial stent retriever depicted removing an intracerebral haematoma.
- No decompressive craniectomy described as clot removal.
- No replaced bone flap at the end of a scene explicitly labelled
  decompressive craniectomy.
- No generic asset presented as patient-specific or predictive.
- No ischemic clot and intracerebral-haematoma primary state enabled together.
- No v1 and v2 equivalent anatomy enabled together without a documented,
  reviewed comparison mode.
- No cranial postoperative dressing after ordinary thrombectomy or
  medical-monitoring-only content.
- No EVD enabled as a routine/default step without an explicitly approved EVD
  branch.
- No conceptual scalp or dura viewing window labelled as a real surgical
  opening.
- No flow arrow, cell, particle, contrast cue, or animation presented as CFD,
  pressure, velocity, perfusion, collateral grading, or a reperfusion result.
- No clot geometry used as a measurement or substitute for CTA, MRA, DSA, CT
  perfusion, or clinician interpretation.
- No generic device used for selection, sizing, navigation, deployment
  training, or manufacturer-specific explanation.
- No venous blue/purple material described as the literal colour of blood.
- No magnified vignette presented as scale-matched to the head.
- No M-series geometry, presentation dimensions, counts, colours, spacing, or
  directional cues described as histology, measured physiology, or a literal
  position inside the head.
- No HRA/Z-Anatomy layer presented as a patient's segmentation, functional map,
  tractography, operative target, safe margin, or complete anatomy.
- No ImageGen appearance reference described as microscopy, histology,
  pathology, anatomical authority, or clinical evidence.
- No held inner-ear-containing build record resolved, bundled, previewed as
  released content, or restored by a developer fallback path.
- No broad white-matter parent and detailed pathway layer presented as disjoint
  tissue compartments.
- No patient scan, identifier, record, or outcome data introduced without a
  separately approved privacy, security, clinical, and regulatory workflow.
- No raw DICOM, patient-derived mesh, identifiable facial surface, or PHI in
  this repository or generic app bundle.

Required automated guards should fail closed:

```text
assert not (ischemic clot visible and ICH haematoma visible)
assert not (thrombectomy pathway and OpenCranialRoot enabled)
assert not (stent retriever targets ICH haematoma)
assert not (decompressive craniectomy and bone flap replacement state)
assert not (ordinary thrombectomy and postoperative head dressing visible)
assert not (EVD visible without an approved EVD branch)
assert no pair of active assets has intersecting transitive contained-leaf sets
assert not (v1 equivalent visible with v2 equivalent outside comparison mode)
assert not (magnified vignette parented under HeadRegisteredRoot)
assert not (unregistered v2 device inspection asset treated as a patient path)
assert release manifest IDs do not contain either inner-ear hold record
assert every manifest exclusion references a known build-record ID
assert not (neural review assembly visible with any N01–N14 component)
assert not (cranial-nerve assembly visible with any C01–C09 component)
assert not (micro teaching set visible with any M01–M11 component)
assert not (major white-matter regions visible with detailed pathways)
assert every microscopic_conceptual_separate asset is parented under MicroScaleRoot
assert every active micro view keeps magnification/conceptual/non-patient warnings visible
assert exported generic assets contain no DICOM identifiers or private paths
```

## 13. Validation gates

Every generated or modified asset must pass all applicable gates:

### Automated package gate

- Manifest ID is unique and matches the USDZ basename.
- File exists, is non-empty, and checksum/byte metadata is current where the
  manifest carries it.
- `/usr/bin/usdchecker --arkit --strict <asset.usdz>` exits successfully.
- Stage has a valid default prim, Y-up metadata, metre scale, nonzero mesh/model
  content, and resolvable texture references.
- RealityKit loads the package and exposes nonzero renderable bounds.
- An animated package exposes the expected animation resource(s).
- The release catalog contains 108 unique IDs and paths; neither held build ID
  nor binary is present.
- Every aggregate/exclusion graph is known, acyclic, recursively expanded, and
  tested against each other active asset.
- Every micro record declares `microscopic_conceptual_separate`,
  `registered_to_head=false`, `quantitative=false`,
  `histology_validated=false`, and a required magnification label.

### Visual/interaction gate

- Registration, laterality, dimensions, pivots, materials, normals, culling,
  cutaways, and labels are inspected in Reality Composer Pro or the target app.
- Aggregate/component switches produce no duplicates or z-fighting.
- Broad/semantic/pathway variants hide overlapping source hierarchy levels, and
  all M-series content opens in a visibly separate presentation stage.
- Reset restores every transform, layer, pathway, highlight, and animation.
- The simulator build shows actual loaded content, not a spinner or placeholder.
- A physical Vision Pro pass verifies comfort, legibility, interaction, and
  frame timing.

### Clinical/release gate

- Interventional neuroradiology reviews arterial laterality, ICA/MCA route,
  right-M1 teaching marker, and thrombectomy sequence.
- Stroke neurology reviews mechanism, uncertainty, urgency, alternatives,
  risks, and recovery language.
- Neurosurgery reviews every open-cranial/haemorrhage sequence that is included.
- Neuroanatomy reviews v3 cortical, deep, white-matter, ventricular, and cranial
  nerve identity/laterality/registration; neuropathology and haematology review
  the conceptual micro/thrombus wording and imagery.
- Accessibility/human-factors review covers captions, colour-independent cues,
  seated/reclined use, opt-out, and non-graphic presentation.
- Licensing, attribution, ShareAlike, source, and modification notices ship
  with the applicable assets.
- The signed checklist identifies the exact reviewed version.
- Any patient-specific replacement separately passes DICOM frame, registration,
  segmentation, privacy/security, human-factors, clinical-validation, quality,
  and regulatory gates for its intended use.

## 14. Agent handoff and definition of done

An agent or Houdini artist implementing the combined experience must deliver:

1. A non-destructive master USD/LOP scene or RealityKit composition using the
   canonical hierarchy.
2. A machine-readable mapping from every loaded manifest ID to canonical parent,
   pathway, visibility state, replacement group, and warning label.
   Preserve separate audit records for the two held IDs without runtime paths.
3. Deterministic state transitions and a complete Reset/Home test.
4. Separate ischemic and haemorrhage pathways with automated tests for every
   prohibited combination.
5. Explicit qualitative labels for magnification and flow cues.
6. An asset-loading report, USD validation log, RealityKit load result, and
   aggregate/component duplication test.
7. Simulator evidence plus a clearly separate physical-device QA record.
8. Updated manifests, checksums, provenance, licence notices, and clinical
   review version whenever geometry, materials, animation, or meaning changes.
9. A layered Solaris handoff preserving source payloads, semantic properties,
   scale domains, variants, exclusions, and separate look/presentation/lesson
   layers; USDZ is final delivery, not the editable master.
10. A test showing held IDs fail before file resolution and micro packages
    cannot enter the head registration graph.
11. If patient replacement is in scope, the controlled DICOM frame/registration
    record and all acceptance-gate evidence—never the patient data itself in
    this repository.

The work is **not done** merely because the master scene opens. It is done only
when the selected assets fit without duplicate geometry, every state is
reversible, prohibited combinations are impossible in code, package and device
performance are measured, and the exact patient-facing build has completed the
review gates above.

## 15. Official implementation references

- Apple: [Creating USD files for Apple devices](https://developer.apple.com/documentation/usd/creating-usd-files-for-apple-devices)
- Apple: [RealityKit coordinate convention](https://developer.apple.com/videos/play/wwdc2023/10080/?time=774)
- Apple: [Reducing the rendering cost of RealityKit content on visionOS](https://developer.apple.com/documentation/visionos/reducing-the-rendering-cost-of-realitykit-content-on-visionos)
- Apple: [Optimize 3D assets for spatial computing](https://developer.apple.com/videos/play/wwdc2024/10186/)
- Apple: [Creating a Reality Composer Pro package](https://developer.apple.com/documentation/realitycomposerpro/creating-a-reality-composer-pro-package-in-your-app)
- Apple: [Analyzing performance with RealityKit Trace](https://developer.apple.com/documentation/visionos/analyzing-the-performance-of-your-visionos-app)
- Apple: [`Entity.availableAnimations`](https://developer.apple.com/documentation/realitykit/entity/availableanimations)
- Apple: [`InputTargetComponent`](https://developer.apple.com/documentation/realitykit/inputtargetcomponent)
- Apple: [`CollisionComponent`](https://developer.apple.com/documentation/realitykit/collisioncomponent)
- Apple: [RealityKit physics collision detection](https://developer.apple.com/documentation/realitykit/physics-collision-detection)
- Apple: [`ParticleEmitterComponent`](https://developer.apple.com/documentation/realitykit/particleemittercomponent)
- Apple: [Responding to gestures on an entity](https://developer.apple.com/documentation/realitykit/responding-to-gestures-on-an-entity)
- SideFX: [USD and Solaris overview](https://www.sidefx.com/docs/houdini/solaris/usd.html)
- SideFX: [Solaris overview and Component Builder](https://www.sidefx.com/docs/houdini/solaris/index.html)
- SideFX: [Component Builder](https://www.sidefx.com/docs/houdini/solaris/component_builder.html)
- SideFX: [Configure Layer LOP](https://www.sidefx.com/docs/houdini/nodes/lop/configurelayer.html)
- SideFX: [USD Export SOP](https://www.sidefx.com/docs/houdini/nodes/sop/usdexport.html)
- SideFX: [USD File Cache LOP](https://www.sidefx.com/docs/houdini/nodes/lop/filecache.html)
- SideFX: [USD output and USDZ packaging](https://www.sidefx.com/docs/houdini/solaris/output.html)
- SideFX: [USD Zip output](https://www.sidefx.com/docs/houdini/nodes/out/usdzip.html)
- SideFX: [USD volume prims](https://www.sidefx.com/docs/houdini/nodes/lop/volume.html)
- SideFX: [VDB from Polygons](https://www.sidefx.com/docs/houdini/nodes/sop/vdbfrompolygons.html)
- SideFX: [DOP simulation caching](https://www.sidefx.com/docs/houdini/dyno/cache)
- SideFX: [Fluid SOP caching](https://www.sidefx.com/docs/houdini/fluid/sopcaching.html)
- DICOM: [Patient-based coordinate system and image plane](https://dicom.nema.org/medical/dicom/current/output/chtml/part03/sect_c.7.6.2.html)
- 3D Slicer: [Segmentations module](https://slicer.readthedocs.io/en/5.8/user_guide/modules/segmentations.html)
- 3D Slicer: [Segmentation developer guide](https://slicer.readthedocs.io/en/latest/developer_guide/modules/segmentations.html)
- NIH 3D: [HRA Brain, Male 3DPX-020960](https://3d.nih.gov/entries/20960/1)
- BodyParts3D: [Licence](https://dbarchive.biosciencedbc.jp/en/bodyparts3d/lic.html)
