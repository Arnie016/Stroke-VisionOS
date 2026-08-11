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

step_contract = state.split("enum StrokeProcedureStep", 1)[1].split("enum StrokePresenterTeachingBeat", 1)[0]
require(all(case in step_contract for case in ("case chooseCase", "case inspectOcclusion", "case discussCare")), "three-step procedure is incomplete")
require(step_contract.count("\n    case ") == 3, "procedure must remain exactly three steps")
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
declared_usdz_paths = re.findall(r"- path: ([^\n]+\.usdz)", project_yml)
require(len(declared_usdz_paths) == 22 and len(set(declared_usdz_paths)) == 22 and "asset_manifest" not in project_yml, "runtime asset slice must remain exactly twenty-two unique explicit USDZ resources")
require(
    len({Path(path).name for path in declared_usdz_paths}) == 22
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
)), "reviewed-frame detail/context and registered conceptual access assets are not declared in the app bundle")
require(all(token in catalog for token in (
    "dural_sinuses_jugulars_realistic_v2",
    "circle_of_willis_flow_overlay_v2",
    "external_head_scalp_cutaway_v2",
    "eyes_context_realistic_v2",
    "twenty-two resources",
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
require("ImmersionStyle = .progressive" in app, "progressive immersion is not the default")
require("StrokeImmersiveView(immersionStyle: $immersionStyle)" in app and ".mixed, .progressive, .full" in app, "three deliberate system immersion styles are not wired")
require(all(mode in state for mode in ('case surroundings', 'case warmHorizon', 'case focusField')), "three-state spatial environment contract is missing")
require("How will you use this?" in launch and "Patient / family" in launch and "Doctor presenter" in launch and "enterSpatialCaseRoom" in launch, "plain-language role-separated spatial threshold is missing")
require("beginPatientExploration" in state and "if lens == .family" in launch, "patient/family anatomy exhibit does not bypass the doctor case library")
require(".disabled(true)" not in launch and "Open the calm, generic anatomy exhibit" in launch, "the patient/family route is still locked behind the retired live-demo gate")
require("audienceLens == .family, familyClarityWasSet" in state and "Let’s slow down." in state and "Pause, ask a question" in state, "family self-reported clarity does not adapt the visible teaching copy")
require("experience.audienceLens == .family ? 360 : 300" in immersive and "minHeight: experience.audienceLens == .clinician ? 300 : 336" in immersive, "family question rail is not given the larger readable spatial footprint")
require("--proof-case-unfold" in launch and "prepareCaseHistoryWebProof" in launch, "current room-scale case-unfold proof route is missing")
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
require("Digital Crown" in immersive, "progressive immersion rationale is missing")
require("BillboardComponent" in immersive and "StrokeIntentionAnnotation" in immersive, "entity-anchored intention annotation is missing")
require("Capsule()" in immersive and "annotationTint.opacity(0.52)" in immersive, "free-standing annotation tether is missing")
require("DragGesture" in immersive and "MagnifyGesture" in immersive, "Heart Field orbit/scale interaction pattern is missing")
require("resetSpatialView" in state and "Reset view" in immersive, "spatial reset is missing")
require("StrokeAnatomyViewpoint" in state and all(view in state for view in ("case threeQuarter", "case anterior", "case lateralA", "case lateralB", "case superior", "case inferior")), "named registered model-frame viewpoints are missing")
require("setAnatomyViewpoint" in state and "cycleAnatomyViewpoint" in state and "anatomyViewpoint = .free" in state and "SpatialViewpointDot" in immersive and "experience.setAnatomyViewpoint(viewpoints[nextIndex], reduceMotion: reduceMotion)" in immersive and '.accessibilityLabel("Anatomy viewpoint")' in immersive, "named views and direct free-orbit handoff are not wired into the quiet viewpoint control")
require(all(token in immersive for token in (
    'Text("CLINICIAN LENS")',
    'Text("VISUAL DETAIL · USER SELECTED")',
    'viewpointControlID = "spatial-viewpoint-control"',
    '.threeQuarter, .anterior, .lateralA, .lateralB, .superior, .inferior',
    'private func advanceViewpoint()',
    'experience.selectDetailLevel(StrokeDetailLevel.allCases[index])',
    'GENERIC VENOUS ATLAS · COLOUR CONVENTION · REVIEW PENDING',
)), "clinician scene lacks the quiet viewpoint dot or progressive detail controls")
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
require("StrokeAnatomyPresentation" in state and all(mode in state for mode in ('case assembled', 'case transparent', 'case exploded')), "reversible anatomy presentation modes are missing")
require("cortexOpacity" in state and "selectedPointEntityName" in state and "selectedPointLabel" in state, "transparent anatomy or point selection state is missing")
require("clinician-region-point-field" in scene and "clinician-procedure-point-field" in scene, "RealityKit point fields are missing")
require("regionPointDirections" in scene and "procedurePointPositions" in scene, "sparse spatial reference data is missing")
require("Example affected area" in scene and "Flow beyond the blockage changes" in scene, "intention-based point labels are missing")
require("experience.lessonPointsVisible" in scene and "experience.pointField" in scene, "point fields are not discoverable or switchable")
require("visualBounds(relativeTo: registered)" in scene and "* 1.025" in scene and "radius: 0.0041" in scene, "point fields are not derived from registered anatomy bounds at a precise readable scale")
require("clotSurfaceMarker" in scene and "bounds.max.z + 0.003" in scene and 'selectedPointEntityName = "clinician-procedure-point-field-point-2"' in state, "blockage marker is not bound to the registered clot surface or proof semantics disagree")
require("frontZ" not in scene and all(anchor in scene for anchor in ("[-0.028297, -0.142271, 0.010944]", "[-0.012158, -0.059836, 0.030163]", "[-0.043842, -0.014646, 0.029223]", "[-0.053607, -0.011508, 0.017754]")), "procedure markers still use a detached screen plane instead of registered-v2 mesh samples")
require("defaultLessonPointIndex" in state and "case .procedure: 2" in state and "index == experience.pointField.defaultLessonPointIndex" in scene, "Vessel Story does not default to its clot-bound marker")
require(all(layer in scene for layer in ("anatomy-cortex-layer", "anatomy-arteries-layer", "anatomy-blockage-layer", "anatomy-dura-layer")), "semantic sibling anatomy layers are missing")
require("OpacityComponent(opacity:" in scene and "anatomyPresentation" in scene and "approach(cortexLayer" in scene, "reversible opacity or exploded-layer rendering is missing")
require("isPointFieldInteractionTarget" in scene and "pointFieldSelection" in scene and "InputTargetComponent(allowedInputTypes: [.direct, .indirect])" in scene, "point fields are not directly targetable")
require("StrokeLessonPointTargetComponent" in scene and "point.components.set(StrokeLessonPointTargetComponent())" in scene and "generateSphere(radius: 0.0074)" in scene and "HoverEffectComponent" in scene, "point interaction affordance is missing")
require("setAnatomyPresentation" in immersive and "Brain transparency" in immersive and "selectedPointLabel" in immersive, "clinician layer-study controls are incomplete")
require("pointFieldSelection(for: value.entity)" in immersive and "selectPoint(entityName:" in immersive, "point pinch selection is not routed into shared state")
require("targetedToEntity(where: .has(StrokeLessonPointTargetComponent.self))" in immersive and "isEnabled: !experience.questionPlacementArmed" in immersive, "lesson-point pinch is not isolated from the anatomy proxy or annotation mode")
require("nearestVisiblePointFieldSelection" in scene and "nearestVisiblePointFieldSelection(" in immersive and "maximumDistance: Float = 0.036" in scene, "anatomy-proxy pinches do not resolve a nearby visible lesson point with the enlarged fallback")
require("StrokeLessonPointTargetComponent.registerComponent()" in scene and "StrokeSceneFactory.registerCustomComponents()" in app, "lesson-point query component is not registered before scene construction")
require(
    "lessonPointOrbName" in scene
    and "let point = Entity()" in scene
    and "orb.scale = [pulse * emphasis" in scene,
    "lesson-point visual pulses are again scaling their collision targets",
)
require(
    "effectiveMaximumDistance = max(maximumDistance, 0.085)" in scene
    and "spatialZoom = max(spatialZoom, isBlockagePoint ? 2.05 : 1.58)" in state,
    "visible far-side points or the selected-vessel close-up path are missing",
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
require("Clinical evidence" in evidence and "Search sources" in evidence and "Pin in space" in evidence and "Compose draft" in evidence, "citation search, pin, and compose workflow is incomplete")
require("Back to explanation" in evidence and "dismissWindow(id: StrokeSpace.evidence)" in evidence, "evidence space lacks a clear, reliable return action")
require("SOURCE-BOUND TEACHING DRAFT" in evidence and "not approved clinical copy" in evidence, "generated evidence copy lacks its draft boundary")
require("fullCitation" in state and "stableURL" in state and "limitation" in state, "evidence sources lack immutable citation context")
require("Clinician upper evidence plane" in deck_canon and "never receives raw gaze" in deck_canon, "RealityKit deck learnings are not mapped to Stroke Care")
require("--proof-evidence" in launch and "prepareEvidenceProof" in state and "opensEvidence: true" in launch, "deterministic evidence-space proof route is missing")
require("--proof-evidence-window" in launch and "openEvidenceProofWindow" in launch, "isolated evidence-window proof route is missing")
require("--proof-layer-study" in launch and "prepareLayerStudyProof" in state, "deterministic anatomy layer-study proof route is missing")
require("--proof-procedure-field" in launch and "prepareProcedureFieldProof" in state, "deterministic procedure-point proof route is missing")
require("--proof-transparent-layer" in launch and "prepareTransparentLayerProof" in state, "deterministic transparent-anatomy proof route is missing")
require(all(route in launch for route in ("--proof-environment-surroundings", "--proof-environment-warm", "--proof-environment-focus")), "deterministic environment proof routes are missing")
require("--proof-clinician-toolkit" in launch and "prepareClinicianToolKitProof" in state, "deterministic clinician tool-kit proof route is missing")
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
    "imported.findEntity(named: importedBrainName)?.isEnabled = !isolateScholarSkull",
    "imported.findEntity(named: importedArteriesName)?.isEnabled = !isolateScholarSkull &&",
    "imported.findEntity(named: importedClotName)?.isEnabled = !isolateScholarSkull &&",
    "let showsConceptualDura = !showsOpenCranialReview && !isolateScholarSkull && showsPurpose",
    "let showsClinicianSkullContext = isClinicianExplanation",
    "showsAccessReference || showsClosureReference",
    "importedSkull?.isEnabled = !showsOpenCranialReview &&",
    "(isolateScholarSkull || showsClinicianSkullContext)",
    "showsClinicianSkullContext ? skullOffset : .zero",
    "showsAccessReference ? 0.42 : (showsClosureReference ? 0.18 : 0)",
    "no transform or exact",
)), "Scholar skull isolation does not restore the registered assembly or preserve the authored frame")
require(all(token in immersive for token in (
    'case .transparent: "Skull"',
    '"Skull reference · separated · review pending"',
    '"Generic separated skull reference. Cross-source alignment requires specialist review."',
    "experience.detailLevel >= .guided",
)), "normal clinician layer cycle does not expose the reviewed skull-context boundary")
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
require(all(token in proof_image_check for token in (
    "PROOF_IMAGE=FAIL",
    "empty-centre",
    "colourless-centre",
    "centre_nonblack_ratio",
    "centre_colour_ratio",
)), "Simulator proof images can pass while the spatial stage is blank")
require("--proof-spatial-docked-case" in launch and "prepareSpatialDockedCaseProof" in state, "deterministic docked-case constellation proof is missing")
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
require("reveal > 0.96" in immersive and "OpacityComponent(opacity: inReview ? 1 - dissolve : 1)" in immersive, "case card dissolve or explicit Enter threshold is missing")
patient_history = (ROOT / "Sources" / "PatientHistoryTimelineView.swift").read_text()
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
require(all(token in launch for token in ('--proof-realtime-narration', 'experience.audienceLens = .family', 'experience.setNarrationEnabled(true)')), "deterministic family Realtime playback route is missing")
require(immersive.count("narrator.speak(") == 1 and all(token in immersive for token in (
    "private func synchronizeNarration()",
    "experience.audienceLens == .family",
    "experience.narrationEnabled",
    "!experience.requestedPause",
    "narrator.stop()",
)), "narration is not guarded by family role, opt-in, and active playback state")
require(".onChange(of: experience.requestedPause)" in immersive and ".onChange(of: experience.audienceLens)" in immersive, "pause or role transition cannot stop/restart narration deterministically")
require("narrationEnabled = false" in state and "func setNarrationEnabled" in state and 'experience.narrationEnabled ? "Narrator off" : "Narrator"' in immersive, "family narration state boundary is incomplete")
require('experience.soundEnabled ? "Ambient off" : "Ambient"' in immersive and 'experience.narrationEnabled ? "Voice off" : "Voice"' not in immersive, "doctor controls still expose synthesized voice instead of ambient sound")
require("spatial-family-controls" in immersive and "spatial-presenter-controls" in immersive and "SpatialRoleControls" in immersive, "role controls are not embedded in the immersive room")
require("SpatialControlBubbleLabel" in immersive and ".hoverEffect(.highlight)" in immersive, "gaze-sized spatial bubble controls are missing")
require(all(question in immersive for question in ("WHAT CHANGED?", "WHY DOES PRESSURE BUILD?", "WHAT CAN MAKING SPACE DO?")), "top intention questions are missing")
require("LessonSpecimenRail" in immersive and "lesson-specimen-rail" in immersive and "selectLessonPoint" in state and "Native two-hand magnification remains the only zoom" in state, "role-aware specimen focus rail is missing")
require("selected.position + [0.038, 0.020, 0.012]" in immersive and "private var presenterControls" in immersive and all(call in immersive for call in ("cycleAnatomyPresentation()", "cycleLessonFamily()", "cycleEnvironment()")), "depth-attached lesson disclosure or direct presenter cycle controls are incomplete")
require(not re.search(r"\bMenu\s*\{", immersive), "immersive controls must not use SwiftUI Menu presentation")
require("[-0.43, 1.28, -0.90]" in immersive and "[0.58, 1.38, -0.92]" in immersive, "family and presenter controls are not spatially separated")
require("openWindow(id: companion)" not in immersive, "immersive case docking still opens a desktop-like companion window")
require("StrokeClinicianTool" in state and "clinicianToolKitVisible" in state and "selectClinicianTool" in state, "clinician tool-kit state is missing")
require("clinician-hand-tool-wheel" in immersive and "ClinicianHandToolWheel" in immersive, "palm tool selector is missing")
require(".hand(.left, location: .palm)" in immersive and ".hand(.right, location: .palm)" in immersive, "tool kit and held tool are not hand anchored")
require("experience.audienceLens == .clinician" in immersive and "enabled && experience.clinicianToolKitVisible" in immersive, "clinician tools may leak into the family lens")
require(all(token in immersive for token in (
    "HandToolArcGuide",
    "CGSize(width: -12, height: -140)",
    ".frame(width: 84, height: 84)",
    "wheel.position = [0.095, 0.025, 0.110]",
    "wheel.scale = [0.78, 0.78, 0.78]",
    'experience.clinicianToolKitVisible ? "Tools on" : "Tools"',
)), "clinician selector is not a gaze-sized hand-adjacent arc with a presenter fallback")
require("makeClinicianHeldTools" in scene and "suction_and_forceps" in scene and "cranial_drill_generic" in scene, "clinician concept tools are not bundled into the held-tool rig")
require("No selection mutates anatomy or simulates a cut" in scene, "clinician tool safety boundary is missing")
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
require("SC-AIS-001.9" in clinical_packet and "PENDING CLINICIAN REVIEW" in clinical_packet, "versioned clinical-review boundary is missing")
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
    '"QUESTIONS TO ASK"',
    '"PRESENTATION CHECKLIST"',
    '"CLARITY · SELF-REPORTED"',
    '"Clarity · \\(experience.familyClarityLabel)"',
    'Slider(',
    "Record the family's self-reported explanation clarity",
    "experience.selectFamilyQuestion(question)",
    '"Selected; lesson paused"',
)), "role-aware left cue surface does not expose tappable questions and explicit clarity")
require(all(token in state for token in (
    "selectedPresenterKeyPointIndex",
    "presenterPlainLanguagePoints",
    "selectPresenterKeyPoint",
    "There is intentionally no runtime-generated paraphrase",
)), "presenter technical-to-plain authored pointer state is missing")
require("experience.selectPresenterKeyPoint(index)" in immersive and "experience.presenterPlainLanguagePoints[index]" in immersive and "authored plain-language phrasing" in immersive, "presenter pointers do not reveal authored plain-language lines")
require("ASK ALOUD" not in immersive and "familyComfort" not in state and "familyComfort" not in immersive, "misleading voice or comfort terminology remains")
require(all(token in immersive for token in (
    "VISUAL DETAIL · USER SELECTED",
    'Text("Simplified")',
    'Text("Standard")',
    'Text("Full")',
    "experience.selectDetailLevel(StrokeDetailLevel.allCases[index])",
)), "explicit three-stop visual-detail slider is incomplete")
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
    ".frame(minWidth: 76, minHeight: 76)",
    ".frame(width: 76, height: 76)",
    "@State private var hoveredBeat",
    "let displayedBeat = hoveredBeat ?? experience.presenterTeachingBeat",
    "let showsContext = labelsVisible || hoveredBeat != nil",
    "STEP \\(displayedBeat.number) OF 6",
    "isHovered: hoveredBeat == beat",
    ".frame(height: beat == experience.presenterTeachingBeat ? 10 : 7)",
    "Color(red: 0.86, green: 0.31, blue: 0.34)",
)), "doctor presenter timeline does not expose six stable direct checkpoints with context above")
require("(teachingTimelineID, [0, 1.13, -0.86]" in immersive, "teaching timeline is not staged in the central-lower demo field")
require(all(token in scene for token in (
    "addAccessTargetHighlight(to: accessPoint, sourceOffset: [0, 0, -0.022])",
    'highlight.name = "clinician-access-target-highlight"',
    'halo.name = "clinician-access-target-halo"',
    'tick.name = "clinician-access-target-mark-\\(index)"',
    'tether.name = "clinician-access-target-tether"',
    'sourcePin.name = "clinician-access-target-source"',
)), "craniotomy access point is missing its non-graphic halo, tether, or registration marks")
require("let accessInvitationMarker = accessSourceMarker + SIMD3<Float>(0, 0, 0.022)" in scene, "access invitation is still visually embedded in the anatomy")
require(all(token in scene for token in (
    "source + simd_normalize(direction) * 0.012",
    "return source + direction * 0.012",
    "addPointInvitationTether(",
    'tether.name = "lesson-point-invitation-tether"',
    'sourcePin.name = "lesson-point-invitation-source"',
)), "region or flow invitations remain embedded in dense anatomy without source tethers")
require("maximumDistance: Float = 0.036" in scene, "nearest visible lesson-point fallback was not enlarged by twenty percent")
require("let revealAll = experience.pointField != .craniotomy" in scene, "region or flow point families still hide unselected selectable markers")
require("activatePresenterAccessStory" in state and "pointField = .craniotomy" in state and "selectDetailLevel(.scholar)" in state, "top Access checkpoint does not enter the craniotomy teaching family")
require("experience.detailLevel == .scholar &&\n            experience.pointField == .craniotomy" not in scene, "craniotomy reference disappears when visual detail leaves Full")
require(all(token in scene for token in (
    "let showsAccessScalp: Bool",
    "let showsAccessBone: Bool",
    "let showsAccessDura: Bool",
    "showsAccessBone = experience.detailLevel != .calm",
    "showsAccessScalp = experience.detailLevel == .scholar",
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
require(all(token in state for token in (
    "pendingPresenterTeachingBeat",
    "beat.procedureStep == .discussCare, !careViewPermissionGranted",
    "selectPresenterTeachingBeat(requestedBeat",
    "beat == .explainClosure",
)), "presenter beat navigation bypasses permission continuity or reversible closure")
require("SpatialRoleMicroCues" in immersive and 'roleMicroCuesID = "spatial-role-micro-cues"' in immersive and "familyQuestionSuggestions" in immersive and "presenterTimelineKeyPoints" in immersive, "role-aware left peripheral micro-cues are missing")
require("StrokeTeachingImagingDrawer" in immersive and 'teachingImagingDrawerID = "spatial-teaching-imaging-drawer"' in immersive and "SpatialVisualField.secondaryCaseDrawer" in immersive, "peripheral teaching imaging drawer is missing")
require("focusLight.isEnabled = experience.environmentMode != .surroundings" in immersive and "high-density cortex reads like flat clay" in immersive, "warm anatomy field is missing its sculpting key light")
require(all(copy in scene for copy in ("Stroke effect", "Making-room purpose")) and all(copy in immersive for copy in ("Generic anatomy · not a patient scan", "Registered-v2 teaching asset · review pending")), "registered teaching-lens boundaries or two-state sequence are missing")
require(all(token in scene for token in ("registered-teaching-imaging-root", "registered-teaching-imaging-affected-vessel", "registered-teaching-imaging-making-room-purpose", "cerebral_arteries_realistic_v2", "ischemic_mca_clot_v2", "dura_mater_cutaway_conceptual_v2")), "registered-v2 teaching miniature or required leaf assets are missing")
require("Canvas" not in immersive and "StrokeTeachingImagingSchematic" not in immersive, "rejected procedural imaging plates remain in the runtime UI")
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
require("--proof-main-overview" in launch and "prepareMainOverviewProof" in state, "dots-first main overview proof route is missing")
require("--proof-clinician-layer-hierarchy" in launch and "prepareClinicianLayerHierarchyProof" in state and "selectDetailLevel(.scholar)" in state, "scholar clinician layer-hierarchy proof route is missing")
require("--proof-main-selected-point" in launch and "prepareTeachingImagingProof" in state, "selected-point main proof route is missing")
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
require("experience.selectedPointEntityName != nil" in immersive and "selected.uppercased()" in immersive, "main explanation appears before point selection or fails to identify the selected target")
require(all(token in state for token in (
    "The secondary reference is an outcome of selecting a teaching point",
    "teachingImagingLens = .affectedVessel",
    "teachingImagingLens = .makingRoomPurpose",
    "teachingImagingDrawerVisible = careViewPermissionGranted",
)), "point selection does not drive one consent-aware, act-matched reference")
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
require("ForEach(experience.pointField.lessonPoints)" not in immersive and "selected.position + [0.038, 0.020, 0.012]" in immersive, "selected-point disclosure is still a permanent label rail or is not depth-attached")
require('"Images"' not in immersive and '"Close images"' not in immersive, "duplicated image-browser controls remain in the spatial role rails")
require(all(token in immersive for token in (
    '"BLOCKED VESSEL · TEACHING VIEW"',
    '"AFFECTED-VESSEL REFERENCE"',
    '"Generic anatomy · not a patient scan"',
    '"Registered-v2 teaching asset · review pending"',
    '"FROM POINT · \\(selectedPointLabel.uppercased())"',
    '"DIRECTION CUE · QUALITATIVE · NOT CFD"',
)), "right-side teaching reference lacks role-safe selected-point captions")
require(all(token in immersive for token in (
    "StrokeScholarReferenceRail",
    'Text("SCHOLAR REFERENCES")',
    "case anatomy",
    "case imaging",
    "case interventions",
    "case medications",
    "case outcomes",
    "case guidelines",
    ".frame(minHeight: 60)",
    "lane.arcInset",
    "experience.selectedPointEntityName != nil",
    'return "Select point"',
    'return "Coming soon"',
    "experience.selectLessonFamily(.craniotomy)",
    "experience.selectCareDiscussion(.medicineReview)",
    "experience.selectEvidence(guideline)",
    "openWindow(id: StrokeSpace.evidence)",
    "StrokeScholarReferenceArc",
    ".frame(width: 310)",
    "case .interventions, .medications: 20",
)), "Scholar rail lacks large targets, point-gated imaging, or truthful authored actions")
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
require(all(token in immersive for token in (
    'Text("ANATOMY FOCUS")',
    "ForEach(StrokeAnatomyFocus.allCases)",
    "experience.selectAnatomyFocus(focus)",
    "experience.anatomyFocusStatus",
    "experience.isAnatomyFocusAvailable(focus)",
    "Unavailable in this build",
    "minHeight: 48",
)), "Scholar rail lacks a directly selectable, accessible anatomy subsystem hierarchy")
require(all(token in scene for token in (
    "let anatomyFocus = experience.anatomyFocus",
    "anatomyFocus == .vessels",
    "anatomyFocus == .internalStructures",
    "anatomyFocus == .surfaceContext",
    "anatomyFocus != .internalStructures",
    "experience.detailLevel == .scholar",
)), "registered arterial, venous, deep-structure, and ventricular geometry does not follow anatomy focus")
require(all(token in launch for token in (
    '"--proof-anatomy-internal"',
    "prepareAnatomyInternalFocusProof",
    '"--proof-anatomy-vessels"',
    "prepareAnatomyVesselsFocusProof",
    '"--proof-anatomy-surface"',
    "prepareAnatomySurfaceFocusProof",
)), "deterministic vessels/internal anatomy-focus proof routes are missing")
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
require(all(copy in state for copy in ("Which layer is this?", "Is this blockage, injury, or swelling?", "What can this surgery change—and not change?")), "family act questions are incomplete")
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
    "caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFigureName)?.isEnabled = inReview" in immersive,
    "the fictional case figure is not scoped to patient-file review",
)
require(
    "setAnatomyViewpoint(.lateralA, reduceMotion: true)" in state
    and "spatialZoom = 1.12" in state,
    "the craniotomy proof no longer uses the bounded lateral demo framing",
)
require(
    "experience.isInteriorPortalAvailable" in immersive
    and 'URL(string: "rbcjourney://enter")' in immersive
    and '"Enter brain"' in immersive,
    "room-scale magnification does not expose the separate inside-brain handoff",
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
    "showsAccessReference ? [0.16, 0, 0] : .zero",
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
require("StrokeModelBoardView()" in deck, "the dominant embedded 3D model is missing from the case board")
require(all(gesture in model_board for gesture in ("DragGesture", "MagnifyGesture", "SpatialTapGesture")), "orbit, scale, or vessel-focus interaction is missing")
require("makeScene(compact: true)" in model_board, "the windowed 3D model is not using the bounded scene profile")
require('--proof-inspect' in deck and '--proof-discuss' in deck, "deterministic proof routes are missing")
require('--proof-rig' in deck and 'experience.focusOcclusion()' in deck, "animated spatial-rig proof route is missing")
require("clinician review pending" in readme.lower(), "clinical review status is missing")
require("Simulator builds and screenshots do not prove XCAT" in readme, "device evidence boundary is missing")
require("SC-AIS-001.9" in clinical_packet and "PENDING CLINICIAN REVIEW" in clinical_packet, "versioned clinical review packet is missing")
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
print("github_asset_runtime=TWENTY_TWO_ASSET_STAGED_SLICE")
print("required_asset_failure=VISIBLE_COMPLETE_PROCEDURAL_FALLBACK")
print("patient_data=NONE_FICTIONAL_ONLY")
print("clinical_review=PENDING")
print("physical_device=NOT_PROVEN")
