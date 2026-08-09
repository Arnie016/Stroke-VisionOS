#!/usr/bin/env python3
from pathlib import Path
import json
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
app = (ROOT / "Sources/RBCJourneyVisionApp.swift").read_text()
model = (ROOT / "Sources/RBCJourneyModel.swift").read_text()
scene = (ROOT / "Sources/RBCJourneyScene.swift").read_text()
immersive = (ROOT / "Sources/RBCJourneyImmersiveView.swift").read_text()
narrator = (ROOT / "Sources/RBCFamilyNarrationEngine.swift").read_text()
gestures = (ROOT / "Sources/RBCPortalGestureController.swift").read_text()
hud = (ROOT / "Sources/RBCJourneyHUD.swift").read_text()
readme = (ROOT / "README.md").read_text()
medical_canon = (ROOT / "Docs/medical-content-canon.md").read_text()
realtime_proxy = (ROOT / "Scripts/rbc_realtime_narration_proxy.mjs").read_text()
realtime_runner = (ROOT / "Scripts/run_rbc_realtime_proxy.zsh").read_text()
anchor_manifest = json.loads((ROOT / "Resources/Provenance/portal-anchor-manifest.json").read_text())
all_source = "\n".join(path.read_text() for path in required_files if path.suffix in {".swift", ".md", ".yml"})
required_resource_names = [
    "brain_anatomy_realistic_v2.usdz",
    "brain_deep_structures_v2.usdz",
    "brain_ventricles_v2.usdz",
    "cerebral_arteries_realistic_v2.usdz",
    "cranial_vascular_registered_assembly_v2.usdz",
    "ischemic_mca_clot_v2.usdz",
    "artery_cutaway_complete_v2.usdz",
    "circle_of_willis_flow_overlay_v2.usdz",
    "red_blood_cells_closeup_v2.usdz",
    "microcirculation_arterial_venous_v2.usdz",
    "cerebral_bloodflow_animation_v2.usdz",
    "FlowBed.wav",
]

