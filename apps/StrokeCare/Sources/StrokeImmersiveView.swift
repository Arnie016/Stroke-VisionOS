import AVFoundation
import ARKit
import QuartzCore
import RealityKit
import SwiftUI
import UniformTypeIdentifiers
import UIKit

/// A local machine receipt for the placement code path. It deliberately omits
/// the device's raw room transform, gaze, hands, and any patient information.
/// Presence of this file proves only that a tracked device anchor was sampled.
private struct StrokeStagePlacementReceipt: Codable {
    let timestamp: String
    let appVersion: String
    let appBuild: String
    let placementSource: String
    let placementMode: String
    let sampleAttempt: Int
    let anchorTracked: Bool
    let targetForwardDistanceMetres: Float
    let machineEvidence: String
    let wearerEvidence: String
    let clinicalEvidence: String
}

/// Samples the current device pose once, then leaves the teaching stage fixed
/// in the room. This is deliberate initial placement—not continuous head-lock,
/// raw gaze access, or evidence that the wearer finds the distance comfortable.
@MainActor
private final class StrokeStagePlacement: ObservableObject {
    @Published private(set) var transform: Transform?

    private let session = ARKitSession()
    private let worldTracking = WorldTrackingProvider()
    private var placementTask: Task<Void, Never>?

    func start() {
#if targetEnvironment(simulator)
        // The visionOS Simulator does not provide a stable wearer-origin for
        // this room-fixed placement path. Keep deterministic proof routes in
        // the authored frame; physical XCAT builds still sample one tracked
        // device anchor and then leave the stage fixed in the room.
        transform = nil
#else
        placementTask?.cancel()
        placementTask = Task { [weak self] in
            guard let self, WorldTrackingProvider.isSupported else { return }
            do {
                try await session.run([worldTracking])
                for sampleAttempt in 1...30 {
                    guard !Task.isCancelled else { return }
                    if let anchor = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()),
                       anchor.isTracked {
                        transform = Self.makeStageTransform(from: anchor.originFromAnchorTransform)
                        writeMachineReceipt(sampleAttempt: sampleAttempt)
                        return
                    }
                    try await Task.sleep(for: .milliseconds(50))
                }
            } catch {
                // Keep the authored fallback frame if tracking is unavailable.
                // Simulator/build proof must not be reported as device placement.
            }
        }
#endif
    }

    func stop() {
        placementTask?.cancel()
        placementTask = nil
        session.stop()
    }

    private func writeMachineReceipt(sampleAttempt: Int) {
        let receipt = StrokeStagePlacementReceipt(
            timestamp: ISO8601DateFormatter().string(from: Date()),
            appVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown",
            appBuild: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "unknown",
            placementSource: "WorldTrackingProvider.queryDeviceAnchor",
            placementMode: "sample-once-room-fixed",
            sampleAttempt: sampleAttempt,
            anchorTracked: true,
            targetForwardDistanceMetres: abs(SpatialVisualField.primaryAnatomy.z),
            machineEvidence: "PLACEMENT_PATH_RAN",
            wearerEvidence: "NOT_RUN",
            clinicalEvidence: "NOT_RUN"
        )

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let data = try encoder.encode(receipt)
            guard let directory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else { return }
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: nil
            )
            try data.write(
                to: directory.appendingPathComponent("stroke-stage-placement.json"),
                options: .atomic
            )
        } catch {
            // An absent receipt is an explicit machine-evidence failure. The
            // visible experience must not change just to make proof pass.
        }
    }

    private static func makeStageTransform(from device: simd_float4x4) -> Transform {
        let devicePosition = SIMD3<Float>(device.columns.3.x, device.columns.3.y, device.columns.3.z)
        var forward = -SIMD3<Float>(device.columns.2.x, 0, device.columns.2.z)
        if simd_length_squared(forward) < 0.0001 { forward = [0, 0, -1] }
        forward = simd_normalize(forward)
        let yaw = atan2(-forward.x, -forward.z)

        // Existing authored coordinates use eye height ~= 1.62 m. Moving that
        // local eye plane to the sampled device pose keeps every child—case
        // archive, anatomy, annotations, and controls—in one coherent frame.
        let stageOrigin = devicePosition - SIMD3<Float>(0, SpatialVisualField.eyePlaneHeight, 0)
        return Transform(
            scale: .one,
            rotation: simd_quatf(angle: yaw, axis: [0, 1, 0]),
            translation: stageOrigin
        )
    }
}

@MainActor
private final class StrokeNarrationEngine: ObservableObject {
    private static let model = "gpt-realtime-2.1"
    private let playback = StrokeAudioPlayback()
    private var requestTask: Task<Void, Never>?

    func speak(_ text: String) {
        stop()
        guard let endpoint = realtimeProxyEndpoint else { return }

        requestTask = Task { [playback] in
            do {
                var request = URLRequest(url: endpoint)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 25
                request.httpBody = try JSONEncoder().encode(
                    RealtimeNarrationRequest(model: Self.model, text: text)
                )
                let (audio, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                    return
                }
                guard !Task.isCancelled else { return }
                try await playback.playOnce(audio)
            } catch {
                // Deliberately no system speech fallback: the voice is either
                // GPT-Realtime-2.1 or silent with a visible setup state.
            }
        }
    }

    func stop() {
        requestTask?.cancel()
        requestTask = nil
        Task { [playback] in
            await playback.stop()
        }
    }

    var isConfigured: Bool { realtimeProxyEndpoint != nil }

    private var realtimeProxyEndpoint: URL? {
        let environment = ProcessInfo.processInfo.environment["STROKE_REALTIME_PROXY_URL"]
        let bundled = Bundle.main.object(forInfoDictionaryKey: "StrokeRealtimeProxyURL") as? String
        return (environment ?? bundled).flatMap(URL.init(string:))
    }
}

private struct RealtimeNarrationRequest: Encodable {
    let model: String
    let text: String
}

/// The room follows a visual-field rule of three.
///
/// PRIMARY_FOVEAL: anatomy, the active vessel focus, and a placed question.
/// SECONDARY_PERIPHERAL: case context and role controls that remain glanceable.
/// TERTIARY_ATMOSPHERE: a quiet meaning cue and low-motion horizon in depth.
///
/// The vertical grammar is equally stable: top explains, middle demonstrates,
/// and the lower companion surface acts. Safety, consent, and exit controls
/// remain on the readable companion surface, never in peripheral vision alone.
private enum SpatialVisualField {
    static let eyePlaneHeight: Float = 1.62
    static let primaryAnatomy: SIMD3<Float> = [0.00, 1.62, -1.16]
    static let primaryVesselFocus: SIMD3<Float> = [0.00, 1.61, -0.76]
    // Keep the selected-point card in the same secondary field as its 3D
    // reference, but inset it enough that it remains readable rather than
    // falling off the far edge of the wearer's view.
    static let secondaryCaseDrawer: SIMD3<Float> = [0.44, 1.49, -0.84]
    static let tertiaryHorizon: SIMD3<Float> = [0.10, 1.64, -1.72]

    // The shared anatomy is the spatial hero. A modestly larger base scale
    // fills the primary field without pulling it into the left conversation
    // surface or the lower family controls.
    static let primaryScale: Float = 2.34
    static let orientScale: Float = 2.18
    static let secondaryScale: Float = 0.62
    static let tertiaryScale: Float = 0.92
}

/// Imported USDZ anatomy can arrive noticeably after the immersive room.
/// This boundary is intentionally descriptive rather than a fake progress
/// meter, so an empty room never masquerades as a frozen family experience.
private struct StrokeSceneReadinessOverlay: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
                .tint(.orange)
            Text("Preparing the 3D teaching model")
                .font(.headline.weight(.semibold))
            Text("The brain, vessel paths, and discovery points will appear together.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 22)
        .frame(width: 360)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.16)))
        .shadow(color: .black.opacity(0.32), radius: 18, y: 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Preparing the 3D teaching model. The brain, vessel paths, and discovery points will appear together.")
    }
}

