import Foundation
import SwiftUI

enum StrokeAudienceLens: String, CaseIterable, Identifiable {
    case family = "Family"
    case clinician = "Presenter"

    var id: String { rawValue }
}

enum StrokeProcedureStep: Int, CaseIterable, Identifiable {
    case chooseCase
    case inspectOcclusion
    case discussCare

    var id: Int { rawValue }
    var number: Int { rawValue + 1 }

    var title: String {
        switch self {
        case .chooseCase: "Choose"
        case .inspectOcclusion: "Inspect"
        case .discussCare: "Discuss"
        }
    }
}

struct TeachingStrokeCase: Identifiable, Equatable {
    let id: String
    let displayName: String
    let ageBand: String
    let reportedSigns: String
    let lastKnownWell: String

    static let case78 = TeachingStrokeCase(
        id: "CASE-078",
        displayName: "Case 78",
        ageBand: "Adult teaching scenario",
        reportedSigns: "Speech change · right arm weakness",
        lastKnownWell: "Reported 70 minutes ago"
    )
}

enum StrokeCareDiscussion: String, CaseIterable, Identifiable {
    case medicineReview = "Plan A"
    case thrombectomyReview = "Plan B"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .medicineReview: "Clot-dissolving medicine review"
        case .thrombectomyReview: "Thrombectomy review"
        }
    }

    var familySummary: String {
        switch self {
        case .medicineReview:
            "The team checks whether clot-dissolving medicine could be used safely. Timing, imaging, bleeding risk, medicines, and history matter."
        case .thrombectomyReview:
            "For some larger blocked vessels, specialists may evaluate a catheter procedure. Imaging, vessel location, time, and the person's situation matter."
        }
    }

    var clinicianBoundary: String {
        switch self {
        case .medicineReview:
            "Conversation prompt only: verify imaging, last-known-well, contraindications, eligibility, and current institutional protocol. This model does not calculate treatment eligibility."
        case .thrombectomyReview:
            "Conversation prompt only: verify occlusion site, imaging profile, time window, disability context, and local neurointerventional criteria. This is not an EVT decision aid."
        }
    }

    var icon: String {
        switch self {
        case .medicineReview: "cross.vial.fill"
        case .thrombectomyReview: "point.topleft.down.to.point.bottomright.curvepath"
        }
    }
}

@MainActor
final class StrokeExperienceState: ObservableObject {
    let teachingCase = TeachingStrokeCase.case78

    @Published var procedureStep: StrokeProcedureStep = .chooseCase
    @Published var audienceLens: StrokeAudienceLens = .family
    @Published var isCaseSelected = false
    @Published var selectedCareDiscussion: StrokeCareDiscussion?
    @Published var reportIsVisible = false
    @Published var requestedPause = false
    @Published var clarificationRequested = false
    @Published var soundEnabled = true
    @Published var careViewPermissionGranted = false
    @Published var isConsentPromptVisible = false
    @Published var isImmersivePresented = false
    @Published private(set) var pendingConsentStep: StrokeProcedureStep?
    /// Spatial interaction state follows the proven Heart Field ownership
    /// pattern: the app state owns pose, while RealityKit only renders it.
    @Published var spatialZoom: Double = 1
    @Published var orbit = SIMD2<Float>.zero

    /// 0...1 animation channels. They drive a deterministic spatial teaching rig,
    /// not a patient scan, surgical simulation, or physiology calculation.
    @Published private(set) var brainRevealProgress: Double = 0
    @Published private(set) var vesselFocusProgress: Double = 0
    @Published private(set) var planPreviewProgress: Double = 0
    @Published private(set) var layerRevealProgress: Double = 0
    private var layerRevealTask: Task<Void, Never>?

    func selectTeachingCase() {
        isCaseSelected = true
        procedureStep = .inspectOcclusion
        withAnimation(.easeInOut(duration: 0.9)) {
            brainRevealProgress = 0.72
            vesselFocusProgress = 0.55
        }
    }

    /// Advances a clinician-paced spatial explanation. It never infers emotion,
    /// advances itself, or calculates a care recommendation.
    func advanceJourney() {
        requestedPause = false
        switch procedureStep {
        case .chooseCase:
            isCaseSelected = true
            procedureStep = .inspectOcclusion
            withAnimation(.easeInOut(duration: 1.0)) {
                brainRevealProgress = 0.28
                vesselFocusProgress = 1
            }
        case .inspectOcclusion:
            guard careViewPermissionGranted else {
                pendingConsentStep = .discussCare
                isConsentPromptVisible = true
                return
            }
            procedureStep = .discussCare
            withAnimation(.easeInOut(duration: 1.15)) {
                brainRevealProgress = 0.58
                vesselFocusProgress = 1
            }
            beginLayerReveal(reduceMotion: false)
        case .discussCare:
            requestedPause = true
        }
    }

