import AVFoundation
import RealityKit
import SwiftUI

@MainActor
private final class StrokeNarrationEngine: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.46
        utterance.pitchMultiplier = 0.98
        utterance.preUtteranceDelay = 0.16
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
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
    static let primaryAnatomy: SIMD3<Float> = [0.00, 1.62, -1.16]
    static let primaryVesselFocus: SIMD3<Float> = [0.00, 1.61, -0.76]
    static let secondaryCaseDrawer: SIMD3<Float> = [0.54, 1.55, -0.82]
    static let tertiaryHorizon: SIMD3<Float> = [0.10, 1.64, -1.72]

    static let primaryScale: Float = 2.12
    static let orientScale: Float = 1.98
    static let secondaryScale: Float = 0.62
    static let tertiaryScale: Float = 0.92
}

struct StrokeImmersiveView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var flowController: AudioPlaybackController?
    @State private var pressureController: AudioPlaybackController?
    @State private var previousDragTranslation = CGSize.zero
    @State private var previousMagnification = 1.0
    @StateObject private var narrator = StrokeNarrationEngine()

    private let annotationID = "stroke-intention-annotation"
    private let annotationAnchorName = "stroke-intention-annotation-anchor"
    private let calmHorizonID = "stroke-calm-paper-horizon"
    private let questionMarkerID = "family-question-marker"
    private let caseDrawerID = "spatial-patient-drawer"
    private let vesselFocusID = "vessel-focus-reticle"
    private let cabinetLabelID = "spatial-case-cabinet-label"
    private let dockLabelID = "spatial-case-dock-label"
    private let hierarchySpineID = "spatial-hierarchy-spine"
    private let speechFactID = "spatial-case-fact-speech"
    private let armFactID = "spatial-case-fact-arm"
    private let timeFactID = "spatial-case-fact-time"
    private let questionFactID = "spatial-case-fact-question"
    private let caseReviewActionsID = "spatial-case-review-actions"
    private let familyControlsID = "spatial-family-controls"
    private let presenterControlsID = "spatial-presenter-controls"
    private let clinicianToolWheelID = "clinician-hand-tool-wheel"
    private let clinicianToolWheelAnchorName = "clinician-left-palm-tool-anchor"
    private let clinicianHeldToolAnchorName = "clinician-right-palm-tool-anchor"

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            RealityView { content, attachments in
                    let root = await StrokeSceneFactory.makeScene()
                    content.add(root)
                    await installSpatialAudio(on: root)

                    let caseRoom = StrokeSceneFactory.makeSpatialCaseIntake()
                    content.add(caseRoom)

                    let handProof = CommandLine.arguments.contains("--proof-clinician-toolkit")
                    let toolWheelAnchor = Entity()
                    toolWheelAnchor.name = clinicianToolWheelAnchorName
                    if handProof {
                        toolWheelAnchor.position = [-0.55, 1.50, -0.74]
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
                        heldToolAnchor.position = [0.48, 1.48, -0.72]
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
                    content.add(horizon)

                    if let annotation = attachments.entity(for: annotationID) {
                        annotation.name = annotationID
                        annotation.components.set(BillboardComponent())
                        let annotationAnchor = Entity()
                        annotationAnchor.name = annotationAnchorName
                        annotationAnchor.addChild(annotation)
                        content.add(annotationAnchor)
                    }

                    if let marker = attachments.entity(for: questionMarkerID) {
                        marker.name = questionMarkerID
                        marker.components.set(BillboardComponent())
                        content.add(marker)
                    }

                    if let drawer = attachments.entity(for: caseDrawerID) {
                        drawer.name = caseDrawerID
                        drawer.components.set(BillboardComponent())
                        content.add(drawer)
                    }

                    if let focus = attachments.entity(for: vesselFocusID) {
                        focus.name = vesselFocusID
                        focus.components.set(BillboardComponent())
                        content.add(focus)
                    }

                    for id in [
                        cabinetLabelID, dockLabelID, hierarchySpineID,
                        speechFactID, armFactID, timeFactID, questionFactID, caseReviewActionsID,
                        familyControlsID, presenterControlsID
                    ] {
                        if let attachment = attachments.entity(for: id) {
                            attachment.name = id
                            attachment.components.set(BillboardComponent())
                            content.add(attachment)
                        }
                    }
                } update: { content, attachments in
                    guard let root = content.entities.first(where: { $0.name == StrokeSceneFactory.rootName }) else {
                        return
                    }

                    let now = timeline.date.timeIntervalSinceReferenceDate
                    StrokeSceneFactory.update(root: root, experience: experience, time: now)

                    // Ported from the proven Heart Field interaction engine:
                    // state-owned orbit/zoom, smoothed presentation, entity-
                    // anchored SwiftUI annotation, cheap RealityKit targets.
                    // Gesture values arrive continuously; keep them local to
                    // the RealityView update so SwiftUI state is never mutated
                    // during rendering. That avoids a 60 Hz runtime warning.
                    let smoothedOrbit = experience.orbit
                    let smoothedZoom = Float(experience.spatialZoom)

                    root.isEnabled = experience.spatialPhase == .explanation
                    if let caseRoom = content.entities.first(where: { $0.name == StrokeSceneFactory.spatialCaseRoomName }) {
                        caseRoom.isEnabled = experience.spatialPhase != .explanation
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFigureName)?.isEnabled = experience.spatialPhase == .caseReview
                    }
                    if let caseRoom = content.entities.first(where: { $0.name == StrokeSceneFactory.spatialCaseRoomName }),
                       let file = caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseFileName) {
                        file.position = experience.spatialCaseFilePosition
                        file.orientation = experience.spatialCaseDocked
                            ? simd_quatf(angle: 0, axis: [0, 1, 0])
                            : simd_quatf(angle: -0.16, axis: [0, 1, 0])
                        caseRoom.findEntity(named: StrokeSceneFactory.spatialCaseDockName)?.isEnabled = !experience.spatialCaseDocked
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
                        let annotationAnchor = content.entities.first(where: { $0.name == annotationAnchorName })
                        if let annotationAnchor, annotation.parent !== annotationAnchor {
                            annotation.removeFromParent()
                            annotationAnchor.addChild(annotation)
                        }
                        annotationAnchor?.position = annotationPosition
                        annotation.position = .zero
                        annotation.scale = [0.78, 0.78, 0.78]
                        annotation.isEnabled = experience.spatialPhase == .explanation
                        annotation.components.set(BillboardComponent())
                    }
                    if let horizon = content.entities.first(where: { $0.name == calmHorizonID }) {
                        // Environmental mood stays behind the anatomy and is
                        // never attached to a vessel or pathology state.
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
                    if let marker = attachments.entity(for: questionMarkerID) {
                        if marker.parent == nil {
                            content.add(marker)
                        }
                        marker.position = questionMarkerPosition(in: root)
                        marker.scale = [0.72, 0.72, 0.72]
                        marker.isEnabled = experience.spatialPhase == .explanation && experience.questionMarkerVisible
                        marker.components.set(BillboardComponent())
                    }
                    if let drawer = attachments.entity(for: caseDrawerID) {
                        if drawer.parent == nil {
                            content.add(drawer)
                        }
                        drawer.isEnabled = false
                        drawer.components.set(BillboardComponent())
                    }
                    if let focus = attachments.entity(for: vesselFocusID) {
                        if focus.parent == nil {
                            content.add(focus)
                        }
                        focus.position = SpatialVisualField.primaryVesselFocus
                        focus.scale = [0.52, 0.52, 0.52]
                        focus.isEnabled = experience.spatialPhase == .explanation && experience.procedureStep != .chooseCase
                        focus.components.set(BillboardComponent())
                    }
                    updateSpatialIntakeAttachments(attachments)
                    updateSpatialRoleControls(attachments, content: content)
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
                    Attachment(id: vesselFocusID) {
                        VesselFocusReticle()
                            .environmentObject(experience)
                            .frame(width: 170, height: 170)
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
                        SpatialCaseFact(title: "REPORTED", value: "Speech change", systemImage: "waveform")
                    }
                    Attachment(id: armFactID) {
                        SpatialCaseFact(title: "ALSO", value: "Right arm weakness", systemImage: "figure.arms.open")
                    }
                    Attachment(id: timeFactID) {
                        SpatialCaseFact(title: "TIME", value: "70 minutes ago", systemImage: "clock.fill")
                    }
                    Attachment(id: questionFactID) {
                        SpatialCaseFact(title: "SCENARIO", value: "Severe stroke + swelling", systemImage: "brain.head.profile")
                    }
                    Attachment(id: caseReviewActionsID) {
                        SpatialCaseReviewActions()
                            .environmentObject(experience)
                            .frame(width: 350)
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
                            .frame(width: 330, height: 390)
                    }
                }
            .gesture(
                    DragGesture(minimumDistance: 3)
                        .targetedToAnyEntity()
                        .onChanged { value in
                            if StrokeSceneFactory.isSpatialCaseFileTarget(value.entity) {
                                let scenePoint = value.convert(value.location3D, from: .local, to: .scene)
                                experience.moveSpatialCaseFile(to: scenePoint)
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
                                experience.settleSpatialCaseFile()
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
                            if experience.questionPlacementArmed {
                                guard
                                    StrokeSceneFactory.isAnatomyInteractionTarget(value.entity),
                                    let root = sceneRoot(for: value.entity)
                                else { return }
                                // Standard visionOS gaze selects the entity;
                                // pinch confirms. The app receives the targeted
                                // 3D hit, not a raw eye-tracking coordinate.
                                let scenePoint = value.convert(
                                    value.location3D,
                                    from: .local,
                                    to: .scene
                                )
                                let rootLocalPoint = root.convert(position: scenePoint, from: nil)
                                experience.placeQuestionMarker(
                                    at: rootLocalPoint,
                                    target: StrokeSceneFactory.semanticTarget(for: value.entity)
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
            .onChange(of: experience.narrationEnabled) { _, enabled in
                enabled ? narrator.speak(experience.journeyCaption) : narrator.stop()
            }
            .onChange(of: experience.procedureStep) { _, _ in
                if experience.narrationEnabled { narrator.speak(experience.journeyCaption) }
            }
            .onChange(of: experience.requestedPause) { _, _ in updateAudioMix() }
            .onDisappear {
                narrator.stop()
                flowController?.stop()
                pressureController?.stop()
                experience.isImmersivePresented = false
            }
        }
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
        let positions: [(String, SIMD3<Float>, Float, Bool)] = [
            (cabinetLabelID, [-0.62, 1.78, -0.88], 0.72, inLibrary),
            (dockLabelID, [0, 1.16, -0.78], 0.68, inLibrary),
            (hierarchySpineID, [0, 2.02, -0.48], 0.90, inReview),
            (speechFactID, [-0.36, 1.91, -0.56], 0.68, inReview),
            (armFactID, [-0.38, 1.62, -0.56], 0.68, inReview),
            (timeFactID, [0.34, 1.62, -0.56], 0.68, inReview),
            (questionFactID, [0.34, 1.91, -0.56], 0.68, inReview),
            (caseReviewActionsID, [0, 1.12, -0.62], 0.74, inReview)
        ]
        for (id, position, scale, visible) in positions {
            guard let entity = attachments.entity(for: id) else { continue }
            entity.position = position
            entity.scale = [scale, scale, scale]
            entity.isEnabled = visible
            entity.components.set(BillboardComponent())
        }
    }

    private func updateSpatialRoleControls(
        _ attachments: RealityViewAttachments,
        content: RealityViewContent
    ) {
        let controls: [(String, SIMD3<Float>, Bool)] = [
            (familyControlsID, [-0.58, 1.34, -0.92], experience.audienceLens == .family),
            (presenterControlsID, [0.58, 1.38, -0.92], experience.audienceLens == .clinician)
        ]

        for (id, position, correctRole) in controls {
            guard let attachment = attachments.entity(for: id) else { continue }
            if attachment.parent == nil { content.add(attachment) }
            attachment.position = position
            attachment.scale = [0.86, 0.86, 0.86]
            attachment.isEnabled = experience.spatialPhase == .explanation && correctRole
            attachment.components.set(BillboardComponent())
        }
    }

    private func updateClinicianHandToolKit(
        content: RealityViewContent,
        attachments: RealityViewAttachments
    ) {
        let enabled = experience.spatialPhase == .explanation && experience.audienceLens == .clinician
        if let anchor = content.entities.first(where: { $0.name == clinicianToolWheelAnchorName }),
           let wheel = attachments.entity(for: clinicianToolWheelID) {
            if wheel.parent !== anchor {
                wheel.removeFromParent()
                anchor.addChild(wheel)
            }
            wheel.position = [0, 0.035, 0.085]
            wheel.scale = [0.42, 0.42, 0.42]
            wheel.isEnabled = enabled
        }

        if let anchor = content.entities.first(where: { $0.name == clinicianHeldToolAnchorName }),
           let tools = anchor.findEntity(named: StrokeSceneFactory.clinicianHeldToolRootName) {
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

    private func questionMarkerPosition(in root: Entity) -> SIMD3<Float> {
        if let placement = experience.placedQuestion {
            return root.convert(position: placement.rootLocalPosition, to: nil)
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
}

/// The explicit handoff between selecting a fictional case and entering its
/// anatomy lesson. It exists only in the review room; the cabinet is removed
/// from the scene before the brain appears.
private struct SpatialCaseReviewActions: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        VStack(spacing: 11) {
            Label("CASE 78 · FICTIONAL", systemImage: "person.text.rectangle.fill")
                .font(.caption.weight(.black))
                .tracking(1.0)
                .foregroundStyle(.orange)

            Text("Review the signals. Then enter one shared explanation.")
                .font(.callout.weight(.semibold))
                .multilineTextAlignment(.center)

            HStack(spacing: 10) {
                Button("Return file", systemImage: "arrow.uturn.backward") {
                    experience.returnCaseToLibrary()
                }
                .buttonStyle(.bordered)

                Button(
                    experience.audienceLens == .family ? "Begin family view" : "Begin presenter view",
                    systemImage: "brain.head.profile"
                ) {
                    experience.beginExplanation()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }

            Text("Generic teaching anatomy · not this person's scan")
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
private struct ClinicianHandToolWheel: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                if experience.clinicianToolKitVisible {
                    Circle()
                        .fill(.regularMaterial)
                        .overlay(Circle().stroke(Color.mint.opacity(0.28), lineWidth: 2))
                        .frame(width: 270, height: 270)

                    ForEach(Array(StrokeClinicianTool.allCases.enumerated()), id: \.element.id) { index, tool in
                        let angle = Double(index) / Double(StrokeClinicianTool.allCases.count) * Double.pi * 2 - Double.pi / 2
                        toolButton(tool)
                            .offset(x: cos(angle) * 98, y: sin(angle) * 98)
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
                    .frame(width: 76, height: 76)
                }
                .buttonStyle(.plain)
                .background(Color.mint.opacity(0.20), in: Circle())
                .overlay(Circle().stroke(Color.mint.opacity(0.52), lineWidth: 2))
            }
            .frame(width: 290, height: 290)

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
            .frame(width: 72, height: 72)
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
                Menu {
                    ForEach(StrokePointField.allCases) { field in
                        Button(field.rawValue, systemImage: field.systemImage) {
                            experience.selectLessonFamily(field)
                        }
                    }
                    Divider()
                    Button(experience.lessonPointsVisible ? "Hide lesson points" : "Show lesson points") {
                        experience.toggleLessonPoints()
                    }
                } label: {
                    SpatialControlBubbleLabel(
                        title: experience.pointField == .regions ? "Regions" : "Flow",
                        systemImage: experience.pointField.systemImage,
                        accent: .orange,
                        selected: experience.lessonPointsVisible
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Lesson points: \(experience.pointField.rawValue)")

                bubbleButton(
                    experience.narrationEnabled ? "Voice off" : "Voice",
                    systemImage: experience.narrationEnabled ? "speaker.slash.fill" : "waveform",
                    accent: .orange,
                    selected: experience.narrationEnabled
                ) {
                    experience.narrationEnabled.toggle()
                }

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

                exitButton
            }
        }
    }

    private var presenterControls: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack(spacing: 8) {
                Menu {
                    ForEach(StrokeProcedureStep.allCases) { step in
                        Button("\(step.number)  \(stepTitle(step))") {
                            experience.present(step: step)
                        }
                    }
                } label: {
                    SpatialControlBubbleLabel(
                        title: "Act \(experience.procedureStep.number)",
                        systemImage: "circle.grid.3x3.fill",
                        accent: .mint,
                        selected: true
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Teaching act \(experience.procedureStep.number): \(stepTitle(experience.procedureStep))")

                Menu {
                    ForEach(StrokeAnatomyPresentation.allCases) { presentation in
                        Button(presentation.rawValue) {
                            experience.setAnatomyPresentation(presentation)
                        }
                    }
                } label: {
                    SpatialControlBubbleLabel(
                        title: anatomyBubbleTitle,
                        systemImage: "circle.lefthalf.filled",
                        accent: .mint,
                        selected: experience.anatomyPresentation != .assembled
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Anatomy view: \(experience.anatomyPresentation.rawValue)")

                Menu {
                    ForEach(StrokePointField.allCases) { field in
                        Button(field.rawValue, systemImage: field.systemImage) {
                            experience.selectLessonFamily(field)
                        }
                    }
                    Divider()
                    Button(experience.lessonPointsVisible ? "Hide lesson points" : "Show lesson points") {
                        experience.toggleLessonPoints()
                    }
                } label: {
                    SpatialControlBubbleLabel(
                        title: experience.pointField == .regions ? "Regions" : "Flow",
                        systemImage: experience.pointField.systemImage,
                        accent: .mint,
                        selected: experience.lessonPointsVisible
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Lesson points: \(experience.pointField.rawValue)")

                bubbleButton("Evidence", systemImage: "text.book.closed.fill", accent: .mint) {
                    openWindow(id: StrokeSpace.evidence)
                }
            }

            HStack(spacing: 8) {
                bubbleButton(
                    experience.requestedPause ? "Resume" : "Pause",
                    systemImage: experience.requestedPause ? "play.fill" : "pause.fill",
                    accent: .mint,
                    selected: experience.requestedPause
                ) {
                    experience.togglePause()
                }

                bubbleButton("Reset", systemImage: "arrow.counterclockwise", accent: .mint) {
                    experience.resetSpatialView()
                }

                bubbleButton(
                    experience.narrationEnabled ? "Voice off" : "Voice",
                    systemImage: experience.narrationEnabled ? "speaker.slash.fill" : "waveform",
                    accent: .mint,
                    selected: experience.narrationEnabled
                ) {
                    experience.narrationEnabled.toggle()
                }

                bubbleButton(
                    experience.closingReflectionVisible ? "Cases" : "Next",
                    systemImage: "arrow.right",
                    accent: .mint,
                    selected: true
                ) {
                    experience.advanceJourney()
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
        }
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

    private func stepTitle(_ step: StrokeProcedureStep) -> String {
        switch step {
        case .chooseCase: "Orient"
        case .inspectOcclusion: "Pressure"
        case .discussCare: "Make space"
        }
    }

    private var anatomyBubbleTitle: String {
        switch experience.anatomyPresentation {
        case .assembled: "Layers"
        case .transparent: "Clear"
        case .exploded: "Apart"
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
        .padding(.horizontal, 4)
        .shadow(color: .black.opacity(0.72), radius: 8, y: 2)
        .accessibilityElement(children: .combine)
    }

    private var annotationTitle: String {
        if experience.closingReflectionVisible { return "YOU DO NOT HAVE TO HOLD EVERY ANSWER AT ONCE" }
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
        return switch experience.procedureStep {
        case .chooseCase: "Start with the blockage in this generic teaching model."
        case .inspectOcclusion: "Swelling presses inside the fixed skull."
        case .discussCare: "The procedure can make room; it cannot undo stroke injury."
        }
    }

    private var annotationIcon: String {
        if experience.closingReflectionVisible { return "sparkles" }
        return switch experience.procedureStep {
        case .chooseCase: "circle.dashed"
        case .inspectOcclusion: "arrow.up.and.down.and.arrow.left.and.right"
        case .discussCare: "square.dashed.inset.filled"
        }
    }

    private var annotationTint: Color {
        if experience.closingReflectionVisible { return .mint }
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

private struct VesselFocusReticle: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        Button {
            experience.toggleRegionPortal()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(experience.regionPortalActive ? 0.12 : 0.035))
                Circle()
                    .stroke(Color.orange.opacity(0.30), lineWidth: 2)
                Circle()
                    .trim(from: 0.08, to: experience.regionPortalActive ? 0.96 : 0.72)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(experience.regionPortalActive ? 42 : -18))
                Circle()
                    .stroke(Color.orange.opacity(0.44), lineWidth: 1)
                    .frame(width: 104, height: 104)
                Image(systemName: experience.regionPortalActive ? "arrow.uturn.backward" : "arrow.down.right.and.arrow.up.left")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.orange)

                Text(portalTitle)
                    .font(.caption2.weight(.black))
                    .tracking(1.0)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(.regularMaterial, in: Capsule())
                    .offset(y: 58)
            }
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
        .accessibilityLabel(experience.regionPortalActive ? "Return to the full brain" : "Enter the illustrative affected-region flow lesson")
        .accessibilityHint("Changes the teaching viewpoint only")
    }

    private var portalTitle: String {
        if experience.regionPortalActive { return "RETURN" }
        return experience.audienceLens == .clinician ? "MAGNIFY" : "LOOK WITHIN"
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
                .accessibilityLabel(experience.soundEnabled ? "Mute spatial audio" : "Enable spatial audio")

                Button {
                    Task { await exitExperience() }
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Exit to patient files")
            }

            if experience.audienceLens == .clinician {
                clinicianPresenter
            } else {
                patientExplanation
            }

            if experience.isConsentPromptVisible {
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
                Menu {
                    ForEach(StrokeProcedureStep.allCases) { step in
                        Button("\(step.number)  \(presenterTitle(for: step))") {
                            experience.present(step: step)
                        }
                    }
                } label: {
                    compactControl("Act \(experience.procedureStep.number)", systemImage: "play.circle.fill")
                }

                Menu {
                    ForEach(StrokeAnatomyPresentation.allCases) { presentation in
                        Button(presentation.rawValue) {
                            experience.setAnatomyPresentation(presentation)
                        }
                    }
                } label: {
                    compactControl(experience.anatomyPresentation.rawValue, systemImage: "circle.lefthalf.filled")
                }

                Menu {
                    ForEach(StrokePointField.allCases) { field in
                        Button(field.rawValue) {
                            experience.pointField = field
                            experience.clearPointSelection()
                        }
                    }
                } label: {
                    compactControl(experience.pointField.rawValue, systemImage: experience.pointField.systemImage)
                }

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
            .frame(height: 34)
            .background(Color.white.opacity(0.08), in: Capsule())
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

    private func presenterTitle(for step: StrokeProcedureStep) -> String {
        switch step {
        case .chooseCase: "Orient"
        case .inspectOcclusion: "Pressure"
        case .discussCare: "Make space"
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
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(title, systemImage: systemImage)
                .font(.caption2.weight(.bold))
                .tracking(1.0)
                .foregroundStyle(.orange)
            Text(value)
                .font(.headline)
                .lineLimit(2)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .frame(width: 175, alignment: .leading)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 18))
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
