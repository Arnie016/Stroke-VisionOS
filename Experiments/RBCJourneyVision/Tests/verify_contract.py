#!/usr/bin/env python3
from pathlib import Path
import hashlib
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]

required_files = [
    ROOT / "project.yml",
    ROOT / "Sources/RBCJourneyVisionApp.swift",
    ROOT / "Sources/RBCJourneyModel.swift",
    ROOT / "Sources/RBCJourneyTrailheadView.swift",
    ROOT / "Sources/RBCJourneyHUD.swift",
    ROOT / "Sources/RBCJourneyImmersiveView.swift",
    ROOT / "Sources/RBCFamilyNarrationEngine.swift",
    ROOT / "Sources/RBCJourneyScene.swift",
    ROOT / "Sources/RBCPortalGestureController.swift",
    ROOT / "Tests/verify_built_bundle.py",
    ROOT / "Docs/existing-app-inventory.json",
    ROOT / "Docs/medical-content-canon.md",
    ROOT / "Resources/Provenance/portal-anchor-manifest.json",
    ROOT / "Scripts/rbc_realtime_narration_proxy.mjs",
    ROOT / "Scripts/run_rbc_realtime_proxy.zsh",
    ROOT / "README.md",
]

for path in required_files:
    if not path.exists():
        raise SystemExit(f"MISSING|{path}")

project = (ROOT / "project.yml").read_text()
pbx_project = (ROOT / "RBCJourneyVision.xcodeproj/project.pbxproj").read_text()
app = (ROOT / "Sources/RBCJourneyVisionApp.swift").read_text()
model = (ROOT / "Sources/RBCJourneyModel.swift").read_text()
scene = (ROOT / "Sources/RBCJourneyScene.swift").read_text()
immersive = (ROOT / "Sources/RBCJourneyImmersiveView.swift").read_text()
trailhead = (ROOT / "Sources/RBCJourneyTrailheadView.swift").read_text()
narrator = (ROOT / "Sources/RBCFamilyNarrationEngine.swift").read_text()
gestures = (ROOT / "Sources/RBCPortalGestureController.swift").read_text()
hud = (ROOT / "Sources/RBCJourneyHUD.swift").read_text()
readme = (ROOT / "README.md").read_text()
medical_canon = (ROOT / "Docs/medical-content-canon.md").read_text()
realtime_proxy = (ROOT / "Scripts/rbc_realtime_narration_proxy.mjs").read_text()
realtime_runner = (ROOT / "Scripts/run_rbc_realtime_proxy.zsh").read_text()
anchor_manifest = json.loads((ROOT / "Resources/Provenance/portal-anchor-manifest.json").read_text())
all_source = "\n".join(path.read_text() for path in required_files if path.suffix in {".swift", ".md", ".yml"})
required_bundle_model_names = {
    "brain_anatomy_realistic_v2.usdz",
    "brain_deep_structures_v2.usdz",
    "brain_ventricles_v2.usdz",
    "cerebral_arteries_realistic_v2.usdz",
    "cranial_vascular_registered_assembly_v2.usdz",
    "ischemic_mca_clot_v2.usdz",
    "artery_cutaway_complete_v2.usdz",
    "circle_of_willis_flow_overlay_v2.usdz",
    "microcirculation_arterial_venous_v2.usdz",
    "cerebral_bloodflow_animation_v2.usdz",
}
source_library_only_model_names = {
    "artery_wall_cutaway_v2.usdz",
    "artery_interior_bloodflow_v2.usdz",
    "red_blood_cells_closeup_v2.usdz",
    "cerebral_bloodflow_teaching_set_v2.usdz",
}
required_non_model_resources = [
    "FlowBed.wav",
]
source_model_names = {path.name for path in (ROOT / "Resources/Models").glob("*.usdz")}
runtime_referenced_model_names = {
    name
    for name in source_model_names
    if f'"{Path(name).stem}"' in scene
}
declared_resource_model_names = set(re.findall(
    r"- path: Resources/Models/([^\s]+\.usdz)\s+buildPhase: resources",
    project,
))
declared_source_only_model_names = set(re.findall(
    r"- path: Resources/Models/([^\s]+\.usdz)\s+buildPhase: none",
    project,
))
pbx_resource_model_names = set(re.findall(
    r"/\* ([^*]+\.usdz) in Resources \*/",
    pbx_project,
))

brainstem_reference = anchor_manifest["registered_references"]["brainstem_vertebral_pair"]
brainstem_expected_nodes = brainstem_reference["source_entities"]
family_companion_source = model[
    model.index("var regionFamilyCompanionTitle"):
    model.index("var familyNarrationCue")
]
family_forbidden_clinician_terms = [
    "SCA", "AICA", "PICA", "M1", "lenticulostriate", "anterior choroidal",
    "posterior perforator", "calcarine", "parieto-occipital", "lingual",
]

def registration_receipt(expected_nodes, available_nodes):
    found = [name for name in expected_nodes if name in available_nodes]
    return {
        "count": len(found),
        "status": "READY" if len(found) == len(expected_nodes) else "DEGRADED",
    }

