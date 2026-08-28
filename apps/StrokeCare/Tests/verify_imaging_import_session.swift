import Foundation

@main
struct VerifyImagingImportSession {
    static func main() {
        var session = StrokeImagingImportSession()
        var checks = 0
        func check(_ condition: Bool, _ message: String) {
            precondition(condition, message)
            checks += 1
        }

        check(session.pending == nil, "No import is pending initially")
        let primary = session.begin(target: .primary)
        check(primary.target == .primary, "Primary destination is captured")
        check(session.isCurrent(primary), "Fresh request can complete")
        session.cancel()
        check(!session.consume(primary), "Back rejects a late file read")
        check(session.pending == nil, "Rejected read cannot reopen a session")

        let old = session.begin(target: .primary)
        let current = session.begin(target: .comparison)
        check(old.id != current.id, "Each choice has a distinct identity")
        check(current.target == .comparison, "Comparison destination is captured")
        check(!session.consume(old), "An older read cannot replace a newer choice")
        check(session.isCurrent(current), "Rejecting an old read preserves the new one")
        check(session.consume(current), "The newest read completes once")
        check(!session.consume(current), "Duplicate completion is rejected")

        let cancelled = session.begin(target: .comparison)
        session.cancel()
        let reopened = session.begin(target: .primary)
        check(!session.consume(cancelled), "Reopening cannot revive a cancelled request")
        check(session.consume(reopened), "Fresh import after reopening still works")
        print("PASS: \(checks) imaging import lifecycle checks")
    }
}
