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

        for index in 0..<6 {
            let progress = Float(index) / 5
            let ribbon = ModelEntity(
                mesh: .generateBox(
                    width: 1.22 + progress * 0.26,
                    height: 0.026 + progress * 0.008,
                    depth: 0.008,
                    cornerRadius: 0.014
                ),
                materials: [ribbonMaterial(index: index, opacity: 0.07 + CGFloat(progress) * 0.025)]
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

    static func update(_ root: Entity, time: TimeInterval, isPaused: Bool, reduceMotion: Bool) {
        let phase = isPaused || reduceMotion ? 0 : Float(time * 0.16)

        for (index, ribbon) in root.children.enumerated() {
            let progress = Float(index) / Float(max(root.children.count - 1, 1))
            let baseY = -0.24 + progress * 0.48
            let drift = sin(phase + progress * 4.2) * (reduceMotion ? 0 : 0.014)
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

        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: palette[index % palette.count])
        material.roughness = 1.0
        material.metallic = 0.0
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        return material
    }
}
