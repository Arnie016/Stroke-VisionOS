import AVFoundation
import ARKit
import QuartzCore
import RealityKit
import SwiftUI

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
    static let secondaryCaseDrawer: SIMD3<Float> = [0.50, 1.50, -0.74]
    static let tertiaryHorizon: SIMD3<Float> = [0.10, 1.64, -1.72]

    static let primaryScale: Float = 2.12
    static let orientScale: Float = 1.98
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
    private let scholarReferenceRailID = "spatial-scholar-reference-rail"
    private let familyControlsID = "spatial-family-controls"
    private let presenterControlsID = "spatial-presenter-controls"
    private let clinicianToolWheelID = "clinician-hand-tool-wheel"
    private let clinicianToolWheelAnchorName = "clinician-left-palm-tool-anchor"
    private let clinicianHeldToolAnchorName = "clinician-right-palm-tool-anchor"
    private let stageRootName = "stroke-world-locked-stage"

    var body: some View {
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
                    experience.updateAvailableAnatomyFocuses(
                        StrokeSceneFactory.availableAnatomyFocuses(in: root)
                    )
                    await installSpatialAudio(on: root)

                    detailedSceneLoadTask?.cancel()
                    detailedSceneLoadTask = Task { @MainActor in
                        let detailedRoot = await StrokeSceneFactory.makeScene()
                        guard !Task.isCancelled else { return }
                        root.removeFromParent()
                        stageRoot.addChild(detailedRoot)
                        experience.updateAvailableAnatomyFocuses(
                            StrokeSceneFactory.availableAnatomyFocuses(in: detailedRoot)
                        )
                        await installSpatialAudio(on: detailedRoot)
                        isSceneReady = true
                    }

                    let caseRoom = StrokeSceneFactory.makeSpatialCaseIntake()
                    stageRoot.addChild(caseRoom)

                    let handProof = CommandLine.arguments.contains("--proof-clinician-toolkit")
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
                    heldToolAnchor.addChild(await StrokeSceneFactory.makeClinicianHeldTools())
                    content.add(heldToolAnchor)

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
                        intensity: 1_150
                    ))
                    focusLight.orientation = simd_quatf(angle: -0.48, axis: [1, 0, 0])
                        * simd_quatf(angle: 0.52, axis: [0, 1, 0])
                    // The warm museum field still needs a sculpting key light;
                    // otherwise the high-density cortex reads like flat clay.
                    // Passthrough keeps this off so room lighting remains honest.
                    focusLight.isEnabled = experience.environmentMode != .surroundings
                    stageRoot.addChild(focusLight)

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
                        teachingTimelineID, viewpointControlID, roleMicroCuesID, familyBrainAtlasID, teachingImagingDrawerID,
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
                    let anatomyVisible = experience.spatialPhase == .explanation
                    root.isEnabled = anatomyVisible
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
                        miniature.position = StrokeSceneFactory.registeredTeachingImagingSuggestedStagePosition
                        let miniatureScale = StrokeSceneFactory.registeredTeachingImagingSuggestedStageScale
                        miniature.scale = [miniatureScale, miniatureScale, miniatureScale]
                        StrokeSceneFactory.updateRegisteredTeachingImaging(
                            root: stageRoot,
                            isVisible: experience.spatialPhase == .explanation
                                && experience.teachingImagingDrawerVisible,
                            lens: experience.teachingImagingLens
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
                        // procedural bust placeholder. The dossier and its
                        // connected facts are the spatial case representation
                        // until a reviewed fictional-person asset exists.
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFigureName)?.isEnabled = inReview
                        StrokeSceneFactory.updateSpatialCaseIntake(
                            root: caseRoom,
                            experience: experience
                        )
                    }
                    if let caseRoom = stageRoot.findEntity(named: StrokeSceneFactory.spatialCaseRoomName),
                       let file = caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFileName) {
                        let inReview = experience.spatialPhase == .caseReview
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
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseDockName)?.isEnabled =
                            experience.spatialPhase == .caseLibrary && !experience.spatialCaseDocked
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

                    if let annotation = attachments.entity(for: annotationID) {
                        let selectedPoint = experience.selectedPointEntityName.flatMap {
                            root.findEntity(named: $0)
                        }
                        // A deliberately selected cue owns its explanation at
                        // the same anatomical depth. This prevents an Atlas
                        // reveal from floating up into room-space like a HUD
                        // while retaining the existing high-level annotation
                        // position for an unselected three-act checkpoint.
                        let annotationParent = selectedPoint?.parent
                            ?? stageRoot.findEntity(named: annotationAnchorName)
                        if let annotationParent, annotation.parent !== annotationParent {
                            annotation.removeFromParent()
                            annotationParent.addChild(annotation)
                        }
                        if let selectedPoint {
                            // The selected-point callout deliberately clears
                            // the anatomy silhouette before billboarding to
                            // the wearer. It remains parented to the point
                            // field, but reads as a compact spatial callout
                            // rather than overlapping detail on the brain.
                            annotation.position = selectedPoint.position + [0.064, 0.052, 0.032]
                        } else {
                            annotationParent?.position = annotationPosition
                            annotation.position = .zero
                        }
                        annotation.scale = [0.78, 0.78, 0.78]
                        annotation.isEnabled = experience.spatialPhase == .explanation && (
                            experience.selectedPointEntityName != nil ||
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
                    if let marker = attachments.entity(for: questionMarkerID) {
                        if marker.parent == nil {
                            stageRoot.addChild(marker)
                        }
                        marker.position = questionMarkerPosition(in: root, relativeTo: stageRoot)
                        marker.scale = [0.72, 0.72, 0.72]
                        marker.isEnabled = experience.spatialPhase == .explanation && experience.questionMarkerVisible
                        marker.components.set(BillboardComponent())
                    }
                    if let drawer = attachments.entity(for: caseDrawerID) {
                        if drawer.parent == nil {
                            stageRoot.addChild(drawer)
                        }
                        // This is the focused dossier's compact briefing, not
                        // persistent furniture. It exists only in the archive
                        // threshold and disappears with the case room.
                        drawer.position = [-0.31, 1.45, -0.76]
                        drawer.scale = [0.62, 0.62, 0.62]
                        drawer.isEnabled = experience.spatialPhase == .caseLibrary
                        drawer.components.set(BillboardComponent())
                    }
                    if let rail = attachments.entity(for: lessonSpecimenRailID) {
                        let selected = experience.selectedPointEntityName.flatMap {
                            root.findEntity(named: $0)
                        }
                        if let selected, let pointField = selected.parent {
                            if rail.parent !== pointField {
                                rail.removeFromParent()
                                pointField.addChild(rail)
                            }
                            // Keep the one revealed explanation beside its
                            // selected point at the same anatomical depth.
                            rail.position = selected.position + [0.038, 0.020, 0.012]
                            rail.scale = [0.42, 0.42, 0.42]
                        }
                        rail.isEnabled = experience.spatialPhase == .explanation && selected != nil
                        rail.components.set(BillboardComponent())
                    }
                    updateSpatialIntakeAttachments(attachments)
                    updateSpatialTeachingAttachments(attachments)
                    updateSpatialRoleControls(attachments, stageRoot: stageRoot)
                    updateClinicianHandToolKit(content: content, attachments: attachments)
                    updateAudioMix()
                } attachments: {
                    Attachment(id: annotationID) {
                        StrokeIntentionAnnotation()
                            .environmentObject(experience)
                            .frame(width: 255)
                    }
                    Attachment(id: questionMarkerID) {
                        FamilyQuestionMarker()
                            .environmentObject(experience)
                            .frame(width: 210)
                    }
                    Attachment(id: caseDrawerID) {
                        SpatialPatientDrawer()
                            .environmentObject(experience)
                            .frame(width: 250)
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
                            .frame(width: 350)
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
                            .frame(width: 430)
                    }
                    Attachment(id: familyBrainAtlasID) {
                        SpatialFamilyBrainAtlas()
                            .environmentObject(experience)
                            .frame(width: 720)
                    }
                    Attachment(id: teachingImagingDrawerID) {
                        StrokeTeachingImagingDrawer()
                            .environmentObject(experience)
                            .frame(width: 330)
                    }
                    Attachment(id: scholarReferenceRailID) {
                        StrokeScholarReferenceRail()
                            .environmentObject(experience)
                            .frame(width: 310)
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
                    isEnabled: !experience.questionPlacementArmed
                )
                .gesture(
                    DragGesture(minimumDistance: 3)
                        .targetedToAnyEntity()
                        .onChanged { value in
                            if StrokeSceneFactory.isSpatialCaseFileTarget(value.entity) {
                                let scenePoint = value.convert(value.location3D, from: .local, to: .scene)
                                let localPoint = spatialCaseRoom(for: value.entity)?.convert(
                                    position: scenePoint,
                                    from: nil
                                ) ?? scenePoint
                                experience.moveSpatialCaseFile(to: localPoint)
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
                            } else if StrokeSceneFactory.semanticTarget(for: value.entity) == "blocked vessel" ||
                                StrokeSceneFactory.semanticTarget(for: value.entity) == "affected brain region" {
                                experience.focusOcclusion()
                            } else if let point = StrokeSceneFactory.pointFieldSelection(for: value.entity) {
                                experience.selectPoint(entityName: point.entityName, label: point.label)
                            }
                        }
                )
            .onChange(of: experience.soundEnabled) { _, _ in updateAudioMix() }
            .onAppear {
                isSceneReady = false
                stagePlacement.start()
                synchronizeImmersionStyle()
                synchronizeNarration()
            }
            .onChange(of: experience.environmentMode) { _, _ in
                synchronizeImmersionStyle()
            }
            .onChange(of: experience.narrationEnabled) { _, _ in
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

    /// GPT-Realtime narration is a family-only teaching aid. Pausing stops the
    /// current request/player; resuming may restart the current authored line.
    private func synchronizeNarration() {
        guard experience.audienceLens == .family,
              experience.narrationEnabled,
              !experience.requestedPause else {
            narrator.stop()
            return
        }
        narrator.speak(experience.journeyCaption)
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
            (hierarchySpineID, [0, 1.94, -0.72], 0.72, inReview && reveal > 0.70),
            (speechFactID, [-0.27, 1.76, -0.76], 0.58, inReview && reveal > 0.60),
            (armFactID, [-0.28, 1.50, -0.76], 0.58, inReview && reveal > 0.67),
            (timeFactID, [0.28, 1.50, -0.76], 0.58, inReview && reveal > 0.74),
            (questionFactID, [0.27, 1.76, -0.76], 0.58, inReview && reveal > 0.81),
            (caseHistoryTimelineID, [0, 1.09, -0.70], 0.60, inReview && reveal > 0.82),
            (caseReviewActionsID, [0, 0.89, -0.68], 0.56, inReview && reveal > 0.96)
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

    private func updateSpatialTeachingAttachments(_ attachments: RealityViewAttachments) {
        let visible = experience.spatialPhase == .explanation
        let isFamily = experience.audienceLens == .family
        let placements: [(String, SIMD3<Float>, Float)] = [
            // Keep the active chapter comfortably inside the primary field.
            // Inactive chapters collapse to quiet numbered dots below, so the
            // timeline reads as orientation rather than another toolbar.
            (teachingTimelineID, [0, 1.13, -0.86], isFamily ? 0.80 : 0.82),
            // Family questions are shared content, not a far-peripheral
            // presenter rail. The larger 0.86-scale field makes authored
            // questions and the explicit clarity check legible in a shared
            // conversation while the anatomy remains central and dominant.
            (roleMicroCuesID, isFamily ? [-0.43, 1.66, -0.90] : [-0.56, 1.72, -0.90], isFamily ? 0.86 : 0.82)
        ]

        for (id, position, scale) in placements {
            guard let attachment = attachments.entity(for: id) else { continue }
            attachment.position = position
            attachment.scale = [scale, scale, scale]
            attachment.isEnabled = visible && !(id == roleMicroCuesID && isFamily && experience.familyBrainAtlasVisible)
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
            viewpoint.isEnabled = visible && experience.audienceLens == .clinician
            viewpoint.components.set(BillboardComponent())
        }

        if let drawer = attachments.entity(for: teachingImagingDrawerID) {
            drawer.position = SpatialVisualField.secondaryCaseDrawer
            drawer.scale = [0.68, 0.68, 0.68]
            drawer.isEnabled = visible && experience.teachingImagingDrawerVisible
            drawer.components.set(BillboardComponent())
        }

        if let scholarRail = attachments.entity(for: scholarReferenceRailID) {
            scholarRail.position = [0.72, 1.76, -0.94]
            scholarRail.scale = [0.88, 0.88, 0.88]
            scholarRail.isEnabled = visible &&
                experience.audienceLens == .clinician &&
                experience.detailLevel == .scholar
            scholarRail.components.set(BillboardComponent())
        }
    }

    private func updateSpatialRoleControls(
        _ attachments: RealityViewAttachments,
        stageRoot: Entity
    ) {
        let controls: [(String, SIMD3<Float>, Float, Bool)] = [
            (familyControlsID, [-0.43, 1.28, -0.90], 0.74, experience.audienceLens == .family),
            (presenterControlsID, [0.58, 1.38, -0.92], 0.86, experience.audienceLens == .clinician)
        ]

        for (id, position, scale, correctRole) in controls {
            guard let attachment = attachments.entity(for: id) else { continue }
            if attachment.parent == nil { stageRoot.addChild(attachment) }
            attachment.position = position
            attachment.scale = [scale, scale, scale]
            attachment.isEnabled = experience.spatialPhase == .explanation && correctRole
            attachment.components.set(BillboardComponent())
        }
    }

    private func updateClinicianHandToolKit(
        content: RealityViewContent,
        attachments: RealityViewAttachments
    ) {
        let enabled = experience.spatialPhase == .explanation &&
            experience.audienceLens == .clinician &&
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
            wheel.isEnabled = enabled
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
                enabled: enabled && experience.clinicianToolKitVisible
            )
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
        VStack(spacing: 10) {
            Label("CASE 78 · FICTIONAL", systemImage: "person.text.rectangle.fill")
                .font(.caption.weight(.black))
                .tracking(1.0)
                .foregroundStyle(.orange)

            HStack(spacing: 10) {
                Button {
                    experience.returnCaseToLibrary()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Return file")

                Button(
                    experience.audienceLens == .family ? "Begin family view" : "Begin presenter view",
                    systemImage: "brain.head.profile"
                ) {
                    experience.beginExplanation()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }

            Text("Teaching anatomy · not a patient scan")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.orange.opacity(0.24)))
    }
}

/// A palm-anchored, clinician-only instrument selector. It stays as a small
/// cuff until the clinician deliberately opens it; gaze plus pinch selects a
/// tool. No raw eye position or custom pinch inference is used.
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
        CGSize(width: -12, height: -140),
        CGSize(width: 65, height: -88),
        CGSize(width: 95, height: 0),
        CGSize(width: 65, height: 88),
        CGSize(width: -12, height: 140)
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
                        .frame(width: 390, height: 390)

                    ForEach(Array(StrokeClinicianTool.allCases.enumerated()), id: \.element.id) { index, tool in
                        toolButton(tool)
                            .offset(arcOffsets[index])
                    }
                }

                Button {
                    experience.toggleClinicianToolKit()
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: experience.clinicianToolKitVisible ? "xmark" : "cross.case.fill")
                            .font(.title2.weight(.semibold))
                        Text(experience.clinicianToolKitVisible ? "CLOSE" : "KIT")
                            .font(.caption2.weight(.black))
                            .tracking(0.7)
                    }
                    .frame(width: 88, height: 88)
                }
                .buttonStyle(.plain)
                .background(Color.mint.opacity(0.20), in: Circle())
                .overlay(Circle().stroke(Color.mint.opacity(0.52), lineWidth: 2))
                .offset(x: -72)
                .accessibilityLabel(experience.clinicianToolKitVisible ? "Close clinician tools" : "Open clinician tools")
            }
            .frame(width: 390, height: 390)

            if experience.clinicianToolKitVisible {
                VStack(spacing: 3) {
                    Text(experience.selectedClinicianTool.rawValue.uppercased())
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
                .frame(width: 280)
                .offset(x: 42)
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
}

/// Role controls live inside the immersive room instead of opening another
/// desktop-like window. They read as a small constellation of gaze-sized
/// bubbles: family controls stay left and low; presenter controls stay right.
/// The shared anatomy remains the only foveal object.
private struct SpatialRoleControls: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL
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

                Text("ACT \(experience.procedureStep.number) OF 3")
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .foregroundStyle(.secondary.opacity(0.82))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.regularMaterial, in: Capsule())

            if role == .family {
                familyControls
            } else {
                presenterControls
            }

            if experience.isConsentPromptVisible {
                consentControls
            }
        }
        .padding(4)
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

                bubbleButton(
                    experience.narrationEnabled ? "Narrator off" : "Narrator",
                    systemImage: experience.narrationEnabled ? "speaker.slash.fill" : "waveform",
                    accent: .orange,
                    selected: experience.narrationEnabled
                ) {
                    experience.setNarrationEnabled(!experience.narrationEnabled)
                }
                .accessibilityLabel(experience.narrationEnabled ? "Turn off family narrator" : "Turn on family narrator")

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
                    openWindow(id: StrokeSpace.evidence)
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
        VStack(alignment: .trailing, spacing: 8) {
            HStack(spacing: 8) {
                bubbleButton(
                    layerBubbleTitle,
                    systemImage: "square.3.layers.3d",
                    accent: .mint,
                    selected: experience.anatomyPresentation != .assembled
                ) {
                    cycleAnatomyPresentation()
                }
                .accessibilityLabel("Layer style")
                .accessibilityValue(experience.anatomyPresentation.rawValue)
                .accessibilityHint("Pinch to show the next layer style")

                bubbleButton(
                    lessonFamilyBubbleTitle,
                    systemImage: experience.pointField.systemImage,
                    accent: .mint,
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
                    accent: .mint,
                    selected: experience.lessonPointsVisible
                ) {
                    experience.toggleLessonPoints()
                }
                .accessibilityLabel(experience.lessonPointsVisible ? "Hide lesson points" : "Show lesson points")

                bubbleButton(
                    environmentBubbleTitle,
                    systemImage: experience.environmentMode.systemImage,
                    accent: .mint,
                    selected: experience.environmentMode != .surroundings
                ) {
                    cycleEnvironment()
                }
                .accessibilityLabel("Environment")
                .accessibilityValue(experience.environmentMode.rawValue)
                .accessibilityHint("Pinch to show the next environment")

                bubbleButton(
                    "Evidence",
                    systemImage: "text.book.closed.fill",
                    accent: .mint
                ) {
                    openWindow(id: StrokeSpace.evidence)
                }
                .accessibilityLabel("Open clinical evidence")
            }

            HStack(spacing: 8) {
                bubbleButton(
                    "Reset",
                    systemImage: "arrow.counterclockwise",
                    accent: .mint
                ) {
                    experience.resetSpatialView()
                }
                .accessibilityLabel("Reset view")
                .accessibilityHint("Restores the original model rotation and scale")

                bubbleButton(
                    experience.requestedPause ? "Resume" : "Pause",
                    systemImage: experience.requestedPause ? "play.fill" : "pause.fill",
                    accent: .mint,
                    selected: experience.requestedPause
                ) {
                    experience.togglePause()
                }

                bubbleButton(
                    experience.soundEnabled ? "Ambient off" : "Ambient",
                    systemImage: experience.soundEnabled ? "speaker.slash.fill" : "speaker.wave.2.fill",
                    accent: .mint,
                    selected: experience.soundEnabled
                ) {
                    experience.soundEnabled.toggle()
                }
                .accessibilityLabel(experience.soundEnabled ? "Mute ambient sound" : "Enable ambient sound")

                bubbleButton(
                    experience.closingReflectionVisible ? "Cases" : "Next",
                    systemImage: "arrow.right",
                    accent: .mint,
                    selected: true
                ) {
                    experience.advanceJourney()
                }

                if experience.isInteriorPortalAvailable {
                    brainInteriorButton(accent: .mint)
                }
                exitButton
            }

            Label("Teaching view · not a recommendation", systemImage: "checkmark.shield")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary.opacity(0.82))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.regularMaterial, in: Capsule())
                .accessibilityLabel(experience.presenterBoundary)

            if experience.anatomyPresentation == .transparent,
               experience.pointField == .regions,
               experience.detailLevel >= .guided {
                Label("Skull reference · separated · review pending", systemImage: "view.3d")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary.opacity(0.86))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.regularMaterial, in: Capsule())
                    .accessibilityLabel("Generic separated skull reference. Cross-source alignment requires specialist review.")
            }
        }
    }

    private func brainInteriorButton(accent: Color) -> some View {
        Button {
            guard let url = URL(string: "rbcjourney://enter") else { return }
            openURL(url)
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
        .accessibilityHint("Opens the separate guided blood-vessel experience after room-scale magnification")
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
        Button(action: action) {
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
        case .warmHorizon: "Horizon"
        case .focusField: "Focus"
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
private struct StrokeTeachingImagingDrawer: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let selectedPointLabel = experience.selectedPointLabel {
                Text("FROM POINT · \(selectedPointLabel.uppercased())")
                    .font(.caption2.monospaced().weight(.semibold))
                    .tracking(0.55)
                    .foregroundStyle(.white.opacity(0.58))
                    .lineLimit(1)
            }

            Text(referenceTitle)
                .font(.caption2.monospaced().weight(.black))
                .tracking(0.8)
                .foregroundStyle(referenceTint)

            Text(referenceBoundary)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.68))

            if experience.pointField == .procedure {
                Text("DIRECTION CUE · QUALITATIVE · NOT CFD")
                    .font(.caption2.monospaced().weight(.semibold))
                    .tracking(0.35)
                    .foregroundStyle(.orange.opacity(0.76))
            }

            if experience.audienceLens == .clinician {
                Button("Open 2D reference", systemImage: "rectangle.on.rectangle") {
                    openWindow(id: StrokeSpace.imaging)
                }
                .buttonStyle(.bordered)
                .tint(referenceTint)
                .accessibilityHint("Opens a moveable generic teaching schematic, not a patient image")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(.thinMaterial, in: Capsule())
        .overlay(Capsule().stroke(referenceTint.opacity(0.42), lineWidth: 1))
        .accessibilityElement(children: .combine)
    }

    private var referenceTitle: String {
        switch (experience.audienceLens, experience.teachingImagingLens) {
        case (.family, .affectedVessel): "BLOCKED VESSEL · TEACHING VIEW"
        case (.family, .makingRoomPurpose): "MAKING-ROOM PURPOSE · TEACHING VIEW"
        case (.clinician, .affectedVessel): "AFFECTED-VESSEL REFERENCE"
        case (.clinician, .makingRoomPurpose): "MAKING-ROOM REFERENCE"
        }
    }

    private var referenceBoundary: String {
        experience.audienceLens == .family
            ? "Generic anatomy · not a patient scan"
            : "Registered-v2 teaching asset · review pending"
    }

    private var referenceTint: Color {
        experience.teachingImagingLens == .affectedVessel ? .orange : .mint
    }
}

