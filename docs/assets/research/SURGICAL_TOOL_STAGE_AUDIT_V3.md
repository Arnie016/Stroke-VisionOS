# Surgical tool stage audit v3

**Audit date:** 2026-08-08

**Baseline audited:** 110 manifest-backed build records: 29 prototype-v1, 36
realistic-v2, and 45 intracranial-detail-v3 records. Two of the 110 are already
licence-held; this audit does not change their status.

**Scope:** read-only clinical/workflow/source audit for a future collection of
generic educational tool props. This document does not authorize asset release,
patient use, procedural planning, navigation, device selection, or treatment.

## Executive decision

The experience must model two **separate, gated pathways**:

1. **Endovascular mechanical thrombectomy (EVT)** for a clinician-selected
   ischemic-stroke scenario. EVT is performed through an endovascular catheter
   route. Ordinary EVT does **not** include a scalp incision, craniotomy,
   craniectomy, bone flap, dural opening, scalp closure, EVD, or postoperative
   head dressing.
2. **Conditional open-cranial / hemorrhage / decompression** for a
   clinician-selected hemorrhage, hydrocephalus, posterior-fossa evacuation, or
   decompression scenario. This branch is not a routine continuation of EVT.
   Its inclusion, approach, and optional EVD state require explicit clinical
   selection.

The FDA defines a neurovascular mechanical thrombectomy device as being
delivered to the neurovasculature by an **endovascular approach** to remove
thrombus and restore blood flow. The current AHA/ASA acute ischemic stroke
guideline broadens EVT eligibility, but eligibility and technique remain
clinical decisions; the model must not infer them from visible anatomy. The
AHA/ASA ICH guideline separately addresses minimally invasive evacuation,
craniotomy/craniectomy, cerebellar evacuation, and EVD-dependent hydrocephalus.

This separation is a release-blocking invariant, not merely a caption.

## Authority and interpretation boundary

The sources below establish clinical categories, workflow boundaries, and
regulatory device classes. They are **not** geometry licences and do not grant
permission to copy figures, CAD, labeling, logos, packaging, user interfaces,
or trade dress.

