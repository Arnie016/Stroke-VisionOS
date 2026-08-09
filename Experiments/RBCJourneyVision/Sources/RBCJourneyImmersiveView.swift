import RealityKit
import SwiftUI

struct RBCJourneyImmersiveView: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
    @Environment(\.openWindow) private var openWindow
    @State private var scene = RBCJourneyScene()
    @State private var handGestures = RBCPortalGestureController()
    @State private var familyNarrator = RBCFamilyNarrationEngine()

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            RealityView { content, attachments in
                await scene.build()
                if model.experienceMode == .entryPrelude {
                    scene.prepareForPrelude(model.entryPreludeChapter)
                }
                content.add(scene.root)
                scene.installFrameUpdates()

                if let infoHUD = attachments.entity(for: "journeyInfo") {
                    scene.attachInfo(infoHUD)
                }
                if let controlsHUD = attachments.entity(for: "journeyControls") {
                    scene.attachControls(controlsHUD)
                }
                if let regionReel = attachments.entity(for: "regionPortalReel") {
                    scene.attachRegionReel(regionReel)
                }
                for landmark in BrainOrientationLandmark.allCases {
                    if let label = attachments.entity(for: landmark.attachmentID) {
                        scene.attachLandmark(label, landmark: landmark)
                    }
                }

                await scene.installSpatialAudio()
                model.isSceneReady = true
            } update: { _, _ in
                // The make closure can run before root.scene is populated.
                // Retry here once the entity belongs to RealityKit's Scene.
                scene.installFrameUpdates()
                model.systemReduceMotion = accessibilityReduceMotion
                scene.update(
                    station: model.station,
                    preludeChapter: model.experienceMode == .entryPrelude ? model.entryPreludeChapter : nil,
                    exhibitBeat: model.experienceMode == .wondrousJourney ? model.exhibitBeat : nil,
                    openPortalIDs: model.openPortalIDs,
                    focusedPortalID: model.focusedPortalID,
                    transferredPortalID: model.transferredPortalID,
                    regionVisualization: model.regionVisualization,
                    frontalClotScenarioActive: model.isFrontalClotScenarioActive,
                    flowRideActive: model.isFlowRideActive,
                    flowRideRoute: model.flowRideRoute,
                    capillaryFieldFocused: model.isCapillaryFieldFocused,
                    time: timeline.date.timeIntervalSinceReferenceDate,
                    paused: model.isPaused,
                    reducedMotion: model.effectiveReducedMotion,
                    soundEnabled: model.soundEnabled,
                    showTeachingPoints: model.showTeachingPoints
                )
            } attachments: {
                Attachment(id: "journeyInfo") {
                    if model.experienceMode == .entryPrelude {
                        RBCEntryPreludeHUD()
                            .environment(model)
                    } else if model.experienceMode == .wondrousJourney {
                        RBCExhibitInfoHUD()
                            .environment(model)
                    } else if model.experienceMode == .regionAtlas {
                        RBCRegionInfoHUD()
                            .environment(model)
                    } else {
                        RBCJourneyInfoHUD()
                            .environment(model)
                    }
                }
                Attachment(id: "journeyControls") {
                    if model.experienceMode == .openAtlas {
                        RBCJourneyControlsHUD()
                            .environment(model)
                    }
                }
                Attachment(id: "regionPortalReel") {
                    if model.experienceMode == .wondrousJourney
                        || (model.experienceMode == .regionAtlas && !model.isFlowRideActive) {
                        RBCRegionPortalReelHUD()
                            .environment(model)
                    }
                }
                ForEach(BrainOrientationLandmark.allCases) { landmark in
                    Attachment(id: landmark.attachmentID) {
                        BrainOrientationLandmarkHUD(landmark: landmark)
                    }
                }
            }
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        if scene.isCapillaryFocusTarget(value.entity) {
                            model.toggleCapillaryFieldFocus()
                        } else if scene.isFrontalClotTarget(value.entity) {
                            model.toggleFrontalClotScenario()
                        } else if let portalID = scene.portalID(for: value.entity) {
                            model.focusPortal(portalID)
                        } else if let regionID = scene.brainRegionID(for: value.entity) {
                            model.activateRegionDiscovery(regionID)
                        }
                    }
            )
        }
        .task {
            await handGestures.start(model: model)
            model.familyNarrationConfigured = familyNarrator.isConfigured
            if model.familyNarrationEnabled && familyNarrator.isConfigured {
                familyNarrator.speakExactCaption(model.familyNarrationText)
            }
        }
        .task(id: model.familyNarrationSequenceKey) {
            guard model.isFlowRideActive,
                  model.familyNarrationEnabled,
                  !model.familyNarrationProofLocked
            else { return }

            model.setFamilyNarrationMoment(.orientation)
            let automaticMoments: [RBCFamilyNarrationMoment] = model.flowRideRoute == .frontal
                ? [.passage]
                : [.passage, .arrival]
            for moment in automaticMoments {
                var remainingSeconds = model.familyNarrationCue.minimumDwellSeconds
                while remainingSeconds > 0
                    || familyNarrator.state == .loading
                    || familyNarrator.state == .speaking {
                    try? await Task.sleep(for: .milliseconds(250))
                    guard !Task.isCancelled,
                          model.isFlowRideActive,
                          model.familyNarrationEnabled
                    else { return }
                    if !model.isPaused {
                        remainingSeconds -= 0.25
                    }
                }
                model.setFamilyNarrationMoment(moment)
            }
        }
        .onChange(of: model.familyNarrationReplayRun) { _, _ in
            if model.familyNarrationEnabled && familyNarrator.isConfigured {
                familyNarrator.speakExactCaption(model.familyNarrationText)
            }
        }
        .onChange(of: model.familyNarrationEnabled) { _, enabled in
            if enabled && familyNarrator.isConfigured {
                familyNarrator.speakExactCaption(model.familyNarrationText)
            } else {
                familyNarrator.stop()
            }
        }
        .onChange(of: model.familyNarrationText) { _, text in
            if model.familyNarrationEnabled && familyNarrator.isConfigured && !text.isEmpty {
                familyNarrator.speakExactCaption(text)
            } else if text.isEmpty {
                familyNarrator.stop()
            }
        }
        .onChange(of: model.isPaused) { _, paused in
            familyNarrator.setPaused(paused)
        }
        .onDisappear {
            handGestures.stop()
            familyNarrator.stop()
            model.isPresented = false
            model.isSceneReady = false
            scene.stopAudio()
            openWindow(id: RBCJourneyModel.trailheadID)
        }
    }
}