struct StrokeImmersiveView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(RBCJourneyModel.self) private var internalJourney
    @Binding var immersionStyle: ImmersionStyle
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var flowController: AudioPlaybackController?
    @State private var pressureController: AudioPlaybackController?
    @State private var previousDragTranslation = CGSize.zero
    @State private var previousMagnification = 1.0
    @State private var isSceneReady = false
    @State private var detailedSceneLoadTask: Task<Void, Never>?
    @StateObject private var narrator = StrokeNarrationEngine()
    @StateObject private var stagePlacement = StrokeStagePlacement()

    private let annotationID = "stroke-intention-annotation"
    private let annotationAnchorName = "stroke-intention-annotation-anchor"
    private let calmHorizonID = "stroke-calm-paper-horizon"
    private let focusLightID = "stroke-focus-key-light"
    private let focusRimLightID = "stroke-focus-rim-light"
    private let surroundingsRevealLightID = "stroke-surroundings-anatomy-reveal-light"
    private let questionMarkerID = "family-question-marker"
    private let caseDrawerID = "spatial-patient-drawer"
    private let lessonSpecimenRailID = "lesson-specimen-rail"
    private let cabinetLabelID = "spatial-case-cabinet-label"
    private let dockLabelID = "spatial-case-dock-label"
    private let hierarchySpineID = "spatial-hierarchy-spine"
    private let speechFactID = "spatial-case-fact-speech"
    private let armFactID = "spatial-case-fact-arm"
    private let timeFactID = "spatial-case-fact-time"
    private let questionFactID = "spatial-case-fact-question"
    private let caseReviewActionsID = "spatial-case-review-actions"
    private let caseHistoryTimelineID = "spatial-case-history-timeline"
    private let teachingTimelineID = "spatial-teaching-timeline"
    private let viewpointControlID = "spatial-viewpoint-control"
    private let roleMicroCuesID = "spatial-role-micro-cues"
    private let familyBrainAtlasID = "spatial-family-brain-atlas"
    private let teachingImagingDrawerID = "spatial-teaching-imaging-drawer"
    private let spatialImagingPlateID = "spatial-clinician-imaging-plate"
    private let spatialImagingComparisonPlateID = "spatial-clinician-imaging-comparison-plate"
    private let spatialAnnotationIDs = [
        "spatial-clinician-pinned-note-0",
        "spatial-clinician-pinned-note-1",
        "spatial-clinician-pinned-note-2"
    ]
    private let spatialInkSurfaceID = "spatial-clinician-ink-surface"
    private let scholarReferenceRailID = "spatial-scholar-reference-rail"
    private let familyControlsID = "spatial-family-controls"
    private let presenterControlsID = "spatial-presenter-controls"
    private let clinicianToolWheelID = "clinician-hand-tool-wheel"
    private let clinicianToolInspectionLabelID = "clinician-device-inspection-label"
    private let accessLayerStudyControlsID = "access-layer-study-controls"
    private let referenceWorkspaceID = "focused-reference-workspace"
    private let clinicianToolWheelAnchorName = "clinician-left-palm-tool-anchor"
    private let clinicianHeldToolAnchorName = "clinician-right-palm-tool-anchor"
    private let stageRootName = "stroke-world-locked-stage"

    @ViewBuilder
    var body: some View {
        if experience.internalBrainModeActive {
            RBCJourneyImmersiveView(
                returnToStrokeCare: returnFromInternalBrainLesson
            )
            .onAppear {
                if experience.familyAtlasCerebellumJourneyRequested {
                    // This is an intentional, atlas-owned entry. The
                    // dedicated interior scene is richer than the one
                    // combined outer mesh, but remains a generic reference.
                    internalJourney.isPresented = true
                    internalJourney.enterRegion(.cerebellum)
                    // The observatory opens on its richer folds-and-arbor
                    // reading, rather than the intentionally faint location
                    // outline. Flow remains a conscious second choice.
                    internalJourney.selectRegionVisualization(.xray)
                } else if CommandLine.arguments.contains("--proof-family-blockage-interior") ||
                            CommandLine.arguments.contains("--proof-family-blockage-return") {
                    internalJourney.startContextualBlockageLesson()
                    if CommandLine.arguments.contains("--proof-family-blockage-return") {
                        // Automation-only receipt: allow the actual interior
                        // scene to open, then invoke the same handler that the
                        // visible Return to Stroke Care action uses.
                        Task { @MainActor in
                            try? await Task.sleep(for: .milliseconds(1_500))
                            guard experience.internalBrainModeActive else { return }
                            returnFromInternalBrainLesson()
                        }
                    }
                } else if CommandLine.arguments.contains("--proof-integrated-cortex") {
                    internalJourney.prepareIntegratedCortexProof(mode: .xray, layerFocus: 3)
                } else if CommandLine.arguments.contains("--proof-integrated-cortex-flow") {
                    internalJourney.prepareIntegratedCortexProof(mode: .flow)
                }
            }
        } else {
            exteriorExperience
        }
    }

    /// One exit keeps the interior experience reversible for both the visible
    /// action and its deterministic receipt. A stopped generic flow ride must
    /// not leak into the next non-vessel interior visit.
    private func returnFromInternalBrainLesson() {
        if internalJourney.isFlowRideActive {
            internalJourney.stopFlowRide()
        }
        internalJourney.isPresented = false
        experience.returnToExteriorLessonContext()
    }

    private var exteriorExperience: some View {
        TimelineView(.animation(
            minimumInterval: 1.0 / 60.0,
            paused: experience.spatialPhase != .explanation
        )) { timeline in
            RealityView { content, attachments in
                    let stageRoot = Entity()
                    stageRoot.name = stageRootName
                    if let transform = stagePlacement.transform {
                        stageRoot.transform = transform
                    }
                    content.add(stageRoot)

                    // A compact, local procedural assembly gets the immersive
                    // room on-screen immediately. The audited USDZ anatomy is
                    // then loaded off the initial presentation path and swaps
                    // in as one complete root, rather than leaving a bare room
                    // while twenty-two resources are decoded.
                    let root = await StrokeSceneFactory.makeScene(compact: true)
                    stageRoot.addChild(root)
                    stageRoot.addChild(StrokeMedicationExhibit.makeRoot())
                    // The compact root intentionally lacks optional USDZ
                    // references. It is a loading placeholder, not an
                    // availability verdict: preserve a preselected Internal,
                    // Vessels, or Surface focus until the detailed root below
                    // resolves the actual registered hierarchy.
                    experience.beginAnatomyAvailabilityCheck()
                    await installSpatialAudio(on: root)

                    detailedSceneLoadTask?.cancel()
                    detailedSceneLoadTask = Task { @MainActor in
                        let detailedRoot = await StrokeSceneFactory.makeScene()
                        guard !Task.isCancelled else { return }
                        root.removeFromParent()
                        stageRoot.addChild(detailedRoot)
                        // The detailed scene arrives after the proof route may
                        // already have selected an anatomy point. Move the
                        // dormant secondary reference out of the hero root
                        // before its first visibility update, otherwise it
                        // inherits room-scale brain magnification for one
                        // frame and can fill the wearer’s view.
                        if let miniature = detailedRoot.findEntity(
                            named: StrokeSceneFactory.registeredTeachingImagingRootName
                        ) {
                            miniature.removeFromParent()
                            stageRoot.addChild(miniature)
                            miniature.position = StrokeSceneFactory.registeredTeachingImagingSuggestedStagePosition
                            let miniatureScale = StrokeSceneFactory.registeredTeachingImagingSuggestedStageScale
                            miniature.scale = [miniatureScale, miniatureScale, miniatureScale]
                            StrokeSceneFactory.updateRegisteredTeachingImaging(
                                root: stageRoot,
                                isVisible: experience.spatialPhase == .explanation
                                    && experience.teachingImagingDrawerVisible,
                                lens: experience.teachingImagingLens,
                                selectedPointLabel: experience.selectedPointLabel,
                                emphasizeNeuronSignalPath: experience.isSelectedNeuronSignalTraceActive,
                                emphasizeSurfacePoint: experience.isSelectedSurfacePlainWordsFocusActive,
                                emphasizeInternalVentricles: experience.isSelectedInternalPlainWordsFocusActive,
                                time: 0,
                                isPaused: experience.requestedPause || reduceMotion
                            )
                        }
                        experience.updateAvailableAnatomyFocuses(
                            StrokeSceneFactory.availableAnatomyFocuses(in: detailedRoot)
                        )
                        experience.resolveAccessLayerStudyAvailability(
                            StrokeSceneFactory.accessLayerStudyAvailable(in: detailedRoot),
                            viewingOrbit: StrokeSceneFactory.accessLayerStudyViewingOrbit(in: detailedRoot)
                        )
                        await installSpatialAudio(on: detailedRoot)
                        isSceneReady = true
                    }

                    let caseRoom = await StrokeSceneFactory.makeSpatialCaseIntake()
                    stageRoot.addChild(caseRoom)

                    let handProof = [
                        "--proof-clinician-toolkit",
                        "--proof-clinician-toolkit-full",
                        "--proof-clinician-toolkit-motion"
                    ].contains { CommandLine.arguments.contains($0) }
                    let toolWheelAnchor = Entity()
                    toolWheelAnchor.name = clinicianToolWheelAnchorName
                    if handProof {
                        toolWheelAnchor.position = [-0.61, 1.76, -0.74]
                    } else {
                        toolWheelAnchor.components.set(AnchoringComponent(
                            .hand(.left, location: .palm),
                            trackingMode: .predicted
                        ))
                    }
                    if let toolWheel = attachments.entity(for: clinicianToolWheelID) {
                        toolWheelAnchor.addChild(toolWheel)
                    }
                    content.add(toolWheelAnchor)

                    let heldToolAnchor = Entity()
                    heldToolAnchor.name = clinicianHeldToolAnchorName
                    if handProof {
                        heldToolAnchor.position = [0.48, 1.68, -0.72]
                    } else {
                        heldToolAnchor.components.set(AnchoringComponent(
                            .hand(.right, location: .palm),
                            trackingMode: .predicted
                        ))
                    }
                    let heldTools = await StrokeSceneFactory.makeClinicianHeldTools()
                    heldToolAnchor.addChild(heldTools)
                    content.add(heldToolAnchor)

                    // The authored catheter geometry is close to plausible
                    // physical thickness and becomes nearly invisible at a
                    // comfortable viewing distance. Reuse the exact same PBR
                    // entities in an explicitly magnified study above the
                    // anatomy. This is an inspection copy, not a second tool,
                    // sizing reference, or procedure simulation.
                    let inspectionTools = heldTools.clone(recursive: true)
                    inspectionTools.name = StrokeSceneFactory.clinicianToolInspectionRootName
                    StrokeSceneFactory.enhanceClinicianToolInspection(inspectionTools)
                    inspectionTools.components.set(
                        StrokeClinicianDeviceInspectionTargetComponent()
                    )
                    inspectionTools.components.set(InputTargetComponent(
                        allowedInputTypes: [.direct, .indirect]
                    ))
                    inspectionTools.components.set(CollisionComponent(shapes: [
                        .generateBox(size: [0.19, 0.045, 0.045])
                    ]))
                    inspectionTools.components.set(HoverEffectComponent())
                    inspectionTools.isEnabled = false
                    stageRoot.addChild(inspectionTools)

                    let horizon = CalmFlowFieldFactory.makeHorizon()
                    horizon.name = calmHorizonID
                    horizon.position = SpatialVisualField.tertiaryHorizon
                    horizon.scale = [SpatialVisualField.tertiaryScale, SpatialVisualField.tertiaryScale, 1]
                    horizon.isEnabled = experience.environmentMode == .warmHorizon
                    stageRoot.addChild(horizon)

                    let focusLight = Entity()
                    focusLight.name = focusLightID
                    focusLight.components.set(DirectionalLightComponent(
                        color: UIColor(red: 1.0, green: 0.84, blue: 0.72, alpha: 1),
                        // The black Focus field needs enough physical key light
                        // to reveal the authored PBR folds and internal forms.
                        // This remains a calm presentation light, not a claim
                        // about surgical illumination or tissue appearance.
                        intensity: 2_800
                    ))
                    // Aim close to the wearer's forward view. The former steep
                    // side angle left the dark PBR internal meshes almost
                    // unreadable in the black Focus field on Simulator.
                    focusLight.orientation = simd_quatf(angle: -0.08, axis: [1, 0, 0])
                    // The warm museum field still needs a sculpting key light;
                    // otherwise the high-density cortex reads like flat clay.
                    // Passthrough keeps this off so room lighting remains honest.
                    focusLight.isEnabled = experience.environmentMode != .surroundings
                    stageRoot.addChild(focusLight)

                    // A restrained cool rim separates the full registered
                    // brain and arterial tree from the Black focus field. It
                    // increases legibility of the authored PBR folds without
                    // simulating tissue, blood, or surgical illumination.
                    let focusRimLight = Entity()
                    focusRimLight.name = focusRimLightID
                    focusRimLight.components.set(DirectionalLightComponent(
                        color: UIColor(red: 0.62, green: 0.86, blue: 1.0, alpha: 1),
                        intensity: 760
                    ))
                    focusRimLight.orientation = simd_quatf(
                        angle: 0.64,
                        axis: simd_normalize(SIMD3<Float>(0.18, 0.92, -0.34))
                    )
                    focusRimLight.isEnabled = experience.environmentMode == .focusField
                    stageRoot.addChild(focusRimLight)

                    // Passthrough can otherwise flatten the authored PBR
                    // cortex into a pastel silhouette. A low, neutral reveal
                    // light keeps the sulci and arterial relief readable in
                    // the opening room without presenting the generic teaching
                    // model as a patient scan or surgical field.
                    let surroundingsRevealLight = Entity()
                    surroundingsRevealLight.name = surroundingsRevealLightID
                    surroundingsRevealLight.components.set(DirectionalLightComponent(
                        color: UIColor(red: 0.82, green: 0.91, blue: 1.0, alpha: 1),
                        intensity: 1_050
                    ))
                    surroundingsRevealLight.orientation = simd_quatf(
                        angle: 0.58,
                        axis: simd_normalize(SIMD3<Float>(-0.32, 0.86, 0.40))
                    )
                    surroundingsRevealLight.isEnabled = experience.environmentMode == .surroundings
                    stageRoot.addChild(surroundingsRevealLight)

                    if let annotation = attachments.entity(for: annotationID) {
                        annotation.name = annotationID
                        annotation.components.set(BillboardComponent())
                        let annotationAnchor = Entity()
                        annotationAnchor.name = annotationAnchorName
                        annotationAnchor.addChild(annotation)
                        stageRoot.addChild(annotationAnchor)

                    }

                    if let marker = attachments.entity(for: questionMarkerID) {
                        marker.name = questionMarkerID
                        marker.components.set(BillboardComponent())
                        stageRoot.addChild(marker)
                    }

                    if let drawer = attachments.entity(for: caseDrawerID) {
                        drawer.name = caseDrawerID
                        drawer.components.set(BillboardComponent())
                        stageRoot.addChild(drawer)
                    }

                    if let rail = attachments.entity(for: lessonSpecimenRailID) {
                        rail.name = lessonSpecimenRailID
                        rail.components.set(BillboardComponent())
                        stageRoot.addChild(rail)
                    }

                    for id in [
                        cabinetLabelID, dockLabelID, hierarchySpineID,
                        speechFactID, armFactID, timeFactID, questionFactID, caseReviewActionsID,
                        caseHistoryTimelineID,
                        teachingTimelineID, viewpointControlID, roleMicroCuesID,
                        familyBrainAtlasID, teachingImagingDrawerID,
                        spatialImagingPlateID, spatialImagingComparisonPlateID,
                        spatialAnnotationIDs[0], spatialAnnotationIDs[1], spatialAnnotationIDs[2],
                        spatialInkSurfaceID,
                        scholarReferenceRailID,
                        familyControlsID, presenterControlsID
                    ] {
                        if let attachment = attachments.entity(for: id) {
                            attachment.name = id
                            attachment.components.set(BillboardComponent())
                            stageRoot.addChild(attachment)
                        }
                    }

                } update: { content, attachments in
                    guard
                        let stageRoot = content.entities.first(where: { $0.name == stageRootName }),
                        let root = stageRoot.findEntity(named: StrokeSceneFactory.rootName)
                    else {
                        return
                    }
                    if let transform = stagePlacement.transform {
                        stageRoot.transform = transform
                    }

                    let now = timeline.date.timeIntervalSinceReferenceDate
                    let anatomyVisible = experience.spatialPhase == .explanation &&
                        experience.focusedReferenceWorkspace == nil && !experience.spatialImagingFocusActive
                    root.isEnabled = anatomyVisible
                    if let medicineRoot = stageRoot.findEntity(named: StrokeMedicationExhibit.rootName) {
                        StrokeMedicationExhibit.update(
                            root: medicineRoot,
                            selectedID: experience.selectedMedicineID,
                            yaw: experience.medicineExhibitYaw,
                            visible: experience.focusedReferenceWorkspace == .medications
                        )
                    }
                    if anatomyVisible {
                        // Patient-file browsing and case review are driven by
                        // explicit state changes. Do not mutate the hidden,
                        // high-density anatomy tree while those rooms are idle.
                        StrokeSceneFactory.update(
                            root: root,
                            experience: experience,
                            time: now,
                            reduceMotion: reduceMotion
                        )
                    }

                    // Keep the secondary registered teaching object world-
                    // locked. Reparenting it out of the hero root prevents the
                    // user's anatomy orbit/zoom gesture from dragging the
                    // reference lens through the room. Only one leaf-only lens
                    // is enabled, so the full head assembly is never doubled.
                    if let miniature = stageRoot.findEntity(
                        named: StrokeSceneFactory.registeredTeachingImagingRootName
                    ) {
                        if miniature.parent !== stageRoot {
                            miniature.removeFromParent()
                            stageRoot.addChild(miniature)
                        }
                        let referenceX = teachingReferenceSideX(
                            anatomyRoot: root,
                            stageRoot: stageRoot
                        ) * abs(StrokeSceneFactory.registeredTeachingImagingSuggestedStagePosition.x)
                        miniature.position = [
                            referenceX,
                            StrokeSceneFactory.registeredTeachingImagingSuggestedStagePosition.y,
                            StrokeSceneFactory.registeredTeachingImagingSuggestedStagePosition.z
                        ]
                        let miniatureScale = StrokeSceneFactory.registeredTeachingImagingSuggestedStageScale
                        miniature.scale = [miniatureScale, miniatureScale, miniatureScale]
                        StrokeSceneFactory.updateRegisteredTeachingImaging(
                            root: stageRoot,
                            isVisible: experience.spatialPhase == .explanation
                                && experience.focusedReferenceWorkspace == nil
                                && experience.teachingImagingDrawerVisible,
                            lens: experience.teachingImagingLens,
                            selectedPointLabel: experience.selectedPointLabel,
                            emphasizeNeuronSignalPath: experience.isSelectedNeuronSignalTraceActive,
                            emphasizeSurfacePoint: experience.isSelectedSurfacePlainWordsFocusActive,
                            emphasizeInternalVentricles: experience.isSelectedInternalPlainWordsFocusActive,
                            time: now,
                            isPaused: experience.requestedPause || reduceMotion
                        )
                    }

                    // Ported from the proven Heart Field interaction engine:
                    // state-owned orbit/zoom, smoothed presentation, entity-
                    // anchored SwiftUI annotation, cheap RealityKit targets.
                    // Gesture values arrive continuously; keep them local to
                    // the RealityView update so SwiftUI state is never mutated
                    // during rendering. That avoids a 60 Hz runtime warning.
                    let smoothedOrbit = experience.orbit
                    let smoothedZoom = Float(experience.spatialZoom)

                    if let caseRoom = stageRoot.findEntity(named: StrokeSceneFactory.spatialCaseRoomName) {
                        caseRoom.isEnabled = experience.spatialPhase != .explanation
                        let inLibrary = experience.spatialPhase == .caseLibrary
                        let inReview = experience.spatialPhase == .caseReview
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseArchiveName)?.isEnabled = inLibrary
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseConstellationName)?.isEnabled = inReview
                        // Keep the case-history constellation, but retire the
                        // procedural bust placeholder. The selected dossier
                        // and its connected facts are the spatial case until a
                        // reviewed fictional-person asset exists.
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFigureName)?.isEnabled = false
                        StrokeSceneFactory.updateSpatialCaseIntake(
                            root: caseRoom,
                            experience: experience
                        )
                    }
                    if let caseRoom = stageRoot.findEntity(named: StrokeSceneFactory.spatialCaseRoomName),
                       let file = caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFileName) {
                        let inReview = experience.spatialPhase == .caseReview
                        // The twelve dossiers are now the library's real
                        // selection targets. Keep the old oversized carry-file
                        // out of the browsing composition; it returns only for
                        // the selected-case unfold in review.
                        file.isEnabled = inReview
                        let reveal = Float(experience.caseReviewRevealProgress)
                        let lift = min(reveal / 0.34, 1)
                        let dissolveStart: Float = 0.34
                        let dissolveDuration: Float = 0.42
                        let normalizedDissolve = (reveal - dissolveStart) / dissolveDuration
                        let dissolve = min(max(normalizedDissolve, Float(0)), Float(1))
                        file.position = inReview
                            ? simd_mix(
                                SIMD3<Float>(0, 1.43, -0.82),
                                SIMD3<Float>(0, 1.54, -0.78),
                                SIMD3<Float>(repeating: lift)
                            )
                            : experience.spatialCaseFilePosition
                        file.orientation = experience.spatialCaseDocked
                            ? simd_quatf(angle: 0, axis: [0, 1, 0])
                            : simd_quatf(angle: -0.16, axis: [0, 1, 0])
                        let fileScale = inReview ? (1 + 0.12 * lift - 0.46 * dissolve) : 1
                        file.scale = [fileScale, fileScale, fileScale]
                        file.components.set(OpacityComponent(opacity: inReview ? 1 - dissolve : 1))
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseDockName)?.isEnabled = false
                    }

                    // The anatomy owns the centre of the room. The progressive
                    // immersion style lets the Digital Crown expand or soften
                    // the surroundings without another app-specific control.
                    root.position = SpatialVisualField.primaryAnatomy
                    let emphasis: Float = experience.procedureStep == .chooseCase
                        ? SpatialVisualField.orientScale
                        : SpatialVisualField.primaryScale
                    let displayScale = emphasis * smoothedZoom
                    root.scale = [displayScale, displayScale, displayScale]
                    root.orientation = simd_quatf(angle: smoothedOrbit.x, axis: [0, 1, 0])
                        * simd_quatf(angle: smoothedOrbit.y, axis: [1, 0, 0])

                    let imageWorkingMode = experience.audienceLens == .clinician &&
                        experience.spatialImagingPlateVisible
                    if let annotation = attachments.entity(for: annotationID) {
                        let selectedPoint = experience.selectedPointEntityName.flatMap {
                            root.findEntity(named: $0)
                        }
                        // Keep a selected cue spatially related to anatomy but
                        // parent its explanation to the stage. Parenting the
                        // SwiftUI attachment inside the scaled hero hierarchy
                        // multiplies its size as the wearer zooms, eventually
                        // turning a local explanation into an anatomy-blocking
                        // pane. Stage-space placement preserves readable scale.
                        let annotationParent = selectedPoint == nil
                            ? stageRoot.findEntity(named: annotationAnchorName)
                            : stageRoot
                        if let annotationParent, annotation.parent !== annotationParent {
                            annotation.removeFromParent()
                            annotationParent.addChild(annotation)
                        }
                        if let selectedPoint {
                            // Resolve the anatomy point into stage coordinates,
                            // then give the local card breathing room outside
                            // the silhouette. It stays near the selected point
                            // without inheriting hero scale or rotation.
                            let pointPosition = selectedPoint.position(relativeTo: stageRoot)
                            let pointSide: Float = pointPosition.x < 0 ? -1 : 1
                            annotation.position = pointPosition
                                + [0.17 * pointSide, 0.08, 0.20]
                        } else {
                            annotationParent?.position = annotationPosition
                            annotation.position = .zero
                        }
                        // A selected point should reveal a compact local cue,
                        // leaving the primary anatomy and its full 3D teaching
                        // structure visibly dominant.
                        let annotationScale: Float = selectedPoint == nil ? 0.48 : 0.78
                        annotation.scale = [annotationScale, annotationScale, annotationScale]
                        // When the Family Atlas owns the selected chapter, its
                        // left surface already contains the explanation, voice
                        // choice, and reference control. Suppress the duplicate
                        // point card so the hero brain remains unobstructed.
                        let atlasOwnsSelection = experience.audienceLens == .family
                            && experience.familyBrainAtlasVisible
                            && experience.familyBrainAtlasCueChapter != nil
                            && experience.selectedPointEntityName != nil
                        annotation.isEnabled = experience.spatialPhase == .explanation
                            && experience.focusedReferenceWorkspace == nil
                            && !experience.accessLayerStudy.isActive
                            && !imageWorkingMode
                            && !atlasOwnsSelection
                            && !experience.selectedPointNoteIsPinned
                            && (
                                experience.selectedPointEntityName != nil ||
                                (experience.audienceLens == .family && experience.familyDiscoveryHintVisible) ||
                                experience.closingReflectionVisible ||
                                experience.isClinicianScholarSkullInspectionActive
                            )
                        annotation.components.set(BillboardComponent())
                    }
                    if let horizon = stageRoot.findEntity(named: calmHorizonID) {
                        // Environmental mood stays behind the anatomy and is
                        // never attached to a vessel or pathology state.
                        horizon.isEnabled = experience.environmentMode == .warmHorizon
                        horizon.position = SpatialVisualField.tertiaryHorizon
                        horizon.scale = [SpatialVisualField.tertiaryScale, SpatialVisualField.tertiaryScale, 1]
                        CalmFlowFieldFactory.update(
                            horizon,
                            time: now,
                            act: experience.procedureStep,
                            isPaused: experience.requestedPause,
                            reduceMotion: reduceMotion
                        )
                    }
                    stageRoot.findEntity(named: focusLightID)?.isEnabled =
                        experience.environmentMode != .surroundings
                    stageRoot.findEntity(named: focusRimLightID)?.isEnabled =
                        experience.environmentMode == .focusField
                    stageRoot.findEntity(named: surroundingsRevealLightID)?.isEnabled =
                        experience.environmentMode == .surroundings
                    if let marker = attachments.entity(for: questionMarkerID) {
                        if marker.parent == nil {
                            stageRoot.addChild(marker)
                        }
                        marker.position = questionMarkerPosition(in: root, relativeTo: stageRoot)
                        marker.scale = [0.72, 0.72, 0.72]
                        marker.isEnabled = experience.spatialPhase == .explanation &&
                            experience.focusedReferenceWorkspace == nil &&
                            !imageWorkingMode &&
                            experience.questionMarkerVisible
                        marker.components.set(BillboardComponent())
                    }
                    if let drawer = attachments.entity(for: caseDrawerID) {
                        if drawer.parent == nil {
                            stageRoot.addChild(drawer)
                        }
                        // This is the focused dossier's compact briefing, not
                        // persistent furniture. It exists only in the archive
                        // threshold and disappears with the case room.
                        // Keep the archive within the wearer's central working
                        // envelope. The previous lower-left placement made the
                        // portrait rail readable only at the edge of vision.
                        drawer.position = [-0.24, 1.62, -0.72]
                        drawer.scale = [0.90, 0.90, 0.90]
                        drawer.isEnabled = experience.spatialPhase == .caseLibrary
                        drawer.components.set(BillboardComponent())
                    }
                    if let rail = attachments.entity(for: lessonSpecimenRailID) {
                        // The intention callout now owns the selected lesson's
                        // title, meaning, reference action, voice choice, and
                        // close affordance. Keeping the old capsule enabled as
                        // well duplicated the disclosure and inherited the
                        // magnified brain hierarchy, obscuring the anatomy.
                        rail.isEnabled = false
                    }
                    updateSpatialIntakeAttachments(attachments)
                    updateSpatialTeachingAttachments(
                        attachments,
                        anatomyRoot: root,
                        stageRoot: stageRoot
                    )
                    updateSpatialRoleControls(attachments, stageRoot: stageRoot)
                    updateClinicianHandToolKit(
                        content: content,
                        attachments: attachments,
                        time: now
                    )
                    updateAudioMix()
                } attachments: {
                    Attachment(id: annotationID) {
                        StrokeIntentionAnnotation()
                            .environmentObject(experience)
                            .frame(width: 310)
                    }
                    Attachment(id: questionMarkerID) {
                        FamilyQuestionMarker()
                            .environmentObject(experience)
                            .frame(width: 210)
                    }
                    Attachment(id: caseDrawerID) {
                        SpatialPatientDrawer()
                            .environmentObject(experience)
                            .frame(width: 560)
                    }
                    Attachment(id: lessonSpecimenRailID) {
                        LessonSpecimenRail()
                            .environmentObject(experience)
                            .frame(width: 285, height: 74)
                    }
                    Attachment(id: cabinetLabelID) {
                        spatialLabel("PATIENT FILES", systemImage: "cabinet.fill")
                    }
                    Attachment(id: dockLabelID) {
                        spatialLabel("PLACE CASE HERE", systemImage: "arrow.down.circle.fill")
                    }
                    Attachment(id: hierarchySpineID) {
                        SpatialHierarchySpine()
                            .environmentObject(experience)
                    }
                    Attachment(id: speechFactID) {
                        SpatialCaseFact(milestone: .everydayContext)
                            .environmentObject(experience)
                    }
                    Attachment(id: armFactID) {
                        SpatialCaseFact(milestone: .reportedChange)
                            .environmentObject(experience)
                    }
                    Attachment(id: timeFactID) {
                        SpatialCaseFact(milestone: .teamReview)
                            .environmentObject(experience)
                    }
                    Attachment(id: questionFactID) {
                        SpatialCaseFact(milestone: .sharedQuestions)
                            .environmentObject(experience)
                    }
                    Attachment(id: caseReviewActionsID) {
                        SpatialCaseReviewActions()
                            .environmentObject(experience)
                            .frame(width: 420)
                    }
                    Attachment(id: caseHistoryTimelineID) {
                        PatientHistoryTimelineView()
                            .environmentObject(experience)
                            .frame(width: 600, height: 188)
                            .transaction { transaction in
                                if reduceMotion {
                                    transaction.animation = nil
                                    transaction.disablesAnimations = true
                                }
                            }
                    }
                    Attachment(id: teachingTimelineID) {
                        SpatialTeachingTimeline()
                            .environmentObject(experience)
                            .frame(width: 720, height: 154)
                    }
                    Attachment(id: viewpointControlID) {
                        SpatialViewpointDot()
                            .environmentObject(experience)
                            .frame(width: 132, height: 88)
                    }
                    Attachment(id: roleMicroCuesID) {
                        SpatialRoleMicroCues()
                            .environmentObject(experience)
                            .frame(width: 520)
                    }
                    Attachment(id: familyBrainAtlasID) {
                        Group {
                            if experience.familyBrainAtlasDirectSurfaceSelectionActive {
                                SpatialFamilyAtlasSurfaceSelection()
                                    .frame(width: 440)
                            } else {
                                SpatialFamilyBrainAtlas()
                                    .frame(width: 720)
                            }
                        }
                        .environmentObject(experience)
                    }
                    Attachment(id: teachingImagingDrawerID) {
                        StrokeTeachingImagingDrawer()
                            .environmentObject(experience)
                            .frame(width: 400)
                    }
                    Attachment(id: spatialImagingPlateID) {
                        StrokeSpatialImagingPlate()
                            .environmentObject(experience)
                    }
                    Attachment(id: spatialImagingComparisonPlateID) {
                        StrokeSpatialImagingComparisonPlate()
                            .environmentObject(experience)
                            .frame(width: 460, height: 500)
                    }
                    Attachment(id: spatialAnnotationIDs[0]) {
                        StrokePinnedAnnotationSlot(index: 0)
                            .environmentObject(experience)
                            .frame(width: 360, height: 190)
                    }
                    Attachment(id: spatialAnnotationIDs[1]) {
                        StrokePinnedAnnotationSlot(index: 1)
                            .environmentObject(experience)
                            .frame(width: 360, height: 190)
                    }
                    Attachment(id: spatialAnnotationIDs[2]) {
                        StrokePinnedAnnotationSlot(index: 2)
                            .environmentObject(experience)
                            .frame(width: 360, height: 190)
                    }
                    Attachment(id: spatialInkSurfaceID) {
                        StrokeSpatialInkSurface()
                            .environmentObject(experience)
                            .frame(width: 760, height: 520)
                    }
                    Attachment(id: scholarReferenceRailID) {
                        StrokeScholarReferenceRail()
                            .environmentObject(experience)
                            .frame(width: 248)
                    }
                    Attachment(id: familyControlsID) {
                        SpatialRoleControls(role: .family)
                            .environmentObject(experience)
                            .frame(width: 440)
                    }
                    Attachment(id: presenterControlsID) {
                        SpatialRoleControls(role: .clinician)
                            .environmentObject(experience)
                            .frame(width: 470)
                    }
                    Attachment(id: clinicianToolWheelID) {
                        ClinicianHandToolWheel()
                            .environmentObject(experience)
                            .frame(width: 430, height: 460)
                    }
                    Attachment(id: clinicianToolInspectionLabelID) {
                        ClinicianDeviceInspectionLabel()
                            .environmentObject(experience)
                            .frame(width: 390)
                    }
                    Attachment(id: accessLayerStudyControlsID) {
                        StrokeAccessLayerStudyControls()
                            .environmentObject(experience)
                    }
                    Attachment(id: referenceWorkspaceID) {
                        StrokeReferenceWorkspaceView().environmentObject(experience)
                    }
                }
                .highPriorityGesture(
                    SpatialTapGesture()
                        .targetedToEntity(where: .has(StrokeLessonPointTargetComponent.self))
                        .onEnded { value in
                            guard let point = StrokeSceneFactory.pointFieldSelection(for: value.entity) else {
                                return
                            }
                            experience.selectPoint(entityName: point.entityName, label: point.label)
                        },
                    isEnabled: !experience.questionPlacementArmed && !experience.spatialInkVisible
                )
                .simultaneousGesture(
                    SpatialTapGesture()
                        .targetedToEntity(where: .has(StrokeMedicineExhibitTargetComponent.self))
                        .onEnded { value in
                            if let target = value.entity.components[StrokeMedicineExhibitTargetComponent.self] {
                                experience.selectSpatialMedicine(target.medicineID)
                            }
                        }
                )
                .simultaneousGesture(
                    SpatialTapGesture()
                        .targetedToEntity(where: .has(StrokeAccessLayerTargetComponent.self))
                        .onEnded { _ in
                            experience.toggleAccessStudyLayer(reduceMotion: reduceMotion)
                        }
                )
                .simultaneousGesture(
                    SpatialTapGesture()
                        .targetedToEntity(where: .has(
                            StrokeClinicianDeviceInspectionTargetComponent.self
                        ))
                        .onEnded { _ in
                            experience.advanceClinicianDeviceStudyBeat()
                        }
                )
                .simultaneousGesture(
                    SpatialTapGesture()
                        .targetedToAnyEntity()
                        .onEnded { value in
                            guard let index = StrokeSceneFactory.spatialCaseIndex(for: value.entity) else { return }
                            experience.selectFictionalCase(at: index)
                        }
                )
                .gesture(
                    DragGesture(minimumDistance: 3)
                        .targetedToAnyEntity()
                        .onChanged { value in
                            if let target = value.entity.components[StrokeMedicineExhibitTargetComponent.self] {
                                if experience.selectedMedicineID != target.medicineID { experience.selectSpatialMedicine(target.medicineID) }
                                let translation = value.gestureValue.translation
                                experience.rotateSpatialMedicine(by: Float(translation.width - previousDragTranslation.width) * 0.008)
                                previousDragTranslation = translation
                                return
                            }
                            if value.entity.components[StrokeAccessLayerTargetComponent.self] != nil {
                                let scenePoint = value.convert(value.location3D, from: .local, to: .scene)
                                if let context = StrokeSceneFactory.accessLayerDragContext(
                                    for: value.entity, scenePosition: scenePoint
                                ) {
                                    experience.dragAccessStudyLayer(at: context.position, along: context.travel)
                                }
                                return
                            }
                            if StrokeSceneFactory.isSpatialCaseFileTarget(value.entity) {
                                if let index = StrokeSceneFactory.spatialCaseIndex(for: value.entity) {
                                    experience.selectFictionalCase(at: index)
                                }
                                let scenePoint = value.convert(value.location3D, from: .local, to: .scene)
                                let localPoint = spatialCaseRoom(for: value.entity)?.convert(
                                    position: scenePoint,
                                    from: nil
                                ) ?? scenePoint
                                experience.moveSpatialCaseFile(to: localPoint)
                                return
                            }
                            if StrokeSceneFactory.isClinicianDeviceInspectionTarget(value.entity) {
                                let translation = value.gestureValue.translation
                                let delta = CGSize(
                                    width: translation.width - previousDragTranslation.width,
                                    height: translation.height - previousDragTranslation.height
                                )
                                previousDragTranslation = translation
                                experience.rotateClinicianDeviceInspection(delta: delta)
                                return
                            }
                            guard StrokeSceneFactory.isAnatomyInteractionTarget(value.entity) else { return }
                            let translation = value.gestureValue.translation
                            let delta = CGSize(
                                width: translation.width - previousDragTranslation.width,
                                height: translation.height - previousDragTranslation.height
                            )
                            previousDragTranslation = translation
                            experience.rotateSpatialView(delta: delta)
                        }
                        .onEnded { value in
                            experience.finishAccessStudyDrag()
                            if StrokeSceneFactory.isSpatialCaseFileTarget(value.entity) {
                                experience.settleSpatialCaseFile(reduceMotion: reduceMotion)
                            }
                            previousDragTranslation = .zero
                        }
                )
            .simultaneousGesture(
                    MagnifyGesture()
                        .targetedToAnyEntity()
                        .onChanged { value in
                            guard StrokeSceneFactory.isAnatomyInteractionTarget(value.entity) else { return }
                            let ratio = value.magnification / previousMagnification
                            experience.magnifySpatialView(ratio: ratio)
                            previousMagnification = value.magnification
                        }
                        .onEnded { _ in previousMagnification = 1 }
                )
            .simultaneousGesture(
                    SpatialTapGesture()
                        .targetedToAnyEntity()
                        .onEnded { value in
                            let scenePoint = value.convert(
                                value.location3D,
                                from: .local,
                                to: .scene
                            )
                            if experience.questionPlacementArmed {
                                guard
                                    StrokeSceneFactory.isAnatomyInteractionTarget(value.entity),
                                    let root = sceneRoot(for: value.entity)
                                else { return }
                                // Standard visionOS gaze selects the entity;
                                // pinch confirms. The app receives the targeted
                                // 3D hit, not a raw eye-tracking coordinate.
                                let rootLocalPoint = root.convert(position: scenePoint, from: nil)
                                experience.placeQuestionMarker(
                                    at: rootLocalPoint,
                                    target: StrokeSceneFactory.semanticTarget(for: value.entity)
                                )
                            } else if let root = sceneRoot(for: value.entity),
                                      let point = StrokeSceneFactory.nearestVisiblePointFieldSelection(
                                        to: scenePoint,
                                        in: root
                                      ) {
                                experience.selectPoint(entityName: point.entityName, label: point.label)
                            } else if experience.audienceLens == .family,
                                      experience.pointField == .regions,
                                      StrokeSceneFactory.semanticTarget(for: value.entity) == "brain surface",
                                      let root = sceneRoot(for: value.entity),
                                      let surface = StrokeSceneFactory.nearestFamilyAtlasSurfaceSelection(
                                        to: scenePoint,
                                        in: root
                                      ) {
                                // Standard system focus determines the target;
                                // this confirmed pinch maps only to a reviewed
                                // broad generic Atlas context, never a raw-gaze
                                // coordinate or patient-specific label.
                                experience.selectFamilyAtlasSurfaceContext(
                                    atlasPointIndex: surface.atlasPointIndex
                                )
                            } else if StrokeSceneFactory.semanticTarget(for: value.entity) == "blocked vessel" ||
                                StrokeSceneFactory.semanticTarget(for: value.entity) == "affected brain region" {
                                experience.focusOcclusion()
                            } else if let point = StrokeSceneFactory.pointFieldSelection(for: value.entity) {
                                experience.selectPoint(entityName: point.entityName, label: point.label)
                            }
                        }
                )
            .onChange(of: experience.soundEnabled) { _, _ in updateAudioMix() }
            .onChange(of: experience.focusedReferenceWorkspace) { _, workspace in
                if workspace != nil {
                    // Close every legacy WindowGroup instance, including
                    // windows restored by the OS from earlier sessions.
                    dismissWindow(id: StrokeSpace.evidence)
                    dismissWindow(id: StrokeSpace.imaging)
                }
            }
            .onChange(of: experience.spatialImagingPlateVisible) { _, isVisible in
                if isVisible {
                    dismissWindow(id: StrokeSpace.evidence)
                    dismissWindow(id: StrokeSpace.imaging)
                }
            }
            .onAppear {
                // visionOS can restore an ImmersiveSpace before its launch
                // window appears. Keep this deterministic visual route owned
                // by the same state transition so it cannot inherit a prior
                // presentation screen during Simulator proof capture.
                restoreProofRouteIfNeeded()
                if experience.focusedReferenceWorkspace != nil || experience.spatialImagingPlateVisible {
                    dismissWindow(id: StrokeSpace.evidence)
                    dismissWindow(id: StrokeSpace.imaging)
                }
                isSceneReady = false
                stagePlacement.start()
                experience.setNarrationSetupAvailable(narrator.isConfigured)
                synchronizeImmersionStyle()
                synchronizeNarration()
            }
            .onChange(of: experience.environmentMode) { _, _ in
                synchronizeImmersionStyle()
            }
            .onChange(of: experience.narrationEnabled) { _, _ in
                synchronizeNarration()
            }
            .onChange(of: experience.activeFamilyNarrationText) { _, _ in
                synchronizeNarration()
            }
            .onChange(of: experience.procedureStep) { _, _ in
                synchronizeNarration()
            }
            .onChange(of: experience.audienceLens) { _, _ in
                synchronizeNarration()
            }
            .onChange(of: experience.requestedPause) { _, _ in
                updateAudioMix()
                synchronizeNarration()
            }
            .onDisappear {
                isSceneReady = false
                detailedSceneLoadTask?.cancel()
                detailedSceneLoadTask = nil
                stagePlacement.stop()
                narrator.stop()
                flowController?.stop()
                pressureController?.stop()
                StrokeSceneFactory.stopAuthoredBloodflowAnimations()
                experience.isImmersivePresented = false
            }
            .overlay {
                if !isSceneReady {
                    StrokeSceneReadinessOverlay()
                        .transition(.opacity)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    @MainActor
    private func restoreProofRouteIfNeeded() {
        if CommandLine.arguments.contains("--proof-family-neuron-unsure") {
            experience.prepareFamilyNeuronUnsureProof()
            return
        }
        if CommandLine.arguments.contains("--proof-family-neuron-plain-words") {
            experience.prepareFamilyNeuronPlainWordsProof()
            return
        }
        guard CommandLine.arguments.contains("--proof-family-neuron-reference") else { return }
        experience.prepareFamilyNeuronReferenceProof()
    }

    /// GPT-Realtime narration is a family-only teaching aid. Pausing stops the
    /// current request/player; resuming may restart the current authored line.
    private func synchronizeNarration() {
        guard experience.audienceLens == .family,
              experience.narrationEnabled,
              !experience.requestedPause,
              let pointNarration = experience.activeFamilyNarrationText else {
            narrator.stop()
            return
        }
        narrator.speak(pointNarration)
    }

    private var annotationPosition: SIMD3<Float> {
        return switch experience.procedureStep {
        case .chooseCase: [0.25, 1.91, -0.84]
        case .inspectOcclusion: [0.27, 1.91, -0.84]
        case .discussCare: [0.27, 1.91, -0.84]
        }
    }

    private func updateSpatialIntakeAttachments(_ attachments: RealityViewAttachments) {
        let inLibrary = experience.spatialPhase == .caseLibrary
        let inReview = experience.spatialPhase == .caseReview
        let reveal = Float(experience.caseReviewRevealProgress)
        let positions: [(String, SIMD3<Float>, Float, Bool)] = [
            (cabinetLabelID, [-0.64, 1.75, -0.82], 0.72, inLibrary),
            (dockLabelID, [0, 1.16, -0.76], 0.68, inLibrary),
            (hierarchySpineID, [0, 1.96, -0.72], 0.72, inReview && reveal > 0.60),
            (speechFactID, [-0.41, 1.76, -0.74], 0.66, inReview && reveal > 0.62),
            (armFactID, [-0.42, 1.48, -0.74], 0.66, inReview && reveal > 0.68),
            (timeFactID, [0.42, 1.48, -0.74], 0.66, inReview && reveal > 0.74),
            (questionFactID, [0.41, 1.76, -0.74], 0.66, inReview && reveal > 0.80),
            (caseReviewActionsID, [0, 1.58, -0.70], 0.76, inReview && reveal > 0.70),
            (caseHistoryTimelineID, [0, 1.08, -0.68], 0.62, inReview && reveal > 0.84)
        ]
        for (id, position, scale, visible) in positions {
            guard let entity = attachments.entity(for: id) else { continue }
            let selectedMilestone: StrokeCaseHistoryMilestone? = switch id {
            case speechFactID: .everydayContext
            case armFactID: .reportedChange
            case timeFactID: .teamReview
            case questionFactID: .sharedQuestions
            default: nil
            }
            let selected = selectedMilestone == experience.selectedCaseHistoryMilestone
            let resolvedScale = selectedMilestone == nil ? scale : scale * (selected ? 1 : 0.64)
            entity.position = position
            entity.scale = [resolvedScale, resolvedScale, resolvedScale]
            entity.isEnabled = visible
            entity.components.set(OpacityComponent(opacity: visible ? 1 : 0))
            entity.components.set(BillboardComponent())
        }
    }

    /// Keeps the full 3D reference opposite the selected invitation. The point
    /// and its compact explanation remain one local cluster; the reference is
    /// a second object across the hero brain, with no connector line or label
    /// cloud crossing the anatomy.
    private func teachingReferenceSideX(
        anatomyRoot: Entity,
        stageRoot: Entity
    ) -> Float {
        guard let entityName = experience.selectedPointEntityName,
              let point = anatomyRoot.findEntity(named: entityName) else {
            return 1
        }
        return point.position(relativeTo: stageRoot).x < 0 ? 1 : -1
    }

    private func updateSpatialTeachingAttachments(
        _ attachments: RealityViewAttachments,
        anatomyRoot: Entity,
        stageRoot: Entity
    ) {
        let visible = experience.spatialPhase == .explanation && !experience.accessLayerStudy.isActive &&
            experience.focusedReferenceWorkspace == nil
        if let workspace = attachments.entity(for: referenceWorkspaceID) {
            if workspace.parent !== stageRoot { stageRoot.addChild(workspace) }
            workspace.position = [0, 1.62, -0.78]
            workspace.scale = [1.05, 1.05, 1.05]
            workspace.components.set(BillboardComponent())
            workspace.isEnabled = experience.spatialPhase == .explanation &&
                experience.audienceLens == .clinician && experience.focusedReferenceWorkspace != nil
        }
        if let study = attachments.entity(for: accessLayerStudyControlsID) {
            if study.parent !== stageRoot { stageRoot.addChild(study) }
            study.position = [0, 1.36, -0.86]
            study.scale = [0.86, 0.86, 0.86]
            study.components.set(BillboardComponent())
            study.isEnabled = experience.spatialPhase == .explanation &&
                experience.audienceLens == .clinician && experience.accessLayerStudy.isActive
        }
        let isFamily = experience.audienceLens == .family
        // Reading, arranging, or marking an image is a distinct task from
        // navigating the wider presenter experience. Once a clinician brings
        // a plate forward, leave only that plate, its optional comparison, and
        // image-surface controls in the working field. The Done and Back
        // controls live on the plate, so this never creates an interaction
        // trap.
        let placedImagingMode = !isFamily && experience.spatialImagingPlateVisible
        let focusedImagingMode = !isFamily && experience.spatialImagingFocusActive
        let annotationImagingMode = !isFamily && experience.spatialImagingAnnotationEnabled
        let imageWorkingMode = placedImagingMode || focusedImagingMode || annotationImagingMode
        let placements: [(String, SIMD3<Float>, Float)] = [
            // Keep the active chapter comfortably inside the primary field.
            // Inactive chapters collapse to quiet numbered dots below, so the
            // timeline reads as orientation rather than another toolbar.
            (teachingTimelineID, [0, 1.27, -0.86], isFamily ? 0.80 : 0.82),
            // Family questions are shared content, not a far-peripheral
            // presenter rail. The larger 0.86-scale field makes authored
            // questions and the explicit clarity check legible in a shared
            // conversation while the anatomy remains central and dominant.
            // The family entry cue sits beside the brain and now contains the
            // exterior-orientation context itself. This replaces the old
            // second card at ceiling height without losing the boundary
            // between the whole-brain exhibit and the optional interior
            // journey.
            (roleMicroCuesID, isFamily ? [-0.36, 1.62, -0.88] : [-0.64, 1.67, -0.94],
             isFamily ? 0.86 : 0.98 * Float(experience.presenterPanelScale))
        ]

        let familyPointDisclosureActive = isFamily && experience.selectedPointEntityName != nil
        for (id, position, scale) in placements {
            guard let attachment = attachments.entity(for: id) else { continue }
            attachment.position = position
            attachment.scale = [scale, scale, scale]
            // The family left field has one owner at a time. Explore Next is
            // the chooser; after a point is selected it yields to the compact
            // point explanation instead of remaining as a second glass panel
            // underneath it. Closing the point restores the chooser.
            let familyLeftFieldOccupied = isFamily &&
                (experience.familyBrainAtlasVisible || familyPointDisclosureActive)
            attachment.isEnabled = visible &&
                !imageWorkingMode &&
                !(id == roleMicroCuesID && familyLeftFieldOccupied)
            attachment.components.set(BillboardComponent())
        }

        if let atlas = attachments.entity(for: familyBrainAtlasID) {
            // The Atlas is a readable family-side teaching surface, not a
            // miniature dashboard. Its wider, 1.10-scale reading field gives
            // the ten-chapter swipe journey room for one short explanation at
            // a time while leaving the central registered anatomy as the
            // primary spatial object.
            atlas.position = [-0.40, 1.60, -0.92]
            atlas.scale = [1.10, 1.10, 1.10]
            atlas.isEnabled = visible && isFamily && experience.familyBrainAtlasVisible
            atlas.components.set(BillboardComponent())
        }

        if let viewpoint = attachments.entity(for: viewpointControlID) {
            viewpoint.position = [0.52, 1.18, -0.84]
            viewpoint.scale = [0.72, 0.72, 0.72]
            viewpoint.isEnabled = visible &&
                experience.audienceLens == .clinician &&
                !imageWorkingMode
            viewpoint.components.set(BillboardComponent())
        }

        if let drawer = attachments.entity(for: teachingImagingDrawerID) {
            let drawerX = teachingReferenceSideX(
                anatomyRoot: anatomyRoot,
                stageRoot: stageRoot
            ) * abs(SpatialVisualField.secondaryCaseDrawer.x)
            drawer.position = [
                drawerX,
                SpatialVisualField.secondaryCaseDrawer.y,
                SpatialVisualField.secondaryCaseDrawer.z
            ]
            drawer.scale = [0.88, 0.88, 0.88]
            drawer.isEnabled = visible &&
                !imageWorkingMode &&
                experience.teachingImagingDrawerVisible &&
                experience.selectedTeachingReferenceNeedsDrawer
            drawer.components.set(BillboardComponent())
        }

        if let plate = attachments.entity(for: spatialImagingPlateID) {
            // RealityKit can resolve an attachment after initial scene setup.
            // Mount the current entity as well as updating it, so opening an
            // image later cannot leave a visible-in-state plate off-scene.
            if plate.parent !== stageRoot {
                plate.name = spatialImagingPlateID
                stageRoot.addChild(plate)
            }
            plate.position = experience.spatialImagingPlatePosition
            let plateScale = (experience.spatialImagingFocusActive ? 1.0 : 0.78) * experience.spatialImagingPlateScale
            plate.scale = [plateScale, plateScale, plateScale]
            plate.isEnabled = visible &&
                experience.audienceLens == .clinician &&
                experience.spatialImagingPlateVisible
            plate.components.set(BillboardComponent())
            StrokeImagingInteractionTrace.sceneApplied(
                focused: experience.spatialImagingFocusActive,
                visible: plate.isEnabled
            )
        }

        if let comparisonPlate = attachments.entity(for: spatialImagingComparisonPlateID) {
            if comparisonPlate.parent !== stageRoot {
                comparisonPlate.name = spatialImagingComparisonPlateID
                stageRoot.addChild(comparisonPlate)
            }
            comparisonPlate.position = experience.spatialImagingComparisonPlatePosition
            let comparisonScale = 0.78 * experience.spatialImagingComparisonPlateScale
            comparisonPlate.scale = [comparisonScale, comparisonScale, comparisonScale]
            comparisonPlate.isEnabled = visible &&
                experience.audienceLens == .clinician &&
                experience.spatialImagingComparisonDetached &&
                experience.spatialImagingLocalComparisonImageData != nil
            comparisonPlate.components.set(BillboardComponent())
        }

        for (index, id) in spatialAnnotationIDs.enumerated() {
            guard let noteEntity = attachments.entity(for: id) else { continue }
            if experience.spatialAnnotations.indices.contains(index) {
                let note = experience.spatialAnnotations[index]
                let isSelectedPointNote = experience.selectedPointEntityName.map {
                    $0 == note.sourceEntityName
                } ?? false
                // A placed study quiets the free document layer, but it must
                // not erase the one annotation that explains the point the
                // clinician deliberately selected. Keep that compact note on
                // the side opposite the image, so the brain remains visible
                // between point, note, and teaching reference.
                let noteSharesImageWorkField = imageWorkingMode && isSelectedPointNote
                if noteSharesImageWorkField {
                    let noteX: Float = experience.spatialImagingPlatePosition.x >= 0 ? -0.62 : 0.62
                    noteEntity.position = [noteX, 1.42, -0.90]
                    noteEntity.scale = [0.70, 0.70, 0.70]
                } else {
                    noteEntity.position = note.position
                    noteEntity.scale = [0.78, 0.78, 0.78]
                }
                let annotationVisibleBesideStudy = !imageWorkingMode || isSelectedPointNote
                noteEntity.isEnabled = visible &&
                    experience.audienceLens == .clinician &&
                    annotationVisibleBesideStudy
                noteEntity.components.set(BillboardComponent())
            } else {
                noteEntity.isEnabled = false
            }
        }

        if let ink = attachments.entity(for: spatialInkSurfaceID) {
            ink.position = [0, 1.43, -0.61]
            ink.scale = [0.72, 0.72, 0.72]
            ink.isEnabled = visible &&
                experience.audienceLens == .clinician &&
                !imageWorkingMode &&
                experience.spatialInkVisible
            ink.components.set(BillboardComponent())
        }

        if let scholarRail = attachments.entity(for: scholarReferenceRailID) {
            // Keep the reference index as one slim vertical rail in the
            // right-secondary field. Its selected detail expands beneath the
            // active tab rather than duplicating the category controls in a
            // lower-right grid.
            scholarRail.position = [0.70, 1.68, -0.96]
            scholarRail.scale = [0.88, 0.88, 0.88]
            scholarRail.isEnabled = visible &&
                experience.audienceLens == .clinician &&
                !imageWorkingMode
            scholarRail.components.set(BillboardComponent())
        }
    }

    private func updateSpatialRoleControls(
        _ attachments: RealityViewAttachments,
        stageRoot: Entity
    ) {
        let imageWorkingMode = experience.audienceLens == .clinician &&
            experience.spatialImagingPlateVisible
        let controls: [(String, SIMD3<Float>, Float, Bool)] = [
            (familyControlsID, [-0.43, 1.28, -0.90], 0.74, experience.audienceLens == .family),
            (
                presenterControlsID,
                [0.56, 1.30, -0.92],
                0.86,
                experience.audienceLens == .clinician
            )
        ]

        for (id, position, scale, correctRole) in controls {
            guard let attachment = attachments.entity(for: id) else { continue }
            if attachment.parent == nil { stageRoot.addChild(attachment) }
            attachment.position = position
            attachment.scale = [scale, scale, scale]
            attachment.isEnabled = experience.spatialPhase == .explanation &&
                correctRole &&
                experience.focusedReferenceWorkspace == nil &&
                !experience.accessLayerStudy.isActive &&
                !(id == presenterControlsID && imageWorkingMode)
            attachment.components.set(BillboardComponent())
        }
    }

    private func updateClinicianHandToolKit(
        content: RealityViewContent,
        attachments: RealityViewAttachments,
        time: TimeInterval
    ) {
        let enabled = experience.spatialPhase == .explanation &&
            experience.audienceLens == .clinician &&
            experience.focusedReferenceWorkspace == nil &&
            !experience.spatialImagingPlateVisible &&
            !experience.spatialImagingFocusActive &&
            !experience.spatialImagingAnnotationEnabled &&
            !experience.isClinicianScholarSkullInspectionActive
        if let anchor = content.entities.first(where: { $0.name == clinicianToolWheelAnchorName }),
           let wheel = attachments.entity(for: clinicianToolWheelID) {
            if wheel.parent !== anchor {
                wheel.removeFromParent()
                anchor.addChild(wheel)
            }
            // Keep the selector beside and slightly in front of the palm. The
            // app deliberately avoids palm-roll/cup-pose inference, leaving
            // Home and Control Center gestures to the system.
            wheel.position = [0.095, 0.025, 0.110]
            wheel.scale = [0.78, 0.78, 0.78]
            // A palm anchor carries the hand's full roll. Let the cuff follow
            // the hand spatially while keeping its SwiftUI face upright and
            // readable to the wearer instead of occasionally presenting the
            // text upside down or back-facing.
            wheel.components.set(BillboardComponent())
            wheel.isEnabled = enabled && !experience.accessLayerStudy.isActive
        }

        if let anchor = content.entities.first(where: { $0.name == clinicianHeldToolAnchorName }),
           let tools = anchor.findEntity(named: StrokeSceneFactory.clinicianHeldToolRootName) {
            // The right-palm anchor's local +Z points opposite the authored
            // instrument shafts. Reverse that single forward axis so forceps,
            // drill, and focus pointer project from the hand toward the shared
            // anatomy rather than back toward the clinician. The small offset
            // keeps the normalized asset's grip at the palm after the flip.
            tools.position = [0, 0.015, 0.055]
            tools.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
            StrokeSceneFactory.updateClinicianHeldTools(
                tools,
                selected: experience.selectedClinicianTool,
                endovascularConcept: experience.selectedEndovascularConcept,
                enabled: enabled && experience.clinicianToolKitVisible,
                detailLevel: experience.detailLevel
            )
        }

        if let stageRoot = content.entities.first(where: { $0.name == stageRootName }),
           let inspection = stageRoot.findEntity(
               named: StrokeSceneFactory.clinicianToolInspectionRootName
           ) {
            let inspectionVisible = enabled &&
                experience.clinicianToolKitVisible &&
                experience.selectedClinicianTool == .endovascularSet

            // A 2.4x teaching magnification preserves the authored device's
            // proportions while making its sub-mm shaft legible without
            // eclipsing the anatomy. It does not imply physical scale.
            var inspectionPosition = SIMD3<Float>(0.30, 1.60, -0.60)
            var inspectionScale: Float = 2.4
            var studyYaw: Float = 0
            switch experience.clinicianDeviceStudyBeat {
            case .overview:
                break
            case .approach:
                let rawPhase = reduceMotion
                    ? Float(0.78)
                    : (sin(Float(time) * 0.65) + 1) * 0.5
                let easedPhase = rawPhase * rawPhase * (3 - 2 * rawPhase)
                // Move toward the central teaching anatomy but retain a clear
                // stop distance. This is a directional concept, not catheter
                // navigation, insertion depth, or a patient-specific route.
                inspectionPosition.x -= 0.10 * easedPhase
                inspectionPosition.z -= 0.025 * easedPhase
                inspectionScale += 0.10 * easedPhase
            case .structure:
                studyYaw = reduceMotion
                    ? 0.32
                    : sin(Float(time) * 0.45) * 0.52
            }
            inspection.position = inspectionPosition
            inspection.scale = [inspectionScale, inspectionScale, inspectionScale]
            let inspectionTilt = simd_quatf(angle: -0.10, axis: [0, 0, 1])
            let inspectionTurn = simd_quatf(
                angle: experience.clinicianDeviceInspectionYaw + studyYaw,
                axis: [0, 1, 0]
            )
            inspection.orientation = inspectionTurn * inspectionTilt
            inspection.isEnabled = inspectionVisible
            StrokeSceneFactory.updateClinicianHeldTools(
                inspection,
                selected: .endovascularSet,
                endovascularConcept: experience.selectedEndovascularConcept,
                enabled: inspectionVisible,
                detailLevel: experience.detailLevel
            )

            if let label = attachments.entity(for: clinicianToolInspectionLabelID) {
                if label.parent !== stageRoot {
                    label.removeFromParent()
                    stageRoot.addChild(label)
                }
                // Keep provenance above the long device silhouette so the
                // catheter never strikes through the interaction or detail copy.
                label.position = [0.30, 1.86, -0.59]
                label.scale = [0.70, 0.70, 0.70]
                label.components.set(BillboardComponent())
                label.isEnabled = inspectionVisible
            }

        }
    }

    private func spatialLabel(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.bold))
            .tracking(1.2)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .glassBackgroundEffect(in: Capsule())
    }

    private func questionMarkerPosition(in root: Entity, relativeTo stageRoot: Entity) -> SIMD3<Float> {
        if let placement = experience.placedQuestion {
            let scenePosition = root.convert(position: placement.rootLocalPosition, to: nil)
            return stageRoot.convert(position: scenePosition, from: nil)
        }
        return switch experience.procedureStep {
        case .chooseCase: [-0.18, 1.73, -0.75]
        case .inspectOcclusion: [0.19, 1.82, -0.72]
        case .discussCare: [0.24, 1.76, -0.74]
        }
    }

    private func sceneRoot(for entity: Entity) -> Entity? {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name == StrokeSceneFactory.rootName {
                return current
            }
            candidate = current.parent
        }
        return nil
    }

    private func spatialCaseRoom(for entity: Entity) -> Entity? {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name == StrokeSceneFactory.spatialCaseRoomName {
                return current
            }
            candidate = current.parent
        }
        return nil
    }

    /// Two quiet mono beds are attached to what they explain. Flow originates
    /// in the vessel; pressure originates in the affected hemisphere. Neither
    /// is a measurement, alarm, diagnosis, or emotional inference.
    @MainActor
    private func installSpatialAudio(on root: Entity) async {
        let loop = AudioFileResource.Configuration(shouldLoop: true)

        if let url = Bundle.main.url(forResource: "FlowBed", withExtension: "wav"),
           let resource = try? await AudioFileResource(contentsOf: url, withName: "flow-bed", configuration: loop) {
            let emitter = Entity()
            emitter.name = "flow-audio-emitter"
            emitter.position = [-0.03, -0.025, 0.055]
            emitter.spatialAudio = SpatialAudioComponent(gain: -18)
            root.addChild(emitter)
            let controller = emitter.prepareAudio(resource)
            controller.gain = -18
            controller.play()
            flowController = controller
        }

        if let url = Bundle.main.url(forResource: "PressureBed", withExtension: "wav"),
           let resource = try? await AudioFileResource(contentsOf: url, withName: "pressure-bed", configuration: loop) {
            let emitter = Entity()
            emitter.name = "pressure-audio-emitter"
            emitter.position = [0.065, 0.04, 0.025]
            emitter.spatialAudio = SpatialAudioComponent(gain: -32)
            root.addChild(emitter)
            let controller = emitter.prepareAudio(resource)
            controller.gain = -32
            controller.play()
            pressureController = controller
        }

        updateAudioMix()
    }

    @MainActor
    private func updateAudioMix() {
        let muted = experience.spatialPhase != .explanation || !experience.soundEnabled || experience.requestedPause
        let flowGain: Double
        let pressureGain: Double

        if muted {
            flowGain = -96
            pressureGain = -96
        } else {
            switch experience.procedureStep {
            case .chooseCase:
                flowGain = -18
                pressureGain = -96
            case .inspectOcclusion:
                flowGain = -28
                pressureGain = -22
            case .discussCare:
                // Pressure softens, but never resolves into a success cue.
                flowGain = -30
                pressureGain = -29
            }
        }

        flowController?.fade(to: flowGain, duration: 0.8)
        pressureController?.fade(to: pressureGain, duration: 0.8)
    }

    private func synchronizeImmersionStyle() {
        immersionStyle = switch experience.environmentMode {
        case .surroundings: .mixed
        case .warmHorizon: .progressive
        case .focusField: .full
        }
    }
}

