import RealityKit
import SwiftUI

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
    static let primaryAnatomy: SIMD3<Float> = [0.12, 1.82, -1.08]
    static let primaryVesselFocus: SIMD3<Float> = [0.12, 1.79, -0.69]
    static let secondaryCaseDrawer: SIMD3<Float> = [0.54, 1.55, -0.82]
    static let tertiaryHorizon: SIMD3<Float> = [0.10, 1.64, -1.72]

    static let primaryScale: Float = 2.46
    static let orientScale: Float = 2.25
    static let secondaryScale: Float = 0.62
    static let tertiaryScale: Float = 0.92
}

struct StrokeImmersiveView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var flowController: AudioPlaybackController?
    @State private var pressureController: AudioPlaybackController?
    @State private var previousDragTranslation = CGSize.zero
    @State private var previousMagnification = 1.0

    private let annotationID = "stroke-intention-annotation"
    private let annotationAnchorName = "stroke-intention-annotation-anchor"
    private let calmHorizonID = "stroke-calm-paper-horizon"
    private let questionMarkerID = "family-question-marker"
    private let caseDrawerID = "spatial-patient-drawer"
    private let vesselFocusID = "vessel-focus-reticle"

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            RealityView { content, attachments in
                    let root = await StrokeSceneFactory.makeScene()
                    content.add(root)
                    await installSpatialAudio(on: root)

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
                            isPaused: experience.requestedPause,
                            reduceMotion: reduceMotion
                        )
                    }
                    if let marker = attachments.entity(for: questionMarkerID) {
                        if marker.parent == nil {
                            content.add(marker)
                        }
                        marker.position = questionMarkerPosition
                        marker.scale = [0.72, 0.72, 0.72]
                        marker.isEnabled = experience.questionMarkerVisible
                        marker.components.set(BillboardComponent())
                    }
                    if let drawer = attachments.entity(for: caseDrawerID) {
                        if drawer.parent == nil {
                            content.add(drawer)
                        }
                        drawer.position = SpatialVisualField.secondaryCaseDrawer
                        drawer.scale = [
                            SpatialVisualField.secondaryScale,
                            SpatialVisualField.secondaryScale,
                            SpatialVisualField.secondaryScale
                        ]
                        drawer.components.set(BillboardComponent())
                    }
                    if let focus = attachments.entity(for: vesselFocusID) {
                        if focus.parent == nil {
                            content.add(focus)
                        }
                        focus.position = SpatialVisualField.primaryVesselFocus
                        focus.scale = [0.52, 0.52, 0.52]
                        focus.isEnabled = experience.procedureStep != .chooseCase
                        focus.components.set(BillboardComponent())
                    }
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
                }
            .gesture(
                    DragGesture(minimumDistance: 3)
                        .targetedToAnyEntity()
                        .onChanged { value in
                            let translation = value.gestureValue.translation
                            let delta = CGSize(
                                width: translation.width - previousDragTranslation.width,
                                height: translation.height - previousDragTranslation.height
                            )
                            previousDragTranslation = translation
                            experience.rotateSpatialView(delta: delta)
                        }
                        .onEnded { _ in previousDragTranslation = .zero }
                )
            .simultaneousGesture(
                    MagnifyGesture()
                        .targetedToAnyEntity()
                        .onChanged { value in
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
                                experience.placeQuestionMarker()
                            } else if value.entity.name == "vessel-blockage" ||
                                value.entity.name == "penumbra-shell" {
                                experience.focusOcclusion()
                            }
                        }
                )
            .onChange(of: experience.soundEnabled) { _, _ in updateAudioMix() }
            .onChange(of: experience.requestedPause) { _, _ in updateAudioMix() }
            .onDisappear {
                flowController?.stop()
                pressureController?.stop()
                experience.isImmersivePresented = false
            }
        }
    }

    private var annotationPosition: SIMD3<Float> {
        switch experience.procedureStep {
        case .chooseCase: [-0.42, 1.96, -0.84]
        case .inspectOcclusion: [0.42, 1.94, -0.84]
        case .discussCare: [0.43, 1.94, -0.86]
        }
    }

    private var questionMarkerPosition: SIMD3<Float> {
        switch experience.procedureStep {
        case .chooseCase: [-0.18, 1.73, -0.75]
        case .inspectOcclusion: [0.19, 1.82, -0.72]
        case .discussCare: [0.24, 1.76, -0.74]
        }
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
        let muted = !experience.soundEnabled || experience.requestedPause
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

private struct StrokeIntentionAnnotation: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Label(annotationTitle, systemImage: annotationIcon)
                .font(.headline.weight(.bold))
                .foregroundStyle(annotationTint)

            Text(annotationMeaning)
                .font(.callout.weight(.medium))
                .foregroundStyle(.primary.opacity(0.88))
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(15)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(annotationTint.opacity(0.28)))
        .accessibilityElement(children: .combine)
    }

    private var annotationTitle: String {
        switch experience.procedureStep {
        case .chooseCase: "FIXED SPACE"
        case .inspectOcclusion: "PRESSURE"
        case .discussCare: "ROOM ≠ REPAIR"
        }
    }

    private var annotationMeaning: String {
        switch experience.procedureStep {
        case .chooseCase: "Skull surrounds brain."
        case .inspectOcclusion: "Swelling crowds fixed space."
        case .discussCare: "More room; injury remains."
        }
    }

    private var annotationIcon: String {
        switch experience.procedureStep {
        case .chooseCase: "circle.dashed"
        case .inspectOcclusion: "arrow.up.and.down.and.arrow.left.and.right"
        case .discussCare: "square.dashed.inset.filled"
        }
    }

    private var annotationTint: Color {
        switch experience.procedureStep {
        case .chooseCase: .cyan
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
        case .inspectOcclusion: "What changed here?"
        case .discussCare: "What does this make room for?"
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
        ZStack {
            Circle()
                .stroke(Color.orange.opacity(0.26), lineWidth: 2)
            Circle()
                .trim(from: 0.08, to: 0.72)
                .stroke(Color.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(experience.procedureStep == .discussCare ? 28 : -18))
            Circle()
                .fill(Color.orange)
                .frame(width: 14, height: 14)
            Text("CLOT")
                .font(.caption2.weight(.black))
                .tracking(1.1)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.regularMaterial, in: Capsule())
                .offset(y: 52)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Illustrative clot focus marker")
    }
}

