import Foundation

enum StrokeLocalImageImportTarget: Equatable, Sendable {
    case primary
    case comparison
}

/// A file read belongs to one deliberate choice, not whichever view or slot
/// happens to be active when the read eventually completes.
struct StrokeImagingImportRequest: Equatable, Sendable {
    let id: UUID
    let target: StrokeLocalImageImportTarget
}

struct StrokeImagingImportSession {
    private(set) var pending: StrokeImagingImportRequest?

    mutating func begin(target: StrokeLocalImageImportTarget) -> StrokeImagingImportRequest {
        let request = StrokeImagingImportRequest(id: UUID(), target: target)
        pending = request
        return request
    }

    func isCurrent(_ request: StrokeImagingImportRequest) -> Bool {
        pending == request
    }

    /// Old completions must not consume a newer request.
    mutating func consume(_ request: StrokeImagingImportRequest) -> Bool {
        guard isCurrent(request) else { return false }
        pending = nil
        return true
    }

    mutating func cancel() {
        pending = nil
    }
}