checks = {
    "standalone_bundle": "com.arnav.RBCJourneyVision" in project,
    "full_immersion": ".immersionStyle(selection: $immersionStyle, in: .full)" in app,
    "seven_station_cases": model.count("case ") >= 7 and "case microcirculation" in model,
    "manual_station_navigation": all(token in model for token in ["func select", "func back", "func advance", "func restart"]),
    "reduce_motion": "systemReduceMotion" in model and "effectiveReducedMotion" in model,
    "gaze_pinch_targets": "InputTargetComponent" in scene and "CollisionComponent" in scene and "HoverEffectComponent" in scene,
    "world_anchored_hud": "world-anchored-journey-hud" in scene and "BillboardComponent" in scene,
    "stable_observation_field": "stable-observation-field-segment" in scene,
    "registered_anatomy_system": all(token in scene for token in ["registered-living-brain-system", "brain_anatomy_realistic_v2", "cerebral_arteries_realistic_v2", "cranial_vascular_registered_assembly_v2"]),
    "no_wire_cloud": all(token not in scene for token in ["conceptual-brain-envelope", "whole-space-capillary", "ambient-red-blood-cell", "conceptual-vessel-canopy"]),
    "continuous_registered_flow": all(token in scene for token in ["cerebral_bloodflow_animation_v2", "availableAnimations", "animation.repeat()", "flowAnimationControllers"]),
    "true_pause_resume": all(token in scene for token in ["controller.pause()", "controller.resume()", "setAnimationsPaused"]),
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
    "required_assets": all(any(ROOT.glob(f"Resources/**/{name}")) for name in required_resource_names),
    "self_contained_resources": "- path: Resources" in project and "../Stroke-VisionOS" not in project,
    "medical_boundary": all(term in all_source for term in ["not patient-specific", "not CFD", "specialist review"]),
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
    "spatial_entry_prologue": all(token in model + hud + immersive + scene for token in [
        "RBCEntryPreludeChapter", "Entering the brain.", "No region works alone.",
        "A blockage changes more than one point.", "Follow one route.",
        "RBCEntryPreludeHUD", "startEntryPrelude", "advanceEntryPrelude",
        "prepareForPrelude", "preludeTransform", "--proof-prelude-", "Skip",
    ]),
    "frontal_region_directional_flow": all(token in model + scene + hud for token in [
        "case frontalLobe", "frontal-region-orientation-outline-not-segmentation",
        "frontal-lobe-directional-blood-flow-field", "frontal-flow-direction-arrow",
        "generateCone", "INSIDE  ·",
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
        "stopFlowRide", "Enter this branch", "Pause ride", "flowRideActive",
        "Combined_Blood_RBC_", "Combined_Blood_Arrow_",
    ]),
    "continuous_deforming_flow_field": all(token in scene + immersive for token in [
        "continuous-intraluminal-direction-field-not-cfd",
        "continuous-intraluminal-direction-ribbon-with-traveling-luminance-front-lane-",
        "flowRideRibbonSegments", "baseOrientation", "deformation", "bloodCellMaterial",
        "SceneEvents.Update", "installFrameUpdates", "advanceFlowRideFrame",
        "streamline.isEnabled = false", "arrow.isEnabled = false",
    ]),
    "opt_in_family_realtime_guide": all(token in model + immersive + hud + narrator + realtime_proxy + realtime_runner for token in [
        "--proof-family-guide", "Family guide", "familyNarrationEnabled",
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
    ]) and "NSMicrophoneUsageDescription" not in project,
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
        "familyNarration(for moment:", "The fork comes into view",
        "Flow carries oxygen forward", "Anatomy can vary",
        "familyNarrationSequenceKey", "selectFlowRideRoute", "familyNarrationProofLocked",
        "--proof-family-guide-beat-", "minimumDwellSeconds",
        "Captions work now; connect the local guide for voice.",
    ]) and "|| (model.proofMode && model.familyNarrationEnabled)" not in immersive,
    "parent_paced_family_scaffold": all(token in model + hud + immersive + narrator for token in [
        "NOTICE", "FOLLOW", "CONNECT", "minimumDwellSeconds",
        "advanceFamilyNarration", "replayFamilyNarration", "Hear again", "Next idea",
        "familyNarrationAdvanceTitle", "Enter field", "automaticMoments",
        "familyNarrator.state == .loading", "familyNarrator.state == .speaking",
        "AVAudioPlayerDelegate", "audioPlayerDidFinishPlaying",
    ]) and "model.flowRideRoute == .frontal && !model.familyNarrationEnabled" in hud,
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
    "user_triggered_capillary_focus": all(token in model + scene + hud + immersive for token in [
        "--proof-capillary-focus", "isCapillaryFieldFocused",
        "toggleCapillaryFieldFocus", "Enter capillary field", "Return to artery",
        "frontal-capillary-field-focus-target", "isCapillaryFocusTarget",
        "flowRideCapillaryFocusMix", "flowRideFrontalOutlineRoot",
        "flowRideFrontalArterioleRoot", "flowRideCapillaryWebRoot",
        "The network expands around you while your body stays still.",
        "setFamilyNarrationMoment(.arrival)",
    ]) and "PerspectiveCameraComponent" not in model + scene + hud + immersive,
    "capillary_flow_to_exchange_story": all(token in scene + model + medical_canon for token in [
        "capillary-flow-front-arrowhead", "capillary-flow-front-tail",
        "flowRideCapillaryExchangeRipples", "exchange_ripples=6",
        "frontal-capillary-exchange-ripple-not-diffusion-measurement-",
        "capillary-to-tissue-exchange-wave", "The red cell and arrow fronts remain intravascular",
        "Red cells stay inside this capillary bed while oxygen passes toward nearby tissue.",
        "The soft rings show that exchange conceptually",
        "oxygen moves from blood toward tissue by diffusion",
    ]) and "oxygen concentration measurement" not in scene + model,
}

failed = [name for name, passed in checks.items() if not passed]
for name, passed in checks.items():
    print(f"{name}|{'PASS' if passed else 'FAIL'}")

if failed:
    print("RBC_JOURNEY_CONTRACT=FAIL|" + ",".join(failed))
    sys.exit(1)

print("RBC_JOURNEY_CONTRACT=PASS")
