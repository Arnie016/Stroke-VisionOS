import Foundation

@main
struct AccessLayerStudyVerification {
    static func main() {
        var checks = 0
        func expect(_ condition: Bool, _ message: String) {
            precondition(condition, message)
            checks += 1
        }
        var study = StrokeAccessLayerStudy()
        expect(!study.move(to: 1), "Inactive study accepted movement")
        study.start()
        expect(study.isActive && study.boneProgress == 0 && study.duraProgress == 0, "Start did not restore the model")
        expect(study.move(to: 0.35) && study.boneProgress == 0.35, "A partial drag must retain its pose")
        expect(!study.move(to: .nan), "Non-finite progress accepted")
        expect(study.boneProgress == 0.35, "Invalid movement changed the mesh pose")
        study.select(.dura)
        expect(!study.move(to: 1), "The inner cover moved through the outer layer")
        expect(study.instruction.contains("Lift the bone"), "Interlock is not explained")
        study.select(.bone)
        expect(study.move(to: 5) && study.boneProgress == 1, "Outward drag did not clamp")
        study.select(.dura)
        expect(study.move(to: 1) && study.duraProgress == 1, "Exposed dura did not lift")
        study.select(.bone)
        expect(!study.move(to: 0), "Bone passed through the separated dura")
        expect(study.instruction.contains("Return the dura"), "Return order is not explained")
        study.select(.dura)
        expect(study.move(to: -3) && study.duraProgress == 0, "Inward drag did not clamp")
        study.select(.bone)
        expect(study.move(to: 0) && study.boneProgress == 0, "Bone did not return")
        _ = study.move(to: 1)
        study.reset()
        expect(study.isActive && study.selectedLayer == .bone && study.boneProgress == 0 && study.duraProgress == 0, "Reset is not reversible")
        study.end()
        expect(!study.isActive && !study.move(to: 1), "Exit left a live interaction")
        study.select(.dura)
        expect(study.selectedLayer == .bone, "Selection changed while inactive")
        print("ACCESS_LAYER_STUDY=PASS checks=\(checks)")
    }
}
