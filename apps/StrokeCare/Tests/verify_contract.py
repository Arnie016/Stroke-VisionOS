#!/usr/bin/env python3
"""Static product-contract checks; not device, wearer, or clinical proof."""

import hashlib
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
failures: list[str] = []


def require(condition: bool, message: str) -> None:
    if not condition:
        failures.append(message)


def swift_string_array(source: str, name: str) -> list[str]:
    match = re.search(
        rf"private static let {name}: \[String\] = \[(.*?)\n    \]",
        source,
        re.DOTALL,
    )
    require(match is not None, f"catalog array {name} is missing")
    return re.findall(r'"([^\"]+)"', match.group(1)) if match else []


state = (ROOT / "Sources" / "StrokeExperienceState.swift").read_text()
deck = (ROOT / "Sources" / "StrokeControlDeck.swift").read_text()
app = (ROOT / "Sources" / "StrokeTimeApp.swift").read_text()
launch = (ROOT / "Sources" / "StrokeJourneyLaunchView.swift").read_text()
print_request = (ROOT / "Sources" / "StrokeTeachingModelPrintRequestView.swift").read_text()
scene = (ROOT / "Sources" / "StrokeSceneFactory.swift").read_text()
immersive = (ROOT / "Sources" / "StrokeImmersiveView.swift").read_text()
model_board = (ROOT / "Sources" / "StrokeModelBoardView.swift").read_text()
catalog = (ROOT / "Sources" / "StrokeAssetCatalog.swift").read_text()
project_yml = (ROOT / "project.yml").read_text()
readme = (ROOT / "README.md").read_text()
houdini = (ROOT / "Docs" / "HOUDINI_STROKE_PIPELINE.md").read_text()
clinical_packet = (ROOT / "Docs" / "ISCHEMIC_STROKE_CLINICAL_REVIEW.md").read_text()
houdini_builder = (ROOT / "Scripts" / "build_houdini_stroke_graph.py").read_text()
xcat_deploy = (ROOT / "Scripts" / "deploy_xcat.zsh").read_text()
xcat_stage_collect = (ROOT / "Scripts" / "collect_xcat_stage_placement.zsh").read_text()
xcat_acceptance = (ROOT / "Proof" / "XCAT_ACCEPTANCE.md").read_text()
internal_root = (ROOT / "../../../Stroke-VisionOS-inside-brain-rd/Experiments/RBCJourneyVision").resolve()
internal_model = (internal_root / "Sources/RBCJourneyModel.swift").read_text()
internal_hud = (internal_root / "Sources/RBCJourneyHUD.swift").read_text()
internal_scene = (internal_root / "Sources/RBCJourneyScene.swift").read_text()
internal_immersive = (internal_root / "Sources/RBCJourneyImmersiveView.swift").read_text()
spatial_prelude = (ROOT / "Sources" / "StrokeSpatialPreludeView.swift").read_text()
imaging_workspace = (ROOT / "Sources" / "StrokeTeachingImagingWorkspaceView.swift").read_text()
reference_workspace = (ROOT / "Sources" / "StrokeReferenceWorkspaceView.swift").read_text()
imaging_import_session = (ROOT / "Sources" / "StrokeImagingImportSession.swift").read_text()