struct StrokeJourneyCompanionView: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        JourneyCaption()
            .frame(width: experience.audienceLens == .clinician ? 500 : 560)
            .padding(18)
            .frame(
                width: experience.audienceLens == .clinician ? 540 : 600,
                height: experience.audienceLens == .clinician ? 660 : 360
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
        VStack(spacing: 16) {
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

            LayerContextBreadcrumb()

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
        .padding(22)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white.opacity(0.12)))
    }

    private var patientExplanation: some View {
        VStack(spacing: 10) {
            Text(experience.journeyCaption)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(experience.journeyIntent)
                .font(.callout.weight(.medium))
                .foregroundStyle(.cyan.opacity(0.92))
        }
    }

    private var clinicianPresenter: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                ForEach(StrokeProcedureStep.allCases) { step in
                    Button {
                        experience.present(step: step)
                    } label: {
                        HStack(spacing: 7) {
                            Text("\(step.number)")
                                .font(.caption.monospacedDigit().weight(.bold))
                            Text(presenterTitle(for: step))
                                .font(.callout.weight(.semibold))
                        }
                        .foregroundStyle(experience.procedureStep == step ? Color.black.opacity(0.82) : .primary)
                        .padding(.horizontal, 10)
                        .frame(height: 38)
                        .frame(maxWidth: .infinity)
                        .background(
                            experience.procedureStep == step ? Color.cyan : Color.white.opacity(0.10),
                            in: Capsule()
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Present act \(step.number), \(presenterTitle(for: step))")
                }
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

            presenterSection("INTENTION", systemImage: "scope", text: experience.presenterCue)

            HStack(alignment: .top, spacing: 12) {
                presenterCard(
                    "VISIBLE NOW",
                    systemImage: "square.3.layers.3d",
                    text: experience.presenterLayerStatus,
                    tint: .cyan
                )
                presenterCard(
                    "SAY CAREFULLY",
                    systemImage: "checkmark.shield",
                    text: experience.presenterBoundary,
                    tint: .orange
                )
            }
        }
    }

    private func presenterSection(_ title: String, systemImage: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage)
                .font(.caption.weight(.bold))
                .tracking(1.1)
                .foregroundStyle(.cyan)
            Text(text)
                .font(.body.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func presenterCard(_ title: String, systemImage: String, text: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Label(title, systemImage: systemImage)
                .font(.caption2.weight(.bold))
                .tracking(0.9)
                .foregroundStyle(tint)
            Text(text)
                .font(.callout)
                .foregroundStyle(.primary.opacity(0.88))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.09), in: RoundedRectangle(cornerRadius: 15))
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
        dismissWindow(id: experience.audienceLens == .clinician ? StrokeSpace.presenter : StrokeSpace.family)
    }

    private var consentChoice: some View {
        VStack(spacing: 10) {
            Text("May I separate the skull, dura, and brain? No incision or blood.")
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

private struct LayerContextBreadcrumb: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "square.3.layers.3d")
                .foregroundStyle(.cyan)
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
                .foregroundStyle(.cyan.opacity(0.78))
        }
        .padding(.horizontal, 12)
        .frame(height: 34)
        .background(Color.cyan.opacity(0.065), in: Capsule())
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