registration_fixtures_pass = (
    registration_receipt(brainstem_expected_nodes, set()) == {"count": 0, "status": "DEGRADED"}
    and registration_receipt(brainstem_expected_nodes, {brainstem_expected_nodes[0]}) == {"count": 1, "status": "DEGRADED"}
    and registration_receipt(brainstem_expected_nodes, set(brainstem_expected_nodes)) == {"count": 2, "status": "READY"}
)
brainstem_source_path = ROOT / "Resources/Models" / brainstem_reference["source_asset"]
brainstem_source_sha256 = hashlib.sha256(brainstem_source_path.read_bytes()).hexdigest()

checks = {
    "standalone_bundle": "com.arnav.RBCJourneyVision" in project,
    "intentional_app_identity": all(token in project + pbx_project for token in [
        "Resources/Assets.xcassets", "ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon",
        "MARKETING_VERSION: 0.1.0", "CURRENT_PROJECT_VERSION: 1",
    ]) and all((ROOT / path).exists() for path in [
        "Resources/Assets.xcassets/AppIcon.solidimagestack/Back.solidimagestacklayer/Content.imageset/icon.png",
        "Resources/Assets.xcassets/AppIcon.solidimagestack/Middle.solidimagestacklayer/Content.imageset/icon.png",
        "Resources/Assets.xcassets/AppIcon.solidimagestack/Front.solidimagestacklayer/Content.imageset/icon.png",
    ]),
    "exact_model_bundle_contract": (
        source_model_names == required_bundle_model_names | source_library_only_model_names
        and runtime_referenced_model_names == required_bundle_model_names
        and declared_resource_model_names == required_bundle_model_names
        and pbx_resource_model_names == required_bundle_model_names
        and declared_source_only_model_names == source_library_only_model_names
    ),
    "full_immersion": ".immersionStyle(selection: $immersionStyle, in: .full)" in app,
    "seven_station_cases": model.count("case ") >= 7 and "case microcirculation" in model,
    "manual_station_navigation": all(token in model for token in ["func select", "func back", "func advance", "func restart"]),
    "reduce_motion": "systemReduceMotion" in model and "effectiveReducedMotion" in model,
    "comfort_selection_persists": "motionMode = .continuous" not in model,
    "hud_reduce_motion": hud.count("withAnimation(") == hud.count("withAnimation(model.effectiveReducedMotion ? nil :"),
    "stable_proof_exit": all(token in model + trailhead for token in [
        "proofAutoLaunchConsumed", "!model.proofAutoLaunchConsumed",
        "model.proofAutoLaunchConsumed = true",
    ]),
    "latched_narration_pause": all(token in narrator + immersive for token in [
        "pauseRequested", "self.pauseRequested", "familyNarrator.isBusy",
        "familyNarrator.setPaused(model.isPaused)",
    ]),
    "single_realitykit_frame_driver": all(token in scene for token in [
        "SceneEvents.Update", "guard !flowRideRuntimeHeld, flowRideRuntimeProofPhase == nil else { return }",
        "retainedAuthoredFlowRideCellCount",
    ]) and "TimelineView" not in immersive and "flowRideCells" not in scene,
    "startup_transitions_outlive_warmup": all(token in scene for token in [
        "private var frameWarmupRemaining: Float = 0.20",
        "self.advanceRegionTransferFrame(deltaTime: deltaTime)",
        "self.advanceAnteriorGatewayTransitionFrame(deltaTime: deltaTime)",
        "if self.frameWarmupRemaining > 0",
    ]) and scene.index("self.advanceRegionTransferFrame(deltaTime: deltaTime)")
        < scene.index("if self.frameWarmupRemaining > 0"),
    "truthful_portal_feedback": all(token in model + gestures for token in [
        "func openNextPortal() -> Bool", "if model.openNextPortal()",
        "all three portals already open",
    ]),
    "gaze_pinch_targets": "InputTargetComponent" in scene and "CollisionComponent" in scene and "HoverEffectComponent" in scene,
    "world_anchored_hud": "world-anchored-journey-hud" in scene and "BillboardComponent" in scene,
    "stable_observation_field": "stable-observation-field-segment" in scene,
    "registered_anatomy_system": all(token in scene for token in ["registered-living-brain-system", "brain_anatomy_realistic_v2", "cerebral_arteries_realistic_v2", "cranial_vascular_registered_assembly_v2"]),
    "no_wire_cloud": all(token not in scene for token in ["conceptual-brain-envelope", "whole-space-capillary", "ambient-red-blood-cell", "conceptual-vessel-canopy"]),
    "continuous_registered_flow": all(token in scene for token in [
        "cerebral_bloodflow_animation_v2", "SceneEvents.Update",
        "latestFrameUpdate", "flowLayer.components.set",
    ]) and "playAllAnimations" not in scene,
    "true_pause_resume": all(token in scene for token in [
        "let motionHeld = paused || reducedMotion",
        "guard !flowRideRuntimeHeld, flowRideRuntimeProofPhase == nil else { return }",
    ]),
    "multi_portal_state": all(token in model + scene for token in ["openPortalIDs", "openNextPortal", "closeAllPortals", "vascular-portal-", "multi-vessel-portal-system"]),
    "maximum_three_portals": "enum RBCVesselPortal" in model and model.count("case lumen") == 1 and "0..<3" in model,
    "user_controlled_region_transfer": all(token in model + scene for token in ["focusedPortalID", "transferredPortalID", "transferToFocusedPortal", "returnToOverview", "user-controlled-region-transfer"]),
    "high_resolution_circle_context": "circle-transfer-high-resolution-cerebral-tree-context" in scene and "targetExtent: 2.72" in scene,
    "inside_brain_vault": all(token in scene for token in ["inside-cortical-vault", "large-inside-out-cortical-vault", "faceCulling = .none"]),
    "no_central_brain_model": "worldRoot.addChild(anatomyRoot)" not in scene and "corticalVaultRoot.addChild(registeredContent)" in scene,
    "surrounding_orientation_guides": all(token in model + immersive + scene for token in ["BrainOrientationLandmark", "brain-landmark-", "surrounding-brain-orientation-guides", "showTeachingPoints"]),
    "geometry_derived_portal_anchors": all(token in scene for token in ["geometryDerivedPortalAnchor", "Right_M1_Large_Vessel_Occlusion", "Flow_Route_Anterior_Communicating", "Cerebral_Cortex_R", "portal-anchor-guide-"]),
    "anchor_manifest_pending_review": len(anchor_manifest["portals"]) == 3 and all("SPECIALIST_REVIEW" in portal["review_status"] for portal in anchor_manifest["portals"]),
    "artistic_identity_boundary": "artistic-identity-echo-field-not-clinical" in scene,
    "saved_learning": all(token in model for token in ["savedLearningIDs", "currentLearningID", "toggleSavedCurrentStation", "UserDefaults.standard"]),
    "contextual_title_subtitle_fact": all(token in model + (ROOT / "Sources/RBCJourneyHUD.swift").read_text() for token in ["lessonTitle", "lessonSubtitle", "lessonFact", "Save"]),
    "t_and_clap_gestures": all(token in gestures for token in ["HandTrackingProvider", ".wrist", ".indexFingerTip", "tHoldDuration", "clapClosingSpeed", "model.openNextPortal()", "model.closeAllPortals()"]),
    "gesture_permission": "NSHandsTrackingUsageDescription" in project,
    "blockage_focus": all(token in scene for token in ["ischemic_mca_clot_v2", "applyMaterialRecursively", "example-right-m1-blockage-halo"]),
    "spatial_audio": "SpatialAudioComponent" in scene and (ROOT / "Resources/Audio/FlowBed.wav").exists(),
    "proof_routes": all(token in model for token in ["--proof-station-", "--proof-portals-", "--proof-focus-", "--proof-comfort-still", "--proof-paused", "--proof-transfer-"]),
    "explicit_scene_readiness": all(token in model + scene + hud + immersive + readme for token in [
        "RBCSceneReadinessPhase", "case loading", "case ready", "case degraded", "case failed",
        "RBCSceneReadinessSurface", "model.sceneReadinessPhase != .ready",
        "expectedBundledModelNames", "requiredEntitiesByModel", "readinessReport(",
        "resolveReadinessAfterFirstPresentationFrame", "presentation:RealityKit-frame",
        "RBC_SCENE_READINESS=", "RBC_MODEL_LOAD=DEGRADED",
        "--proof-scene-loading", "--proof-scene-ready",
        "--proof-scene-degraded", "--proof-scene-failed",
        "GENERIC SYNTHETIC TEACHING VIEW · NOT A PATIENT SCAN",
        "SPECIALIST REVIEW PENDING · CLINICAL REVIEW PENDING",
    ]) and "model.isSceneReady = true" not in immersive,
    "live_scene_readiness_attachment": (
        'Attachment(id: "sceneReadiness")' in immersive
        and "scene.attachReadinessSurface(" in immersive
        and "scene.resolveReadinessAfterFirstPresentationFrame" in immersive
        and "firstPresentationFrameAction" in scene
        and "await scene.waitForFirstPresentationFrame()" not in immersive
        and immersive.index("content.add(scene.root)") < immersive.index("await scene.build()")
        and immersive.index("scene.installFrameUpdates()") > immersive.index("} update:")
    ),
    "required_assets": all((ROOT / "Resources/Models" / name).exists() for name in required_bundle_model_names | source_library_only_model_names)
        and all(any(ROOT.glob(f"Resources/**/{name}")) for name in required_non_model_resources),
    "self_contained_resources": "- path: Resources" in project and "../Stroke-VisionOS" not in project,
    "medical_boundary": all(term in all_source for term in ["not patient-specific", "not CFD", "specialist review"]),
    "persistent_immersive_boundary": all(token in hud for token in [
        "RBCEducationalBoundaryBadge", "GENERIC SYNTHETIC TEACHING VIEW",
        "NOT A PATIENT SCAN", "SPECIALIST REVIEW PENDING", "CLINICAL REVIEW PENDING",
        "RBCEntryPreludeHUD", "RBCExhibitInfoHUD", "RBCRegionInfoHUD", "RBCRegionTransferHUD",
    ]) and hud.count("RBCEducationalBoundaryBadge()") >= 5,
    "family_clinician_audience_separation": all(token in model + hud for token in [
        "regionFamilyCompanionTitle", "regionFamilyCompanionSubtitle", "regionFamilyCompanionFact",
        "FAMILY COMPANION", "CLINICIAN DETAIL", "Small arteries reach deep tissue",
        "Blood routes reach the visual area", "Two blood routes join into one",
        "SCA, AICA, and PICA", "M1 lenticulostriate", "calcarine, parieto-occipital, and lingual",
    ]) and all(term not in family_companion_source for term in family_forbidden_clinician_terms),
    "no_custom_camera": "PerspectiveCameraComponent" not in all_source,
    "no_direct_provider_secret": all(term not in all_source for term in [
        "OPENAI_API_KEY", "https://api.openai"
    ]) and all(token in narrator for token in [
        "RBC_REALTIME_PROXY_URL", "URLSession.shared.data", "X-RBC-Narration-Copy-SHA256"
    ]),
    "no_strokecare_source_dependency": "com.arnav.StrokeTime" not in all_source and "import StrokeCare" not in all_source,
    "targeted_portal_gesture": ".targetedToAnyEntity()" in immersive and "portalID(for:" in immersive,
    "three_beat_wondrous_journey": all(token in model for token in [
        "enum RBCExhibitBeat", "case route", "case blockage", "case consequence",
        "startWondrousJourney", "advanceExhibit", "retreatExhibit",
    ]),
    "single_portal_judge_path": all(token in model for token in [
        "RBCVesselPortal.circleOfWillis.id", "--proof-exhibit-", "experienceMode",
    ]),
    "minimal_exhibit_interface": all(token in hud + immersive for token in [
        "RBCExhibitInfoHUD", "RBCExhibitControlsHUD", "Explain",
        "RBCExhibitControlsHUD()",
        "model.experienceMode == .wondrousJourney",
    ]),
    "geometry_derived_causal_story": all(token in scene for token in [
        "portal-projected-causal-story-field-pending-specialist-review",
        "route-from-circle-to-example-right-m1",
        "illustrative-downstream-consequence-field-not-segmentation",
        "Flow_Route_Anterior_Communicating",
        "Right_M1_Large_Vessel_Occlusion",
        "updateCausalStory",
    ]),
    "region_portal_reel": all(token in model + hud + immersive + scene for token in [
        "RBCBrainRegionDestination", "RBCRegionPortalReelHUD", "regionPortalReel",
        "ventricular-system-region-portal", "cerebellum-region-portal",
        "deep-structures-region-portal", "--proof-region-", "ONE ACTIVE",
    ]),
    "stationary_wearer_region_threshold": all(token in model + hud + immersive + scene for token in [
        "pendingRegionDestination", "requestRegion", "completePendingRegionTransfer",
        "regionTransferSequenceKey", "--proof-region-transition-",
        "--proof-region-transition-progress-", "RBCRegionTransferHUD", "Opening…",
        "The room moves. You stay.", "Watch the next region gather around your point of view.",
        "region-transfer-threshold-stationary-wearer-no-camera-locomotion",
        "irregular-laminar-region-threshold-contour-", "outward-cortical-fiber-threshold-shard-",
        "advanceRegionTransferFrame", "pendingRegionID", "regionTransferProofProgress",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "circle_network_to_branch_focus": all(token in model + hud + immersive + scene + medical_canon for token in [
        "enum RBCWillisRouteFocus", "case overview", "case anterior", "case posterior",
        "Whole circle", "Follow the anterior route", "Follow the posterior route",
        "selectWillisRouteFocus", "--proof-willis-route-overview",
        "--proof-willis-route-anterior", "--proof-willis-route-posterior",
        "room-scale-circle-of-willis-network-not-patient-specific",
        "qualitative-anterior-route-family", "qualitative-posterior-route-family",
        "communicating-artery-connection-family-no-fixed-flow-claim",
        "willis-tangent-flow-front-", "willis-flow-front-arrowhead",
        "willis-flow-front-tail", "paths=26", "moving_fronts=16", "connector_fronts=0",
        "addContinuousTubePath", "inwardFacing: false", "advanceWillisNetworkFrame",
        "willisRouteFocus", "Circle of Willis anatomy varies between people",
        "do not imply that every person has a complete symmetric circle",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "user_directed_anterior_passage": all(token in model + scene + hud + immersive + medical_canon + readme for token in [
        "enum RBCAnteriorPassagePhase", "case carotidApproach", "case circleCrossroads",
        "case middleCerebralContinuation", "--proof-anterior-passage-carotid",
        "--proof-anterior-passage-crossroads", "--proof-anterior-passage-mca",
        "Two carotid routes rise", "At the arterial crossroads", "Follow one right MCA route",
        "Enter anterior passage", "Reach the crossroads", "Reveal MCA routes",
        "Enter artery", "Open frontal field", "Leave passage",
        "startAnteriorPassage", "advanceAnteriorPassage", "chooseAnteriorDestination",
        "anterior-passage-paired-internal-carotid-approaches",
        "anterior-passage-circle-crossroads",
        "anterior-passage-selected-right-mca-exemplar-not-patient-specific",
        "contralateral-mca-context-not-selected-route",
        "right-mca-entry-threshold-to-inhabited-arterial-lumen",
        "anterior-passage-mca-navigation-halo-not-vessel-color",
        "isSelectedAnteriorExemplar", "selected_route_halos=3", "gateway=1",
        "startFlowRide()", "requestRegion(destination)",
        "familyNarrationText", "activeWillisTitle", "activeWillisSubtitle",
        ".onChange(of: model.familyNarrationText)", "speakExactCaption",
        "teaching exemplar, not a patient-specific pathway",
        "stationary wearer",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "spatial_anterior_gateway_activation": all(token in model + scene + hud + immersive + medical_canon + readme for token in [
        "isAnteriorPassageGatewayTarget", "right-mca-entry-threshold-to-inhabited-arterial-lumen",
        "InputTargetComponent", "allowedInputTypes: [.direct, .indirect]",
        "CollisionComponent", ".generateSphere(radius: 0.205)", "HoverEffectComponent()",
        "TapGesture()", ".targetedToAnyEntity()",
        "model.chooseAnteriorDestination(.arterialLumen)",
        "Look at its warm threshold and pinch", "system hover", "Enter artery",
        "motor fallback", "do not expose or retain an eye-gaze vector",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "continuous_anterior_gateway_to_lumen_transition": all(token in model + scene + hud + immersive + medical_canon + readme for token in [
        "isAnteriorGatewayTransitionActive", "beginAnteriorGatewayTransition",
        "--proof-anterior-gateway-transition-", "The route becomes a place",
        "The branch opens around you. Your body stays still.", "1_650", "480",
        "advanceAnteriorGatewayTransitionFrame", "anteriorGatewayTransitionVisualProgress",
        "gatewayTransitionActive", "gatewayLocus", "flowRideRoot.position = gatewayLocus",
        "willisNetworkRoot.isEnabled = gatewayProgress < 0.84",
        "Circle and lumen", "same gateway locus", "Reduce Motion",
        "RBCRegionTransferHUD", "!model.isAnteriorGatewayTransitionActive",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "spatial_entry_prologue": all(token in model + hud + immersive + scene for token in [
        "RBCEntryPreludeChapter", "Entering the brain.", "No region works alone.",
        "A blockage changes more than one point.", "Follow one route.",
        "RBCEntryPreludeHUD", "startEntryPrelude", "advanceEntryPrelude",
        "prepareForPrelude", "preludeTransform", "--proof-prelude-", "Skip",
    ]),
    "frontal_region_directional_flow": all(token in model + scene + hud for token in [
        "case frontalLobe", "frontal-region-orientation-outline-not-segmentation",
        "frontal-lobe-directional-blood-flow-field", "frontal-flow-direction-arrow",
        "generateCone", "CLINICIAN DETAIL  ·", "INSIDE  ·", "macroContextScale",
        "Frontal lobe · capillary field",
    ]),
    "brain_observatory_views": all(token in model + scene + hud for token in [
        "enum RBCRegionVisualizationMode", "case locate", "case xray", "case flow",
        "prefrontal-constellation-guide-star", "--proof-region-mode-flow",
        "RBCRegionModeButton", "regionVisualization == .flow",
    ]),
    "gaze_pinch_region_discovery": all(token in model + scene + immersive for token in [
        "brain-region-discovery-target-", "InputTargetComponent", "CollisionComponent",
        "HoverEffectComponent", "brainRegionID(for:", "activateRegionDiscovery",
    ]),
    "frontal_clot_scenario": all(token in model + scene + hud + immersive for token in [
        "--proof-frontal-clot", "illustrative-frontal-branch-occlusion-not-patient-specific",
        "toggleFrontalClotScenario", "Place example clot", "frontalClotScenarioActive",
    ]),
    "inhabit_the_flow_ride": all(token in model + scene + hud + immersive for token in [
        "--proof-flow-ride", "inside-arterial-lumen-flow-ride", "startFlowRide",
        "stopFlowRide", "Enter this branch", "Pause journey", "flowRideActive",
        "Combined_Blood_RBC_", "Combined_Blood_Arrow_",
    ]),
    "continuous_deforming_flow_field": all(token in scene + immersive for token in [
        "continuous-intraluminal-direction-field-not-cfd",
        "continuous-intraluminal-direction-ribbon-with-traveling-luminance-front-lane-",
        "flowRideRibbonSegments", "baseOrientation", "deformation", "bloodCellMaterial",
        "SceneEvents.Update", "installFrameUpdates", "advanceFlowRideFrame",
        "streamline.isEnabled = false", "arrow.isEnabled = false",
    ]),
    "layered_directional_blood_current": all(token in scene + model + immersive + medical_canon + readme for token in [
        "--proof-flow-phase-", "flowRideProofPhase", "flowRideRuntimeProofPhase",
        "buildFlowCurrentChoreography", "offsetFlowStrandPath", "bloodCurrentMaterial",
        "continuous-layered-blood-current-not-cfd-strand-", "flow_strands=",
        "tangent-aligned-blood-current-front-not-velocity-field-",
        "blood-current-direction-arrowhead", "blood-current-direction-fading-wake",
        "Forty-two clones", "for index in 0..<42", "warm amber", "teal remains",
        "velocity profile", "hematocrit", "multi-cell simulation",
    ]),
    "opt_in_family_realtime_guide": all(token in model + immersive + hud + narrator + realtime_proxy + realtime_runner for token in [
        "--proof-family-guide", "Optional voice", "familyNarrationEnabled",
        "gpt-realtime-2.1", "RBC_REALTIME_PROXY_URL", "marin",
        "X-RBC-Narration-Model", "X-RBC-Narration-Copy-SHA256",
        "X-RBC-Narration-Transcript-SHA256", "canonicalNarrationSHA256",
        "response.output_audio_transcript.delta", "realtime_transcript_mismatch",
        "response.output_audio.delta", "pcm16MonoToWAV",
        "rbc-journey-reviewed-family-caption", "apikey get OPENAI_API_KEY",
    ]) and "AVSpeechSynthesizer" not in narrator + realtime_proxy,
    "region_family_voice_companion": all(token in model + hud + immersive + narrator for token in [
        "--proof-region-family-companion", "regionFamilyCompanionTitle",
        "regionFamilyCompanionSubtitle", "Family companion",
        "Voice reads this exact view.", "familyNarrationText",
        "X-RBC-Narration-Transcript-SHA256",
    ]) and "NSMicrophoneUsageDescription" not in project
        and "regionFamilyCompanionProofRequested && regionIndex == nil" in model,
    "family_voice_spatial_thresholds": all(token in model + hud + immersive + scene + narrator for token in [
        "regionTransferFamilyTitle", "regionTransferFamilySubtitle",
        "regionTransferNarrationWaitLimitMilliseconds", "shouldDuckAmbientAudio",
        "narrationWaitMilliseconds", "narrationDucking", "min(exhibitGain, -42.0)",
    ]),
    "inhabited_branching_flow_corridor": all(token in model + scene + hud + immersive for token in [
        "enum RBCFlowRideRoute", "native-inward-facing-arterial-corridor",
        "makeInwardFacingTubeMesh", "flowRideJourneyCells",
        "frontal-route-constellation-outline-not-segmentation",
        "neighbor-route-tissue-point-field-not-segmentation",
        "Both paths", "Frontal route", "Neighbor route",
        "--proof-flow-route-frontal", "--proof-flow-route-neighbor",
    ]),
    "provenance_tracked_arterial_wall_microtexture": all(token in scene for token in [
        "firstPhysicallyBasedMaterial", "Combined_Artery_Media",
        "pbr.baseColor.texture != nil", "pbr.normal.texture != nil",
        "pbr.roughness.texture != nil", "adaptedArterialWallMaterial",
        "provenance-tracked-arterial-wall-pbr-microtexture-main",
        "descriptor.textureCoordinates", "descriptor.tangents",
        "descriptor.bitangents", "RBC_FLOW_WALL_PBR=READY",
    ]),
    "frontal_macro_to_micro_destination": all(token in scene + model + medical_canon for token in [
        "frontal-route-arteriole-capillary-transition-not-to-scale",
        "frontal-route-penetrating-arteriole",
        "frontal-route-capillary-link-",
        "frontal-route-capillary-traveling-flow-front-",
        "frontal-route-cortical-exchange-surface-not-segmentation",
        "capillary_nodes=34", "organic_links=nearest_neighbor",
        "From artery to cortex", "A network meets the cortex",
        "surface arteries give rise to", "macro-to-micro destination expands scale",
    ]),
    "paced_family_voyage_guide": all(token in model + hud + immersive for token in [
        "enum RBCFamilyNarrationMoment", "case orientation", "case passage", "case arrival",
        "familyNarration(for moment:", "You are inside a cerebral artery",
        "The route narrows toward cortex", "Anatomy can vary",
        "familyNarrationSequenceKey", "selectFlowRideRoute", "familyNarrationProofLocked",
        "--proof-family-guide-beat-", "minimumDwellSeconds",
        "Caption-led; optional voice is not connected.",
    ]) and "|| (model.proofMode && model.familyNarrationEnabled)" not in immersive,
    "parent_paced_family_scaffold": all(token in model + hud + immersive + narrator for token in [
        "NOTICE", "FOLLOW", "CONNECT", "minimumDwellSeconds",
        "advanceFamilyNarration", "replayFamilyNarration", "Hear again", "Next idea",
        "familyNarrationAdvanceTitle", "Enter field", "automaticMoments",
        "familyNarrator.isBusy", "requestTask != nil || player != nil",
        "AVAudioPlayerDelegate", "audioPlayerDidFinishPlaying",
    ]),
    "automatic_guided_vascular_journey": all(token in model + hud + immersive + narrator for token in [
        "enum RBCGuidedFlowTourPhase", "case source", "case division", "case chooseFrontal",
        "case enterFrontal", "case narrowTowardCortex", "case capillaryArrival", "case complete",
        "guidedFlowTourSequenceKey", "isGuidedFlowTourPlaying", "advanceGuidedFlowTour",
        "restartGuidedFlowTour", "applyGuidedFlowTourPhase", "while model.isGuidedFlowTourPlaying",
        "Pause journey", "Resume journey", "Journey complete", "minimumDwellSeconds",
        "familyNarrator.state == .loading", "familyNarrator.state == .speaking",
        "AVAudioPlayerDelegate", "audioPlayerDidFinishPlaying",
    ]),
    "cortical_microarchitecture_room": all(token in model + scene + hud + medical_canon for token in [
        "case corticalMicroarchitecture", "Cortical microarchitecture", "Cortical layers",
        "cortical-microarchitecture-constellation-outline-not-segmentation",
        "six-cortical-laminae-magnified-teaching-model-not-to-scale",
        "simplified-radial-columnar-guides-area-variation-explicit",
        "pial-to-penetrating-arteriole-to-capillary-direction-field-not-cfd",
        "cortical-microarchitecture-flow-arrowhead", "cortical-microarchitecture-flow-arrow-tail",
        "laminae=6", "radial_guides=5", "illustrative_cells=93", "vascular_paths=9",
        "updateCorticalMicroarchitectureRegion", "advanceCorticalMicroarchitectureFrame",
        "SceneEvents.Update", "region == .corticalMicroarchitecture",
        "pial arteries distribute blood", "Five radial guides",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "cerebellar_observatory_folds_to_flow": all(token in model + scene + hud + medical_canon for token in [
        "RBC_CEREBELLAR_OBSERVATORY=READY",
        "cerebellum-constellation-outline-not-segmentation",
        "magnified-cerebellar-folia-orientation-bands-not-histology",
        "magnified-arbor-vitae-orientation-abstraction-not-histology",
        "qualitative-sca-aica-pica-vertebrobasilar-approaches-not-patient-specific",
        "folia_bands=47", "arbor_paths=13", "arterial_paths=15", "moving_fronts=22",
        "cerebellar-tangent-flow-front", "advanceCerebellumFrame",
        "SceneEvents.Update", "region == .cerebellum",
        "SCA, AICA, and PICA", "47 fold bands", "substantial variation",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "deep_structures_observatory_perforator_flow": all(token in model + scene + hud + medical_canon for token in [
        "RBC_DEEP_OBSERVATORY=READY",
        "registered-combined-deep-structures-reference-expanded-environment-not-segmentation",
        "deep-nuclei-constellation-outlines-not-segmentation",
        "thalamus-caudate-lentiform-relational-guides-not-measured-anatomy",
        "internal-capsule-corridor-orientation-abstraction-not-tractography",
        "qualitative-deep-perforator-approaches-not-fixed-territories",
        "deep-nucleus-sparse-point-cloud-orientation-not-segmentation",
        "deep-perforator-tangent-flow-front", "deep-perforator-flow-front-arrowhead",
        "nuclei_guides=6", "nucleus_points=192", "capsule_fibers=10",
        "arterial_paths=18", "moving_fronts=20", "advanceDeepStructuresFrame",
        "SceneEvents.Update", "region == .deepStructures",
        "Small branches, deep consequences", "M1 lenticulostriate",
        "not semantic segmentation", "fixed arterial territories",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "occipital_observatory_calcarine_flow": all(token in model + scene + hud + medical_canon for token in [
        "case occipitalLobe", "Occipital lobe", "Visual cortex",
        "RBC_OCCIPITAL_OBSERVATORY=READY",
        "registered-cortex-expanded-around-wearer-occipital-context-not-segmentation",
        "occipital-pole-constellation-outline-not-segmentation",
        "occipital-surface-fold-fragments-orientation-not-histology",
        "calcarine-upper-lower-bank-orientation-guide-not-retinotopy",
        "qualitative-pca-calcarine-parieto-occipital-lingual-routes-not-fixed-territories",
        "selected_medial_wall=left", "broken_boundary_arcs=3", "field_points=168",
        "fold_fragments=28", "calcarine_bank_layers=6", "arterial_paths=10", "moving_fronts=12",
        "occipital-flow-front-arrowhead", "occipital-flow-front-tail",
        "updateOccipitalRegion", "advanceOccipitalFrame", "SceneEvents.Update",
        "region == .occipitalLobe", "Posterior routes enter the visual cortex",
        "not lobe segmentation", "retinotopic or visual-field mapping",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "brainstem_posterior_circulation_bridge": all(token in model + scene + hud + medical_canon for token in [
        "case brainstem", "Brainstem bridge",
        "RBC_BRAINSTEM_OBSERVATORY=\\(registrationStatus)",
        "registered-brainstem-relational-context-combined-source-not-segmentation",
        "registered-paired-vertebral-artery-reference-source-nodes",
        r"brainstem-\(level.name)-broken-constellation-arc-",
        "brainstem-longitudinal-and-transverse-pathway-guides-not-tractography",
        "qualitative-vertebral-basilar-pica-aica-sca-pca-and-pontine-routes-not-fixed-territories",
        "levels=3", "broken_outline_arcs=9", "environmental_wall_sheets=4", "peripheral_ribs=16",
        "longitudinal_guides=9", "transverse_pons_guides=9", "tegmental_points=72",
        "arterial_paths=17", "moving_fronts=23", "registered_vertebral_nodes=\\(brainstemRegisteredVertebralNodeCount)",
        "expected_vertebral_nodes=\\(expectedVertebralNodeCount)", "DEGRADED",
        "brainstem-flow-front-arrowhead", "brainstem-flow-front-tail",
        "updateBrainstemRegion", "advanceBrainstemFrame", "SceneEvents.Update",
        "region == .brainstem", "Two vertebral routes become one",
        "midbrain, pons, and medulla", "not brainstem segmentation",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "truthful_brainstem_registration_receipt": (
        len(brainstem_expected_nodes) == brainstem_reference["required_count"] == 2
        and all(name in scene for name in brainstem_expected_nodes)
        and brainstem_reference["review_status"].endswith("PENDING_SPECIALIST_REVIEW")
        and brainstem_reference["display_status"] == "DISABLED_PROVENANCE_REFERENCE"
        and brainstem_source_sha256 == brainstem_reference["source_asset_sha256"]
        and "brainstemRegisteredVertebralNodeCount += 1" in scene
        and "registered_vertebral_nodes=2" not in scene
        and registration_fixtures_pass
    ),
    "user_directed_posterior_voyage": all(token in model + scene + hud + immersive + medical_canon + readme for token in [
        "enum RBCPosteriorVoyagePhase", "case convergence", "case basilarBridge", "case destinations",
        "--proof-posterior-voyage-convergence", "--proof-posterior-voyage-bridge",
        "--proof-posterior-voyage-choice", "Two routes approach", "Inside the basilar bridge",
        "Where should the route continue?", "Follow posterior route", "Reach the bridge",
        "Open destinations", "Cerebellum", "Visual cortex", "Leave route",
        "startPosteriorVoyage", "advancePosteriorVoyage", "choosePosteriorDestination",
        "posterior-voyage-vertebral-to-basilar-convergence",
        "posterior-voyage-cerebellar-route-family",
        "posterior-voyage-posterior-cerebral-route-family",
        "posterior-voyage-small-pontine-approaches", "voyage_route_groups=4",
        "destination_route_halos=8", "destination-teaching-halo-not-vessel-color",
        "configureBrainstemVoyageTransition", "simd_slerp", "1.10",
        "model.posteriorVoyagePhase", "requestRegion(destination)",
        "familyNarrationText", "activeBrainstemTitle", "activeBrainstemSubtitle",
        "arterial walls remain red", "spatial storytelling device, not anatomical",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "guided_capillary_focus": all(token in model + scene + hud + immersive for token in [
        "--proof-capillary-focus", "isCapillaryFieldFocused",
        "toggleCapillaryFieldFocus", "case .capillaryArrival, .complete",
        "frontal-capillary-field-focus-target", "isCapillaryFocusTarget",
        "flowRideCapillaryFocusMix", "flowRideFrontalOutlineRoot",
        "flowRideFrontalArterioleRoot", "flowRideCapillaryWebRoot",
        "The network expands around you while your body stays still.",
        "familyNarrationMoment = .arrival",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "capillary_flow_to_exchange_story": all(token in scene + model + medical_canon for token in [
        "capillary-flow-front-arrowhead", "capillary-flow-front-tail",
        "flowRideCapillaryExchangeRipples", "exchange_ripples=6",
        "frontal-capillary-exchange-ripple-not-diffusion-measurement-",
        "capillary-to-tissue-exchange-wave", "The red cell and arrow fronts remain intravascular",
        "Red cells stay inside the vessels while soft rings show exchange with nearby tissue conceptually",
        "not at real scale or measured flow",
        "oxygen moves from blood toward tissue by diffusion",
    ]) and "oxygen concentration measurement" not in scene + model
        and "ripple.components.set(OpacityComponent(opacity: 0))" not in scene,
    "route_front_selection_contrast": all(token in scene for token in [
        "let selectedScale: Float = selected ? 1 : 0.18",
        "transform-only contrast, avoiding per-frame component writes",
    ]),
    "flow_ride_brain_locator": all(token in scene + model + hud + immersive for token in [
        "RBCFlowRideMiniMapHUD", "HStack(alignment: .bottom, spacing: 18)",
        "BRAIN ATLAS", "ANTERIOR VIEW", "YOU ARE HERE", "Frontal lobe · capillary field",
        "registered-three-dimensional-brain-route-locator", "miniature-registered-cortex-and-cerebral-arteries",
        "geometry-derived-spatial-atlas-locator-", "Flow_Route_Anterior_Communicating",
        "Right_M1_Large_Vessel_Occlusion", "Cerebral_Cortex_R", "patient_registration=false",
        "capillary_proxy=true", "The atlas is an orientation instrument",
        "geometry-derived-atlas-route-trace", "geometry-derived-atlas-route-front-",
        "flowRideSpatialAtlasRouteFronts", "sampleAtlasPolyline",
        "activeJourneyStage", "FORK", "FRONTAL", "CORTEX",
        "geometry-derived-atlas-region-labels", "generateText",
        "geometry-derived-atlas-label-anchor-", "atlas-region-label-stem",
    ]) and "Canvas {" not in hud,
    "living_inside_brain_cortical_context": all(token in scene for token in [
        "surrounding-inside-brain-cortical-fold-scaffold-not-segmentation",
        "room-scale-inside-out-registered-cortical-fold-environment",
        "flowRideCorticalScaffoldMaterial", "slow_living_motion=true",
        "not_neuroplasticity=true", "Pause and Reduce Motion hold the same clock",
    ]),
    "map_aware_optional_realtime_voiceover": all(token in model + narrator + realtime_proxy for token in [
        "The three-dimensional brain atlas marks this teaching fork",
        "The atlas marker moves with it",
        "The locator enters the frontal branch",
        "gpt-realtime-2.1", "speakExactCaption", "realtime_transcript_mismatch",
    ]),
}

failed = [name for name, passed in checks.items() if not passed]
for name, passed in checks.items():
    print(f"{name}|{'PASS' if passed else 'FAIL'}")

if failed:
    print("RBC_JOURNEY_CONTRACT=FAIL|" + ",".join(failed))
    sys.exit(1)

print("RBC_JOURNEY_CONTRACT=PASS")
