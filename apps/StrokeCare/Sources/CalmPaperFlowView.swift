import Foundation
import RealityKit
import UIKit

/// Native RealityKit ribbons inspired by the earlier Paper Shader experiment.
/// They communicate calm continuity—not blood, perfusion, pressure, emotion,
/// or any patient measurement. Geometry keeps the horizon transparent in an
/// immersive space; a large SwiftUI attachment would render as an occluding
/// rectangular texture in Simulator and on device.
@MainActor
enum CalmFlowFieldFactory {
    static func makeHorizon() -> Entity {
        let root = Entity()
        root.components.set(OpacityComponent(opacity: 0.72))

        // Apple recommends a ground plane so an immersive environment does not
        // feel like a black void. These low-contrast meshes are atmosphere, not
        // a literal clinic, office, or claimed therapeutic environment.
        let ground = ModelEntity(
            mesh: .generateBox(width: 4.8, height: 0.012, depth: 4.8, cornerRadius: 0.006),
            materials: [environmentMaterial(
                color: UIColor(red: 0.72, green: 0.58, blue: 0.43, alpha: 0.24),
                opacity: 0.24
            )]
        )
        ground.name = "calm-ground-plane"
        ground.position = [0, -1.70, 0.32]
        root.addChild(ground)

        let horizonVeil = ModelEntity(
            mesh: .generateBox(width: 5.2, height: 3.0, depth: 0.012, cornerRadius: 0.28),
            materials: [environmentMaterial(
                color: UIColor(red: 0.76, green: 0.64, blue: 0.52, alpha: 0.30),
                opacity: 0.30
            )]
        )
        horizonVeil.name = "calm-horizon-veil"
        horizonVeil.position = [0, -0.15, -0.14]
        root.addChild(horizonVeil)

        for index in 0..<6 {
            let progress = Float(index) / 5
            let ribbon = ModelEntity(
                mesh: .generateBox(
                    width: 1.22 + progress * 0.26,
                    height: 0.026 + progress * 0.008,
                    depth: 0.008,
                    cornerRadius: 0.014
                ),
                materials: [ribbonMaterial(index: index, opacity: 0.10 + CGFloat(progress) * 0.03)]
            )
            ribbon.name = "calm-flow-ribbon-\(index)"
            ribbon.position = [
                index.isMultiple(of: 2) ? -0.10 : 0.08,
                -0.24 + progress * 0.48,
                -0.02 - progress * 0.018
            ]
            ribbon.orientation = simd_quatf(
                angle: -0.08 + progress * 0.14,
                axis: [0, 0, 1]
            )
            root.addChild(ribbon)
        }

        return root
    }

    static func update(
        _ root: Entity,
        time: TimeInterval,
        act: StrokeProcedureStep,
        isPaused: Bool,
        reduceMotion: Bool
    ) {
        let phase = isPaused || reduceMotion ? 0 : Float(time * 0.16)
        // The environment quietly follows the teaching intent: open while
        // orienting, restrained around pressure, and gently reopened when the
        // purpose of making space is discussed. This is atmosphere, not an
        // inferred emotional or physiological state.
        let targetOpacity: Float = switch act {
        case .chooseCase: 0.58
        case .inspectOcclusion: 0.76
        case .discussCare: 0.46
        }
        let currentOpacity = root.components[OpacityComponent.self]?.opacity ?? targetOpacity
        let resolvedOpacity = reduceMotion
            ? targetOpacity
            : currentOpacity + (targetOpacity - currentOpacity) * 0.035
        root.components.set(OpacityComponent(opacity: resolvedOpacity))

        let ribbons = root.children.filter { $0.name.hasPrefix("calm-flow-ribbon-") }
        for (index, ribbon) in ribbons.enumerated() {
            let progress = Float(index) / Float(max(ribbons.count - 1, 1))
            let baseY = -0.24 + progress * 0.48
            let actAmplitude: Float = switch act {
            case .chooseCase: 0.012
            case .inspectOcclusion: 0.006
            case .discussCare: 0.014
            }
            let drift = sin(phase + progress * 4.2) * (reduceMotion ? 0 : actAmplitude)
            ribbon.position.y = baseY + drift
            ribbon.orientation = simd_quatf(
                angle: -0.08 + progress * 0.14 + drift * 0.9,
                axis: [0, 0, 1]
            )
        }
    }

    private static func ribbonMaterial(index: Int, opacity: CGFloat) -> RealityKit.Material {
        let palette: [UIColor] = [
            UIColor(red: 0.28, green: 0.69, blue: 0.67, alpha: opacity),
            UIColor(red: 0.77, green: 0.54, blue: 0.48, alpha: opacity),
            UIColor(red: 0.45, green: 0.72, blue: 0.64, alpha: opacity),
            UIColor(red: 0.82, green: 0.71, blue: 0.60, alpha: opacity)
        ]

        var material = UnlitMaterial(color: palette[index % palette.count])
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        return material
    }

    private static func environmentMaterial(color: UIColor, opacity: CGFloat) -> RealityKit.Material {
        // Unlit translucent material keeps the dawn tint stable across room
        // lighting without pretending that this plane is physical scenery.
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        return material
    }
}