/// A clinician-only index of technically denser reference lanes. The two
/// enabled rows route to registered teaching content already in the app. The
/// remaining rows are honest scaffolding: visibly unavailable until reviewed
/// data and interactions exist, rather than inert controls that imply content.
private struct StrokeScholarReferenceRail: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        ZStack(alignment: .leading) {
            StrokeScholarReferenceArc()
                .stroke(Color.mint.opacity(0.20), style: StrokeStyle(lineWidth: 1.2, dash: [3, 5]))
                .padding(.leading, 18)
                .padding(.vertical, 42)

            VStack(alignment: .leading, spacing: 8) {
                Text("SCHOLAR REFERENCES")
                    .font(.caption2.weight(.black))
                    .tracking(1.0)
                    .foregroundStyle(.mint)

                ForEach(StrokeScholarReferenceLane.allCases) { lane in
                    if isActionable(lane) {
                        Button {
                            select(lane)
                        } label: {
                            row(
                                for: lane,
                                isSelected: isSelected(lane),
                                isEnabled: true,
                                unavailableStatus: nil
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                        .frame(minHeight: 60)
                        .contentShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.leading, lane.arcInset)
                        .accessibilityLabel(lane.title)
                        .accessibilityValue(isSelected(lane) ? "Selected" : "Available")
                    } else {
                        row(
                            for: lane,
                            isSelected: false,
                            isEnabled: false,
                            unavailableStatus: unavailableStatus(for: lane)
                        )
                            .frame(minHeight: 60)
                            .padding(.leading, lane.arcInset)
                            .opacity(0.62)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(unavailableLabel(for: lane))
                    }
                }

                if !experience.teachingImagingDrawerVisible {
                    Divider()
                        .overlay(Color.white.opacity(0.10))

                    Text("ANATOMY FOCUS")
                        .font(.caption2.weight(.black))
                        .tracking(0.8)
                        .foregroundStyle(.white.opacity(0.58))

                    HStack(spacing: 6) {
                        ForEach(StrokeAnatomyFocus.allCases) { focus in
                            let isAvailable = experience.isAnatomyFocusAvailable(focus)
                            Button {
                                experience.selectAnatomyFocus(focus)
                            } label: {
                                Text(focus.rawValue)
                                    .font(.caption2.weight(.bold))
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .foregroundStyle(
                                        experience.anatomyFocus == focus ? Color.black.opacity(0.82) : .white
                                    )
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
                    }

                    Text(experience.anatomyFocusStatus)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.10)))
        .frame(width: 310)
        .accessibilityElement(children: .contain)
    }

    private func row(
        for lane: StrokeScholarReferenceLane,
        isSelected: Bool,
        isEnabled: Bool,
        unavailableStatus: String?
    ) -> some View {
        HStack(spacing: 9) {
            Image(systemName: lane.systemImage)
                .font(.caption.weight(.bold))
                .frame(width: 20, height: 20)
                .foregroundStyle(isSelected ? Color.black.opacity(0.78) : Color.white.opacity(0.78))
                .background(isSelected ? Color.mint : Color.white.opacity(0.08), in: Circle())

            Text(lane.title)
                .font(.caption.weight(isSelected ? .bold : .semibold))
                .foregroundStyle(.white.opacity(isEnabled ? 0.90 : 0.64))

            Spacer(minLength: 5)

            if isEnabled {
                Image(systemName: isSelected ? "checkmark" : "chevron.right")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(isSelected ? Color.mint : Color.white.opacity(0.38))
            } else if let unavailableStatus {
                Text(unavailableStatus.uppercased())
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .tracking(0.45)
                    .foregroundStyle(.white.opacity(0.56))
            }
        }
        .padding(.horizontal, 9)
        .frame(minHeight: 48)
        .background(
            isSelected ? Color.mint.opacity(0.13) : Color.white.opacity(0.025),
            in: RoundedRectangle(cornerRadius: 11)
        )
    }

    private func isSelected(_ lane: StrokeScholarReferenceLane) -> Bool {
        switch lane {
        case .anatomy:
            experience.pointField == .regions && !experience.teachingImagingDrawerVisible
        case .imaging:
            experience.teachingImagingDrawerVisible
        case .interventions:
            experience.pointField == .craniotomy
        case .medications:
            experience.selectedCareDiscussion == .medicineReview
        case .outcomes, .guidelines:
            false
        }
    }

    private func isActionable(_ lane: StrokeScholarReferenceLane) -> Bool {
        switch lane {
        case .anatomy:
            true
        case .imaging:
            experience.selectedPointEntityName != nil
        case .interventions, .medications, .guidelines:
            true
        case .outcomes:
            false
        }
    }

    private func unavailableStatus(for lane: StrokeScholarReferenceLane) -> String {
        if lane == .imaging && experience.selectedPointEntityName == nil {
            return "Select point"
        }
        return "Coming soon"
    }

    private func unavailableLabel(for lane: StrokeScholarReferenceLane) -> String {
        if lane == .imaging && experience.selectedPointEntityName == nil {
            return "Imaging, select an anatomy point first"
        }
        return "\(lane.title), unavailable in this prototype"
    }

    private func select(_ lane: StrokeScholarReferenceLane) {
        switch lane {
        case .anatomy:
            experience.selectLessonFamily(.regions)
        case .imaging:
            experience.selectTeachingImagingLens(.affectedVessel, reduceMotion: reduceMotion)
        case .interventions:
            // Reuses the reviewed, non-graphic access-story point family.
            experience.selectLessonFamily(.craniotomy)
        case .medications:
            // Reuses the authored medicine-review conversation; it does not
            // calculate eligibility or rank care pathways.
            experience.selectCareDiscussion(.medicineReview)
        case .guidelines:
            if let guideline = StrokeEvidenceSource.library.first(where: { $0.kind == .guideline }) {
                experience.selectEvidence(guideline)
            }
            openWindow(id: StrokeSpace.evidence)
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

    var id: String { rawValue }
    var title: String { rawValue.capitalized }

    /// A shallow visual arc keeps the rail peripheral without reducing any
    /// row's 60-point interaction target.
    var arcInset: CGFloat {
        switch self {
        case .anatomy, .guidelines: 0
        case .imaging, .outcomes: 10
        case .interventions, .medications: 20
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
        .padding(.horizontal, 13)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.58)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.10), radius: 14, y: 5)
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
                .foregroundStyle(Color.white.opacity(0.70))
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 18)
                .opacity(showsContext ? 1 : 0)
                .contentTransition(.opacity)
                .animation(.easeOut(duration: 0.22), value: showsContext)
                .accessibilityHidden(!showsContext)

            HStack(spacing: 6) {
                ForEach(StrokeProcedureStep.allCases) { step in
                    let isActive = step == experience.procedureStep
                    Button {
                        // `present` retains the existing Make-space consent gate.
                        experience.present(step: step)
                    } label: {
                        SpatialTeachingTimelineNode(
                            number: step.number,
                            title: title(for: step),
                            isActive: isActive,
                            showLabel: false,
                            tint: tint(for: step)
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.highlight)
                    .onHover { isHovering in
                        hoveredStep = isHovering ? step : nil
                    }
                    .accessibilityLabel("Act \(step.number), \(title(for: step))")
                    .accessibilityValue(isActive ? "Current act" : "Inactive act")
                }
            }
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

            HStack(spacing: 5) {
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

            HStack(spacing: 3) {
                ForEach(StrokePresenterTeachingBeat.allCases) { beat in
                    Capsule()
                        .fill(tint(for: beat).opacity(beat == experience.presenterTeachingBeat ? 0.98 : 0.64))
                        .frame(height: beat == experience.presenterTeachingBeat ? 12 : 8)
                }
            }
        }
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
    let title: String
    let isActive: Bool
    let showLabel: Bool
    let tint: Color

    var body: some View {
        HStack(spacing: showLabel ? 10 : 6) {
            Text(String(number))
                .font(.callout.monospacedDigit().weight(.black))
                .frame(width: 38, height: 38)
                .background(isActive ? tint : Color.white.opacity(0.08), in: Circle())
                .foregroundStyle(isActive ? Color.black : Color.white.opacity(0.58))

            if showLabel {
                Text(title)
                    .font(.body.weight(.bold))
                    .foregroundStyle(isActive ? Color.white : Color.white.opacity(0.82))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, showLabel ? 16 : 10)
        .frame(width: showLabel ? 252 : 65, height: 72)
        .background(
            isActive ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(Color.white.opacity(0.025)),
            in: Capsule()
        )
        .overlay(
            Capsule().stroke(
                isActive ? tint.opacity(0.68) : Color.white.opacity(0.08),
                lineWidth: isActive ? 1.5 : 1
            )
        )
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

            // Make the three wearer-controlled explanations legible before a
            // pinch. This is a compact story rhythm, not another navigation
            // rail: one tap advances Position → Meaning → Conversation.
            HStack(spacing: 6) {
                atlasBeat("1", "POSITION", index: 0)
                atlasBeatConnector
                atlasBeat("2", "MEANING", index: 1)
                atlasBeatConnector
                atlasBeat("3", "ASK", index: 2)
            }

            HStack(alignment: .center, spacing: 12) {
                atlasStepButton(symbol: "chevron.left", label: "Previous") {
                    experience.advanceFamilyBrainAtlasChapter(by: -1)
                }

                Button {
                    experience.advanceFamilyBrainAtlasDetail(by: 1)
                } label: {
                    VStack(alignment: .leading, spacing: 7) {
                        Text(chapter.title)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                        Text("\(experience.familyBrainAtlasDetailIndex + 1) OF \(StrokeFamilyBrainAtlasChapter.detailCount) · \(detailTitle)")
                            .font(.caption2.weight(.black))
                            .tracking(0.8)
                            .foregroundStyle(.orange.opacity(0.90))
                        Text(detailText)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.white.opacity(0.82))
                            .fixedSize(horizontal: false, vertical: true)
                        Label("PINCH FOR THE NEXT SHORT EXPLANATION", systemImage: "hand.tap.fill")
                            .font(.caption2.weight(.black))
                            .tracking(0.35)
                            .foregroundStyle(.orange.opacity(0.92))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(.orange.opacity(0.12), in: Capsule())
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: 150, alignment: .leading)
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

                atlasStepButton(symbol: "chevron.right", label: "Next") {
                    experience.advanceFamilyBrainAtlasChapter(by: 1)
                }
            }

            Button {
                experience.revealFamilyBrainAtlasModelCue()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isModelCueActive ? "checkmark.circle.fill" : chapter.systemImage)
                    Text(isModelCueActive ? "3D CUE ACTIVE · LOOK FOR ONE LIT MARKER" : "REVEAL IN 3D · \(chapter.modelCue)")
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

            Text("Pinch-drag left or right for the next structure · reveal one 3D marker at a time · generic teaching anatomy, not a patient scan")
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
        if chapter == .arterialRoutes {
            return "Show qualitative branching flow on the 3D teaching model"
        }
        if chapter.spatialCuePointIndex != nil {
            return "Show \(chapter.title) context on the 3D teaching model"
        }
        return "Open the separate inside-brain journey"
    }

    private var isDeepStructureChapter: Bool {
        chapter.spatialCuePointIndex == nil && chapter != .arterialRoutes
    }

    private var atlasCueAccessibilityHint: String {
        if chapter == .arterialRoutes {
            return "Selects one generic vessel cue and opens one local teaching reference. It is not a patient scan or measurement"
        }
        if chapter.spatialCuePointIndex != nil {
            return "Selects one lifted generic anatomy cue. It does not identify anatomy in a patient scan"
        }
        return "Makes the room-scale inside-brain handoff available. The paired guided journey must be installed separately"
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
                experience.audienceLens == .family ? "QUESTIONS TO ASK" : "PRESENTATION CHECKLIST",
                systemImage: experience.audienceLens == .family ? "questionmark.bubble.fill" : "list.bullet"
            )
            .font(.caption2.weight(.black))
            .tracking(1.0)
            .foregroundStyle(accent)

            if experience.audienceLens == .family {
                ForEach(Array(experience.familyQuestionSuggestions.enumerated()), id: \.offset) { index, question in
                    let isSelected = experience.selectedFamilyQuestion == question
                    Button {
                        experience.selectFamilyQuestion(question)
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
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
                    .accessibilityLabel("Select question: \(question)")
                    .accessibilityValue(isSelected ? "Selected; lesson paused" : "Not selected")
                }

                if let answer = experience.selectedFamilyQuestionAnswer {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("A CLEARER WAY TO SAY IT", systemImage: "text.bubble.fill")
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
            } else {
                clinicianLensControls

                Divider().overlay(Color.white.opacity(0.12))

                HStack {
                    Text("ACT \(experience.procedureStep.number) OF 3")
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

                ForEach(Array(experience.presenterTimelineKeyPoints.enumerated()), id: \.offset) { index, point in
                    let isExpanded = experience.selectedPresenterKeyPointIndex == index
                    VStack(alignment: .leading, spacing: 9) {
                        if index > 0 {
                            Divider().overlay(Color.white.opacity(0.12))
                        }
                        Button {
                            experience.selectPresenterKeyPoint(index)
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                HStack(alignment: .top, spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(isExpanded ? accent.opacity(0.92) : Color.white.opacity(0.10))
                                        Text("\(index + 1)")
                                            .font(.caption2.monospacedDigit().weight(.black))
                                            .foregroundStyle(isExpanded ? Color.black.opacity(0.78) : accent)
                                    }
                                    .frame(width: 23, height: 23)

                                    Text(point)
                                        .font(.callout.weight(isExpanded ? .bold : .semibold))
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer(minLength: 0)
                                    Image(systemName: isExpanded ? "chevron.up" : "text.bubble")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(accent.opacity(0.76))
                                }

                                if isExpanded {
                                    Text(experience.presenterPlainLanguagePoints[index])
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(.white.opacity(0.72))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.leading, 33)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                        .accessibilityLabel("Presenter pointer \(index + 1): \(point)")
                        .accessibilityHint("Pinch to reveal an authored plain-language phrasing")
                        .frame(minHeight: 48, alignment: .topLeading)
                    }
                }

                Divider().overlay(Color.white.opacity(0.12))
                Text("Visible to the presenter · concise prompts, not a script")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.54))
            }
        }
        .foregroundStyle(.white.opacity(0.92))
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.10)))
        .frame(width: experience.audienceLens == .family ? 360 : 300)
        .frame(minHeight: experience.audienceLens == .clinician ? 300 : 336, alignment: .topLeading)
        .accessibilityElement(children: .contain)
    }

    private var accent: Color {
        experience.audienceLens == .family ? .orange : .mint
    }

    private var clinicianLensControls: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("CLINICIAN LENS")
                .font(.caption2.weight(.black))
                .tracking(0.8)
                .foregroundStyle(accent)

            HStack {
                Text("VISUAL DETAIL · USER SELECTED")
                    .font(.caption2.weight(.black))
                    .tracking(0.65)
                Spacer()
                Text(experience.detailLevel.visualDetailTitle.uppercased())
                    .font(.caption2.monospaced().weight(.bold))
                    .foregroundStyle(accent)
            }
            .foregroundStyle(.white.opacity(0.62))

            Slider(
                value: Binding(
                    get: { Double(StrokeDetailLevel.allCases.firstIndex(of: experience.detailLevel) ?? 0) },
                    set: { value in
                        let index = min(max(Int(value.rounded()), 0), StrokeDetailLevel.allCases.count - 1)
                        experience.selectDetailLevel(StrokeDetailLevel.allCases[index])
                    }
                ),
                in: 0...2,
                step: 1
            )
            .tint(accent)
            .accessibilityLabel("Visual explanation detail")
            .accessibilityValue(experience.detailLevel.visualDetailTitle)

            HStack {
                Text("Simplified")
                Spacer()
                Text("Standard")
                Spacer()
                Text("Full")
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.white.opacity(0.58))

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
        }
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
        .frame(width: 66, height: 66)
        .foregroundStyle(selected ? Color.black.opacity(0.82) : Color.white)
        .overlay(Circle().stroke(selected ? accent : Color.white.opacity(0.16), lineWidth: selected ? 2 : 1))
        .contentShape(Circle())
        .hoverEffect(.highlight)
    }
}

