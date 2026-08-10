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
        RealityView { content, attachments in
            model.beginSceneLoading()
            content.add(scene.root)
            if let readinessSurface = attachments.entity(for: "sceneReadiness") {
                scene.attachReadinessSurface(readinessSurface, isVisible: true)
            }
            await scene.build()
            if model.experienceMode == .entryPrelude {
                scene.prepareForPrelude(model.entryPreludeChapter)
            }
            // Prime all component types before insertion into the shared
            // RealityKit scene. Live frame mutations begin only after the
            // loaded resources have completed their short warm-up.
            updateScene(time: Date.timeIntervalSinceReferenceDate)

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

            let audioReady = await scene.installSpatialAudio()
            scene.resolveReadinessAfterFirstPresentationFrame { [weak readinessScene = scene] in
                guard let readinessScene else { return }
                model.resolveSceneReadiness(readinessScene.readinessReport(
                    audioReady: audioReady,
                    presentationFrameReady: true
                ))
            }
        } update: { _, attachments in
            if let readinessSurface = attachments.entity(for: "sceneReadiness") {
                scene.attachReadinessSurface(
                    readinessSurface,
                    isVisible: model.sceneReadinessPhase != .ready
                )
            }
            guard scene.isBuildComplete else { return }
            scene.installFrameUpdates()
            updateScene(time: Date.timeIntervalSinceReferenceDate)
        } attachments: {
            Attachment(id: "sceneReadiness") {
                RBCSceneReadinessSurface()
                    .environment(model)
            }
            Attachment(id: "journeyInfo") {
                if model.pendingRegionDestination != nil {
                    RBCRegionTransferHUD()
                        .environment(model)
                } else if model.experienceMode == .entryPrelude {
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
                    || (model.experienceMode == .regionAtlas
                        && !model.isFlowRideActive
                        && !model.isAnteriorGatewayTransitionActive) {
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
                    if scene.isAnteriorPassageGatewayTarget(value.entity) {
                        model.chooseAnteriorDestination(.arterialLumen)
                    } else if scene.isCapillaryFocusTarget(value.entity) {
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
        .task {
            await handGestures.start(model: model)
            model.familyNarrationConfigured = familyNarrator.isConfigured
            familyNarrator.setPaused(model.isPaused)
            if model.familyNarrationEnabled && familyNarrator.isConfigured {
                familyNarrator.speakExactCaption(model.familyNarrationText)
            }
        }
        .task(id: model.regionTransferSequenceKey) {
            guard let destination = model.pendingRegionDestination,
                  model.regionTransferProofProgress == nil,
                  model.anteriorGatewayTransitionProofProgress == nil
            else { return }
            let run = model.regionTransferRun
            try? await Task.sleep(for: .milliseconds(model.regionTransferDurationMilliseconds))
            var narrationWaitMilliseconds = 0
            while model.familyNarrationEnabled,
                  familyNarrator.isConfigured,
                  familyNarrator.shouldDuckAmbientAudio,
                  narrationWaitMilliseconds < model.regionTransferNarrationWaitLimitMilliseconds {
                try? await Task.sleep(for: .milliseconds(250))
                narrationWaitMilliseconds += 250
                guard !Task.isCancelled,
                      model.regionTransferRun == run,
                      model.pendingRegionDestination == destination
                else { return }
            }
            guard !Task.isCancelled,
                  model.regionTransferRun == run,
                  model.pendingRegionDestination == destination
            else { return }
            model.completePendingRegionTransfer()
        }
        .task(id: model.guidedFlowTourSequenceKey) {
            guard model.isGuidedFlowTourPlaying,
                  !model.familyNarrationProofLocked
            else { return }

            while model.isGuidedFlowTourPlaying {
                let heldPhase = model.guidedFlowTourPhase
                var remainingSeconds = model.familyNarrationCue.minimumDwellSeconds
                while remainingSeconds > 0
                    || familyNarrator.state == .loading
                    || familyNarrator.state == .speaking {
                    try? await Task.sleep(for: .milliseconds(250))
                    guard !Task.isCancelled,
                          model.isGuidedFlowTourPlaying,
                          model.guidedFlowTourPhase == heldPhase
                    else { return }
                    if !model.isPaused {
                        remainingSeconds -= 0.25
                    }
                }
                model.advanceGuidedFlowTour()
            }
        }
        .task(id: model.familyNarrationSequenceKey) {
            guard model.isFlowRideActive,
                  model.familyNarrationEnabled,
                  !model.isGuidedFlowTourActive,
                  !model.familyNarrationProofLocked
            else { return }

            model.setFamilyNarrationMoment(.orientation)
            let automaticMoments: [RBCFamilyNarrationMoment] = model.flowRideRoute == .frontal
                ? [.passage]
                : [.passage, .arrival]
            for moment in automaticMoments {
                var remainingSeconds = model.familyNarrationCue.minimumDwellSeconds
                while remainingSeconds > 0
                    || familyNarrator.isBusy {
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
            model.resetSceneReadiness()
            scene.stopAudio()
            openWindow(id: RBCJourneyModel.trailheadID)
        }
    }

    private func updateScene(time: TimeInterval) {
        model.systemReduceMotion = accessibilityReduceMotion
        scene.update(
            station: model.station,
            preludeChapter: model.experienceMode == .entryPrelude ? model.entryPreludeChapter : nil,
            exhibitBeat: model.experienceMode == .wondrousJourney ? model.exhibitBeat : nil,
            openPortalIDs: model.openPortalIDs,
            focusedPortalID: model.focusedPortalID,
            transferredPortalID: model.transferredPortalID,
            pendingRegionID: model.pendingRegionDestination?.id,
            regionTransferProofProgress: model.regionTransferProofProgress,
            regionVisualization: model.regionVisualization,
            willisRouteFocus: model.willisRouteFocus,
            frontalClotScenarioActive: model.isFrontalClotScenarioActive,
            anteriorPassagePhase: model.anteriorPassagePhase,
            anteriorGatewayTransitionActive: model.isAnteriorGatewayTransitionActive,
            anteriorGatewayTransitionProofProgress: model.anteriorGatewayTransitionProofProgress,
            posteriorVoyagePhase: model.posteriorVoyagePhase,
            flowRideActive: model.isFlowRideActive,
            flowRideRoute: model.flowRideRoute,
            capillaryFieldFocused: model.isCapillaryFieldFocused,
            flowRideProofPhase: model.flowRideProofPhase,
            time: time,
            paused: model.isPaused,
            reducedMotion: model.effectiveReducedMotion,
            soundEnabled: model.soundEnabled,
            narrationDucking: familyNarrator.shouldDuckAmbientAudio,
            showTeachingPoints: model.showTeachingPoints
        )
    }
}
