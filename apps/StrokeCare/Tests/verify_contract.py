#!/usr/bin/env python3
"""Static product-contract checks; not device, wearer, or clinical proof."""

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
failures: list[str] = []


def require(condition: bool, message: str) -> None:
    if not condition:
        failures.append(message)


state = (ROOT / "Sources" / "StrokeExperienceState.swift").read_text()
deck = (ROOT / "Sources" / "StrokeControlDeck.swift").read_text()
app = (ROOT / "Sources" / "StrokeTimeApp.swift").read_text()
launch = (ROOT / "Sources" / "StrokeJourneyLaunchView.swift").read_text()
scene = (ROOT / "Sources" / "StrokeSceneFactory.swift").read_text()
immersive = (ROOT / "Sources" / "StrokeImmersiveView.swift").read_text()
model_board = (ROOT / "Sources" / "StrokeModelBoardView.swift").read_text()
readme = (ROOT / "README.md").read_text()
houdini = (ROOT / "Docs" / "HOUDINI_STROKE_PIPELINE.md").read_text()
clinical_packet = (ROOT / "Docs" / "ISCHEMIC_STROKE_CLINICAL_REVIEW.md").read_text()
houdini_builder = (ROOT / "Scripts" / "build_houdini_stroke_graph.py").read_text()
xcat_deploy = (ROOT / "Scripts" / "deploy_xcat.zsh").read_text()
xcat_stage_collect = (ROOT / "Scripts" / "collect_xcat_stage_placement.zsh").read_text()
xcat_acceptance = (ROOT / "Proof" / "XCAT_ACCEPTANCE.md").read_text()
project_yml = (ROOT / "project.yml").read_text()
asset_intake = (ROOT / "Docs" / "GITHUB_ASSET_INTAKE_PR2.md").read_text()
simulator_proof = (ROOT / "Scripts" / "capture_simulator_route_proof.zsh").read_text()
proof_route_image = (ROOT / "Tests" / "verify_proof_route_image.swift").read_text()

