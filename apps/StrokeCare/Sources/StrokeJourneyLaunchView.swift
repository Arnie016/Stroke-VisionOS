import AVFoundation
import RealityKit
import SwiftUI

/// Owns every `AVAudioPlayer` call away from the main actor. AVFoundation can
/// synchronously prepare its audio graph, so keeping construction,
/// `prepareToPlay`, playback, and teardown on this actor prevents the journey
/// UI from inheriting that work.
actor StrokeAudioPlayback {
    private var player: AVAudioPlayer?

    func playLoop(from url: URL, volume: Float) {
        stop()
        guard let audio = try? AVAudioPlayer(contentsOf: url) else { return }
        audio.numberOfLoops = -1
        audio.volume = volume
        audio.prepareToPlay()
        audio.play()
        player = audio
    }

    func playOnce(_ data: Data) throws {
        stop()
        let audio = try AVAudioPlayer(data: data)
        audio.numberOfLoops = 0
        audio.prepareToPlay()
        audio.play()
        player = audio
    }

    func stop() {
        player?.stop()
        player = nil
    }
}

@MainActor
private final class StrokePreludeAudio: ObservableObject {
    private let playback = StrokeAudioPlayback()
    private var playbackTask: Task<Void, Never>?

    func play() {
        guard playbackTask == nil,
              let url = Bundle.main.url(forResource: "FlowBed", withExtension: "wav")
        else { return }
        playbackTask = Task { [playback] in
            await playback.playLoop(from: url, volume: 0.12)
        }
    }

    func stop() {
        playbackTask?.cancel()
        playbackTask = nil
        Task { [playback] in
            await playback.stop()
        }
    }
}