/// The explicit handoff between selecting a fictional case and entering its
/// anatomy lesson. It exists only in the review room; the cabinet is removed
/// from the scene before the brain appears.
private struct SpatialCaseReviewActions: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        let record = experience.selectedFictionalCase
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top, spacing: 13) {
                FictionalCasePortrait(record: record, size: 78, selected: true)

                VStack(alignment: .leading, spacing: 3) {
                    Text("SELECTED FICTIONAL DOSSIER")
                        .font(.caption2.weight(.black))
                        .tracking(1.1)
                        .foregroundStyle(.orange)
                    Text(record.displayName)
                        .font(.title3.weight(.bold))
                    Text("\(record.id) · \(record.ageBand) · no patient data")
                        .font(.caption.monospacedDigit().weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 6)

                Text(record.elapsed.uppercased())
                    .font(.caption2.monospacedDigit().weight(.black))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.12), in: Capsule())
                    .foregroundStyle(.orange)
            }

            HStack(spacing: 8) {
                dossierSignal(record.lead, icon: record.systemImage)
                dossierSignal(record.context, icon: "person.2.fill")
            }

            HStack(spacing: 10) {
                Button {
                    experience.returnCaseToLibrary()
                } label: {
                    Label("Files", systemImage: "chevron.backward")
                        .frame(minHeight: 44)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Return file")

                Button(
                    experience.audienceLens == .family ? "Explore the brain" : "Open brain explanation",
                    systemImage: "arrow.up.right"
                ) {
                    experience.beginExplanation()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .frame(maxWidth: .infinity)
            }

            Label("Next view uses generic teaching anatomy—not this person's scan", systemImage: "shield.lefthalf.filled")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.orange.opacity(0.28)))
        .shadow(color: .black.opacity(0.18), radius: 18, y: 8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Selected fictional dossier, \(record.id), \(record.displayName)")
    }

    private func dossierSignal(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.semibold))
            .lineLimit(2)
            .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
            .padding(.horizontal, 11)
            .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 13))
    }
}

/// A palm-anchored, clinician-only instrument selector. It stays as a small
/// cuff until the clinician deliberately opens it; gaze plus pinch selects a
/// tool. No raw eye position or custom pinch inference is used.
private struct StrokeAccessLayerStudyControls: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var study: StrokeAccessLayerStudy { experience.accessLayerStudy }
    private var actionTitle: String {
        if experience.selectedClinicianTool != .forceps { return "Select forceps" }
        if !study.canMoveSelectedLayer {
            return study.selectedLayer == .bone ? "Return dura first" : "Lift bone first"
        }
        return "\(study.selectedProgress < 0.5 ? "Lift" : "Return") \(study.selectedLayer.rawValue.lowercased())"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 14) {
                Button("Back", systemImage: "chevron.left") {
                    experience.endAccessLayerStudy()
                }
                .buttonStyle(.bordered)
                .frame(minHeight: 52)
                .accessibilityLabel("Return to the access story")

                VStack(alignment: .leading, spacing: 3) {
                    Text("CRANIOTOMY LAYERS")
                        .font(.caption.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(.mint)
                    Text("\(study.selectedLayer.rawValue) model · \(study.selectedProgress >= 0.999 ? "lifted" : (study.selectedProgress <= 0.001 ? "in place" : "moving"))")
                        .font(.title3.weight(.semibold))
                }
                Spacer(minLength: 6)
                Button {
                    experience.resetAccessLayerStudy()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(width: 52, height: 52)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Reset both teaching layers")
                .help("Reset both layers")
            }

            Text(study.instruction)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.88))

            HStack(spacing: 18) {
                Picker("Layer", selection: Binding(
                    get: { study.selectedLayer },
                    set: { experience.selectAccessStudyLayer($0) }
                )) {
                    ForEach(StrokeAccessStudyLayer.allCases) { layer in
                        Text(layer.rawValue).tag(layer)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 212, height: 54)
                .accessibilityLabel("Choose the bone or dura teaching layer")

                Button(actionTitle, systemImage: "hand.pinch.fill") {
                    if experience.selectedClinicianTool != .forceps {
                        experience.selectClinicianTool(.forceps)
                    } else {
                        if !study.canMoveSelectedLayer {
                            let neededTarget: Float = study.selectedLayer == .bone ? 0 : 1
                            experience.selectAccessStudyLayer(study.selectedLayer == .bone ? .dura : .bone)
                            experience.moveAccessStudyLayer(to: neededTarget, reduceMotion: reduceMotion)
                        } else {
                            experience.toggleAccessStudyLayer(reduceMotion: reduceMotion)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
                .frame(maxWidth: .infinity, minHeight: 54)
                .accessibilityHint("Alternative to pinching or dragging the mint handle on the model")
            }
            Text("Generic layer model · not operative technique · clinician review pending")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.62))
        }
        .padding(18)
        .frame(width: 600)
        .background(.black.opacity(0.70), in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.mint.opacity(0.20)))
        .accessibilityElement(children: .contain)
    }
}

private struct HandToolArcGuide: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX - 50, y: rect.midY),
            radius: min(rect.width, rect.height) * 0.37,
            startAngle: .degrees(-75),
            endAngle: .degrees(75),
            clockwise: false
        )
        return path
    }
}

private struct ClinicianHandToolWheel: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    private let arcOffsets: [CGSize] = [
        CGSize(width: -18, height: -160),
        CGSize(width: 72, height: -112),
        CGSize(width: 112, height: -40),
        CGSize(width: 112, height: 40),
        CGSize(width: 72, height: 112),
        CGSize(width: -18, height: 160)
    ]

    private let conceptOffsets: [CGSize] = [
        CGSize(width: -18, height: -160),
        CGSize(width: 102, height: -62),
        CGSize(width: 102, height: 62),
        CGSize(width: -18, height: 160)
    ]

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if experience.clinicianToolKitVisible {
                    HandToolArcGuide()
                        .stroke(
                            Color.mint.opacity(0.30),
                            style: StrokeStyle(lineWidth: 18, lineCap: .round)
                        )
                        .frame(width: 430, height: 430)

                    if experience.selectedClinicianTool == .endovascularSet {
                        ForEach(Array(StrokeEndovascularConcept.allCases.enumerated()), id: \.element.id) { index, concept in
                            conceptButton(concept)
                                .offset(conceptOffsets[index])
                        }
                    } else {
                        ForEach(Array(StrokeClinicianTool.allCases.enumerated()), id: \.element.id) { index, tool in
                            toolButton(tool)
                                .offset(arcOffsets[index])
                        }
                    }
                }

                Button {
                    if experience.selectedClinicianTool == .endovascularSet {
                        experience.selectClinicianTool(.focus)
                    } else {
                        experience.toggleClinicianToolKit()
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: experience.selectedClinicianTool == .endovascularSet ? "chevron.backward" : (experience.clinicianToolKitVisible ? "xmark" : "cross.case.fill"))
                            .font(.title2.weight(.semibold))
                        Text(experience.selectedClinicianTool == .endovascularSet ? "TOOLS" : (experience.clinicianToolKitVisible ? "CLOSE" : "KIT"))
                            .font(.caption2.weight(.black))
                            .tracking(0.7)
                    }
                    .frame(width: 88, height: 88)
                }
                .buttonStyle(.plain)
                .background(Color.mint.opacity(0.20), in: Circle())
                .overlay(Circle().stroke(Color.mint.opacity(0.52), lineWidth: 2))
                .offset(x: -72)
                .accessibilityLabel(
                    experience.selectedClinicianTool == .endovascularSet
                        ? "Return to clinician tools"
                        : (experience.clinicianToolKitVisible ? "Close clinician tools" : "Open clinician tools")
                )
            }
            .frame(width: 430, height: 430)

            if experience.clinicianToolKitVisible {
                VStack(spacing: 3) {
                    Text(
                        experience.selectedClinicianTool == .endovascularSet
                            ? "CATHETER SET · \(experience.selectedEndovascularConcept.rawValue.uppercased())"
                            : experience.selectedClinicianTool.rawValue.uppercased()
                    )
                        .font(.caption.weight(.black))
                        .tracking(1.0)
                    Text(experience.selectedClinicianTool.boundary)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.regularMaterial, in: Capsule())
                .frame(width: 330)
                .offset(x: 42)

                if experience.selectedClinicianTool == .endovascularSet {
                    Text(experience.selectedEndovascularConcept.boundary)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(width: 350)
                        .offset(x: 42)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Clinician hand tool kit")
    }

    private func toolButton(_ tool: StrokeClinicianTool) -> some View {
        Button {
            experience.selectClinicianTool(tool)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tool.systemImage)
                    .font(.title3.weight(.semibold))
                Text(tool.rawValue)
                    .font(.caption2.weight(.bold))
                    .lineLimit(1)
            }
            .frame(width: 84, height: 84)
        }
        .buttonStyle(.plain)
        .foregroundStyle(experience.selectedClinicianTool == tool ? Color.black : Color.white)
        .background(experience.selectedClinicianTool == tool ? Color.mint : Color.white.opacity(0.10), in: Circle())
        .overlay(Circle().stroke(Color.white.opacity(0.15)))
        .accessibilityLabel("Select \(tool.rawValue)")
        .accessibilityValue(tool.boundary)
    }

    private func conceptButton(_ concept: StrokeEndovascularConcept) -> some View {
        Button {
            experience.selectEndovascularConcept(concept)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: concept.systemImage)
                    .font(.title3.weight(.semibold))
                Text(concept.rawValue)
                    .font(.caption2.weight(.bold))
                    .lineLimit(1)
            }
            .frame(width: 94, height: 94)
        }
        .buttonStyle(.plain)
        .foregroundStyle(experience.selectedEndovascularConcept == concept ? Color.black : Color.white)
        .background(
            experience.selectedEndovascularConcept == concept ? Color.mint : Color.white.opacity(0.10),
            in: Circle()
        )
        .overlay(Circle().stroke(Color.white.opacity(0.15)))
        .accessibilityLabel("Inspect \(concept.rawValue) concept")
        .accessibilityValue(concept.boundary)
    }
}

/// Plain spatial provenance for the enlarged authored device. The model stays
/// primary; this compact label prevents a magnified teaching view from being
/// mistaken for physical scale or a procedural recommendation.
private struct ClinicianDeviceInspectionLabel: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    private var accessibilitySummary: String {
        [
            "Magnified three D device study",
            experience.selectedEndovascularConcept.rawValue,
            experience.selectedEndovascularConcept.inspectionSummary,
            experience.clinicianDeviceStudyBeat.title,
            experience.clinicianDeviceStudyBeat.summary,
            "Colour-enhanced geometry, not to scale, specialist review pending",
            "Pinch to advance the three-beat study",
            "Drag horizontally to turn this device"
        ].joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("MAGNIFIED 3D DEVICE STUDY")
                .font(.caption2.weight(.black))
                .tracking(1.1)
                .foregroundStyle(.mint)
            Text(experience.selectedEndovascularConcept.rawValue)
                .font(.headline.weight(.bold))
            Text(experience.selectedEndovascularConcept.inspectionSummary)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(
                "0\(experience.clinicianDeviceStudyBeat.rawValue + 1) / 03 · " +
                experience.clinicianDeviceStudyBeat.title.uppercased()
            )
                .font(.caption.weight(.black))
                .foregroundStyle(.orange)
            Text(experience.clinicianDeviceStudyBeat.summary)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(
                "\(experience.detailLevel.visualDetailTitle.uppercased()) GEOMETRY · " +
                experience.selectedEndovascularConcept.geometryDisclosure(
                    for: experience.detailLevel
                ).uppercased()
            )
                .font(.caption.weight(.black))
                .foregroundStyle(.white.opacity(0.78))
            Text("PINCH · NEXT BEAT   DRAG · TURN")
                .font(.caption2.weight(.black))
                .tracking(0.7)
                .foregroundStyle(.mint)
            Text("Colour-enhanced geometry · not to scale · specialist review pending")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.mint.opacity(0.28)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }
}