private struct StrokeIntentionAnnotation: View {
    @EnvironmentObject private var experience: StrokeExperienceState

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
                Text(annotationTitle)
                    .font(.headline.weight(.black))
                    .tracking(0.35)
                    .foregroundStyle(annotationTint)

                Text(annotationMeaning)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 9)
        .background(.black.opacity(0.56), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(annotationTint.opacity(0.26)))
        .shadow(color: .black.opacity(0.72), radius: 8, y: 2)
        .accessibilityElement(children: .combine)
    }

    private var annotationTitle: String {
        if experience.closingReflectionVisible { return "YOU DO NOT HAVE TO HOLD EVERY ANSWER AT ONCE" }
        if experience.isClinicianScholarSkullInspectionActive { return "SKULL · REGISTRATION REVIEW" }
        if let selected = experience.selectedPointLabel { return selected.uppercased() }
        if experience.audienceLens == .clinician {
            return switch experience.presenterTeachingBeat {
            case .confirmContext: "GENERIC TEACHING ANATOMY"
            case .discussAccess: "SKULL REFERENCE"
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
        if experience.audienceLens == .clinician {
            return switch experience.presenterTeachingBeat {
            case .confirmContext: "Generic anatomy only—not this person's scan."
            case .discussAccess: "A separated skull reference shows the fixed boundary; it does not plan an opening."
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
                Text("QUESTION HERE")
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
        case .chooseCase: "Which layer is this?"
        case .inspectOcclusion: "Is this blockage, injury, or swelling?"
        case .discussCare: "What can this surgery change—and not change?"
        }
    }
}

private struct SpatialPatientDrawer: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("FILE 78", systemImage: "folder.fill")
                    .font(.caption.weight(.bold))
                    .tracking(0.9)
                Spacer()
                Image(systemName: "pin.fill")
                    .foregroundStyle(.orange)
            }

            HStack(spacing: 8) {
                evidenceChip("waveform", "Speech", .orange)
                evidenceChip("figure.arms.open", "Arm", .orange)
                evidenceChip("clock.fill", "70 min", .yellow)
            }

            HStack(spacing: 8) {
                Capsule()
                    .fill(.secondary.opacity(0.38))
                    .frame(width: 54, height: 5)
                Text(experience.procedureStep == .chooseCase ? "PULL INTO VIEW" : "CASE IN VIEW")
                    .font(.caption2.weight(.bold))
                    .tracking(0.7)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Fictional file 78: speech change, arm weakness, reported 70 minutes ago")
    }

    private func evidenceChip(_ icon: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(tint)
            Text(label)
                .font(.caption2.weight(.semibold))
        }
        .frame(maxWidth: .infinity, minHeight: 48)
        .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 11))
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
                    openWindow(id: StrokeSpace.evidence)
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
                        Text(milestone.spatialWebValue)
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
        .accessibilityLabel("\(milestone.shortTitle), \(milestone.spatialWebValue)")
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
