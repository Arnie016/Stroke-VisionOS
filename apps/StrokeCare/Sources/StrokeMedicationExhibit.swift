import RealityKit
import UIKit

struct StrokeMedicineExhibitTargetComponent: Component {
    let medicineID: String
}

enum StrokeMedicationExhibit {
    static let rootName = "spatial-medication-teaching-exhibits"
    static let ids = ["antiplatelets", "anticoagulants", "thrombolysis", "prevention"]

    static func makeRoot() -> Entity {
        let root = Entity()
        root.name = rootName
        root.isEnabled = false
        let x: [Float] = [-0.21, -0.07, 0.07, 0.21]
        for (index, id) in ids.enumerated() {
            let exhibit = makeExhibit(id)
            exhibit.name = "medicine-exhibit-\(id)"
            exhibit.position = [x[index], 1.69, -0.61]
            exhibit.components.set(StrokeMedicineExhibitTargetComponent(medicineID: id))
            exhibit.components.set(CollisionComponent(shapes: [.generateBox(size: [0.18, 0.21, 0.08])]))
            exhibit.components.set(InputTargetComponent())
            exhibit.components.set(HoverEffectComponent())
            root.addChild(exhibit)
        }
        return root
    }

    static func update(root: Entity, selectedID: String, yaw: Float, visible: Bool) {
        root.isEnabled = visible
        for id in ids {
            guard let exhibit = root.findEntity(named: "medicine-exhibit-\(id)") else { continue }
            let selected = id == selectedID
            exhibit.scale = selected ? [0.68, 0.68, 0.68] : [0.56, 0.56, 0.56]
            exhibit.orientation = simd_quatf(angle: selected ? yaw : 0, axis: [0, 1, 0])
            exhibit.findEntity(named: "selection-rim")?.isEnabled = selected
        }
    }

    private static func makeExhibit(_ id: String) -> Entity {
        let root = Entity()
        let white = SimpleMaterial(color: UIColor(white: 0.94, alpha: 1), roughness: 0.38, isMetallic: false)
        let mint = SimpleMaterial(color: UIColor(red: 0.20, green: 0.82, blue: 0.70, alpha: 1), roughness: 0.30, isMetallic: false)
        let cyan = SimpleMaterial(color: UIColor(red: 0.20, green: 0.65, blue: 0.92, alpha: 1), roughness: 0.24, isMetallic: false)
        let amber = SimpleMaterial(color: UIColor(red: 0.94, green: 0.51, blue: 0.18, alpha: 1), roughness: 0.38, isMetallic: false)
        let silver = SimpleMaterial(color: UIColor(white: 0.50, alpha: 1), roughness: 0.45, isMetallic: false)
        switch id {
        case "antiplatelets":
            let blister = ModelEntity(mesh: .generateBox(size: [0.13, 0.17, 0.008], cornerRadius: 0.014), materials: [silver])
            for row in 0..<3 { for column in 0..<2 {
                let tablet = ModelEntity(mesh: .generateSphere(radius: 0.017), materials: [white])
                tablet.scale.z = 0.42
                tablet.position = [Float(column) * 0.050 - 0.025, Float(row) * 0.050 - 0.050, 0.012]
                blister.addChild(tablet)
            }}
            root.addChild(blister)
        case "anticoagulants":
            let barrel = ModelEntity(mesh: .generateCylinder(height: 0.13, radius: 0.022), materials: [white])
            barrel.orientation = simd_quatf(angle: .pi / 2, axis: [0, 0, 1])
            let band = ModelEntity(mesh: .generateCylinder(height: 0.045, radius: 0.024), materials: [cyan])
            band.orientation = barrel.orientation; band.position.x = -0.020
            root.addChild(barrel); root.addChild(band)
            let plunger = ModelEntity(mesh: .generateBox(size: [0.042, 0.010, 0.012], cornerRadius: 0.004), materials: [white])
            plunger.position.x = 0.077; root.addChild(plunger)
            let grip = ModelEntity(mesh: .generateBox(size: [0.010, 0.055, 0.018], cornerRadius: 0.005), materials: [mint])
            grip.position.x = 0.101; root.addChild(grip)
            let roundedTip = ModelEntity(mesh: .generateSphere(radius: 0.011), materials: [mint])
            roundedTip.position.x = -0.074; root.addChild(roundedTip)
        case "thrombolysis":
            let bag = ModelEntity(mesh: .generateBox(size: [0.115, 0.160, 0.024], cornerRadius: 0.025), materials: [white])
            let fill = ModelEntity(mesh: .generateBox(size: [0.094, 0.070, 0.027], cornerRadius: 0.018), materials: [cyan])
            fill.position.y = -0.032; bag.addChild(fill)
            let port = ModelEntity(mesh: .generateCylinder(height: 0.050, radius: 0.012), materials: [mint])
            port.position.y = -0.102; root.addChild(bag); root.addChild(port)
        default:
            let bottle = ModelEntity(mesh: .generateCylinder(height: 0.135, radius: 0.050), materials: [amber])
            let cap = ModelEntity(mesh: .generateCylinder(height: 0.030, radius: 0.052), materials: [white])
            cap.position.y = 0.082
            let label = ModelEntity(mesh: .generateBox(size: [0.101, 0.055, 0.012], cornerRadius: 0.006), materials: [mint])
            label.position.z = 0.045
            root.addChild(bottle); root.addChild(cap); root.addChild(label)
        }
        let rim = ModelEntity(mesh: .generateBox(size: [0.18, 0.006, 0.075], cornerRadius: 0.003), materials: [mint])
        rim.name = "selection-rim"; rim.position.y = -0.13; rim.isEnabled = false; root.addChild(rim)
        return root
    }
}