/// Role controls live inside the immersive room instead of opening another
/// desktop-like window. They read as a small constellation of gaze-sized
/// bubbles: family controls stay left and low; presenter controls stay right.
/// The shared anatomy remains the only foveal object.
private struct SpatialRoleControls: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(RBCJourneyModel.self) private var internalJourney
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let role: StrokeAudienceLens

    var body: some View {
        VStack(alignment: role == .family ? .leading : .trailing, spacing: 9) {
            HStack(spacing: 8) {
                Label(
                    role == .family ? "FAMILY" : "PRESENTER",
                    systemImage: role == .family ? "person.2.fill" : "stethoscope"
                )
                .font(.caption2.weight(.black))
                .tracking(1.0)
                .foregroundStyle(role == .family ? .orange : .mint)

                Text(
                    role == .family
                        ? "ACT \(experience.procedureStep.number) OF 3"
                        : "CHECKPOINT \(experience.presenterTeachingBeat.number) OF \(StrokePresenterTeachingBeat.allCases.count)"
                )
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .foregroundStyle(.secondary.opacity(0.82))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.regularMaterial, in: Capsule())

            if role == .family {
                if isFamilyFirstDiscovery {
                    familyFirstDiscoveryControls
                } else {
                    familyControls
                }
            } else {
                presenterControls
            }

            if experience.isConsentPromptVisible {
                consentControls
            }
        }
        .padding(4)
        // This is system-managed semantic feedback on supported visionOS
        // hardware. All controls retain their visible labels and state when
        // feedback is unavailable or disabled at the system level.
        .strokeSemanticSelectionFeedback(trigger: experience.interactionFeedbackToken)
    }

    /// The first family view intentionally contains one spatial invitation,
    /// not a miniature dashboard. The concise cue above the brain explains
    /// the primary action; this lower cluster preserves only an obvious way
    /// out. Full family controls arrive after the first selected point.
    private var isFamilyFirstDiscovery: Bool {
        role == .family &&
            experience.familyDiscoveryHintVisible &&
            experience.selectedPointEntityName == nil &&
            !experience.familyBrainAtlasVisible
    }

    private var familyFirstDiscoveryControls: some View {
        HStack(spacing: 8) {
            Label("One point at a time", systemImage: "sparkles")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.orange.opacity(0.88))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(.regularMaterial, in: Capsule())
                .accessibilityLabel("One point at a time")

            exitButton
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Family entry controls")
    }

    private var familyControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                bubbleButton(
                    lessonFamilyBubbleTitle,
                    systemImage: experience.pointField.systemImage,
                    accent: .orange,
                    selected: experience.pointField == .procedure
                ) {
                    cycleLessonFamily()
                }
                .accessibilityLabel("Lesson family")
                .accessibilityValue(experience.pointField.rawValue)
                .accessibilityHint("Pinch to show the next lesson family")

                bubbleButton(
                    "Points",
                    systemImage: experience.lessonPointsVisible ? "eye.fill" : "eye.slash",
                    accent: .orange,
                    selected: experience.lessonPointsVisible
                ) {
                    experience.toggleLessonPoints()
                }
                .accessibilityLabel(experience.lessonPointsVisible ? "Hide lesson points" : "Show lesson points")

                // A spatial control must perform an action. When the local
                // Realtime proxy is absent there is nothing this surface can
                // configure, so the dead Voice setup bubble stays hidden; the
                // selected-point card still offers its authored Read more path.
                if experience.narrationSetupAvailable {
                    bubbleButton(
                        experience.narrationEnabled ? "Narrator off" : "Narrator",
                        systemImage: experience.narrationEnabled ? "speaker.slash.fill" : "waveform",
                        accent: .orange,
                        selected: experience.narrationEnabled
                    ) {
                        if experience.narrationEnabled || experience.familyNarrationPromptVisible {
                            experience.setNarrationEnabled(false)
                        } else {
                            experience.setNarrationEnabled(true)
                        }
                    }
                    .accessibilityLabel(
                        experience.narrationEnabled
                            ? "Turn off Curious Learner narrator"
                            : "Turn on Curious Learner narrator"
                    )
                    .accessibilityHint("Voice remains silent until you select a point and choose Play audio")
                }

                bubbleButton(
                    experience.familyBrainAtlasVisible ? "Atlas off" : "Atlas",
                    systemImage: "book.closed.fill",
                    accent: .orange,
                    selected: experience.familyBrainAtlasVisible
                ) {
                    experience.toggleFamilyBrainAtlas()
                }
                .accessibilityLabel(experience.familyBrainAtlasVisible ? "Close Brain Atlas" : "Open Brain Atlas")
                .accessibilityHint("Opens a ten-part, family-paced guide beside the 3D brain")

                bubbleButton(
                    experience.closingReflectionVisible ? "Cases" : "Next",
                    systemImage: "arrow.right",
                    accent: .orange,
                    selected: true
                ) {
                    experience.advanceJourney()
                }
            }

            HStack(spacing: 8) {
                bubbleButton(
                    experience.requestedPause ? "Resume" : "Pause",
                    systemImage: experience.requestedPause ? "play.fill" : "pause.fill",
                    accent: .orange,
                    selected: experience.requestedPause
                ) {
                    experience.togglePause()
                }
                .accessibilityValue(experience.requestedPause ? "Paused" : "Playing")
                .accessibilityHint(experience.requestedPause ? "Resume all authored lesson motion" : "Hold all authored lesson motion")

                bubbleButton(
                    experience.clarificationRequested ? "Marked" : "Clarify",
                    systemImage: "questionmark.bubble",
                    accent: .orange,
                    selected: experience.clarificationRequested
                ) {
                    experience.requestClarification()
                }
                .disabled(experience.clarificationRequested)

                bubbleButton(
                    experience.questionPlacementArmed ? "Tap brain" : "Point",
                    systemImage: "mappin.and.ellipse",
                    accent: .orange,
                    selected: experience.questionPlacementArmed
                ) {
                    experience.toggleQuestionPlacement()
                }

                if experience.isInteriorPortalAvailable {
                    brainInteriorButton(accent: .orange)
                }

                exitButton
            }
        }
    }

    @ViewBuilder
    private var presenterControls: some View {
        if experience.isClinicianScholarSkullInspectionActive {
            scholarSkullControls
        } else {
            regularPresenterControls
        }
    }

    private var scholarSkullControls: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack(spacing: 8) {
                bubbleButton(
                    environmentBubbleTitle,
                    systemImage: experience.environmentMode.systemImage,
                    accent: .cyan,
                    selected: experience.environmentMode != .surroundings
                ) {
                    cycleEnvironment()
                }
                .accessibilityLabel("Environment")

                bubbleButton(
                    "Evidence",
                    systemImage: "text.book.closed.fill",
                    accent: .cyan
                ) {
                    experience.openReferenceWorkspace(.guides)
                }
                .accessibilityLabel("Open registration evidence")
            }

            HStack(spacing: 8) {
                bubbleButton(
                    experience.clinicianToolKitVisible ? "Tools on" : "Tools",
                    systemImage: "cross.case.fill",
                    accent: .mint,
                    selected: experience.clinicianToolKitVisible
                ) {
                    experience.toggleClinicianToolKit()
                }
                .accessibilityLabel("Clinician tools")
                .accessibilityHint("Shows or hides the hand-adjacent tool arc")

                bubbleButton(
                    "Reset",
                    systemImage: "arrow.counterclockwise",
                    accent: .cyan
                ) {
                    experience.resetSpatialView()
                }
                .accessibilityLabel("Reset skull view")

                exitButton
            }

            Label("Generic skull · specialist review pending", systemImage: "exclamationmark.shield")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary.opacity(0.88))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.regularMaterial, in: Capsule())
        }
    }

    private var regularPresenterControls: some View {
        VStack(alignment: .trailing, spacing: 9) {
            // Two stable rows keep the common presenter actions glanceable.
            // Technical anatomy, imaging, medication, and evidence branches
            // live in the peripheral reference ring instead of duplicating a
            // second toolbar around the brain.
            LazyVGrid(
                columns: Array(repeating: GridItem(.fixed(80), spacing: 8), count: 4),
                spacing: 8
            ) {
                bubbleButton(
                    lessonFamilyBubbleTitle,
                    systemImage: experience.pointField.systemImage,
                    accent: .mint,
                    selected: experience.pointField != .regions
                ) {
                    cycleLessonFamily()
                }
                .accessibilityLabel("Lesson family")
                .accessibilityValue(experience.pointField.rawValue)

                bubbleButton(
                    "Points",
                    systemImage: experience.lessonPointsVisible ? "eye.fill" : "eye.slash",
                    accent: .mint,
                    selected: experience.lessonPointsVisible
                ) {
                    experience.toggleLessonPoints()
                }
                .accessibilityLabel(experience.lessonPointsVisible ? "Hide lesson points" : "Show lesson points")

                bubbleButton(
                    "Tools",
                    systemImage: "hand.raised.fingers.spread",
                    accent: .mint
                ) {
                    experience.toggleClinicianToolKit()
                }
                .accessibilityLabel("Show or hide hand tools")

                bubbleButton(
                    environmentBubbleTitle,
                    systemImage: experience.environmentMode.systemImage,
                    accent: .mint,
                    selected: experience.environmentMode != .surroundings
                ) {
                    cycleEnvironment()
                }
                .accessibilityLabel("Background")
                .accessibilityValue(experience.environmentMode.rawValue)

                bubbleButton(
                    experience.requestedPause ? "Resume" : "Pause",
                    systemImage: experience.requestedPause ? "play.fill" : "pause.fill",
                    accent: .mint,
                    selected: experience.requestedPause
                ) {
                    experience.togglePause()
                }
                .accessibilityValue(experience.requestedPause ? "Paused" : "Playing")
                .accessibilityHint(experience.requestedPause ? "Resume all authored lesson motion" : "Hold all authored lesson motion")

                bubbleButton(
                    experience.soundEnabled ? "Sound on" : "Sound off",
                    systemImage: experience.soundEnabled ? "speaker.slash.fill" : "speaker.wave.2.fill",
                    accent: .mint,
                    selected: experience.soundEnabled
                ) {
                    experience.soundEnabled.toggle()
                }
                .accessibilityLabel(experience.soundEnabled ? "Mute ambient sound" : "Enable ambient sound")

                bubbleButton(
                    experience.spatialInkVisible ? "Drawing" : "Ink",
                    systemImage: "pencil.tip.crop.circle",
                    accent: .orange,
                    selected: experience.spatialInkVisible
                ) {
                    experience.toggleSpatialInk()
                }
                .accessibilityLabel(experience.spatialInkVisible ? "Hide spatial ink overlay" : "Show spatial ink overlay")
                .accessibilityHint("Look at the teaching surface, then pinch-drag to draw a temporary trail")

                bubbleButton(
                    experience.closingReflectionVisible ? "Cases" : "Next",
                    systemImage: "arrow.right",
                    accent: .mint,
                    selected: true
                ) {
                    experience.advanceJourney()
                }
            }

            HStack(spacing: 8) {
                Label("Teaching view · not a recommendation", systemImage: "checkmark.shield")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary.opacity(0.82))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.regularMaterial, in: Capsule())
                    .accessibilityLabel(experience.presenterBoundary)

                if experience.isInteriorPortalAvailable {
                    brainInteriorButton(accent: .mint)
                }
                exitButton
            }
        }
    }

    private func brainInteriorButton(accent: Color) -> some View {
        Button {
            internalJourney.startEntryPrelude()
            internalJourney.isPresented = true
            experience.enterInternalBrainMode()
            experience.registerInteractionFeedback()
        }
        label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.right.and.arrow.up.left")
                    .font(.headline.weight(.bold))
                VStack(alignment: .leading, spacing: 1) {
                    Text("ENTER THE BRAIN")
                        .font(.caption.weight(.black))
                        .tracking(0.55)
                    Text("Guided vessel journey")
                        .font(.caption2.weight(.medium))
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 13)
            .padding(.vertical, 10)
            .background(accent.gradient, in: Capsule())
        }
        .buttonStyle(.plain)
        .contentShape(Capsule())
        .accessibilityLabel("Enter the inside-the-brain journey")
        .accessibilityHint("Transitions into the guided blood-vessel experience and keeps a return path to Stroke Care")
    }

    private var consentControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("May I make the protective layers transparent? No incision or blood.")
                .font(.caption.weight(.semibold))
            HStack(spacing: 8) {
                Button("Not now") { experience.declineCareView() }
                    .buttonStyle(.bordered)
                Button("Show non-graphic view") {
                    experience.grantNonGraphicCareViewPermission()
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
        }
        .padding(10)
        .background(Color.orange.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
    }

    private var exitButton: some View {
        bubbleButton("Exit", systemImage: "xmark", accent: role == .family ? .orange : .mint) {
            Task { await exitRoom() }
        }
    }

    private func bubbleButton(
        _ title: String,
        systemImage: String,
        accent: Color,
        selected: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
            experience.registerInteractionFeedback()
        } label: {
            SpatialControlBubbleLabel(
                title: title,
                systemImage: systemImage,
                accent: accent,
                selected: selected
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private var layerBubbleTitle: String {
        switch experience.anatomyPresentation {
        case .assembled: "Layers"
        case .transparent: "Skull"
        case .exploded: "Apart"
        }
    }

    private var lessonFamilyBubbleTitle: String {
        switch experience.pointField {
        case .regions: "Regions"
        case .procedure: "Flow"
        case .craniotomy: "Access"
        }
    }

    private var environmentBubbleTitle: String {
        switch experience.environmentMode {
        case .surroundings: "Room"
        case .warmHorizon: "Warm"
        case .focusField: "Black"
        }
    }

    private func cycleAnatomyPresentation() {
        switch experience.anatomyPresentation {
        case .assembled:
            experience.setAnatomyPresentation(.transparent)
        case .transparent:
            experience.setAnatomyPresentation(.exploded)
        case .exploded:
            experience.setAnatomyPresentation(.assembled)
        }
    }

    private func cycleLessonFamily() {
        let next: StrokePointField
        switch experience.pointField {
        case .regions:
            next = .procedure
        case .procedure:
            next = experience.audienceLens == .clinician ? .craniotomy : .regions
        case .craniotomy:
            next = .regions
        }
        experience.selectLessonFamily(next)
    }

    private func cycleEnvironment() {
        switch experience.environmentMode {
        case .surroundings:
            experience.setEnvironmentMode(.warmHorizon)
        case .warmHorizon:
            experience.setEnvironmentMode(.focusField)
        case .focusField:
            experience.setEnvironmentMode(.surroundings)
        }
    }

    @MainActor
    private func exitRoom() async {
        await dismissImmersiveSpace()
        experience.isImmersivePresented = false
        experience.reset()
        openWindow(id: StrokeSpace.window)
    }
}

/// Compact labels for the real registered-v2 teaching object beside them.
/// Geometry lives in RealityKit; this view only selects one lens and preserves
/// the explicit generic/non-scan boundary without another image panel.
private struct StrokePinnedAnnotationSlot: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    let index: Int
    @State private var isDragging = false

    @ViewBuilder
    var body: some View {
        if experience.spatialAnnotations.indices.contains(index) {
            let note = experience.spatialAnnotations[index]
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 9) {
                    Label("PINNED NOTE", systemImage: "pin.fill")
                        .font(.caption2.weight(.black))
                        .tracking(0.85)
                        .foregroundStyle(.orange)

                    Spacer()

                    Label("Pinch-drag", systemImage: "hand.draw")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.60))

                    Button("Remove", systemImage: "xmark") {
                        experience.removeSpatialAnnotation(id: note.id)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                    .accessibilityLabel("Remove pinned note")
                }
                .frame(minHeight: 42)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 4)
                        .onChanged { value in
                            if !isDragging {
                                isDragging = true
                                experience.beginSpatialAnnotationDrag(id: note.id)
                            }
                            experience.moveSpatialAnnotation(
                                id: note.id,
                                translation: value.translation
                            )
                        }
                        .onEnded { _ in
                            isDragging = false
                            experience.endSpatialAnnotationDrag(id: note.id)
                        }
                )

                Text(note.title.uppercased())
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(note.body)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(3)

                HStack {
                    Text("AUTHORED POINT · GENERIC TEACHING MODEL")
                        .font(.caption2.monospaced().weight(.semibold))
                        .foregroundStyle(.white.opacity(0.48))
                    Spacer()
                    Button("Locate", systemImage: "scope") {
                        experience.locateSpatialAnnotation(id: note.id)
                    }
                    .buttonStyle(.bordered)
                    .tint(.orange)
                }
            }
            .padding(15)
            .frame(width: 360, height: 190, alignment: .topLeading)
            .background(.black.opacity(0.76), in: RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.orange.opacity(0.38)))
            .shadow(color: .black.opacity(0.62), radius: 12, y: 4)
            .accessibilityElement(children: .contain)
        }
    }
}

/// A temporary, transparent clinician drawing plane positioned immediately in
/// front of the generic teaching brain. It uses ordinary targeted pinch-drag
/// input through SwiftUI; no raw gaze, custom hand pose, or patient capture is
/// requested. Normalized points keep the ink stable as the attachment scales.
private struct StrokeSpatialInkSurface: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var isDrawing = false

    var body: some View {
        ZStack {
            Canvas { context, size in
                for stroke in experience.spatialInkStrokes where !stroke.points.isEmpty {
                    var path = Path()
                    let renderedPoints = stroke.points.map { denormalized($0, in: size) }
                    path.move(to: renderedPoints[0])
                    if renderedPoints.count == 2 {
                        path.addLine(to: renderedPoints[1])
                    } else if renderedPoints.count > 2 {
                        for index in 1..<(renderedPoints.count - 1) {
                            let control = renderedPoints[index]
                            let next = renderedPoints[index + 1]
                            let midpoint = CGPoint(
                                x: (control.x + next.x) * 0.5,
                                y: (control.y + next.y) * 0.5
                            )
                            path.addQuadCurve(to: midpoint, control: control)
                        }
                        path.addLine(to: renderedPoints[renderedPoints.count - 1])
                    }

                    // A quiet outer trail gives the mark continuity against
                    // dark or detailed anatomy without turning it into a
                    // diagnostic outline. The inner line remains precise.
                    context.stroke(
                        path,
                        with: .color(.orange.opacity(0.18)),
                        style: StrokeStyle(lineWidth: 13, lineCap: .round, lineJoin: .round)
                    )
                    context.stroke(
                        path,
                        with: .color(.orange.opacity(0.94)),
                        style: StrokeStyle(
                            lineWidth: 5.5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = normalized(value.location, in: CGSize(width: 760, height: 520))
                        if !isDrawing {
                            isDrawing = true
                            experience.beginSpatialInk(at: point)
                        } else {
                            experience.continueSpatialInk(at: point)
                        }
                    }
                    .onEnded { value in
                        let point = normalized(value.location, in: CGSize(width: 760, height: 520))
                        experience.endSpatialInk(at: point)
                        isDrawing = false
                    }
            )

            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Label("INK OVERLAY", systemImage: "pencil.tip.crop.circle.fill")
                        .font(.caption.weight(.black))
                        .tracking(1)
                        .foregroundStyle(.orange)

                    Text("Pinch-drag over the teaching model")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))

                    Spacer()

                    Button("Undo", systemImage: "arrow.uturn.backward") {
                        experience.undoSpatialInk()
                    }
                    .buttonStyle(.bordered)
                    .disabled(experience.spatialInkStrokes.isEmpty)

                    Button("Clear", systemImage: "eraser") {
                        experience.clearSpatialInk()
                    }
                    .buttonStyle(.bordered)
                    .disabled(experience.spatialInkStrokes.isEmpty)

                    Button("Done", systemImage: "checkmark") {
                        experience.finishSpatialInk()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding(.horizontal, 16)
                .frame(height: 64)
                .background(.black.opacity(0.74), in: Capsule())

                Spacer()

                HStack {
                    cornerMark(rotation: .degrees(0))
                    Spacer()
                    Text("GENERIC TEACHING MARKUP · NOT A MEASUREMENT OR PROCEDURE PLAN")
                        .font(.caption2.monospaced().weight(.semibold))
                        .foregroundStyle(.white.opacity(0.54))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(.black.opacity(0.58), in: Capsule())
                    Spacer()
                    cornerMark(rotation: .degrees(90))
                }
            }
            .allowsHitTesting(true)
        }
        .frame(width: 760, height: 520)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Spatial ink overlay")
        .accessibilityHint("Pinch and drag to add a temporary teaching mark")
    }

    private func normalized(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(1, max(0, point.x / size.width)),
            y: min(1, max(0, point.y / size.height))
        )
    }

    private func denormalized(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }

    private func cornerMark(rotation: Angle) -> some View {
        Image(systemName: "viewfinder")
            .font(.title2.weight(.light))
            .foregroundStyle(.orange.opacity(0.48))
            .rotationEffect(rotation)
            .padding(12)
    }
}