step_contract = state.split("enum StrokeProcedureStep", 1)[1].split("enum StrokePresenterTeachingBeat", 1)[0]
require(all(case in step_contract for case in ("case chooseCase", "case inspectOcclusion", "case discussCare")), "three-step procedure is incomplete")
require(step_contract.count("\n    case ") == 3, "procedure must remain exactly three steps")
require(all(token in internal_model for token in (
    "enum RBCInternalSystemLayer",
    "case cortex",
    "case vessels",
    "case deepStructures",
    "case ventricles",
    "case neuralActivity",
    "visibleSystemLayers",
    "toggleSystemLayer",
    "focusedSystemLayer",
    "exploreFocusedInternalSystem",
)), "integrated interior systems-lens state is incomplete")
require(all(token in internal_hud for token in (
    '"BRAIN STORY',
    '"COMPARE',
    'Button("Previous", systemImage: "chevron.left")',
    'Button("Next", systemImage: "chevron.right")',
    'model.selectInternalSystemStoryChapter(layer)',
    'model.activeRegionDestination != model.focusedSystemLayer.destination',
    'Button("Open \\(model.focusedSystemLayer.compactTitle)", systemImage: "arrow.up.right")',
    'Button("Brain overview", systemImage: "square.grid.2x2")',
    'model.familyNarrationEnabled ? "Stop voice" : "Hear this chapter"',
    'Label("Anterior ↔ Posterior  ·  Superior ↑  ·  Inferior ↓  ·  Left / Right"',
    'Text("Generic teaching layers · neural activity is schematic · not a patient scan")',
)), "internal systems lens lacks visible controls or teaching boundary")
exhibit_hud = internal_hud.split("struct RBCExhibitInfoHUD", 1)[1].split("struct RBCExhibitControlsHUD", 1)[0]
require(
    "Choose a region below to explore a system" in exhibit_hud
    and "RBCInternalSystemsCompactHUD()" not in exhibit_hud
    and ".glassBackgroundEffect" not in exhibit_hud,
    "the default inside-brain story still reads as a stacked control window instead of a spatial cue",
)
region_hud_contract = internal_hud.split("struct RBCRegionInfoHUD", 1)[1].split("private struct RBCRegionModeButton", 1)[0]
require(
    ".glassBackgroundEffect" not in region_hud_contract
    and ".background(.black.opacity(0.72)" not in region_hud_contract,
    "inside-brain lessons regressed into a central glass window",
)
require(
    all(token in spatial_prelude for token in (
        "let visibleCount = [1, 2, 4, 9][stage]",
        "for index in 0..<48",
        "beatStartedAt",
    ))
    and ".id(introBeat)" in launch
    and ".windowStyle(.plain)" in app,
    "the opening story lacks transparent presentation or staged neural growth",
)
fictional_case_contract = state.split("struct StrokeFictionalCase", 1)[1].split("enum StrokeEnvironmentMode", 1)[0]
require(
    fictional_case_contract.count('.init(id: "F-') == 12
    and "selectedFictionalCaseIndex" in state
    and "stepFictionalCase(by delta: Int)" in state
    and "StrokeFictionalCase.library.indices" in scene
    and "spatialCaseIndex(for entity: Entity)" in scene
    and 'Button("Use this file", systemImage: "arrow.up.right")' in immersive,
    "doctor intake does not expose twelve selectable fictional dossiers",
)
fictional_portraits = sorted(
    (ROOT / "Resources" / "Assets.xcassets" / "FictionalCases").glob(
        "FictionalCasePortrait*.imageset/FictionalCasePortrait*.png"
    )
)
require(
    len(fictional_portraits) == 12
    and len({path.name for path in fictional_portraits}) == 12
    and "portraitAssetName" in fictional_case_contract
    and "FictionalCasePortrait" in immersive
    and "ScrollView(.horizontal)" in immersive
    and "Original fictional portrait · no patient identity" in immersive,
    "fictional case browser is missing its twelve original portrait assets or spatial portrait rail",
)
require(
    "await fictionalCasePortraitMaterial" in scene
    and "TextureResource(" in scene
    and 'portrait.name = "fictional-case-portrait-' in scene
    and "await StrokeSceneFactory.makeSpatialCaseIntake()" in immersive,
    "world-space dossiers still use placeholder surfaces instead of authored fictional portrait textures",
)
require(all(token in internal_scene for token in (
    'neuralActivityRoot.name = "schematic-neural-activity-lens-not-cellular-simulation"',
    "buildNeuralActivityLens()",
    "updateNeuralActivityLens(",
    "buildVentricularSystemRegionInterior",
    'ventricular-continuity-guide-not-csf-flow-or-pressure',
    "updateVentricularSystemRegion(",
)), "schematic internal neural-activity animation is incomplete")
presenter_beat_contract = state.split("enum StrokePresenterTeachingBeat", 1)[1].split("struct PlacedStrokeQuestion", 1)[0]
require(all(case in presenter_beat_contract for case in (
    "case confirmContext",
    "case discussAccess",
    "case protectiveCovering",
    "case explainPurpose",
    "case teamChecks",
    "case explainClosure",
)), "clinician six-beat teaching sequence is incomplete")
require(presenter_beat_contract.count("\n    case ") == 6, "presenter teaching sequence must remain exactly six nested beats")
detail_contract = catalog.split("enum StrokeDetailLevel", 1)[1].split("enum StrokeAssetFamily", 1)[0]
require(all(case in detail_contract for case in ("case calm", "case guided", "case scholar")), "presentation detail levels are incomplete")
require(detail_contract.count("\n    case ") == 3, "detail level must remain a three-state presentation filter")
require(all(token in detail_contract for token in (
    'case .calm: "minimal"',
    'case .guided: "reduced80"',
    'case .scholar: "full"',
    'case .calm: "Simplified"',
    'case .guided: "Standard"',
    'case .scholar: "Full"',
)), "three-tier visual-detail binding is incomplete")
catalog_groups = {
    "v1": swift_string_array(catalog, "v1PrototypeIDs"),
    "v2_core": swift_string_array(catalog, "v2CoreIDs"),
    "v2_head": swift_string_array(catalog, "v2HeadDetailIDs"),
    "v2_vascular": swift_string_array(catalog, "v2CranialVascularIDs"),
    "v2_flow": swift_string_array(catalog, "v2BloodFlowIDs"),
    "v2_devices": swift_string_array(catalog, "v2DeviceIDs"),
    "v3_cranial": swift_string_array(catalog, "v3CranialDetailIDs"),
    "v3_neural": swift_string_array(catalog, "v3NeuralDetailIDs"),
    "v3_micro": swift_string_array(catalog, "v3MicroTeachingIDs"),
    "v3_endovascular": swift_string_array(catalog, "v3EndovascularToolIDs"),
    "v3_open_cranial": swift_string_array(catalog, "v3OpenCranialToolIDs"),
}
v1_catalog_ids = catalog_groups["v1"]
v2_catalog_ids = sum((ids for key, ids in catalog_groups.items() if key.startswith("v2_")), [])
v3_catalog_ids = sum((ids for key, ids in catalog_groups.items() if key.startswith("v3_")), [])
release_catalog_ids = v1_catalog_ids + v2_catalog_ids + v3_catalog_ids
release_catalog_digest = hashlib.sha256(
    ("\n".join(sorted(release_catalog_ids)) + "\n").encode()
).hexdigest()
held_catalog_ids = swift_string_array(catalog, "heldSourceBuildIDs")
require((len(v1_catalog_ids), len(v2_catalog_ids), len(v3_catalog_ids)) == (29, 36, 69), "PR #8 family counts are not 29/36/69")
require(len(release_catalog_ids) == len(set(release_catalog_ids)) == 134, "release catalog must contain exactly 134 unique IDs")
require(release_catalog_digest == "92db33954c08e9a2f6879072a92e7f969a66beddbcf3f848a7cf79147b37271a", "release catalog IDs drifted from audited PR #8 head")
require(set(held_catalog_ids) == {"middle_inner_ear_bilateral_v3", "cranial_support_registered_assembly_v3"}, "two held source-build IDs are not kept separate")
require(not set(held_catalog_ids).intersection(release_catalog_ids), "held source-build IDs leaked into the 134 release records")
require(all(token in catalog for token in ("auditedPullRequestHead = \"12728df2e856897a44df2bbfbe01236f8b142303\"", "nonV1CandidateCount = 105", "candidateMetadata", "quarantinedPrototype", "heldSourceBuildRecords")), "catalog provenance or release gates are incomplete")
require(all(token in catalog for token in ("StrokeAssetLane", "StrokeAssetFrameDomain", "StrokeAssetReviewGate", "StrokeAssetBundleStatus", "StrokeAssetLoadStatus")), "catalog routing/status metadata is incomplete")
require("Entity.load" not in catalog and "loadBundledUSDZ" not in catalog and "ModelEntity" not in catalog, "static catalog must not load scene assets")
require(all(token in catalog for token in (
    'branch = "codex/three-tier-visual-detail-assets"',
    'head = "6127cf38f500c2f2d6975df2d6cc945f526e08af"',
    "physicalUSDZCount = 150",
    "virtualBindingCount = 450",
    "runtimeGeometryIncluded = false",
)), "audited 150-source / 450-binding visual-detail snapshot is incomplete")
require(all(token in app for token in (
    'WindowGroup(id: StrokeSpace.imaging, for: String.self)',
    'StrokeTeachingImagingWorkspaceView()',
    'static let imaging = "stroke-teaching-imaging"',
    'CommandLine.arguments.contains("--proof-imaging-window")',
    'CommandLine.arguments.contains("--proof-imaging-window-term-note")',
    'CommandLine.arguments.contains("--proof-imaging-ct")',
    'CommandLine.arguments.contains("--proof-imaging-mri")',
    '.onAppear { experience.prepareTeachingImagingProof() }',
)), "moveable generic teaching-imaging window is incomplete")
imaging_workspace = (ROOT / "Sources/StrokeTeachingImagingWorkspaceView.swift").read_text()
require(all(token in imaging_workspace for token in (
    'case ctGuide = "CT (X-ray)"',
    'case ctaGuide = "CT angiography"',
    'case mriGuide = "MRI"',
    'case mraGuide = "MR angiography"',
    'case petOverview = "PET overview"',
    '"Open research atlas · generic teaching reference · not a patient scan or result',
    'X-RAY-BASED CT TEMPLATE',
    'MRI TEMPLATE',
    '"CT angiography (CTA)"',
    '"MR angiography (MRA)"',
    '"positron emission tomography (PET)"',
    'StrokeTeachingImagingReferenceDetails',
    'CommandLine.arguments.contains("--proof-imaging-ct")',
    'CommandLine.arguments.contains("--proof-imaging-mri")',
    'CommandLine.arguments.contains("--proof-imaging-window-term-note")',
    'referenceDetailsVisible ? 620 : 470',
)), "moveable imaging reference must distinguish generic CT/MRI/CTA/MRA/PET teaching views from patient imaging")
workspace_term_note = imaging_workspace.split("struct StrokeTeachingImagingWorkspaceView", 1)[1].split("@ViewBuilder", 1)[0]
require(
    'Label("SOURCE NOTE", systemImage: "doc.text.magnifyingglass")' in workspace_term_note
    and 'if !referenceDetailsVisible {' in workspace_term_note
    and 'onReturnToStudy:' in workspace_term_note
    and 'closeTermNote()' in workspace_term_note
    and 'private func returnToAnatomy()' in workspace_term_note
    and 'referenceDetailsVisible = false' in workspace_term_note,
    "the optional imaging window can leave a source note open or duplicate its local return action",
)
require(all(token in immersive for token in (
    'Button("Open 2D reference", systemImage: "rectangle.on.rectangle")',
    'experience.placeSpatialImagingPlate(.ctGuide)',
    'experience.toggleSpatialImagingFocus()',
    'not a patient image',
)), "clinician imaging handoff is incomplete")
declared_usdz_paths = re.findall(r"- path: ([^\n]+\.usdz)", project_yml)
require(len(declared_usdz_paths) == 34 and len(set(declared_usdz_paths)) == 34 and "asset_manifest" not in project_yml, "runtime asset slice must contain exactly thirty-four unique explicit USDZ resources")
require(
    len({Path(path).name for path in declared_usdz_paths}) == 34
    and all((ROOT / path).resolve().exists() for path in declared_usdz_paths),
    "every explicit USDZ resource must exist and have a unique bundle basename",
)
require(all(name in project_yml for name in (
    "brain_deep_structures_v2.usdz",
    "brain_ventricles_v2.usdz",
    "cerebral_bloodflow_animation_v2.usdz",
    "dural_sinuses_jugulars_realistic_v2.usdz",
    "circle_of_willis_flow_overlay_v2.usdz",
    "external_head_scalp_cutaway_v2.usdz",
    "eyes_context_realistic_v2.usdz",
    "scalp_access_closure_registered_conceptual_v1.usdz",
    "cranial_bone_access_closure_registered_conceptual_v1.usdz",
    "dural_access_closure_registered_conceptual_v1.usdz",
    "intracerebral_hematoma_registered_conceptual_v1.usdz",
    "cerebral_edema_registered_conceptual_v1.usdz",
    "thrombectomy_device_set_educational_v2.usdz",
)), "required detail/context, registered conceptual access, and educational device assets are not declared in the app bundle")
require(all(token in catalog for token in (
    "dural_sinuses_jugulars_realistic_v2",
    "circle_of_willis_flow_overlay_v2",
    "external_head_scalp_cutaway_v2",
    "eyes_context_realistic_v2",
    "twenty-two catalogued exterior resources",
)), "registered-v2 detail/context references are not recorded in the explicit bundle catalog")
third_party_notices = (ROOT / "Resources/THIRD_PARTY_NOTICES.txt").read_text()
require("THIRD_PARTY_NOTICES.txt" in project_yml and "Z-Anatomy" in third_party_notices and "BodyParts3D" in third_party_notices and "ShareAlike" in third_party_notices and "HRA Skin" in third_party_notices and "Visible Human eye context" in third_party_notices, "required atlas attribution and ShareAlike notice is not bundled")
require(all(token in immersive for token in (
    'Text("GENERIC VENOUS ATLAS · COLOUR CONVENTION · REVIEW PENDING")',
    'Text("ATLAS · Z-ANATOMY + BODYPARTS3D · CC BY-SA")',
    "Atlas sources: Z-Anatomy and BodyParts3D, Creative Commons Attribution ShareAlike.",
    "experience.anatomyFocus == .vessels",
)), "visible venous reference does not surface its review boundary and atlas attribution")
require(all(token in state for token in ("detailLevel: StrokeDetailLevel = .calm", "selectedCatalogAssetID", "selectDetailLevel", "selectCatalogAsset", "resetCatalogPresentation")), "detail selection/reset state is incomplete")
require("guard audienceLens == .clinician || level == .calm" in state and "lane.isFamilyRestricted" in catalog and "self == .legacyQuarantine || self == .openCranialTools" in catalog, "family calm/open-cranial boundary is incomplete")
require("StrokeJourneyLaunchView()" in app and "StrokeControlDeck()" not in app, "dashboard is still the default experience")
require(all(token in app for token in (
    'WindowGroup(id: StrokeSpace.printRequest, for: String.self)',
    '"--proof-print-request"',
    'StrokeTeachingModelPrintRequestView',
)), "generic teaching-model request is not wired as a dedicated review surface")
require(all(token in print_request for token in (
    'Text("Prepare a teaching model")',
    'Text("NOT AN ORDER")',
    'Label("Generic teaching anatomy only"',
    'No patient scans, identifiers, treatment planning, or device claims are included.',
    'Shipping and manufacturing are not connected in this prototype.',
)), "teaching-model request does not preserve its local-only, non-patient, non-order boundary")
require("ImmersionStyle = .progressive" in app, "progressive immersion is not the default")
require("StrokeImmersiveView(immersionStyle: $immersionStyle)" in app and ".mixed, .progressive, .full" in app, "three deliberate system immersion styles are not wired")
require(all(mode in state for mode in ('case surroundings', 'case warmHorizon', 'case focusField')), "three-state spatial environment contract is missing")
require('environmentMode: StrokeEnvironmentMode = .focusField' in state and 'case focusField = "Black focus"' in state, "the default presenter environment is not the clean black focus state")
require('func preparePresenterControlsProof()' in state and 'requestedPause = true' in state.split('func preparePresenterControlsProof()', 1)[1].split('\n    }', 1)[0], "presenter-control proof does not hold the explicit Resume state")
require("Choose your way in." in launch and "Curious learner" in launch and "Doctor presenter" in launch and "enterSpatialCaseRoom" in launch, "plain-language role-separated spatial threshold is missing")
require("beginPatientExploration" in state and "if lens == .family" in launch, "patient/family anatomy exhibit does not bypass the doctor case library")
require(".disabled(true)" not in launch and "Open the calm, generic anatomy discovery experience" in launch, "the patient/family route is still locked behind the retired live-demo gate")
require(
    len(re.findall(r"private func (?:enterSpatialCaseRoom|enterStory).*?dismissWindow\(id: StrokeSpace\.evidence\)", launch, re.DOTALL)) == 2,
    "a fresh role or case-story entry can retain a stale clinical-evidence window",
)
require("audienceLens == .family, familyClarityWasSet" in state and "Let’s slow down." in state and "Pause, ask a question" in state, "family self-reported clarity does not adapt the visible teaching copy")
require("experience.audienceLens == .family ? 360 : 410" in immersive and "minHeight: experience.audienceLens == .clinician ? 300 : 336" in immersive, "family and clinician conversation rails lack their readable spatial footprints")
require("var selectedFamilyQuestionAnswer: String?" in state and "Only a boundary action opens a clarification card" in state and "does not measure flow, identify a diagnosis, or predict an outcome" in state, "family exploration boundary does not produce a bounded, authored clarification")
require("if let answer = experience.selectedFamilyQuestionAnswer" in immersive and "WHY THIS VIEW MATTERS" in immersive and "Plain-language answer:" in immersive, "family rail does not surface the selected exploration's plain-language answer")
require("--proof-case-unfold" in launch and "prepareCaseHistoryWebProof" in launch, "current room-scale case-unfold proof route is missing")
require(
    "--proof-role-choice" in launch
    and 'subtitle: "Discover the brain at your own pace"' in launch
    and 'subtitle: "Guide a careful family conversation"' in launch,
    "role choice does not explain the Family and Doctor journeys",
)
spatial_prelude = (ROOT / "Sources" / "StrokeSpatialPreludeView.swift").read_text()
require(all(token in launch for token in (
    "StrokeSpatialPreludeView",
    'Button("Skip story")',
    "for target in 1...4",
    "introLineReveal",
    "introActionTitle",
    '"See cortical columns"',
    '"See signalling networks"',
    '"See another scale"',
    '"Choose a path"',
    "introActionHint",
    '"The brain is not one object."',
    '"There is always another scale."',
    '"Conceptual teaching anatomy · not a patient scan"',
    "--proof-spatial-prelude",
    "--proof-spatial-prelude-hero",
)), "wonder-first spatial prelude is not skippable, bounded, or deterministically routable")
require(all(token in spatial_prelude for token in (
    'Model3D(named: "brain_anatomy_realistic_v2")',
    "conceptualWholeBrain",
    "PreludeBrainShape",
    "PreludeVesselShape",
    "PreludeCorticalColumn",
    "neuronNetwork",
    "reduceMotion",
)), "spatial prelude does not cover whole-brain, vessel, cortical-column, and neuron scales")
require("caseReviewRevealProgress" in state and "startCaseReviewReveal" in state, "dossier-to-history reveal state is missing")
require(
    "paused: experience.spatialPhase != .explanation" in immersive,
    "case library and review still drive the display-rate animation timeline",
)
require(
    "let anatomyVisible = experience.spatialPhase == .explanation" in immersive
    and "if anatomyVisible {" in immersive
    and "StrokeSceneFactory.update(" in immersive,
    "hidden anatomy is still mutated while the patient-file rooms are active",
)
require(
    "caseReviewRevealTask = Task" in state
    and "self.caseReviewRevealProgress =" in state,
    "case-review unfolding is no longer state-driven while the timeline is paused",
)
require(state.count("guard audienceLens == .clinician") >= 6, "patient-file intake must remain clinician-only at the state boundary")
require(all(token in state for token in (
    "guard audienceLens == .clinician, spatialPhase == .caseReview else { return }",
    "guard audienceLens == .clinician,\n              spatialPhase == .caseReview",
    "guard audienceLens == .clinician else { return }\n        cancelCaseReviewReveal()",
)), "case selection, explanation entry, or library return can bypass the doctor-presenter boundary")
require('audienceLens == .family ? "Restart exhibit" : "Return to cases"' in state and "reset()\n                beginPatientExploration()" in state, "family closing can leak into the doctor-only case archive")
require(all(token in immersive for token in (
    "SpatialCaseFact(milestone: .everydayContext)",
    "SpatialCaseFact(milestone: .reportedChange)",
    "SpatialCaseFact(milestone: .teamReview)",
    "SpatialCaseFact(milestone: .sharedQuestions)",
    "experience.selectCaseHistoryMilestone(\n                milestone,\n                reduceMotion: reduceMotion",
    ".hoverEffect(.highlight)",
    "transaction.disablesAnimations = true",
)), "every visible case-history endpoint must be directly selectable and respect Reduce Motion")
require("hospital protocol" in launch and "Presenter rail" in launch, "emergency accountability boundary is missing")
require(all(route in launch for route in ("--proof-orient", "--proof-pressure", "--proof-care-purpose")), "deterministic spatial proof routes are missing")
require('id: "CASE-078"' in state and 'displayName: "Case 78"' in state, "fictional case contract is missing")
require("No patient data" in deck and "FICTIONAL" in deck, "privacy boundary is not visible")
require("Severe large-territory ischemic stroke with swelling" in state, "single severe-stroke scenario frame is missing")
require("This model shows one severe stroke affecting one side of the brain." in state, "family orient wording is not versioned")
require("In this severe stroke, swelling builds inside the fixed skull." in state, "family pressure wording is not scenario-specific and versioned")
require("Surgery can make room for swelling. It cannot undo the stroke injury." in state, "family procedure-purpose wording is not conditional and versioned")
require("not a recommendation, consent discussion, or outcome promise" in state.lower(), "clinical decision boundary is missing")
require("not diagnosis, recommendation, consent, or record" in state, "discussion summary overclaims its role")
require("brain-left" in scene and "brain-right" in scene and "brain-midline-seam" in scene, "separable brain rig is missing")
require("brain_anatomy_realistic_v2" in scene and "cerebral_arteries_realistic_v2" in scene and "ischemic_mca_clot_v2" in scene, "PR2 v2 hero anatomy is not integrated")
require(all(token in scene for token in (
    'importedDeepStructuresName = "brain_deep_structures_v2"',
    'importedVentriclesName = "brain_ventricles_v2"',
    'importedBloodflowName = "cerebral_bloodflow_animation_v2"',
    'importedFlowOverlayName = "circle_of_willis_flow_overlay_v2"',
    'qualitativeFlowOverlayLayerName = "anatomy-qualitative-flow-overlay-layer"',
    "startAuthoredBloodflowAnimations",
    "animation.repeat()",
    "experience.pointField == .regions",
    'hasPrefix(\n                "clinician-procedure-point-field-point-"',
    "experience.requestedPause || reduceMotion",
    "qualitative teaching cues—not CFD",
    "qualitativeFlowOverlayLayer?.isEnabled = showsAuthoredBloodflow",
    "procedure-point selection",
    'flowMarkerRootName = "registered-teaching-imaging-flow-markers"',
    "Seven upstream markers approach the teaching blockage",
    "isPaused: experience.requestedPause || reduceMotion",
    "updateQualitativeFlowMarkers",
    "Float((time * 0.18).truncatingRemainder(dividingBy: 1))",
)), "registered detail layers are not role/lesson/pause gated or recursively animated")
require(all(token in scene for token in (
    'importedVenousName = "dural_sinuses_jugulars_realistic_v2"',
    'venousLayerName = "anatomy-venous-layer"',
    "registeredVenousReviewStateName",
    "experience.audienceLens == .clinician",
    "experience.detailLevel >= .guided",
    "experience.spatialPhase == .explanation",
    "experience.pointField == .regions",
    "venousLayer?.isEnabled = showsVenousReference",
    "Blue/purple is an educational convention",
)), "registered-v2 venous reference is not explicitly role/detail gated or review bounded")
require("imported-brain-surface-target" in scene and "generateSphere(radius: 0.112)" in scene, "semantic imported brain collision target is missing")
require("imported-clot-focus-target" in scene and "isAnatomyInteractionTarget" in scene, "semantic clot interaction target is missing")
require("legacy-v1-pressure-root" in scene and "craniotomy_bone_flap" in scene and "dural_patch" in scene, "PR2 pressure-purpose assets are not segregated")
require("loadBundledUSDZ" in scene and "procedural-stroke-fallback" in scene, "imported-asset fallback loader is missing")
require(all(token in scene for token in (
    "calibrateRegisteredBrainMaterials",
    "calibrateRegisteredBrainMaterials(brain)",
    "if name == importedBrainName",
    "pbr.roughness = .init(floatLiteral: 0.52)",
    "pbr.blending = .opaque",
    "pbr.readsDepth = true",
    "pbr.writesDepth = true",
)), "registered brain material calibration does not preserve a solid PBR teaching surface")
require(all(token in immersive for token in (
    "focusRimLightID",
    '"stroke-focus-rim-light"',
    "intensity: 760",
    "experience.environmentMode == .focusField",
)), "Black focus field is missing its restrained PBR silhouette-rim treatment")
require(all(token in scene for token in (
    "calibrateRegisteredVesselMaterials",
    "calibrateRegisteredVesselMaterials(arteries)",
    "name == importedArteriesName || name == importedVenousName",
    "pbr.clearcoatRoughness = .init(floatLiteral: 0.52)",
)), "registered vessel material calibration is missing its light-responsive generic-tissue finish")
require(all(token in scene for token in (
    "requiredCoreAnatomyNames",
    "importedBrainName",
    "importedArteriesName",
    "importedClotName",
    "importedDuraName",
    "guard missingRequired.isEmpty else",
    "Registered anatomy incomplete; using procedural fallback",
    "SIMPLIFIED TEACHING VIEW",
    "Detailed anatomy unavailable",
)), "partial registered-v2 loads can still masquerade as a complete teaching model")
require(all(flag in scene for flag in (
    "--proof-load-brain-only",
    "--proof-load-missing-arteries",
    "--proof-load-missing-clot",
    "--proof-load-missing-dura",
)), "required-asset failure-injection matrix is incomplete")
require("Bundled anatomy resource missing" in scene and "Bundled anatomy resource failed to load" in scene, "asset-load diagnostics do not identify missing or invalid resources")
require("catheter-review-preview" in scene and "medicine-review-preview" in scene, "care discussion previews are missing")
require(all(name in scene for name in ("fixed-skull-context", "bone-flap", "dura-expansion")), "pressure-purpose anatomy is missing")
require(all(name in scene for name in (
    "registered-care-purpose-story",
    "registered-care-purpose-aperture",
    "registered-care-purpose-protective-cover",
    "registered-care-purpose-expanding-room",
)), "registered family-safe Make-space purpose cues are missing")
require(
    "let showsPurposeReference = showsPurpose" in scene
    and "carePurposeStory?.isEnabled = showsPurposeReference && !isolateScholarSkull" in scene
    and "0.026 * reveal" in scene
    and "0.72 + 0.28 * reveal" in scene,
    "Make-space opening and expansion cues are not permission-controlled",
)
require(
    "imported.findEntity(named: importedFlapName)?.isEnabled = false" in scene
    and "imported.findEntity(named: importedPatchName)?.isEnabled = false" in scene,
    "prototype-v1 flap or patch escaped quarantine",
)
require(
    "--proof-family-make-space-purpose" in launch
    and "prepareFamilyMakeSpacePurposeProof" in state,
    "family Make-space purpose proof route is missing",
)
require("does not restore or shrink established injury" in scene, "non-restoration visual boundary is missing")
require("authored teaching motion" in scene and "not a patient measurement" in scene, "animation evidence boundary is missing")
require("TimelineView" in immersive and "focusOcclusion()" in immersive, "runtime spatial animation or focus gesture is missing")
require(all(color in immersive for color in (
    "Color(red: 0.50, green: 0.58, blue: 0.82)",
    "Color(red: 0.65, green: 0.63, blue: 0.85)",
    "Color(red: 0.95, green: 0.48, blue: 0.29)",
)), "Figma-derived cool-to-warm three-act timeline palette is missing")
require("Deep structures · ventricles · generic anatomy · review pending" in state and "Flow overlay + authored markers · qualitative · not CFD" in state, "clinician detail boundaries are not visible")
require("SpatialAudioComponent" in immersive and "FlowBed" in immersive and "PressureBed" in immersive, "entity-anchored spatial audio is missing")
require(
    "var soundEnabled = false" in state
    and "interactionFeedbackToken" in state
    and "func registerInteractionFeedback()" in state
    and "lastInteractionFeedbackAt" in state,
    "optional ambient sound or rate-limited sensory-feedback state is missing",
)
require(
    'experience.soundEnabled ? "Sound on" : "Sound off"' in launch
    and "if experience.soundEnabled {" in launch
    and ".onChange(of: experience.soundEnabled)" in launch
    and "prelude.stop()" in launch,
    "doorway ambience does not stay opt-in with a visible mute path",
)
require(
    "strokeSemanticSelectionFeedback(trigger: experience.interactionFeedbackToken)" in immersive
    and "#available(visionOS 26.0, *)" in state
    and "experience.registerInteractionFeedback()" in immersive,
    "meaningful immersive controls lack availability-gated system-managed semantic feedback",
)
require("Digital Crown" in immersive, "progressive immersion rationale is missing")
require("BillboardComponent" in immersive and "StrokeIntentionAnnotation" in immersive, "entity-anchored intention annotation is missing")
require("Capsule()" in immersive and "annotationTint.opacity(0.52)" in immersive, "free-standing annotation tether is missing")
require("let selectedPoint = experience.selectedPointEntityName.flatMap" in immersive and "selectedPoint.position(relativeTo: stageRoot)" in immersive, "selected point explanation is no longer spatially related to its anatomy point")
require("DragGesture" in immersive and "MagnifyGesture" in immersive, "Heart Field orbit/scale interaction pattern is missing")
require("resetSpatialView" in state and "Reset view" in immersive, "spatial reset is missing")
require("StrokeAnatomyViewpoint" in state and all(view in state for view in ("case threeQuarter", "case anterior", "case lateralA", "case lateralB", "case superior", "case inferior")), "named registered model-frame viewpoints are missing")
require("setAnatomyViewpoint" in state and "cycleAnatomyViewpoint" in state and "anatomyViewpoint = .free" in state and "SpatialViewpointDot" in immersive and "experience.setAnatomyViewpoint(viewpoints[nextIndex], reduceMotion: reduceMotion)" in immersive and '.accessibilityLabel("Anatomy viewpoint")' in immersive, "named views and direct free-orbit handoff are not wired into the quiet viewpoint control")
require(all(token in immersive for token in (
    '"EXPLAIN THIS"',
    'Text("SETTINGS")',
    'Text("VISUAL DETAIL")',
    'viewpointControlID = "spatial-viewpoint-control"',
    '.threeQuarter, .anterior, .lateralA, .lateralB, .superior, .inferior',
    'private func advanceViewpoint()',
    'detailStepButton(',
    'experience.cycleDetailLevel(by: offset)',
    'Text("Optional geometry and motion only.")',
    'GENERIC VENOUS ATLAS · COLOUR CONVENTION · REVIEW PENDING',
)), "clinician scene lacks the quiet viewpoint dot, clarity checklist, or secondary presentation settings")
require('Text("VISUAL DETAIL · USER SELECTED")' not in immersive and 'private var clinicianLensControls' not in immersive, "visual detail remains in the explanation checklist instead of secondary settings")
require(all(route in launch for route in ("--proof-view-anterior", "--proof-view-lateral-a", "--proof-view-lateral-b", "--proof-view-superior", "--proof-view-inferior")), "deterministic anatomy-viewpoint proof routes are missing")
require("true medial view is intentionally not" in state, "single-surface anatomy is mislabeled as a medial view")
require("smoothedOrbit" in immersive and "smoothedZoom" in immersive, "Heart Field smoothing pattern is missing")
require("WorldTrackingProvider" in immersive and "queryDeviceAnchor" in immersive and "stroke-world-locked-stage" in immersive, "stage is not placed from a sampled device pose")
require("Samples the current device pose once" in immersive and "session.stop()" in immersive, "anatomy stage is continuously head-locked or tracking is not bounded")
require("stageRoot.addChild(root)" in immersive and "stageRoot.addChild(caseRoom)" in immersive and "relativeTo: stageRoot" in immersive, "brain, case archive, and annotation placement do not share one coherent stage frame")
require("stroke-stage-placement.json" in immersive and "PLACEMENT_PATH_RAN" in immersive and "raw room transform" in immersive, "physical placement path lacks a privacy-bounded machine receipt")
require(
    "#if targetEnvironment(simulator)" in immersive
    and "transform = nil" in immersive
    and "Keep deterministic proof routes in" in immersive,
    "Simulator stage placement can still inherit an invalid or zero device pose",
)
require("appDataContainer" in xcat_stage_collect and "anchorTracked == true" in xcat_stage_collect and "wearerEvidence == \"NOT_RUN\"" in xcat_stage_collect, "XCAT placement receipt cannot be collected with explicit proof boundaries")
require("careViewPermissionGranted" in state and "Reveal layers" in immersive, "non-graphic permission gate is missing")
require("layerRevealProgress" in state and "calm-layer-reveal-seam" in scene, "calm layer-separation animation is missing")
require("No incision or blood" in immersive, "patient-friendly layer reveal language is missing")
calm_shader = (ROOT / "Sources" / "CalmPaperFlowView.swift").read_text()
require("CalmFlowFieldFactory" in immersive and "not blood" in calm_shader, "calm environmental shader boundary is missing")
require("generateBox" in calm_shader and "UnlitMaterial" in calm_shader, "calm horizon must remain stable transparent RealityKit geometry")
require("targetOpacity" in calm_shader and "act: StrokeProcedureStep" in calm_shader, "three-act environmental modulation is missing")
require("LayerContextBreadcrumb" in immersive and "YOU ARE HERE" in immersive, "nested layer context is missing")
require("never infers emotion" in state and "Presenter rail" in launch, "clinician pace or inference boundary is missing")
require("presenterCue" in state and "presenterBoundary" in state and "presenterLayerStatus" in state, "precise presenter content is missing")
require("PRESENTER ONLY" in immersive and "clinicianPresenter" in immersive, "private presenter rail is missing")
require("StrokePointField" in state and "Brain regions" in state and "Blood flow" in state, "lesson point-field flavors are missing")
require(
    all(token in state for token in (
        '"Single neuron · schematic reference"',
        "prepareFamilyNeuronReferenceProof",
        "prepareFamilyNeuronPlainWordsProof",
        "Think of this as a tree-like brain cell",
        'case .neuron: "single neuron"',
        "selectedTeachingReferenceNeedsDrawer",
        "isSelectedNeuronSignalTraceActive",
    ))
    and all(token in scene for token in (
        "case neuron",
        'neuronRootName = "registered-teaching-imaging-single-neuron-schematic"',
        "makeSchematicNeuronReference()",
        "updateSchematicNeuronReference(",
        "neuronSignalPath",
        "neuronSignalGuideRootName",
        "emphasizeNeuronSignalPath",
        "single-neuron-schematic-signal-guide",
    ))
    and all(token in immersive for token in (
        "ONE NEURON · SCHEMATIC TEACHING VIEW",
        "Generic schematic · not to scale, patient tissue, or a recording",
        "experience.selectedTeachingReferenceNeedsDrawer",
        "experience.isSelectedNeuronSignalTraceActive",
    )),
    "point-led schematic neuron reference is missing its bounded spatial object",
)
require("StrokeAnatomyPresentation" in state and all(mode in state for mode in ('case assembled', 'case transparent', 'case exploded')), "reversible anatomy presentation modes are missing")
require("cortexOpacity" in state and "selectedPointEntityName" in state and "selectedPointLabel" in state, "transparent anatomy or point selection state is missing")
require("clinician-region-point-field" in scene and "clinician-procedure-point-field" in scene, "RealityKit point fields are missing")
require("regionPointDirections" in scene and "procedurePointPositions" in scene, "sparse spatial reference data is missing")
require("Example affected area" in scene and "Flow beyond the blockage changes" in scene, "intention-based point labels are missing")
require("experience.lessonPointsVisible" in scene and "experience.pointField" in scene, "point fields are not discoverable or switchable")
require("visualBounds(relativeTo: registered)" in scene and "* 1.025" in scene and "radius: 0.0036" in scene, "point fields are not derived from registered anatomy bounds at a precise readable scale")
require("clotSurfaceMarker" in scene and "bounds.max.z + 0.003" in scene and 'selectedPointEntityName = "clinician-procedure-point-field-point-2"' in state, "blockage marker is not bound to the registered clot surface or proof semantics disagree")
require("frontZ" not in scene and all(anchor in scene for anchor in ("[-0.028297, -0.142271, 0.010944]", "[-0.012158, -0.059836, 0.030163]", "[-0.043842, -0.014646, 0.029223]", "[-0.053607, -0.011508, 0.017754]")), "procedure markers still use a detached screen plane instead of registered-v2 mesh samples")
require("defaultLessonPointIndex" in state and "case .procedure: 2" in state and "index == experience.pointField.defaultLessonPointIndex" in scene, "Vessel Story does not default to its clot-bound marker")
require(all(layer in scene for layer in ("anatomy-cortex-layer", "anatomy-arteries-layer", "anatomy-blockage-layer", "anatomy-dura-layer")), "semantic sibling anatomy layers are missing")
require("OpacityComponent(opacity:" in scene and "anatomyPresentation" in scene and "approach(cortexLayer" in scene, "reversible opacity or exploded-layer rendering is missing")
require("isPointFieldInteractionTarget" in scene and "pointFieldSelection" in scene and "InputTargetComponent(allowedInputTypes: [.direct, .indirect])" in scene, "point fields are not directly targetable")
require("StrokeLessonPointTargetComponent" in scene and "point.components.set(StrokeLessonPointTargetComponent())" in scene and "generateSphere(radius: 0.0074)" in scene and "HighlightHoverEffectStyle" in scene and ".highlight(hoverStyle)" in scene, "point interaction affordance or pre-pinch focus feedback is missing")
require("AccessibilityComponent()" in scene and "accessibility.isAccessibilityElement = true" in scene and "accessibility.label" in scene and "accessibility.systemActions = [.activate]" in scene, "lesson points do not expose their authored identity as an accessible activation target")
require("setAnatomyPresentation" in immersive and "Brain transparency" in immersive and "selectedPointLabel" in immersive, "clinician layer-study controls are incomplete")
require("pointFieldSelection(for: value.entity)" in immersive and "selectPoint(entityName:" in immersive, "point pinch selection is not routed into shared state")
require("targetedToEntity(where: .has(StrokeLessonPointTargetComponent.self))" in immersive and "isEnabled: !experience.questionPlacementArmed" in immersive, "lesson-point pinch is not isolated from the anatomy proxy or annotation mode")
require("nearestVisiblePointFieldSelection" in scene and "nearestVisiblePointFieldSelection(" in immersive and "maximumDistance: Float = 0.036" in scene, "anatomy-proxy pinches do not resolve a nearby visible lesson point")
require("StrokeLessonPointTargetComponent.registerComponent()" in scene and "StrokeSceneFactory.registerCustomComponents()" in app, "lesson-point query component is not registered before scene construction")
require(
    "lessonPointOrbName" in scene
    and "let point = Entity()" in scene
    and "orb.scale = [pulse * emphasis" in scene,
    "lesson-point visual pulses are again scaling their collision targets",
)
require(
    "extendedMaximumDistance = max(maximumDistance, 0.085)" in scene
    and "minimumUnambiguousGap: Float = 0.024" in scene
    and "$0.distance - nearest.distance >= minimumUnambiguousGap" in scene
    and "guard isSingleAccessPoint || hasClearLead else { return nil }" in scene
    and "selectedBlockageExteriorZoom" in state
    and "selectedBlockageExteriorOrbit" in state
    and "spatialZoom = max(spatialZoom, isBlockagePoint ? Self.selectedBlockageExteriorZoom : 1.58)" in state,
    "far-side point acquisition is ambiguous or the selected-vessel close-up path is missing",
)
require(
    "wheel.components.set(BillboardComponent())" in immersive
    and "tools.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])" in immersive,
    "the clinician hand cuff or held tools can regress to a reversed orientation",
)
evidence = (ROOT / "Sources" / "StrokeEvidenceWorkspaceView.swift").read_text()
deck_canon = (ROOT / "Docs" / "REALITYKIT_DECK_TO_STROKECARE.md").read_text()
asset_triage = (ROOT / "Docs" / "ASSET_CATALOG_TRIAGE.md").read_text()
presentation_canon = (ROOT / "Docs" / "PRESENTATION_DESIGN_CANON.md").read_text()
product_map = (ROOT / "Docs" / "STROKE_CARE_PRODUCT_UI_MAP.md").read_text()
dcc_pipeline = (ROOT / "Docs" / "DCC_LAYER_STUDY_PIPELINE.md").read_text()
blender_builder = (ROOT / "Scripts" / "build_blender_layer_study.py").read_text()
blender_manifest = (ROOT / "TechnicalArt" / "Generated" / "StrokeLayerStudy.manifest.json").read_text()
require("StrokeEvidenceWorkspaceView()" in app and "StrokeSpace.evidence" in app, "upper evidence window is missing")
require('WindowGroup(id: StrokeSpace.window)' in app, "the primary launch scene must remain a restorable window group")
for singleton_scene in (
    'WindowGroup(id: StrokeSpace.family, for: String.self)',
    'WindowGroup(id: StrokeSpace.presenter, for: String.self)',
    'WindowGroup(id: StrokeSpace.evidence, for: String.self)',
    'WindowGroup(id: StrokeSpace.imaging, for: String.self)',
    'WindowGroup(id: StrokeSpace.printRequest, for: String.self)',
):
    require(singleton_scene in app, f"auxiliary scene is not value-keyed: {singleton_scene}")