    func grantNonGraphicCareViewPermission(reduceMotion: Bool = false) {
        careViewPermissionGranted = true
        isConsentPromptVisible = false
        let requestedStep = pendingConsentStep
        pendingConsentStep = nil
        if requestedStep == .discussCare {
            present(step: .discussCare, reduceMotion: reduceMotion)
        } else {
            advanceJourney()
        }
    }

    func declineCareView() {
        isConsentPromptVisible = false
        pendingConsentStep = nil
        requestedPause = true
    }

    func retreatJourney() {
        requestedPause = false
        isConsentPromptVisible = false
        pendingConsentStep = nil
        switch procedureStep {
        case .chooseCase:
            break
        case .inspectOcclusion:
            procedureStep = .chooseCase
            withAnimation(.easeInOut(duration: 0.8)) {
                brainRevealProgress = 0
                vesselFocusProgress = 0
            }
        case .discussCare:
            procedureStep = .inspectOcclusion
            withAnimation(.easeInOut(duration: 0.8)) {
                brainRevealProgress = 0.28
                vesselFocusProgress = 1
            }
        }
    }

    func togglePause() {
        requestedPause.toggle()
    }

    /// Explicit family feedback replaces any attempt to infer anxiety from
    /// face, voice, gaze, or physiology. It pauses the story and gives the
    /// clinician a calm clarification cue.
    func requestClarification() {
        clarificationRequested = true
        requestedPause = true
    }

    func acknowledgeClarification() {
        clarificationRequested = false
    }

    var clarificationCue: String {
        switch procedureStep {
        case .chooseCase:
            "Re-orient together: ask which part of the brain-and-vessel map is unclear."
        case .inspectOcclusion:
            "Clarify the difference between the blocked vessel, injured tissue, and pressure."
        case .discussCare:
            "Restate purpose first: making room may reduce pressure; it does not restore injured tissue."
        }
    }

    var journeyTitle: String {
        switch procedureStep {
        case .chooseCase: "Orient"
        case .inspectOcclusion: "Pressure"
        case .discussCare: "Make space"
        }
    }

    var journeyCaption: String {
        switch procedureStep {
        case .chooseCase:
            "The brain rests inside a fixed skull, supplied by branching vessels."
        case .inspectOcclusion:
            "A blocked vessel can injure tissue; swelling then has nowhere easy to go."
        case .discussCare:
            "Making space may reduce pressure. It does not restore tissue already injured."
        }
    }

    var journeyIntent: String {
        switch procedureStep {
        case .chooseCase: "Build a shared map."
        case .inspectOcclusion: "Separate injury from pressure."
        case .discussCare: "Explain purpose without promising outcome."
        }
    }

    /// Presenter copy is deliberately separate from the patient narration.
    /// It supports a clinician-led explanation but never supplies a script,
    /// treatment ranking, eligibility calculation, or patient-specific claim.
    var presenterCue: String {
        switch procedureStep {
        case .chooseCase:
            "Establish orientation before pathology. Point to the fixed skull, then the branching arterial map."
        case .inspectOcclusion:
            "Focus the blocked-vessel marker first, then reveal swelling. Name injury and pressure as related but different problems."
        case .discussCare:
            "After permission, separate the skull, dura, and brain layers slowly. State the purpose: create room, not restore injured tissue."
        }
    }

    var presenterLayerStatus: String {
        switch procedureStep {
        case .chooseCase:
            "Cortex · arterial map · fixed skull context"
        case .inspectOcclusion:
            "Occlusion marker · affected tissue · swelling · fixed skull"
        case .discussCare:
            "Persistent injury · bone flap · dural expansion"
        }
    }

    var presenterBoundary: String {
        switch procedureStep {
        case .chooseCase:
            "Generic teaching anatomy. Do not describe laterality, dimensions, or registration as patient-specific."
        case .inspectOcclusion:
            "No pressure value, tissue-volume estimate, prognosis, or treatment-eligibility inference is shown."
        case .discussCare:
            "Not a recommendation or outcome promise. The treating team explains whether this pathway applies."
        }
    }

    var primaryActionTitle: String {
        switch procedureStep {
        case .chooseCase: "Reveal what changed"
        case .inspectOcclusion: "Reveal layers with permission"
        case .discussCare: "Pause here"
        }
    }

    func setBrainReveal(_ value: Double) {
        brainRevealProgress = min(max(value, 0), 1)
    }

    func focusOcclusion() {
        withAnimation(.easeInOut(duration: 0.65)) {
            brainRevealProgress = 1
            vesselFocusProgress = 1
            spatialZoom = min(max(spatialZoom, 1.10), 1.30)
            orbit.y = max(orbit.y, 0.08)
        }
    }

    func rotateSpatialView(delta: CGSize) {
        orbit.x += Float(delta.width) * 0.008
        orbit.y = min(max(orbit.y + Float(delta.height) * 0.006, -0.78), 0.78)
    }