- AHA/ASA, *2026 Guideline for the Early Management of Patients With Acute
  Ischemic Stroke*, DOI
  [10.1161/STR.0000000000000513](https://doi.org/10.1161/STR.0000000000000513).
  The guideline replaces the 2018 guideline and 2019 update and includes
  broadened EVT eligibility. Use it for the clinical branch boundary, not for a
  scripted device sequence.
- AHA/ASA,
  [2026 AIS EVT eligibility algorithm](https://professional.heart.org/en/-/media/PHD-Files-2/Science-News/2/2026/AIS-EVT-Algorithm-Poster.pdf?sc_lang=en).
  The app may narrate that imaging and clinical assessment determine
  eligibility, but must not reproduce the chart as an automated decision tool.
- AHA/ASA, *2022 Guideline for the Management of Patients With Spontaneous
  Intracerebral Hemorrhage*, DOI
  [10.1161/STR.0000000000000407](https://doi.org/10.1161/STR.0000000000000407),
  and its
  [official summary](https://professional.heart.org/en/science-news/2022-guideline-for-the-management-of-patients-with-spontaneous-intracerebral-hemorrhage/top-things-to-know).
  These support a distinct, conditional hemorrhage-management branch and the
  fact that intervention choice and expected benefit vary by presentation.
- Society of NeuroInterventional Surgery (SNIS),
  [transarterial and transvenous access standards](https://jnis.bmj.com/content/12/8/733).
  This supports generic access categories including ultrasound guidance and
  micropuncture concepts without implying that any one access method is
  universal.
- SNIS,
  [focused update for basilar-artery-occlusion EVT](https://jnis.bmj.com/content/16/8/752).
  This confirms that aspiration, stent-retriever, and combined approaches are
  technique variants, not props that should all be shown acting at once.
- FDA,
  [neurovascular mechanical thrombectomy device classification, product code POL](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpcd/classification.cfm?id=4136),
  [thrombus-retriever catheter classification, NRY](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPCD/classification.cfm?id=NRY),
  [neurovascular percutaneous catheter classification, QJP](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpcd/classification.cfm?id=3963),
  and
  [catheter-introducer classification, DYB](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPCD/classification.cfm?ID=DYB).
  These justify generic category names only. FDA classification does not imply
  that this project's geometry is cleared, safe, compatible, or effective.
- FDA,
  [intravascular catheter, wire, and delivery-system coating guidance](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/intravascular-catheters-wires-and-delivery-systems-lubricious-coatings-labeling-considerations).
  It identifies catheters, guidewires, balloon catheters, and sheaths as coated
  intravascular device categories. The asset materials must remain illustrative
  and must not claim a particular coating or performance.
- Neurocritical Care Society,
  [EVD insertion and management consensus statement](https://www.neurocriticalcare.org/Portals/0/Docs/Resources/EVD_FINAL.pdf).
  It supports EVD as an optional drainage/monitoring intervention with
  meaningful risks, not a routine stroke prop.
- FDA classifications for
  [neurosurgical head holders](https://www.accessdata.fda.gov/scripts/cdrh/cfPCD/classification.cfm?ID=HBL),
  [cranial drills, burrs, and trephines](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpcd/classification.cfm?devicename=drill&sortcolumn=deviceclassdesc&start_search=1),
  and the neurological-device table containing
  [scalp clips, rongeurs, retractors, paddies, and related categories](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpcd/classification.cfm?deviceclass=&devicename=&implant_flag=&life_sustain_support_flag=&pagenum=500&panel=NE&productcode=&regulationnumber=&sortcolumn=productcode&start_search=1&submission_type_id=&summary_malfunction_reporting=&thirdparty=).
  Again, these are category references—not copied product designs.
- FDA 510(k) summary describing cranial plates/screws used after craniotomy,
  cranioplasty, or craniectomy:
  [K192162](https://www.accessdata.fda.gov/cdrh_docs/pdf19/K192162.pdf).

The audit intentionally does not prescribe puncture technique, device size,
catheter compatibility, pressure, aspiration time, number of passes, drill
trajectory, head-clamp force, incision, surgical corridor, hemostatic agent,
closure method, EVD target, or drainage height. Those are clinician- and
device-specific decisions outside a patient-education asset kit.

## Existing 110-record duplicate audit

### Existing endovascular and room assets

These assets already cover broad concepts and must not be rebuilt under a new
name unless the new package has a documented semantic/detail delta.

| Existing asset | Keep / replace rule |
|---|---|
| `patient_supine_generic` | Reuse as patient context. It is not a positioning or anesthesia specification. |
| `angiography_operating_table` | Reuse. No collision envelope or load rating is encoded. |
| `angiography_c_arm` | Reuse as generic fluoroscopy context. Do not copy a commercial biplane system. |
| `vital_sign_monitor` | Reuse; display must be explicitly synthetic and non-diagnostic. |
| `iv_pole_and_bag` | Reuse as room context, not as a medication claim. |
| `clinical_team_generic` | Reuse as non-identifying staff context. |
| `arterial_access_site` | Already includes a simplified introducer-sheath/guidewire cue. Any v3 access kit must be a semantic close-up or component expansion, not a duplicate in the same shot. |
| `catheter_body_to_brain_route` | Reuse as a conceptual path. It is not an anatomical centerline or approved access plan. |
| `guidewire_microcatheter_set` | Prototype delivery set. Prefer the detailed v2 individual assets for inspection; never co-load overlapping close-ups. |
| `guidewire_educational_v2` | Existing generic guidewire inspection asset; no new guidewire is needed. |
| `microcatheter_educational_v2` | Existing generic microcatheter inspection asset; no new microcatheter is needed. |
| `aspiration_catheter_educational_v2` | Existing generic large-bore aspiration-catheter concept. |
| `stent_retriever_educational_v2` | Existing generic deployed retrieval-lattice concept. |
| `thrombectomy_device_set_educational_v2` | Aggregate replacing the four individual v2 device close-ups while active. |
| `stent_retriever` | Prototype in-route cue. Do not show with the v2 inspection copy at the same registration/scale. |
| `aspiration_catheter` | Prototype alternative route. Do not imply simultaneous aspiration and retrieval unless a clinician-approved combined-technique explanation explicitly requires it. |
| `angiography_contrast_flow` | Existing qualitative before/after vessel-filling cue. It is not contrast dose, flow, radiation, or perfusion data. |

### Existing open-cranial and hemorrhage assets

| Existing asset | Keep / replace rule |
|---|---|
| `ich_hematoma` | Generic pathology context, never a surgical-selection engine. |
| `edema_swelling` | Generic mass-effect cue, not an ICP or tissue-mechanics model. |
| `scalp_incision_flap` | Existing non-graphic exposure state; do not create a second scalp flap. |
| `craniotomy_bone_flap` | Existing removable-flap state. Do not replace it at closure when the branch is labelled decompressive craniectomy. |
| `cranial_drill_generic` | Existing stylized motor/handpiece. New drilling assets should add generic attachments or a tray, not another overlapping motor. |
| `suction_and_forceps` | Existing combined instrument concept. New separate suction or forceps close-ups replace this package while active. |
| `scalp_closure_sutures` | Existing non-graphic closure state. |
| `dural_patch` | Existing optional repair/expansion concept; not universal. |
| `minimally_invasive_evacuator_port` | Existing separate minimally invasive hemorrhage branch. Never relabel as an aspiration thrombectomy catheter. |
| `optional_evd_system` | Existing optional EVD concept. Any detailed EVD package must replace it, not duplicate it. |
| `postoperative_head_dressing` | Existing procedure-specific recovery prop. Prohibited after ordinary EVT. |
| `spatial_step_markers` | Existing generic sequence markers; app-owned state labels are preferred for branch-dependent stage counts. |

### Anatomy/context that tools may reference but never modify

- V2 neck-access arteries and cerebral arteries may provide educational route
  context, but no generic catheter path is a patient centerline.
- V2 clot and arterial flow overlays may supply narrative state changes, but
  they cannot validate device engagement or reperfusion.
- V3 cortical, deep-nuclear, white-matter, cranial-nerve, and micro packages are
  anatomy/teaching layers. Tools must not cut, deform, collide with, or derive
  a safe corridor from them.
- `brain_ventricles_v2` or `ventricular_spaces_v3` may be displayed beside an
  EVD explanation only after a separately authored, clinician-reviewed
  transform. Atlas overlap is not a catheter target.

## Missing tool categories: endovascular thrombectomy

The following categories add meaningful stage detail without rebuilding the
existing guidewire, microcatheter, aspiration catheter, or stent retriever.
Suggested IDs are generic naming targets; final manifests must record the
actual build IDs and hashes.

| Priority | Suggested generic package | Stage | Purpose and non-claim |
|---:|---|---|---|
| 1 | `vascular_access_ultrasound_probe_educational_v3` | EVT-02 | Optional access-site localization prop. No live ultrasound image, target, needle guidance, or access recommendation. |
| 1 | `arterial_access_needle_dilator_sheath_educational_v3` | EVT-02 | Component close-up completing the existing simplified access-site cue. No gauge/French size, puncture angle, side, or compatibility claim. |
| 1 | `guide_balloon_guide_catheter_educational_v3` | EVT-03 to EVT-06 | Generic proximal support/flow-control category shown as a technique variant. No balloon volume, pressure, vessel-fit, or protection claim. |
| 1 | `diagnostic_angiography_catheter_educational_v3` | EVT-03 to EVT-04 | Generic diagnostic catheter and hub. No named curve, anatomy fit, or injection specification. |
| 1 | `contrast_injector_manifold_educational_v3` | EVT-04 and EVT-07 | External injector/manifold/tubing cue for angiographic checks. No contrast agent, concentration, volume, flow rate, pressure, timing, or radiation claim. |
| 1 | `aspiration_pump_tubing_canister_educational_v3` | EVT-06B/06C | External aspiration source, tubing, and collection canister supporting the existing aspiration catheter. No vacuum, pressure, clot-capture, sterility, or compatible-system claim. |
| 1 | `access_site_hemostasis_compression_educational_v3` | EVT-08 | Generic manual/compression-style post-access cue. No closure-device, compression-time, ambulation, or complication claim. |
| 2 | `hemostatic_valve_flush_line_educational_v3` | EVT-03 to EVT-06 | Optional rotating-hemostatic-valve/flush-line context. No fluid, drug, pressure, air-management, or connector compatibility claim. |
| 2 | `neurointerventional_sterile_tray_educational_v3` | EVT-01 | Organizational tray for detached props only. It does not define a complete sterile pack or institutional setup. |
| 3 | `radiation_shielding_context_educational_v3` | EVT-01 to EVT-07 | Room-context shielding/PPE cue. It must not calculate or imply radiation dose or safe positioning. |

No device-specific geometry is needed. In particular, do not copy proprietary
distal-tip shapes, braid/weave counts, pump housings, screens, button layouts,
connector keying, logos, colors strongly associated with a brand, exact
dimensions, package inserts, or CAD downloaded from manufacturers.

## EVT stage and activation map

| Stage | Required visible context | Optional tool categories | Deactivate / prohibit |
|---|---|---|---|
| `EVT-00_SELECTION` | Synthetic CT/CTA/MR narrative or simple scan card; existing monitor context | None of the invasive tools | All catheter/device tools off. No automatic eligibility decision. |
| `EVT-01_SUITE_SETUP` | Patient, angiography table, C-arm, monitor, team | Sterile tray, radiation shielding | All open-cranial tools off. Distal devices remain on inspection tray or hidden. |
| `EVT-02_ARTERIAL_ACCESS` | Existing access-site cue | Ultrasound probe; needle/dilator/sheath close-up | Intracranial retrieval states off. Do not depict a required femoral or radial site unless the reviewed lesson specifies one. |
| `EVT-03_GUIDE_ACCESS` | Existing conceptual body-to-brain route | Diagnostic catheter; guide/balloon-guide variant; valve/flush line | No clot engagement. No head opening. |
| `EVT-04_BASELINE_ANGIOGRAPHY` | C-arm plus qualitative contrast-flow overlay | Injector/manifold | No claim that the overlay is measured angiography, perfusion, or radiation. |
| `EVT-05_DISTAL_DELIVERY` | One reviewed kinematic route cue | Existing guidewire + microcatheter; proximal guide category | Retrieval lattice and suction state remain off until the technique variant is selected. |
| `EVT-06A_STENT_RETRIEVER` | Existing stent-retriever concept and clot cue | Proximal guide category | Aspiration-only action hidden. Combined support may be enabled only by the explicit combined variant. |
| `EVT-06B_CONTACT_ASPIRATION` | Existing aspiration-catheter concept and clot cue | Aspiration pump/tubing/canister | Deployed stent-retriever action hidden. |
| `EVT-06C_COMBINED` | Existing retriever + aspiration categories under one reviewed narration | Pump/tubing/canister; proximal guide | Do not infer superiority, compatibility, or simultaneous timing from spatial overlap. |
| `EVT-07_VERIFICATION` | Qualitative post-treatment angiography/flow cue | Injector/manifold | Retrieval action and magnified clot-engagement close-up off. No automatic reperfusion score. |
| `EVT-08_WITHDRAWAL_HEMOSTASIS` | Access site | Generic compression/hemostasis cue | All intracranial device instances withdrawn/hidden. Open-cranial recovery props remain off. |
| `EVT-09_POST_PROCEDURE` | Monitor and non-procedural recovery context | None from this tool expansion | **No craniotomy, scalp closure, EVD, or head dressing in ordinary EVT.** |

`EVT-06A`, `EVT-06B`, and `EVT-06C` are explicit variants, not automatically
ordered stages. A reviewed lesson may compare them, but it must reset the scene
between variants and must not imply that every patient receives all three.

## Missing tool categories: conditional open-cranial / hemorrhage branch

| Priority | Suggested generic package | Stage | Purpose and non-claim |
|---:|---|---|---|
| 1 | `neurosurgical_head_holder_educational_v3` | OPEN-01 | Generic positioning context. No pin placement, force, radiolucency, fixation, or patient-suitability claim. |
| 1 | `scalpel_marker_incision_set_educational_v3` | OPEN-02 | Detached scalpel/marker/ruler-like orientation props. No incision path, blade choice, or measurement claim. |
| 1 | `scalp_hemostasis_bipolar_clip_set_educational_v3` | OPEN-02 | Generic scalp clips and bipolar-forceps context. No energy, vessel sealing, clip count, or hemostatic efficacy. |
| 1 | `periosteal_elevator_soft_tissue_retractor_educational_v3` | OPEN-02 | Exposure-tool categories. No force, tissue plane, or retraction duration. |
| 1 | `cranial_perforator_burr_craniotome_set_educational_v3` | OPEN-03 | Attachments/detail supplementing the existing generic drill handpiece. No speed, torque, geometry, auto-disengagement, trajectory, or safe-stop claim. |
| 1 | `manual_bone_rongeur_educational_v3` | OPEN-03 | Generic bone-edge/decompression category. No bite force, removal extent, or operative instruction. |
| 1 | `dural_hook_scissors_educational_v3` | OPEN-04 | Generic dural-opening instrument categories. No opening pattern, trajectory, or anatomy clearance. |
| 1 | `microsurgical_illumination_educational_v3` | OPEN-04 to OPEN-06 | Generic microscope/light context. No optical magnification, filter, field, illumination, or navigation claim. |
| 1 | `bipolar_forceps_generator_educational_v3` | OPEN-05 to OPEN-06 | Generic bipolar handpiece/cable/generator context. No energy or coagulation setting. |
| 1 | `suction_irrigation_tubing_canister_educational_v3` | OPEN-05 to OPEN-06 | External support for the existing suction concept. No pressure, flow, irrigation fluid, evacuation rate, or tissue-removal physics. |
| 1 | `neurosurgical_patties_hemostasis_set_educational_v3` | OPEN-05 to OPEN-06 | Generic protective/absorbent pad and hemostasis-placement cues. No material, drug, absorbency, retained-item, or efficacy claim. |
| 1 | `cranial_fixation_plate_screw_set_educational_v3` | OPEN-07A | Generic bone-flap fixation category used only when the reviewed branch replaces the flap. No implant material, size, screw torque, or suitability claim. |
| 2 | `closure_needle_holder_stapler_set_educational_v3` | OPEN-07 | Generic closure-instrument context complementing the existing sutured closure state. No closure pattern, staple count, or wound-care instruction. |
| 2 | `evd_catheter_drainage_set_detailed_educational_v3` | OPEN-EVD | Optional semantic replacement for `optional_evd_system`. No target, insertion path, depth, drainage height, pressure reading, or management instruction. |
| 3 | `stereotactic_navigation_pointer_educational_v3` | OPEN-01/05 | Optional navigation category only if a reviewed lesson needs it. Never align it to generic atlas anatomy as if registered. |

Avoid modelling a commercial surgical microscope, drill console, clamp, powered
instrument attachment, cranial plate pattern, bipolar generator UI, navigation
screen, or evacuator system. Original generic silhouettes are sufficient.

## Open-cranial stage and activation map

The open-cranial root defaults to unloaded. It may load only when
`workflowBranch == openCranialHemorrhage` and
`clinicalSelectionConfirmed == true`.

| Stage | Required visible context | Optional tool categories | Deactivate / prohibit |
|---|---|---|---|
| `OPEN-00_SELECTION` | Hemorrhage/edema context plus reviewed clinical narration | None | All open tools off; never infer surgery from hematoma size rendered by a generic asset. |
| `OPEN-01_POSITION_PREP` | OR table/patient/team | Head holder; sterile setup; optional navigation category | Endovascular thrombectomy tools off. Clamp pins must not visibly penetrate or claim fixation. |
| `OPEN-02_SCALP_EXPOSURE` | Existing non-graphic scalp-flap state | Scalpel/marker set; scalp clips/bipolar; elevator/retractor | Bone/dural/tissue-removal actions off. |
| `OPEN-03_BONE_ACCESS` | Existing bone-flap concept or decompressive-craniectomy state | Existing drill plus perforator/burr/craniotome attachments; rongeur | No procedural cutting simulation. `craniotomyReplace` and `decompressiveLeaveOff` are mutually exclusive. |
| `OPEN-04_DURAL_ACCESS` | Applicable dura state | Dural hook/scissors; illumination | Existing educational scalp/skull cutaway must not be relabelled as an operative opening. |
| `OPEN-05A_OPEN_EVACUATION` | Clinician-selected open evacuation context | Existing suction/forceps or its detailed replacements; bipolar; patties; illumination | MIS evacuator port hidden. No tissue deformation, corridor, or evacuation-completeness claim. |
| `OPEN-05B_MINIMALLY_INVASIVE_EVACUATION` | Existing `minimally_invasive_evacuator_port` | Optional illumination/navigation context only if reviewed | Open craniotomy instrument action hidden. Keep distinct from EVT aspiration. |
| `OPEN-05C_DECOMPRESSION` | Clinician-selected decompressive state | Bone-access tools only as stage recap | Do not promise hematoma removal or outcome. Do not replace the bone flap in the same closure state. |
| `OPEN-06_HEMOSTASIS_INSPECTION` | Static open-state context | Bipolar; suction/irrigation; patties | No simulated bleeding rate, coagulation energy, or success metric. |
| `OPEN-07A_CRANIOTOMY_CLOSURE` | Dural closure/patch if applicable; bone flap replaced; existing scalp closure | Generic plates/screws; needle holder/stapler | Prohibited if approach variant is decompressive craniectomy. |
| `OPEN-07B_CRANIECTOMY_CLOSURE` | Dural/scalp closure as reviewed; bone flap remains absent | Closure tools; dressing | Bone-flap fixation off. Do not call this a craniotomy closure. |
| `OPEN-EVD_OPTIONAL` | EVD explanation plus reviewed ventricular registration | Existing EVD or detailed replacement | Never universal, never auto-triggered, never shown as an ordinary EVT step. |
| `OPEN-08_POSTOPERATIVE` | Branch-appropriate recovery state | Existing head dressing only when applicable | Active drills, cutting tools, open dura, and intravascular devices off. |

The AHA/ASA ICH guideline's intervention recommendations and uncertainty must
be reflected in narration: open evacuation, minimally invasive evacuation,
decompression, and EVD are conditional choices, not an inevitable linear
sequence. Cerebellar hemorrhage and hydrocephalus have distinct considerations;
the app must not collapse them into a generic supratentorial lesson.

## Parallel candidate-build alignment

The baseline duplicate audit above covers the 110 records that existed when
this audit started. Two parallel builders subsequently reported the following
stable candidate IDs. They are **not counted in the audited 110**, and their
appearance here does not certify geometry, USD validation, RealityKit loading,
licensing, clinical review, or release readiness. The IDs are recorded so the
README, MASTER, Houdini stage map, and runtime state machine can use one naming
contract after their separate QA is complete.

### Endovascular candidate set — 10 components plus two review assemblies

| Candidate ID | Audit mapping |
|---|---|
| `vascular_access_needle_educational_v3` | EVT-02 access component; complements, then replaces the overlapping close-up portion of `arterial_access_site`. |
| `vascular_access_wire_educational_v3` | EVT-02 short access-wire category; distinguish from the v2 intracranial guidewire by stage metadata and do not stack the close-ups. |
| `introducer_sheath_dilator_set_educational_v3` | EVT-02 access component; no French size or compatibility. |
| `guide_catheter_hemostatic_valve_educational_v3` | EVT-03 proximal support and valve category; no balloon-performance or connector claim. |
| `aspiration_pump_canister_tubing_educational_v3` | EVT-06B/06C external support for the existing v2 aspiration catheter; no pressure/flow simulation. |
| `contrast_manifold_syringe_flush_educational_v3` | EVT-04/07 external angiography support; no contrast, pressure, dose, or injection settings. |
| `torque_device_y_connector_accessories_educational_v3` | EVT-03/05 accessory context; no compatibility or torque-transmission claim. |
| `puncture_site_hemostasis_options_educational_v3` | EVT-08 qualitative alternatives; no closure recommendation or compression time. |
| `sterile_endovascular_instrument_tray_educational_v3` | EVT-01 detached organization view; explicitly incomplete and institution-neutral. |
| `angiography_suite_controls_educational_v3` | EVT-01/04/07 generic controls; must not copy commercial screens, layouts, labels, or dose displays. |
| `vascular_access_setup_review_assembly_v3` | Review-only replacement view for needle, access wire, sheath/dilator, and puncture-site hemostasis components. |
| `endovascular_tools_workflow_review_assembly_v3` | Review-only comparison of all ten endovascular components; it encodes no procedure and excludes the access assembly and all components while active. |

The manifest fields `used_before` and `used_after`, if retained by the builder,
must be interpreted only as an authored educational association. Runtime code
must use the gated stages in this audit and must not turn those fields into
operative instructions or a claim that every tool is required.

### Open-cranial candidate set — 12 components plus two review assemblies

| Candidate ID | Audit mapping |
|---|---|
| `surface_marking_ruler_set_open_neurosurgery_v3` | OPEN-01 orientation context; ruler markings/dimensions are non-calibrated. |
| `scalpel_dissector_set_open_neurosurgery_v3` | OPEN-02 non-graphic tool recognition; no incision/dissection technique. |
| `scalp_retractor_hemostat_set_open_neurosurgery_v3` | OPEN-02 exposure/hemostasis categories; no force, tissue, or clamp claim. |
| `perforator_craniotome_system_open_neurosurgery_v3` | OPEN-03 supplement/replacement detail for `cranial_drill_generic`; avoid a coincident second drill motor. |
| `bone_flap_fixation_set_open_neurosurgery_v3` | OPEN-07A only; prohibited when `boneClosure=decompressiveLeaveOff`. |
| `dural_scissors_hooks_forceps_set_open_neurosurgery_v3` | OPEN-04 generic dural instruments; no opening pattern or corridor. |
| `bipolar_forceps_irrigation_set_open_neurosurgery_v3` | OPEN-05A/06; no energy, temperature, flow, sealing, or efficacy. |
| `suction_microdissector_set_open_neurosurgery_v3` | OPEN-05A/06; replaces overlapping `suction_and_forceps` close-up while active. |
| `brain_spatula_retractor_set_open_neurosurgery_v3` | OPEN-05A generic recognition only; never animate pressure or derive a safe corridor. |
| `microscope_microinstrument_tray_open_neurosurgery_v3` | OPEN-04/05A detached tray; it is not an operating-microscope model or a complete instrument set. |
| `dural_closure_suture_patch_set_open_neurosurgery_v3` | OPEN-07 branch-appropriate closure; does not replace the existing patient closure state by itself. |
| `conditional_csf_access_instrument_set_open_neurosurgery_v3` | OPEN-EVD optional close-up; replaces `optional_evd_system` while active and stays outside both review assemblies. |
| `cranial_access_tools_review_assembly_open_neurosurgery_v3` | Review-only replacement for the five surface/exposure/bone-access component sets. |
| `intradural_closure_tools_review_assembly_open_neurosurgery_v3` | Review-only replacement for six dural/intradural/closure component sets; intentionally excludes conditional CSF access. |

The open candidate manifest's gate
`clinician_selected_hemorrhage_or_decompression_only` is consistent with this
audit. The `brain_spatula_retractor` and conditional CSF categories require
particularly conservative patient-facing narration because generic placement
could otherwise look like surgical guidance.

## Canonical scene parents

Preserve the established top-level `MASTER.md` ownership and extend it as
follows:

```text
StrokeExperienceRoot
└── ExperiencePlacementRoot
    ├── EnvironmentRoot
    ├── PatientContextRoot
    │   ├── HeadRegisteredRoot
    │   ├── LegacyHeadRoot
    │   │   └── OpenCranialRoot
    │   │       ├── PositioningRoot
    │   │       ├── ExposureRoot
    │   │       ├── BoneAccessRoot
    │   │       ├── DuralAccessRoot
    │   │       ├── EvacuationRoot
    │   │       ├── HemostasisRoot
    │   │       ├── ClosureRoot
    │   │       └── OptionalEVDAdjunctRoot
    │   └── ProcedureToolRoot
    │       └── EndovascularToolRoot
    │           ├── AccessSupportRoot
    │           ├── GuideSupportRoot
    │           ├── ImagingSupportRoot
    │           ├── DeliveryRoot
    │           ├── RetrievalRoot
    │           └── AccessHemostasisRoot
    ├── DeviceInspectionRoot
    └── SpatialGuidanceRoot
```

- Room-scale injector, aspiration console, microscope, generators, stands, and
  shielding may be physically parented under `EnvironmentRoot`, but the
  procedure state owner remains the relevant branch root.
- Detached close-ups belong under `DeviceInspectionRoot`, never on the patient
  path. A magnified close-up requires a persistent scale label.
- In-patient tool poses belong under `ProcedureToolRoot/EndovascularToolRoot` or
  `OpenCranialRoot`, never both.
- Open-cranial content stays under `LegacyHeadRoot` until a documented,
  landmark-reviewed registration to the v2 head exists.

## State gates and prohibited combinations

Release code must enforce all of the following:

```text
assert not (evtBranch.active and openCranialBranch.active)
assert not (evtBranch.active and postoperative_head_dressing.visible)
assert not (evtBranch.active and optional_evd_system.visible)
assert not (evtBranch.active and craniotomy_bone_flap.visible)
assert not (evtBranch.active and scalp_incision_flap.visible)
assert not (evtTechnique == aspirationOnly and stentRetrieverAction.visible)
assert not (evtTechnique == stentRetrieverOnly and aspirationAction.visible)
assert not (openApproach == minimallyInvasive and openEvacuationAction.visible)
assert not (boneClosure == decompressiveLeaveOff and boneFlapFixation.visible)
assert not (optionalEVD.visible and not clinicalEVDSelectionConfirmed)
assert not (magnifiedInspectionRoot.visible and registeredPatientToolInstance.sameEntity)
```

Additional rules:

- `thrombectomy_device_set_educational_v2` excludes its four component close-up
  assets.
- V1 delivery/retrieval prototypes and their v2 inspection equivalents are
  alternatives, not co-registered layers.
- A new detailed access kit replaces the device children in
  `arterial_access_site` for a close-up; it may coexist only when the original
  is reduced to non-overlapping body context.
- A detailed EVD package replaces `optional_evd_system` while active.
- A detailed open suction/forceps set replaces `suction_and_forceps` while
  active.
- `cranial_drill_generic` may parent a new attachment variant; a new package
  must not introduce a second coincident drill motor.
- Bone-flap fixation is valid only for a clinician-reviewed branch that replaces
  the flap. A decompressive craniectomy closure must leave it absent.
- A rare conversion from EVT to emergency surgery must be a new, explicit
  clinician-selected `rescueOpenCranial` branch. It is never inferred from a
  generic complication animation.

## Scale, appearance, and material cues

All exported stages remain Y-up with `metersPerUnit = 1`.

| Domain | Examples | Display contract |
|---|---|---|
| `room_context_real_world` | C-arm, table, injector stand, aspiration console, microscope | Approximate real-world staging only. No working clearance, service envelope, electrical, load, or dose claim. |
| `handheld_generic_real_world` | Head holder, hand instruments, access kit, hemostasis tools | Plausible scale and grip only; no exact dimensions, ergonomics, force, or compatibility. |
| `intravascular_generic_real_world` | Guide catheter, diagnostic catheter, wire/catheter route | Preserve actual-scale intent where visible; use highlight or cutaway, not silent enlargement. |
| `magnified_device_inspection` | Distal tips, stent lattice, catheter wall/marker details | Detached beside the patient with persistent **“Magnified generic teaching model — not patient/device specific”** label. Never register the enlarged copy to a vessel. |
| `open_surgical_inspection` | Burr/perforator, scissors, plates/screws, patties | Detached tray view; any enlargement explicitly labeled. |

Material cues are visual semantics only:

- Stainless/surgical-metal concepts: restrained neutral metal, medium/high
  roughness, no mirror-like finish, grade, passivation, coating, or sterilization
  claim.
- Nitinol-like retrieval lattice: neutral metallic cue; do not name an alloy or
  encode radial force, shape memory, fatigue, braid count, or vessel fit.
- Catheter/polymer bodies: simple opaque or lightly tinted PBR with generic
  reinforcement and radiopaque-marker cues. Do not claim PTFE, PVP, Pebax,
  hydrophilic coating, durometer, trackability, or fluoroscopic visibility.
- Silicone/rubber-like tubing and seals: generic elastomer look only.
- Cranial fixation: muted metallic plate/screw cue; no titanium/PEEK claim unless
  a source-backed, separately reviewed educational label says only that such
  materials exist as categories.
- Absorbent patties/hemostasis cues: off-white soft surface. Do not depict blood
  saturation as a measured volume or imply a hemostatic drug/product.
- Use a subtle active-tool outline or app-owned highlight; do not make clinical
  status depend on material color alone.
- No trademarks, logos, proprietary colorways, copied screens, package labels,
  or recognizable commercial housings.

## Collision and physics boundary

This tool expansion is limited to **static or authored kinematic educational
motion**.

- Anatomy: static; optional coarse input/selection colliders only.
- Room equipment: static or kinematic with coarse presentation bounds. A clear
  animation does not establish a safe equipment clearance.
- Guidewires and catheters: curve-driven kinematic poses baked from reviewed
  presentation paths. No Cosserat rod, wire, friction, buckling, torque,
  pushability, trackability, wall-contact, perforation, dissection, embolization,
  or force model.
- Retriever deployment/withdrawal: explicit visibility or blend-shape states.
  No radial force, clot integration, vessel deformation, fragment capture, or
  pass-success simulation.
- Aspiration: pump/tubing/canister animation and flow arrows are symbolic. No
  pressure, vacuum, fluid dynamics, clot mechanics, blood loss, emboli, or
  efficacy calculation.
- Contrast: qualitative vessel-filling overlay only; no injection, mixing,
  perfusion, radiation, nephrotoxicity, or dose model.
- Drilling/cutting/rongeur/scissors: authored approach/withdraw poses only. No
  Boolean cutting at runtime, fracture, heat, swarf, dura-stop, torque, force,
  or trajectory safety.
- Retraction/head holding: static context or small kinematic placement only. No
  pin penetration, clamp force, tissue pressure, ischemia, or collision-derived
  safety.
- Suction/irrigation/evacuation: symbolic visibility changes between authored
  pathology states. No tissue removal, pressure, bleeding, lavage, deformation,
  or completeness metric.
- Bipolar/hemostasis: state highlight only. No electrical, thermal, sealing, or
  coagulation solver.
- EVD: static/kinematic catheter and chamber explanation only. No catheter
  trajectory, CSF hydrodynamics, ICP, leveling, drainage height, waveform, or
  infection model.

Physics collisions may support tap targets, gross keep-out narration, or stage
triggers. They must never select a device, approve a path, infer anatomical
contact, calculate force, or decide a clinical outcome.

## Houdini / Solaris handoff slots

Use the established layered-USD approach and keep source geometry immutable.
USDZ is a final delivery package, not the working scene or a volume-cache
container.

```text
00_source_payloads.usdc
10_registration.usda
20_tool_placement.usda
30_lookdev.usda
40_procedure_states.usda
50_kinematic_clips.usda
60_warnings_and_labels.usda
90_release_flattened.usdc
```

Recommended payload slots:

| Solaris slot | Canonical target | Content |
|---|---|---|
| `/World/ProcedureTools/Endovascular/AccessSupport` | `AccessSupportRoot` | Ultrasound/access kit and access-site close-up variant |
| `/World/ProcedureTools/Endovascular/GuideSupport` | `GuideSupportRoot` | Diagnostic/guide catheter and valve/flush support |
| `/World/ProcedureTools/Endovascular/ImagingSupport` | `ImagingSupportRoot` | Injector/manifold; qualitative contrast-cue references |
| `/World/ProcedureTools/Endovascular/Delivery` | `DeliveryRoot` | Existing wire/microcatheter routed instances |
| `/World/ProcedureTools/Endovascular/Retrieval` | `RetrievalRoot` | Existing retriever/aspiration variants and external pump |
| `/World/ProcedureTools/Endovascular/AccessHemostasis` | `AccessHemostasisRoot` | Post-access compression/hemostasis cue |
| `/World/OpenCranial/Positioning` | `PositioningRoot` | Head-holder and optional navigation context |
| `/World/OpenCranial/Exposure` | `ExposureRoot` | Scalpel, clips/bipolar, elevator/retractor, scalp state |
| `/World/OpenCranial/BoneAccess` | `BoneAccessRoot` | Existing drill motor, attachment variants, rongeur, bone-flap state |
| `/World/OpenCranial/DuralAccess` | `DuralAccessRoot` | Dural instruments and illumination |
| `/World/OpenCranial/Evacuation` | `EvacuationRoot` | Open or MIS evacuation variant tools |
| `/World/OpenCranial/Hemostasis` | `HemostasisRoot` | Bipolar, suction/irrigation, patties |
| `/World/OpenCranial/Closure` | `ClosureRoot` | Dura/patch, bone-flap/fixation variant, scalp closure tools |
| `/World/OpenCranial/OptionalEVD` | `OptionalEVDAdjunctRoot` | Existing or replacement EVD, loaded only by explicit gate |

Required variant sets:

```text
workflowBranch = { anatomyOnly, ischemicEVT, openCranialHemorrhage }
evtTechnique = { none, stentRetriever, contactAspiration, combined }
evtAccessSupport = { simplifiedExisting, detailedGeneric }
openApproach = { none, openEvacuation, minimallyInvasive, decompressive }
boneClosure = { notApplicable, craniotomyReplace, decompressiveLeaveOff }
evdState = { off, clinicianSelected }
inspectionScale = { oneToOne, labelledMagnified }
```

Author stage timing and branch transitions in `40_procedure_states.usda` or in
application data, not by destructively modifying tool payloads. Use references
for small always-needed props and payloads for stage-specific trays/consoles.
Keep `clinicalGate`, `educationalOnly`, `patientSpecific=false`,
`deviceSpecific=false`, `magnificationLabelRequired`, `scaleDomain`, source,
licence, and review status as machine-readable metadata.

## Machine-state event contract

Every tool state transition should emit a semantic event rather than a device
command:

```text
procedure.stage.entered
procedure.stage.exited
procedure.variant.selected
tool.category.shown
tool.category.hidden
warning.scale.presented
warning.educational.presented
clinical.gate.confirmed
```

Do not expose events named `device.success`, `path.safe`, `reperfusion.achieved`,
`hematoma.evacuated`, `hemostasis.complete`, or `evd.correct` because the scene
has no validated evidence for those determinations.

## Clinical, medical-device, and licence gates

All new props must be labelled and manifested as:

- `intended_use = generic patient education / design review only`
- `patient_specific = false`
- `device_specific = false`
- `clinical_review_status = REQUIRES_SPECIALIST_REVIEW`
- `physics_status = STATIC_OR_KINEMATIC_ILLUSTRATIVE_ONLY`
- `not_for = diagnosis, eligibility determination, treatment planning,
  navigation, device choice/sizing, training competency, informed-consent
  replacement, or outcome prediction`

Before any patient-facing pilot, the complete experience requires specialist
review by appropriate stroke/neurointerventional/neurosurgical clinicians,
human-factors/usability evaluation, readability and distress review,
institutional privacy/security governance, accessibility review, build-locked
content/version control, and a regulatory assessment for the intended use.

Manufacturer/FDA pages may inform a generic category audit but are not asset
licences. Permitted geometry sources are original project modelling or sources
with verified licences compatible with the repository and intended
distribution. Maintain per-file source URLs, author, licence text, attribution,
modification notes, and hashes. Exclude any model whose provenance, commercial
use, redistribution, ShareAlike obligations, or medical-device branding rights
are unclear.

Hospital or clinician review does not convert the generic models into cleared
medical devices. Do not use the terms FDA-approved, FDA-cleared, validated,
clinically accurate, surgical grade, compatible, safe, sterile, patient matched,
or hospital ready for these assets.

## Release checklist for the future tool packages

1. Every ID is unique against all 110 existing build records.
2. The manifest describes the semantic/detail delta for any package overlapping
   an existing access, drill, suction, forceps, EVD, or device concept.
3. Ordinary EVT screenshots and automated tests contain zero open-cranial
   assets and zero postoperative head dressing.
4. Open-cranial screenshots state that the branch is conditional and
   clinician-selected.
5. Aspiration-only, retriever-only, and combined EVT variants pass mutual-
   exclusion tests.
6. Craniotomy replacement and decompressive-craniectomy leave-off closure
   variants pass mutual-exclusion tests.
7. Optional EVD stays off unless the explicit clinical gate is true.
8. Actual-scale and magnified inspection instances are separate entities; the
   magnified warning remains visible for the entire close-up.
9. No copied CAD, logos, proprietary UI, exact dimensions, or compatibility
   table appears in geometry, textures, metadata, README text, or previews.
10. All animation is static/kinematic and all unsupported physics claims are
    explicitly absent.
11. USD validation, RealityKit loading, bounds, semantic-child, preview, hash,
    licence, and clinical-review checks pass for the exact release binaries.
12. The release README and MASTER describe tool use as a stage-specific
    educational category, never as operational instructions.

## Audit conclusion

The existing kit already contains the core room scene, endovascular path,
guidewire, microcatheter, aspiration catheter, stent retriever, basic cranial
drill, suction/forceps, bone flap, closure, EVD, and head dressing. The most
useful expansion is therefore **support equipment and semantically separated
instrument categories**, not another copy of the same core devices.

Build the endovascular support set around access, proximal support, angiography,
aspiration support, and access-site hemostasis. Build the open-cranial set around
positioning, exposure, bone/dural access, hemostasis, and branch-correct closure.
Keep the two sets under separate state roots with hard exclusions. That produces
a more complete patient-education sequence without falsely turning generic
geometry into a procedural guide or device simulation.