for auxiliary_id in (
    "StrokeSpace.family",
    "StrokeSpace.presenter",
    "StrokeSpace.evidence",
    "StrokeSpace.imaging",
    "StrokeSpace.printRequest",
):
    require(f"WindowGroup(id: {auxiliary_id}) {{" not in app, f"auxiliary scene can still multiply: {auxiliary_id}")
require("Clinical evidence" in evidence and "Search sources" in evidence and "Pin in space" in evidence and "Compose draft" in evidence, "citation search, pin, and compose workflow is incomplete")
require("Return to anatomy" in evidence and "returnToExplanation()" in evidence and "dismissWindow(id: StrokeSpace.evidence)" in evidence, "evidence space lacks redundant, reliable return actions")
require("Restart at roles" in evidence and "restartAtRoles()" in evidence and "await dismissImmersiveSpace()" in evidence and "openWindow(id: StrokeSpace.window)" in evidence and ".onDisappear" in evidence, "evidence space lacks a stale-window recovery path")
require("SOURCE-BOUND TEACHING DRAFT" in evidence and "not approved clinical copy" in evidence, "generated evidence copy lacks its draft boundary")
require("fullCitation" in state and "stableURL" in state and "limitation" in state, "evidence sources lack immutable citation context")
require("Clinician upper evidence plane" in deck_canon and "never receives raw gaze" in deck_canon, "RealityKit deck learnings are not mapped to Stroke Care")
require("--proof-evidence" in launch and "prepareEvidenceProof" in state and "opensEvidence: true" in launch, "deterministic evidence-space proof route is missing")
require("--proof-evidence-window" in launch and "openEvidenceProofWindow" in launch, "isolated evidence-window proof route is missing")
require("--proof-layer-study" in launch and "prepareLayerStudyProof" in state, "deterministic anatomy layer-study proof route is missing")
require("--proof-procedure-field" in launch and "prepareProcedureFieldProof" in state, "deterministic procedure-point proof route is missing")
require("--proof-transparent-layer" in launch and "prepareTransparentLayerProof" in state, "deterministic transparent-anatomy proof route is missing")
require(all(route in launch for route in ("--proof-environment-surroundings", "--proof-environment-warm", "--proof-environment-focus")), "deterministic environment proof routes are missing")
require(
    "--proof-clinician-toolkit" in launch
    and "prepareClinicianToolKitProof" in state
    and "selectedClinicianTool = .endovascularSet" in state
    and "--proof-clinician-toolkit" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and '"--proof-clinician-toolkit": ("catheter set", "microcatheter")' in (ROOT / "Tests" / "verify_proof_image.py").read_text(),
    "deterministic clinician catheter-set proof route is missing",
)
require(
    "prepareClinicianToolKitFullProof" in state
    and "--proof-clinician-toolkit-full" in launch
    and "--proof-clinician-toolkit-full" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and '"--proof-clinician-toolkit-full": ("microcatheter", "full geometry")' in (ROOT / "Tests" / "verify_proof_image.py").read_text()
    and "geometryDisclosure(for detailLevel: StrokeDetailLevel)" in state
    and "applyClinicianDeviceDetail" in scene
    and 'loweredName.contains("braid")' in scene
    and 'loweredName.contains("lattice")' in scene
    and "detailLevel: experience.detailLevel" in immersive
    and "GEOMETRY ·" in immersive,
    "visual detail does not change the authored catheter submesh hierarchy",
)
require(
    "enum StrokeClinicianDeviceStudyBeat" in state
    and "advanceClinicianDeviceStudyBeat" in state
    and "prepareClinicianToolKitMotionProof" in state
    and "--proof-clinician-toolkit-motion" in launch
    and "--proof-clinician-toolkit-motion" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and '"--proof-clinician-toolkit-motion": ("microcatheter", "approach concept")' in (ROOT / "Tests" / "verify_proof_image.py").read_text()
    and "experience.clinicianDeviceStudyBeat" in immersive
    and "PINCH · NEXT BEAT" in immersive
    and "inspectionPosition.x -= 0.10 * easedPhase" in immersive
    and "sin(Float(time) * 0.45) * 0.52" in immersive,
    "the real catheter study is missing its reversible three-beat motion grammar",
)
require("--proof-scholar-skull" in launch and "prepareScholarSkullProof" in state, "deterministic Scholar skull proof route is missing")
require(all(token in state for token in (
    'scholarSkullCatalogID = "skull_semantic_realistic_v2"',
    "isClinicianScholarSkullInspectionActive",
    "audienceLens == .clinician",
    "detailLevel == .scholar",
    "selectedCatalogAssetID == Self.scholarSkullCatalogID",
    "selectDetailLevel(.scholar)",
    "selectCatalogAsset(id: Self.scholarSkullCatalogID)",
    "resetCatalogPresentation()",
)), "Scholar skull state is not exact-ID, clinician, and Scholar gated")
require(all(token in scene for token in (
    "let isolateScholarSkull = experience.isClinicianScholarSkullInspectionActive",
    "importedSkull != nil",
    "imported.findEntity(named: importedBrainName)?.isEnabled =",
    "!isolateScholarSkull && !showsInternalStudy",
    "imported.findEntity(named: importedArteriesName)?.isEnabled = !isolateScholarSkull &&",
    "imported.findEntity(named: importedClotName)?.isEnabled = !isolateScholarSkull &&",
    "let showsConceptualDura = !showsOpenCranialReview && !isolateScholarSkull && showsPurpose",
    "let showsClinicianSkullContext = isAccessStory",
    "[StrokePresenterTeachingBeat.discussAccess, .explainClosure]",
    "importedSkull?.isEnabled = !showsOpenCranialReview &&",
    "(isolateScholarSkull || showsClinicianSkullContext)",
    "showsClinicianSkullContext ? skullOffset : .zero",
    "experience.presenterTeachingBeat == .discussAccess ? 0.32 : 0.16",
    "no transform or exact",
)), "Scholar skull isolation does not restore the registered assembly or preserve the authored frame")
require(all(token in immersive for token in (
    "Two stable rows keep the common presenter actions glanceable",
    "LazyVGrid(",
    "GridItem(.fixed(80)",
    'experience.spatialInkVisible ? "Drawing" : "Ink"',
)), "normal presenter controls do not preserve the quiet two-by-four action grid")
require("REQUIRES_SPECIALIST_REVIEW" in state and "never presented as exact family anatomy" in state, "Scholar skull specialist/family safety boundary is missing")
require(all(token in state for token in (
    '"Generic cross-source skull"',
    '"Inspect shape only"',
    '"Specialist review pending"',
    "environmentMode = .surroundings",
)), "Scholar skull proof is missing its focused review cues or bright surroundings")
require(all(token in immersive for token in (
    '"SKULL · REGISTRATION REVIEW"',
    '"Generic cross-source teaching skull. Inspect shape only; alignment and landmarks still require specialist review."',
    "scholarSkullControls",
    "!experience.isClinicianScholarSkullInspectionActive",
)), "Scholar skull annotation does not expose the registration-review boundary")
require("--proof-spatial-intake" in launch and "makeSpatialCaseIntake" in scene, "deterministic room-scale case intake is missing")
simulator_proof = (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
proof_image_check = (ROOT / "Tests" / "verify_proof_image.py").read_text()
require(all(token in simulator_proof for token in (
    "--proof-spatial-intake",
    "--proof-pressure",
    "simctl install",
    "simctl launch --terminate-running-process",
    "simctl io",
    "kill -0",
    "verify_proof_image.py",
    "SIMULATOR_PROOF_BOUNDARY=render-and-process-only;not-wearer-or-clinical-proof",
)), "current Simulator route proof is not freshly installed, process-checked, captured, and bounded")
require(
    "simctl uninstall" in simulator_proof
    and ".onAppear { experience.audienceLens" not in app,
    "a restored Simulator companion can overwrite the proof route's chosen role",
)
require(all(token in simulator_proof for token in (
    "PROOF_LAUNCH_TIMEOUT_SECONDS",
    "launch exceeded",
    "Simulator shell may be unhealthy",
)), "Simulator proof launch can hang indefinitely instead of reporting an unhealthy shell")
require(all(token in proof_image_check for token in (
    "PROOF_IMAGE=FAIL",
    "empty-centre",
    "colourless-centre",
    "centre_nonblack_ratio",
    "centre_colour_ratio",
)), "Simulator proof images can pass while the spatial stage is blank")
patient_history = (ROOT / "Sources" / "PatientHistoryTimelineView.swift").read_text()
require("--proof-spatial-docked-case" in launch and "prepareSpatialDockedCaseProof" in state, "deterministic docked-case constellation proof is missing")
require(all(token in launch + state + immersive + patient_history for token in (
    "--proof-selected-case-handoff",
    "prepareSelectedCaseHandoffProof",
    "caseHistoryTimeLabel",
    "caseHistoryWebValue",
    "selectedFictionalCase.id",
    "selectedFictionalCase.displayName",
)), "the selected fictional dossier does not persist through review and anatomy handoff")
require("--proof-selected-case-handoff" in simulator_proof and '"f 168", "elena"' in proof_image_check, "selected-case handoff lacks a deterministic visual proof route")
require("spatialCaseFilePosition" in state and "settleSpatialCaseFile" in state and "isSpatialCaseFileTarget" in scene, "spatial case carry-and-dock loop is incomplete")
require("StrokeSpatialPhase" in state and "caseLibrary" in state and "caseReview" in state and "explanation" in state, "case room and anatomy are not separated into explicit phases")
require("root.isEnabled = anatomyVisible" in immersive and "caseRoom.isEnabled = experience.spatialPhase != .explanation" in immersive, "patient cabinet still persists into the brain explanation")
require("spatial-case-archive" in scene and "archive-dossier-bay" in scene and "[0.19, 0.25, 0.018]" in scene, "case library is not a single angled dossier archive with an upright selected file")
require("spatial-case-constellation" in scene and all(branch in scene for branch in (
    "case-constellation-filament-speech",
    "case-constellation-filament-arm",
    "case-constellation-filament-time",
    "case-constellation-filament-open-question",
)), "selected case does not unfold as a four-signal spatial constellation")
require("StrokeSceneFactory.spatialCaseArchiveName)?.isEnabled = inLibrary" in immersive and "StrokeSceneFactory.spatialCaseConstellationName)?.isEnabled = inReview" in immersive, "archive and case constellation do not hand off by phase")
require("SpatialCaseReviewActions" in immersive and "beginExplanation" in state, "selected-case review lacks an explicit explanation threshold")
require("updateSpatialCaseIntake" in scene and "smoothSegment" in scene and "selectedCaseHistoryMilestone" in scene, "selected history branch does not unfold from the dossier")
require("caseReviewActionsID, [0, 1.58" in immersive and "OpacityComponent(opacity: inReview ? 1 - dissolve : 1)" in immersive, "case card dissolve or selected dossier centerpiece is missing")
require("PatientHistoryTimelineView" in immersive and 'caseHistoryTimelineID = "spatial-case-history-timeline"' in immersive, "case review lacks a distinct spatial patient-history timeline")
require("StrokeCaseHistoryMilestone" in patient_history and "selectedCaseHistoryMilestone" in state and "selectCaseHistoryMilestone" in state, "case-history milestones are not interactive state")
require(all(copy in patient_history for copy in ("WHAT WE KNOW SO FAR", "CASE HISTORY · FICTIONAL", "SOURCE SLOT", "NOT A MEDICAL RECORD")), "case-history timeline lacks role-aware copy or fictional-record boundaries")
require("calm-flow-direction-arrows" in scene and "updateFlowArrows" in scene, "calm directional flow lesson is missing")
require("gpt-realtime-2.1" in immersive and "STROKE_REALTIME_PROXY_URL" in immersive and "AVSpeechSynthesizer" not in immersive and "@Published private(set) var narrationEnabled" in state, "GPT-Realtime-2.1-only narrator boundary is missing")
realtime_proxy = (ROOT / "Scripts" / "realtime_narration_proxy.mjs").read_text()
realtime_runner = (ROOT / "Scripts" / "run_realtime_proxy.zsh").read_text()
require('const MODEL = "gpt-realtime-2.1"' in realtime_proxy and 'body.model !== MODEL' in realtime_proxy, "Realtime proxy does not lock the requested model")
require('response.output_audio.delta' in realtime_proxy and 'pcm16MonoToWAV' in realtime_proxy, "Realtime audio stream is not converted into app-playable WAV")
require('AVSpeechSynthesizer' not in realtime_proxy and 'apikey get OPENAI_API_KEY' in realtime_runner, "Narration can fall back to system speech or bypass the keychain router")
require(all(token in launch for token in (
    "actor StrokeAudioPlayback",
    "func playLoop(from url: URL, volume: Float)",
    "func playOnce(_ data: Data) throws",
    "audio.prepareToPlay()",
    "await playback.playLoop",
)), "prelude audio preparation is not isolated from the main actor")
require(
    "try await playback.playOnce(audio)" in immersive
    and "AVAudioPlayerDelegate" not in immersive,
    "Realtime narration still prepares or owns AVAudioPlayer on the main actor",
)
require(all(token in launch for token in ('--proof-realtime-narration', 'experience.prepareFamilySurfaceReferenceProof()', 'never auto-accepts or starts audio')), "deterministic family Realtime invitation route bypasses explicit consent")
require(immersive.count("narrator.speak(") == 1 and all(token in immersive for token in (
    "private func synchronizeNarration()",
    "experience.audienceLens == .family",
    "experience.narrationEnabled",
    "!experience.requestedPause",
    "narrator.stop()",
)), "narration is not guarded by family role, opt-in, and active playback state")
require(".onChange(of: experience.requestedPause)" in immersive and ".onChange(of: experience.audienceLens)" in immersive, "pause or role transition cannot stop/restart narration deterministically")
require("narrationEnabled = false" in state and "func setNarrationEnabled" in state and 'experience.narrationEnabled ? "Narrator off" : "Narrator"' in immersive, "family narration state boundary is incomplete")
require(all(token in state for token in (
    'case family = "Curious learner"',
    "familyNarrationPromptVisible",
    "activeFamilyNarrationText",
    "familyNarrationTranscriptVisible",
    "narrationSetupAvailable",
    "func acceptFamilyNarrationPrompt()",
    "func showFamilyNarrationTranscript()",
    "func dismissFamilyNarrationPrompt()",
    "narrationSetupAvailable,",
)), "Curious Learner narration does not require explicit point-level consent and visible setup state")
require(
    "isSelectedSurfacePlainWordsFocusActive" in state
    and "emphasizeSurfacePoint" in scene
    and "updateSurfaceReferenceHighlight" in scene
    and "experience.isSelectedSurfacePlainWordsFocusActive" in immersive,
    "plain-language surface reference does not visibly reinforce its selected 3D patch",
)
require(all(token in immersive for token in (
    '"OPTIONAL AUDIO"',
    '"PLAIN WORDS"',
    'experience.narrationSetupAvailable ? "Play audio" : "Explain simply"',
    "experience.setNarrationSetupAvailable(narrator.isConfigured)",
    "let pointNarration = experience.activeFamilyNarrationText",
    "narrator.speak(pointNarration)",
    "GENERIC TEACHING MODEL · NOT A PATIENT SCAN",
    '"Hide", systemImage: "chevron.up"',
    "Hide plain-language explanation",
)) and "Want to hear one layer deeper?" not in immersive and "Want to read one layer deeper?" not in immersive, "selected-point voice action is not direct, pauseable, or honest when the proxy is missing")
require(
    all(token in launch for token in (
        '"--proof-family-read-more"',
        "experience.prepareFamilyReadMoreProof()",
    ))
    and "--proof-family-read-more" in simulator_proof
    and '"--proof-family-read-more": ("plain words", "folded outer surface")' in proof_image_check,
    "deterministic silent family read-more proof route is missing",
)
require('experience.soundEnabled ? "Sound on" : "Sound off"' in immersive and 'experience.narrationEnabled ? "Voice off" : "Voice"' not in immersive, "doctor controls still expose synthesized voice instead of ambient sound")
require(
    "if experience.narrationSetupAvailable {" in immersive
    and 'experience.narrationEnabled ? "Narrator off" : "Narrator"' in immersive
    and '"Voice setup"' not in immersive
    and 'waveform.badge.exclamationmark' not in immersive,
    "family controls expose a dead voice-setup affordance when narration is unavailable",
)
require("spatial-family-controls" in immersive and "spatial-presenter-controls" in immersive and "SpatialRoleControls" in immersive, "role controls are not embedded in the immersive room")
require('.frame(width: 80, height: 80)' in immersive and 'case .focusField: "Black"' in immersive, "presenter controls do not expose larger stable targets and the clear Black environment label")
require('experience.requestedPause ? "Resume" : "Pause"' in immersive and '.accessibilityValue(experience.requestedPause ? "Paused" : "Playing")' in immersive, "pause control does not expose explicit Resume and motion state semantics")
require('"--proof-presenter-controls"' in launch and 'experience.preparePresenterControlsProof()' in launch and '--proof-presenter-controls' in simulator_proof and '"--proof-presenter-controls": ("resume", "black")' in proof_image_check, "deterministic presenter-control proof route is incomplete")
require('"--proof-presentation-settings"' in launch and 'experience.preparePresentationSettingsProof()' in launch and '--proof-presentation-settings' in simulator_proof and '"--proof-presentation-settings": ("settings", "visual detail")' in proof_image_check, "deterministic presentation-settings proof route is incomplete")
require("SpatialControlBubbleLabel" in immersive and ".hoverEffect(.highlight)" in immersive, "gaze-sized spatial bubble controls are missing")
require(all(question in immersive for question in ("WHAT CHANGED?", "WHY DOES PRESSURE BUILD?", "WHAT CAN MAKING SPACE DO?")), "top intention questions are missing")
require("LessonSpecimenRail" in immersive and "lesson-specimen-rail" in immersive and "selectLessonPoint" in state and "Native two-hand magnification remains the only zoom" in state, "role-aware specimen focus rail is missing")
require("rail.isEnabled = false" in immersive and 'experience.clearPointSelection()' in immersive and "private var presenterControls" in immersive and all(call in immersive for call in ("cycleAnatomyPresentation()", "cycleLessonFamily()", "cycleEnvironment()")), "single selected-point disclosure or direct presenter cycle controls are incomplete")
require(not re.search(r"\bMenu\s*\{", immersive), "immersive controls must not use SwiftUI Menu presentation")
require("[-0.43, 1.28, -0.90]" in immersive and "[0.56, 1.30, -0.92]" in immersive, "family and presenter controls are not spatially separated")
require("openWindow(id: companion)" not in immersive, "immersive case docking still opens a desktop-like companion window")
require("StrokeClinicianTool" in state and "clinicianToolKitVisible" in state and "selectClinicianTool" in state, "clinician tool-kit state is missing")
require("clinician-hand-tool-wheel" in immersive and "ClinicianHandToolWheel" in immersive, "palm tool selector is missing")
require(".hand(.left, location: .palm)" in immersive and ".hand(.right, location: .palm)" in immersive, "tool kit and held tool are not hand anchored")
require("experience.audienceLens == .clinician" in immersive and "enabled && experience.clinicianToolKitVisible" in immersive, "clinician tools may leak into the family lens")
require(all(token in immersive for token in (
    "HandToolArcGuide",
    "CGSize(width: -18, height: -160)",
    ".frame(width: 84, height: 84)",
    "wheel.position = [0.095, 0.025, 0.110]",
    "wheel.scale = [0.78, 0.78, 0.78]",
    'experience.clinicianToolKitVisible ? "Tools on" : "Tools"',
)), "clinician selector is not a gaze-sized hand-adjacent arc with a presenter fallback")
require(all(token in state for token in (
    'case endovascularSet = "Catheter set"',
    "enum StrokeEndovascularConcept",
    "func selectEndovascularConcept(_ concept: StrokeEndovascularConcept)",
    '"Generic educational device comparison · no sizing or deployment guidance"',
    "case .forceps, .cranialDrill, .endovascularSet:",
)), "the clinician catheter set is missing its explicit non-procedural state boundary")
require(all(token in scene for token in (
    "makeClinicianHeldTools",
    "suction_and_forceps",
    "cranial_drill_generic",
    "guidewire_educational_v2",
    "microcatheter_educational_v2",
    "aspiration_catheter_educational_v2",
    "stent_retriever_educational_v2",
    'endovascularRoot.name = "clinician-tool-endovascular-set"',
    'conceptName = "clinician-endovascular-guidewire"',
    'conceptName = "clinician-endovascular-microcatheter"',
    'conceptName = "clinician-endovascular-aspiration"',
    'conceptName = "clinician-endovascular-retriever"',
    "case .endovascularSet: selectedName = \"clinician-tool-endovascular-set\"",
)), "four independently selectable educational catheter concepts are not bundled into the held-tool rig")
require(all(token in immersive for token in (
    "ForEach(Array(StrokeEndovascularConcept.allCases.enumerated())",
    "experience.selectEndovascularConcept(concept)",
    'Text(experience.selectedClinicianTool == .endovascularSet ? "TOOLS"',
    'accessibilityLabel("Inspect \\(concept.rawValue) concept")',
    "endovascularConcept: experience.selectedEndovascularConcept",
)), "catheter concepts are not individually selectable from the hand-adjacent tool arc")
require("No selection mutates anatomy or simulates a cut" in scene, "clinician tool safety boundary is missing")
require(
    'clinicianToolInspectionRootName = "clinician-device-inspection-root"' in scene
    and "heldTools.clone(recursive: true)" in immersive
    and "enhanceClinicianToolInspection(inspectionTools)" in immersive
    and "StrokeClinicianDeviceInspectionTargetComponent.registerComponent()" in scene
    and "StrokeClinicianDeviceInspectionTargetComponent()" in immersive
    and "isClinicianDeviceInspectionTarget(value.entity)" in immersive
    and "experience.advanceClinicianDeviceStudyBeat()" in immersive
    and "rotateClinicianDeviceInspection(delta: delta)" in immersive
    and "clinicianDeviceInspectionYaw" in state
    and "inspectionTurn * inspectionTilt" in immersive
    and "PINCH · NEXT BEAT   DRAG · TURN" in immersive
    and "static func enhanceClinicianToolInspection" in scene
    and 'loweredName.contains("marker")' in scene
    and 'loweredName.contains("crown")' in scene
    and "inspection.scale = [inspectionScale, inspectionScale, inspectionScale]" in immersive
    and "MAGNIFIED 3D DEVICE STUDY" in immersive
    and "Colour-enhanced geometry · not to scale · specialist review pending" in immersive
    and "inspectionSummary" in state,
    "the authored catheter model is not available as a truthful magnified spatial inspection",
)
require("proofRouteHasRun" in launch and "guard !proofRouteHasRun" in launch, "proof routing can open duplicate companion windows")
require("134 unique USDZ assets" in asset_triage and all(name in asset_triage for name in (
    "brain_deep_structures_v2",
    "brain_ventricles_v2",
    "cerebral_bloodflow_animation_v2",
)), "expanded asset catalog is not triaged separately from the twenty-two-file runtime slice")
require("museum drawer" in presentation_canon and "MetaHuman" in presentation_canon and "information state" in presentation_canon and "90-second presentation script" in presentation_canon, "presentation canon is missing the case-discovery and ethical-avatar contract")
require("anatomy-anchored handle" in presentation_canon and "Reversible layer study" in presentation_canon and "never literal peeling" in presentation_canon, "presentation canon lacks the reversible layer-study interaction contract")
require("Core spatial choreography" in product_map and "Annotation engineering contract" in product_map and "Implementation map" in product_map, "product and UI map is incomplete")
require("left" in product_map.lower() and "centre" in product_map.lower() and "right" in product_map.lower(), "product map lacks room-scale choreography")
require("BLENDER_LAYER_STUDY=PASS" in blender_manifest and "REGION_ANCHOR" in blender_builder, "executed Blender layer-study receipt is missing")
require("Houdini is not installed" in dcc_pipeline and "Unreal Editor is not installed" in dcc_pipeline, "DCC pipeline overclaims unexecuted Houdini or Unreal work")
require("RealityKit remains the runtime source of truth" in dcc_pipeline and "hub-and-spoke USD" in dcc_pipeline, "DCC/runtime authority boundary is missing")
require("SC-AIS-001.12" in clinical_packet and "PENDING CLINICIAN REVIEW" in clinical_packet, "versioned clinical-review boundary is missing")
require("familyFeedback" in immersive and '"Clarify"' in immersive, "family-only clarification control is missing")
require("Point on brain" in immersive and "family-question-marker" in immersive, "family spatial question marker is missing")
require("PlacedStrokeQuestion" in state and "rootLocalPosition" in state, "question placement is not owned in anatomy-local coordinates")
require("value.location3D" in immersive and "from: .local" in immersive and "to: .scene" in immersive, "targeted 3D hit conversion is missing")
require("root.convert(position: scenePoint, from: nil)" in immersive, "scene hit is not converted into anatomy-local coordinates")
require("root.convert(position: placement.rootLocalPosition, to: nil)" in immersive, "anatomy-local question is not reconstructed in world space")
require(immersive.count("guard StrokeSceneFactory.isAnatomyInteractionTarget(value.entity) else { return }") >= 2, "orbit and magnify are not routed to anatomy targets")
require("spatial-patient-drawer" in immersive and "SpatialPatientDrawer" in immersive and "drawer.isEnabled = experience.spatialPhase == .caseLibrary" in immersive, "focused dossier briefing is missing or persists beyond the archive")
require("VESSEL STORY" in immersive and "BRAIN ATLAS" in immersive and "let revealAll = experience.pointField != .craniotomy" in scene, "focused specimen rail or fully discoverable registered lesson-family rendering is missing")
require("FLOW_ANCHOR exports" in scene, "unreviewed flow markers are not quarantined from all-marker presentation")
require("registered-region-point-anchor" in scene and "approach(regionPointAnchor" in scene, "region lesson markers remain coupled to cortical opacity or layer motion")
require("horizon.isEnabled = experience.environmentMode == .warmHorizon" in immersive and "case .focusField: .full" in immersive, "environment state does not control horizon visibility and system immersion")
require("DirectionalLightComponent" in immersive and "experience.environmentMode != .surroundings" in immersive, "warm and focus environments lack a bounded anatomy key light")
require(
    "stroke-surroundings-anatomy-reveal-light" in immersive
    and "surroundingsRevealLight.isEnabled = experience.environmentMode == .surroundings" in immersive
    and "stageRoot.findEntity(named: surroundingsRevealLightID)?.isEnabled" in immersive,
    "the registered anatomy hero loses all material-revealing light in the surroundings opening",
)
require(all(layer in immersive for layer in ("PRIMARY_FOVEAL", "SECONDARY_PERIPHERAL", "TERTIARY_ATMOSPHERE")), "visual-field hierarchy is not encoded in the immersive room")
spatial_workspace = (ROOT / "Docs" / "SPATIAL_CASE_WORKSPACE.md").read_text()
require("top explains, middle demonstrates" in spatial_workspace and "lower acts" in spatial_workspace, "vertical rule-of-three contract is missing")
require("never communicated by peripheral" in spatial_workspace, "peripheral safety boundary is missing")
require("--proof-family-question" in launch and "prepareFamilyQuestionProof" in state, "family question proof route is missing")
require("--proof-family-clarity" in launch and "prepareFamilyClarityProof" in state, "family clarity proof route is missing")
require("--proof-presenter-plain-language" in launch and "preparePresenterPlainLanguageProof" in state, "presenter plain-language proof route is missing")
require("clarificationRequested" in state and "never infers emotion" in state, "explicit clarification or emotion-inference boundary is missing")
require(all(token in state for token in (
    "familyClarityCheck",
    "familyClarityWasSet",
    "setFamilyClarityCheck",
    "not an anxiety score",
    "familyQuestionSuggestions",
    "familyClarityLabel",
    "selectedFamilyQuestion",
    "selectFamilyQuestion",
)), "explicit session-local family clarity check or finite question selection is missing")
require(all(token in immersive for token in (
    '"BEGIN HERE"',
    '"EXPLORE NEXT"',
    '"EXPLAIN THIS"',
    '"CLARITY · SELF-REPORTED"',
    '"Clarity · \\(experience.familyClarityLabel)"',
    'Slider(',
    "Record the family's self-reported explanation clarity",
    "experience.selectFamilyQuestion(question)",
    '"Opens an authored spatial teaching point"',
    '"Shows model limitations"',
)), "role-aware left cue surface does not expose spatial exploration actions and explicit clarity")
require(all(token in state for token in (
    "familyExploreDestination(for:",
    'case "Start with one glowing point":',
    'case "Follow one vessel story", "Follow this vessel route":',
    'case "Locate this in the whole brain":',
    'case "Keep nearby anatomy in view":',
    'case "Compare before and beyond the blockage":',
    'case "Unfold the teaching layers":',
    "pointField = destination.field",
    "selectLessonPoint(point)",
)), "family exploration rail actions do not navigate to authored 3D points")
require('return ["Start with one glowing point"]' in state
and "A newcomer gets one clear spatial invitation" in immersive
and "it cannot feel like a question before they have explored" in immersive,
"family entry still presents competing prompts or a clarity check before the first spatial reveal")
require(all(token in state for token in (
    "selectedPresenterKeyPointIndex",
    "presenterPlainLanguagePoints",
    "selectPresenterKeyPoint",
    "There is intentionally no runtime-generated paraphrase",
)), "presenter technical-to-plain authored pointer state is missing")
require("StrokePresenterConversationTopics().environmentObject(experience)" in immersive
        and all(token in reference_workspace for token in (
            "Text(topic.meaning)", "case .regions:", "case .procedure:", "case .craniotomy:",
            "experience.presenterTeachingBeat == .teamChecks", "expandedTerm = expanded ? nil : topic.term",
            "Show a plain-language explanation", "topicButton(\"Flow\", field: .procedure)",
        )), "presenter topics do not disclose contextual authored plain-language explanations")
require("ASK ALOUD" not in immersive and "familyComfort" not in state and "familyComfort" not in immersive, "misleading voice or comfort terminology remains")
require(all(token in immersive for token in (
    "SETTINGS",
    "VISUAL DETAIL",
    "detailStepButton",
    "cycleDetailLevel(by:",
    "Optional geometry and motion only.",
)), "explicit three-stop presentation-setting choices are incomplete")
require("familyClarityCheck < 0.5" in state and "familyClarityCheck < 1.5" in state, "family question suggestions do not adapt to explicit clarity")
require("if detailLevel == .calm" in state and "if detailLevel == .scholar" in state, "presenter wording does not adapt to the selected visual-detail tier")
require(all(token in scene for token in (
    "experience.detailLevel.motionRate",
    "experience.detailLevel.pointScale",
    "experience.detailLevel.pointOpacity",
    "let flowOpacity: Float = switch experience.detailLevel",
)), "RealityKit point and flow presentation does not respond to visual detail")
require("experience.present(step: step)" in immersive, "presenter-controlled act targeting is missing")
require("SpatialTeachingTimeline" in immersive and 'teachingTimelineID = "spatial-teaching-timeline"' in immersive, "centered world-space teaching timeline is missing")
require("ForEach(StrokeProcedureStep.allCases)" in immersive and ".hoverEffect(.highlight)" in immersive and "labelsVisible = false" in immersive and "let showsContext = labelsVisible || hoveredStep != nil" in immersive, "three-act gaze timeline lacks quiet nodes or hover/selection context")
require(all(token in immersive for token in (
    "ForEach(StrokePresenterTeachingBeat.allCases)",
    "experience.selectPresenterTeachingBeat(beat)",
    "SpatialPresenterTeachingBeatNode",
    ".frame(minWidth: 108, minHeight: 108)",
    ".frame(width: 108, height: 108)",
    "@State private var hoveredBeat",
    "let displayedBeat = hoveredBeat ?? experience.presenterTeachingBeat",
    "let showsContext = labelsVisible || hoveredBeat != nil",
    "STEP \\(displayedBeat.number) OF 6",
    "isHovered: hoveredBeat == beat",
    ".frame(height: beat == experience.presenterTeachingBeat ? 12 : 8)",
    "Color(red: 0.86, green: 0.31, blue: 0.34)",
)), "doctor presenter timeline does not expose six stable direct checkpoints with context above")
require("(teachingTimelineID, [0, 1.27, -0.86]" in immersive, "teaching timeline is not staged in the central-lower demo field")
require(all(token in scene for token in (
    "addAccessTargetHighlight(to: accessPoint)",
    'highlight.name = "clinician-access-target-highlight"',
    'halo.name = "clinician-access-target-halo"',
)) and 'clinician-access-target-mark-' not in scene,
"craniotomy access point is missing its quiet non-graphic halo or still draws radial registration noise")
require("let accessInvitationMarker = accessSourceMarker + SIMD3<Float>(0, 0, 0.022)" in scene, "access invitation is still visually embedded in the anatomy")
require(all(token in scene for token in (
    "source + simd_normalize(direction) * 0.018",
    "return source + direction * 0.018",
)) and all(token not in scene for token in (
    'lesson-point-invitation-tether',
    'clinician-access-target-tether',
)), "lesson invitations must float clear of anatomy without connector lines")
require("maximumDistance: Float = 0.036" in scene, "nearest visible lesson-point fallback was not enlarged by twenty percent")
require("let revealAll = experience.pointField != .craniotomy" in scene, "region or flow point families still hide unselected selectable markers")
require("activatePresenterAccessStory" in state and "pointField = .craniotomy" in state and "selectDetailLevel(.scholar)" in state, "top Access checkpoint does not enter the craniotomy teaching family")
require("experience.detailLevel == .scholar &&\n            experience.pointField == .craniotomy" not in scene, "craniotomy reference disappears when visual detail leaves Full")
require(all(token in scene for token in (
    "let showsAccessScalp: Bool",
    "let showsAccessBone: Bool",
    "let showsAccessDura: Bool",
    "showsAccessBone = false",
    "showsAccessScalp = false",
    "accessScalpLayer?.isEnabled = showsOpenCranialReview && showsAccessScalp",
    "accessBoneLayer?.isEnabled = showsOpenCranialReview && showsAccessBone",
    "accessDuraLayer?.isEnabled = showsOpenCranialReview && showsAccessDura",
    "accessScalpLayer?.components.set(OpacityComponent(opacity: 1))",
    "accessBoneLayer?.components.set(OpacityComponent(opacity: 1))",
    "accessDuraLayer?.components.set(OpacityComponent(opacity: 1))",
)), "craniotomy assembly does not disclose stable authored layers across all three visual-detail tiers")
require(all(token in scene for token in (
    "accessEdemaLayer?.isEnabled = showsOpenCranialReview && [",
    "].contains(experience.presenterTeachingBeat) && experience.detailLevel == .scholar",
)), "the optional edema cue is not explicitly restricted to Full clinician detail")
require("clinicianToolKitVisible = true" in state, "pinching the access invitation does not reveal the clinician toolkit")
access_study = (ROOT / "Sources" / "StrokeAccessLayerStudy.swift").read_text()
require(all(token in access_study for token in (
    "canMoveSelectedLayer", "progress.isFinite", "min(1, max(0, progress))",
    "mutating func reset()", "mutating func end()",
)), "access-layer study lacks bounded reversible model state")
require(all(token in state for token in (
    "startAccessLayerStudy()", "accessLayerStudyAssetsAvailable",
    "guard careViewPermissionGranted else", "accessLayerStudyEntryPending",
    "selectedClinicianTool == .forceps", "accessStudyReturnState",
    "guard !accessLayerStudy.isActive else { return }",
)), "interactive access model bypasses role/assets/permission or lets the anatomy drift")
require(all(token in immersive for token in (
    'Button("Move the layers"', "StrokeAccessLayerStudyControls()",
    "StrokeAccessLayerTargetComponent.self", "accessLayerDragContext(",
    "experience.dragAccessStudyLayer(", "experience.finishAccessStudyDrag()",
    "experience.endAccessLayerStudy()", "experience.resetAccessLayerStudy()",
    '"Generic layer model · not operative technique · clinician review pending"',
)), "access-layer study has no direct manipulation or independent Back/Reset")
require(all(token in scene for token in (
    "StrokeAccessLayerTargetComponent.registerComponent()",
    "experience.accessLayerStudy.boneProgress", "experience.accessLayerStudy.duraProgress",
    "updateAccessStudySubset", "RegisteredSkull_",
    "Registered_Conceptual_Dura_Remainder_With_Opening",
)), "access model is not driving the actual registered flaps or reintroduces the face")
require(all(token in state for token in (
    "pendingPresenterTeachingBeat",
    "beat.procedureStep == .discussCare, !careViewPermissionGranted",
    "selectPresenterTeachingBeat(requestedBeat",
    "beat == .explainClosure",
)), "presenter beat navigation bypasses permission continuity or reversible closure")
require("SpatialRoleMicroCues" in immersive and 'roleMicroCuesID = "spatial-role-micro-cues"' in immersive and ".frame(width: 520)" in immersive and "isFamily ? 0.86 : 0.94" in immersive and "familyQuestionSuggestions" in immersive and "StrokePresenterConversationTopics" in immersive, "role-aware left peripheral micro-cues are missing or too small for the family conversation")
require(all(token in immersive for token in (
    "let familyPointDisclosureActive = isFamily && experience.selectedPointEntityName != nil",
    "experience.familyBrainAtlasVisible || familyPointDisclosureActive",
    "id == roleMicroCuesID && familyLeftFieldOccupied",
)), "family Explore Next remains stacked behind an active point explanation")
require(all(token in immersive for token in (
    "StrokeSceneReadinessOverlay",
    "Preparing the 3D teaching model",
    "brain, vessel paths, and discovery points will appear together",
    "@State private var isSceneReady = false",
    "StrokeSceneFactory.makeScene(compact: true)",
    "let detailedRoot = await StrokeSceneFactory.makeScene()",
    "isSceneReady = true",
)), "immersive launch lacks an honest anatomy-readiness boundary")
require(
    "makeCompactRegisteredHero" in scene
    and "fallback.isEnabled = false" in scene
    and "registered-v2-fast-hero-root" in scene
    and "importedArteriesName" in scene
    and "importedClotName" in scene,
    "the compact immersive opening does not retain the registered-v2 anatomy hero"
)
require(
    all(token in scene for token in (
        "let familyFirstDiscovery = experience.audienceLens == .family",
        "let guidedPointIndex = experience.pointField.defaultLessonPointIndex",
        "let isGuidedFirstPoint = familyFirstDiscovery",
        "child.isEnabled = isGuidedFirstPoint || revealAll || isSelected",
        "(isSelected || isGuidedFirstPoint)",
    ))
    and all(token in immersive for token in (
        "if isFamilyFirstDiscovery {",
        "familyFirstDiscoveryControls",
        "familyControls",
        "private var familyFirstDiscoveryControls",
        '"One point at a time"',
    )),
    "the family entry cue does not reduce initial point competition and controls to one guided discovery action",
)
require(all(token in state for token in (
    "enum StrokeFamilyBrainAtlasChapter",
    "familyBrainAtlasVisible",
    "familyBrainAtlasChapter",
    "familyBrainAtlasDetailIndex",
    "familyBrainAtlasCueChapter",
    "toggleFamilyBrainAtlas()",
    "advanceFamilyBrainAtlasChapter(by",
    "advanceFamilyBrainAtlasDetail(by",
    "selectLessonFamily(chapter.pointField)",
    "revealFamilyBrainAtlasModelCue()",
    "var spatialCuePointIndex: Int?",
    "selectPoint(",
    "var teachingReferenceLabel: String?",
    'chapter.teachingReferenceLabel ??',
    '"\\(chapter.title) · combined internal atlas context"',
    "teachingImagingLens = .internalStructures",
    "prepareFamilyArterialAtlasFlowProof",
    "prepareFamilyAtlasNextChapterProof",
    "prepareFamilyAtlasInteriorReadyProof",
    "prepareFamilyAtlasInternalReferenceProof",
    "prepareFamilyAtlasCerebellumJourneyProof",
    "prepareFamilyBrainAtlasProof",
    "prepareFamilyAtlasSurfaceCueProof",
    "prepareFamilyAtlasDirectSurfacePickProof",
    "prepareFamilyAtlasTemporalCueProof",
    "selectFamilyAtlasSurfaceContext(atlasPointIndex:",
    "surfaceChapter(for:",
)), "family Brain Atlas does not keep a user-selected, generic-model handoff")
require(all(token in state for token in (
    "var usesCombinedInternalReference: Bool",
    "case .corpusCallosum, .thalamus, .hippocampus, .brainstemAndCerebellum:",
    "familyAtlasCerebellumJourneyRequested",
    "enterFamilyAtlasCerebellumJourney()",
)), "deep Atlas topics do not declare their combined-reference boundary")
require(all(token in state for token in (
    'entityName: "family-atlas-point-field-point-\\(index)"',
    "selectFamilyBrainAtlasChapter(.temporalLobe)",
)), "Family Atlas chapters still borrow generic region-point identities")
require(all(token in state for token in (
    "complete generic brain with this chapter's localized focus",
    "teachingImagingLens = .brainSurface",
    "teachingImagingDrawerVisible = true",
)), "Family Atlas surface chapters do not reveal their complete localized 3D brain reference")
require("atlasSurfaceDirections" in scene and "Array(atlasSurfaceDirections.keys)" in scene, "Family Atlas surface references are missing their chapter-specific 3D focus beacons")
require(
    "isSelectedInternalPlainWordsFocusActive" in state
    and "emphasizeInternalVentricles" in scene
    and "updateInternalReferenceFocus" in scene
    and "experience.isSelectedInternalPlainWordsFocusActive" in immersive,
    "plain-language internal Atlas reference does not visibly reinforce its named ventricular object",
)
require(all(token in scene for token in (
    "case internalStructures",
    'internalRootName = "registered-teaching-imaging-internal-structures"',
    'deepStructuresAssetName = "brain_deep_structures_v2"',
    'ventriclesAssetName = "brain_ventricles_v2"',
)) and "Combined generic internal mesh" in immersive,
"Family Atlas deep chapters do not use the bundled combined internal reference honestly")
require(all(token in scene for token in (
    'atlasPointFieldName = "family-atlas-point-field"',
    "atlasPointDirections",
    "atlasPointLabels",
    "atlasOwnsSurfacePoints",
    "nearestFamilyAtlasSurfaceSelection",
    "maximumDistance: Float = 0.16",
    "The Atlas presents exactly one chapter-owned invitation",
)), "Family Atlas does not own five distinct, one-at-a-time hero-brain markers")
require(all(token in immersive for token in (
    'familyBrainAtlasID = "spatial-family-brain-atlas"',
    "SpatialFamilyBrainAtlas()",
    "SWIPE OR USE ARROWS FOR THE NEXT STRUCTURE",
    "isPlainWordsExpanded",
    "ATLAS CONTEXT · 3D REFERENCE REMAINS BESIDE THE BRAIN",
    ".frame(minHeight: 126, alignment: .leading)",
    "REVEAL IN 3D",
    'return "\\(action) · \\(experience.teachingReferenceActionTitle().uppercased())"',
    "experience.familyBrainAtlasCueChapter == chapter",
    "ROOM SCALE READY · USE ENTER THE BRAIN BELOW",
    "canOpenCerebellumObservatory",
    "EXPLORE CEREBELLUM IN 3D",
    "Folds, vessel paths, and qualitative flow",
    "experience.enterFamilyAtlasCerebellumJourney()",
    "internalJourney.selectRegionVisualization(.xray)",
    "isDeepStructureChapter",
    "FIND IT IN SPACE",
    "GENERIC TEACHING MODEL · NOT A PATIENT SCAN",
    ".frame(width: 720)",
    ".background(.black.opacity(0.72), in: RoundedRectangle(cornerRadius: 22))",
    "atlasCueAccessibilityLabel",
    "atlasCueAccessibilityHint",
    "isAtlasCombinedInternalChapter",
    '"Deep systems"',
    '"TOPIC · \\(chapter.title.uppercased())"',
    '"COMBINED INTERNAL MODEL · NOT A SEPARATE OUTLINE"',
    "revealFamilyBrainAtlasModelCue()",
    "experience.selectFamilyAtlasSurfaceContext(",
    "broad generic Atlas context",
    "atlasOwnsSelection",
    "!atlasOwnsSelection",
    "atlasReferenceActionTitle",
    "experience.toggleSelectedPointReference()",
    "OPTIONAL AUDIO",
    "PLAIN WORDS",
    "Explain simply",
    "static let secondaryCaseDrawer: SIMD3<Float> = [0.44, 1.49, -0.84]",
    "drawer.scale = [0.88, 0.88, 0.88]",
)), "family Brain Atlas is missing its spatial, one-chapter-at-a-time interface")
require("--proof-family-brain-atlas" in launch and "prepareFamilyBrainAtlasProof" in launch, "deterministic family Brain Atlas proof route is missing")
require("--proof-family-arterial-atlas-flow" in launch and "prepareFamilyArterialAtlasFlowProof" in launch, "deterministic family arterial-flow Atlas proof route is missing")
require("--proof-family-atlas-next-chapter" in launch and "prepareFamilyAtlasNextChapterProof" in launch, "deterministic Family Atlas next-chapter proof route is missing")
require("--proof-family-atlas-interior-ready" in launch and "prepareFamilyAtlasInteriorReadyProof" in launch, "deterministic Family Atlas interior-ready proof route is missing")
require("--proof-family-atlas-surface-cue" in launch and "prepareFamilyAtlasSurfaceCueProof" in launch, "deterministic family Atlas surface-cue proof route is missing")
require("--proof-family-atlas-direct-surface-pick" in launch and "prepareFamilyAtlasDirectSurfacePickProof" in launch and "--proof-family-atlas-direct-surface-pick" in simulator_proof and '"--proof-family-atlas-direct-surface-pick": ("temporal lobe", "whole brain surface")' in proof_image_check, "deterministic direct Family Atlas surface-pick proof route is missing")
require("--proof-family-atlas-temporal-cue" in launch and "prepareFamilyAtlasTemporalCueProof" in launch, "deterministic temporal Atlas cue proof route is missing")
require("--proof-family-atlas-internal-reference" in launch and "prepareFamilyAtlasInternalReferenceProof" in launch, "deterministic internal Atlas reference route is missing")
require("--proof-family-atlas-internal-plain-words" in launch and "prepareFamilyAtlasInternalPlainWordsProof" in launch, "deterministic internal Atlas plain-language proof route is missing")
require("--proof-family-atlas-cerebellum-journey" in launch and "prepareFamilyAtlasCerebellumJourneyProof" in launch and "--proof-family-atlas-cerebellum-journey" in simulator_proof and '"--proof-family-atlas-cerebellum-journey": ("inside", "cerebellum")' in proof_image_check, "deterministic dedicated cerebellum Atlas journey route is missing")
require(
    "--proof-family-neuron-reference" in launch
    and "prepareFamilyNeuronReferenceProof" in launch
    and "--proof-family-neuron-reference" in simulator_proof
    and '"--proof-family-neuron-reference": ("one neuron", "3d teaching model")' in proof_image_check,
    "deterministic schematic-neuron reference proof route is missing",
)
require(
    "--proof-family-neuron-plain-words" in launch
    and "prepareFamilyNeuronPlainWordsProof" in launch
    and "--proof-family-neuron-plain-words" in simulator_proof
    and '"--proof-family-neuron-plain-words": ("plain words", "one neuron")' in proof_image_check,
    "deterministic plain-words neuron proof route is missing",
)
require("atlasBeat(\"1\", \"POSITION\"" in immersive and "atlasBeat(\"2\", \"MEANING\"" in immersive and "atlasBeat(\"3\", \"ASK\"" in immersive, "family Brain Atlas lacks a visible three-beat explanation rhythm")
require(".frame(width: 720)" in immersive and "atlas.scale = [1.10, 1.10, 1.10]" in immersive and "OF \\(StrokeFamilyBrainAtlasChapter.detailCount) · \\(detailTitle)" in immersive, "family Brain Atlas is not sized or labelled for one-at-a-time readability")
require("fixed 108-point field and 64-point disc" in immersive and ".frame(minWidth: 108, minHeight: 108)" in immersive and "let discDiameter: CGFloat = 64" in immersive, "presenter timeline targets are not room-scale legible")
require("suggestedStagePosition: SIMD3<Float> = [0.48, 1.62, -0.84]" in scene and "suggestedStageScale: Float = 1.04" in scene, "the secondary 3D teaching reference must remain separated and legible beside the hero anatomy")
require(all(token in immersive for token in (
    "teachingReferenceSideX(",
    "point.position(relativeTo: stageRoot).x < 0 ? 1 : -1",
    "0.17 * pointSide",
    "drawerX",
)), "selected-point explanation and full 3D reference do not occupy opposite sides of the hero brain")
require('.frame(width: 400)' in immersive and 'drawer.scale = [0.88, 0.88, 0.88]' in immersive, "the selected-point explanation is too small to read beside its full 3D reference")
require(all(token in state for token in (
    "selectedPointReferenceExpanded",
    "toggleSelectedPointReference()",
    "teachingImagingDrawerVisible = true",
)), "Family point selection must disclose its secondary 3D reference explicitly")
require(all(token in immersive for token in (
    'experience.toggleSelectedPointReference()',
    'accessibilityLabel("Hide 3D teaching reference")',
    '.frame(width: 44, height: 44)',
)), "the point-owned 3D reference lacks a direct, reachable Hide action")
require("showsFamilyReferenceAction" in immersive and "teachingReferenceActionTitle()" in immersive and "toggleSelectedPointReference()" in immersive, "selected Family points are missing their explicit spatial-reference follow-up")
require(
    "teachingReferenceRelationship" in state
    and '"COMBINED 3D CONTEXT" : "FULL 3D STRUCTURE"' in immersive
    and "experience.teachingReferenceRelationship()" in immersive
    and all(token in state for token in (
        '"ROUTE · BLOOD APPROACHES THROUGH LARGER ARTERIES"',
        '"BRANCHING · ONE ROUTE DIVIDES INTO SMALLER PATHS"',
        '"BLOCKAGE · GENERIC FLOW INTERRUPTION"',
        '"DOWNSTREAM · COMPARE FLOW BEYOND THE BLOCKAGE"',
        '"TERRITORY · THIS REGION DEPENDS ON THE UPSTREAM ROUTE"',
        '"LAYERS · SKULL, DURA, AND BRAIN — NOT A SITE PLAN"',
    )),
    "selected points do not explain their relationship to the complete 3D reference",
)
require(
    'pointHighlightPrefix = "registered-teaching-imaging-point-highlight-"' in scene
    and 'pointRouteTracePrefix = "registered-teaching-imaging-route-trace-"' in scene
    and "addPointRelationshipHighlights" in scene
    and "addProcedureRouteTrace" in scene
    and "routeTraceName(for: label)" in scene
    and "selectedPointLabel: String?" in scene
    and "label == selectedPointLabel" in scene
    and "selectedPointLabel: experience.selectedPointLabel" in immersive,
    "the complete 3D reference does not visibly spotlight the selected point relationship",
)
require(
    "selectedPointLabel: selectedPointLabel" in scene
    and "switch selectedPointLabel" in scene
    and all(token in scene for token in (
        'case "Blood supply approaches":',
        'case "Arteries branch":',
        'case "Example blockage":',
        'case "Flow beyond the blockage changes":',
        'case "Affected territory":',
        "marker.isEnabled = route != nil",
        "they are not vessel centre-lines, speed, perfusion, or patient flow",
    )),
    "blood-flow teaching points still reuse one generic particle route",
)
require(all(token in scene for token in (
    "func addSurfaceRegionHighlight(",
    'patch.scale = [1.65, 1.20, 0.26]',
    "to: simd_normalize(outwardNormal)",
    "not a segmented lobe, measured boundary, or patient finding",
)), "surface/context references still use detached dots instead of bounded tangential patches")
require(all(token in state for token in (
    "func prepareFamilyNearbyReferenceProof()",
    "func prepareFamilyOppositeReferenceProof()",
    "prepareFamilyRegionalReferenceProof(pointIndex: 1",
    "prepareFamilyRegionalReferenceProof(pointIndex: 3",
)) and all(token in launch for token in (
    '"--proof-family-nearby-reference"',
    '"--proof-family-opposite-reference"',
)), "regional reference comparison routes are incomplete")
require("--proof-family-selected-point" in launch and "prepareFamilyTeachingReferenceProof" in launch and "prepareFamilyTeachingReferenceProof" in state, "family point-to-spatial-reference proof route is missing")
require("--proof-family-surface-reference" in launch and "prepareFamilySurfaceReferenceProof" in launch and "prepareFamilySurfaceReferenceProof" in state, "family brain-surface reference proof route is missing")
require(
    "--proof-family-explore-nearby" in launch
    and "prepareFamilyExploreNearbyProof" in state
    and 'selectFamilyQuestion("Keep nearby anatomy in view")' in state
    and "--proof-family-explore-beyond" in launch
    and "prepareFamilyExploreBeyondProof" in state
    and 'selectFamilyQuestion("Compare before and beyond the blockage")' in state,
    "left-rail-to-spatial-reference transition proof routes are missing",
)
require("--proof-family-arterial-reference" in launch and "prepareFamilyArterialReferenceProof" in launch and "prepareFamilyArterialReferenceProof" in state, "family arterial-tree reference proof route is missing")
require(
    "--proof-family-arterial-supply-reference" in launch
    and "prepareFamilyArterialSupplyReferenceProof" in launch
    and "prepareFamilyArterialSupplyReferenceProof" in state
    and "--proof-family-arterial-branch-reference" in launch
    and "prepareFamilyArterialBranchReferenceProof" in launch
    and "prepareFamilyArterialBranchReferenceProof" in state
    and "--proof-family-arterial-beyond-reference" in launch
    and "prepareFamilyArterialBeyondReferenceProof" in launch
    and "prepareFamilyArterialBeyondReferenceProof" in state,
    "arterial selected-point comparison proof routes are missing",
)
require(
    "--proof-family-affected-reference" in launch
    and "prepareFamilyAffectedReferenceProof" in launch
    and "prepareFamilyAffectedReferenceProof" in state
    and "--proof-family-arterial-territory-reference" in launch
    and "prepareFamilyArterialTerritoryReferenceProof" in launch
    and "prepareFamilyArterialTerritoryReferenceProof" in state,
    "affected-area or arterial-territory selected-point proof route is missing",
)
require("--proof-family-layer-reference" in launch and "prepareFamilyLayerReferenceProof" in launch and "prepareFamilyLayerReferenceProof" in state and "pointField = .craniotomy" in state, "family access-story layer-reference proof route is missing")
require(all(point_label in state for point_label in (
    '"Example affected area"', '"Blood supply approaches"', '"Arteries branch"',
    '"Example blockage"', '"Flow beyond the blockage changes"', '"Affected territory"',
    '"Nearby brain tissue"', '"Brain surface"', '"Opposite-side context"',
)) and "case \"Generic craniotomy teaching story\":" in state, "every current point label must map to an explicit structure-specific teaching lens")
require(all(token in state for token in (
    "configurePresenterPointField(",
    "case .confirmContext:",
    "case .discussAccess:",
    "case .protectiveCovering, .explainPurpose, .teamChecks, .explainClosure:",
    "lessonPointsVisible = false",
)), "presenter checkpoints do not own their point-field visibility")
require("StrokeTeachingImagingDrawer" in immersive and 'teachingImagingDrawerID = "spatial-teaching-imaging-drawer"' in immersive and "SpatialVisualField.secondaryCaseDrawer" in immersive, "peripheral teaching imaging drawer is missing")
require(
    all(token in immersive for token in (
        'spatialImagingPlateID = "spatial-clinician-imaging-plate"',
        "StrokeSpatialImagingPlate",
        '"Drag to place · two-hand pinch to resize"',
        '"Grab the scan to move · two-hand pinch to resize"',
        "including: isMarking ? .none : .all",
        "private var plateDragGesture: some Gesture",
        "experience.moveSpatialImagingPlate(translation: value.translation)",
        "experience.audienceLens == .clinician &&\n                experience.spatialImagingPlateVisible",
        "Generic teaching reference · not a patient scan",
    )),
    "clinician spatial imaging plate is missing its placement interaction or teaching boundary",
)
require(
    all(token in state for token in (
        "spatialImagingPlateScale: Float = 1",
        "func beginSpatialImagingPlateScale()",
        "func scaleSpatialImagingPlate(by magnification: CGFloat)",
        "max(0.55, origin * Float(magnification))",
        "func resetSpatialImagingPlateTransform()",
    ))
    and all(token in immersive for token in (
        "(experience.spatialImagingFocusActive ? 1.0 : 0.78) * experience.spatialImagingPlateScale",
        "MagnifyGesture()",
        "experience.scaleSpatialImagingPlate(by: value.magnification)",
        "Reset teaching image position and size",
    )),
    "the spatial teaching image cannot be resized and safely reset",
)
require(
    all(token in state for token in (
        "spatialImagingComparisonEnabled",
        "func toggleSpatialImagingComparison()",
        "spatialImagingComparisonEnabled = true",
    ))
    and all(token in immersive for token in (
        'Label("CT + MRI", systemImage: "rectangle.split.2x1")',
        "CTTeachingSchematic()",
        "MRITeachingSchematic()",
        "Side-by-side research templates · no patient registration",
    )),
    "the placed imaging board cannot show a bounded CT/MRI spatial comparison",
)
require(
    all(token in state for token in (
        "spatialImagingPlateVisible",
        "spatialImagingReference",
        "func placeSpatialImagingPlate(",
        "func moveSpatialImagingPlate(translation: CGSize)",
        "guard audienceLens == .clinician, spatialPhase == .explanation",
        "teachingImagingDrawerVisible = false",
    )),
    "spatial imaging placement is not clinician-gated and state-owned",
)
require(
    all(token in state for token in (
        "struct StrokeSpatialAnnotation",
        "spatialAnnotations: [StrokeSpatialAnnotation]",
        "func pinSelectedPointNote()",
        "func moveSpatialAnnotation(id: String, translation: CGSize)",
        "func locateSpatialAnnotation(id: String)",
        "spatialAnnotations.count == 3",
        "guard audienceLens == .clinician",
    )),
    "point-linked spatial notes are missing persistence, movement, or clinician gating",
)
require(
    all(token in immersive for token in (
        "StrokePinnedAnnotationSlot",
        '"spatial-clinician-pinned-note-0"',
        'Button("Pin note", systemImage: "pin.fill")',
        'Label("Pinch-drag", systemImage: "hand.draw")',
        'Text("AUTHORED POINT · GENERIC TEACHING MODEL")',
        "experience.moveSpatialAnnotation(",
    )),
    "the spatial document layer lacks an authored, movable point-note surface",
)
require(
    all(token in immersive for token in (
        "let isSelectedPointNote = experience.selectedPointEntityName.map",
        "let noteSharesImageWorkField = imageWorkingMode && isSelectedPointNote",
        "let annotationVisibleBesideStudy = !imageWorkingMode || isSelectedPointNote",
        "noteEntity.position = [noteX, 1.42, -0.90]",
        "annotationVisibleBesideStudy",
    )),
    "a placed teaching image hides the selected point annotation instead of preserving one compact, anatomy-linked note",
)
require(
    all(token in immersive for token in (
        "@State private var studyToolsVisible = false",
        "let showsStudyTools = studyToolsVisible || referencePickerVisible",
        "let contentFirstStudy = !isChoosingStudy && !isReadingTermNote && !showsStudyTools",
        "let imageMinimumHeight: CGFloat = contentFirstStudy",
        "? (experience.spatialImagingFocusActive ? 430 : 360) : 232",
        'showsStudyTools ? "Hide tools" : "Study tools"',
        'experience.spatialImagingFocusActive ? "Place beside brain" : "Focus"',
        'Text("Generic teaching reference · not a patient scan")',
    )),
    "the default imaging study is still control-heavy instead of prioritizing the selected teaching image",
)
imaging_header = immersive.split('private struct StrokeSpatialImagingPlate', 1)[-1].split(
    '// The image stays primary,', 1
)[0]
imaging_header_actions = imaging_header.split('Button("Back", systemImage: "chevron.backward")', 1)[-1]
require(
    '.accessibilityIdentifier("stroke-imaging-move-handle")' in imaging_header
    and '.accessibilityIdentifier("stroke-imaging-back")' in imaging_header_actions
    and '.gesture(plateDragGesture' not in imaging_header_actions
    and '.simultaneousGesture(plateMagnifyGesture' not in imaging_header_actions,
    "image header navigation still shares a drag or magnify gesture with its buttons",
)
require(
    '.accessibilityIdentifier("stroke-imaging-focus")' in immersive,
    "the placed-image Focus control has no stable interaction-test identifier",
)
imaging_trace = state.split("enum StrokeImagingInteractionTrace", 1)[-1].split("extension View", 1)[0]
require(
    all(token in imaging_trace for token in (
        "enum Event: String",
        "#if DEBUG && targetEnvironment(simulator)",
        'ProcessInfo.processInfo.environment["STROKE_TRACE_IMAGING"] == "1"',
        'category: "ImagingInteraction"',
        "event.rawValue, privacy: .public",
        "guard event != lastSceneEvent else { return }",
    ))
    and imaging_trace.count("logger.notice(") == 1
    and all(token in immersive for token in (
        "StrokeImagingInteractionTrace.record(.ready)",
        "StrokeImagingInteractionTrace.record(.focusButton)",
        "StrokeImagingInteractionTrace.record(.backButton)",
        "StrokeImagingInteractionTrace.sceneApplied(",
    )),
    "imaging interaction diagnostics must be opt-in, Simulator-debug-only, fixed events with distinct button and scene receipts",
)
require(
    "--proof-spatial-annotation" in launch
    and "prepareSpatialAnnotationProof" in launch
    and "prepareSpatialAnnotationProof" in state
    and "--proof-spatial-annotation" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text(),
    "deterministic spatial-annotation proof route is missing",
)
require(
    all(token in state for token in (
        "struct StrokeSpatialInkStroke",
        "spatialInkVisible",
        "spatialInkStrokes: [StrokeSpatialInkStroke]",
        "func beginSpatialInk(at point: CGPoint)",
        "func continueSpatialInk(at point: CGPoint)",
        "func undoSpatialInk()",
        "func clearSpatialInk()",
        "guard audienceLens == .clinician",
    )),
    "clinician spatial ink is missing normalized state, editing, or role gating",
)
require(
    all(token in immersive for token in (
        "StrokeSpatialInkSurface",
        '"spatial-clinician-ink-surface"',
        'Label("INK OVERLAY", systemImage: "pencil.tip.crop.circle.fill")',
        "DragGesture(minimumDistance: 0)",
        "GENERIC TEACHING MARKUP · NOT A MEASUREMENT OR PROCEDURE PLAN",
        "!experience.spatialInkVisible",
    )),
    "transparent spatial ink surface is missing pinch-draw interaction or safety boundary",
)
require(
    "--proof-spatial-ink" in launch
    and "prepareSpatialInkProof" in launch
    and "prepareSpatialInkProof" in state
    and "--proof-spatial-ink" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text(),
    "deterministic spatial-ink proof route is missing",
)
require(
    "experience.openReferenceWorkspace(.settings)" in immersive
    and "experience.audienceLens == .clinician" in immersive
    and "experience.spatialImagingPlateVisible" in immersive
    and "StrokeTeachingImageDeckSection.allCases" in immersive,
    "placed imaging loses its persistent reference-ring controls or explicit subfield selector",
)
require(
    all(token in imaging_workspace for token in (
        "enum StrokeTeachingImageReference",
        "VesselMapSchematic",
        "CTTeachingSchematic",
        "MRITeachingSchematic",
        'assetName: "StrokeCTTemplate"',
        'assetName: "StrokeMRITemplate"',
        "X-RAY-BASED CT TEMPLATE",
        "Kaffenberger et al. · CC BY 4.0",
        "not a patient scan or result",
    )),
    "shared CT, MRI, and vessel teaching references are incomplete",
)
require(
    all((ROOT / path).exists() for path in (
        "Resources/Assets.xcassets/TeachingImaging/StrokeCTTemplate.imageset/StrokeCTTemplate.png",
        "Resources/Assets.xcassets/TeachingImaging/StrokeMRITemplate.imageset/StrokeMRITemplate.png",
        "Docs/IMAGING_REFERENCE_PROVENANCE.md",
    )),
    "openly licensed CT/MRI atlas images or their provenance record are missing",
)
require(
    all(token in state for token in (
        "spatialImagingAnnotationEnabled",
        "spatialImagingInkStrokes: [StrokeSpatialInkStroke]",
        "func toggleSpatialImagingAnnotation()",
        "func beginSpatialImagingInk(at point: CGPoint)",
        "func continueSpatialImagingInk(at point: CGPoint)",
        "func undoSpatialImagingInk()",
        "func clearSpatialImagingInk()",
        "resetSpatialImagingAnnotation()",
    ))
    and all(token in immersive for token in (
        "StrokeSpatialImagingInkLayer",
        'Done" : "Annotate scan',
        '"Done B" : "Annotate B"',
        '"Finish annotating scan"',
        "experience.beginSpatialImagingInk(at: point)",
        "GENERIC TEACHING MARKUP · NOT A MEASUREMENT",
    )),
    "the placed atlas image is missing direct temporary annotation interaction",
)
require("focusLight.isEnabled = experience.environmentMode != .surroundings" in immersive and "high-density cortex reads like flat clay" in immersive, "warm anatomy field is missing its sculpting key light")
require(all(copy in scene for copy in ("Stroke effect", "Brain surface", "Making-room purpose")) and all(copy in immersive for copy in ("FULL ARTERIAL TREE · TEACHING VIEW", "WHOLE BRAIN SURFACE · TEACHING VIEW", "Complete generic arterial structure · not a patient scan", "Complete generic brain surface · not a patient scan", "Registered-v2 teaching asset · review pending")), "registered teaching-lens boundaries or point-owned structure sequence are missing")
require(
    "func teachingReferencePlainSummary(" in state
    and all(copy in state for copy in (
        "This area relies on the highlighted vessel route.",
        "Nearby tissue stays visible so this point is not viewed alone.",
        "The selected point opens its larger teaching context.",
    ))
    and "familyArterialReferenceSummary" in immersive
    and "Follow the orange cue from a larger artery into smaller branches." in immersive
    and 'Text("ARTERIAL PATH · 3D TEACHING MODEL")' in immersive
    and 'Text("3D ATLAS · \\(selectedPointLabel.uppercased())")' not in immersive
    and "experience.teachingReferencePlainSummary()" in immersive,
    "family point references are missing their concise relationship-first explanation",
)
require(all(token in scene for token in ("registered-teaching-imaging-root", "registered-teaching-imaging-affected-vessel", "registered-teaching-imaging-brain-surface", "registered-teaching-imaging-making-room-purpose", "cerebral_arteries_realistic_v2", "brain_anatomy_realistic_v2", "ischemic_mca_clot_v2", "dura_mater_cutaway_conceptual_v2")), "registered-v2 teaching miniature or required leaf assets are missing")
require("affected-brain-context" in scene and "OpacityComponent(opacity: 0.18)" in scene, "arterial teaching reference no longer preserves a quiet whole-brain context")
require(all(token in scene for token in ("purpose-skull-context", "purpose-brain-context", "skull_semantic_realistic_v2")), "making-room reference no longer preserves its complete skull-dura-brain relationship")
require(
    "StrokeTeachingImagingSchematic" not in immersive,
    "rejected procedural imaging plates remain in the runtime UI",
)
require("teachingImagingDrawerVisible = false" in state and "teachingImagingLens" in state and "selectTeachingImagingLens" in state and "careViewPermissionGranted" in state and "present(step: .discussCare" in state, "teaching lens is not explanation-gated or consent-aware")
require(
    state.count("selectedPointEntityName != nil else {") >= 2
    and "toggleTeachingImagingDrawer()" in state
    and "func selectTeachingImagingLens(" in state,
    "teaching reference can open without an authored point selection",
)
require("updateRegisteredTeachingImaging" in scene and "miniature.parent !== stageRoot" in immersive and "registeredTeachingImagingSuggestedStagePosition" in immersive, "registered teaching lens is not mutually selected and world-locked")
require("let miniature = stageRoot.findEntity(" in immersive and "root.findEntity(\n                        named: StrokeSceneFactory.registeredTeachingImagingRootName" not in immersive, "world-locked teaching reference stops updating after reparenting")
require("--proof-teaching-imaging" in launch and "prepareTeachingImagingProof" in state, "deterministic teaching imaging proof route is missing")
require(
    all(token in state for token in (
        "spatialImagingImportByteLimit = 24 * 1_024 * 1_024",
        "spatialImagingLocalImageData: Data?",
        "spatialImagingLocalComparisonImageData: Data?",
        "spatialImagingLocalImageModality: StrokeImagingModality",
        "spatialImagingLocalComparisonImageModality: StrokeImagingModality",
        "spatialImagingFocusActive",
        "spatialImagingFocusReturnPosition",
        "func toggleSpatialImagingFocus()",
        "spatialImagingPlatePosition = [0, 1.62, -0.90]",
        "func selectSpatialImagingModality(_ modality: StrokeImagingModality, comparison: Bool)",
        "func cycleSpatialImagingModality(comparison: Bool)",
        "spatialImagingComparisonDetached",
        "func placeSpatialImagingLocalImage(data: Data, displayName: String) -> Bool",
        "func placeSpatialImagingLocalComparisonImage(data: Data, displayName: String) -> Bool",
        "func toggleSpatialImagingComparisonSeparation()",
        "func moveSpatialImagingComparisonPlate(translation: CGSize)",
        "func scaleSpatialImagingComparisonPlate(by magnification: CGFloat)",
        "func beginSpatialImagingComparisonInk(at point: CGPoint)",
        "func attachSelectedPointContextToSpatialImaging(comparison: Bool)",
        "func moveSpatialImagingPointContextAnchor(to point: CGPoint, comparison: Bool)",
        "spatialImagingPrimaryContextTitle: String?",
        "spatialImagingComparisonContextTitle: String?",
        "spatialImagingPrimaryContextAnchor: CGPoint?",
        "spatialImagingComparisonContextAnchor: CGPoint?",
        "UIImage(data: data) != nil",
        "func clearSpatialImagingLocalImage()",
        "func clearSpatialImagingLocalComparisonImage()",
        "prepareLocalImagingImportProof()",
        "prepareImagingModalityReferenceProof()",
    ))
    and all(token in immersive for token in (
        '"LOCAL A · \\(experience.spatialImagingLocalImageModality.rawValue.uppercased()) · MEMORY ONLY"',
        'Text("NOT UPLOADED · NOT INTERPRETED")',
        '"CHOOSE OR DROP LOCAL A"',
        '"ADD OR DROP LOCAL B"',
        'Text("SIDE BY SIDE · NOT REGISTERED")',
        '"SEPARATE INTO SPACE"',
        '"LOCAL B · INDEPENDENT PLATE"',
        "StrokeSpatialImagingComparisonPlate()",
        "StrokeSpatialImagingComparisonInkLayer()",
        "StrokeSpatialImagingPointContextCard(",
        "StrokeSpatialImagingDiscussionMarker(",
        'Text("MANUAL MARKER · FROM SELECTED POINT · NOT AN IMAGE FINDING")',
        'Label("MODALITY \\(plate) · \\(modality.rawValue.uppercased())"',
        'Text("PRESENTER SELECTED · NOT INFERRED")',
        '"FOCUSED LOCAL IMAGE"',
        '"Focus image in room"',
        '"Return beside brain"',
        'accessibilityHint("Pinch and drag to place. This is not an image finding or registration.")',
        ".dropDestination(for: Data.self)",
        ".fileImporter(",
        "Choose de-identified primary image",
        "Choose de-identified comparison image",
    ))
    and "--proof-imaging-local-import" in launch
    and "--proof-imaging-local-import" in simulator_proof
    and '"--proof-imaging-local-import": ("focused local image", "discussion prompt", "manual marker", "return beside brain")' in proof_image_check,
    "local clinician imaging lacks separable spatial images with manual point-linked discussion markers or deterministic proof",
)
require(
    all(token in immersive for token in (
        "referenceSelectionControls",
        '"STUDY · \\(experience.spatialImagingReference.rawValue)"',
        '"Close study deck"',
        '"Keeps the current teaching reference and returns to its image tools"',
        '"STUDY DECK"',
        '"Choose a teaching modality. Close: image tools; Back: brain explanation."',
        '"Current study"',
        'StrokeTeachingImageDeckSection.allCases',
        'section.title',
        'section.summary',
        'section.references',
        'ScrollView(.vertical, showsIndicators: false)',
        "height: isChoosingStudy ? 640 : (isReadingTermNote ? 470 : (showsStudyTools ? 700 : (experience.spatialImagingFocusActive ? 690 : 620)))",
        "let isReadingTermNote = referenceDetailsVisible",
        "termNoteIntroducedFocus",
        "openTermNote()",
        "closeTermNote()",
        "onChange(of: experience.spatialImagingPlateVisible)",
        "isMarking || isReadingTermNote ? .none : .all",
        '"FOCUSED TERM NOTE"',
        '"Reading position · source note"',
        "Pinch the technical term to bring this teaching image forward",
        "onReturnToStudy:",
        '"Back to study"',
        '"Back to study returns to the selected teaching image. Back exits the image and returns to the brain explanation."',
        "StrokeTeachingImagingReferenceDetails",
    ))
    and '"SOURCE-AWARE TERM NOTE"' not in immersive
    and '"OUTER BACK RETURNS TO THE BRAIN EXPLANATION"' not in immersive
    and all(token in imaging_workspace for token in (
        "CTA · GENERIC VASCULAR OVERVIEW",
        "MRA · GENERIC VASCULAR OVERVIEW",
        "PET · FUNCTIONAL TEACHING OVERVIEW",
        "sourceKind",
        "sourceActionTitle",
        '"Read open research atlas"',
        '"Read guideline context"',
        '"Read science overview"',
    ))
    and "--proof-imaging-modality-reference" in launch
    and "--proof-imaging-modality-reference" in simulator_proof
    and '"--proof-imaging-modality-reference"' in proof_image_check,
    "imaging lacks a compact multi-modality teaching selector, term-linked source note, or deterministic returnable proof",
)
require(
    all(token in imaging_workspace for token in (
        "PET uses radiotracers to create images of functional molecular processes",
        '"NIH NIBIB · nuclear medicine overview"',
        '"Read science overview"',
    ))
    and "func prepareImagingPETTermNoteProof()" in state
    and "--proof-imaging-pet-term-note" in launch
    and "--proof-imaging-pet-term-note" in simulator_proof
    and '"--proof-imaging-pet-term-note"' in proof_image_check,
    "functional imaging lacks a source-aware generic PET term-note proof",
)
require(
    all(token in imaging_workspace for token in (
        'var deckCategory: String',
        'var deckSummary: String',
        '"STRUCTURE"',
        '"VESSELS"',
        '"FUNCTION"',
    ))
    and all(token in immersive for token in (
        "reference.deckCategory",
        "reference.deckSummary",
    ))
    and "prepareImagingStudyDeckProof" in state
    and "--proof-imaging-study-deck" in launch
    and "--proof-imaging-study-deck" in simulator_proof
    and '"--proof-imaging-study-deck"' in proof_image_check,
    "the in-space imaging study deck does not visibly distinguish structural, vascular, and functional generic references",
)
require(
    all(token in immersive for token in (
        "let placedImagingMode = !isFamily && experience.spatialImagingPlateVisible",
        "let focusedImagingMode = !isFamily && experience.spatialImagingFocusActive",
        "let annotationImagingMode = !isFamily && experience.spatialImagingAnnotationEnabled",
        "let imageWorkingMode = placedImagingMode || focusedImagingMode || annotationImagingMode",
        "drawer.isEnabled = visible &&\n                !imageWorkingMode",
        "scholarRail.isEnabled = visible &&\n                experience.audienceLens == .clinician &&\n                !imageWorkingMode",
        "!(id == presenterControlsID && imageWorkingMode)",
        "!experience.spatialImagingPlateVisible &&",
        "!imageWorkingMode\n                            && !atlasOwnsSelection",
        "if showsStudyTools && !experience.spatialImagingFocusActive && !isMarking {",
        "Marking image · Done to move",
        "!experience.spatialImagingAnnotationEnabled &&",
        "if !showsStudyTools && !isMarking && !isReadingTermNote {",
        '"Return beside brain"',
    )),
    "focused or active-markup imaging does not quiet unrelated presenter surfaces while preserving a visible return",
)
require(
    all(token in scene for token in (
        "let clinicianImagingStudyOpen = experience.audienceLens == .clinician &&",
        "experience.spatialImagingPlateVisible",
        "!clinicianImagingStudyOpen",
        "let isImagingStudyContext = isClinicianExplanation && experience.spatialImagingPlateVisible",
        "let imagingCortexOpacity",
        "let imagingArteriesOpacity",
        "let imagingBlockageOpacity",
    )),
    "a placed teaching image leaves a noisy anatomy field behind its working surface",
)
require(
    all(token in state for token in (
        "spatialImagingDefaultPlatePosition",
        "StrokeExperienceState.spatialImagingDefaultPlatePosition",
        "Self.spatialImagingDefaultPlatePosition",
        "spatialImagingPlatePosition = [0.54, 1.43, -0.82]",
    )),
    "the imaging study deck has no stable right-secondary-field default or deterministic proof placement",
)
require(
    all(token in state for token in (
        "func returnToAnatomyFromSpatialImaging()",
        "spatialImagingPlateVisible = false",
        "spatialImagingFocusActive = false",
        "resetSpatialImagingAnnotation()",
        "clearSpatialImagingLocalImage()",
        "func hideSpatialImagingPlate()",
        "returnToAnatomyFromSpatialImaging()",
    ))
    and all(token in immersive for token in (
        'Button("Back", systemImage: "chevron.backward")',
        'experience.returnToAnatomyFromSpatialImaging()',
        'accessibilityLabel("Back to anatomy")',
    ))
    and all(token in imaging_workspace for token in (
        'experience.returnToAnatomyFromSpatialImaging()',
        'dismissWindow(id: StrokeSpace.imaging)',
    )),
    "imaging has no explicit, state-clearing way back to the anatomy explanation",
)
require(
    all(token in immersive for token in (
        "onChange(of: experience.spatialImagingPlateVisible)",
        "referenceDetailsVisible = false",
        "termNoteIntroducedFocus = false",
        "referencePickerVisible = false",
        "localImageDisclosureVisible = false",
        "localImageImporterVisible = false",
        "localImageStatus = nil",
        "localImageImportTarget = .primary",
    )),
    "outer imaging Back can retain a stale local study deck, source note, or image-import surface",
)
require(
    all(token in state for token in (
        "func prepareImagingReturnToAnatomyProof()",
        "prepareImagingModalityReferenceProof()",
        "spatialImagingAnnotationEnabled = true",
        "toggleSpatialImagingFocus()",
        "returnToAnatomyFromSpatialImaging()",
    ))
    and "--proof-imaging-return-to-anatomy" in launch
    and "--proof-imaging-return-to-anatomy" in simulator_proof
    and '"--proof-imaging-return-to-anatomy"' in proof_image_check,
    "imaging recovery has no deterministic receipt that exercises a focused annotated study before returning to anatomy",
)
require(
    all(token in immersive for token in (
        "returnReopenProofHasRun",
        "runImagingReturnReopenProofIfNeeded()",
        'CommandLine.arguments.contains("--proof-imaging-return-reopen")',
        "referencePickerVisible = true",
        "experience.returnToAnatomyFromSpatialImaging()",
        "experience.placeSpatialImagingPlate(.ctaGuide)",
        "experience.resetSpatialImagingPlateTransform()",
    ))
    and "func prepareImagingReturnReopenProof()" in state
    and "--proof-imaging-return-reopen" in launch
    and "--proof-imaging-return-reopen" in simulator_proof
    and '"--proof-imaging-return-reopen"' in proof_image_check,
    "imaging cannot prove that its visible study deck clears before a later reopen",
)
require(
    all(token in immersive for token in (
        "termReturnReopenProofHasRun",
        "runImagingTermReturnReopenProofIfNeeded()",
        'CommandLine.arguments.contains("--proof-imaging-term-return-reopen")',
        "returnToAnatomyFromPlate()",
        "resetLocalImagingSurface()",
        "experience.placeSpatialImagingPlate(.ctaGuide)",
    ))
    and "func prepareImagingTermReturnReopenProof()" in state
    and "--proof-imaging-term-return-reopen" in launch
    and "--proof-imaging-term-return-reopen" in simulator_proof
    and '"--proof-imaging-term-return-reopen"' in proof_image_check,
    "imaging cannot prove that a focused term source note clears before its selected study is reopened",
)
require("--proof-main-overview" in launch and "prepareMainOverviewProof" in state, "dots-first main overview proof route is missing")
require("--proof-clinician-layer-hierarchy" in launch and "prepareClinicianLayerHierarchyProof" in state and "selectDetailLevel(.scholar)" in state, "scholar clinician layer-hierarchy proof route is missing")
require("--proof-main-selected-point" in launch and "prepareTeachingImagingProof" in state, "selected-point main proof route is missing")
require(
    "func traceProcedureRoute(by offset: Int)" in state
    and "selectedProcedurePointIndex" in state
    and "procedureRouteProgressLabel" in state
    and "QUALITATIVE ROUTE · NOT A MEASUREMENT" in immersive
    and "vesselRouteControls" in immersive
    and "Previous vessel relationship" in immersive
    and "Next vessel relationship" in immersive,
    "the selected vascular reference is not an interactive five-step route trace",
)
require(
    "--proof-family-vessel-route-trace" in launch
    and "prepareFamilyVesselRouteTraceProof" in state
    and "--proof-family-vessel-route-trace" in simulator_proof,
    "the deterministic family vessel-route trace proof is missing",
)
require(
    "func enterSelectedBlockageLesson()" in state
    and "Open vessel detail" in immersive
    and "startContextualBlockageLesson()" in immersive
    and "startFlowRide()" in immersive
    and "Separate teaching scene · qualitative flow · not a patient scan or treatment simulation" in immersive
    and "Return to Stroke Care" in internal_hud
    and "You are inside a cerebral artery" in internal_hud
    and "--proof-family-blockage-interior" in launch
    and "prepareFamilyBlockageInteriorProof" in state
    and "--proof-family-blockage-interior" in simulator_proof,
    "the selected blockage does not open the authored vessel study with a return path",
)
require(
    "prepareFamilyBlockageReturnProof" in state
    and "--proof-family-blockage-return" in launch
    and "--proof-family-blockage-return" in simulator_proof
    and "returnFromInternalBrainLesson" in immersive
    and "internalJourney.stopFlowRide()" in immersive
    and "experience.returnToExteriorLessonContext()" in immersive
    and "selectedBlockageExteriorZoom" in state
    and "selectedBlockageExteriorOrbit" in state,
    "the selected vessel lesson has no deterministic receipt that uses its real return handler and clears a stale flow ride",
)
require(
    "scaffold.components.set(OpacityComponent(opacity: 0.045))" in internal_scene
    and "let corticalContextOpacity: Float = (0.045 + sin(flowRideElapsed * 0.24) * 0.006)" in internal_scene
    and "inhabited-main-arterial-intima" in internal_scene
    and "buildPeripheralArteryAssembly" in internal_scene
    and "flowRideShellRoot.isEnabled = false" in internal_scene
    and "RBC_FLOW_PERIPHERAL_ASSEMBLY=READY" in internal_scene
    and "RBC_FLOW_WALL_PBR=QUARANTINED" in internal_scene
    and "generated_lumen_uv_projection_obscures_teaching_route" in internal_scene
    and "Keep the imported cutaway detached from the rendered scene" in internal_scene,
    "the arterial-lumen study does not keep cortical context quiet while rendering a peripheral artery assembly and quarantining an incompatible PBR projection",
)
require("let revealAll = experience.pointField != .craniotomy" in scene and "generateSphere(radius: 0.0042)" in scene and "selectedLessonPointMaterial" in scene, "lesson clouds are not visibly distinct and fully discoverable around the main anatomy")
require("selectLessonPoint(initialPoint)" not in state and "clearPointSelection()" in state, "lesson family still auto-selects a label instead of beginning dots-first")
require("clotTarget.position = clotSurfaceMarker" in scene and 'clotBeacon.name = "registered-clot-focus-beacon"' in scene, "registered clot target is not visibly derived from the loaded clot surface")
require(all(token in scene for token in (
    'registeredPressureStoryName = "registered-pressure-story"',
    'registeredPressureBlockageCueName = "registered-pressure-blockage-cue"',
    'registeredPressureAffectedCueName = "registered-pressure-affected-tissue-cue"',
    'registeredPressureSwellingCueName = "registered-pressure-swelling-cue"',
    "let affectedSurfaceMarker = brainCenter + brainRadii * affectedDirection * 1.018",
    "mesh: .generateCylinder(height: 0.0022, radius: 0.030)",
    "for index in 0..<14",
    "experience.procedureStep != .chooseCase",
    "pressureStory?.isEnabled = showsPressureFocus",
)), "registered-frame blockage, affected-tissue, and constrained-swelling Pressure cues are incomplete")
require(
    "imported.findEntity(named: importedEdemaName)?.isEnabled = false" in scene
    and "imported.findEntity(named: importedFlapName)?.isEnabled = false" in scene
    and "imported.findEntity(named: importedPatchName)?.isEnabled = false" in scene,
    "prototype-v1 pressure/open-cranial meshes escaped quarantine",
)
require(all(token in state for token in (
    "prepareFamilyPressureStoryProof",
    "prepareClinicianPressureStoryProof",
    "pointField = .regions",
    "clearPointSelection()",
)), "family and clinician Pressure-story proof states are missing")
require(all(token in launch for token in (
    '"--proof-family-pressure-story"',
    '"--proof-clinician-pressure-story"',
)), "deterministic family/clinician Pressure-story routes are missing")
require(all(token in state for token in (
    "familyDiscoveryHintVisible",
    "showFamilyDiscoveryHint(autoDismiss: false)",
    "dismissFamilyDiscoveryHint()",
)) and "LOOK, THEN PINCH" in immersive
and "One idea opens at a time" in immersive
and '"--proof-family-entry-hint"' in launch, "transient family point-discovery hint or deterministic route is missing")
require("experience.selectedPointEntityName != nil" in immersive and "selected.uppercased()" in immersive, "main explanation appears before point selection or fails to identify the selected target")
require(all(token in state for token in (
    "Every anatomy-attached point owns one matching spatial reference",
    "teachingImagingLens = .affectedVessel",
    "teachingImagingLens = .makingRoomPurpose",
    "teachingImagingDrawerVisible = careViewPermissionGranted",
    "toggleSelectedPointReference()",
)), "point selection does not keep one consent-aware, act-matched reference available")
require(
    "experience.presenterTeachingBeat == .discussAccess &&\n            experience.selectedPointEntityName == nil" in scene,
    "selected-point reference competes with the large access-skull composition",
)
require(all(token in immersive for token in (
    "private var selectedPointMeaning: String?",
    'case "Example blockage":',
    '"A teaching clot interrupts the route; motion is qualitative—not CFD."',
    'case "Flow beyond the blockage changes":',
    '"Fewer cues continue beyond the example blockage; no perfusion value is inferred."',
)), "selected flow points can inherit unrelated checkpoint copy or quantitative physiology claims")
require(all(token in immersive for token in (
    "let pointPosition = selectedPoint.position(relativeTo: stageRoot)",
    "+ [0.17 * pointSide, 0.08, 0.20]",
    "let annotationScale: Float = selectedPoint == nil ? 0.48 : 0.78",
    'Text(experience.pointField == .procedure ? "VESSEL STORY" : "BRAIN ATLAS")',
    ".frame(maxWidth: 310, alignment: .leading)",
    ".background(.black.opacity(0.56), in: RoundedRectangle(cornerRadius: 12))",
)) and "ForEach(experience.pointField.lessonPoints)" not in immersive
and "stroke-selected-point-callout-connector" not in immersive
and "updateCalloutConnectorSegment" not in immersive,
"selected-point disclosure is still a permanent label rail, inherits hero scale, or overlaps anatomy")
require('"Images"' not in immersive and '"Close images"' not in immersive, "duplicated image-browser controls remain in the spatial role rails")
require(all(token in immersive for token in (
    '"FULL ARTERIAL TREE · TEACHING VIEW"',
    '"WHOLE BRAIN SURFACE · TEACHING VIEW"',
    '"AFFECTED-VESSEL REFERENCE"',
    '"Complete generic arterial structure · not a patient scan"',
    '"Complete generic brain surface · not a patient scan"',
    '"Registered-v2 teaching asset · review pending"',
    'Text("FROM \\(isCombinedInternalChapter' ,
    'selectedPointLabel.uppercased())")',
    '"COMBINED 3D CONTEXT"',
    '"QUALITATIVE ROUTE · NOT A MEASUREMENT"',
)), "right-side teaching reference lacks role-safe selected-point captions")
require(all(token in immersive for token in (
    "StrokeScholarReferenceRail",
    '.accessibilityLabel("Scholar references")',
    "var railTitle: String",
    "case anatomy",
    "case imaging",
    "case interventions",
    "case medications",
    "case outcomes",
    "case guidelines",
    "case teachingModel",
    'Text("REFERENCE")',
    'Text("SETTINGS")',
    'Text("VISUAL DETAIL")',
    'detailStepButton(',
    'experience.cycleDetailLevel(by: offset)',
    'Label("Teaching model brief", systemImage: "cube.transparent")',
    "StrokeScholarReferenceArc()",
    "ForEach(visibleLanes)",
    "@State private var inlineDetailsVisible: Bool",
    'CommandLine.arguments.contains("--proof-presentation-settings")',
    "inlineDetailsVisible && !experience.teachingImagingDrawerVisible",
    "var supportsInlineDetails: Bool",
    '"Pinch to show the selected reference details"',
    "Image(systemName: trailingSymbol(",
    ".frame(minHeight: 60)",
    "private func tab(",
    "experience.placeSpatialImagingPlate(.ctGuide)",
    "experience.selectedScholarReferenceCategory == lane.category",
    "experience.selectScholarReferenceCategory(lane.category)",
    "StrokeScholarReferenceLane.allCases.filter { $0 != .outcomes }",
    "experience.selectLessonFamily(.craniotomy)",
    "experience.openReferenceWorkspace(.medications)",
    "experience.openReferenceWorkspace(.guides)",
    "experience.openReferenceWorkspace(.settings)",
    "experience.selectEvidence(guideline)",
    "openWindow(id: StrokeSpace.evidence, value: StrokeSpace.evidence)",
    "openWindow(id: StrokeSpace.printRequest, value: StrokeSpace.printRequest)",
    ".frame(width: 248)",
    "scholarRail.position = [0.70, 1.68, -0.96]",
    "StrokeTeachingImageDeckSection.allCases",
)), "reference ring lacks gaze-sized targets, imaging subfields, or truthful authored actions")
require(all(token in state for token in (
    "enum StrokeScholarReferenceCategory: String, CaseIterable, Identifiable",
    "@Published private(set) var selectedScholarReferenceCategory: StrokeScholarReferenceCategory = .anatomy",
    "func selectScholarReferenceCategory(_ category: StrokeScholarReferenceCategory)",
    "guard category != .imaging else { return }",
    "teachingImagingDrawerVisible = false",
    "spatialImagingPlateVisible = false",
    "spatialImagingDragOrigin = nil",
    "selectedScholarReferenceCategory = .imaging",
)), "reference ring can retain stale imaging or expose multiple selected categories")
require(all(token in state for token in (
    "enum StrokeAnatomyFocus",
    'case whole = "Whole"',
    'case vessels = "Vessels"',
    'case internalStructures = "Internal"',
    'case surfaceContext = "Surface"',
    "func selectAnatomyFocus(_ focus: StrokeAnatomyFocus)",
    "func updateAvailableAnatomyFocuses(_ focuses: Set<StrokeAnatomyFocus>)",
    "availableAnatomyFocuses.contains(focus)",
    "Venous reference unavailable · Whole view restored",
    "Internal references unavailable · Whole view restored",
    "Surface context unavailable · Whole view restored",
    "focus.requiresScholar",
    "anatomyFocus = .whole",
    "prepareAnatomyInternalFocusProof",
)), "clinician anatomy focus lacks guarded Whole, Vessels, and Internal states")
require(
    "let minimumFocusZoom: Double = focus == .internalStructures ? 1.70 : 1.28" in state
    and "spatialZoom = max(spatialZoom, minimumFocusZoom)" in state,
    "Internal focus does not preserve a wearer's larger zoom or supply a readable live-study scale"
)
require(all(token in immersive for token in (
    'Text("ANATOMY FOCUS")',
    "ForEach(StrokeAnatomyFocus.allCases)",
    "experience.selectAnatomyFocus(focus)",
    "experience.anatomyFocusStatus",
    "experience.isAnatomyFocusAvailable(focus)",
    "Unavailable in this build",
    "minHeight: 44",
)), "reference ring lacks a directly selectable, accessible anatomy subsystem hierarchy")
require(all(token in scene for token in (
    "let anatomyFocus = experience.anatomyFocus",
    "anatomyFocus == .vessels",
    "anatomyFocus == .internalStructures",
    "anatomyFocus == .surfaceContext",
    "anatomyFocus != .internalStructures",
    "experience.detailLevel == .scholar",
)), "registered arterial, venous, deep-structure, and ventricular geometry does not follow anatomy focus")
require(
    "!isolateScholarSkull && !showsInternalStudy" in scene,
    "the external cortical shell can still obscure the explicit Internal study"
)
require(all(token in launch for token in (
    '"--proof-anatomy-internal"',
    "prepareAnatomyInternalFocusProof",
    '"--proof-anatomy-vessels"',
    "prepareAnatomyVesselsFocusProof",
    '"--proof-anatomy-surface"',
    "prepareAnatomySurfaceFocusProof",
)), "deterministic vessels/internal anatomy-focus proof routes are missing")
require(
    "--proof-anatomy-internal" in simulator_proof
    and '"--proof-anatomy-internal": ("internal", "anatomy")' in proof_image_check,
    "high-detail Internal anatomy lacks a screenshot-verifiable Simulator route",
)
require(all(token in launch for token in (
    '"--proof-anatomy-vessels-unavailable"',
    '"--proof-anatomy-internal-unavailable"',
)), "deterministic optional-anatomy failure proof routes are missing")
require(all(token in scene for token in (
    "static func availableAnatomyFocuses(in root: Entity)",
    'arguments.contains("--proof-anatomy-vessels-unavailable")',
    'arguments.contains("--proof-anatomy-internal-unavailable")',
)), "optional registered layers lack a live availability report and deterministic failure injection")
require(all(token in immersive for token in (
    'Text("SHARED DISCUSSION")',
    '"This teaching view does not diagnose or recommend care."',
    '"What did imaging show? What are the options? What happens next?"',
    'experience.closingReflectionVisible',
)), "closing state lacks an honest shared-discussion summary in the active companion")
require(all(copy in state for copy in ("Explore the protective layers.", "Trace supply, blockage, and the tissue beyond.", "Review what generic access can—and cannot—show.")), "family act exploration guidance is incomplete")
require(all(copy in state for copy in ("Generic scenario", "Whole brain first", "Not a patient scan", "Blockage → injury → swelling", "Keep them distinct", "No prognosis inferred", "Ask before transparency", "Room, not repair", "No outcome promise")), "presenter three-point act cues are incomplete")
require('title: "Act \\(experience.procedureStep.number)"' not in immersive and 'compactControl("Act \\(experience.procedureStep.number)"' not in immersive, "redundant presenter act menu remains after adding the teaching timeline")
require("--proof-clinician-pressure" in launch, "deterministic presenter proof route is missing")
require("--proof-clinician-six-beat-timeline" in launch and "prepareClinicianSixBeatTimelineProof" in state and "selectPresenterTeachingBeat(.teamChecks" in state, "deterministic six-beat presenter timeline proof is missing")
require("--proof-clinician-protective-covering" in launch and "prepareClinicianProtectiveCoveringProof" in state and "selectPresenterTeachingBeat(.protectiveCovering" in state, "deterministic protective-covering composition proof is missing")
require("--proof-clinician-craniotomy" in launch and "prepareClinicianCraniotomyStoryProof" in state, "deterministic conceptual craniotomy-story proof is missing")
require(
    'readonly PROOF_ROUTE="--hackathon-demo"' in xcat_deploy,
    "XCAT deployment bypasses the complete showcase journey",
)
require(
    "caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFigureName)?.isEnabled = false" in immersive
    and '"SELECTED FICTIONAL DOSSIER"' in immersive
    and '"Next view uses generic teaching anatomy—not this person\'s scan"' in immersive,
    "the anonymous review bust was not replaced by a selected fictional dossier centerpiece",
)
require(
    "setAnatomyViewpoint(.lateralA, reduceMotion: true)" in state
    and "spatialZoom = 1.12" in state,
    "the craniotomy proof no longer uses the bounded lateral demo framing",
)
require(
    "experience.isInteriorPortalAvailable" in immersive
    and "experience.enterInternalBrainMode()" in immersive
    and "experience.internalBrainModeActive" in immersive
    and "RBCJourneyImmersiveView" in immersive
    and '"ENTER THE BRAIN"' in immersive,
    "room-scale magnification does not expose the in-app inside-brain transition",
)
require(
    "returnToStrokeCare:" in immersive
    and "experience.returnToExteriorLessonContext()" in immersive,
    "the internal journey lacks an explicit return to the exterior explanation",
)
require(
    "RBCRegionInfoHUD(returnToStrokeCare: returnToStrokeCare)" in internal_root.joinpath("Sources/RBCJourneyImmersiveView.swift").read_text()
    and 'returnToStrokeCare == nil ? "Exit" : "Return to Stroke Care"' in internal_hud,
    "a region lesson can strand the integrated learner without a direct Stroke Care return",
)
require(all(token in immersive for token in (
    'Text("ENTER THE BRAIN")',
    'Text("Guided vessel journey")',
    'background(accent.gradient, in: Capsule())',
)), "room-scale magnification lacks a prominent inside-brain handoff control")
require(
    "--proof-interior-handoff" in launch
    and "prepareInteriorHandoffProof" in state
    and "spatialZoom = 3.2" in state,
    "the visible Inside the Flow handoff lacks a deterministic room-scale proof route",
)
require(
    "--proof-integrated-interior" in launch
    and "--proof-integrated-ventricles" in launch
    and "--proof-integrated-cortex" in launch
    and "prepareIntegratedInteriorProof" in state
    and "--proof-integrated-interior" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and "--proof-integrated-cortex" in internal_model
    and "--proof-integrated-cortex-flow" in internal_model
    and "enterRegion(.corticalMicroarchitecture)" in internal_model
    and "activeCorticalMicroarchitectureTitle" in internal_model
    and "corticalLayerFocus" in internal_model
    and "selectCorticalLayer" in internal_model
    and "prepareIntegratedCortexProof" in internal_model
    and "activeCorticalLayerTitle" in internal_model
    and "RBCInternalSystemsCompactHUD()" in internal_hud
    and "RBCCorticalLayerFocusHUD()" in internal_hud
    and 'Text("PIAL SURFACE  →  DEEP BOUNDARY")' in internal_hud
    and 'case .flow: 0.24' in internal_scene
    and "corticalMicroarchitectureLayerGroups" in internal_scene
    and "corticalMicroarchitectureRuntimeLayerFocus" in internal_scene
    and "selected ? 1.0 : 0.055" in internal_scene
    and "group.position = [0, 0, layersReadingActive && selected ? 0.075 : 0]" in internal_scene
    and "Radial guides are an orientation aid" in internal_scene
    and "case .xray: 0.12" in internal_scene
    and "case .xray: 0.18" in internal_scene
    and "Each lens owns a single visual job" in internal_scene
    and "corticalMicroarchitectureColumnRoot?.isEnabled = visualization != .xray" in internal_scene
    and "corticalMicroarchitectureVesselRoot?.isEnabled = visualization != .xray" in internal_scene
    and "target.isEnabled = visualization == .locate" in internal_scene
    and "Keep its title inside the initial field of view" in internal_scene
    and "[0, 1.68, -1.04]" in internal_scene
    and "corticalMicroarchitectureLayerLabels" in internal_scene
    and "romanNumeral(forCorticalLayer: layerIndex + 1)" in internal_scene
    and "layersReadingActive" in internal_scene
    and "orientation index only" in internal_scene
    and "corticalMicroarchitectureFlowArrows" in internal_scene,
    "the in-app internal journey lacks a deterministic Simulator proof route",
)
require(
    "--proof-integrated-neural-gradient" in launch
    and "--proof-integrated-neural-gradient" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and "--proof-integrated-neural-gradient" in internal_model
    and '"An ion gradient stores potential."' in internal_model
    and '"Gradient"' in internal_hud
    and '"Signal"' in internal_hud
    and '"Synapse"' in internal_hud
    and "--proof-integrated-neural" in launch
    and "--proof-integrated-neural" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and "--proof-integrated-neural" in internal_model
    and "case neuralSignalling" in internal_model
    and "case .neuralActivity: .neuralSignalling" in internal_model
    and "enterRegion(.neuralSignalling)" in internal_model
    and "activeNeuralSignallingTitle" in internal_model
    and "RBC_NEURAL_SIGNALLING=READY" in internal_scene
    and "neuralSignallingImpulses" in internal_scene
    and "neuralSignallingIonParticles" in internal_scene
    and "neural-signalling-membrane-microdomain" in internal_scene
    and "qualitative-sodium-ion" in internal_scene
    and "qualitative-potassium-ion" in internal_scene
    and "schematic-synaptic-handoff" in internal_scene
    and "blood-supply-context-not-neural-pathway" in internal_scene
    and "not membrane voltage" in internal_scene,
    "neural activity still lacks a separate, bounded, explorable internal lesson",
)
require(
    "--proof-integrated-loading" in launch
    and "--proof-integrated-loading" in (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
    and "loadingProofMode" in internal_model
    and "RBCJourneyLoadingVeil" in internal_immersive
    and "BUILDING THE BRAIN AROUND YOU" in internal_immersive
    and 'Attachment(id: "journeyLoading")' in internal_immersive
    and 'Button("Return to Stroke Care"' in internal_immersive
    and internal_immersive.index("content.add(loadingVeil)") < internal_immersive.index("content.add(scene.root)") < internal_immersive.index("await scene.build()"),
    "the internal scene can expose an unexplained or trapping black loading frame",
)
require(all(token in scene for token in (
    'openCranialReviewRootName = "registered-open-cranial-review-root"',
    'importedAccessScalpName = "scalp_access_closure_registered_conceptual_v1"',
    'importedAccessBoneName = "cranial_bone_access_closure_registered_conceptual_v1"',
    'importedAccessDuraName = "dural_access_closure_registered_conceptual_v1"',
    'importedAccessHematomaName = "intracerebral_hematoma_registered_conceptual_v1"',
    'importedAccessEdemaName = "cerebral_edema_registered_conceptual_v1"',
)), "registered conceptual access-layer assets are not loaded into one review-gated hierarchy")
require(all(token in scene for token in (
    "let showsAccessReference",
    "let showsProtectiveCovering",
    "let showsPurposeReference",
    "let showsClosureReference",
    "experience.presenterTeachingBeat == .discussAccess",
    "? [0.16, 0, 0]",
    "showsProtectiveCovering\n            ? [0.055, 0, 0.012]",
    "carePurposeStory?.isEnabled = showsPurposeReference",
)), "six presenter beats still change labels without distinct skull, dura, purpose, and closure compositions")
require(all(copy in immersive for copy in (
    'case .discussAccess: "SKULL REFERENCE"',
    'case .protectiveCovering: "PROTECTIVE COVERING"',
    'case .explainPurpose: "MAKING ROOM"',
    'case .teamChecks: "WHAT THE TEAM REASSESSES"',
    'case .explainClosure: "ASSEMBLED TEACHING VIEW"',
)), "presenter checkpoint annotation does not identify the active spatial explanation")
require("isImmersivePresented = false\n        advanceJourney()" not in state, "permission incorrectly resets the companion window")
require("pendingConsentStep" in state and "present(step: .discussCare" in state, "presenter direct-jump consent continuation is missing")
require(
    "boundary.isEnabled = !hasImportedBrain && experience.audienceLens == .clinician" in scene
    and "experience.procedureStep != .chooseCase" in scene,
    "the clinician pressure-boundary ring still leaks into the Family explainer",
)
require(all(token in state for token in (
    "@Published private(set) var focusedReferenceWorkspace: StrokeReferenceWorkspace?",
    "func openReferenceWorkspace(_ workspace: StrokeReferenceWorkspace)",
    "func closeReferenceWorkspace()", "focusedReferenceWorkspace = nil",
)), "focused reference navigation is not exclusive or recoverable")
require(all(token in reference_workspace for token in (
    'Button("Back", systemImage: "chevron.left")', "experience.closeReferenceWorkspace()",
    "case .settings: settings", "case .guides: guides", "case .medications: medications",
    "NHS medicine reference", "no dose or prescribing", "not actual medicine packaging",
    "experience.presenterPanelScale", "experience.selectDetailLevel(level)",
)), "reference workspace lacks functional content, settings, or Back")
gallery_model = (ROOT / "Sources/StrokeImagingGalleryModel.swift").read_text()
gallery_view = (ROOT / "Sources/StrokeImagingGalleryView.swift").read_text()
medicine_exhibit = (ROOT / "Sources/StrokeMedicationExhibit.swift").read_text()
require(all(token in gallery_model for token in (
    "case two = 2, three = 3, four = 4", "maximumImageCount = 40", "maximumBytes = 64",
    "guard pendingImport == request", "mutating func clearLocalImages()", "mutating func appendStroke",
)), "gallery lacks independent grid capacities, bounded imports, or image-specific ink")
require(all(token in gallery_view for token in (
    "allowsMultipleSelection: true", "CGImageSourceCreateThumbnailAtIndex", "kCGImageSourceThumbnailMaxPixelSize: 1_536",
    "experience.focusedReferenceWorkspace == .imagingGallery", 'Button("Gallery", systemImage: "chevron.left")',
    "experience.imagingGallery.pendingImport == request", "currentStroke.count < 1_000",
)), "gallery import or annotation cannot recover safely")
require(all(token in state for token in (
    "func placeImagingGalleryImage(_ id: UUID) -> Bool", "spatialImagingGalleryImage = source",
    "spatialImagingInkStrokes = image.strokes.map", "func prepareImagingGalleryPlacementProof",
)), "gallery cannot transfer its selected image and image-bound marks")
require('Button("Place beside brain"' in gallery_view and
        "StrokeImagingImageFit.rect" in gallery_view and "StrokeImagingImageFit.rect" in immersive and
        "StrokeSpatialImagingInkLayer(useStraightSegments: true)" in immersive,
        "gallery and placed image do not share fitted raster coordinates")

# Attachments can resolve after RealityView's one-time make closure. The
# update path must mount each live image entity, not only move/enable it.
teaching_attachment_update = immersive.split(
    "private func updateSpatialTeachingAttachments(", 1
)[1]
for attachment_id, entity in (
    ("spatialImagingPlateID", "plate"),
    ("spatialImagingComparisonPlateID", "comparisonPlate"),
):
    resolved = teaching_attachment_update.split(
        f"if let {entity} = attachments.entity(for: {attachment_id}) {{", 1
    )[1].split(f"{entity}.position =", 1)[0]
    require(f"if {entity}.parent !== stageRoot" in resolved and
            f"stageRoot.addChild({entity})" in resolved,
            f"late-resolving {attachment_id} is never mounted in the scene update")
require(all(route in launch and route in simulator_proof and route in proof_image_check for route in (
    "--proof-imaging-gallery-placed", "--proof-imaging-gallery-placed-local", "--proof-imaging-gallery-placement-return",
)), "gallery placement lacks bundled, local and Back proof routes")
require(all(token in medicine_exhibit for token in (
    "StrokeMedicineExhibitTargetComponent", "CollisionComponent", "InputTargetComponent", "HoverEffectComponent",
    "selected ? yaw : 0", "selection-rim",
)), "medications lack selectable real spatial geometry and rotation state")
require(all(route in launch and route in simulator_proof and route in proof_image_check for route in (
    "--proof-imaging-gallery", "--proof-imaging-gallery-nine", "--proof-imaging-gallery-sixteen",
    "--proof-imaging-gallery-detail", "--proof-imaging-gallery-return",
)), "gallery lacks layout and recovery render routes")
require(all(token in immersive for token in (
    "workspace.position = [0, 1.62, -0.78]", "experience.focusedReferenceWorkspace == nil",
    ".onChange(of: experience.focusedReferenceWorkspace)",
    "dismissWindow(id: StrokeSpace.evidence)", "dismissWindow(id: StrokeSpace.imaging)",
    'Button("Studies", systemImage: "square.grid.2x2")',
    'Button("Gallery", systemImage: "rectangle.grid.3x2")',
    'Label("CT + MRI", systemImage: "rectangle.split.2x1")',
    "localImageImportControl",
)), "focused destinations fail to suppress legacy duplicates or hide imaging controls")
require(all(route in launch and route in simulator_proof and route in proof_image_check for route in (
    "--proof-reference-medications", "--proof-reference-guides", "--proof-reference-return", "--proof-imaging-room",
)), "focused reference destinations lack deterministic Simulator routes")
require(all(route in launch and route in simulator_proof and route in proof_image_check for route in (
    "--proof-imaging-import-lifecycle", "--proof-imaging-import-return",
)), "image import lifecycle lacks runtime and rendered recovery routes")
require(all(token in imaging_import_session for token in (
    "let target: StrokeLocalImageImportTarget", "guard isCurrent(request) else { return false }",
    "pending = nil", "mutating func cancel()",
)), "image imports are not single-use and destination-bound")
require(all(token in state for token in (
    "if !spatialImagingPlateVisible { spatialImagingImportSession.cancel() }",
    "guard spatialImagingImportSession.consume(request)",
    "spatialImagingReference != reference || spatialImagingLocalImageData != nil",
    "func prepareImagingImportLifecycleProof(returnToAnatomy: Bool = false)",
)), "late image reads or mismatched annotations can survive navigation")
import_callback = immersive.split("private func importLocalImage(", 1)[1].split("private func acceptDroppedImage", 1)[0]
require("let request = localImageImportRequest" in import_callback
        and "guard experience.isCurrentSpatialImagingImport(request) else { return }" in import_callback
        and "target: localImageImportTarget" not in import_callback,
        "asynchronous file completion can change destination or reopen a closed image")
reference_rail_visibility = immersive.split("scholarRail.isEnabled =", 1)[1].split("scholarRail.components", 1)[0]
require("detailLevel" not in reference_rail_visibility and "audienceLens == .clinician" in reference_rail_visibility,
        "changing visual detail can hide Settings and the reference destinations")
require("assert(procedureStep == originalStep && orbit == originalOrbit && spatialZoom == originalZoom)" in state
        and "assert(spatialImagingFocusActive && spatialImagingPlateVisible)" in state,
        "focused reference recovery or imaging study persistence is not checked")
require(
    "pressureStory?.isEnabled = showsPressureFocus && experience.audienceLens == .clinician" in scene
    and "clotTarget?.isEnabled = showsPressureFocus" in scene,
    "the Family Pressure story still renders the clinician-only dashed boundary instead of the direct clot target",
)
require(
    "static let primaryScale: Float = 2.34" in immersive
    and "static let orientScale: Float = 2.18" in immersive,
    "the central anatomy no longer fills the intended primary spatial field",
)
require("StrokeModelBoardView()" in deck, "the dominant embedded 3D model is missing from the case board")
require(all(gesture in model_board for gesture in ("DragGesture", "MagnifyGesture", "SpatialTapGesture")), "orbit, scale, or vessel-focus interaction is missing")
require("makeScene(compact: true)" in model_board, "the windowed 3D model is not using the bounded scene profile")
require('--proof-inspect' in deck and '--proof-discuss' in deck, "deterministic proof routes are missing")
require('--proof-rig' in deck and 'experience.focusOcclusion()' in deck, "animated spatial-rig proof route is missing")
require("clinician review pending" in readme.lower(), "clinical review status is missing")
require("Simulator builds and screenshots do not prove XCAT" in readme, "device evidence boundary is missing")
require("SC-AIS-001.12" in clinical_packet and "PENDING CLINICIAN REVIEW" in clinical_packet, "versioned clinical review packet is missing")
require("Exact three-act review" in clinical_packet and "Reviewed on XCAT app version/build" in clinical_packet, "XCAT three-act clinical review gate is missing")
require("determine eligibility" in clinical_packet and "does not show treatment ranking" in clinical_packet, "clinical review packet lacks decision-support boundaries")
require("Houdini-ready, not Houdini-executed" in houdini, "Houdini execution boundary is missing")
require("BRAIN_REVEAL_RIG" in houdini_builder and "OCCLUSION_RADIUS_PROFILE" in houdini_builder, "stroke Houdini graph builder is missing")
require("XCAT_DEPLOY=BLOCKED" in xcat_deploy and "XCAT_DEPLOY=PASS" in xcat_deploy, "guarded XCAT deployment receipt is missing")
require("BLOCKED.md" in xcat_deploy and "device-list.json" in xcat_deploy and "Tunnel state:" in xcat_deploy, "blocked XCAT reachability does not create a dated machine receipt")
require("Install command: PASS" in xcat_deploy and "Running-process query: PASS" in xcat_deploy, "XCAT machine evidence ladder is incomplete")
require("--hackathon-demo" in xcat_deploy and "-derivedDataPath" in xcat_deploy and "WEARER_RESULT.md" in xcat_deploy and "NOT RUN" in xcat_deploy, "XCAT launch is not tied to the complete showcase journey and receipt")
require("LEGIBILITY" in xcat_acceptance and "GESTURE" in xcat_acceptance and "COMFORT" in xcat_acceptance and "COMPREHENSION" in xcat_acceptance, "XCAT wearer acceptance protocol is incomplete")

if failures:
    for failure in failures:
        print(f"FAIL: {failure}")
    raise SystemExit(1)

print("STROKE_CARE_CONTRACT=PASS")
print("procedure_steps=3")
print("default_experience=PROGRESSIVE_SPATIAL_STORY")
print("spatial_audio=ENTITY_ANCHORED_MONO")
print("graphic_content=EXPLICIT_PERMISSION_REQUIRED")
print("presentation_modes=PATIENT_FAMILY_AND_CLINICIAN")
print("family_feedback=EXPLICIT_CLARIFICATION_NOT_INFERRED_ANXIETY")
print("heart_field_engine_reuse=ORBIT_SCALE_SMOOTHING_ANNOTATION")
print("github_asset_runtime=THIRTY_FOUR_ASSET_INTEGRATED_SLICE")
print("required_asset_failure=VISIBLE_COMPLETE_PROCEDURAL_FALLBACK")
print("patient_data=NONE_FICTIONAL_ONLY")
print("clinical_review=PENDING")
print("physical_device=NOT_PROVEN")