/// A clinician-placed, room-scale teaching image. Unlike the optional large
/// workspace window, this card lives beside the anatomy and can be moved with
/// a direct pinch-drag on its handle.
private struct StrokeSpatialImagingPlate: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var isDragging = false
    @State private var isResizing = false
    @State private var referenceDetailsVisible: Bool
    /// Records whether this term note moved the existing plate forward. This
    /// makes the local Back restore the presenter's exact working placement
    /// instead of leaving a reading note stranded in the centre of the room.
    @State private var termNoteIntroducedFocus = false
    @State private var referencePickerVisible = false
    @State private var studyToolsVisible = false
    @State private var localImageDisclosureVisible = false
    @State private var localImageImporterVisible = false
    @State private var localImageStatus: String?
    @State private var localImageImportTarget: StrokeLocalImageImportTarget = .primary
    @State private var localImageImportRequest: StrokeImagingImportRequest?
    @State private var returnReopenProofHasRun = false
    @State private var termReturnReopenProofHasRun = false

    init() {
        // The deterministic modality proof opens the same in-context note that
        // a presenter reaches by pinching the displayed technical term.
        _referenceDetailsVisible = State(
            initialValue: CommandLine.arguments.contains("--proof-imaging-modality-reference") ||
                CommandLine.arguments.contains("--proof-imaging-pet-term-note") ||
                CommandLine.arguments.contains("--proof-imaging-term-return-reopen")
        )
        // This proof opens the same vertical study deck that a presenter gets
        // from the visible Study control. It is deliberately not a second
        // imaging panel or a hidden system menu.
        _referencePickerVisible = State(
            initialValue: CommandLine.arguments.contains("--proof-imaging-study-deck")
        )
    }

    var body: some View {
        let isMarking = experience.spatialImagingAnnotationEnabled
        // An open study deck temporarily replaces the image workspace. This
        // keeps the deck, its title, and the outer Back target fully inside
        // one plate instead of letting a tall list clip the route out.
        let isChoosingStudy = referencePickerVisible && !isMarking
        // A technical term should read as a small, deliberate teaching pause,
        // not an overlay tangled with annotation, import, or comparison tools.
        // The actual plate may come forward for readability, but the note
        // still retains two named exits: Back to study and outer Back to
        // anatomy.
        let isReadingTermNote = referenceDetailsVisible &&
            !referencePickerVisible &&
            !isMarking
        // The default state is intentionally image-first. A clinician can
        // reveal the complete study, import, comparison, and reset controls
        // deliberately, rather than facing a dense control stack before they
        // have had a chance to read the selected reference.
        let showsStudyTools = studyToolsVisible || referencePickerVisible
        let contentFirstStudy = !isChoosingStudy && !isReadingTermNote && !showsStudyTools
        let imageMinimumHeight: CGFloat = contentFirstStudy
            ? (experience.spatialImagingFocusActive ? 430 : 360) : 232
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Label(
                    experience.spatialImagingFocusActive
                        ? (isReadingTermNote ? "FOCUSED TERM NOTE" :
                            (experience.spatialImagingLocalImageData == nil ? "IMAGING" : "FOCUSED LOCAL IMAGE"))
                        : (isMarking ? "MARKING TEACHING IMAGE" : "PLACED TEACHING IMAGE"),
                    systemImage: experience.spatialImagingFocusActive
                        ? (isReadingTermNote ? "text.magnifyingglass" : "rectangle.inset.filled")
                        : (isMarking ? "pencil.tip.crop.circle.fill" : "viewfinder")
                )
                    .font(.caption.weight(.black))
                    .tracking(0.9)
                    .foregroundStyle(.cyan)
                    .frame(minHeight: 48)
                    .contentShape(Rectangle())
                    // Move only from the identity area or the image surface.
                    // A drag on the whole header also competes with Back,
                    // Study tools and Reset for the same pinch sequence.
                    .gesture(plateDragGesture, including: isMarking || isReadingTermNote ? .none : .all)
                    .simultaneousGesture(plateMagnifyGesture, including: isMarking || isReadingTermNote ? .none : .all)
                    .accessibilityIdentifier("stroke-imaging-move-handle")
                    .accessibilityHint(isMarking || isReadingTermNote
                        ? "Teaching image title"
                        : "Drag this title or the image to move the plate")

                // Keep the global escape hatch immediately beside the plate
                // identity. The right-side reading controls can move outside
                // a wearer's central field as the plate is arranged, but Back
                // must remain the first stable action they can find.
                Button("Back", systemImage: "chevron.backward") {
                    StrokeImagingInteractionTrace.record(.backButton)
                    returnToAnatomyFromPlate()
                }
                .buttonStyle(.bordered)
                .tint(.gray)
                .accessibilityLabel("Back to anatomy")
                .accessibilityIdentifier("stroke-imaging-back")
                .accessibilityHint("Closes this teaching image and returns to the brain explanation")

                Spacer(minLength: 0)

                if !isMarking && !isReadingTermNote {
                    Button {
                        studyToolsVisible.toggle()
                    } label: {
                        Label(
                            showsStudyTools ? "Hide tools" : "Study tools",
                            systemImage: showsStudyTools
                                ? "slider.horizontal.3"
                                : "slider.horizontal.3"
                        )
                        .font(.caption.weight(.bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(showsStudyTools ? .cyan : .gray)
                    .accessibilityLabel(showsStudyTools ? "Hide study tools" : "Show study tools")
                    .accessibilityHint("Reveals study, comparison, import, and reset controls without leaving the teaching image")
                }

                if showsStudyTools || isMarking {
                    Label(
                        experience.spatialImagingFocusActive
                            ? (isReadingTermNote ? "Reading position · source note" : "Reading position · annotate or return")
                            : (isMarking ? "Marking image · Done to move" : "Drag to place · two-hand pinch to resize"),
                        systemImage: experience.spatialImagingFocusActive
                            ? "eye"
                            : (isMarking ? "pencil.tip.crop.circle.fill" : "hand.draw")
                    )
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.68))
                }

                if showsStudyTools && !experience.spatialImagingFocusActive && !isMarking {
                    Text("\(Int((experience.spatialImagingPlateScale * 100).rounded()))%")
                        .font(.caption2.monospacedDigit().weight(.bold))
                        .foregroundStyle(.cyan)

                    Button("Reset position and size", systemImage: "arrow.counterclockwise") {
                        experience.resetSpatialImagingPlateTransform()
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Reset teaching image position and size")
                }
            }
            .frame(minHeight: 48)

            // The image stays primary, with the same concise study controls
            // in the room and beside the brain. Marking temporarily hides
            // study selection so a drawing gesture cannot change the image.
            if !showsStudyTools && !isMarking && !isReadingTermNote {
                HStack(spacing: 10) {
                    ForEach([StrokeTeachingImageReference.ctGuide, .mriGuide]) { reference in
                        Button(reference == .ctGuide ? "CT" : "MRI") {
                            experience.placeSpatialImagingPlate(reference)
                        }
                        .buttonStyle(.bordered)
                        .tint(experience.spatialImagingLocalImageData == nil && experience.spatialImagingReference == reference ? .cyan : .gray)
                        .frame(minWidth: 70, minHeight: 50)
                    }
                    Button("Studies", systemImage: "square.grid.2x2") {
                        referencePickerVisible = true
                    }.buttonStyle(.bordered).frame(minHeight: 50)
                        .accessibilityLabel("All imaging studies")
                    Button("Gallery", systemImage: "rectangle.grid.3x2") {
                        experience.openReferenceWorkspace(.imagingGallery)
                    }.buttonStyle(.bordered).frame(minHeight: 50)
                    Spacer(minLength: 0)
                }
                .lineLimit(1)
                // Import and comparison remain in Study tools. Four concise
                // destinations leave the raster primary without wrapped labels.
                .accessibilityLabel("Imaging studies and controls")
            }
            if showsStudyTools && !isMarking {
                if !isReadingTermNote,
                   experience.spatialImagingLocalImageData == nil {
                    referenceSelectionControls
                }

                if !isChoosingStudy && !isReadingTermNote {
                    localImageImportControl
                }

                if !isChoosingStudy && !isReadingTermNote,
                   experience.spatialImagingLocalImageData != nil {
                    localImagingModalityControls
                }

                if !isChoosingStudy && !isReadingTermNote,
                   experience.spatialImagingLocalComparisonImageData != nil {
                    Button {
                        experience.toggleSpatialImagingComparisonSeparation()
                    } label: {
                        Label(
                            experience.spatialImagingComparisonDetached
                                ? "REJOIN SIDE BY SIDE"
                                : "SEPARATE INTO SPACE",
                            systemImage: experience.spatialImagingComparisonDetached
                                ? "rectangle.split.2x1"
                                : "rectangle.on.rectangle.angled"
                        )
                        .font(.caption.weight(.black))
                        .tracking(0.55)
                        .frame(maxWidth: .infinity, minHeight: 46)
                    }
                    .buttonStyle(.bordered)
                    .tint(.cyan)
                    .accessibilityHint(
                        experience.spatialImagingComparisonDetached
                            ? "Returns Local B to the side-by-side comparison board"
                            : "Places Local B as a second independently movable plate"
                    )
                }
            }

            if isReadingTermNote {
                // The term note already names its source and owns the local
                // return. Do not put that card inside another card or repeat
                // the outer Back instruction: the persistent top-bar Back is
                // the global exit from this reading state.
                StrokeTeachingImagingReferenceDetails(
                    reference: experience.spatialImagingReference,
                    onReturnToStudy: {
                        closeTermNote()
                    }
                )
                .frame(maxWidth: 440, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Technical term source note")
                .accessibilityHint("Back to study returns to the selected teaching image. Back exits the image and returns to the brain explanation.")
            } else if !isChoosingStudy {
                ZStack {
                    if let image = experience.spatialImagingGalleryRaster {
                        GeometryReader { geometry in
                            let fit = StrokeImagingImageFit.rect(image: image.size, viewport: geometry.size)
                            ZStack {
                                Image(uiImage: image).resizable().interpolation(.high).scaledToFit()
                                StrokeSpatialImagingInkLayer(useStraightSegments: true)
                            }
                            .frame(width: fit.width, height: fit.height)
                            .position(x: fit.midX, y: fit.midY)
                        }
                    } else {
                        teachingGraphic
                        StrokeSpatialImagingInkLayer()
                    }
                    if let anchor = experience.spatialImagingPrimaryContextAnchor {
                        StrokeSpatialImagingDiscussionMarker(
                            plateLabel: "A",
                            anchor: displayedContextAnchor(anchor, comparison: false)
                        ) { point in
                            experience.moveSpatialImagingPointContextAnchor(
                                to: localContextAnchor(point, comparison: false),
                                comparison: false
                            )
                        }
                    }
                    if joinedLocalComparison,
                       let anchor = experience.spatialImagingComparisonContextAnchor {
                        StrokeSpatialImagingDiscussionMarker(
                            plateLabel: "B",
                            anchor: displayedContextAnchor(anchor, comparison: true)
                        ) { point in
                            experience.moveSpatialImagingPointContextAnchor(
                                to: localContextAnchor(point, comparison: true),
                                comparison: true
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: imageMinimumHeight)
                    .background(.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 22))
                    .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.cyan.opacity(0.30)))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    // The image behaves like a physical plate until annotation is
                    // armed. Once armed, the same direct pinch-drag belongs to the
                    // ink layer, so movement cannot accidentally shift the scan.
                    .simultaneousGesture(
                        plateDragGesture,
                        including: isMarking ? .none : .all
                    )
                    .simultaneousGesture(plateMagnifyGesture, including: isMarking ? .none : .all)
                    .overlay(alignment: .bottomLeading) {
                        if let title = experience.spatialImagingPrimaryContextTitle,
                           let body = experience.spatialImagingPrimaryContextBody {
                            StrokeSpatialImagingPointContextCard(
                                plateLabel: "LOCAL A",
                                title: title,
                                message: body
                            )
                            .frame(maxWidth: 280)
                            .padding(12)
                            .allowsHitTesting(false)
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        if joinedLocalComparison,
                           let title = experience.spatialImagingComparisonContextTitle,
                           let body = experience.spatialImagingComparisonContextBody {
                            StrokeSpatialImagingPointContextCard(
                                plateLabel: "LOCAL B",
                                title: title,
                                message: body
                            )
                            .frame(maxWidth: 250)
                            .padding(12)
                            .allowsHitTesting(false)
                        }
                    }

                HStack(spacing: 8) {
                    Button {
                        experience.toggleSpatialImagingAnnotation()
                    } label: {
                        Label(
                            experience.spatialImagingAnnotationEnabled ? "Done" : "Annotate scan",
                            systemImage: experience.spatialImagingAnnotationEnabled
                                ? "checkmark.circle.fill"
                                : "pencil.tip.crop.circle"
                        )
                        .font(.caption.weight(.bold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(experience.spatialImagingAnnotationEnabled ? .orange : .cyan)
                    .accessibilityLabel(
                        experience.spatialImagingAnnotationEnabled
                            ? "Finish annotating scan"
                            : "Annotate scan"
                    )
                    .accessibilityHint(
                        experience.spatialImagingAnnotationEnabled
                            ? "Pinch to finish marking and restore image movement"
                            : "Pinch, then pinch-drag directly on the teaching image to mark it"
                    )

                    if isMarking && !experience.spatialImagingInkStrokes.isEmpty {
                        Button("Undo", systemImage: "arrow.uturn.backward") {
                            experience.undoSpatialImagingInk()
                        }
                        .buttonStyle(.bordered)

                        Button("Clear", systemImage: "eraser") {
                            experience.clearSpatialImagingInk()
                        }
                        .buttonStyle(.bordered)
                    }

                    if showsStudyTools && !isMarking {
                        Button {
                            if experience.spatialImagingPrimaryContextTitle == nil {
                                experience.attachSelectedPointContextToSpatialImaging(comparison: false)
                            } else {
                                experience.clearSpatialImagingPointContext(comparison: false)
                            }
                        } label: {
                            Label(
                                experience.spatialImagingPrimaryContextTitle == nil
                                    ? "Attach point"
                                    : "Remove prompt",
                                systemImage: experience.spatialImagingPrimaryContextTitle == nil
                                    ? "point.topleft.down.to.point.bottomright.curvepath"
                                    : "text.badge.minus"
                            )
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.bordered)
                        .disabled(
                            experience.spatialImagingLocalImageData == nil ||
                            (experience.selectedPointEntityName == nil && experience.spatialImagingPrimaryContextTitle == nil)
                        )
                        .accessibilityLabel(
                            experience.spatialImagingPrimaryContextTitle == nil
                                ? "Attach selected point discussion prompt to Local A"
                                : "Remove discussion prompt from Local A"
                        )
                    }

                    Spacer()

                    Text(
                        experience.spatialImagingAnnotationEnabled
                            ? "Pinch-drag to mark · Done to move the image"
                            : "Grab the scan to move · two-hand pinch to resize"
                    )
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(
                            experience.spatialImagingAnnotationEnabled
                                ? Color.orange
                            : Color.white.opacity(0.48)
                        )

                    if !isMarking {
                        Button(
                            experience.spatialImagingFocusActive ? "Place beside brain" : "Focus",
                            systemImage: experience.spatialImagingFocusActive
                                ? "arrow.down.right.and.arrow.up.left"
                                : "arrow.up.left.and.arrow.down.right"
                        ) {
                            StrokeImagingInteractionTrace.record(.focusButton)
                            experience.toggleSpatialImagingFocus()
                        }
                        .buttonStyle(.bordered)
                        .tint(.cyan)
                        .accessibilityIdentifier("stroke-imaging-focus")
                        .accessibilityLabel(
                            experience.spatialImagingFocusActive
                                ? "Return beside brain"
                                : "Focus image in room"
                        )
                        .accessibilityHint(
                            experience.spatialImagingFocusActive
                                ? "Restores the image's previous position and size beside the brain"
                                : "Brings this actual placed image forward for reading without opening another window"
                        )
                    }
                }

                HStack(alignment: .bottom, spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(
                            experience.spatialImagingGalleryImage?.name ?? experience.spatialImagingLocalImageName
                                ?? experience.spatialImagingReference.title
                        )
                            .font(.callout.weight(.bold))
                        Text(pointCaption)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.68))
                        Text("Generic teaching reference · not a patient scan")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.orange.opacity(0.82))
                            .accessibilityLabel("Open research atlas · not a patient scan, finding, or result")
                        if let localImageStatus {
                            Text(localImageStatus)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(
                                    experience.spatialImagingLocalImageData == nil
                                        ? Color.orange
                                        : Color.cyan
                                )
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(17)
        // The study deck is its own short, vertical index. Do not leave a
        // large empty card below it or repeat the same navigation instructions
        // in a second panel.
        .frame(
            width: experience.spatialImagingFocusActive ? 900 : 700,
            height: isChoosingStudy ? 640 : (isReadingTermNote ? 470 : (showsStudyTools ? 700 : (experience.spatialImagingFocusActive ? 690 : 620)))
        )
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white.opacity(0.14)))
        .preferredColorScheme(.dark)
        .onAppear {
            StrokeImagingInteractionTrace.record(.ready)
            // The deterministic term-note route follows the same reading
            // transition as a deliberate pinch, rather than proving a tiny
            // side card that is different from the real interaction.
            if referenceDetailsVisible,
               !experience.spatialImagingFocusActive,
               !termNoteIntroducedFocus {
                experience.toggleSpatialImagingFocus()
                termNoteIntroducedFocus = true
            }
            runImagingReturnReopenProofIfNeeded()
            runImagingTermReturnReopenProofIfNeeded()
        }
        .onChange(of: experience.spatialImagingPlateVisible) { _, isVisible in
            // Outer Back hides the plate through shared experience state. Do
            // not retain any local surface that could reappear the next time
            // a presenter opens a different generic teaching study.
            if !isVisible {
                resetLocalImagingSurface()
            }
        }
        .accessibilityElement(children: .contain)
        .confirmationDialog(
            localImageImportTarget == .primary
                ? "Choose a local teaching image?"
                : "Choose a local comparison image?",
            isPresented: $localImageDisclosureVisible,
            titleVisibility: .visible
        ) {
            Button(
                localImageImportTarget == .primary
                    ? "Choose de-identified primary image"
                    : "Choose de-identified comparison image"
            ) {
                presentLocalImageImporter()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Use PNG, JPEG, or HEIC only. Review identifiers first. The image stays in memory, is not uploaded, and is not interpreted by the app.")
        }
        .fileImporter(
            isPresented: $localImageImporterVisible,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false,
            onCompletion: importLocalImage
        )
    }

    private var plateDragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                    experience.beginSpatialImagingPlateDrag()
                }
                experience.moveSpatialImagingPlate(translation: value.translation)
            }
            .onEnded { _ in
                isDragging = false
                experience.endSpatialImagingPlateDrag()
            }
    }

    private var plateMagnifyGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                if !isResizing {
                    isResizing = true
                    experience.beginSpatialImagingPlateScale()
                }
                experience.scaleSpatialImagingPlate(by: value.magnification)
            }
            .onEnded { _ in
                isResizing = false
                experience.endSpatialImagingPlateScale()
            }
    }

    /// A compact, pinch-open study deck keeps the image surface quiet. It is
    /// deliberately an in-place spatial control rather than a system menu, so
    /// the presenter always sees both the selected study and the way back.
    private var referenceSelectionControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Give the study, explanation, and comparison actions their own
            // vertical rows. At room scale these are easier to scan than a
            // repeated horizontal button strip, and each keeps a generous
            // target without turning the image itself into a dashboard.
            VStack(alignment: .leading, spacing: 8) {
                Button {
                    referencePickerVisible.toggle()
                } label: {
                    Label(
                        referencePickerVisible
                            ? "Close study deck"
                            : "STUDY · \(experience.spatialImagingReference.rawValue)",
                        systemImage: referencePickerVisible
                            ? "chevron.up.circle.fill"
                            : experience.spatialImagingReference.systemImage
                    )
                    .font(.caption.weight(.black))
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
                .buttonStyle(.bordered)
                .tint(.cyan)
                .accessibilityLabel(
                    referencePickerVisible
                        ? "Close teaching study deck"
                        : "Teaching study, \(experience.spatialImagingReference.rawValue)"
                )
                .accessibilityHint(
                    referencePickerVisible
                        ? "Keeps the current teaching reference and returns to its image tools"
                        : "Pinch to open the CT, CTA, MRI, MRA, PET, and vessel-map study deck"
                )

                if !referencePickerVisible {
                    Button {
                        referencePickerVisible = false
                        if referenceDetailsVisible {
                            closeTermNote()
                        } else {
                            openTermNote()
                        }
                    } label: {
                        Label(
                            referenceDetailsVisible
                                ? "Back to study"
                                : experience.spatialImagingReference.technicalTerm,
                            systemImage: referenceDetailsVisible
                                ? "chevron.backward"
                                : "text.magnifyingglass"
                        )
                        .font(.caption.weight(.bold))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }
                    .buttonStyle(.bordered)
                    .tint(referenceDetailsVisible ? .orange : .gray)
                    .accessibilityHint(
                        referenceDetailsVisible
                            ? "Pinch to return this image beside the brain with its selected teaching study"
                            : "Pinch the technical term to bring this teaching image forward with plainer language and its named source"
                    )

                    Button {
                        experience.toggleSpatialImagingComparison()
                    } label: {
                        Label("CT + MRI", systemImage: "rectangle.split.2x1")
                            .font(.caption.weight(.bold))
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }
                    .buttonStyle(.bordered)
                    .tint(experience.spatialImagingComparisonEnabled ? .orange : .gray)
                    .accessibilityLabel("Compare CT and MRI teaching templates")
                    .accessibilityHint("Shows the two bundled atlas templates side by side")
                }
            }

            if referencePickerVisible {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text("STUDY DECK")
                            .font(.caption2.weight(.black))
                            .tracking(0.8)
                            .foregroundStyle(.cyan)
                        Spacer(minLength: 0)
                        Label("Current study", systemImage: experience.spatialImagingReference.systemImage)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white.opacity(0.74))
                        Text(experience.spatialImagingReference.rawValue)
                            .font(.caption.weight(.black))
                            .foregroundStyle(.cyan)
                    }

                    Text("Choose a teaching modality. Close: image tools; Back: brain explanation.")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.orange.opacity(0.86))
                        .fixedSize(horizontal: false, vertical: true)

                    // The fixed top-level Back remains outside this short
                    // scroll region. New studies can be added without pushing
                    // the only recovery path below the visible card.
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(StrokeTeachingImageDeckSection.allCases) { section in
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text(section.title)
                                            .font(.caption2.monospaced().weight(.black))
                                            .tracking(0.65)
                                            .foregroundStyle(.cyan.opacity(0.88))
                                        Text(section.summary)
                                            .font(.caption2.weight(.semibold))
                                            .foregroundStyle(.white.opacity(0.50))
                                    }

                                    ForEach(section.references) { reference in
                                        Button {
                                            let changed = experience.spatialImagingReference != reference
                                            experience.placeSpatialImagingPlate(reference)
                                            if changed { referenceDetailsVisible = false }
                                            referencePickerVisible = false
                                        } label: {
                                            HStack(spacing: 9) {
                                                Image(systemName: reference.systemImage)
                                                    .font(.caption.weight(.black))
                                                    .frame(width: 22)
                                                HStack(spacing: 6) {
                                                    Text(reference.rawValue)
                                                        .font(.caption.weight(.black))
                                                    Text(reference.deckCategory)
                                                        .font(.caption2.monospaced().weight(.black))
                                                        .tracking(0.45)
                                                        .foregroundStyle(.cyan.opacity(0.92))
                                                        .padding(.horizontal, 5)
                                                        .padding(.vertical, 2)
                                                        .background(.cyan.opacity(0.13), in: Capsule())
                                                    Spacer(minLength: 2)
                                                    Text(reference.deckSummary)
                                                        .font(.caption2.weight(.semibold))
                                                        .foregroundStyle(.white.opacity(0.54))
                                                        .lineLimit(1)
                                                }
                                                Spacer(minLength: 0)
                                                if experience.spatialImagingReference == reference {
                                                    Image(systemName: "checkmark.circle.fill")
                                                }
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 42, alignment: .leading)
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(experience.spatialImagingReference == reference ? .cyan : .gray)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 420)

                    Text("GENERIC TEACHING REFERENCES · NOT A PATIENT STUDY OR CARE CHOICE")
                        .font(.caption2.monospaced().weight(.semibold))
                        .foregroundStyle(.orange.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                        .padding(.top, 3)
                }
                .padding(8)
                .background(.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cyan.opacity(0.30)))
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Teaching study deck")
            }
        }
    }

    /// A deliberate reading action brings the same in-space study forward;
    /// it does not create a second floating window. The flag preserves a
    /// pre-existing presenter focus if they had already moved the image.
    private func openTermNote() {
        guard !referenceDetailsVisible else { return }
        if !experience.spatialImagingFocusActive {
            experience.toggleSpatialImagingFocus()
            termNoteIntroducedFocus = true
        }
        referenceDetailsVisible = true
    }

    private func closeTermNote() {
        guard referenceDetailsVisible else { return }
        referenceDetailsVisible = false
        if termNoteIntroducedFocus,
           experience.spatialImagingFocusActive {
            experience.toggleSpatialImagingFocus()
        }
        termNoteIntroducedFocus = false
    }

    /// The global Back action must clear this attachment's reading, picker,
    /// and import state before it hides the plate. Relying only on a later
    /// visibility callback risks a stale term note if a presenter reopens the
    /// same image quickly.
    private func returnToAnatomyFromPlate() {
        resetLocalImagingSurface()
        experience.returnToAnatomyFromSpatialImaging()
        StrokeImagingInteractionTrace.record(.returned)
    }

    private func resetLocalImagingSurface() {
        if let request = localImageImportRequest {
            experience.cancelSpatialImagingImport(request)
        }
        localImageImportRequest = nil
        referenceDetailsVisible = false
        termNoteIntroducedFocus = false
        referencePickerVisible = false
        studyToolsVisible = false
        localImageDisclosureVisible = false
        localImageImporterVisible = false
        localImageStatus = nil
        localImageImportTarget = .primary
    }

    /// Automation-only recovery receipt. Simulator command-line routes cannot
    /// pinch a visionOS attachment, so this opens the same visible study deck,
    /// invokes the same outer-Back state handler, then reopens the exact plate
    /// a presenter would return to. It never opens the system file picker.
    private func runImagingReturnReopenProofIfNeeded() {
        guard CommandLine.arguments.contains("--proof-imaging-return-reopen"),
              !returnReopenProofHasRun else { return }

        returnReopenProofHasRun = true
        Task { @MainActor in
            referencePickerVisible = true
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled,
                  experience.spatialImagingPlateVisible else { return }

            returnToAnatomyFromPlate()
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled else { return }

            experience.placeSpatialImagingPlate(.ctaGuide)
            experience.resetSpatialImagingPlateTransform()
        }
    }

    /// Automation-only receipt for the other recovery path a presenter can
    /// take: leaving a focused technical-term source note with the persistent
    /// global Back action, then reopening the same generic teaching image.
    /// Command-line Simulator routes cannot pinch the attachment, so this
    /// invokes the exact local handler owned by the visible Back button.
    private func runImagingTermReturnReopenProofIfNeeded() {
        guard CommandLine.arguments.contains("--proof-imaging-term-return-reopen"),
              !termReturnReopenProofHasRun else { return }

        termReturnReopenProofHasRun = true
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled,
                  referenceDetailsVisible,
                  experience.spatialImagingPlateVisible else { return }

            returnToAnatomyFromPlate()
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled else { return }

            experience.placeSpatialImagingPlate(.ctaGuide)
            experience.resetSpatialImagingPlateTransform()
        }
    }

    @ViewBuilder
    private var teachingGraphic: some View {
        if !experience.spatialImagingComparisonDetached,
           let primaryData = experience.spatialImagingLocalImageData,
           let comparisonData = experience.spatialImagingLocalComparisonImageData,
           let primaryImage = UIImage(data: primaryData),
           let comparisonImage = UIImage(data: comparisonData) {
            HStack(spacing: 2) {
                localTeachingImage(
                    primaryImage,
                    label: "LOCAL A",
                    modality: experience.spatialImagingLocalImageModality
                )
                localTeachingImage(
                    comparisonImage,
                    label: "LOCAL B",
                    modality: experience.spatialImagingLocalComparisonImageModality
                )
            }
            .overlay(alignment: .bottomTrailing) {
                Text("SIDE BY SIDE · NOT REGISTERED")
                    .font(.caption2.monospaced().weight(.black))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.76), in: Capsule())
                    .padding(10)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(
                "Two local teaching images side by side, memory only, not uploaded, interpreted, or registered"
            )
        } else if let data = experience.spatialImagingLocalImageData,
                  let image = UIImage(data: data) {
            ZStack {
                Color.black
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .padding(7)
            }
            .overlay(alignment: .topLeading) {
                Text(
                    experience.spatialImagingComparisonDetached
                        ? "LOCAL A · \(experience.spatialImagingLocalImageModality.rawValue.uppercased()) · MEMORY ONLY"
                        : "LOCAL IMAGE · \(experience.spatialImagingLocalImageModality.rawValue.uppercased()) · MEMORY ONLY"
                )
                    .font(.caption2.monospaced().weight(.black))
                    .tracking(0.7)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(.black.opacity(0.72), in: Capsule())
                    .padding(10)
            }
            .overlay(alignment: .bottomTrailing) {
                Text("NOT UPLOADED · NOT INTERPRETED")
                    .font(.caption2.monospaced().weight(.black))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.76), in: Capsule())
                    .padding(10)
            }
            .accessibilityLabel("Local teaching image, memory only, not uploaded or interpreted")
        } else if experience.spatialImagingComparisonEnabled {
            HStack(spacing: 2) {
                CTTeachingSchematic()
                MRITeachingSchematic()
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Side-by-side CT and MRI generic teaching templates")
        } else {
            switch experience.spatialImagingReference {
            case .vesselMap:
                VesselMapSchematic()
            case .ctGuide:
                CTTeachingSchematic()
            case .ctaGuide:
                CTATeachingSchematic()
            case .mriGuide:
                MRITeachingSchematic()
            case .mraGuide:
                MRATeachingSchematic()
            case .petOverview:
                PETTeachingSchematic()
            }
        }
    }

    private var pointCaption: String {
        if let image = experience.spatialImagingGalleryImage {
            return image.isLocal
                ? "\(experience.spatialImagingLocalImageModality.rawValue) · Local image · memory only"
                : "\(image.modality.rawValue) · Kaffenberger et al. · CC BY 4.0"
        }
        if let primaryName = experience.spatialImagingLocalImageName,
           let comparisonName = experience.spatialImagingLocalComparisonImageName {
            return "\(experience.spatialImagingLocalImageModality.rawValue) + \(experience.spatialImagingLocalComparisonImageModality.rawValue) · \(primaryName) + \(comparisonName) · not registered"
        }
        if let name = experience.spatialImagingLocalImageName {
            return "Local \(experience.spatialImagingLocalImageModality.rawValue) teaching image · \(name)"
        }
        if experience.spatialImagingComparisonEnabled {
            return "Side-by-side research templates · no patient registration"
        }
        if let label = experience.selectedPointLabel {
            return "Linked from point: \(label)"
        }
        return "Unlinked generic reference · select a point to add context"
    }

    private var joinedLocalComparison: Bool {
        !experience.spatialImagingComparisonDetached &&
        experience.spatialImagingLocalImageData != nil &&
        experience.spatialImagingLocalComparisonImageData != nil
    }

    /// Local A and B share one canvas while joined, so each normalized marker
    /// occupies only its own half. The stored point remains local to its image
    /// and is therefore stable when B is separated into space again.
    private func displayedContextAnchor(_ anchor: CGPoint, comparison: Bool) -> CGPoint {
        guard joinedLocalComparison else { return anchor }
        return CGPoint(
            x: comparison ? 0.5 + anchor.x * 0.5 : anchor.x * 0.5,
            y: anchor.y
        )
    }

    private func localContextAnchor(_ anchor: CGPoint, comparison: Bool) -> CGPoint {
        guard joinedLocalComparison else { return anchor }
        return CGPoint(
            x: comparison ? (anchor.x - 0.5) * 2 : anchor.x * 2,
            y: anchor.y
        )
    }

    private var localImageImportControl: some View {
        HStack(spacing: 8) {
            localImageSlotControl(target: .primary)
                .dropDestination(for: Data.self) { items, _ in
                    acceptDroppedImage(items.first, target: .primary)
                }

            if experience.spatialImagingLocalImageData != nil {
                localImageSlotControl(target: .comparison)
                    .dropDestination(for: Data.self) { items, _ in
                        acceptDroppedImage(items.first, target: .comparison)
                    }
            }
        }
    }

    private var localImagingModalityControls: some View {
        HStack(spacing: 8) {
            localImagingModalityControl(comparison: false)
            if experience.spatialImagingLocalComparisonImageData != nil {
                localImagingModalityControl(comparison: true)
            }
            Spacer(minLength: 4)
            Text("PRESENTER SELECTED · NOT INFERRED")
                .font(.caption2.monospaced().weight(.bold))
                .foregroundStyle(.orange.opacity(0.86))
        }
    }

    private func localImagingModalityControl(comparison: Bool) -> some View {
        let modality = comparison
            ? experience.spatialImagingLocalComparisonImageModality
            : experience.spatialImagingLocalImageModality
        let plate = comparison ? "B" : "A"

        return Button {
            experience.cycleSpatialImagingModality(comparison: comparison)
        } label: {
            Label("MODALITY \(plate) · \(modality.rawValue.uppercased())", systemImage: modality.systemImage)
                .font(.caption2.weight(.black))
                .tracking(0.35)
                .frame(minHeight: 42)
        }
        .buttonStyle(.bordered)
        .tint(.cyan)
        .accessibilityLabel("Local \(plate) modality, \(modality.rawValue), selected by presenter")
        .accessibilityHint("Pinch to cycle CT, MRI, X-ray, Other, and Unspecified")
    }

    private func localImageSlotControl(target: StrokeLocalImageImportTarget) -> some View {
        let isPrimary = target == .primary
        let isLoaded = isPrimary
            ? experience.spatialImagingLocalImageData != nil
            : experience.spatialImagingLocalComparisonImageData != nil
        let title: String = {
            if isPrimary { return isLoaded ? "REMOVE LOCAL A" : "CHOOSE OR DROP LOCAL A" }
            return isLoaded ? "REMOVE LOCAL B" : "ADD OR DROP LOCAL B"
        }()

        return Button {
            if isLoaded {
                if isPrimary {
                    experience.clearSpatialImagingLocalImage()
                    localImageStatus = "Both local images removed from memory"
                } else {
                    experience.clearSpatialImagingLocalComparisonImage()
                    localImageStatus = "Comparison image removed from memory"
                }
            } else {
                localImageImportTarget = target
                localImageDisclosureVisible = true
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isLoaded ? "photo.badge.minus" : "photo.badge.plus")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.caption2.weight(.black))
                        .tracking(0.45)
                    Text("24 MB max · memory only")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 4)
                Text(isLoaded ? "LOADED" : "NO UPLOAD")
                    .font(.caption2.monospaced().weight(.bold))
                    .foregroundStyle(.cyan)
            }
            .padding(.horizontal, 11)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 5]))
                    .foregroundStyle(Color.cyan.opacity(0.42))
            )
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .accessibilityLabel(title.lowercased())
    }

    private func presentLocalImageImporter() {
        guard let request = experience.beginSpatialImagingImport(target: localImageImportTarget) else { return }
        localImageImportRequest = request
        localImageImporterVisible = true
    }

    private func importLocalImage(_ result: Result<[URL], Error>) {
        // Capture the request before any asynchronous work. Back, another
        // study, a new import, or a role change invalidates it in shared state.
        guard let request = localImageImportRequest,
              experience.isCurrentSpatialImagingImport(request) else { return }
        localImageImportRequest = nil
        switch result {
        case .failure:
            experience.cancelSpatialImagingImport(request)
            localImageStatus = "Image selection was cancelled or unavailable"
        case .success(let urls):
            guard let url = urls.first else {
                experience.cancelSpatialImagingImport(request)
                localImageStatus = "No image selected"
                return
            }
            Task { @MainActor in
                do {
                    let payload = try await Task.detached(priority: .userInitiated) {
                        let accessGranted = url.startAccessingSecurityScopedResource()
                        defer {
                            if accessGranted { url.stopAccessingSecurityScopedResource() }
                        }
                        let values = try url.resourceValues(forKeys: [.fileSizeKey])
                        if let byteCount = values.fileSize,
                           byteCount > StrokeExperienceState.spatialImagingImportByteLimit {
                            throw CocoaError(.fileReadTooLarge)
                        }
                        return try Data(contentsOf: url, options: .mappedIfSafe)
                    }.value
                    guard experience.isCurrentSpatialImagingImport(request) else { return }
                    let accepted = experience.completeSpatialImagingImport(
                        request,
                        data: payload,
                        displayName: url.lastPathComponent
                    )
                    localImageStatus = accepted
                        ? "Loaded locally · cleared when this teaching view closes"
                        : "Could not read image · use PNG, JPEG, or HEIC under 24 MB"
                } catch {
                    guard experience.isCurrentSpatialImagingImport(request) else { return }
                    experience.cancelSpatialImagingImport(request)
                    localImageStatus = "Could not load this image locally"
                }
            }
        }
    }

    private func acceptDroppedImage(
        _ data: Data?,
        target: StrokeLocalImageImportTarget
    ) -> Bool {
        guard let data,
              let request = experience.beginSpatialImagingImport(target: target) else { return false }
        let accepted = experience.completeSpatialImagingImport(
            request,
            data: data,
            displayName: target == .primary
                ? "Dropped local teaching image A"
                : "Dropped local teaching image B"
        )
        localImageStatus = accepted
            ? "Loaded locally · cleared when this teaching view closes"
            : "Could not read image · use PNG, JPEG, or HEIC under 24 MB"
        return accepted
    }

    private func localTeachingImage(
        _ image: UIImage,
        label: String,
        modality: StrokeImagingModality
    ) -> some View {
        ZStack {
            Color.black
            Image(uiImage: image)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .padding(5)
        }
        .overlay(alignment: .topLeading) {
            Text("\(label) · \(modality.rawValue.uppercased()) · MEMORY ONLY")
                .font(.caption.monospaced().weight(.black))
                .tracking(0.5)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(.black.opacity(0.72), in: Capsule())
                .padding(8)
        }
    }
}

private struct StrokeSpatialImagingPointContextCard: View {
    let plateLabel: String
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("DISCUSSION PROMPT · \(plateLabel)")
                .font(.caption2.monospaced().weight(.black))
                .tracking(0.5)
                .foregroundStyle(.cyan)
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
            Text(message)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.82))
                .lineLimit(2)
            Text("MANUAL MARKER · FROM SELECTED POINT · NOT AN IMAGE FINDING")
                .font(.caption2.monospaced().weight(.black))
                .foregroundStyle(.orange)
        }
        .padding(10)
        .background(.black.opacity(0.84), in: RoundedRectangle(cornerRadius: 13))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.cyan.opacity(0.38)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Discussion prompt from selected teaching point, \(title). Not an image finding. \(message)"
        )
    }
}

/// A small direct-manipulation target that a clinician deliberately places on
/// a local raster. It does not use gaze coordinates or infer correspondence;
/// the larger invisible hit area simply makes the visible dot pinchable.
private struct StrokeSpatialImagingDiscussionMarker: View {
    let plateLabel: String
    let anchor: CGPoint
    let onMove: (CGPoint) -> Void

    @State private var dragOrigin: CGPoint?

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .fill(.black.opacity(0.86))
                    .frame(width: 27, height: 27)
                Circle()
                    .stroke(.cyan, lineWidth: 3)
                    .frame(width: 27, height: 27)
                Text(plateLabel)
                    .font(.caption2.monospaced().weight(.black))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
            .contentShape(Circle())
            .position(
                x: anchor.x * proxy.size.width,
                y: anchor.y * proxy.size.height
            )
            .hoverEffect(.highlight)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let origin = dragOrigin ?? anchor
                        if dragOrigin == nil { dragOrigin = anchor }
                        onMove(
                            CGPoint(
                                x: min(
                                    0.96,
                                    max(0.04, origin.x + value.translation.width / max(proxy.size.width, 1))
                                ),
                                y: min(
                                    0.94,
                                    max(0.06, origin.y + value.translation.height / max(proxy.size.height, 1))
                                )
                            )
                        )
                    }
                    .onEnded { _ in
                        dragOrigin = nil
                    }
            )
            .accessibilityLabel("Manual discussion marker (plateLabel)")
            .accessibilityHint("Pinch and drag to place. This is not an image finding or registration.")
        }
    }
}

/// Local B can be separated from the comparison board and placed as its own
/// view-facing teaching object. It remains memory-only and deliberately has
/// no registration tether or inferred correspondence to Local A or anatomy.
private struct StrokeSpatialImagingComparisonPlate: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var isDragging = false
    @State private var isResizing = false

    var body: some View {
        let isMarking = experience.spatialImagingAnnotationEnabled
        VStack(alignment: .leading, spacing: 11) {
            HStack(spacing: 9) {
                Label("LOCAL B · INDEPENDENT PLATE", systemImage: "rectangle.on.rectangle.angled")
                    .font(.caption.weight(.black))
                    .tracking(0.6)
                    .foregroundStyle(.cyan)
                Spacer()
                if !isMarking {
                    Text("\(Int((experience.spatialImagingComparisonPlateScale * 100).rounded()))%")
                        .font(.caption2.monospacedDigit().weight(.bold))
                        .foregroundStyle(.cyan)
                    Button("Rejoin", systemImage: "rectangle.split.2x1") {
                        experience.toggleSpatialImagingComparisonSeparation()
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Rejoin Local B with Local A")
                }
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
            .gesture(plateDragGesture, including: isMarking ? .none : .all)
            .simultaneousGesture(plateMagnifyGesture, including: isMarking ? .none : .all)

            ZStack {
                Color.black
                if let data = experience.spatialImagingLocalComparisonImageData,
                   let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                        .padding(7)
                }
                StrokeSpatialImagingComparisonInkLayer()
                if let anchor = experience.spatialImagingComparisonContextAnchor {
                    StrokeSpatialImagingDiscussionMarker(
                        plateLabel: "B",
                        anchor: anchor
                    ) { point in
                        experience.moveSpatialImagingPointContextAnchor(
                            to: point,
                            comparison: true
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 255)
            .background(.black.opacity(0.84), in: RoundedRectangle(cornerRadius: 21))
            .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color.cyan.opacity(0.34)))
            .clipShape(RoundedRectangle(cornerRadius: 21))
            .simultaneousGesture(
                plateDragGesture,
                including: isMarking ? .none : .all
            )
            .simultaneousGesture(plateMagnifyGesture, including: isMarking ? .none : .all)
            .overlay(alignment: .topLeading) {
                Text(
                    "LOCAL B · \(experience.spatialImagingLocalComparisonImageModality.rawValue.uppercased()) · MEMORY ONLY"
                )
                    .font(.caption.monospaced().weight(.black))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.74), in: Capsule())
                    .padding(10)
                    .allowsHitTesting(false)
            }
            .overlay(alignment: .bottomTrailing) {
                Text("NOT REGISTERED")
                    .font(.caption.monospaced().weight(.black))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.78), in: Capsule())
                    .padding(10)
                    .allowsHitTesting(false)
            }
            .overlay(alignment: .bottomLeading) {
                if let title = experience.spatialImagingComparisonContextTitle,
                   let body = experience.spatialImagingComparisonContextBody {
                    StrokeSpatialImagingPointContextCard(
                        plateLabel: "LOCAL B",
                        title: title,
                        message: body
                    )
                    .frame(maxWidth: 245)
                    .padding(10)
                    .allowsHitTesting(false)
                }
            }

            HStack(spacing: 8) {
                Button {
                    experience.toggleSpatialImagingAnnotation()
                } label: {
                    Label(
                        experience.spatialImagingAnnotationEnabled ? "Done B" : "Annotate B",
                        systemImage: experience.spatialImagingAnnotationEnabled
                            ? "checkmark.circle.fill"
                            : "pencil.tip.crop.circle"
                    )
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                }
                .buttonStyle(.borderedProminent)
                .tint(experience.spatialImagingAnnotationEnabled ? .orange : .cyan)
                .accessibilityLabel(
                    experience.spatialImagingAnnotationEnabled
                        ? "Finish annotating comparison image"
                        : "Annotate comparison image"
                )
                .accessibilityHint(
                    experience.spatialImagingAnnotationEnabled
                        ? "Pinch to finish marking comparison image"
                        : "Pinch, then pinch-drag directly on the comparison image to mark it"
                )

                Button("Undo B", systemImage: "arrow.uturn.backward") {
                    experience.undoSpatialImagingComparisonInk()
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                .disabled(experience.spatialImagingComparisonInkStrokes.isEmpty)

                Button("Clear B", systemImage: "eraser") {
                    experience.clearSpatialImagingComparisonInk()
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                .disabled(experience.spatialImagingComparisonInkStrokes.isEmpty)

                Button {
                    if experience.spatialImagingComparisonContextTitle == nil {
                        experience.attachSelectedPointContextToSpatialImaging(comparison: true)
                    } else {
                        experience.clearSpatialImagingPointContext(comparison: true)
                    }
                } label: {
                    Label(
                        experience.spatialImagingComparisonContextTitle == nil
                            ? "Attach point to B"
                            : "Remove prompt from B",
                        systemImage: experience.spatialImagingComparisonContextTitle == nil
                            ? "point.topleft.down.to.point.bottomright.curvepath"
                            : "text.badge.minus"
                    )
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                .disabled(
                    experience.selectedPointEntityName == nil &&
                    experience.spatialImagingComparisonContextTitle == nil
                )
                .accessibilityLabel(
                    experience.spatialImagingComparisonContextTitle == nil
                        ? "Attach selected point discussion prompt to Local B"
                        : "Remove discussion prompt from Local B"
                )

                Spacer()
                Text(isMarking ? "Marking image · Done B to move" : "Drag · resize · mark")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.58))
            }

            Text("Independent comparison · no pixel or anatomy registration")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.orange.opacity(0.86))
        }
        .padding(16)
        .frame(width: 460, height: 500)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 25))
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.14)))
        .accessibilityElement(children: .contain)
        .accessibilityLabel(
            "Local comparison image B, independently movable, memory only, not uploaded, interpreted, or registered"
        )
    }

    private var plateDragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                    experience.beginSpatialImagingComparisonPlateDrag()
                }
                experience.moveSpatialImagingComparisonPlate(translation: value.translation)
            }
            .onEnded { _ in
                isDragging = false
                experience.endSpatialImagingComparisonPlateDrag()
            }
    }

    private var plateMagnifyGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                if !isResizing {
                    isResizing = true
                    experience.beginSpatialImagingComparisonPlateScale()
                }
                experience.scaleSpatialImagingComparisonPlate(by: value.magnification)
            }
            .onEnded { _ in
                isResizing = false
                experience.endSpatialImagingComparisonPlateScale()
            }
    }
}

