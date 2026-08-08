import RealityKit
import SwiftUI

struct StrokeImmersiveView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var flowController: AudioPlaybackController?
    @State private var pressureController: AudioPlaybackController?
    @State private var previousDragTranslation = CGSize.zero
    @State private var previousMagnification = 1.0
    @State private var smoothedOrbit = SIMD2<Float>.zero
    @State private var smoothedZoom: Float = 1

    private let annotationID = "stroke-intention-annotation"
    private let annotationAnchorName = "stroke-intention-annotation-anchor"
    private let calmHorizonID = "stroke-calm-paper-horizon"

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            RealityView { content, attachments in
                    let root = await StrokeSceneFactory.makeScene()
                    content.add(root)
                    await installSpatialAudio(on: root)

                    if let annotation = attachments.entity(for: annotationID) {
                        annotation.name = annotationID
                        annotation.components.set(BillboardComponent())
                        let annotationAnchor = Entity()
                        annotationAnchor.name = annotationAnchorName
                        annotationAnchor.addChild(annotation)
                        content.add(annotationAnchor)
                    }

                    if let horizon = attachments.entity(for: calmHorizonID) {
                        horizon.name = calmHorizonID
                        horizon.position = [0, 1.62, -1.88]
                        horizon.scale = [1.48, 1.48, 1]
                        content.add(horizon)
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
                    let blend: Float = 0.16
                    smoothedOrbit = simd_mix(smoothedOrbit, experience.orbit, SIMD2(repeating: blend))
                    smoothedZoom += (Float(experience.spatialZoom) - smoothedZoom) * blend

                    // The anatomy owns the centre of the room. The progressive
                    // immersion style lets the Digital Crown expand or soften
                    // the surroundings without another app-specific control.
                    root.position = [0, 1.82, -1.02]
                    let emphasis: Float = experience.procedureStep == .chooseCase ? 2.45 : 2.72
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
                    if let horizon = attachments.entity(for: calmHorizonID) {
                        if horizon.parent == nil {
                            content.add(horizon)
                        }
                        // Environmental mood stays behind the anatomy and is
                        // never attached to a vessel or pathology state.
                        horizon.position = [0, 1.62, -1.88]
                        horizon.scale = [1.48, 1.48, 1]
                    }
                    updateAudioMix()
                } attachments: {
                    Attachment(id: annotationID) {
                        StrokeIntentionAnnotation()
                            .environmentObject(experience)
                            .frame(width: 255)
                    }
                    Attachment(id: calmHorizonID) {
                        CalmPaperFlowView(isPaused: reduceMotion || experience.requestedPause)
                            .frame(width: 1540, height: 920)
                            .opacity(0.82)
                            .mask {
                                RadialGradient(
                                    colors: [.black, .black.opacity(0.92), .clear],
                                    center: .center,
                                    startRadius: 90,
                                    endRadius: 740
                                )
                            }
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
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
                            if value.entity.name == "vessel-blockage" ||
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

            Text("Illustrative teaching cue")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(15)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(annotationTint.opacity(0.28)))
        .accessibilityElement(children: .combine)
    }

    private var annotationTitle: String {
        switch experience.procedureStep {
        case .chooseCase: "Fixed space"
        case .inspectOcclusion: "Pressure has little room"
        case .discussCare: "Room, not repair"
        }
    }

    private var annotationMeaning: String {
        switch experience.procedureStep {
        case .chooseCase: "The skull forms a boundary around the brain."
        case .inspectOcclusion: "Swelling and injured tissue are related, but not the same problem."
        case .discussCare: "The opening explains pressure relief; injured tissue remains visible."
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

struct StrokeJourneyCompanionView: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        JourneyCaption()
            .frame(width: experience.audienceLens == .clinician ? 720 : 640)
            .padding(18)
            .frame(
                width: experience.audienceLens == .clinician ? 760 : 680,
                height: experience.audienceLens == .clinician ? 500 : 330
            )
            .animation(.easeInOut(duration: 0.28), value: experience.audienceLens)
    }
}

private struct JourneyCaption: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
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
                Picker("Audience", selection: $experience.audienceLens) {
                    ForEach(StrokeAudienceLens.allCases) { lens in
                        Text(lens.rawValue).tag(lens)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 260)
                .accessibilityLabel("Explanation view")

                Button {
                    experience.soundEnabled.toggle()
                } label: {
                    Image(systemName: experience.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                }
                .buttonStyle(.plain)
                .accessibilityLabel(experience.soundEnabled ? "Mute spatial audio" : "Enable spatial audio")
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

            Text("Teaching model · clinician review pending · not a patient scan")
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
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(experience.procedureStep == step ? .cyan : .secondary)
                    .accessibilityLabel("Present act \(step.number), \(presenterTitle(for: step))")
                }
            }

            if experience.clarificationRequested {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "questionmark.bubble.fill")
                        .foregroundStyle(.orange)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("FAMILY ASKED TO CLARIFY")
                            .font(.caption.weight(.bold))
                            .tracking(1.0)
                            .foregroundStyle(.orange)
                        Text(experience.clarificationCue)
                            .font(.callout.weight(.medium))
                    }
                    Spacer()
                    Button("Addressed") {
                        experience.acknowledgeClarification()
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
                experience.clarificationRequested ? "Clarification marked" : "I need clarification",
                systemImage: experience.clarificationRequested ? "checkmark.circle.fill" : "questionmark.bubble"
            ) {
                experience.requestClarification()
            }
            .buttonStyle(.borderedProminent)
            .tint(experience.clarificationRequested ? .orange : .cyan)
            .disabled(experience.clarificationRequested)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Family pace and clarification controls")
    }

    private var clinicianNavigation: some View {
        HStack(spacing: 12) {
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

            Button("Reset view", systemImage: "arrow.counterclockwise") {
                experience.resetSpatialView()
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .accessibilityHint("Restores the original model rotation and scale")

            Button(experience.primaryActionTitle, systemImage: "arrow.right") {
                experience.advanceJourney()
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)

            Button("Exit", systemImage: "xmark") {
                Task {
                    await dismissImmersiveSpace()
                    experience.isImmersivePresented = false
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }
    }

    private var consentChoice: some View {
        VStack(spacing: 10) {
            Text("May I gently separate the skull, dura, and brain layers? No incision or blood is shown.")
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
