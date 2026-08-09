import AVFoundation
import RealityKit
import SwiftUI

@MainActor
private final class StrokePreludeAudio: ObservableObject {
    private var player: AVAudioPlayer?

    func play() {
        guard player == nil,
              let url = Bundle.main.url(forResource: "FlowBed", withExtension: "wav"),
              let audio = try? AVAudioPlayer(contentsOf: url)
        else { return }
        audio.numberOfLoops = -1
        audio.volume = 0.12
        audio.prepareToPlay()
        audio.play()
        player = audio
    }

    func stop() {
        player?.stop()
        player = nil
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
    @StateObject private var prelude = StrokePreludeAudio()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.045, green: 0.055, blue: 0.060), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Label("STROKE CARE", systemImage: "brain.head.profile")
                    .font(.caption.weight(.bold))
                    .tracking(2.0)
                    .foregroundStyle(.orange)

                Text(introTitle)
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .contentTransition(.opacity)

                Text(introSubtitle)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .contentTransition(.opacity)

                if introBeat >= 2 {
                    HStack(spacing: 14) {
                        Button("Doctor → family", systemImage: "person.2.fill") {
                            Task { await enterSpatialCaseRoom(as: .family) }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)

                        Button("Clinician teaching", systemImage: "stethoscope") {
                            Task { await enterSpatialCaseRoom(as: .clinician) }
                        }
                        .buttonStyle(.bordered)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Button("Continue", systemImage: "arrow.right") {
                        advanceIntroBeat()
                    }
                    .buttonStyle(.bordered)
                }

                Text("Fictional teaching case · no patient data · emergencies follow hospital protocol")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(34)
            .scaleEffect(isOpening && !reduceMotion ? 1.025 : 1)
            .opacity(isOpening ? 0.28 : 1)
            .blur(radius: isOpening && !reduceMotion ? 10 : 0)
        }
        .frame(width: 620, height: 360)
        .onAppear {
            prelude.play()
            routeProofIfNeeded()
        }
        .onDisappear { prelude.stop() }
        .task { await playIntroSequence() }
    }

    private var introTitle: String {
        switch introBeat {
        case 0: "When time is urgent, clarity matters."
        case 1: "One calm shared picture can reduce uncertainty."
        default: "Who are you guiding today?"
        }
    }

    private var introSubtitle: String {
        switch introBeat {
        case 0: "A stroke conversation can begin before every answer is known."
        case 1: "See the case, explain the change, and leave with a next step."
        default: "Choose the purpose first. The room changes with it."
        }
    }

    private func advanceIntroBeat() {
        withAnimation(.easeInOut(duration: 0.55)) {
            introBeat = min(introBeat + 1, 2)
        }
    }

    private func playIntroSequence() async {
        guard !CommandLine.arguments.contains(where: { $0.hasPrefix("--proof-") }) else { return }
        for target in 1...2 {
            try? await Task.sleep(for: .seconds(2.2))
            guard !Task.isCancelled, introBeat < target else { continue }
            await MainActor.run { advanceIntroBeat() }
        }
    }

    @MainActor
    private func enterSpatialCaseRoom(as lens: StrokeAudienceLens) async {
        guard !isOpening else { return }
        isOpening = true
        prelude.stop()
        experience.reset()
        experience.audienceLens = lens
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
        if CommandLine.arguments.contains("--proof-case-unfold") ||
            CommandLine.arguments.contains("--proof-cabinet-selected") {
            caseRevealProgress = 1
            casePlaced = true
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
        } else if CommandLine.arguments.contains("--proof-environment-surroundings") {
            experience.prepareEnvironmentProof(.surroundings)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-environment-warm") {
            experience.prepareEnvironmentProof(.warmHorizon)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-environment-focus") {
            experience.prepareEnvironmentProof(.focusField)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-clinician-toolkit") {
            experience.prepareClinicianToolKitProof()
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
        } else if CommandLine.arguments.contains("--proof-clinician-pressure") {
            experience.prepareClinicianProof(step: .inspectOcclusion)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-teaching-imaging") {
            experience.prepareTeachingImagingProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-family-question") {
            experience.prepareFamilyQuestionProof()
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-realtime-narration") {
            experience.prepareProof(step: .inspectOcclusion)
            experience.narrationEnabled = true
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-pressure") {
            experience.prepareProof(step: .inspectOcclusion)
            Task { await openProofSpace() }
        } else if CommandLine.arguments.contains("--proof-care-purpose") {
            experience.prepareProof(step: .discussCare)
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
            openWindow(id: experience.audienceLens == .clinician ? StrokeSpace.presenter : StrokeSpace.family)
        }
        if opensEvidence {
            // In normal use the presenter taps the evidence button after this
            // window exists. The deterministic proof waits for the same
            // hierarchy so the evidence space can resolve `.above(presenter)`.
            try? await Task.sleep(for: .milliseconds(650))
            openWindow(id: StrokeSpace.evidence)
        }
        dismissWindow(id: StrokeSpace.window)
    }

    @MainActor
    private func openEvidenceProofWindow() async {
        try? await Task.sleep(for: .milliseconds(500))
        openWindow(id: StrokeSpace.evidence)
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
