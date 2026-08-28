import Foundation

/// An inspectable model of two authored layers, not a surgical procedure.
/// Progress describes only a mesh's closed-to-separated presentation pose.
enum StrokeAccessStudyLayer: String, CaseIterable, Identifiable {
    case bone = "Bone"
    case dura = "Dura"

    var id: String { rawValue }
}

struct StrokeAccessLayerStudy: Equatable {
    private(set) var isActive = false
    private(set) var selectedLayer: StrokeAccessStudyLayer = .bone
    private(set) var boneProgress: Float = 0
    private(set) var duraProgress: Float = 0

    var selectedProgress: Float {
        selectedLayer == .bone ? boneProgress : duraProgress
    }

    /// Keep the nested model legible. This is a presentation interlock, not
    /// operative guidance: the inner cover cannot pass through the outer one.
    var canMoveSelectedLayer: Bool {
        isActive && (selectedLayer == .bone ? duraProgress <= 0.001 : boneProgress >= 0.999)
    }

    var instruction: String {
        if selectedLayer == .dura && boneProgress < 0.999 {
            return "Lift the bone model to see the dura."
        }
        if selectedLayer == .bone && duraProgress > 0.001 {
            return "Return the dura model before the bone."
        }
        return selectedProgress < 0.5
            ? "Pinch the mint handle and pull the layer outward."
            : "Push the layer back, or choose Return below."
    }

    mutating func start() {
        self = Self()
        isActive = true
    }

    mutating func select(_ layer: StrokeAccessStudyLayer) {
        guard isActive else { return }
        selectedLayer = layer
    }

    @discardableResult
    mutating func move(to progress: Float) -> Bool {
        guard canMoveSelectedLayer, progress.isFinite else { return false }
        let bounded = min(1, max(0, progress))
        if selectedLayer == .bone {
            boneProgress = bounded
        } else {
            duraProgress = bounded
        }
        return true
    }

    mutating func reset() {
        guard isActive else { return }
        start()
    }

    mutating func end() {
        self = Self()
    }
}