/// Temporary ink is drawn directly over the placed image rather than on a
/// detached overlay. The normalized mark follows the card when it is moved.
private struct StrokeSpatialImagingInkLayer: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var isDrawing = false
    var useStraightSegments = false

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                for stroke in experience.spatialImagingInkStrokes where !stroke.points.isEmpty {
                    var path = Path()
                    let points = stroke.points.map {
                        CGPoint(x: $0.x * size.width, y: $0.y * size.height)
                    }
                    path.move(to: points[0])
                    if useStraightSegments {
                        for point in points.dropFirst() { path.addLine(to: point) }
                    } else if points.count == 2 {
                        path.addLine(to: points[1])
                    } else if points.count > 2 {
                        for index in 1..<(points.count - 1) {
                            let control = points[index]
                            let next = points[index + 1]
                            path.addQuadCurve(
                                to: CGPoint(
                                    x: (control.x + next.x) * 0.5,
                                    y: (control.y + next.y) * 0.5
                                ),
                                control: control
                            )
                        }
                        path.addLine(to: points[points.count - 1])
                    }
                    context.stroke(
                        path,
                        with: .color(.black.opacity(0.54)),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                    )
                    context.stroke(
                        path,
                        with: .color(.orange.opacity(0.98)),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .contentShape(Rectangle())
            .allowsHitTesting(experience.spatialImagingAnnotationEnabled)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = normalized(value.location, in: proxy.size)
                        if !isDrawing {
                            isDrawing = true
                            experience.beginSpatialImagingInk(at: point)
                        } else {
                            experience.continueSpatialImagingInk(at: point)
                        }
                    }
                    .onEnded { value in
                        experience.endSpatialImagingInk(
                            at: normalized(value.location, in: proxy.size)
                        )
                        isDrawing = false
                    }
            )
            .overlay(alignment: .bottomLeading) {
                if experience.spatialImagingAnnotationEnabled {
                    Text("GENERIC TEACHING MARKUP · NOT A MEASUREMENT")
                        .font(.caption2.monospaced().weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.76), in: Capsule())
                        .padding(10)
                        .allowsHitTesting(false)
                }
            }
        }
        .accessibilityLabel("Annotation layer on the generic teaching scan")
        .accessibilityHint("Turn on Annotate scan, then pinch and drag to draw. Finish marking to move the scan again")
    }

    private func normalized(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(1, max(0, point.x / max(size.width, 1))),
            y: min(1, max(0, point.y / max(size.height, 1)))
        )
    }
}

private struct StrokeSpatialImagingComparisonInkLayer: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var isDrawing = false

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                for stroke in experience.spatialImagingComparisonInkStrokes where !stroke.points.isEmpty {
                    var path = Path()
                    let points = stroke.points.map {
                        CGPoint(x: $0.x * size.width, y: $0.y * size.height)
                    }
                    path.move(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    context.stroke(
                        path,
                        with: .color(.black.opacity(0.54)),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                    )
                    context.stroke(
                        path,
                        with: .color(.orange.opacity(0.98)),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .contentShape(Rectangle())
            .allowsHitTesting(experience.spatialImagingAnnotationEnabled)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = normalized(value.location, in: proxy.size)
                        if !isDrawing {
                            isDrawing = true
                            experience.beginSpatialImagingComparisonInk(at: point)
                        } else {
                            experience.continueSpatialImagingComparisonInk(at: point)
                        }
                    }
                    .onEnded { value in
                        experience.endSpatialImagingComparisonInk(
                            at: normalized(value.location, in: proxy.size)
                        )
                        isDrawing = false
                    }
            )
            .overlay(alignment: .bottomLeading) {
                if experience.spatialImagingAnnotationEnabled {
                    Text("TEACHING MARKUP · NOT A MEASUREMENT")
                        .font(.caption2.monospaced().weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.76), in: Capsule())
                        .padding(10)
                        .allowsHitTesting(false)
                }
            }
        }
        .accessibilityLabel("Annotation layer on local comparison image B")
        .accessibilityHint("Turn on Annotate B, then pinch and drag to draw")
    }

    private func normalized(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(1, max(0, point.x / max(size.width, 1))),
            y: min(1, max(0, point.y / max(size.height, 1)))
        )
    }
}

private struct StrokeTeachingImagingDrawer: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.openWindow) private var openWindow
    @Environment(RBCJourneyModel.self) private var internalJourney

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 8) {
                if let selectedPointLabel = experience.selectedPointLabel {
                    Group {
                        if isFamilyArterialReference {
                            // The nearby lesson card already names the selected
                            // example. The secondary field should identify its
                            // role, not repeat that point label a second time.
                            Text("ARTERIAL PATH · 3D TEACHING MODEL")
                        } else if let selectedAtlasSurfaceChapter {
                            Text("FROM BRAIN SURFACE · \(selectedAtlasSurfaceChapter.title.uppercased())")
                        } else {
                            Text("FROM \(isCombinedInternalChapter ? "CHAPTER" : "POINT") · \(selectedPointLabel.uppercased())")
                        }
                    }
                    .font(.caption2.monospaced().weight(.semibold))
                    .tracking(0.55)
                    .foregroundStyle(.white.opacity(0.58))
                    .lineLimit(1)
                }

                Spacer(minLength: 8)

                Button {
                    experience.toggleSelectedPointReference()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.black))
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
                .accessibilityLabel("Hide 3D teaching reference")
                .accessibilityHint("Keeps the selected anatomy point and hides its secondary teaching model")
            }

            if isFamilyArterialReference {
                familyArterialReferenceSummary
                vesselRouteControls
            } else if experience.audienceLens == .family {
                Text("WHAT THIS OPENS")
                    .font(.caption2.monospaced().weight(.black))
                    .tracking(0.7)
                    .foregroundStyle(referenceTint.opacity(0.82))

                Text(referenceTitle)
                    .font(.callout.weight(.black))
                    .foregroundStyle(.white)

                Text(experience.teachingReferencePlainSummary())
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(referenceTitle)
                    .font(.caption2.monospaced().weight(.black))
                    .tracking(0.8)
                    .foregroundStyle(referenceTint)

                HStack(spacing: 5) {
                    Text(isCombinedInternalChapter ? "CHAPTER" : "POINT")
                        .font(.caption2.monospaced().weight(.black))
                    Image(systemName: "arrow.right")
                        .font(.caption2.weight(.black))
                    Text(isCombinedInternalChapter ? "COMBINED 3D CONTEXT" : "FULL 3D STRUCTURE")
                        .font(.caption2.monospaced().weight(.black))
                }
                .foregroundStyle(referenceTint.opacity(0.92))

                Text(experience.teachingReferenceRelationship())
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !isFamilyArterialReference {
                Text(referenceBoundary)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.68))

                if experience.pointField == .procedure {
                    vesselRouteControls
                }
            }

            if experience.audienceLens == .clinician {
                Button("Open 2D reference", systemImage: "rectangle.on.rectangle") {
                    experience.placeSpatialImagingPlate(.ctGuide)
                    if !experience.spatialImagingFocusActive { experience.toggleSpatialImagingFocus() }
                }
                .buttonStyle(.bordered)
                .tint(referenceTint)
                .accessibilityHint("Opens a moveable generic teaching schematic, not a patient image")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(referenceTint.opacity(0.34), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
    }

    private func routeStepButton(
        systemImage: String,
        label: String,
        offset: Int
    ) -> some View {
        Button {
            experience.traceProcedureRoute(by: offset)
        } label: {
            Image(systemName: systemImage)
                .font(.callout.weight(.black))
                .frame(width: 48, height: 48)
                .background(.white.opacity(0.08), in: Circle())
                .overlay(Circle().stroke(.orange.opacity(0.34), lineWidth: 1))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .accessibilityLabel(label)
        .accessibilityHint("Changes the selected relationship in the same generic arterial teaching model")
    }

    /// The family arterial reference is intentionally a compact orienting cue,
    /// because the 3D arterial tree and its motion markers carry the lesson.
    /// It avoids a duplicate point explanation while preserving the clear
    /// generic-model boundary beside the spatial object.
    private var familyArterialReferenceSummary: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Follow the orange cue from a larger artery into smaller branches.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.84))
                .fixedSize(horizontal: false, vertical: true)

            Text("GENERIC TEACHING MODEL · NOT A PATIENT SCAN")
                .font(.caption2.monospaced().weight(.bold))
                .tracking(0.28)
                .foregroundStyle(.white.opacity(0.56))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
    }

    /// One reusable route affordance keeps the active vascular relationship
    /// explorable without adding another tab or overlay. Its copy avoids
    /// technical simulation language: the animated cue is illustrative only.
    private var vesselRouteControls: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(
                isFamilyArterialReference
                    ? "ROUTE ONLY · NOT A MEASUREMENT"
                    : "QUALITATIVE ROUTE · NOT A MEASUREMENT"
            )
                .font(.caption2.monospaced().weight(.semibold))
                .tracking(0.32)
                .foregroundStyle(.orange.opacity(0.78))

            HStack(spacing: 8) {
                routeStepButton(
                    systemImage: "chevron.left",
                    label: "Previous vessel relationship",
                    offset: -1
                )

                VStack(spacing: 1) {
                    Text("ROUTE")
                        .font(.caption2.monospaced().weight(.black))
                        .tracking(0.45)
                    Text(experience.procedureRouteProgressLabel)
                        .font(.caption2.monospacedDigit().weight(.semibold))
                        .foregroundStyle(.white.opacity(0.62))
                }
                .frame(maxWidth: .infinity)

                routeStepButton(
                    systemImage: "chevron.right",
                    label: "Next vessel relationship",
                    offset: 1
                )
            }
            .foregroundStyle(.orange)

            if experience.selectedPointEntityName == "\(StrokePointField.procedure.entityPrefix)2" {
                Button {
                    experience.enterSelectedBlockageLesson()
                    guard experience.internalBrainModeActive else { return }
                    internalJourney.startContextualBlockageLesson()
                } label: {
                    Label("Open vessel detail", systemImage: "arrow.down.right.and.arrow.up.left")
                        .font(.caption.weight(.black))
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .accessibilityHint("Opens an authored high-detail vessel study with a visible return to Stroke Care")

                if experience.audienceLens == .clinician {
                    Text("Separate teaching scene · qualitative flow · not a patient scan or treatment simulation")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var isFamilyArterialReference: Bool {
        experience.audienceLens == .family &&
            experience.teachingImagingLens == .affectedVessel
    }

    private var referenceTitle: String {
        if experience.audienceLens == .family,
           experience.teachingImagingLens == .brainSurface,
           let selectedAtlasSurfaceChapter {
            return "\(selectedAtlasSurfaceChapter.title.uppercased()) · WHOLE-BRAIN CONTEXT"
        }
        switch (experience.audienceLens, experience.teachingImagingLens) {
        case (.family, .affectedVessel): return "FULL ARTERIAL TREE · TEACHING VIEW"
        case (.family, .brainSurface): return "WHOLE BRAIN SURFACE · TEACHING VIEW"
        case (.family, .neuron): return "ONE NEURON · SCHEMATIC TEACHING VIEW"
        case (.family, .internalStructures): return "INTERNAL STRUCTURES + VENTRICLES · TEACHING VIEW"
        case (.family, .makingRoomPurpose): return "MAKING-ROOM PURPOSE · TEACHING VIEW"
        case (.clinician, .affectedVessel): return "AFFECTED-VESSEL REFERENCE"
        case (.clinician, .brainSurface): return "BRAIN-SURFACE REFERENCE"
        case (.clinician, .neuron): return "ONE-NEURON SCHEMATIC"
        case (.clinician, .internalStructures): return "INTERNAL-STRUCTURES REFERENCE"
        case (.clinician, .makingRoomPurpose): return "MAKING-ROOM REFERENCE"
        }
    }

    private var isCombinedInternalChapter: Bool {
        experience.selectedPointLabel?.hasSuffix("· combined internal atlas context") == true
    }

    private var selectedAtlasSurfaceChapter: StrokeFamilyBrainAtlasChapter? {
        guard experience.selectedPointLabel?.hasSuffix("· generic atlas focus") == true,
              let chapter = experience.familyBrainAtlasCueChapter,
              chapter.spatialCuePointIndex != nil
        else { return nil }
        return chapter
    }

    private var referenceBoundary: String {
        if experience.teachingImagingLens == .neuron {
            return "Generic schematic · not to scale, patient tissue, or a recording"
        }
        if experience.audienceLens == .clinician {
            return "Registered-v2 teaching asset · review pending"
        }
        switch experience.teachingImagingLens {
        case .affectedVessel:
            return "Complete generic arterial structure · not a patient scan"
        case .brainSurface:
            return "Complete generic brain surface · not a patient scan"
        case .neuron:
            return "Generic schematic · not to scale, patient tissue, or a recording"
        case .internalStructures:
            return "Combined generic internal mesh · labels and registration under specialist review"
        case .makingRoomPurpose:
            return "Generic layer relationship · not a patient scan"
        }
    }

    private var referenceTint: Color {
        switch experience.teachingImagingLens {
        case .affectedVessel: .orange
        case .brainSurface: .cyan
        case .neuron: .mint
        case .internalStructures: .purple
        case .makingRoomPurpose: .mint
        }
    }
}

private extension RBCJourneyModel {
    /// Opens the deliberately requested, authored arterial-lumen composition
    /// only after a person chooses the blockage point. This stays generic,
    /// qualitative teaching anatomy rather than a patient-specific procedure.
    func startContextualBlockageLesson() {
        startFlowRide()
        isPresented = true
    }
}

/// A clinician-only index of technically denser reference lanes. It is one
/// slim vertical rail in the right-secondary field: a chosen tab can reveal
/// its own compact controls without duplicating every category as a grid.
private struct StrokeScholarReferenceRail: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openWindow) private var openWindow
    /// The reference rail begins as a narrow index. A second, explicit tab
    /// choice reveals only the selected category's detail, rather than
    /// permanently stacking an anatomy grid below a second set of tabs.
    @State private var inlineDetailsVisible: Bool

    init() {
        // Deterministic settings proof must still show the selected disclosure
        // without making the everyday reference rail expand by default.
        _inlineDetailsVisible = State(
            initialValue: CommandLine.arguments.contains("--proof-presentation-settings")
        )
    }

    var body: some View {
        ZStack(alignment: .leading) {
            StrokeScholarReferenceArc()
                .stroke(
                    Color.mint.opacity(0.22),
                    style: StrokeStyle(lineWidth: 1.5, dash: [3, 7])
                )
                .frame(width: 26, height: 424)
                .offset(x: 4, y: 16)

            VStack(alignment: .leading, spacing: 7) {
                Text("REFERENCE")
                    .font(.caption2.weight(.black))
                    .tracking(1.25)
                    .foregroundStyle(.mint.opacity(0.82))
                    .padding(.leading, 16)

                ForEach(visibleLanes) { lane in
                    Button {
                        select(lane)
                    } label: {
                        tab(
                            for: lane,
                            isSelected: isSelected(lane),
                            showsInlineDetails: showsInlineDetails(for: lane)
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.highlight)
                    .frame(minHeight: 60)
                    .contentShape(Capsule())
                    .accessibilityLabel(lane.title)
                    .accessibilityValue(accessibilityValue(for: lane))
                    .accessibilityHint(accessibilityHint(for: lane))
                }

                if inlineDetailsVisible && !experience.teachingImagingDrawerVisible {
                    selectedSubfields
                }
            }
        }
        .padding(.leading, 10)
        .padding(.vertical, 7)
        .frame(width: 248)
        .accessibilityLabel("Scholar references")
        .accessibilityElement(children: .contain)
    }

    private var visibleLanes: [StrokeScholarReferenceLane] {
        StrokeScholarReferenceLane.allCases.filter { $0 != .outcomes }
    }

    private func tab(
        for lane: StrokeScholarReferenceLane,
        isSelected: Bool,
        showsInlineDetails: Bool
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: lane.systemImage)
                .font(.callout.weight(.bold))
                .frame(width: 26, height: 30)
                .foregroundStyle(isSelected ? Color.black.opacity(0.78) : Color.white.opacity(0.86))

            Text(lane.railTitle)
                .font(.subheadline.weight(isSelected ? .black : .bold))
                .lineLimit(1)
                .foregroundStyle(
                    isSelected ? Color.black.opacity(0.78) : Color.white.opacity(0.92)
                )

            Spacer(minLength: 0)

            Image(systemName: trailingSymbol(
                for: lane,
                isSelected: isSelected,
                showsInlineDetails: showsInlineDetails
            ))
                .font(.caption.weight(.black))
                .foregroundStyle(isSelected ? Color.black.opacity(0.62) : Color.white.opacity(0.48))
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(
            isSelected ? Color.mint : Color.white.opacity(0.08),
            in: Capsule()
        )
        .overlay(
            Capsule()
                .stroke(isSelected ? Color.mint.opacity(0.72) : Color.white.opacity(0.14))
        )
    }

    @ViewBuilder
    private var selectedSubfields: some View {
        if experience.selectedScholarReferenceCategory == .teachingModel {
            presentationSettings
        } else if experience.selectedScholarReferenceCategory == .anatomy,
                  experience.pointField == .regions,
                  !experience.spatialImagingPlateVisible {
            VStack(alignment: .leading, spacing: 5) {
                Text("ANATOMY FOCUS")
                    .font(.caption2.weight(.black))
                    .tracking(0.75)
                    .foregroundStyle(.white.opacity(0.62))

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 2), spacing: 5) {
                    ForEach(StrokeAnatomyFocus.allCases) { focus in
                        anatomyFocusButton(focus)
                    }
                }

                Text(experience.anatomyFocusStatus)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private var presentationSettings: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("SETTINGS")
                .font(.caption2.weight(.black))
                .tracking(0.75)
                .foregroundStyle(.mint)

            HStack(alignment: .firstTextBaseline) {
                Text("VISUAL DETAIL")
                    .font(.caption2.weight(.black))
                    .tracking(0.65)
                Spacer()
                Text(experience.detailLevel.visualDetailTitle.uppercased())
                    .font(.caption2.monospaced().weight(.bold))
                    .foregroundStyle(.mint)
            }

            HStack(spacing: 8) {
                detailStepButton(
                    systemImage: "chevron.left",
                    label: "Show less visual detail",
                    offset: -1
                )

                VStack(spacing: 2) {
                    Text("VISUAL DETAIL")
                        .font(.caption2.weight(.black))
                        .tracking(0.55)
                    Text(experience.detailLevel.visualDetailTitle)
                        .font(.caption.weight(.black))
                        .foregroundStyle(.mint)
                }
                .frame(maxWidth: .infinity)

                detailStepButton(
                    systemImage: "chevron.right",
                    label: "Show more visual detail",
                    offset: 1
                )
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.08), in: Capsule())

            Text("Optional geometry and motion only.")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.white.opacity(0.56))
                .fixedSize(horizontal: false, vertical: true)

            if experience.detailLevel >= .guided &&
                experience.pointField == .regions &&
                experience.anatomyFocus == .vessels {
                VStack(alignment: .leading, spacing: 3) {
                    Text("GENERIC VENOUS ATLAS · COLOUR CONVENTION · REVIEW PENDING")
                    Text("ATLAS · Z-ANATOMY + BODYPARTS3D · CC BY-SA")
                        .foregroundStyle(.white.opacity(0.48))
                }
                .font(.caption2.monospaced().weight(.semibold))
                .foregroundStyle(.white.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    "Generic venous atlas. Colour is a display convention. Specialist review pending. Atlas sources: Z-Anatomy and BodyParts3D, Creative Commons Attribution ShareAlike."
                )
            }

            Button {
                openWindow(id: StrokeSpace.printRequest, value: StrokeSpace.printRequest)
            } label: {
                Label("Teaching model brief", systemImage: "cube.transparent")
                    .font(.caption.weight(.bold))
                    .frame(maxWidth: .infinity, minHeight: 42)
                    .foregroundStyle(.white.opacity(0.86))
                    .background(Color.white.opacity(0.08), in: Capsule())
            }
            .buttonStyle(.plain)
            .hoverEffect(.highlight)
            .contentShape(Capsule())
            .accessibilityHint("Opens the separate generic teaching-model request")
        }
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    /// Settings use two direct, gaze-sized steps rather than a horizontal
    /// slider or menu. The family-side clarity check remains separate because
    /// it records the conversation, not the presenter's visual preference.
    private func detailStepButton(
        systemImage: String,
        label: String,
        offset: Int
    ) -> some View {
        Button {
            experience.cycleDetailLevel(by: offset)
        } label: {
            Image(systemName: systemImage)
                .font(.caption.weight(.black))
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.10), in: Circle())
                .overlay(Circle().stroke(Color.mint.opacity(0.32), lineWidth: 1))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .accessibilityLabel(label)
        .accessibilityValue(experience.detailLevel.visualDetailTitle)
    }

    private func anatomyFocusButton(_ focus: StrokeAnatomyFocus) -> some View {
        let isAvailable = experience.isAnatomyFocusAvailable(focus)
        return Button {
            experience.selectAnatomyFocus(focus)
        } label: {
            Text(focus.rawValue)
                .font(.caption2.weight(.bold))
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 44)
                .foregroundStyle(experience.anatomyFocus == focus ? Color.black.opacity(0.82) : .white)
                .background(
                    experience.anatomyFocus == focus ? Color.mint : Color.white.opacity(0.07),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .contentShape(Capsule())
        .opacity(isAvailable ? 1 : 0.46)
        .accessibilityLabel("Anatomy focus, \(focus.rawValue)")
        .accessibilityValue(
            experience.anatomyFocus == focus
                ? "Selected"
                : (isAvailable ? "Available" : "Unavailable in this build")
        )
    }

    private func isSelected(_ lane: StrokeScholarReferenceLane) -> Bool {
        lane != .outcomes && experience.selectedScholarReferenceCategory == lane.category
    }

    private func showsInlineDetails(for lane: StrokeScholarReferenceLane) -> Bool {
        isSelected(lane) && lane.supportsInlineDetails && inlineDetailsVisible
    }

    private func trailingSymbol(
        for lane: StrokeScholarReferenceLane,
        isSelected: Bool,
        showsInlineDetails: Bool
    ) -> String {
        guard isSelected else { return "chevron.right" }
        guard lane.supportsInlineDetails else { return "checkmark" }
        return showsInlineDetails ? "chevron.up" : "chevron.down"
    }

    private func accessibilityValue(for lane: StrokeScholarReferenceLane) -> String {
        guard isSelected(lane) else { return "Available" }
        guard lane.supportsInlineDetails else { return "Selected" }
        return showsInlineDetails(for: lane) ? "Selected, details shown" : "Selected, details hidden"
    }

    private func accessibilityHint(for lane: StrokeScholarReferenceLane) -> String {
        guard lane.supportsInlineDetails else { return "Pinch to select this reference" }
        if isSelected(lane) {
            return showsInlineDetails(for: lane)
                ? "Pinch to hide the selected reference details"
                : "Pinch to show the selected reference details"
        }
        return "Pinch to select this reference and show its details"
    }

    private func isActionable(_ lane: StrokeScholarReferenceLane) -> Bool {
        switch lane {
        case .anatomy:
            true
        case .imaging:
            true
        case .interventions, .medications, .guidelines, .teachingModel:
            true
        case .outcomes:
            false
        }
    }

    private func unavailableStatus(for lane: StrokeScholarReferenceLane) -> String {
        return "Coming soon"
    }

    private func unavailableLabel(for lane: StrokeScholarReferenceLane) -> String {
        return "\(lane.title), unavailable in this prototype"
    }

    private func select(_ lane: StrokeScholarReferenceLane) {
        guard lane != .outcomes else { return }
        if isSelected(lane), lane.supportsInlineDetails {
            inlineDetailsVisible.toggle()
            return
        }
        inlineDetailsVisible = lane.supportsInlineDetails
        experience.selectScholarReferenceCategory(lane.category)
        switch lane {
        case .anatomy:
            experience.selectLessonFamily(.regions)
        case .imaging:
            experience.placeSpatialImagingPlate(.ctGuide)
            if !experience.spatialImagingFocusActive { experience.toggleSpatialImagingFocus() }
        case .interventions:
            // Reuses the reviewed, non-graphic access-story point family.
            experience.selectLessonFamily(.craniotomy)
        case .medications:
            experience.openReferenceWorkspace(.medications)
        case .guidelines:
            if let guideline = StrokeEvidenceSource.library.first(where: { $0.kind == .guideline }) {
                experience.selectEvidence(guideline)
            }
            experience.openReferenceWorkspace(.guides)
        case .teachingModel:
            inlineDetailsVisible = false
            experience.openReferenceWorkspace(.settings)
        case .outcomes:
            break
        }
    }
}

private enum StrokeScholarReferenceLane: String, CaseIterable, Identifiable {
    case anatomy
    case imaging
    case interventions
    case medications
    case outcomes
    case guidelines
    case teachingModel

    var id: String { rawValue }

    var category: StrokeScholarReferenceCategory {
        switch self {
        case .anatomy: .anatomy
        case .imaging: .imaging
        case .interventions: .interventions
        case .medications: .medications
        case .guidelines: .guidelines
        case .teachingModel: .teachingModel
        case .outcomes: .anatomy
        }
    }

    /// A shallow visual arc keeps the rail peripheral without reducing any
    /// row's 60-point interaction target.
    var arcInset: CGFloat {
        switch self {
        case .anatomy, .guidelines: 0
        case .imaging, .outcomes, .teachingModel: 6
        case .interventions, .medications: 12
        }
    }

    var systemImage: String {
        switch self {
        case .anatomy: "brain.head.profile"
        case .imaging: "viewfinder"
        case .interventions: "cross.case"
        case .medications: "pills"
        case .outcomes: "chart.line.uptrend.xyaxis"
        case .guidelines: "text.book.closed"
        case .teachingModel: "cube.transparent"
        }
    }

    var title: String {
        switch self {
        case .teachingModel: "Presentation settings"
        default: rawValue.capitalized
        }
    }

    /// Short visible labels keep the peripheral ring narrow. VoiceOver keeps
    /// the full category title through each button's accessibility label.
    var railTitle: String {
        switch self {
        case .anatomy: "Anatomy"
        case .imaging: "Imaging"
        case .interventions: "Access"
        case .medications: "Meds"
        case .outcomes: "Outcomes"
        case .guidelines: "Guides"
        case .teachingModel: "Settings"
        }
    }

    /// Only categories with compact, secondary controls disclose inline.
    /// Imaging gets a full image surface instead; duplicating CT/MRI choices
    /// in the rail would recreate the visual stack this rail avoids.
    var supportsInlineDetails: Bool {
        switch self {
        case .anatomy:
            true
        case .imaging, .interventions, .medications, .outcomes, .guidelines, .teachingModel:
            false
        }
    }
}

/// A non-interactive peripheral guide for the Scholar lanes. It reinforces a
/// ring-like reference index while all actual targets remain generous rows.
private struct StrokeScholarReferenceArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.minX + 6, y: rect.minY + 18)
        let end = CGPoint(x: rect.minX + 6, y: rect.maxY - 18)
        path.move(to: start)
        path.addCurve(
            to: end,
            control1: CGPoint(x: rect.maxX * 0.78, y: rect.height * 0.26),
            control2: CGPoint(x: rect.maxX * 0.78, y: rect.height * 0.74)
        )
        return path
    }
}

/// A centered, world-space chapter line. The active act opens enough to read
/// at a glance while the other two remain quiet navigation targets.
private struct SpatialTeachingTimeline: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var hoveredBeat: StrokePresenterTeachingBeat?
    @State private var hoveredStep: StrokeProcedureStep?
    @State private var labelsVisible = true

    var body: some View {
        Group {
            if experience.audienceLens == .clinician {
                presenterTimeline
            } else {
                familyTimeline
            }
        }
        .shadow(color: .black.opacity(0.14), radius: 16, y: 6)
        .task(id: revealKey) {
            labelsVisible = true
            try? await Task.sleep(for: .seconds(2.6))
            guard !Task.isCancelled else { return }
            withAnimation(.easeOut(duration: 0.42)) {
                labelsVisible = false
            }
        }
    }

    private var familyTimeline: some View {
        VStack(spacing: 7) {
            let displayedStep = hoveredStep ?? experience.procedureStep
            let showsContext = labelsVisible || hoveredStep != nil

            Text("\(title(for: displayedStep)) · \(familySummary(for: displayedStep))")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.82))
                .lineLimit(1)
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .frame(minHeight: 30)
                .background(.ultraThinMaterial.opacity(0.48), in: Capsule())
                .opacity(showsContext ? 1 : 0)
                .contentTransition(.opacity)
                .animation(.easeOut(duration: 0.22), value: showsContext)
                .accessibilityHidden(!showsContext)

            ZStack {
                SpatialTimelineRibbonBackground()

                SpatialTimelineTrack(tints: familyTrackTints)
                    .padding(.horizontal, 48)

                HStack(spacing: 0) {
                    ForEach(StrokeProcedureStep.allCases) { step in
                        let isActive = step == experience.procedureStep
                        Button {
                            // `present` retains the existing Make-space consent gate.
                            experience.present(step: step)
                        } label: {
                            SpatialTeachingTimelineNode(
                                number: step.number,
                                isActive: isActive,
                                isHovered: hoveredStep == step,
                                tint: tint(for: step)
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                        // The visible marker stays quiet while the 96-point
                        // acquisition field remains dependable for gaze/pinch.
                        .frame(minWidth: 96, minHeight: 96)
                        .contentShape(Rectangle())
                        .onHover { isHovering in
                            hoveredStep = isHovering ? step : nil
                        }
                        .accessibilityLabel("Act \(step.number), \(title(for: step))")
                        .accessibilityValue(isActive ? "Current act" : "Inactive act")
                    }
                }
            }
            .frame(width: 288, height: 96)
        }
    }

    /// The presenter can revisit any of six authored checkpoints without
    /// losing the three-act patient story. Beats 3–6 continue to use the
    /// existing explicit permission gate before any layer separation.
    private var presenterTimeline: some View {
        VStack(spacing: 8) {
            let displayedBeat = hoveredBeat ?? experience.presenterTeachingBeat
            let showsContext = labelsVisible || hoveredBeat != nil

            Text("STEP \(displayedBeat.number) OF 6 · \(displayedBeat.title) — \(displayedBeat.summary)")
                .font(.callout.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.72))
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 18)
                .opacity(showsContext ? 1 : 0)
                .contentTransition(.opacity)
                .animation(.easeOut(duration: 0.22), value: showsContext)
                .accessibilityHidden(!showsContext)

            ZStack {
                SpatialTimelineRibbonBackground()

                SpatialTimelineTrack(tints: presenterTrackTints)
                    .padding(.horizontal, 54)

                HStack(spacing: 0) {
                    ForEach(StrokePresenterTeachingBeat.allCases) { beat in
                        let isActive = beat == experience.presenterTeachingBeat
                        Button {
                            experience.selectPresenterTeachingBeat(beat)
                        } label: {
                            SpatialPresenterTeachingBeatNode(
                                beat: beat,
                                isActive: isActive,
                                isHovered: hoveredBeat == beat,
                                tint: tint(for: beat)
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                        // Six timeline targets must remain easy to acquire in
                        // spatial use. A fixed 108-point field and 64-point disc
                        // improve room-scale legibility without shifting targets
                        // when a beat becomes active or gaze-hovered.
                        .frame(minWidth: 108, minHeight: 108)
                        .contentShape(Rectangle())
                        .onHover { isHovering in
                            hoveredBeat = isHovering ? beat : nil
                        }
                        .accessibilityLabel("Presenter beat \(beat.number), \(beat.title)")
                        .accessibilityValue(isActive ? "Current checkpoint" : "Available checkpoint")
                    }
                }
            }
            .frame(width: 648, height: 108)
        }
    }

    private var familyTrackTints: [Color] {
        StrokeProcedureStep.allCases.map { tint(for: $0) }
    }

    private var presenterTrackTints: [Color] {
        StrokePresenterTeachingBeat.allCases.map { tint(for: $0) }
    }

    private var revealKey: String {
        if experience.audienceLens == .clinician {
            "clinician-\(experience.presenterTeachingBeat.rawValue)"
        } else {
            "family-\(experience.procedureStep.number)"
        }
    }

    private func title(for step: StrokeProcedureStep) -> String {
        switch step {
        case .chooseCase: "Orient"
        case .inspectOcclusion: "Pressure"
        case .discussCare: "Make space"
        }
    }

    private func familySummary(for step: StrokeProcedureStep) -> String {
        switch step {
        case .chooseCase: "See the whole brain and its vessels"
        case .inspectOcclusion: "See where flow is interrupted"
        case .discussCare: "See why making room may be discussed"
        }
    }

    /// Page 2's cool-to-warm scale becomes three restrained chapter colors:
    /// orient in blue, inspect pressure in lavender, and discuss purpose in
    /// orange-red. Color communicates chapter position, never severity.
    private func tint(for step: StrokeProcedureStep) -> Color {
        switch step {
        case .chooseCase: Color(red: 0.50, green: 0.58, blue: 0.82)
        case .inspectOcclusion: Color(red: 0.65, green: 0.63, blue: 0.85)
        case .discussCare: Color(red: 0.95, green: 0.48, blue: 0.29)
        }
    }

    /// The six checkpoints form one calm intensity arc: cool orientation,
    /// warmer access/purpose, then a deliberate return to cool context. Color
    /// communicates story position only; it is never a severity score.
    private func tint(for beat: StrokePresenterTeachingBeat) -> Color {
        switch beat {
        case .confirmContext: Color(red: 0.50, green: 0.58, blue: 0.82)
        case .discussAccess: Color(red: 0.61, green: 0.62, blue: 0.84)
        case .protectiveCovering: Color(red: 0.73, green: 0.58, blue: 0.77)
        case .explainPurpose: Color(red: 0.95, green: 0.48, blue: 0.29)
        case .teamChecks: Color(red: 0.86, green: 0.31, blue: 0.34)
        case .explainClosure: Color(red: 0.58, green: 0.60, blue: 0.82)
        }
    }
}

