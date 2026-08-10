import RealityKit
import SwiftUI

/// A shared, realistic generic-anatomy teaching image for the current state.
/// It renders the same reviewed registered-v2 assets as the spatial lesson; it
/// is not a patient scan, diagnostic image, or clinical measurement. Both
/// audience roles open this one synchronized surface.
struct StrokeXrayWorkspaceView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissWindow) private var dismissWindow
    var tracksXrayWindowLifecycle = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.025, green: 0.045, blue: 0.060),
                    Color(red: 0.010, green: 0.014, blue: 0.022)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                header

                HStack(alignment: .top, spacing: 18) {
                    StrokeTeachingImagingPlate()
                        .environmentObject(experience)
                        .frame(width: 540, height: 392)

                    teachingState
                        .frame(width: 270, height: 392, alignment: .top)
                }
            }
            .padding(22)
        }
        .frame(width: 872, height: 510)
        .onAppear {
            guard tracksXrayWindowLifecycle else { return }
            experience.markXrayWindowPresented()
        }
        .onDisappear {
            guard tracksXrayWindowLifecycle else { return }
            experience.markXrayWindowClosed()
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.cyan.opacity(0.13))
                    .frame(width: 42, height: 42)
                Image(systemName: "viewfinder")
                    .foregroundStyle(.cyan)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("SHARED TEACHING X-RAY")
                    .font(.headline.weight(.bold))
                    .tracking(1.2)
                Text("Realistic generic anatomy · synthetic teaching image · not a patient scan")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Label("SYNCHRONIZED · SYNTHETIC", systemImage: "arrow.triangle.2.circlepath")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.cyan)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.cyan.opacity(0.09), in: Capsule())

            Button {
                if tracksXrayWindowLifecycle {
                    experience.beginXrayWindowClose()
                    dismissWindow(id: StrokeSpace.xray)
                } else {
                    dismissWindow(id: StrokeSpace.window)
                }
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .accessibilityLabel("Close teaching X-ray")
        }
    }

    private var teachingState: some View {
        VStack(alignment: .leading, spacing: 13) {
            stateCard(
                label: "ACT \(experience.procedureStep.number)",
                value: experience.journeyTitle,
                detail: experience.journeyIntent,
                systemImage: "timeline.selection",
                tint: .orange
            )

            stateCard(
                label: "LAYER VIEW",
                value: experience.anatomyPresentation.rawValue,
                detail: "Cortex opacity \(Int((experience.cortexOpacity * 100).rounded()))%",
                systemImage: "square.3.layers.3d",
                tint: .cyan
            )

            stateCard(
                label: "LESSON FIELD",
                value: experience.pointField.rawValue,
                detail: experience.selectedPointLabel ?? "No teaching point selected",
                systemImage: experience.pointField.systemImage,
                tint: .mint
            )

            Spacer(minLength: 0)

            Label("Synthetic · review pending", systemImage: "checkmark.shield")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text("It does not display uploaded imaging, infer a diagnosis, or represent this fictional case as a real radiograph.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.09)))
    }

    private func stateCard(
        label: String,
        value: String,
        detail: String,
        systemImage: String,
        tint: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(label, systemImage: systemImage)
                .font(.caption2.weight(.bold))
                .tracking(0.9)
                .foregroundStyle(tint)
            Text(value)
                .font(.headline)
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 15))
    }
}

private struct StrokeTeachingImagingPlate: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    @State private var orbitYaw: Float = -0.10
    @State private var orbitPitch: Float = 0.03
    @State private var modelScale: Float = 1.02
    @State private var previousDrag: CGSize = .zero
    @State private var previousMagnification = 1.0

    var body: some View {
        GeometryReader { geometry in
            let plateSize = geometry.size

            TimelineView(.animation(
                minimumInterval: 1.0 / 30.0,
                paused: experience.requestedPause
            )) { timeline in
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        colors: [
                            Color(red: 0.018, green: 0.042, blue: 0.054),
                            Color.black.opacity(0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: plateSize.width, height: plateSize.height)

                    RealityView { content in
                        // Full mode is intentional: compact mode is procedural.
                        // The shared image loads the registered generic brain,
                        // arteries, clot, and reviewed layer hierarchy without
                        // reducing mesh or semantic detail.
                        let root = await StrokeSceneFactory.makeScene(compact: false)
                        root.position = [0, -0.025, 0.08]
                        content.add(root)
                    } update: { content in
                        guard let root = content.entities.first(where: {
                            $0.name == StrokeSceneFactory.rootName
                        }) else { return }

                        StrokeSceneFactory.update(
                            root: root,
                            experience: experience,
                            time: timeline.date.timeIntervalSinceReferenceDate
                        )
                        root.scale = SIMD3(repeating: modelScale)
                        root.orientation = simd_quatf(angle: orbitYaw, axis: [0, 1, 0])
                            * simd_quatf(angle: orbitPitch, axis: [1, 0, 0])
                    }
                    .frame(width: plateSize.width, height: plateSize.height)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 3)
                            .onChanged { value in
                                let translation = value.translation
                                let delta = CGSize(
                                    width: translation.width - previousDrag.width,
                                    height: translation.height - previousDrag.height
                                )
                                previousDrag = translation
                                orbitYaw += Float(delta.width) * 0.006
                                orbitPitch = min(
                                    max(orbitPitch + Float(delta.height) * 0.005, -0.48),
                                    0.48
                                )
                            }
                            .onEnded { _ in previousDrag = .zero }
                    )
                    .simultaneousGesture(
                        MagnifyGesture()
                            .onChanged { value in
                                let ratio = value.magnification / previousMagnification
                                modelScale = min(max(modelScale * Float(ratio), 0.76), 1.28)
                                previousMagnification = value.magnification
                            }
                            .onEnded { _ in previousMagnification = 1 }
                    )

                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 3) {
                            Label("ASSET-DERIVED GENERIC VIEW", systemImage: "view.3d")
                                .font(.caption2.weight(.bold))
                                .tracking(0.9)
                                .foregroundStyle(.cyan)
                            Text("Drag to orient · pinch to scale")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(13)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 13))

                        Spacer()

                        HStack(spacing: 7) {
                            Circle()
                                .fill(affectedTint)
                                .frame(width: 8, height: 8)
                            Text(radiographCaption)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.78))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                    }
                    .padding(14)
                    .frame(
                        width: plateSize.width,
                        height: plateSize.height,
                        alignment: .topLeading
                    )
                    .allowsHitTesting(false)
                }
                .frame(width: plateSize.width, height: plateSize.height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.cyan.opacity(0.18), lineWidth: 1)
                        .allowsHitTesting(false)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    "Synthetic generic anatomy teaching image synchronized to \(experience.journeyTitle), \(experience.anatomyPresentation.rawValue), and \(experience.pointField.rawValue); not a patient scan"
                )
            }
            .frame(width: plateSize.width, height: plateSize.height)
        }
        .frame(width: 540, height: 392)
    }

    private var affectedTint: Color {
        switch experience.procedureStep {
        case .chooseCase: .cyan
        case .inspectOcclusion: .orange
        case .discussCare: .mint
        }
    }

    private var radiographCaption: String {
        switch experience.procedureStep {
        case .chooseCase: "Orient to the full registered generic model"
        case .inspectOcclusion: "Blockage and affected-tissue cues are qualitative"
        case .discussCare: "Making space does not restore injured tissue"
        }
    }
}