    func magnifySpatialView(ratio: Double) {
        spatialZoom = min(max(spatialZoom * ratio, 0.72), 1.45)
    }

    func resetSpatialView() {
        spatialZoom = 1
        orbit = .zero
    }

    func beginCareDiscussion() {
        procedureStep = .discussCare
        withAnimation(.easeInOut(duration: 0.55)) {
            brainRevealProgress = 0.92
            vesselFocusProgress = 1
        }
    }

    func present(step: StrokeProcedureStep, reduceMotion: Bool = false) {
        requestedPause = false
        clarificationRequested = false
        isConsentPromptVisible = false

        switch step {
        case .chooseCase:
            cancelLayerReveal()
            procedureStep = .chooseCase
            withAnimation(.easeInOut(duration: 0.65)) {
                brainRevealProgress = 0
                vesselFocusProgress = 0
                planPreviewProgress = 0
            }
        case .inspectOcclusion:
            cancelLayerReveal()
            isCaseSelected = true
            procedureStep = .inspectOcclusion
            withAnimation(.easeInOut(duration: 0.65)) {
                brainRevealProgress = 0.28
                vesselFocusProgress = 1
                planPreviewProgress = 0
            }
        case .discussCare:
            guard careViewPermissionGranted else {
                pendingConsentStep = .discussCare
                isConsentPromptVisible = true
                return
            }
            isCaseSelected = true
            procedureStep = .discussCare
            withAnimation(.easeInOut(duration: 0.75)) {
                brainRevealProgress = 0.58
                vesselFocusProgress = 1
                planPreviewProgress = 0
            }
            beginLayerReveal(reduceMotion: reduceMotion)
        }
    }

    private func beginLayerReveal(reduceMotion: Bool) {
        layerRevealTask?.cancel()
        layerRevealProgress = reduceMotion ? 1 : 0
        guard !reduceMotion else { return }

        layerRevealTask = Task { @MainActor [weak self] in
            guard let self else { return }
            let frames = 42
            for frame in 1...frames {
                guard !Task.isCancelled else { return }
                try? await Task.sleep(for: .milliseconds(28))
                let linear = Double(frame) / Double(frames)
                // A familiar, gentle zip/peel rhythm with no cutting motion.
                self.layerRevealProgress = 1 - pow(1 - linear, 3)
            }
        }
    }

    private func cancelLayerReveal() {
        layerRevealTask?.cancel()
        layerRevealTask = nil
        layerRevealProgress = 0
    }

    func selectCareDiscussion(_ discussion: StrokeCareDiscussion) {
        selectedCareDiscussion = discussion
        reportIsVisible = false
        withAnimation(.easeInOut(duration: 0.6)) {
            planPreviewProgress = discussion == .thrombectomyReview ? 1 : 0.45
        }
    }

    func createDiscussionSummary() {
        reportIsVisible = true
    }

    func setPauseRequested(_ requested: Bool) {
        requestedPause = requested
        if requested {
            planPreviewProgress = 0
        }
    }

    func reset() {
        cancelLayerReveal()
        procedureStep = .chooseCase
        audienceLens = .family
        isCaseSelected = false
        selectedCareDiscussion = nil
        reportIsVisible = false
        requestedPause = false
        clarificationRequested = false
        careViewPermissionGranted = false
        isConsentPromptVisible = false
        pendingConsentStep = nil
        resetSpatialView()
        withAnimation(.easeInOut(duration: 0.6)) {
            brainRevealProgress = 0
            vesselFocusProgress = 0
            planPreviewProgress = 0
        }
    }

    func prepareHackathonDemo() {
        reset()
    }

    func prepareProof(step: StrokeProcedureStep) {
        reset()
        switch step {
        case .chooseCase:
            break
        case .inspectOcclusion:
            isCaseSelected = true
            procedureStep = .inspectOcclusion
            brainRevealProgress = 1
            vesselFocusProgress = 1
        case .discussCare:
            isCaseSelected = true
            procedureStep = .discussCare
            brainRevealProgress = 0.92
            vesselFocusProgress = 1
            selectedCareDiscussion = nil
            planPreviewProgress = 0
            reportIsVisible = false
            careViewPermissionGranted = true
            layerRevealProgress = 1
        }
    }

    func prepareClinicianProof(step: StrokeProcedureStep) {
        prepareProof(step: step)
        audienceLens = .clinician
    }

    var discussionReport: String {
        let plan = selectedCareDiscussion?.title ?? "No pathway selected"
        return """
        \(teachingCase.id) · FICTIONAL
        Seen: schematic blockage + tissue at risk.
        Open: \(plan).
        Ask: What did imaging show? Which options now? What happens next?
        Discussion aid only—not diagnosis, recommendation, consent, or record.
        """
    }
}