/// A single continuous path replaces the earlier detached progress strip.
/// Its cool-to-warm color only communicates authored story position.
private struct SpatialTimelineTrack: View {
    let tints: [Color]

    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.white.opacity(0.10))

            LinearGradient(
                colors: tints.map { $0.opacity(0.88) },
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(Capsule())
        }
        .frame(height: 10)
        .overlay(Capsule().stroke(Color.white.opacity(0.16), lineWidth: 0.8))
        .accessibilityHidden(true)
    }
}

/// A slim, darkened glass ribbon keeps the controls readable in both a bright
/// room and the optional black environment without becoming a window.
private struct SpatialTimelineRibbonBackground: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.30)
            Capsule()
                .fill(Color.black.opacity(0.12))
            Capsule()
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
    }
}

private struct SpatialPresenterTeachingBeatNode: View {
    let beat: StrokePresenterTeachingBeat
    let isActive: Bool
    let isHovered: Bool
    let tint: Color

    var body: some View {
        let isEmphasized = isActive || isHovered
        let discDiameter: CGFloat = 64
        ZStack {
            Circle()
                .fill(isActive ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(Color.white.opacity(isHovered ? 0.10 : 0.025)))
                .frame(width: discDiameter, height: discDiameter)

            Circle()
                .stroke(
                    isEmphasized ? tint.opacity(0.78) : Color.white.opacity(0.10),
                    lineWidth: isEmphasized ? 1.6 : 1
                )
                .frame(width: discDiameter, height: discDiameter)

            Text(String(beat.number))
                .font(.caption.monospacedDigit().weight(.black))
                .frame(width: 40, height: 40)
                .background(isEmphasized ? tint : Color.white.opacity(0.08), in: Circle())
                .foregroundStyle(isEmphasized ? Color.black : Color.white.opacity(0.62))
        }
        .frame(width: 108, height: 108)
        .contentShape(Rectangle())
    }
}

private struct SpatialTeachingTimelineNode: View {
    let number: Int
    let isActive: Bool
    let isHovered: Bool
    let tint: Color

    var body: some View {
        let isEmphasized = isActive || isHovered
        ZStack {
            Circle()
                .fill(
                    isActive
                        ? AnyShapeStyle(.regularMaterial)
                        : AnyShapeStyle(Color.black.opacity(isHovered ? 0.22 : 0.14))
                )
                .frame(width: 54, height: 54)

            Circle()
                .stroke(
                    isEmphasized ? tint.opacity(0.90) : Color.white.opacity(0.14),
                    lineWidth: isEmphasized ? 2 : 1
                )
                .frame(width: 54, height: 54)

            Text(String(number))
                .font(.callout.monospacedDigit().weight(.black))
                .frame(width: 40, height: 40)
                .background(isEmphasized ? tint : Color.black.opacity(0.28), in: Circle())
                .foregroundStyle(isEmphasized ? Color.black : Color.white.opacity(0.70))
        }
        .frame(width: 96, height: 96)
        .contentShape(Rectangle())
    }
}

/// A quiet lower-corner orientation affordance. It replaces a row of view
/// buttons: gaze shows the current authored view and one pinch advances to the
/// next repeatable whole-assembly viewpoint.
private struct SpatialViewpointDot: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let viewpoints: [StrokeAnatomyViewpoint] = [
        .threeQuarter, .anterior, .lateralA, .lateralB, .superior, .inferior
    ]

    var body: some View {
        Button(action: advanceViewpoint) {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                    Circle()
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                    Image(systemName: experience.anatomyViewpoint.systemImage)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.88))
                }
                .frame(width: 48, height: 48)

                Text(experience.anatomyViewpoint.shortTitle.uppercased())
                    .font(.caption2.monospaced().weight(.bold))
                    .foregroundStyle(Color.white.opacity(0.62))
                    .lineLimit(1)
            }
            .frame(width: 92, height: 78)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .accessibilityLabel("Anatomy viewpoint")
        .accessibilityValue(experience.anatomyViewpoint.rawValue)
        .accessibilityHint("Pinch to move to the next whole-anatomy view")
    }

    private func advanceViewpoint() {
        let currentIndex = viewpoints.firstIndex(of: experience.anatomyViewpoint) ?? -1
        let nextIndex = (currentIndex + 1) % viewpoints.count
        experience.setAnatomyViewpoint(viewpoints[nextIndex], reduceMotion: reduceMotion)
    }
}

/// A single left-peripheral cue surface whose density follows the audience.
/// Family suggestions and the explicit self-reported clarity check stay together
/// in the mirrored view; the presenter sees that declared clarity plus exactly
/// three teaching beats. A second headset or shared spatial session is not
/// implied by this surface.
/// A deliberately optional, room-anchored atlas for the family route. It
/// advances through one idea at a time and changes the existing discovery
/// points rather than placing a permanent cloud of labels around the brain.
private struct SpatialFamilyAtlasSurfaceSelection: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    private var chapter: StrokeFamilyBrainAtlasChapter {
        experience.familyBrainAtlasChapter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 10) {
                Label("SELECTED ON BRAIN", systemImage: "viewfinder")
                    .font(.caption2.weight(.black))
                    .tracking(0.9)
                    .foregroundStyle(.mint)
                Spacer(minLength: 8)
                Button {
                    experience.dismissFamilyBrainAtlas()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.black))
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
                .accessibilityLabel("Close selected brain region")
                .accessibilityHint("Hides this generic region cue and its teaching reference")
            }

            Text(chapter.title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)

            Text(chapter.explanation)
                .font(.callout.weight(.medium))
                .foregroundStyle(.white.opacity(0.84))
                .fixedSize(horizontal: false, vertical: true)

            Text("BROAD ATLAS CONTEXT · NOT A PATIENT SCAN OR MEASURED BORDER")
                .font(.caption2.monospaced().weight(.bold))
                .tracking(0.25)
                .foregroundStyle(.white.opacity(0.54))
                .fixedSize(horizontal: false, vertical: true)

            Button {
                experience.expandFamilyBrainAtlasJourney()
            } label: {
                Label("Explore atlas", systemImage: "arrow.right")
                    .font(.caption.weight(.bold))
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .accessibilityHint("Opens the optional ten-part Brain Atlas at this region")
        }
        .padding(16)
        .background(.black.opacity(0.66), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.mint.opacity(0.42)))
        .shadow(color: .black.opacity(0.46), radius: 16, y: 7)
        .accessibilityElement(children: .contain)
    }
}

private struct SpatialFamilyBrainAtlas: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @GestureState private var horizontalDrag: CGFloat = 0

    private var chapter: StrokeFamilyBrainAtlasChapter {
        experience.familyBrainAtlasChapter
    }

    private var detailTitle: String {
        switch experience.familyBrainAtlasDetailIndex {
        case 0: "FIND IT IN SPACE"
        case 1: "WHAT IT HELPS WITH"
        default: "TAKE THE NEXT QUESTION"
        }
    }

    private var detailText: String {
        switch experience.familyBrainAtlasDetailIndex {
        case 0: chapter.discoveryPrompt
        case 1: chapter.explanation
        default: chapter.conversationPrompt
        }
    }

    /// A cue is only considered active after the wearer has deliberately
    /// revealed one existing anatomy-attached point. This keeps the Atlas
    /// connected to the spatial model instead of turning every chapter into a
    /// permanent screen-side explanation.
    private var isModelCueActive: Bool {
        experience.familyBrainAtlasCueChapter == chapter
    }

    private var isReferenceVisible: Bool {
        isModelCueActive && experience.teachingImagingDrawerVisible
    }

    /// Once the learner has explicitly chosen the concise explanation, the
    /// position/meaning/ask chrome should stop competing with it. The chapter
    /// arrows and drag gesture remain available, while the 3D reference stays
    /// in the secondary field as the object of attention.
    private var isPlainWordsExpanded: Bool {
        isModelCueActive &&
            experience.familyNarrationTranscriptVisible &&
            experience.activeFamilyNarrationText != nil
    }

    /// A deep-topic lesson must not make the available combined mesh look like
    /// an individual, exact segmentation. The topic remains explicit, while
    /// the large heading tells the wearer what the 3D object actually is.
    private var isAtlasCombinedInternalChapter: Bool {
        chapter.usesCombinedInternalReference
    }

    private var chapterHeading: String {
        isAtlasCombinedInternalChapter ? "Deep systems" : chapter.title
    }

    private var chapterTopicKicker: String? {
        guard isAtlasCombinedInternalChapter else { return nil }
        return "TOPIC · \(chapter.title.uppercased())"
    }

    private var chapterReferenceBoundary: String {
        isAtlasCombinedInternalChapter
            ? "COMBINED INTERNAL MODEL · NOT A SEPARATE OUTLINE"
            : "ATLAS CONTEXT · 3D REFERENCE REMAINS BESIDE THE BRAIN"
    }

    private var atlasReferenceActionTitle: String {
        guard isModelCueActive else {
            return "REVEAL IN 3D · \(chapter.modelCue)"
        }
        let action = isReferenceVisible ? "HIDE" : "SHOW"
        return "\(action) · \(experience.teachingReferenceActionTitle().uppercased())"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .firstTextBaseline) {
                Label("BRAIN ATLAS", systemImage: "brain.head.profile")
                    .font(.caption2.weight(.black))
                    .tracking(1.15)
                    .foregroundStyle(.orange)
                Spacer()
                Text("\(chapter.ordinal) / \(StrokeFamilyBrainAtlasChapter.allCases.count)")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundStyle(.white.opacity(0.58))
            }

            if !isPlainWordsExpanded {
                // Make the three wearer-controlled explanations legible
                // before a pinch. Once the short explanation is open, this
                // chrome deliberately recedes so it does not repeat the same
                // lesson beside the 3D reference.
                HStack(spacing: 6) {
                    atlasBeat("1", "POSITION", index: 0)
                    atlasBeatConnector
                    atlasBeat("2", "MEANING", index: 1)
                    atlasBeatConnector
                    atlasBeat("3", "ASK", index: 2)
                }
            }

            HStack(alignment: .center, spacing: 12) {
                atlasStepButton(symbol: "chevron.left", label: "Previous") {
                    experience.advanceFamilyBrainAtlasChapter(by: -1)
                }

                if isPlainWordsExpanded {
                    VStack(alignment: .leading, spacing: 7) {
                        Text(chapterHeading)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                        if let chapterTopicKicker {
                            Text(chapterTopicKicker)
                                .font(.caption2.weight(.black))
                                .tracking(0.8)
                                .foregroundStyle(.orange.opacity(0.90))
                        }
                        Text(chapterReferenceBoundary)
                            .font(.caption2.weight(.black))
                            .tracking(0.8)
                            .foregroundStyle(.mint.opacity(0.90))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: 78, alignment: .leading)
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.mint.opacity(0.26)))
                } else {
                    Button {
                        experience.advanceFamilyBrainAtlasDetail(by: 1)
                    } label: {
                        VStack(alignment: .leading, spacing: 7) {
                            Text(chapterHeading)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(.white)
                            if let chapterTopicKicker {
                                Text(chapterTopicKicker)
                                    .font(.caption2.weight(.black))
                                    .tracking(0.8)
                                    .foregroundStyle(.mint.opacity(0.90))
                            }
                            HStack(spacing: 6) {
                                Text("\(experience.familyBrainAtlasDetailIndex + 1) OF \(StrokeFamilyBrainAtlasChapter.detailCount) · \(detailTitle)")
                                    .font(.caption2.weight(.black))
                                    .tracking(0.8)
                                    .foregroundStyle(.orange.opacity(0.90))
                                Spacer(minLength: 0)
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundStyle(.orange.opacity(0.90))
                            }
                            Text(detailText)
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.white.opacity(0.82))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: 126, alignment: .leading)
                        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.orange.opacity(0.30)))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.highlight)
                    .accessibilityLabel("\(chapter.title), insight \(experience.familyBrainAtlasDetailIndex + 1) of \(StrokeFamilyBrainAtlasChapter.detailCount). \(detailText)")
                    .accessibilityHint("Pinch for the next explanation")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: horizontalDrag * 0.12)
                }

                atlasStepButton(symbol: "chevron.right", label: "Next") {
                    experience.advanceFamilyBrainAtlasChapter(by: 1)
                }
            }

            Button {
                if isModelCueActive {
                    experience.toggleSelectedPointReference()
                } else {
                    experience.revealFamilyBrainAtlasModelCue()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isModelCueActive ? (isReferenceVisible ? "eye.slash" : "view.3d") : chapter.systemImage)
                    Text(atlasReferenceActionTitle)
                        .font(.caption2.weight(.black))
                        .tracking(0.55)
                    Spacer(minLength: 0)
                    Image(systemName: isModelCueActive ? "viewfinder" : "arrow.right")
                }
                .foregroundStyle(isModelCueActive ? .mint.opacity(0.95) : .orange.opacity(0.95))
                .padding(.horizontal, 11)
                .padding(.vertical, 10)
                .background((isModelCueActive ? Color.mint : Color.orange).opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke((isModelCueActive ? Color.mint : Color.orange).opacity(0.26)))
            }
            .buttonStyle(.plain)
            .hoverEffect(.highlight)
            .accessibilityLabel(atlasCueAccessibilityLabel)
            .accessibilityHint(atlasCueAccessibilityHint)

            if isModelCueActive, experience.familyNarrationPromptVisible {
                HStack(spacing: 9) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(experience.narrationSetupAvailable
                             ? "OPTIONAL AUDIO"
                             : "PLAIN WORDS")
                            .font(.caption2.weight(.black))
                            .tracking(0.65)
                    }
                    Spacer(minLength: 4)
                    Button(
                        experience.narrationSetupAvailable ? "Play audio" : "Explain simply",
                        systemImage: experience.narrationSetupAvailable ? "waveform" : "text.book.closed"
                    ) {
                        if experience.narrationSetupAvailable {
                            experience.acceptFamilyNarrationPrompt()
                        } else {
                            experience.showFamilyNarrationTranscript()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)

                }
                .padding(10)
                .background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 12))
                .accessibilityElement(children: .contain)
            } else if isModelCueActive,
                      experience.familyNarrationTranscriptVisible,
                      let deeperText = experience.activeFamilyNarrationText {
                VStack(alignment: .leading, spacing: 7) {
                    Text("PLAIN WORDS")
                        .font(.caption2.weight(.black))
                        .tracking(0.65)
                        .foregroundStyle(.mint)
                    Text(deeperText)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.78))
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        Text("GENERIC TEACHING MODEL · NOT A PATIENT SCAN")
                            .font(.caption2.monospaced().weight(.bold))
                            .foregroundStyle(.white.opacity(0.44))
                            .lineLimit(1)
                            .minimumScaleFactor(0.66)
                            .layoutPriority(1)
                        Spacer(minLength: 0)
                        Button("Hide", systemImage: "chevron.up") {
                            experience.dismissFamilyNarrationPrompt()
                        }
                        .buttonStyle(.bordered)
                        .fixedSize(horizontal: true, vertical: false)
                        .accessibilityLabel("Hide plain-language explanation")
                    }
                }
                .padding(10)
                .background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 12))
            } else if isModelCueActive, experience.activeFamilyNarrationText != nil {
                Button("Stop voice", systemImage: "speaker.slash.fill") {
                    experience.dismissFamilyNarrationPrompt()
                }
                .buttonStyle(.bordered)
                .tint(.mint)
            }

            if canOpenCerebellumObservatory {
                Button {
                    experience.enterFamilyAtlasCerebellumJourney()
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.caption.weight(.black))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("EXPLORE CEREBELLUM IN 3D")
                                .font(.caption2.weight(.black))
                                .tracking(0.55)
                            Text("Folds, vessel paths, and qualitative flow")
                                .font(.caption2.weight(.semibold))
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.right")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundStyle(.mint.opacity(0.96))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 10)
                    .background(.mint.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.mint.opacity(0.30)))
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
                .accessibilityLabel("Explore the cerebellum in the dedicated 3D learning scene")
                .accessibilityHint("Opens a generic orientation scene for folded form, vessel paths, and qualitative flow. It is not a patient scan or histology")
            }

            if isDeepStructureChapter, experience.isInteriorPortalAvailable {
                Label("ROOM SCALE READY · USE ENTER THE BRAIN BELOW", systemImage: "arrow.down.right.and.arrow.up.left")
                    .font(.caption2.weight(.black))
                    .tracking(0.45)
                    .foregroundStyle(.mint.opacity(0.95))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(.mint.opacity(0.10), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.mint.opacity(0.28)))
                    .accessibilityLabel("Room scale is ready. Use Enter the Brain below to open the separate guided vessel journey")
            }

            Text("SWIPE OR USE ARROWS FOR THE NEXT STRUCTURE")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.52))
        }
        .padding(18)
        // Family copy has to remain readable against an arbitrary real room;
        // the card stays peripheral while the registered anatomy remains the
        // spatial hero, rather than letting environmental texture wash out
        // the explanation.
        .background(.black.opacity(0.72), in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.orange.opacity(0.42)))
        .shadow(color: .black.opacity(0.52), radius: 18, y: 8)
        .contentShape(RoundedRectangle(cornerRadius: 22))
        .gesture(
            DragGesture(minimumDistance: 20)
                .updating($horizontalDrag) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    guard abs(value.translation.width) > 42 else { return }
                    experience.advanceFamilyBrainAtlasChapter(by: value.translation.width < 0 ? 1 : -1)
                }
        )
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: chapter)
        .accessibilityElement(children: .contain)
    }

    private var atlasCueAccessibilityLabel: String {
        if isModelCueActive {
            return "\(isReferenceVisible ? "Hide" : "Show") \(experience.teachingReferenceActionTitle()) for \(chapter.title)"
        }
        if chapter == .arterialRoutes {
            return "Show qualitative branching flow on the 3D teaching model"
        }
        if chapter.spatialCuePointIndex != nil {
            return "Show \(chapter.title) context on the 3D teaching model"
        }
        return "Show the combined internal structures and ventricular system in 3D"
    }

    private var isDeepStructureChapter: Bool {
        isAtlasCombinedInternalChapter
    }

    /// Only the final Atlas chapter has a dedicated, authored observatory.
    /// Corpus callosum, thalamus, and hippocampus remain bounded to the one
    /// combined internal reference until separately reviewed source meshes
    /// exist; this prevents a generic journey from silently standing in for
    /// anatomy it does not actually contain.
    private var canOpenCerebellumObservatory: Bool {
        chapter == .brainstemAndCerebellum && isModelCueActive
    }

    private var atlasCueAccessibilityHint: String {
        if isModelCueActive {
            return "Toggles the complete generic 3D structure while keeping this chapter selected"
        }
        if chapter == .arterialRoutes {
            return "Selects one generic vessel cue and opens one local teaching reference. It is not a patient scan or measurement"
        }
        if chapter.spatialCuePointIndex != nil {
            return "Selects one lifted generic anatomy cue. It does not identify anatomy in a patient scan"
        }
        return "Shows the complete combined internal mesh without pretending this chapter is separately segmented. The optional guided journey remains available at room scale"
    }

    private func atlasStepButton(
        symbol: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.headline.weight(.bold))
                .frame(width: 56, height: 64)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.14)))
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .accessibilityLabel(label + " Brain Atlas chapter")
    }

    private func atlasBeat(_ number: String, _ title: String, index: Int) -> some View {
        let active = experience.familyBrainAtlasDetailIndex == index
        return HStack(spacing: 5) {
            Text(number)
                .font(.caption2.monospacedDigit().weight(.black))
                .frame(width: 18, height: 18)
                .foregroundStyle(active ? .black : .white.opacity(0.72))
                .background(active ? .orange : .white.opacity(0.10), in: Circle())
            Text(title)
                .font(.caption2.weight(active ? .black : .bold))
                .tracking(0.45)
                .foregroundStyle(active ? .orange : .white.opacity(0.42))
        }
        .accessibilityHidden(true)
    }

    private var atlasBeatConnector: some View {
        Capsule()
            .fill(.white.opacity(0.16))
            .frame(width: 14, height: 1)
            .accessibilityHidden(true)
    }
}

private struct SpatialRoleMicroCues: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Label(
                experience.audienceLens == .family
                    ? (experience.selectedPointEntityName == nil ? "BEGIN HERE" : "EXPLORE NEXT")
                    : "EXPLAIN THIS",
                systemImage: experience.audienceLens == .family ? "sparkles" : "list.bullet"
            )
            .font(.caption2.weight(.black))
            .tracking(1.0)
            .foregroundStyle(accent)

            if experience.audienceLens == .family {
                if experience.selectedPointEntityName == nil {
                    HStack(alignment: .top, spacing: 9) {
                        Image(systemName: "view.3d")
                            .font(.caption.weight(.black))
                            .foregroundStyle(.mint)
                            .frame(width: 28, height: 28)
                            .background(.mint.opacity(0.14), in: Circle())

                        VStack(alignment: .leading, spacing: 3) {
                            Text("OUTSIDE THE BRAIN")
                                .font(.caption2.weight(.black))
                                .tracking(0.9)
                                .foregroundStyle(.mint)

                            Text("Generic whole-brain teaching anatomy")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.78))

                            if experience.isInteriorPortalAvailable {
                                Text("Room scale is ready. Enter the Brain opens the separate guided journey.")
                                    .font(.caption2.weight(.medium))
                                    .foregroundStyle(.orange.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(
                        experience.isInteriorPortalAvailable
                            ? "Outside the brain. Generic whole-brain teaching anatomy. Room scale is ready; Enter the Brain opens the separate guided journey."
                            : "Outside the brain. Generic whole-brain teaching anatomy."
                    )

                    Divider().overlay(Color.white.opacity(0.12))
                }

                ForEach(Array(experience.familyQuestionSuggestions.enumerated()), id: \.offset) { index, question in
                    let isSelected = experience.selectedFamilyQuestion == question
                    let opensSpatialReference = experience.familyExploreDestination(for: question) != nil
                        || question == "Enter the brain at room scale"
                    Button {
                        experience.selectFamilyQuestion(question)
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Image(systemName: opensSpatialReference ? "arrow.right.circle" : (isSelected ? "checkmark.shield.fill" : "shield"))
                                .font(.caption.weight(.bold))
                                .foregroundStyle(isSelected ? accent : Color.white.opacity(0.42))
                            Text(question)
                                .font(index == 0 ? .callout.weight(.semibold) : .caption.weight(.semibold))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 7)
                        .background(isSelected ? accent.opacity(0.13) : Color.clear, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.highlight)
                    .accessibilityLabel("Explore next: \(question)")
                    .accessibilityValue(
                        opensSpatialReference
                            ? "Opens an authored spatial teaching point"
                            : (isSelected ? "Selected; limitations shown" : "Shows model limitations")
                    )
                }

                if let answer = experience.selectedFamilyQuestionAnswer {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("WHY THIS VIEW MATTERS", systemImage: "scope")
                            .font(.caption2.weight(.black))
                            .tracking(0.75)
                            .foregroundStyle(accent)
                        Text(answer)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.white.opacity(0.84))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(10)
                    .background(accent.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(accent.opacity(0.22)))
                    .transition(.opacity)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Plain-language answer: \(answer)")
                }

                // A newcomer gets one clear spatial invitation. The optional
                // self-reported clarity check follows a real explanation, so
                // it cannot feel like a question before they have explored.
                if experience.selectedPointEntityName != nil {
                    Divider().overlay(Color.white.opacity(0.12))

                    HStack {
                        Text("CLARITY · SELF-REPORTED")
                            .font(.caption2.weight(.black))
                            .tracking(0.8)
                        Spacer()
                        Text(experience.familyClarityLabel)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(accent)
                    }

                    Slider(
                        value: Binding(
                            get: { experience.familyClarityCheck },
                            set: { experience.setFamilyClarityCheck($0) }
                        ),
                        in: 0...2,
                        step: 1
                    )
                    .tint(accent)
                    .accessibilityLabel("Record the family's self-reported explanation clarity")
                    .accessibilityValue(experience.familyClarityLabel)

                    HStack {
                        Text("Again")
                        Spacer()
                        Text("Unsure")
                        Spacer()
                        Text("Clear")
                    }
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.58))
                }
            } else {
                HStack {
                    Text(
                        "CHECKPOINT \(experience.presenterTeachingBeat.number) / " +
                        "\(StrokePresenterTeachingBeat.allCases.count) · " +
                        experience.presenterTeachingBeat.shortTitle.uppercased()
                    )
                        .font(.caption2.monospacedDigit().weight(.black))
                        .tracking(0.8)
                    Spacer()
                    HStack(spacing: 6) {
                        Circle()
                            .fill(experience.familyClarityWasSet ? accent : Color.white.opacity(0.30))
                            .frame(width: 7, height: 7)
                        Text("Clarity · \(experience.familyClarityLabel)")
                            .font(.caption.weight(.bold))
                    }
                }
                .foregroundStyle(.white.opacity(0.76))

                StrokePresenterConversationTopics().environmentObject(experience)

                Divider().overlay(Color.white.opacity(0.12))
                Text("Tap a term for plain words. Teaching model, not a patient scan.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.54))
            }
        }
        .foregroundStyle(.white.opacity(0.92))
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            experience.audienceLens == .family
                ? AnyShapeStyle(Color.black.opacity(0.66))
                : AnyShapeStyle(.thinMaterial),
            in: RoundedRectangle(cornerRadius: 18)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    experience.audienceLens == .family
                        ? accent.opacity(0.30)
                        : Color.white.opacity(0.10)
                )
        )
        .shadow(
            color: experience.audienceLens == .family ? .black.opacity(0.42) : .clear,
            radius: 12,
            y: 5
        )
        .frame(width: experience.audienceLens == .family ? 360 : 460)
        .frame(
            minHeight: experience.audienceLens == .clinician ? 300 : 220,
            alignment: .topLeading
        )
        .accessibilityElement(children: .contain)
    }

    private var accent: Color {
        experience.audienceLens == .family ? .orange : .mint
    }

}

/// A single spatial affordance rather than a miniature desktop toolbar.
/// The visible word is intentionally short; VoiceOver carries the full label.
private struct SpatialControlBubbleLabel: View {
    let title: String
    let systemImage: String
    let accent: Color
    let selected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(.regularMaterial)
            if selected {
                Circle()
                    .fill(accent.opacity(0.84))
            }

            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.headline.weight(.semibold))
                Text(title)
                    .font(.caption2.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .padding(7)
        }
        // A stable 80-point gaze target is about 20% larger than the previous
        // control without adding more controls or moving them during focus.
        .frame(width: 80, height: 80)
        .foregroundStyle(selected ? Color.black.opacity(0.82) : Color.white)
        .overlay(Circle().stroke(selected ? accent : Color.white.opacity(0.16), lineWidth: selected ? 2 : 1))
        .contentShape(Circle())
        .hoverEffect(.highlight)
    }
}

