import RealityKit
import SwiftUI

/// The window is a quiet threshold, not the lesson. The spatial model becomes
/// the interface after one deliberate action.
struct StrokeJourneyLaunchView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isOpening = false
    @State private var casePlaced = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.055, green: 0.060, blue: 0.070), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Label("STROKE CARE", systemImage: "brain.head.profile")
                        .font(.caption.weight(.semibold))
                        .tracking(2.2)
                        .foregroundStyle(.white.opacity(0.78))
                    Spacer()
                    Label("FICTIONAL TEACHING FILE", systemImage: "checkmark.shield")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.48))
                }

                HStack(alignment: .top, spacing: 18) {
                    caseCabinet
                        .frame(width: 220)

                    relationshipBoard
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 390)

                Button {
                    Task { await enterStory() }
                } label: {
                    Label(isOpening ? "Opening…" : "Enter spatial explanation", systemImage: "viewfinder")
                        .font(.headline)
                        .frame(minWidth: 290)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.24, green: 0.67, blue: 0.78))
                .controlSize(.large)
                .disabled(isOpening || !casePlaced)

                Text("Clinician controls the explanation · Real emergency response follows hospital protocol")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.42))
            }
            .padding(28)
            .scaleEffect(isOpening && !reduceMotion ? 1.035 : 1)
            .opacity(isOpening ? 0.25 : 1)
            .blur(radius: isOpening && !reduceMotion ? 12 : 0)
        }
        .frame(width: 820, height: 620)
        .onAppear {
            if CommandLine.arguments.contains("--proof-cabinet-selected") {
                casePlaced = true
            } else if CommandLine.arguments.contains("--proof-clinician-pressure") {
                experience.prepareClinicianProof(step: .inspectOcclusion)
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
    }

    @MainActor
    private func enterStory() async {
        guard !isOpening, casePlaced else { return }
        isOpening = true
        experience.reset()
        if !reduceMotion {
            try? await Task.sleep(for: .milliseconds(260))
        }
        _ = await openImmersiveSpace(id: StrokeSpace.immersive)
        experience.isImmersivePresented = true
        isOpening = false
    }

    private var caseCabinet: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("CASE CABINET", systemImage: "cabinet.fill")
                .font(.caption.weight(.bold))
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.70))

            Text("Select one teaching file")
                .font(.callout)
                .foregroundStyle(.secondary)

            Spacer(minLength: 2)

            Button {
                placeCase()
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("FILE 78")
                            .font(.caption.monospacedDigit().weight(.bold))
                        Spacer()
                        Image(systemName: casePlaced ? "pin.fill" : "hand.pinch.fill")
                    }
                    Text("Acute stroke conversation")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Text("Adult · fictional")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.58))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.black.opacity(0.82))
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.93, green: 0.78, blue: 0.48), Color(red: 0.80, green: 0.60, blue: 0.30)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: UnevenRoundedRectangle(
                        topLeadingRadius: 8,
                        bottomLeadingRadius: 18,
                        bottomTrailingRadius: 18,
                        topTrailingRadius: 8
                    )
                )
            }
            .buttonStyle(.plain)
            .draggable(experience.teachingCase.id)
            .accessibilityLabel("Fictional case 78, acute stroke conversation")
            .accessibilityHint("Pinch and place the file on the relationship board")

            ForEach(["Archive slot 02", "Archive slot 03"], id: \.self) { title in
                HStack {
                    Image(systemName: "folder")
                    Text(title)
                    Spacer()
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.34))
                .padding(.horizontal, 12)
                .frame(height: 38)
                .background(Color.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 10))
            }

            Spacer(minLength: 2)

            Text(casePlaced ? "File pinned to the board" : "Pinch and place, or tap")
                .font(.caption2.weight(.medium))
                .foregroundStyle(casePlaced ? .cyan : .secondary)
        }
        .padding(18)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.10)))
    }

    private var relationshipBoard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(Color(red: 0.075, green: 0.078, blue: 0.082))
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(casePlaced ? 0.16 : 0.08))

            if casePlaced {
                CaseRelationshipThreads()
                    .padding(26)
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "pin.circle")
                        .font(.system(size: 42, weight: .light))
                    Text("Place a file to reveal the shared map")
                        .font(.title3.weight(.semibold))
                    Text("Only the information needed for this conversation appears.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(30)
            }
        }
        .dropDestination(for: String.self) { items, _ in
            guard items.contains(experience.teachingCase.id) else { return false }
            placeCase()
            return true
        }
        .accessibilityLabel(casePlaced ? "Case 78 relationship board" : "Empty case relationship board")
    }

    private func placeCase() {
        withAnimation(reduceMotion ? nil : .spring(response: 0.46, dampingFraction: 0.82)) {
            casePlaced = true
        }
    }

    @MainActor
    private func openProofSpace() async {
        // Simulator launches can request a proof route before the first window
        // frame exists. Let that scene register before transitioning so the
        // system does not retain its generic globe placeholder.
        try? await Task.sleep(for: .milliseconds(700))
        _ = await openImmersiveSpace(id: StrokeSpace.immersive)
        experience.isImmersivePresented = true
    }
}

private struct CaseRelationshipThreads: View {
    var body: some View {
        ZStack {
            Canvas { context, size in
                let points: [CGPoint] = [
                    CGPoint(x: size.width * 0.18, y: size.height * 0.25),
                    CGPoint(x: size.width * 0.72, y: size.height * 0.20),
                    CGPoint(x: size.width * 0.82, y: size.height * 0.70),
                    CGPoint(x: size.width * 0.30, y: size.height * 0.76)
                ]
                var path = Path()
                for edge in [(0, 1), (1, 2), (2, 3), (3, 0), (0, 2)] {
                    path.move(to: points[edge.0])
                    path.addLine(to: points[edge.1])
                }
                context.stroke(path, with: .color(.orange.opacity(0.38)), lineWidth: 1.4)
                for point in points {
                    context.fill(
                        Path(ellipseIn: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)),
                        with: .color(.orange.opacity(0.82))
                    )
                }
            }

            VStack(spacing: 14) {
                HStack(alignment: .top, spacing: 14) {
                    caseNote("FILE 78", "Adult teaching scenario", icon: "person.text.rectangle", tint: .cyan)
                    caseNote("REPORTED", "Speech change\nRight arm weakness", icon: "waveform.path.ecg", tint: .orange)
                }
                HStack(alignment: .top, spacing: 14) {
                    caseNote("TIME", "Last known well\n70 minutes ago", icon: "clock", tint: .yellow)
                    caseNote("OPEN QUESTIONS", "Imaging? Vessel?\nWhich options now?", icon: "questionmark.bubble", tint: .mint)
                }
            }
            .padding(22)

            VStack {
                HStack {
                    Label("SHARED CLINICAL MAP", systemImage: "point.3.connected.trianglepath.dotted")
                        .font(.caption2.weight(.bold))
                        .tracking(1.0)
                        .foregroundStyle(.white.opacity(0.52))
                    Spacer()
                    Text("FICTIONAL · NO PATIENT DATA")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.36))
                }
                Spacer()
            }
        }
    }

    private func caseNote(_ title: String, _ detail: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .font(.caption2.weight(.bold))
                    .tracking(0.9)
            }
            .foregroundStyle(tint)
            Text(detail)
                .font(.callout.weight(.semibold))
                .foregroundStyle(.white.opacity(0.88))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            Image(systemName: "pin.fill")
                .font(.caption)
                .foregroundStyle(tint.opacity(0.75))
                .padding(11)
        }
    }
}