/// A spatial intake threshold. The file itself is the control: pulling it from
/// the shelf progressively reveals the few facts needed for this conversation.
struct StrokeJourneyLaunchView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isOpening = false
    @State private var casePlaced = false
    @State private var caseRevealProgress = 0.0
    @State private var fileDrag = CGSize.zero
    @State private var proofRouteHasRun = false
    @State private var introBeat = 0
    @State private var introLineReveal = 0
    @State private var introSequenceWasSkipped = false
    @StateObject private var prelude = StrokePreludeAudio()

    var body: some View {
        let usesAsymmetricHeroLayout = introBeat == 0
        ZStack {
            if introBeat < 4 {
                StrokeSpatialPreludeView(beat: introBeat, reduceMotion: reduceMotion)
                    .id(introBeat)
                    .transition(.opacity)
            } else {
                LinearGradient(
                    colors: [Color.indigo.opacity(0.16), Color.orange.opacity(0.08), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .transition(.opacity)
            }

            VStack(spacing: introBeat < 4 ? 14 : 24) {
                HStack {
                    Label("STROKE CARE", systemImage: "brain.head.profile")
                        .font(.caption.weight(.bold))
                        .tracking(2.0)
                        .foregroundStyle(.orange)
                    Spacer()
                    Button {
                        experience.soundEnabled.toggle()
                        experience.registerInteractionFeedback()
                    } label: {
                        Label(
                            experience.soundEnabled ? "Sound on" : "Sound off",
                            systemImage: experience.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill"
                        )
                    }
                    .buttonStyle(.plain)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(experience.soundEnabled ? .cyan : .secondary)
                    .accessibilityLabel(experience.soundEnabled ? "Mute optional ambient sound" : "Enable optional ambient sound")
                    .accessibilityHint("Ambient sound is optional and does not change the lesson")
                    if introBeat < 4 {
                        Button("Skip story") {
                            introSequenceWasSkipped = true
                            withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 0.55)) {
                                introBeat = 4
                            }
                        }
                        .buttonStyle(.plain)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .accessibilityHint("Move directly to the use choice")
                    }
                }

                Spacer(minLength: 0)

                if introBeat >= 4 {
                    Text("Choose your way in.")
                        .font(.system(size: 38, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)

                    Text("Explore freely, or prepare a guided explanation.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 16) {
                        roleChoiceCard(
                            title: "Curious learner",
                            subtitle: "Discover the brain at your own pace",
                            detail: "Follow spatial stories, enter internal systems, and ask for plain-language guidance",
                            systemImage: "sparkles",
                            tint: .orange,
                            prominent: true
                        ) {
                            Task { await enterSpatialCaseRoom(as: .family) }
                        }
                        .accessibilityHint("Open the calm, generic anatomy discovery experience")

                        roleChoiceCard(
                            title: "Doctor presenter",
                            subtitle: "Guide a careful family conversation",
                            detail: "Use a fictional case, presentation timeline, teaching references, and evidence",
                            systemImage: "stethoscope",
                            tint: .cyan,
                            prominent: false
                        ) {
                            Task { await enterSpatialCaseRoom(as: .clinician) }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    VStack(alignment: usesAsymmetricHeroLayout ? .leading : .center, spacing: 14) {
                        Text(String(format: "%02d / 04", introBeat + 1))
                            .font(.caption2.monospaced().weight(.bold))
                            .tracking(2.2)
                            .foregroundStyle(.cyan.opacity(0.72))

                        Text(introTitle)
                            .font(.system(size: 38, weight: .semibold, design: .rounded))
                            .multilineTextAlignment(usesAsymmetricHeroLayout ? .leading : .center)
                            .frame(maxWidth: .infinity, alignment: usesAsymmetricHeroLayout ? .leading : .center)
                            .opacity(introLineReveal >= 1 ? 1 : 0)
                            .offset(y: introLineReveal >= 1 ? 0 : 8)

                        Text(introSubtitle)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(usesAsymmetricHeroLayout ? .leading : .center)
                            .frame(maxWidth: .infinity, alignment: usesAsymmetricHeroLayout ? .leading : .center)
                            .opacity(introLineReveal >= 2 ? 1 : 0)
                            .offset(y: introLineReveal >= 2 ? 0 : 8)

                        HStack(spacing: 10) {
                            ForEach(0..<4, id: \.self) { index in
                                Capsule()
                                    .fill(index == introBeat ? Color.orange : Color.white.opacity(0.20))
                                    .frame(width: index == introBeat ? 34 : 10, height: 7)
                            }
                        }
                        .animation(.easeInOut(duration: 0.35), value: introBeat)

                        Button(introActionTitle, systemImage: "arrow.right") {
                            advanceIntroBeat()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .accessibilityHint(introActionHint)
                    }
                    .frame(maxWidth: usesAsymmetricHeroLayout ? 310 : 610, alignment: usesAsymmetricHeroLayout ? .leading : .center)
                    .offset(x: usesAsymmetricHeroLayout ? -205 : 0)
                    .padding(.horizontal, 24)
                }

                Spacer(minLength: 0)

                Text(introBeat < 4
                     ? "Conceptual teaching anatomy · not a patient scan"
                     : "Fictional teaching case · no patient data · emergencies follow hospital protocol")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(34)
            .scaleEffect(isOpening && !reduceMotion ? 1.025 : 1)
            .opacity(isOpening ? 0.28 : 1)
            .blur(radius: isOpening && !reduceMotion ? 10 : 0)
        }
        .padding(26)
        .frame(width: 820, height: 520)
        .onAppear {
            if experience.soundEnabled {
                prelude.play()
            }
            routeProofIfNeeded()
        }
        .onChange(of: experience.soundEnabled) { _, enabled in
            if enabled {
                prelude.play()
            } else {
                prelude.stop()
            }
        }
        .onDisappear { prelude.stop() }
        .strokeSemanticSelectionFeedback(trigger: experience.interactionFeedbackToken)
        .task { await playIntroSequence() }
        .task(id: introBeat) { await revealIntroCopy() }
    }

    private var introTitle: String {
        switch introBeat {
        case 0: "The brain is not one object."
        case 1: "A surface becomes a world."
        case 2: "Signals become networks."
        default: "There is always another scale."
        }
    }

    private var introSubtitle: String {
        switch introBeat {
        case 0: "Folds, vessels, fluid spaces, deep structures, and signalling networks share one volume."
        case 1: "Move closer and broad folds resolve into layered cortical architecture."
        case 2: "Cells hand activity from branch to branch while vessels support the surrounding tissue."
        default: "Explore with curiosity, or guide a family through a careful clinical explanation."
        }
    }

    /// The prelude is a short spatial sequence, not a slideshow. Naming the
    /// next scale on the control lets a learner understand the consequence of
    /// a pinch before they take it, without adding another explanatory panel.
    private var introActionTitle: String {
        switch introBeat {
        case 0: "See cortical columns"
        case 1: "See signalling networks"
        case 2: "See another scale"
        default: "Choose a path"
        }
    }

    private var introActionHint: String {
        switch introBeat {
        case 0: "Moves from the whole brain to a conceptual cortical-column view"
        case 1: "Moves from cortical columns to a conceptual signalling-network view"
        case 2: "Moves to the final invitation before choosing how to explore"
        default: "Opens the Curious learner and Doctor presenter choices"
        }
    }

    private func advanceIntroBeat() {
        introLineReveal = 0
        withAnimation(.easeInOut(duration: 0.55)) {
            introBeat = min(introBeat + 1, 4)
        }
    }

    @MainActor
    private func revealIntroCopy() async {
        guard introBeat < 4 else {
            introLineReveal = 2
            return
        }
        if reduceMotion {
            introLineReveal = 2
            return
        }
        introLineReveal = 0
        withAnimation(.easeOut(duration: 0.42)) {
            introLineReveal = 1
        }
        try? await Task.sleep(for: .milliseconds(620))
        guard !Task.isCancelled else { return }
        withAnimation(.easeOut(duration: 0.48)) {
            introLineReveal = 2
        }
    }

    private func roleChoiceCard(
        title: String,
        subtitle: String,
        detail: String,
        systemImage: String,
        tint: Color,
        prominent: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 9) {
                HStack(spacing: 9) {
                    Image(systemName: systemImage)
                        .font(.title3.weight(.semibold))
                    Text(title)
                        .font(.headline.weight(.semibold))
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                        .opacity(0.62)
                }
                Text(subtitle)
                    .font(.callout.weight(.medium))
                    .multilineTextAlignment(.leading)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(prominent ? .white.opacity(0.72) : .secondary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
            .padding(16)
            .contentShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
        .foregroundStyle(prominent ? Color.white : tint)
        .background(
            prominent ? tint.gradient : Color.white.opacity(0.055).gradient,
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(tint.opacity(prominent ? 0.22 : 0.48), lineWidth: 1)
        }
        .hoverEffect(.highlight)
        .accessibilityElement(children: .combine)
    }

    private func playIntroSequence() async {
        guard !CommandLine.arguments.contains(where: { $0.hasPrefix("--proof-") }) else { return }
        for target in 1...4 {
            try? await Task.sleep(for: .seconds(reduceMotion ? 2.0 : 6.4))
            guard !Task.isCancelled, !introSequenceWasSkipped, introBeat < target else { continue }
            await MainActor.run { advanceIntroBeat() }
        }
    }

    @MainActor
    private func enterSpatialCaseRoom(as lens: StrokeAudienceLens) async {
        guard !isOpening else { return }
        isOpening = true
        prelude.stop()
        // An evidence space can outlive the immersive scene. A fresh role
        // choice must always begin at the intended Family/Doctor threshold.
        dismissWindow(id: StrokeSpace.evidence)
        experience.reset()
        experience.audienceLens = lens
        if lens == .family {
            experience.beginPatientExploration()
        } else {
            // Patient-file review belongs in the real room: the clinician can
            // glance between the case and family without entering a dark set.
            experience.environmentMode = .surroundings
        }
        let result = await openImmersiveSpace(id: StrokeSpace.immersive)
        guard result == .opened else {
            isOpening = false
            return
        }
        experience.isImmersivePresented = true
        dismissWindow(id: StrokeSpace.window)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Label("STROKE CARE", systemImage: "brain.head.profile")
                    .font(.caption.weight(.bold))
                    .tracking(2.0)
                    .foregroundStyle(.cyan.opacity(0.82))
                Text("Pull one case into view")
                    .font(.title2.weight(.semibold))
            }
            Spacer()
            Label("NO PATIENT DATA", systemImage: "checkmark.shield")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.48))
        }
    }

    private var patientFileShelf: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("PATIENT FILES", systemImage: "cabinet.fill")
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.68))

            Text("Pinch + pull")
                .font(.callout)
                .foregroundStyle(.secondary)

            ZStack(alignment: .topLeading) {
                archivedFolder("Archive 03", depth: -34, y: 176)
                archivedFolder("Archive 02", depth: -18, y: 92)
                activeCaseFolder
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            Button(casePlaced ? "Return file" : "Unfold without dragging") {
                casePlaced ? returnCase() : placeCase()
            }
            .buttonStyle(.plain)
            .font(.caption.weight(.semibold))
            .foregroundStyle(casePlaced ? Color.secondary : Color.cyan)
        }
        .padding(18)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white.opacity(0.09)))
    }

    private var activeCaseFolder: some View {
        caseFolderCard
            .opacity(casePlaced ? 0 : 1)
            .offset(x: caseFolderX, y: caseFolderY)
            .offset(z: caseFolderZ)
            .rotation3DEffect(
                .degrees(caseFolderRotation),
                axis: (x: 0, y: 1, z: 0)
            )
            .scaleEffect(1 + caseRevealProgress * 0.035)
            .gesture(caseFolderDragGesture)
            .accessibilityLabel("Fictional file 78, acute stroke conversation")
            .accessibilityHint("Drag right to progressively reveal the teaching facts")
    }

    private var caseFolderCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("FILE 78")
                    .font(.caption.monospacedDigit().weight(.bold))
                Spacer()
                Image(systemName: casePlaced ? "pin.fill" : "hand.pinch.fill")
            }
            Text("Stroke conversation")
                .font(.headline)
                .lineLimit(2)
            Text("Adult · fictional")
                .font(.caption)
                .foregroundStyle(.black.opacity(0.58))
        }
        .padding(16)
        .frame(width: 205, height: 126, alignment: .leading)
        .foregroundStyle(Color.black.opacity(0.84))
        .background(
            LinearGradient(
                colors: [Color(red: 0.95, green: 0.80, blue: 0.49), Color(red: 0.80, green: 0.59, blue: 0.29)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: UnevenRoundedRectangle(
                topLeadingRadius: 9,
                bottomLeadingRadius: 20,
                bottomTrailingRadius: 20,
                topTrailingRadius: 9
            )
        )
        .shadow(color: .black.opacity(0.34), radius: 20, y: 10)
    }

    private var caseFolderX: CGFloat {
        casePlaced ? 250 : max(0, fileDrag.width)
    }

    private var caseFolderY: CGFloat {
        casePlaced ? 116 : max(-20, min(70, fileDrag.height * 0.18))
    }

    private var caseFolderZ: CGFloat {
        casePlaced ? 90 : caseRevealProgress * 70
    }

    private var caseFolderRotation: Double {
        casePlaced ? -4 : -8 + caseRevealProgress * 8
    }

    private var caseFolderDragGesture: some Gesture {
        DragGesture(minimumDistance: 3)
            .onChanged { value in
                guard !casePlaced else { return }
                let horizontal = max(0, min(300, value.translation.width))
                fileDrag = CGSize(width: horizontal, height: value.translation.height)
                caseRevealProgress = horizontal / 300
            }
            .onEnded { _ in
                if caseRevealProgress >= 0.58 {
                    placeCase()
                } else {
                    returnCase()
                }
            }
    }

    private func archivedFolder(_ title: String, depth: Double, y: CGFloat) -> some View {
        HStack {
            Image(systemName: "folder.fill")
            Text(title)
            Spacer()
        }
        .font(.caption.weight(.medium))
        .foregroundStyle(.white.opacity(0.30))
        .padding(.horizontal, 14)
        .frame(width: 202, height: 66)
        .background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 16))
        .offset(y: y)
        .offset(z: depth)
    }

    private var unfoldingCaseSpace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.028))
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white.opacity(0.08 + caseRevealProgress * 0.08))

            CaseFactConstellation(progress: caseRevealProgress)
                .padding(24)

            if casePlaced {
                placedCaseTab
                    .position(x: 76, y: 62)
                    .transition(.scale.combined(with: .opacity))
            }

            if caseRevealProgress < 0.08 {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.right.circle")
                        .font(.system(size: 42, weight: .light))
                    Text("Pull file here")
                        .font(.title3.weight(.semibold))
                    Text("Details unfold as it moves.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }

            if casePlaced {
                VStack {
                    Spacer()
                    roleEntryActions
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .padding(20)
            }
        }
        .animation(.easeOut(duration: 0.28), value: casePlaced)
        .accessibilityLabel("Shared case space")
    }

    private var roleEntryActions: some View {
        VStack(spacing: 10) {
            Text("WHO IS WEARING XCAT?")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Button {
                    Task { await enterStory(as: .family) }
                } label: {
                    Label("Family questions", systemImage: "person.2.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)

                Button {
                    Task { await enterStory(as: .clinician) }
                } label: {
                    Label("Presenter rail", systemImage: "lock.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private var placedCaseTab: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("FILE 78")
                    .font(.caption2.monospacedDigit().weight(.bold))
                Spacer()
                Image(systemName: "pin.fill")
            }
            Text("Placed")
                .font(.caption.weight(.semibold))
        }
        .padding(11)
        .frame(width: 128, height: 72, alignment: .leading)
        .foregroundStyle(Color.black.opacity(0.78))
        .background(Color(red: 0.90, green: 0.71, blue: 0.40), in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.24), radius: 12, y: 7)
        .offset(z: 42)
        .accessibilityLabel("File 78 placed in the shared space")
    }

    private func placeCase() {
        withAnimation(reduceMotion ? nil : .spring(response: 0.52, dampingFraction: 0.84)) {
            caseRevealProgress = 1
            fileDrag = .zero
            casePlaced = true
        }
    }

    private func returnCase() {
        withAnimation(reduceMotion ? nil : .easeOut(duration: 0.34)) {
            caseRevealProgress = 0
            fileDrag = .zero
            casePlaced = false
        }
    }

    @MainActor
    private func enterStory(as lens: StrokeAudienceLens) async {
        guard !isOpening, casePlaced else { return }
        isOpening = true
        // Do not carry a previously opened evidence surface into a new story.
        dismissWindow(id: StrokeSpace.evidence)
        experience.reset()
        experience.audienceLens = lens
        if !reduceMotion {
            try? await Task.sleep(for: .milliseconds(220))
        }
        _ = await openImmersiveSpace(id: StrokeSpace.immersive)
        experience.isImmersivePresented = true
        dismissWindow(id: StrokeSpace.window)
        isOpening = false
    }

    private func routeProofIfNeeded() {
        guard !proofRouteHasRun else { return }
        proofRouteHasRun = true
        if CommandLine.arguments.contains("--proof-role-choice") {
            introBeat = 4
        } else if CommandLine.arguments.contains("--proof-spatial-prelude-hero") {
            introBeat = 0
        } else if CommandLine.arguments.contains("--proof-spatial-prelude") {
            introBeat = 2
        } else if CommandLine.arguments.contains("--proof-case-unfold") ||
            CommandLine.arguments.contains("--proof-cabinet-selected") {
            experience.prepareCaseHistoryWebProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-evidence-window") {
            experience.prepareEvidenceProof()
            Task { await openEvidenceProofWindow() }
        } else if CommandLine.arguments.contains("--proof-evidence") {
            experience.prepareEvidenceProof()
            Task { await openProofSpace(opensEvidence: true) }
        } else if CommandLine.arguments.contains("--proof-layer-study") {
            experience.prepareLayerStudyProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-procedure-field") {
            experience.prepareProcedureFieldProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-interior-handoff") {
            experience.prepareInteriorHandoffProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-integrated-interior")
            || CommandLine.arguments.contains("--proof-integrated-ventricles")
            || CommandLine.arguments.contains("--proof-integrated-cortex")
            || CommandLine.arguments.contains("--proof-integrated-cortex-flow")
            || CommandLine.arguments.contains("--proof-integrated-neural-gradient")
            || CommandLine.arguments.contains("--proof-integrated-neural")
            || CommandLine.arguments.contains("--proof-integrated-loading") {
            experience.prepareIntegratedInteriorProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-surface-cue") {
            experience.prepareFamilyAtlasSurfaceCueProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-direct-surface-pick") {
            experience.prepareFamilyAtlasDirectSurfacePickProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-temporal-cue") {
            experience.prepareFamilyAtlasTemporalCueProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-internal-plain-words") {
            experience.prepareFamilyAtlasInternalPlainWordsProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-internal-reference") {
            experience.prepareFamilyAtlasInternalReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-cerebellum-journey") {
            experience.prepareFamilyAtlasCerebellumJourneyProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-transparent-layer") {
            experience.prepareTransparentLayerProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-view-anterior") {
            experience.prepareAnatomyViewpointProof(.anterior)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-view-lateral-a") {
            experience.prepareAnatomyViewpointProof(.lateralA)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-view-lateral-b") {
            experience.prepareAnatomyViewpointProof(.lateralB)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-view-superior") {
            experience.prepareAnatomyViewpointProof(.superior)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-view-inferior") {
            experience.prepareAnatomyViewpointProof(.inferior)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-environment-surroundings") {
            experience.prepareEnvironmentProof(.surroundings)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-environment-warm") {
            experience.prepareEnvironmentProof(.warmHorizon)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-environment-focus") {
            experience.prepareEnvironmentProof(.focusField)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-presenter-controls") {
            experience.preparePresenterControlsProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-presentation-settings") {
            experience.preparePresentationSettingsProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery-placement-return") {
            experience.prepareImagingGalleryPlacementProof(returns: true)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery-placed-local") {
            experience.prepareImagingGalleryPlacementProof(local: true)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery-placed") {
            experience.prepareImagingGalleryPlacementProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery-return") {
            experience.prepareImagingGalleryProof(returns: true)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery-sixteen") {
            experience.prepareImagingGalleryProof(layout: .four)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery-nine") {
            experience.prepareImagingGalleryProof(layout: .three)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-gallery") || CommandLine.arguments.contains("--proof-imaging-gallery-detail") {
            experience.prepareImagingGalleryProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-reference-medications") {
            experience.prepareReferenceWorkspaceProof(.medications)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-reference-guides") {
            experience.prepareReferenceWorkspaceProof(.guides)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-reference-return") {
            experience.prepareReferenceReturnProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-room") {
            experience.prepareImagingRoomProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-import-lifecycle") {
            experience.prepareImagingImportLifecycleProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-imaging-import-return") {
            experience.prepareImagingImportLifecycleProof(returnToAnatomy: true)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-clinician-toolkit") {
            experience.prepareClinicianToolKitProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-toolkit-full") {
            experience.prepareClinicianToolKitFullProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-toolkit-motion") {
            experience.prepareClinicianToolKitMotionProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-scholar-skull") {
            experience.prepareScholarSkullProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-spatial-intake") {
            experience.reset()
            experience.audienceLens = .clinician
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-spatial-docked-case") {
            experience.prepareSpatialDockedCaseProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-selected-case-handoff") {
            experience.prepareSelectedCaseHandoffProof()
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-clinician-pressure") {
            experience.prepareClinicianProof(step: .inspectOcclusion)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-six-beat-timeline") {
            experience.prepareClinicianSixBeatTimelineProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-protective-covering") {
            experience.prepareClinicianProtectiveCoveringProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-craniotomy") {
            experience.prepareClinicianCraniotomyStoryProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-access-layer-open") {
            experience.prepareAccessLayerStudyProof(opened: true)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-access-layer-closed") {
            experience.prepareAccessLayerStudyProof(opened: false)
            Task { await openProofSpace(opensCompanion: false) }
        } else if CommandLine.arguments.contains("--proof-main-overview") {
            experience.prepareMainOverviewProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-layer-hierarchy") {
            experience.prepareClinicianLayerHierarchyProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-anatomy-internal") {
            experience.prepareAnatomyInternalFocusProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-anatomy-surface") {
            experience.prepareAnatomySurfaceFocusProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-anatomy-vessels") {
            experience.prepareAnatomyVesselsFocusProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-anatomy-vessels-unavailable") {
            experience.prepareAnatomyVesselsFocusProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-anatomy-internal-unavailable") {
            experience.prepareAnatomyInternalFocusProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-main-selected-point") {
            experience.prepareTeachingImagingProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-spatial-annotation") {
            experience.prepareSpatialAnnotationProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-spatial-ink") {
            experience.prepareSpatialInkProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-selected-point") {
            experience.prepareFamilyTeachingReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-surface-reference") {
            experience.prepareFamilySurfaceReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-neuron-unsure") {
            experience.prepareFamilyNeuronUnsureProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-neuron-plain-words") {
            experience.prepareFamilyNeuronPlainWordsProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-neuron-reference") {
            experience.prepareFamilyNeuronReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-affected-reference") {
            experience.prepareFamilyAffectedReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-nearby-reference") {
            experience.prepareFamilyNearbyReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-explore-nearby") {
            experience.prepareFamilyExploreNearbyProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-opposite-reference") {
            experience.prepareFamilyOppositeReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-arterial-reference") {
            experience.prepareFamilyArterialReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-arterial-supply-reference") {
            experience.prepareFamilyArterialSupplyReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-arterial-branch-reference") {
            experience.prepareFamilyArterialBranchReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-arterial-beyond-reference") {
            experience.prepareFamilyArterialBeyondReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-explore-beyond") {
            experience.prepareFamilyExploreBeyondProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-arterial-territory-reference") {
            experience.prepareFamilyArterialTerritoryReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-vessel-route-trace") {
            experience.prepareFamilyVesselRouteTraceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-blockage-interior") {
            experience.prepareFamilyBlockageInteriorProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-blockage-return") {
            experience.prepareFamilyBlockageReturnProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-layer-reference") {
            experience.prepareFamilyLayerReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-teaching-imaging") {
            experience.prepareTeachingImagingProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-modality-reference") {
            experience.prepareImagingModalityReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-pet-term-note") {
            experience.prepareImagingPETTermNoteProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-study-deck") {
            experience.prepareImagingStudyDeckProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-return-to-anatomy") {
            experience.prepareImagingReturnToAnatomyProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-return-reopen") {
            experience.prepareImagingReturnReopenProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-term-return-reopen") {
            experience.prepareImagingTermReturnReopenProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-imaging-local-import") {
            experience.prepareLocalImagingImportProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-question") {
            experience.prepareFamilyQuestionProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-clarity") {
            experience.prepareFamilyClarityProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-brain-atlas") {
            experience.prepareFamilyBrainAtlasProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-arterial-atlas-flow") {
            experience.prepareFamilyArterialAtlasFlowProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-next-chapter") {
            experience.prepareFamilyAtlasNextChapterProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-atlas-interior-ready") {
            experience.prepareFamilyAtlasInteriorReadyProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-presenter-plain-language") {
            experience.preparePresenterPlainLanguageProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-realtime-narration") {
            // The deterministic receipt stops at the explicit invitation.
            // It never auto-accepts or starts audio on the learner's behalf.
            experience.prepareFamilySurfaceReferenceProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-read-more") {
            experience.prepareFamilyReadMoreProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-pressure") {
            experience.prepareProof(step: .inspectOcclusion)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-pressure-story") {
            experience.prepareFamilyPressureStoryProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-entry-hint") {
            experience.prepareFamilyEntryHintProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-pressure-story") {
            experience.prepareClinicianPressureStoryProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-care-purpose") {
            experience.prepareProof(step: .discussCare)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-make-space-purpose") {
            experience.prepareFamilyMakeSpacePurposeProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-orient") {
            experience.prepareProof(step: .chooseCase)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--hackathon-demo") {
            experience.prepareHackathonDemo()
        }
    }

    @MainActor
    private func openProofSpace(opensEvidence: Bool = false, opensCompanion: Bool = false) async {
        try? await Task.sleep(for: .milliseconds(700))
        let result = await openImmersiveSpace(id: StrokeSpace.immersive)
        print("PROOF_IMMERSIVE_RESULT=\(result)")
        guard result == .opened else { return }
        experience.isImmersivePresented = true
        if opensCompanion {
            let companionID = experience.audienceLens == .clinician ? StrokeSpace.presenter : StrokeSpace.family
            openWindow(id: companionID, value: companionID)
        }
        if opensEvidence {
            // In normal use the presenter taps the evidence button after this
            // window exists. The deterministic proof waits for the same
            // hierarchy so the evidence space can resolve `.above(presenter)`.
            try? await Task.sleep(for: .milliseconds(650))
            openWindow(id: StrokeSpace.evidence, value: StrokeSpace.evidence)
        }
        dismissWindow(id: StrokeSpace.window)
    }

    @MainActor
    private func openEvidenceProofWindow() async {
        try? await Task.sleep(for: .milliseconds(500))
        openWindow(id: StrokeSpace.evidence, value: StrokeSpace.evidence)
        dismissWindow(id: StrokeSpace.window)
    }
}

private struct CaseFactConstellation: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Canvas { context, size in
                    let points = [
                        CGPoint(x: size.width * 0.24, y: size.height * 0.23),
                        CGPoint(x: size.width * 0.71, y: size.height * 0.18),
                        CGPoint(x: size.width * 0.78, y: size.height * 0.52),
                        CGPoint(x: size.width * 0.34, y: size.height * 0.58)
                    ]
                    var path = Path()
                    for edge in [(0, 1), (1, 2), (2, 3)] {
                        path.move(to: points[edge.0])
                        path.addLine(to: points[edge.1])
                    }
                    context.stroke(path, with: .color(.cyan.opacity(0.16 * progress)), lineWidth: 1.2)
                }

                fact("REPORTED", "Speech change", icon: "waveform", tint: .orange, threshold: 0.18)
                    .position(x: geometry.size.width * 0.24, y: geometry.size.height * 0.23)
                fact("ALSO REPORTED", "Right arm weakness", icon: "figure.arms.open", tint: .orange, threshold: 0.38)
                    .position(x: geometry.size.width * 0.71, y: geometry.size.height * 0.18)
                fact("TIME", "70 minutes ago", icon: "clock.fill", tint: .yellow, threshold: 0.58)
                    .position(x: geometry.size.width * 0.78, y: geometry.size.height * 0.52)
                fact("SCENARIO", "Severe stroke + swelling", icon: "brain.head.profile", tint: .mint, threshold: 0.78)
                    .position(x: geometry.size.width * 0.34, y: geometry.size.height * 0.58)
            }
        }
    }

    private func fact(
        _ label: String,
        _ value: String,
        icon: String,
        tint: Color,
        threshold: Double
    ) -> some View {
        let local = max(0, min(1, (progress - threshold) / 0.20))
        return VStack(alignment: .leading, spacing: 7) {
            Label(label, systemImage: icon)
                .font(.caption2.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(tint)
            Text(value)
                .font(.callout.weight(.semibold))
        }
        .padding(13)
        .frame(width: 180, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(tint.opacity(0.20)))
        .opacity(local)
        .offset(y: (1 - local) * 18)
        .offset(z: local * 34)
        .scaleEffect(0.94 + local * 0.06)
    }
}
