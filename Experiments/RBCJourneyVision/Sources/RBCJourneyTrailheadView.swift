import SwiftUI

struct RBCJourneyTrailheadView: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
    @State private var opening = false

    var body: some View {
        @Bindable var model = model

        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.015, blue: 0.025),
                    Color(red: 0.20, green: 0.035, blue: 0.055),
                    Color(red: 0.035, green: 0.018, blue: 0.030)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.red.opacity(0.16))
                .frame(width: 420, height: 420)
                .blur(radius: 70)
                .offset(x: 300, y: -170)

            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 10) {
                    Image(systemName: "circle.hexagongrid.fill")
                    Text("STANDALONE SPATIAL LESSON")
                        .tracking(1.8)
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.pink.opacity(0.9))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Inside the Flow")
                        .font(.system(size: 54, weight: .semibold, design: .rounded))
                    Text("A wondrous journey inside the brain.")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.72))
                        .frame(maxWidth: 690, alignment: .leading)
                }

                HStack(spacing: 10) {
                    ForEach(RBCExhibitBeat.allCases) { beat in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: beat.systemImage)
                                Spacer()
                                Text(beat.number)
                                    .font(.caption2.monospacedDigit().weight(.bold))
                            }
                            Text(beat.title)
                                .font(.caption.weight(.semibold))
                                .lineLimit(2)
                        }
                        .padding(13)
                        .frame(width: 206, height: 82, alignment: .leading)
                        .background(.white.opacity(0.065), in: .rect(cornerRadius: 16))
                        .foregroundStyle(.white.opacity(0.82))
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Comfort")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.58))

                    Picker("Motion", selection: $model.motionMode) {
                        ForEach(RBCJourneyMotionMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(model.motionMode.explanation)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.58))
                }

                HStack(spacing: 14) {
                    Button {
                        Task { await openJourney(starting: .entryPrelude) }
                    } label: {
                        Label(opening ? "Opening…" : "Begin the journey", systemImage: "sparkles")
                            .frame(minWidth: 200)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.90, green: 0.16, blue: 0.25))
                    .disabled(opening || model.isPresented)

                    Button {
                        Task { await openJourney(starting: .openAtlas) }
                    } label: {
                        Label("Explore the full atlas", systemImage: "brain.head.profile")
                    }
                    .buttonStyle(.bordered)
                    .disabled(opening || model.isPresented)

                    if model.isPresented {
                        Button("Leave full space", systemImage: "xmark") {
                            Task {
                                await dismissImmersiveSpace()
                                model.isPresented = false
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Label("The three-beat journey uses one vessel portal. Open Atlas keeps all three lenses and the seven-station lesson available.", systemImage: "hand.raised.fingers.spread")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.66))

                Text("Generic educational anatomy · not patient-specific · not CFD · specialist review required")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.42))
            }
            .padding(42)
        }
        .frame(width: 820, height: 660)
        .onAppear {
            model.systemReduceMotion = accessibilityReduceMotion
        }
        .task {
            if model.proofMode,
               !model.isPresented,
               !model.proofAutoLaunchConsumed {
                model.proofAutoLaunchConsumed = true
                await openJourney()
            }
        }
        .onOpenURL { url in
            guard RBCJourneyDeepLink.isEntry(url) else { return }
            Task { await openEntryDeepLink() }
        }
    }

    @MainActor
    private func openEntryDeepLink() async {
        if model.isPresented {
            model.startEntryPrelude()
            return
        }
        await openJourney(starting: .entryPrelude)
    }

    @MainActor
    private func openJourney(starting mode: RBCJourneyExperienceMode? = nil) async {
        guard !opening, !model.isPresented else { return }
        if mode == .entryPrelude {
            model.startEntryPrelude()
        } else if mode == .wondrousJourney {
            model.startWondrousJourney()
        } else if mode == .openAtlas {
            model.startOpenAtlas()
        }
        opening = true
        let result = await openImmersiveSpace(id: RBCJourneyModel.immersiveID)
        model.isPresented = result == .opened
        if result == .opened {
            dismissWindow(id: RBCJourneyModel.trailheadID)
        }
        opening = false
    }
}