step_contract = state.split("enum StrokeProcedureStep", 1)[1].split("struct TeachingStrokeCase", 1)[0]
require(all(case in step_contract for case in ("case chooseCase", "case inspectOcclusion", "case discussCare")), "three-step procedure is incomplete")
require(step_contract.count("\n    case ") == 3, "procedure must remain exactly three steps")
require("StrokeJourneyLaunchView()" in app and "StrokeControlDeck()" not in app, "dashboard is still the default experience")
require("ImmersionStyle = .progressive" in app, "progressive immersion is not the default")
require("StrokeImmersiveView(immersionStyle: $immersionStyle)" in app and ".mixed, .progressive, .full" in app, "three deliberate system immersion styles are not wired")
require(all(mode in state for mode in ('case surroundings', 'case warmHorizon', 'case focusField')), "three-state spatial environment contract is missing")
require("Who are you guiding today?" in launch and "Doctor → family" in launch and "Clinician teaching" in launch and "enterSpatialCaseRoom" in launch, "role-separated spatial threshold is missing")
require(
    'CommandLine.arguments.contains("--proof-case-unfold")' in launch
    and "experience.prepareSpatialDockedCaseProof()" in launch
    and "Task { await openProofSpace() }" in launch,
    "case-unfold proof does not reach the current immersive case-review state",
)
require("DragGesture" in launch and "caseRevealProgress" in launch, "progressive case-file drag interaction is missing")
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
require("imported-brain-surface-target" in scene and "generateSphere(radius: 0.112)" in scene, "semantic imported brain collision target is missing")
require("imported-clot-focus-target" in scene and "isAnatomyInteractionTarget" in scene, "semantic clot interaction target is missing")
require("legacy-v1-pressure-root" in scene and "craniotomy_bone_flap" in scene and "dural_patch" in scene, "PR2 pressure-purpose assets are not segregated")
require("loadBundledUSDZ" in scene and "procedural-stroke-fallback" in scene, "imported-asset fallback loader is missing")
require("catheter-review-preview" in scene and "medicine-review-preview" in scene, "care discussion previews are missing")
require(all(name in scene for name in ("fixed-skull-context", "bone-flap", "dura-expansion")), "pressure-purpose anatomy is missing")
require("does not restore or shrink established injury" in scene, "non-restoration visual boundary is missing")
require("authored teaching motion" in scene and "not a patient measurement" in scene, "animation evidence boundary is missing")
require("TimelineView" in immersive and "focusOcclusion()" in immersive, "runtime spatial animation or focus gesture is missing")
require(
    "#if targetEnvironment(simulator)" in immersive
    and "transform = nil" in immersive
    and "intentionally emits no tracked-anchor receipt" in immersive
    and "WorldTrackingProvider.queryDeviceAnchor" in immersive,
    "Simulator authored-frame fallback or physical world-tracking boundary is missing",
)
require(
    "TimelineView(.periodic" in immersive
    and "sceneRefreshInterval" in immersive
    and "guard experience.spatialPhase == .explanation else" in scene
    and "suspendImportedBloodflow(in: root)" in scene,
    "static phases still drive hidden anatomy at display rate",
)
require("SpatialAudioComponent" in immersive and "FlowBed" in immersive and "PressureBed" in immersive, "entity-anchored spatial audio is missing")
require("Digital Crown" in immersive, "progressive immersion rationale is missing")
require("BillboardComponent" in immersive and "StrokeIntentionAnnotation" in immersive, "entity-anchored intention annotation is missing")
require("Capsule()" in immersive and "annotationTint.opacity(0.52)" in immersive, "free-standing annotation tether is missing")
require("DragGesture" in immersive and "MagnifyGesture" in immersive, "Heart Field orbit/scale interaction pattern is missing")
require("resetSpatialView" in state and "Reset view" in immersive, "spatial reset is missing")
require("StrokeAnatomyViewpoint" in state and all(view in state for view in ("case threeQuarter", "case anterior", "case lateralA", "case lateralB", "case superior")), "named registered model-frame viewpoints are missing")
require("setAnatomyViewpoint" in state and "cycleAnatomyViewpoint" in state and "anatomyViewpoint = .free" in state and "experience.cycleAnatomyViewpoint(reduceMotion: reduceMotion)" in immersive, "named views and free-orbit handoff are not wired into the existing anatomy control")
require(all(route in launch for route in ("--proof-view-anterior", "--proof-view-lateral-a", "--proof-view-lateral-b", "--proof-view-superior")), "deterministic anatomy-viewpoint proof routes are missing")
require("true medial view is intentionally not" in state, "single-surface anatomy is mislabeled as a medial view")
require("smoothedOrbit" in immersive and "smoothedZoom" in immersive, "Heart Field smoothing pattern is missing")
require("WorldTrackingProvider" in immersive and "queryDeviceAnchor" in immersive and "stroke-world-locked-stage" in immersive, "stage is not placed from a sampled device pose")
require("Samples the current device pose once" in immersive and "session.stop()" in immersive, "anatomy stage is continuously head-locked or tracking is not bounded")
require("stageRoot.addChild(root)" in immersive and "stageRoot.addChild(caseRoom)" in immersive and "relativeTo: stageRoot" in immersive, "brain, case archive, and annotation placement do not share one coherent stage frame")
require("stroke-stage-placement.json" in immersive and "PLACEMENT_PATH_RAN" in immersive and "raw room transform" in immersive, "physical placement path lacks a privacy-bounded machine receipt")
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
require("visualBounds(relativeTo: registered)" in scene and "* 0.98" in scene and "radius: 0.0025" in scene, "point fields are not derived from registered anatomy bounds at a precise scale")
require("clotSurfaceMarker" in scene and "bounds.max.z + 0.003" in scene and 'selectedPointEntityName = "clinician-procedure-point-field-point-2"' in state, "blockage marker is not bound to the registered clot surface or proof semantics disagree")
require("frontZ" not in scene and all(anchor in scene for anchor in ("[-0.028297, -0.142271, 0.010944]", "[-0.012158, -0.059836, 0.030163]", "[-0.043842, -0.014646, 0.029223]", "[-0.053607, -0.011508, 0.017754]")), "procedure markers still use a detached screen plane instead of registered-v2 mesh samples")
require("defaultLessonPointIndex" in state and "case .procedure: 2" in state and "index == experience.pointField.defaultLessonPointIndex" in scene, "Vessel Story does not default to its clot-bound marker")
require(all(layer in scene for layer in ("anatomy-cortex-layer", "anatomy-arteries-layer", "anatomy-blockage-layer", "anatomy-dura-layer")), "semantic sibling anatomy layers are missing")
require("OpacityComponent(opacity:" in scene and "anatomyPresentation" in scene and "approach(cortexLayer" in scene, "reversible opacity or exploded-layer rendering is missing")
require("isPointFieldInteractionTarget" in scene and "pointFieldSelection" in scene and "InputTargetComponent(allowedInputTypes: [.direct, .indirect])" in scene, "point fields are not directly targetable")
require("StrokeLessonPointTargetComponent" in scene and "point.components.set(StrokeLessonPointTargetComponent())" in scene and "generateSphere(radius: 0.006)" in scene and "HoverEffectComponent" in scene, "point interaction affordance is missing")
require("setAnatomyPresentation" in immersive and "Brain transparency" in immersive and "selectedPointLabel" in immersive, "clinician layer-study controls are incomplete")
require("pointFieldSelection(for: value.entity)" in immersive and "selectPoint(entityName:" in immersive, "point pinch selection is not routed into shared state")
require("targetedToEntity(where: .has(StrokeLessonPointTargetComponent.self))" in immersive and "isEnabled: !experience.questionPlacementArmed" in immersive, "lesson-point pinch is not isolated from the anatomy proxy or annotation mode")
require("StrokeLessonPointTargetComponent.registerComponent()" in scene and "StrokeSceneFactory.registerCustomComponents()" in app, "lesson-point query component is not registered before scene construction")
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
require("SOURCE-BOUND TEACHING DRAFT" in evidence and "not approved clinical copy" in evidence, "generated evidence copy lacks its draft boundary")
require("fullCitation" in state and "stableURL" in state and "limitation" in state, "evidence sources lack immutable citation context")
require("Clinician upper evidence plane" in deck_canon and "never receives raw gaze" in deck_canon, "RealityKit deck learnings are not mapped to Stroke Care")
require("--proof-evidence" in launch and "prepareEvidenceProof" in state and "opensEvidence: true" in launch, "deterministic evidence-space proof route is missing")
require("--proof-evidence-window" in launch and "openEvidenceProofWindow" in launch, "isolated evidence-window proof route is missing")
require("--proof-layer-study" in launch and "prepareLayerStudyProof" in state, "deterministic anatomy layer-study proof route is missing")
require("--proof-flow-layer-study" in launch and "prepareFlowLayerStudyProof" in state, "deterministic registered-flow layer-study proof route is missing")
require("--proof-flow-exit" in launch and "experience.returnCaseToLibrary()" in launch, "deterministic active-flow exit proof route is missing")
flow_exit_route = launch.split('CommandLine.arguments.contains("--proof-flow-exit")', 1)[1].split(
    'CommandLine.arguments.contains("--proof-procedure-field")', 1
)[0]
flow_exit_delay_match = re.search(r"Task\.sleep\(for: \.seconds\((\d+)\)\)", flow_exit_route)
flow_exit_settle_match = re.search(
    r"PROOF_FLOW_EXIT_SETTLE_SECONDS:-([0-9]+)",
    simulator_proof,
)
require(
    flow_exit_delay_match is not None
    and flow_exit_settle_match is not None
    and int(flow_exit_settle_match.group(1)) >= int(flow_exit_delay_match.group(1)) + 5,
    "flow-exit proof capture can race the delayed non-anatomy transition",
)
require("--proof-procedure-field" in launch and "prepareProcedureFieldProof" in state, "deterministic procedure-point proof route is missing")
require("--proof-transparent-layer" in launch and "prepareTransparentLayerProof" in state, "deterministic transparent-anatomy proof route is missing")
require(all(route in launch for route in ("--proof-environment-surroundings", "--proof-environment-warm", "--proof-environment-focus")), "deterministic environment proof routes are missing")
require("--proof-clinician-toolkit" in launch and "prepareClinicianToolKitProof" in state, "deterministic clinician tool-kit proof route is missing")
require("--proof-spatial-intake" in launch and "makeSpatialCaseIntake" in scene, "deterministic room-scale case intake is missing")
require("--proof-spatial-docked-case" in launch and "prepareSpatialDockedCaseProof" in state, "deterministic docked-case constellation proof is missing")
require("spatialCaseFilePosition" in state and "settleSpatialCaseFile" in state and "isSpatialCaseFileTarget" in scene, "spatial case carry-and-dock loop is incomplete")
require("StrokeSpatialPhase" in state and "caseLibrary" in state and "caseReview" in state and "explanation" in state, "case room and anatomy are not separated into explicit phases")
require("root.isEnabled = anatomyVisible" in immersive and "caseRoom.isEnabled = experience.spatialPhase != .explanation" in immersive, "patient cabinet still persists into the brain explanation")
require("spatial-case-archive" in scene and "archive-dossier-bay" in scene and "[0.19, 0.25, 0.018]" in scene, "case library is not a single angled dossier archive with an upright selected file")
require("spatial-case-constellation" in scene and scene.count("case-constellation-filament-") == 4, "selected case does not unfold as a four-signal spatial constellation")
require("StrokeSceneFactory.spatialCaseArchiveName)?.isEnabled = inLibrary" in immersive and "StrokeSceneFactory.spatialCaseConstellationName)?.isEnabled = inReview" in immersive, "archive and case constellation do not hand off by phase")
require("SpatialCaseReviewActions" in immersive and "beginExplanation" in state, "selected-case review lacks an explicit explanation threshold")
require("calm-flow-direction-arrows" in scene and "updateFlowArrows" in scene, "calm directional flow lesson is missing")
require(all(token in scene for token in (
    'importedBloodflowName = "cerebral_bloodflow_animation_v2"',
    'importedFlowOverlayName = "circle_of_willis_flow_overlay_v2"',
    "startAuthoredBloodflowAnimations",
    "updateAuthoredBloodflowPlayback",
    "experience.requestedPause || reduceMotion",
    "setEnabledIfChanged(showsAuthoredBloodflow, on: qualitativeFlowOverlayLayer)",
    "registeredArrows.isEnabled = false",
)), "registered qualitative droplets/chevrons are absent or the detached-arrow quarantine regressed")
scene_update = scene.split("static func update(", 1)[1].split(
    "private static func updatePointFields", 1
)[0]
require(
    "guard experience.spatialPhase == .explanation else" in scene_update
    and "suspendImportedBloodflow(in: root)" in scene_update
    and scene_update.index("suspendImportedBloodflow(in: root)")
        < scene_update.index("updateBrainReveal"),
    "leaving explanation can skip the flow-controller shutdown before hidden anatomy work",
)
immersive_update = immersive.split("let anatomyVisible = experience.spatialPhase == .explanation", 1)[1].split(
    "// Ported from the proven Heart Field interaction engine", 1
)[0]
require(
    "StrokeSceneFactory.update(" in immersive_update
    and "if anatomyVisible" not in immersive_update,
    "RealityView does not deliver the non-anatomy phase transition to the flow shutdown",
)
require(
    "private static func suspendImportedBloodflow" in scene
    and "setEnabledIfChanged(false, on: qualitativeFlowOverlayLayer)" in scene
    and "isVisible: false" in scene
    and "isPaused: true" in scene,
    "hidden blood-flow layers or their authored playback controller remain active",
)
require(
    "STROKE_FLOW_PLAYBACK=SUSPENDED overlay=false phase=non-anatomy" in scene,
    "active-flow exit lacks a bounded debug receipt for controller suspension",
)
require(
    "let arterySeparationTarget = SIMD3<Float>" in scene
    and "approach(arteriesLayer, arterySeparationTarget)" in scene
    and "approach(blockageLayer, arterySeparationTarget)" in scene
    and "approach(authoredBloodflowLayer, arterySeparationTarget)" in scene
    and "approach(qualitativeFlowOverlayLayer, arterySeparationTarget)" in scene,
    "registered blood-flow detail can detach from the arteries during Study apart",
)
imported_update = scene.split("private static func updateImportedAnatomy", 1)[1].split(
    "private static func suspendImportedBloodflow", 1
)[0]
require(
    "setSemanticLayerOpacity(cortexOpacity, on: cortexLayer)" in imported_update
    and "cortexOpacity = Float(experience.cortexOpacity)" in imported_update
    and "let separation: Float = presentation == .exploded ? 1 : 0" in imported_update
    and "setSemanticLayerOpacity(presentation == .assembled ? 0.90 : 1, on: arteriesLayer)" in imported_update
    and "setSemanticLayerOpacity(1, on: blockageLayer)" in imported_update
    and "setSemanticLayerOpacity(presentation == .exploded ? 0.20 : 0.14, on: duraLayer)" in imported_update
    and "setSemanticLayerOpacity(" in imported_update
    and ".components.set(OpacityComponent" not in imported_update,
    "imported semantic layers still replace HierarchicalFade every frame",
)
require(
    "initialSemanticLayerOpacity" in scene
    and "case importedFlowOverlayName:" in scene
    and "abs(currentOpacity - targetOpacity) <= 0.000_001" in scene
    and "simd_length_squared(delta) <= 0.000_000_01" in imported_update
    and "setEnabledIfChanged" in imported_update,
    "imported hierarchy updates are not state-change-driven or fail to settle",
)
authored_flow_loader = scene.split("private static func startAuthoredBloodflowAnimations", 1)[1].split(
    "private static func updateAuthoredBloodflowPlayback", 1
)[0]
require(
    'name == "global scene animation"' in authored_flow_loader
    and "for child in entity.children" not in authored_flow_loader,
    "blood-flow loader still duplicates generated subtree animation aliases",
)
require(
    "DIRECTION CUE · QUALITATIVE · NOT CFD" in immersive,
    "blood-flow motion lacks its visible qualitative/non-CFD boundary",
)
require("gpt-realtime-2.1" in immersive and "STROKE_REALTIME_PROXY_URL" in immersive and "AVSpeechSynthesizer" not in immersive and "narrationEnabled" in state, "GPT-Realtime-2.1-only narrator boundary is missing")
realtime_proxy = (ROOT / "Scripts" / "realtime_narration_proxy.mjs").read_text()
realtime_runner = (ROOT / "Scripts" / "run_realtime_proxy.zsh").read_text()
require('const MODEL = "gpt-realtime-2.1"' in realtime_proxy and 'body.model !== MODEL' in realtime_proxy, "Realtime proxy does not lock the requested model")
require('response.output_audio.delta' in realtime_proxy and 'pcm16MonoToWAV' in realtime_proxy, "Realtime audio stream is not converted into app-playable WAV")
require('AVSpeechSynthesizer' not in realtime_proxy and 'apikey get OPENAI_API_KEY' in realtime_runner, "Narration can fall back to system speech or bypass the keychain router")
require('--proof-realtime-narration' in launch and "private func synchronizeNarration()" in immersive, "deterministic Realtime playback route is missing")
require(all(token in launch for token in (
    "actor StrokeAudioPlayback",
    "func playLoop(from url: URL, volume: Float)",
    "func playOnce(_ data: Data) throws",
    "await playback.playLoop",
)), "prelude audio preparation is not isolated from the main actor")
require(
    "try await self?.playback.playOnce(audio)" in immersive
    and "AVAudioPlayerDelegate" not in immersive
    and "private func synchronizeNarration()" in immersive
    and "!experience.requestedPause" in immersive,
    "Realtime narration still prepares audio on the main actor or ignores Pause",
)
require("spatial-family-controls" in immersive and "spatial-presenter-controls" in immersive and "SpatialRoleControls" in immersive, "role controls are not embedded in the immersive room")
spatial_controls = immersive.split("private struct SpatialRoleControls", 1)[1].split("private struct SpatialTeachingTimeline", 1)[0]
require("Menu {" not in spatial_controls, "immersive role controls still use unsupported SwiftUI Menu presentation")
require(all(token in spatial_controls for token in (
    "cycleAnatomyPresentation()",
    "cycleLessonFamily()",
    "cycleEnvironment()",
    'bubbleButton("Evidence"',
    'bubbleButton("Reset"',
)), "immersive direct controls do not expose every former menu action")
require("SpatialControlBubbleLabel" in immersive and ".hoverEffect(.highlight)" in immersive, "gaze-sized spatial bubble controls are missing")
require(all(question in immersive for question in ("WHAT CHANGED?", "WHY DOES PRESSURE BUILD?", "WHAT CAN MAKING SPACE DO?")), "top intention questions are missing")
require("LessonSpecimenRail" in immersive and "lesson-specimen-rail" in immersive and "selectLessonPoint" in state and "Native two-hand magnification remains the only zoom" in state, "role-aware specimen focus rail is missing")
require("rail.position = [-0.44, 1.82, -0.86]" in immersive and 'bubbleButton("Evidence"' in immersive and 'bubbleButton("Reset"' in immersive, "lesson title is not upper-field or presenter direct controls remain incomplete")
require("[-0.58, 1.34, -0.92]" in immersive and "[0.58, 1.38, -0.92]" in immersive, "family and presenter controls are not spatially separated")
require("openWindow(id: companion)" not in immersive, "immersive case docking still opens a desktop-like companion window")
require("StrokeClinicianTool" in state and "clinicianToolKitVisible" in state and "selectClinicianTool" in state, "clinician tool-kit state is missing")
require("clinician-hand-tool-wheel" in immersive and "ClinicianHandToolWheel" in immersive, "palm tool selector is missing")
require(".hand(.left, location: .palm)" in immersive and ".hand(.right, location: .palm)" in immersive, "tool kit and held tool are not hand anchored")
require("experience.audienceLens == .clinician" in immersive and "enabled && experience.clinicianToolKitVisible" in immersive, "clinician tools may leak into the family lens")
require("makeClinicianHeldTools" in scene and "suction_and_forceps" in scene and "cranial_drill_generic" in scene, "clinician concept tools are not bundled into the held-tool rig")
require("No selection mutates anatomy or simulates a cut" in scene, "clinician tool safety boundary is missing")
require(
    "@State private var proofRouteHasRun" not in launch
    and "@StateObject private var experience = StrokeExperienceState()" in app
    and "private var proofRouteHasRun = false" in state
    and "func consumeProofRouteLaunch() -> Bool" in state
    and "guard experience.consumeProofRouteLaunch() else { return }" in launch,
    "proof routing is guarded per view instead of once per shared app process",
)
proof_routes = (
    "--proof-case-unfold",
    "--proof-spatial-intake",
    "--proof-spatial-docked-case",
    "--proof-pressure",
    "--proof-family-question",
    "--proof-procedure-field",
    "--proof-layer-study",
    "--proof-flow-layer-study",
    "--proof-flow-exit",
    "--proof-view-anterior",
    "--proof-evidence-window",
    "--proof-clinician-toolkit",
    "--proof-care-purpose",
    "--proof-exit-reset",
)
require(
    all(route in simulator_proof and route in proof_route_image for route in proof_routes)
    and "VNRecognizeTextRequest" in proof_route_image
    and "PROOF_ROUTE_IMAGE=FAIL" in proof_route_image,
    "route proof does not reject blank or wrong-screen captures for the required UI states",
)
require(
    all(token in proof_route_image for token in (
        '"--proof-case-unfold": [["CASE 78"], ["FICTIONAL"], ["BEGIN PRESENTER VIEW"]]',
        '"--proof-spatial-docked-case": [["CASE 78"], ["FICTIONAL"], ["BEGIN PRESENTER VIEW"]]',
        '["QUESTION HERE", "FAMILY POINTED TO THIS AREA"]',
        '"--proof-layer-study": [["APART"]',
        '"--proof-view-anterior": [["FRONT"]',
        '"--proof-view-lateral-a": [["SIDE A"]',
        '"--proof-view-lateral-b": [["SIDE B"]',
        '"--proof-view-superior": [["TOP"]',
    ))
    and "let regions = [" in proof_route_image
    and "cgImage.cropping(to: region)" in proof_route_image
    and '[["FRONT", "VIEW"]' not in proof_route_image
    and '[["SIDE A", "VIEW"]' not in proof_route_image
    and '[["SIDE B", "VIEW"]' not in proof_route_image
    and '[["TOP", "VIEW"]' not in proof_route_image,
    "proof OCR can accept generic or stale labels instead of the exact rendered route state",
)
require("65 manifest-backed USDZ" in asset_triage and "cerebral_bloodflow_animation_v2" in asset_triage, "expanded asset catalog is not triaged for runtime use")
bundled_usdz_paths = re.findall(r"^\s+- path: (.+\.usdz)\s*$", project_yml, re.MULTILINE)
bundled_usdz_names = [Path(path).name for path in bundled_usdz_paths]
expected_story_assets = {
    "brain_anatomy_realistic_v2.usdz",
    "cerebral_arteries_realistic_v2.usdz",
    "ischemic_mca_clot_v2.usdz",
    "skull_semantic_realistic_v2.usdz",
    "dura_mater_cutaway_conceptual_v2.usdz",
    "cerebral_bloodflow_animation_v2.usdz",
    "circle_of_willis_flow_overlay_v2.usdz",
    "edema_swelling.usdz",
    "craniotomy_bone_flap.usdz",
    "dural_patch.usdz",
}
expected_clinician_tools = {
    "cranial_drill_generic.usdz",
    "suction_and_forceps.usdz",
}
require(
    len(bundled_usdz_names) == 12
    and len(set(bundled_usdz_names)) == 12
    and set(bundled_usdz_names) == expected_story_assets | expected_clinician_tools
    and all((ROOT / path).resolve().is_file() for path in bundled_usdz_paths),
    "project USDZ declaration must be exactly ten story assets plus two clinician-only tools",
)
require(
    all("ten story assets plus two clinician-only concept tools" in " ".join(document.lower().split()) for document in (
        readme,
        asset_triage,
        asset_intake,
    )),
    "runtime asset-count documentation is not exact and consistent",
)
require("museum drawer" in presentation_canon and "MetaHuman" in presentation_canon and "information state" in presentation_canon and "90-second presentation script" in presentation_canon, "presentation canon is missing the case-discovery and ethical-avatar contract")
require("anatomy-anchored handle" in presentation_canon and "Reversible layer study" in presentation_canon and "never literal peeling" in presentation_canon, "presentation canon lacks the reversible layer-study interaction contract")
require("Core spatial choreography" in product_map and "Annotation engineering contract" in product_map and "Implementation map" in product_map, "product and UI map is incomplete")
require("left" in product_map.lower() and "centre" in product_map.lower() and "right" in product_map.lower(), "product map lacks room-scale choreography")
require("BLENDER_LAYER_STUDY=PASS" in blender_manifest and "REGION_ANCHOR" in blender_builder, "executed Blender layer-study receipt is missing")
require("Houdini is not installed" in dcc_pipeline and "Unreal Editor is not installed" in dcc_pipeline, "DCC pipeline overclaims unexecuted Houdini or Unreal work")
require("RealityKit remains the runtime source of truth" in dcc_pipeline and "hub-and-spoke USD" in dcc_pipeline, "DCC/runtime authority boundary is missing")
require("SC-AIS-001.4" in clinical_packet and "PENDING CLINICIAN REVIEW" in clinical_packet, "versioned clinical-review boundary is missing")
require("familyFeedback" in immersive and '"Clarify"' in immersive, "family-only clarification control is missing")
require("Point on brain" in immersive and "family-question-marker" in immersive, "family spatial question marker is missing")
require("PlacedStrokeQuestion" in state and "rootLocalPosition" in state, "question placement is not owned in anatomy-local coordinates")
require("value.location3D" in immersive and "from: .local" in immersive and "to: .scene" in immersive, "targeted 3D hit conversion is missing")
require("root.convert(position: scenePoint, from: nil)" in immersive, "scene hit is not converted into anatomy-local coordinates")
require("root.convert(position: placement.rootLocalPosition, to: nil)" in immersive, "anatomy-local question is not reconstructed in world space")
require(immersive.count("guard StrokeSceneFactory.isAnatomyInteractionTarget(value.entity) else { return }") >= 2, "orbit and magnify are not routed to anatomy targets")
require("spatial-patient-drawer" in immersive and "SpatialPatientDrawer" in immersive and "drawer.isEnabled = experience.spatialPhase == .caseLibrary" in immersive, "focused dossier briefing is missing or persists beyond the archive")
require("VESSEL STORY" in immersive and "BRAIN ATLAS" in immersive and "let revealAll = experience.pointField == .regions" in scene, "focused specimen rail or registered transparent region-family rendering is missing")
require("FLOW_ANCHOR exports" in scene, "unreviewed flow markers are not quarantined from all-marker presentation")
require("registered-region-point-anchor" in scene and "approach(regionPointAnchor" in scene, "region lesson markers remain coupled to cortical opacity or layer motion")
require("horizon.isEnabled = experience.environmentMode == .warmHorizon" in immersive and "case .focusField: .full" in immersive, "environment state does not control horizon visibility and system immersion")
require("DirectionalLightComponent" in immersive and "experience.environmentMode == .focusField" in immersive, "focus environment lacks a bounded anatomy key light")
require(all(layer in immersive for layer in ("PRIMARY_FOVEAL", "SECONDARY_PERIPHERAL", "TERTIARY_ATMOSPHERE")), "visual-field hierarchy is not encoded in the immersive room")
spatial_workspace = (ROOT / "Docs" / "SPATIAL_CASE_WORKSPACE.md").read_text()
require("top explains, middle demonstrates" in spatial_workspace and "lower acts" in spatial_workspace, "vertical rule-of-three contract is missing")
require("never communicated by peripheral" in spatial_workspace, "peripheral safety boundary is missing")
require("--proof-family-question" in launch and "prepareFamilyQuestionProof" in state, "family question proof route is missing")
require("clarificationRequested" in state and "never infers emotion" in state, "explicit clarification or emotion-inference boundary is missing")
require("experience.present(step: step)" in immersive, "presenter-controlled act targeting is missing")
require("SpatialTeachingTimeline" in immersive and 'teachingTimelineID = "spatial-teaching-timeline"' in immersive, "centered world-space teaching timeline is missing")
require("ForEach(StrokeProcedureStep.allCases)" in immersive and ".hoverEffect(.highlight)" in immersive and "isActive ? 190 : 118" in immersive, "three-act gaze timeline lacks active expansion or quiet inactive nodes")
require("SpatialRoleMicroCues" in immersive and 'roleMicroCuesID = "spatial-role-micro-cues"' in immersive and "familyTimelineQuestion" in immersive and "presenterTimelineKeyPoints" in immersive, "role-aware left peripheral micro-cues are missing")
require(all(copy in state for copy in ("Which layer is this?", "Is this blockage, injury, or swelling?", "What can this surgery change—and not change?")), "family act questions are incomplete")
require(all(copy in state for copy in ("Generic scenario", "Whole brain first", "Not a patient scan", "Blockage → injury → swelling", "Keep them distinct", "No prognosis inferred", "Ask before transparency", "Room, not repair", "No outcome promise")), "presenter three-point act cues are incomplete")
require('title: "Act \\(experience.procedureStep.number)"' not in immersive and 'compactControl("Act \\(experience.procedureStep.number)"' not in immersive, "redundant presenter act menu remains after adding the teaching timeline")
require("--proof-clinician-pressure" in launch, "deterministic presenter proof route is missing")
require("isImmersivePresented = false\n        advanceJourney()" not in state, "permission incorrectly resets the companion window")
require("pendingConsentStep" in state and "present(step: .discussCare" in state, "presenter direct-jump consent continuation is missing")
require("StrokeModelBoardView()" in deck, "the dominant embedded 3D model is missing from the case board")
require(all(gesture in model_board for gesture in ("DragGesture", "MagnifyGesture", "SpatialTapGesture")), "orbit, scale, or vessel-focus interaction is missing")
require("makeScene(compact: true)" in model_board, "the windowed 3D model is not using the bounded scene profile")
require('--proof-inspect' in deck and '--proof-discuss' in deck, "deterministic proof routes are missing")
require('--proof-rig' in deck and 'experience.focusOcclusion()' in deck, "animated spatial-rig proof route is missing")
require("clinician review pending" in readme.lower(), "clinical review status is missing")
require("Simulator builds and screenshots do not prove XCAT" in readme, "device evidence boundary is missing")
require("SC-AIS-001.4" in clinical_packet and "PENDING CLINICIAN REVIEW" in clinical_packet, "versioned clinical review packet is missing")
require("Exact three-act review" in clinical_packet and "Reviewed on XCAT app version/build" in clinical_packet, "XCAT three-act clinical review gate is missing")
require("determine eligibility" in clinical_packet and "does not show treatment ranking" in clinical_packet, "clinical review packet lacks decision-support boundaries")
require("Houdini-ready, not Houdini-executed" in houdini, "Houdini execution boundary is missing")
require("BRAIN_REVEAL_RIG" in houdini_builder and "OCCLUSION_RADIUS_PROFILE" in houdini_builder, "stroke Houdini graph builder is missing")
require("XCAT_DEPLOY=BLOCKED" in xcat_deploy and "XCAT_DEPLOY=PASS" in xcat_deploy, "guarded XCAT deployment receipt is missing")
require("BLOCKED.md" in xcat_deploy and "device-list.json" in xcat_deploy and "Tunnel state:" in xcat_deploy, "blocked XCAT reachability does not create a dated machine receipt")
require("Install command: PASS" in xcat_deploy and "Running-process query: PASS" in xcat_deploy, "XCAT machine evidence ladder is incomplete")
require("--hackathon-demo" in xcat_deploy and "-derivedDataPath" in xcat_deploy and "WEARER_RESULT.md" in xcat_deploy and "NOT RUN" in xcat_deploy, "XCAT launch is not tied to the complete deterministic wearer route and receipt")
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
print("github_asset_runtime=TEN_STORY_PLUS_TWO_CLINICIAN_TOOLS")
print("patient_data=NONE_FICTIONAL_ONLY")
print("clinical_review=PENDING")
print("physical_device=NOT_PROVEN")
