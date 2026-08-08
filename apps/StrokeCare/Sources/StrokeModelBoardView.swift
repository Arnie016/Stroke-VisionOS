import RealityKit
import SwiftUI

/// The Figma-derived dominant model panel: the same deterministic teaching rig
/// appears inside the case board before the learner expands it into space.
struct StrokeModelBoardView: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    @State private var orbitYaw: Float = -0.16
    @State private var orbitPitch: Float = 0.04
    @State private var modelScale: Float = 0.82
    @State private var previousDrag: CGSize = .zero
    @State private var previousMagnification = 1.0

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            RealityView { content in
                let root = await StrokeSceneFactory.makeScene(compact: true)
                root.position = [0, 0.035, 0.08]
                content.add(root)
            } update: { content in
                guard let root = content.entities.first(where: { $0.name == StrokeSceneFactory.rootName }) else {
                    return
                }

                StrokeSceneFactory.update(
                    root: root,
                    experience: experience,
                    time: timeline.date.timeIntervalSinceReferenceDate
                )
                root.scale = SIMD3(repeating: modelScale)
                root.orientation = simd_quatf(angle: orbitYaw, axis: [0, 1, 0])
                    * simd_quatf(angle: orbitPitch, axis: [1, 0, 0])
            }
            .gesture(
                DragGesture(minimumDistance: 3)
                    .targetedToAnyEntity()
                    .onChanged { value in
                        let translation = value.gestureValue.translation
                        let delta = CGSize(
                            width: translation.width - previousDrag.width,
                            height: translation.height - previousDrag.height
                        )
                        previousDrag = translation
                        orbitYaw += Float(delta.width) * 0.008
                        orbitPitch = min(max(orbitPitch + Float(delta.height) * 0.006, -0.65), 0.65)
                    }
                    .onEnded { _ in previousDrag = .zero }
            )
            .simultaneousGesture(
                MagnifyGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        let ratio = value.magnification / previousMagnification
                        modelScale = min(max(modelScale * Float(ratio), 0.58), 1.35)
                        previousMagnification = value.magnification
                    }
                    .onEnded { _ in previousMagnification = 1 }
            )
            .simultaneousGesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded { _ in experience.focusOcclusion() }
            )
        }
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.12), Color.cyan.opacity(0.035), Color.black.opacity(0.20)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28)
        )
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 4) {
                Label("LIVE 3D MODEL", systemImage: "view.3d")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(.orange)
                Text("Drag to orbit · pinch to scale · tap the vessel")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.09)))
        .accessibilityLabel("Interactive three-dimensional stroke teaching model")
    }
}