private struct StrokeIntentionAnnotation: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    /// Once the learner explicitly opens the concise fallback, repeating the
    /// technical summary above it adds words without adding a relationship.
    /// The selected 3D object stays visible, so this remains spatial rather
    /// than becoming a second, denser text card.
    private var isFamilyPlainWordsExpanded: Bool {
        experience.audienceLens == .family &&
            experience.familyNarrationTranscriptVisible
    }

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            VStack(spacing: 5) {
                Image(systemName: annotationIcon)
                    .font(.caption.weight(.black))
                    .foregroundStyle(annotationTint)
                    .frame(width: 25, height: 25)
                    .background(annotationTint.opacity(0.15), in: Circle())
                    .overlay(Circle().stroke(annotationTint.opacity(0.72), lineWidth: 1.5))

                Capsule()
                    .fill(annotationTint.opacity(0.52))
                    .frame(width: 2, height: 42)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 7) {
                    Text(annotationEyebrow)
                        .font(.caption2.weight(.black))
                        .tracking(0.9)
                        .foregroundStyle(.white.opacity(0.68))

                    Spacer(minLength: 8)

                    if experience.selectedPointEntityName != nil {
                        Button {
                            experience.clearPointSelection()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption2.weight(.bold))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Close selected lesson")
                    }
                }

                Text(annotationTitle)
                    .font(.headline.weight(.black))
                    .tracking(0.35)
                    .foregroundStyle(annotationTint)

                if !isFamilyPlainWordsExpanded {
                    Text(annotationMeaning)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.92))
                        .fixedSize(horizontal: false, vertical: true)
                }

                if experience.audienceLens == .clinician,
                   experience.selectedPointEntityName != nil {
                    if experience.pointField == .craniotomy {
                        Button("Move the layers", systemImage: "hand.pinch.fill") {
                            experience.startAccessLayerStudy()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.mint)
                        .disabled(!experience.accessLayerStudyAssetsAvailable)
                        .accessibilityHint("Opens a reversible bone and dura model, not an operative simulation")
                        if !experience.accessLayerStudyAssetsAvailable {
                            Text("Layer models are unavailable. You can still explore the brain.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Button("Pin note", systemImage: "pin.fill") {
                        experience.pinSelectedPointNote()
                    }
                    .buttonStyle(.bordered)
                    .tint(annotationTint)
                    .accessibilityHint("Keeps this authored teaching note in the spatial workspace")
                }

                if experience.audienceLens == .family,
                   experience.familyNarrationPromptVisible {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(
                            experience.narrationSetupAvailable
                                ? "OPTIONAL AUDIO"
                                : "PLAIN WORDS"
                        )
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)

                        HStack(spacing: 7) {
                            Button(
                                experience.narrationSetupAvailable ? "Play audio" : "Explain simply",
                                systemImage: experience.narrationSetupAvailable ? "waveform" : "text.book.closed"
                            ) {
                                if experience.narrationSetupAvailable {
                                    experience.acceptFamilyNarrationPrompt()
                                } else {
                                    experience.showFamilyNarrationTranscript()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(annotationTint)
                            .accessibilityHint(
                                experience.narrationSetupAvailable
                                    ? "Plays one authored explanation for the selected teaching point"
                                    : "Shows one authored explanation silently for the selected teaching point"
                            )

                        }
                    }
                    .padding(.top, 2)
                } else if experience.audienceLens == .family,
                          experience.familyNarrationTranscriptVisible,
                          let deeperText = experience.activeFamilyNarrationText {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PLAIN WORDS")
                            .font(.caption2.weight(.black))
                            .tracking(0.65)
                            .foregroundStyle(annotationTint)
                        Text(deeperText)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.white.opacity(0.82))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(6)
                        HStack {
                            Text("GENERIC TEACHING MODEL · NOT A PATIENT SCAN")
                                .font(.caption2.monospaced().weight(.bold))
                                .foregroundStyle(.white.opacity(0.44))
                                .lineLimit(1)
                                .minimumScaleFactor(0.66)
                                .layoutPriority(1)
                            Spacer(minLength: 0)
                            Button("Hide", systemImage: "chevron.up") {
                                experience.dismissFamilyNarrationPrompt()
                            }
                            .buttonStyle(.bordered)
                            .fixedSize(horizontal: true, vertical: false)
                            .accessibilityLabel("Hide plain-language explanation")
                        }
                    }
                    .padding(.top, 2)
                } else if experience.audienceLens == .family,
                          experience.activeFamilyNarrationText != nil {
                    Button("Stop voice", systemImage: "speaker.slash.fill") {
                        experience.dismissFamilyNarrationPrompt()
                    }
                    .buttonStyle(.bordered)
                    .tint(annotationTint)
                    .accessibilityHint("Stops the optional selected-point narration")
                }

                if showsFamilyReferenceAction {
                    Button {
                        experience.toggleSelectedPointReference()
                    } label: {
                        Label(
                            selectedReferenceActionTitle,
                            systemImage: experience.selectedPointReferenceExpanded
                                ? "eye.slash"
                                : "view.3d"
                        )
                        .font(.caption.weight(.bold))
                    }
                    .buttonStyle(.bordered)
                    .tint(annotationTint)
                    .accessibilityHint("Shows or hides the one generic 3D teaching reference related to this point")
                }

                if experience.audienceLens == .family,
                   experience.familyNarrationTranscriptVisible,
                   experience.selectedPointEntityName != nil {
                    familyFollowUpControls
                }
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 8)
        .background(.black.opacity(0.56), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(annotationTint.opacity(0.26)))
        .shadow(color: .black.opacity(0.72), radius: 8, y: 2)
        .frame(maxWidth: 310, alignment: .leading)
        .accessibilityElement(children: .contain)
    }

    /// Two authored follow-ups are enough to preserve curiosity without
    /// rebuilding the hidden family rail inside the point disclosure. The
    /// answer replaces itself in this same card, and clarity is always an
    /// explicit family response rather than an inferred anxiety signal.
    private var familyFollowUpControls: some View {
        VStack(alignment: .leading, spacing: 7) {
            Divider().overlay(Color.white.opacity(0.12))

            Text("ASK NEXT")
                .font(.caption2.weight(.black))
                .tracking(0.7)
                .foregroundStyle(annotationTint)

            ForEach(Array(experience.familyQuestionSuggestions.prefix(2)), id: \.self) { question in
                Button {
                    experience.selectFamilyQuestion(question)
                } label: {
                    HStack(spacing: 7) {
                        Image(systemName: "questionmark.circle")
                            .font(.caption.weight(.bold))
                        Text(question)
                            .font(.caption.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
                .buttonStyle(.bordered)
                .tint(annotationTint)
                .accessibilityHint("Shows one authored follow-up or moves to its matching teaching point")
            }

            if let answer = experience.selectedFamilyQuestionAnswer {
                Text(answer)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
                    .accessibilityLabel("Plain-language answer: \(answer)")
            }

            Text("DID THIS MAKE SENSE?")
                .font(.caption2.weight(.black))
                .tracking(0.65)
                .foregroundStyle(.white.opacity(0.58))

            HStack(spacing: 6) {
                clarityButton("Again", value: 0)
                clarityButton("Unsure", value: 1)
                clarityButton("Clear", value: 2)
            }

            if let response = experience.familyPointClarityResponse {
                HStack(alignment: .top, spacing: 7) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(annotationTint)
                        .frame(width: 3, height: 34)
                    Text(response)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 7)
                .background(annotationTint.opacity(0.09), in: RoundedRectangle(cornerRadius: 10))
                .transition(.opacity.combined(with: .move(edge: .top)))
                .accessibilityLabel("Clarity response: \(response)")
            }
        }
        .padding(.top, 2)
        .animation(.easeInOut(duration: 0.20), value: experience.familyClarityCheck)
        .animation(.easeInOut(duration: 0.20), value: experience.familyClarityWasSet)
    }

    private func clarityButton(_ title: String, value: Double) -> some View {
        let isSelected = experience.familyClarityWasSet && experience.familyClarityCheck == value
        return Button {
            withAnimation(.easeInOut(duration: 0.20)) {
                experience.setFamilyClarityCheck(value)
            }
        } label: {
            Text(title)
                .font(.caption2.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.borderedProminent)
        .tint(isSelected ? annotationTint : Color.white.opacity(0.14))
        .accessibilityLabel("Explanation clarity: \(title)")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }

    private var annotationTitle: String {
        if experience.closingReflectionVisible { return "YOU DO NOT HAVE TO HOLD EVERY ANSWER AT ONCE" }
        if experience.isClinicianScholarSkullInspectionActive { return "SKULL · REGISTRATION REVIEW" }
        if experience.selectedPointLabel == "Single neuron · schematic reference" {
            return "ONE NEURON"
        }
        if let selected = experience.selectedPointLabel { return selected.uppercased() }
        if experience.audienceLens == .family && experience.familyDiscoveryHintVisible {
            return "LOOK, THEN PINCH"
        }
        if experience.audienceLens == .clinician {
            return switch experience.presenterTeachingBeat {
            case .confirmContext: "GENERIC TEACHING ANATOMY"
            case .discussAccess: "PRESSURE STORY"
            case .protectiveCovering: "PROTECTIVE COVERING"
            case .explainPurpose: "MAKING ROOM"
            case .teamChecks: "WHAT THE TEAM REASSESSES"
            case .explainClosure: "ASSEMBLED TEACHING VIEW"
            }
        }
        return switch experience.procedureStep {
        case .chooseCase: "WHAT CHANGED?"
        case .inspectOcclusion: "WHY DOES PRESSURE BUILD?"
        case .discussCare: "WHAT CAN MAKING SPACE DO?"
        }
    }

    private var annotationEyebrow: String {
        if experience.selectedPointLabel == "Single neuron · schematic reference" {
            return "BRAIN ATLAS · 3D TEACHING MODEL"
        }
        let lesson = experience.pointField == .procedure ? "VESSEL STORY" : "BRAIN ATLAS"
        guard experience.audienceLens == .clinician else { return lesson }
        return "\(experience.selectedFictionalCase.id) · FICTIONAL · \(lesson)"
    }

    private var showsFamilyReferenceAction: Bool {
        experience.audienceLens == .family
            && experience.selectedPointEntityName != nil
            && (experience.procedureStep != .discussCare || experience.careViewPermissionGranted)
    }

    /// The neuron is a deliberately isolated 3D object, so the action names
    /// that object directly instead of repeating the point's internal label.
    /// Other references preserve their existing, relationship-led wording.
    private var selectedReferenceActionTitle: String {
        if experience.selectedPointLabel == "Single neuron · schematic reference" {
            return experience.selectedPointReferenceExpanded ? "Hide 3D neuron" : "Show 3D neuron"
        }
        return experience.selectedPointReferenceExpanded
            ? "Hide \(experience.teachingReferenceActionTitle())"
            : "Show \(experience.teachingReferenceActionTitle())"
    }

    private var annotationMeaning: String {
        if experience.closingReflectionVisible {
            return "A clear next step can make uncertainty feel smaller. Your care team will guide what comes next."
        }
        if experience.isClinicianScholarSkullInspectionActive {
            return "Generic cross-source teaching skull. Inspect shape only; alignment and landmarks still require specialist review."
        }
        if let selectedPointMeaning {
            return selectedPointMeaning
        }
        if experience.audienceLens == .family && experience.familyDiscoveryHintVisible {
            return "Look at one mint point, then pinch it. One idea opens at a time."
        }
        if experience.audienceLens == .clinician {
            return switch experience.presenterTeachingBeat {
            case .confirmContext:
                "The selected fictional file records \(experience.selectedFictionalCase.lead.lowercased()) and \(experience.selectedFictionalCase.context.lowercased()). This anatomy remains generic—not this person's scan."
            case .discussAccess: "Follow supply to the example blockage, then distinguish affected tissue from swelling."
            case .protectiveCovering: "The conceptual dura is offset only to explain its protective role."
            case .explainPurpose: "The reversible aperture shows room, not repaired tissue."
            case .teamChecks: "Discuss pressure, bleeding, imaging, and monitoring—no result is inferred."
            case .explainClosure: "Layers return together; suturing and fixation are not shown."
            }
        }
        return switch experience.procedureStep {
        case .chooseCase: "Start with the blockage in this generic teaching model."
        case .inspectOcclusion: "Swelling presses inside the fixed skull."
        case .discussCare: "The procedure can make room; it cannot undo stroke injury."
        }
    }

    /// A selected point owns the nearby disclosure. Keeping this copy keyed to
    /// the authored point prevents a checkpoint-level skull or dura sentence
    /// from describing a vessel, territory, or cortex marker.
    private var selectedPointMeaning: String? {
        guard let selectedPointLabel = experience.selectedPointLabel else { return nil }

        return switch selectedPointLabel {
        case "Example affected area":
            "Generic example only—not a scan or measured injury."
        case "Nearby brain tissue":
            "Nearby tissue stays visible so the explanation keeps context."
        case "Brain surface":
            "Surface orientation only; no incision or access site is planned."
        case "Opposite-side context":
            "A comparison reference—not a claim of normal function."
        case "Single neuron · schematic reference":
            "A generic 3D model of one branching nerve cell, not patient tissue or a recording."
        case "Blood supply approaches":
            "Follow the cues toward the brain: direction only, not speed or volume."
        case "Arteries branch":
            "Branches distribute supply; this generic map is not patient-specific."
        case "Example blockage":
            "A teaching clot interrupts the route; motion is qualitative—not CFD."
        case "Flow beyond the blockage changes":
            "Fewer cues continue beyond the example blockage; no perfusion value is inferred."
        case "Affected territory":
            "The highlighted territory explains risk—not prognosis or measured damage."
        default:
            "Generic teaching reference—not a patient scan or measurement."
        }
    }

    private var annotationIcon: String {
        if experience.closingReflectionVisible { return "sparkles" }
        if experience.isClinicianScholarSkullInspectionActive { return "view.3d" }
        return switch experience.procedureStep {
        case .chooseCase: "circle.dashed"
        case .inspectOcclusion: "arrow.up.and.down.and.arrow.left.and.right"
        case .discussCare: "square.dashed.inset.filled"
        }
    }

    private var annotationTint: Color {
        if experience.closingReflectionVisible { return .mint }
        if experience.isClinicianScholarSkullInspectionActive { return .cyan }
        return switch experience.procedureStep {
        case .chooseCase: .orange
        case .inspectOcclusion: .orange
        case .discussCare: .mint
        }
    }
}

private struct FamilyQuestionMarker: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "questionmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text("MARKED FOR CLARIFICATION")
                    .font(.caption2.weight(.bold))
                    .tracking(0.8)
                Text(markerMeaning)
                    .font(.caption.weight(.medium))
            }
        }
        .padding(11)
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.orange.opacity(0.42)))
        .accessibilityElement(children: .combine)
    }

    private var markerMeaning: String {
        switch experience.procedureStep {
        case .chooseCase: "Review which protective layer is shown."
        case .inspectOcclusion: "Review the blockage and tissue beyond."
        case .discussCare: "Review what generic access can and cannot show."
        }
    }
}

private struct SpatialPatientDrawer: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        let caseRecord = experience.selectedFictionalCase
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(caseRecord.id, systemImage: "folder.fill")
                    .font(.caption.weight(.bold))
                    .tracking(0.9)
                Spacer()
                Text("FICTIONAL · \(experience.selectedFictionalCaseIndex + 1) / \(StrokeFictionalCase.library.count)")
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 14) {
                FictionalCasePortrait(record: caseRecord, size: 92, selected: true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(caseRecord.displayName)
                        .font(.title3.weight(.bold))
                    Text("\(caseRecord.ageBand) · \(caseRecord.elapsed)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Original fictional portrait · no patient identity")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.orange.opacity(0.78))
                }
            }

            ScrollView(.horizontal) {
                HStack(spacing: 9) {
                    ForEach(Array(StrokeFictionalCase.library.enumerated()), id: \.element.id) { index, record in
                        Button {
                            experience.selectFictionalCase(at: index)
                        } label: {
                            VStack(spacing: 5) {
                                FictionalCasePortrait(
                                    record: record,
                                    size: 62,
                                    selected: index == experience.selectedFictionalCaseIndex
                                )
                                Text(record.displayName.components(separatedBy: " ").first ?? record.displayName)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(index == experience.selectedFictionalCaseIndex ? .orange : .secondary)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Fictional case \(record.id), \(record.displayName)")
                    }
                }
                .padding(.horizontal, 2)
            }
            .scrollIndicators(.hidden)
            .accessibilityLabel("Browse twelve fictional cases")

            HStack(spacing: 8) {
                evidenceChip(caseRecord.systemImage, caseRecord.lead, .orange)
                evidenceChip("person.2", caseRecord.context, .cyan)
                evidenceChip("clock.fill", caseRecord.elapsed, .yellow)
            }

            HStack(spacing: 7) {
                Button("Previous", systemImage: "chevron.left") {
                    experience.stepFictionalCase(by: -1)
                }
                .labelStyle(.iconOnly)

                Button("Use this file", systemImage: "arrow.up.right") {
                    experience.selectTeachingCase()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

                Button("Next", systemImage: "chevron.right") {
                    experience.stepFictionalCase(by: 1)
                }
                .labelStyle(.iconOnly)
            }
            .buttonBorderShape(.capsule)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.orange.opacity(0.9))
                .frame(width: 78, height: 10)
                .offset(x: 12, y: -7)
        }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.14)))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Fictional case \(caseRecord.id), \(caseRecord.displayName), \(caseRecord.lead), \(caseRecord.context), \(caseRecord.elapsed)")
    }

    private func evidenceChip(_ icon: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(tint)
            Text(label)
                .font(.caption2.weight(.semibold))
        }
        .lineLimit(2)
        .minimumScaleFactor(0.82)
        .frame(maxWidth: .infinity, minHeight: 58)
        .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 11))
    }
}

/// A portrait is presentation art for an authored fictional record. It is
/// never camera input, face analysis, a patient image, or inferred identity.
private struct FictionalCasePortrait: View {
    let record: StrokeFictionalCase
    let size: CGFloat
    let selected: Bool

    var body: some View {
        Image(record.portraitAssetName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .stroke(selected ? Color.orange : Color.white.opacity(0.16), lineWidth: selected ? 3 : 1)
            }
            .shadow(color: selected ? Color.orange.opacity(0.16) : .clear, radius: 10)
            .accessibilityHidden(true)
    }
}

private struct LessonSpecimenRail: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "scope")
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text(experience.pointField == .procedure ? "VESSEL STORY" : "BRAIN ATLAS")
                    .font(.caption2.weight(.black))
                    .tracking(0.9)
                Text(experience.selectedPointLabel ?? "")
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            Button {
                experience.clearPointSelection()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption2.weight(.bold))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close selected lesson")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.thinMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.white.opacity(0.13), lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(experience.selectedPointLabel ?? "Selected anatomy lesson")
    }
}

struct StrokeJourneyCompanionView: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        JourneyCaption()
            .frame(width: experience.audienceLens == .clinician ? 424 : 424)
            .padding(14)
            .frame(
                width: 460,
                height: experience.audienceLens == .clinician ? 560 : 310
            )
            .animation(.easeInOut(duration: 0.28), value: experience.audienceLens)
    }
}

private struct JourneyCaption: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: experience.audienceLens == .clinician ? 16 : 12) {
            HStack(alignment: .center) {
                Text("\(experience.procedureStep.number) / 3")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundStyle(.cyan)
                Text(experience.journeyTitle.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.8)
                Spacer()
                Label(
                    experience.audienceLens == .clinician ? "PRESENTER ONLY" : "FAMILY QUESTIONS",
                    systemImage: experience.audienceLens == .clinician ? "lock.fill" : "person.2.fill"
                )
                .font(.caption2.weight(.bold))
                .foregroundStyle(experience.audienceLens == .clinician ? .orange : .cyan)

                Button {
                    experience.soundEnabled.toggle()
                } label: {
                    Image(systemName: experience.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                }
                .buttonStyle(.plain)
                .accessibilityLabel(experience.soundEnabled ? "Mute ambient sound" : "Enable ambient sound")

                Button {
                    Task { await exitExperience() }
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Exit to patient files")
            }

            if experience.closingReflectionVisible {
                sharedDiscussion
            } else if experience.audienceLens == .clinician {
                clinicianPresenter
            } else {
                patientExplanation
            }

            if experience.closingReflectionVisible {
                sharedDiscussionNavigation
            } else if experience.isConsentPromptVisible {
                consentChoice
            } else if experience.audienceLens == .family {
                familyFeedback
            } else {
                clinicianNavigation
            }

            Text("Teaching model · not a patient scan")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(experience.audienceLens == .clinician ? 22 : 18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white.opacity(0.12)))
    }

    private var sharedDiscussion: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SHARED DISCUSSION")
                .font(.caption.weight(.black))
                .tracking(1.2)
                .foregroundStyle(.mint)

            discussionRow(
                "SHOWN",
                "Generic anatomy, blockage, pressure, and the purpose of making space.",
                systemImage: "eye.fill"
            )
            discussionRow(
                "CANNOT ANSWER",
                "This teaching view does not diagnose or recommend care.",
                systemImage: "minus.circle"
            )
            discussionRow(
                "QUESTIONS",
                "What did imaging show? What are the options? What happens next?",
                systemImage: "questionmark.bubble.fill"
            )
        }
        .padding(12)
        .background(Color.mint.opacity(0.075), in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(Color.mint.opacity(0.18)))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Shared discussion summary")
    }

    private func discussionRow(_ title: String, _ text: String, systemImage: String) -> some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .foregroundStyle(.mint)
                .frame(width: 18)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.black))
                    .tracking(0.7)
                    .foregroundStyle(.white.opacity(0.62))
                Text(text)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.90))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var sharedDiscussionNavigation: some View {
        Button {
            experience.advanceJourney()
        } label: {
            Label(
                experience.audienceLens == .clinician ? "Return to patient files" : "Restart exhibit",
                systemImage: experience.audienceLens == .clinician ? "folder" : "arrow.counterclockwise"
            )
            .font(.callout.weight(.semibold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.mint)
    }

    private var patientExplanation: some View {
        VStack(spacing: 10) {
            Text(experience.journeyCaption)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(experience.journeyIntent)
                .font(.callout.weight(.medium))
                .foregroundStyle(.cyan.opacity(0.92))
        }
    }

    private var clinicianPresenter: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(spacing: 8) {
                Button {
                    cycleAnatomyPresentation()
                } label: {
                    compactControl(experience.anatomyPresentation.rawValue, systemImage: "circle.lefthalf.filled")
                }
                .buttonStyle(.plain)
                .contentShape(Capsule())
                .hoverEffect(.highlight)
                .accessibilityLabel("Layer style")
                .accessibilityValue(experience.anatomyPresentation.rawValue)
                .accessibilityHint("Pinch to show the next layer style")

                Button {
                    cycleLessonFamily()
                } label: {
                    compactControl(experience.pointField.rawValue, systemImage: experience.pointField.systemImage)
                }
                .buttonStyle(.plain)
                .contentShape(Capsule())
                .hoverEffect(.highlight)
                .accessibilityLabel("Lesson family")
                .accessibilityValue(experience.pointField.rawValue)
                .accessibilityHint("Pinch to show the next lesson family")

                Button {
                    if experience.isImmersivePresented {
                        experience.openReferenceWorkspace(.guides)
                    } else {
                        openWindow(id: StrokeSpace.evidence, value: StrokeSpace.evidence)
                    }
                } label: {
                    Image(systemName: "text.book.closed.fill")
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.bordered)
                .tint(.cyan)
                .accessibilityLabel("Open clinical evidence space")
            }

            if experience.anatomyPresentation != .assembled {
                HStack(spacing: 9) {
                    Image(systemName: "circle.lefthalf.filled")
                        .foregroundStyle(.cyan)
                    Slider(value: $experience.cortexOpacity, in: 0.16...0.82)
                        .accessibilityLabel("Brain transparency")
                }
            }

            if let selectedPointLabel = experience.selectedPointLabel {
                HStack(spacing: 8) {
                    Image(systemName: "scope")
                        .foregroundStyle(.cyan)
                    Text(selectedPointLabel)
                        .font(.callout.weight(.semibold))
                    Spacer()
                    Button {
                        experience.clearPointSelection()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear selected anatomy point")
                }
                .padding(.horizontal, 11)
                .frame(minHeight: 38)
                .background(Color.cyan.opacity(0.08), in: Capsule())
            }

            if experience.clarificationRequested {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "questionmark.bubble.fill")
                        .foregroundStyle(.orange)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(experience.questionMarkerVisible ? "FAMILY POINTED TO THIS AREA" : "FAMILY ASKED TO CLARIFY")
                            .font(.caption.weight(.bold))
                            .tracking(1.0)
                            .foregroundStyle(.orange)
                        Text(experience.clarificationCue)
                            .font(.callout.weight(.medium))
                    }
                    Spacer()
                    Button("Addressed") {
                        experience.acknowledgeClarification()
                        experience.clearQuestionMarker()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(12)
                .background(Color.orange.opacity(0.10), in: RoundedRectangle(cornerRadius: 15))
            }

            Label(clinicianFocusCue, systemImage: "scope")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.cyan)
                .lineLimit(2)
        }
    }

    private func compactControl(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .frame(minHeight: 44)
            .background(Color.white.opacity(0.08), in: Capsule())
    }

    private func cycleAnatomyPresentation() {
        switch experience.anatomyPresentation {
        case .assembled:
            experience.setAnatomyPresentation(.transparent)
        case .transparent:
            experience.setAnatomyPresentation(.exploded)
        case .exploded:
            experience.setAnatomyPresentation(.assembled)
        }
    }

    private func cycleLessonFamily() {
        experience.pointField = experience.pointField == .regions ? .procedure : .regions
        experience.clearPointSelection()
    }

    private var clinicianFocusCue: String {
        switch experience.procedureStep {
        case .chooseCase:
            "Whole brain first."
        case .inspectOcclusion:
            "Separate blockage, injury, swelling."
        case .discussCare:
            "Fade one layer. Room, not repair."
        }
    }

    private var familyFeedback: some View {
        HStack(spacing: 12) {
            Button(experience.requestedPause ? "Resume" : "Pause", systemImage: experience.requestedPause ? "play.fill" : "pause.fill") {
                experience.togglePause()
            }
            .buttonStyle(.bordered)

            Button(
                experience.clarificationRequested ? "Marked" : "Clarify",
                systemImage: experience.clarificationRequested ? "checkmark.circle.fill" : "questionmark.bubble"
            ) {
                experience.requestClarification()
            }
            .buttonStyle(.borderedProminent)
            .tint(experience.clarificationRequested ? .orange : .cyan)
            .disabled(experience.clarificationRequested)

            Button(
                experience.questionPlacementArmed ? "Tap brain…" : "Point on brain",
                systemImage: experience.questionPlacementArmed ? "hand.point.up.left.fill" : "mappin.and.ellipse"
            ) {
                experience.toggleQuestionPlacement()
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Family pace and clarification controls")
    }

    private var clinicianNavigation: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                if experience.procedureStep != .chooseCase {
                    Button("Back", systemImage: "chevron.left") {
                        experience.retreatJourney()
                    }
                    .buttonStyle(.bordered)
                }

                Button(experience.requestedPause ? "Resume" : "Pause", systemImage: experience.requestedPause ? "play.fill" : "pause.fill") {
                    experience.togglePause()
                }
                .buttonStyle(.bordered)

                Spacer(minLength: 8)

                Button("Reset view", systemImage: "arrow.counterclockwise") {
                    experience.resetSpatialView()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .accessibilityHint("Restores the original model rotation and scale")
            }

            Button {
                experience.advanceJourney()
            } label: {
                Label(experience.primaryActionTitle, systemImage: "arrow.right")
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
        }
    }

    @MainActor
    private func exitExperience() async {
        await dismissImmersiveSpace()
        experience.isImmersivePresented = false
        openWindow(id: StrokeSpace.window)
        dismissWindow(id: StrokeSpace.evidence)
        dismissWindow(id: experience.audienceLens == .clinician ? StrokeSpace.presenter : StrokeSpace.family)
    }

    private var consentChoice: some View {
        VStack(spacing: 10) {
            Text("May I make the protective layers transparent? No incision or blood.")
                .font(.callout.weight(.semibold))
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button("Not now") {
                    experience.declineCareView()
                }
                .buttonStyle(.bordered)

                Button("Reveal layers") {
                    experience.grantNonGraphicCareViewPermission(reduceMotion: reduceMotion)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
            }
        }
        .padding(14)
        .background(Color.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 18))
    }
}

private struct SpatialHierarchySpine: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                if index > 0 {
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                Label(label.title, systemImage: label.icon)
                    .font(.caption.weight(index == labels.count - 1 ? .bold : .medium))
                    .foregroundStyle(index == labels.count - 1 ? .orange : .primary.opacity(0.72))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .glassBackgroundEffect(in: Capsule())
        .accessibilityLabel(labels.map(\.title).joined(separator: ", "))
    }

    private var labels: [(title: String, icon: String)] {
        switch experience.procedureStep {
        case .chooseCase:
            [("Head", "person.crop.circle"), ("Brain", "brain.head.profile")]
        case .inspectOcclusion:
            [("Brain", "brain.head.profile"), ("Artery", "point.topleft.down.to.point.bottomright.curvepath"), ("Clot", "circle.fill")]
        case .discussCare:
            [("Head", "person.crop.circle"), ("Skull", "shield.lefthalf.filled"), ("Pressure space", "arrow.up.left.and.arrow.down.right")]
        }
    }
}

private struct SpatialCaseFact: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let milestone: StrokeCaseHistoryMilestone

    var body: some View {
        Button {
            experience.selectCaseHistoryMilestone(
                milestone,
                reduceMotion: reduceMotion
            )
        } label: {
            Group {
                if milestone == experience.selectedCaseHistoryMilestone {
                    VStack(alignment: .leading, spacing: 5) {
                        Label(milestone.shortTitle.uppercased(), systemImage: milestone.systemImage)
                            .font(.caption2.weight(.bold))
                            .tracking(0.9)
                            .foregroundStyle(.orange)
                        Text("\(experience.selectedFictionalCase.id) · \(experience.selectedFictionalCase.displayName.uppercased())")
                            .font(.caption2.monospaced().weight(.black))
                            .foregroundStyle(.white.opacity(0.72))
                        Text(experience.caseHistoryWebValue(for: milestone))
                            .font(.headline)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .frame(width: 190, alignment: .leading)
                    .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 18))
                } else {
                    Image(systemName: milestone.systemImage)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))
                        .frame(width: 50, height: 50)
                        .glassBackgroundEffect(in: Circle())
                }
            }
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(milestone.shortTitle), \(experience.caseHistoryWebValue(for: milestone))")
    }
}

private struct LayerContextBreadcrumb: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "square.3.layers.3d")
                .foregroundStyle(.mint)
            ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                if index > 0 {
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(.secondary.opacity(0.55))
                }
                Text(label)
                    .font(.caption.weight(index == labels.count - 1 ? .bold : .medium))
                    .foregroundStyle(index == labels.count - 1 ? .primary : .secondary)
            }
            Spacer()
            Text("YOU ARE HERE")
                .font(.caption2.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(.mint.opacity(0.86))
        }
        .padding(.horizontal, 12)
        .frame(height: 34)
        .background(Color.mint.opacity(0.075), in: Capsule())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Layer context: \(labels.joined(separator: ", "))")
    }

    private var labels: [String] {
        switch experience.procedureStep {
        case .chooseCase: ["Head", "Skull", "Brain"]
        case .inspectOcclusion: ["Brain", "Artery", "Clot"]
        case .discussCare: ["Head", "Skull", "Pressure space"]
        }
    }
}
