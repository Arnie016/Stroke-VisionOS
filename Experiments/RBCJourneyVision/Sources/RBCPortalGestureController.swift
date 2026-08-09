import ARKit
import Foundation
import Observation
import simd

private enum RBCHandSide {
    case left
    case right
}

private struct RBCHandPose {
    var isTracked = false
    var wrist = SIMD3<Float>.zero
    var indexTip = SIMD3<Float>.zero

    var indexDirection: SIMD3<Float> {
        let vector = indexTip - wrist
        guard simd_length_squared(vector) > 0.000_1 else { return .zero }
        return simd_normalize(vector)
    }
}

/// Device-only hand recognizer for the two deliberate portal commands.
///
/// - T: both index fingertips meet while one wrist-to-index axis is vertical
///   and the other is horizontal; hold for 0.45 seconds to open one portal.
/// - Clap: both wrist joints close quickly below the near-hand threshold to
///   close every portal.
///
/// The Simulator uses explicit buttons and proof arguments. Compilation does
/// not claim that either gesture has been accepted by a wearer on XCAT.
@MainActor
@Observable
final class RBCPortalGestureController {
    private let session = ARKitSession()
    private let provider = HandTrackingProvider()
    private var anchorTask: Task<Void, Never>?
    private var eventTask: Task<Void, Never>?

    private var left = RBCHandPose()
    private var right = RBCHandPose()
    private var tCandidateSince: TimeInterval?
    private var previousWristDistance: Float?
    private var previousSampleTime: TimeInterval?
    private var lastGestureTime: TimeInterval = -.infinity

    private let tTipThreshold: Float = 0.095
    private let tHoldDuration: TimeInterval = 0.45
    private let clapDistanceThreshold: Float = 0.17
    private let clapClosingSpeed: Float = 0.20
    private let gestureCooldown: TimeInterval = 1.0

    func start(model: RBCJourneyModel) async {
        guard anchorTask == nil else { return }
        guard HandTrackingProvider.isSupported else {
            model.handTrackingStatus = "Hand gestures require Apple Vision Pro"
            return
        }

        model.handTrackingStatus = "Requesting hand tracking"
        let authorization = await session.requestAuthorization(for: [.handTracking])
        guard authorization[.handTracking] == .allowed else {
            model.handTrackingStatus = "Hand tracking not allowed · use portal buttons"
            return
        }

        do {
            try await session.run([provider])
            model.handTrackingStatus = "Hands live · hold T to open · clap to close"
        } catch {
            model.handTrackingStatus = "Hand tracking unavailable · use portal buttons"
            return
        }

        anchorTask = Task { [weak self, weak model] in
            guard let self, let model else { return }
            for await update in provider.anchorUpdates {
                guard !Task.isCancelled else { return }
                process(update, model: model)
            }
        }

        eventTask = Task { [weak self, weak model] in
            guard let self, let model else { return }
            for await event in session.events {
                guard !Task.isCancelled else { return }
                if case let .dataProviderStateChanged(_, newState, _) = event,
                   newState == .stopped {
                    model.handTrackingStatus = "Hand tracking stopped · use portal buttons"
                }
            }
        }
    }

    func stop() {
        anchorTask?.cancel()
        eventTask?.cancel()
        anchorTask = nil
        eventTask = nil
        session.stop()
        left = RBCHandPose()
        right = RBCHandPose()
        tCandidateSince = nil
        previousWristDistance = nil
        previousSampleTime = nil
    }

    private func process(_ update: AnchorUpdate<HandAnchor>, model: RBCJourneyModel) {
        let side: RBCHandSide = update.anchor.chirality == .left ? .left : .right

        guard update.event != .removed,
              update.anchor.isTracked,
              let skeleton = update.anchor.handSkeleton else {
            setPose(RBCHandPose(), for: side)
            tCandidateSince = nil
            return
        }

        let wrist = skeleton.joint(.wrist)
        let index = skeleton.joint(.indexFingerTip)
        guard wrist.isTracked, index.isTracked else {
            setPose(RBCHandPose(), for: side)
            tCandidateSince = nil
            return
        }

        let wristWorld = update.anchor.originFromAnchorTransform * wrist.anchorFromJointTransform
        let indexWorld = update.anchor.originFromAnchorTransform * index.anchorFromJointTransform
        setPose(
            RBCHandPose(
                isTracked: true,
                wrist: translation(of: wristWorld),
                indexTip: translation(of: indexWorld)
            ),
            for: side
        )
        evaluate(model: model, timestamp: Date.timeIntervalSinceReferenceDate)
    }

    private func evaluate(model: RBCJourneyModel, timestamp: TimeInterval) {
        guard left.isTracked, right.isTracked else {
            tCandidateSince = nil
            previousWristDistance = nil
            previousSampleTime = nil
            return
        }

        let wristDistance = simd_distance(left.wrist, right.wrist)
        if let previousWristDistance, let previousSampleTime {
            let deltaTime = max(timestamp - previousSampleTime, 0.001)
            let closingSpeed = (previousWristDistance - wristDistance) / Float(deltaTime)
            if wristDistance < clapDistanceThreshold,
               closingSpeed > clapClosingSpeed,
               timestamp - lastGestureTime > gestureCooldown {
                model.closeAllPortals()
                model.handTrackingStatus = "Clap recognized · portals closed"
                lastGestureTime = timestamp
                tCandidateSince = nil
            }
        }
        previousWristDistance = wristDistance
        previousSampleTime = timestamp

        let leftDirection = left.indexDirection
        let rightDirection = right.indexDirection
        let tipsMeet = simd_distance(left.indexTip, right.indexTip) < tTipThreshold
        let axesMakeT = (isVertical(leftDirection) && isHorizontal(rightDirection))
            || (isVertical(rightDirection) && isHorizontal(leftDirection))

        if tipsMeet && axesMakeT && timestamp - lastGestureTime > gestureCooldown {
            let began = tCandidateSince ?? timestamp
            tCandidateSince = began
            if timestamp - began >= tHoldDuration {
                model.openNextPortal()
                model.handTrackingStatus = "T recognized · portal opened"
                lastGestureTime = timestamp
                tCandidateSince = nil
            }
        } else {
            tCandidateSince = nil
        }
    }

    private func isVertical(_ direction: SIMD3<Float>) -> Bool {
        abs(direction.y) > 0.72
    }

    private func isHorizontal(_ direction: SIMD3<Float>) -> Bool {
        abs(direction.y) < 0.38 && simd_length(SIMD2<Float>(direction.x, direction.z)) > 0.72
    }

    private func setPose(_ pose: RBCHandPose, for side: RBCHandSide) {
        switch side {
        case .left: left = pose
        case .right: right = pose
        }
    }

    private func translation(of transform: simd_float4x4) -> SIMD3<Float> {
        SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}
