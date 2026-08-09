import Foundation
import SwiftUI

enum StrokeAudienceLens: String, CaseIterable, Identifiable {
    case family = "Patient / family"
    case clinician = "Doctor presenter"

    var id: String { rawValue }
}

enum StrokeSpatialPhase: String {
    case caseLibrary
    case caseReview
    case explanation
}

enum StrokeEnvironmentMode: String, CaseIterable, Identifiable {
    case surroundings = "Surroundings"
    case warmHorizon = "Warm horizon"
    case focusField = "Focus field"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .surroundings: "Room"
        case .warmHorizon: "Warm"
        case .focusField: "Focus"
        }
    }

    var systemImage: String {
        switch self {
        case .surroundings: "viewfinder"
        case .warmHorizon: "sun.horizon.fill"
        case .focusField: "circle.fill"
        }
    }
}

enum StrokePointField: String, CaseIterable, Identifiable {
    case regions = "Brain regions"
    case procedure = "Blood flow"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .regions: "brain.head.profile"
        case .procedure: "point.3.connected.trianglepath.dotted"
        }
    }

    var lessonPoints: [StrokeLessonPoint] {
        switch self {
        case .regions:
            [
                StrokeLessonPoint(index: 0, shortTitle: "Affected", fullTitle: "Example affected area"),
                StrokeLessonPoint(index: 1, shortTitle: "Nearby", fullTitle: "Nearby brain tissue"),
                StrokeLessonPoint(index: 2, shortTitle: "Surface", fullTitle: "Brain surface"),
                StrokeLessonPoint(index: 3, shortTitle: "Context", fullTitle: "Opposite-side context")
            ]
        case .procedure:
            [
                StrokeLessonPoint(index: 0, shortTitle: "Supply", fullTitle: "Blood supply approaches"),
                StrokeLessonPoint(index: 1, shortTitle: "Branch", fullTitle: "Arteries branch"),
                StrokeLessonPoint(index: 2, shortTitle: "Blockage", fullTitle: "Example blockage"),
                StrokeLessonPoint(index: 3, shortTitle: "Beyond", fullTitle: "Flow beyond the blockage changes"),
                StrokeLessonPoint(index: 4, shortTitle: "Territory", fullTitle: "Affected territory")
            ]
        }
    }

    var entityPrefix: String {
        switch self {
        case .regions: "clinician-region-point-field-point-"
        case .procedure: "clinician-procedure-point-field-point-"
        }
    }

    var defaultLessonPointIndex: Int {
        switch self {
        case .regions: 0
        case .procedure: 2
        }
    }
}

struct StrokeLessonPoint: Identifiable, Equatable {
    let index: Int
    let shortTitle: String
    let fullTitle: String

    var id: Int { index }
}

enum StrokeAnatomyPresentation: String, CaseIterable, Identifiable {
    case assembled = "Layers"
    case transparent = "See through"
    case exploded = "Study apart"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .assembled: "PROTECTIVE LAYERS"
        case .transparent: "SEE THROUGH BRAIN"
        case .exploded: "STUDY LAYERS APART"
        }
    }
}

/// Named, repeatable views of the authored anatomy. These rotate the complete
/// registered-v2 assembly as one object; they never reposition individual
/// organs, vessels, or lesson markers. A true medial view is intentionally not
/// offered until the cortex has reviewed left/right surfaces or a clipping
/// plane—the current single cortical surface cannot support that claim.
enum StrokeAnatomyViewpoint: String, CaseIterable, Identifiable {
    case free = "Free orbit"
    case threeQuarter = "Three-quarter"
    case anterior = "Front · model frame"
    case lateralA = "Side A · review laterality"
    case lateralB = "Side B · review laterality"
    case superior = "Top · model frame"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .free: "View"
        case .threeQuarter: "3/4"
        case .anterior: "Front"
        case .lateralA: "Side A"
        case .lateralB: "Side B"
        case .superior: "Top"
        }
    }

    var systemImage: String {
        switch self {
        case .free: "rotate.3d"
        case .threeQuarter: "view.3d"
        case .anterior: "person.crop.circle"
        case .lateralA: "arrow.left.circle"
        case .lateralB: "arrow.right.circle"
        case .superior: "arrow.down.to.line.circle"
        }
    }

    var orbit: SIMD2<Float> {
        switch self {
        case .free, .threeQuarter: .zero
        case .anterior: [0.42, 0]
        case .lateralA: [0.42 - Float.pi * 0.5, 0]
        case .lateralB: [0.42 + Float.pi * 0.5, 0]
        case .superior: [0.42, -Float.pi * 0.5]
        }
    }
}

enum StrokeEvidenceKind: String, Equatable {
    case guideline = "Guideline"
    case decisionAid = "Decision aid"
    case paper = "Paper"
    case web = "Web"
    case audio = "Audio"
    case video = "Video"

    var systemImage: String {
        switch self {
        case .guideline: "checkmark.seal"
        case .decisionAid: "person.text.rectangle"
        case .paper: "doc.richtext"
        case .web: "link"
        case .audio: "waveform"
        case .video: "play.rectangle"
        }
    }
}

struct StrokeEvidenceSource: Identifiable, Equatable {
    let id: String
    let shortTitle: String
    let fullCitation: String
    let stableURL: URL
    let kind: StrokeEvidenceKind
    let supports: String
    let limitation: String

    static let library: [StrokeEvidenceSource] = [
        StrokeEvidenceSource(
            id: "AHA-AIS-2026",
            shortTitle: "AHA/ASA acute stroke guideline",
            fullCitation: "American Heart Association/American Stroke Association. 2026 Guideline for the Early Management of Patients With Acute Ischemic Stroke.",
            stableURL: URL(string: "https://doi.org/10.1161/STR.0000000000000513")!,
            kind: .guideline,
            supports: "Acute ischemic stroke framing and clinician-led management context.",
            limitation: "Not a patient-specific recommendation or outcome estimate."
        ),
        StrokeEvidenceSource(
            id: "NICE-NG128",
            shortTitle: "NICE stroke recommendations",
            fullCitation: "National Institute for Health and Care Excellence. Stroke and transient ischaemic attack in over 16s: diagnosis and initial management. NG128.",
            stableURL: URL(string: "https://www.nice.org.uk/guidance/ng128/chapter/recommendations")!,
            kind: .guideline,
            supports: "Selection and communication context for decompressive hemicraniectomy.",
            limitation: "Jurisdiction-specific guidance; eligibility still belongs to the treating team."
        ),
        StrokeEvidenceSource(
            id: "NICE-DHCA-2019",
            shortTitle: "NICE family decision-aid guide",
            fullCitation: "National Institute for Health and Care Excellence. Decompressive hemicraniectomy surgery: patient decision aid user guide.",
            stableURL: URL(string: "https://www.nice.org.uk/guidance/ng128/resources/decompressive-hemicraniectomy-surgery-patient-decision-aid-user-guide-pdf-6775901391")!,
            kind: .decisionAid,
            supports: "Family-facing discussion of purpose, uncertainty, and shared decisions.",
            limitation: "Supports conversation; it is not consent and does not replace local review."
        )
    ]
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

/// A question is stored in the anatomy root's coordinate space, not as a
/// screen point. It therefore stays on the same teaching landmark when the
/// wearer orbits or magnifies the model.
struct PlacedStrokeQuestion: Equatable {
    let rootLocalPosition: SIMD3<Float>
    let semanticTarget: String
}

struct TeachingStrokeCase: Identifiable, Equatable {
    let id: String
    let displayName: String
    let ageBand: String
    let reportedSigns: String
    let lastKnownWell: String
    let scenarioFrame: String

    static let case78 = TeachingStrokeCase(
        id: "CASE-078",
        displayName: "Case 78",
        ageBand: "Adult teaching scenario",
        reportedSigns: "Speech change · right arm weakness",
        lastKnownWell: "Reported 70 minutes ago",
        scenarioFrame: "Severe large-territory ischemic stroke with swelling"
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

enum StrokeClinicianTool: String, CaseIterable, Identifiable {
    case focus = "Region focus"
    case transparency = "Transparency"
    case layerReveal = "Layers"
    case forceps = "Forceps"
    case cranialDrill = "Drill"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .focus: "scope"
        case .transparency: "circle.lefthalf.filled"
        case .layerReveal: "square.3.layers.3d"
        case .forceps: "move.3d"
        case .cranialDrill: "gearshape.2.fill"
        }
    }

    var boundary: String {
        switch self {
        case .focus: "Region focus · context fades"
        case .transparency: "Reversible transparency"
        case .layerReveal: "Permission-gated layer explanation"
        case .forceps: "Generic concept asset · specialist review pending"
        case .cranialDrill: "Generic concept asset · specialist review pending"
        }
    }
}

@MainActor
final class StrokeExperienceState: ObservableObject {
    static let scholarSkullCatalogID = "skull_semantic_realistic_v2"

    let teachingCase = TeachingStrokeCase.case78

    @Published var procedureStep: StrokeProcedureStep = .chooseCase
    @Published var audienceLens: StrokeAudienceLens = .family {
        didSet {
            guard audienceLens == .family else { return }
            detailLevel = .calm
            selectedCatalogAssetID = nil
            clinicianToolKitVisible = false
            selectedClinicianTool = .focus
        }
    }
    @Published private(set) var detailLevel: StrokeDetailLevel = .calm
    @Published private(set) var selectedCatalogAssetID: String?
    @Published var isCaseSelected = false
    @Published var selectedCareDiscussion: StrokeCareDiscussion?
    @Published var reportIsVisible = false
    @Published var requestedPause = false
    @Published var clarificationRequested = false
    @Published private(set) var familyComfortCheck: Double = 1
    @Published private(set) var familyComfortWasSet = false
    @Published var questionPlacementArmed = false
    @Published var questionMarkerVisible = false
    @Published private(set) var placedQuestion: PlacedStrokeQuestion?
    @Published var soundEnabled = true
    @Published var narrationEnabled = false
    @Published var closingReflectionVisible = false
    @Published var pointField: StrokePointField = .regions
    @Published var lessonPointsVisible = true
    @Published var teachingImagingDrawerVisible = false
    @Published var teachingImagingLens: StrokeTeachingImagingLens = .affectedVessel
    @Published var clinicianToolKitVisible = false
    @Published var selectedClinicianTool: StrokeClinicianTool = .focus
    @Published var anatomyPresentation: StrokeAnatomyPresentation = .assembled
    @Published private(set) var anatomyViewpoint: StrokeAnatomyViewpoint = .threeQuarter
    @Published var environmentMode: StrokeEnvironmentMode = .warmHorizon
    @Published var cortexOpacity: Double = 0.34
    @Published var regionPortalActive = false
    @Published private(set) var selectedPointEntityName: String?
    @Published private(set) var selectedPointLabel: String?
    @Published var selectedEvidenceID: String = StrokeEvidenceSource.library[0].id
    @Published private(set) var pinnedEvidenceIDs: [String] = []
    @Published var sourceBoundDraftVisible = false
    @Published var careViewPermissionGranted = false
    @Published var isConsentPromptVisible = false
    @Published var isImmersivePresented = false
    @Published var spatialPhase: StrokeSpatialPhase = .caseLibrary
    @Published var spatialCaseDocked = false
    @Published var spatialCaseFilePosition = SIMD3<Float>(-0.58, 1.45, -0.82)
    @Published var selectedCaseHistoryMilestone: StrokeCaseHistoryMilestone = .reportedChange
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
        spatialCaseDocked = true
        isCaseSelected = true
        spatialPhase = .caseReview
        selectedCaseHistoryMilestone = .reportedChange
        procedureStep = .chooseCase
    }

    func selectCaseHistoryMilestone(_ milestone: StrokeCaseHistoryMilestone) {
        guard spatialPhase == .caseReview else { return }
        selectedCaseHistoryMilestone = milestone
    }

    /// Detail is a presentation filter, never a fourth teaching act. Family
    /// mode is fixed to calm; a presenter may deliberately opt into more depth.
    func selectDetailLevel(_ level: StrokeDetailLevel) {
        guard audienceLens == .clinician || level == .calm else {
            resetCatalogPresentation()
            return
        }

        detailLevel = level
        if let selectedCatalogAssetID,
           !visibleCatalogRecords.contains(where: { $0.id == selectedCatalogAssetID }) {
            self.selectedCatalogAssetID = nil
        }
    }

    /// Selects catalog metadata only. Scene loading is intentionally absent.
    func selectCatalogAsset(id: String?) {
        guard let id,
              let record = StrokeAssetCatalog.record(id: id),
              record.isVisible(to: audienceLens, detailLevel: detailLevel) else {
            selectedCatalogAssetID = nil
            return
        }
        selectedCatalogAssetID = record.id
    }

    var visibleCatalogRecords: [StrokeAssetRecord] {
        StrokeAssetCatalog.visibleRecords(for: audienceLens, detailLevel: detailLevel)
    }

    /// The imported skull is an approximate cross-source fit marked
    /// REQUIRES_SPECIALIST_REVIEW. It can therefore be isolated only in the
    /// clinician Scholar lens; it is never presented as exact family anatomy.
    var isClinicianScholarSkullInspectionActive: Bool {
        audienceLens == .clinician &&
            detailLevel == .scholar &&
            selectedCatalogAssetID == Self.scholarSkullCatalogID
    }

    func resetCatalogPresentation() {
        detailLevel = .calm
        selectedCatalogAssetID = nil
    }

    func moveSpatialCaseFile(to position: SIMD3<Float>) {
        spatialCaseFilePosition = SIMD3<Float>(
            min(max(position.x, -0.78), 0.32),
            min(max(position.y, 1.18), 1.72),
            min(max(position.z, -1.08), -0.58)
        )
        let overDock = simd_distance(spatialCaseFilePosition, [0, 1.43, -0.82]) < 0.16
        spatialCaseDocked = overDock
        isCaseSelected = overDock
    }

    func settleSpatialCaseFile() {
        if simd_distance(spatialCaseFilePosition, [0, 1.43, -0.82]) < 0.22 {
            withAnimation(.easeInOut(duration: 0.38)) {
                spatialCaseFilePosition = [0, 1.43, -0.82]
                spatialCaseDocked = true
                isCaseSelected = true
                spatialPhase = .caseReview
                procedureStep = .chooseCase
                brainRevealProgress = 0
            }
        } else {
            withAnimation(.easeInOut(duration: 0.32)) {
                spatialCaseFilePosition = [-0.58, 1.45, -0.82]
                spatialCaseDocked = false
                isCaseSelected = false
                spatialPhase = .caseLibrary
                procedureStep = .chooseCase
                brainRevealProgress = 0
            }
        }
    }

    /// The patient file is a threshold, not persistent furniture. The case room
    /// disappears before anatomy appears, preserving one clear spatial task.
    func beginExplanation() {
        guard spatialCaseDocked, isCaseSelected else { return }
        spatialPhase = .explanation
        clearPointSelection()
        procedureStep = .chooseCase
        lessonPointsVisible = true
        requestedPause = false
        withAnimation(.easeInOut(duration: 0.72)) {
            brainRevealProgress = 0.18
            vesselFocusProgress = 0
        }
    }

    /// The layperson route is an anatomy exhibit, not a patient-record room.
    /// It enters the same generic teaching brain directly with calm detail and
    /// quiet discovery points. No fictional record is presented as theirs.
    func beginPatientExploration() {
        audienceLens = .family
        spatialPhase = .explanation
        spatialCaseDocked = false
        isCaseSelected = false
        procedureStep = .chooseCase
        detailLevel = .calm
        lessonPointsVisible = true
        clearPointSelection()
        requestedPause = false
        teachingImagingDrawerVisible = false
        withAnimation(.easeInOut(duration: 0.72)) {
            brainRevealProgress = 0.18
            vesselFocusProgress = 0
        }
    }

    func returnCaseToLibrary() {
        spatialPhase = .caseLibrary
        teachingImagingDrawerVisible = false
        spatialCaseDocked = false
        isCaseSelected = false
        spatialCaseFilePosition = [-0.58, 1.45, -0.82]
        brainRevealProgress = 0
        vesselFocusProgress = 0
        closingReflectionVisible = false
        narrationEnabled = false
    }

    func selectLessonFamily(_ field: StrokePointField) {
        pointField = field
        lessonPointsVisible = true
        // A lesson family begins as quiet anatomy-attached points. The wearer
        // decides which explanation to reveal; switching families never opens
        // a label or teaching reference on their behalf.
        clearPointSelection()
        requestedPause = false
        if field == .procedure {
            withAnimation(.easeInOut(duration: 0.65)) {
                brainRevealProgress = max(brainRevealProgress, 0.42)
                vesselFocusProgress = 1
            }
        }
    }

    func toggleLessonPoints() {
        lessonPointsVisible.toggle()
        if !lessonPointsVisible { clearPointSelection() }
    }

    func toggleTeachingImagingDrawer() {
        guard spatialPhase == .explanation else {
            teachingImagingDrawerVisible = false
            return
        }
        teachingImagingDrawerVisible.toggle()
    }

    /// Chooses one real registered teaching lens. The making-room purpose view
    /// remains behind the same explicit non-graphic care-view permission as
    /// layer separation; selecting it early opens that existing consent gate.
    func selectTeachingImagingLens(
        _ lens: StrokeTeachingImagingLens,
        reduceMotion: Bool = false
    ) {
        guard spatialPhase == .explanation else { return }
        if lens == .makingRoomPurpose,
           (procedureStep != .discussCare || !careViewPermissionGranted) {
            present(step: .discussCare, reduceMotion: reduceMotion)
            return
        }
        teachingImagingLens = lens
        teachingImagingDrawerVisible = true
    }

    /// Advances a clinician-paced spatial explanation. It never infers emotion,
    /// advances itself, or calculates a care recommendation.
    func advanceJourney() {
        if closingReflectionVisible {
            returnCaseToLibrary()
            return
        }
        requestedPause = false
        closingReflectionVisible = false
        regionPortalActive = false
        clearPointSelection()
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
            requestedPause = false
            closingReflectionVisible = true
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
        regionPortalActive = false
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

    /// The Vision Pro presenter records a family's explicitly stated,
    /// session-local conversation cue after asking aloud. It is not an anxiety score
    /// and is never inferred from gaze, voice, face, physiology,
    /// diagnosis, or patient data. Choosing Pause uses the same explicit
    /// clarification path as the family pause control.
    func setFamilyComfortCheck(_ value: Double) {
        familyComfortCheck = min(max(value, 0), 2)
        familyComfortWasSet = true
        if familyComfortCheck < 0.5 {
            requestClarification()
        }
    }

    func toggleQuestionPlacement() {
        questionPlacementArmed.toggle()
        if questionPlacementArmed {
            requestedPause = true
        }
    }

    func placeQuestionMarker(at rootLocalPosition: SIMD3<Float>, target: String) {
        guard questionPlacementArmed else { return }
        questionPlacementArmed = false
        questionMarkerVisible = true
        placedQuestion = PlacedStrokeQuestion(
            rootLocalPosition: rootLocalPosition,
            semanticTarget: target
        )
        clarificationRequested = true
        requestedPause = true
    }

    func clearQuestionMarker() {
        questionPlacementArmed = false
        questionMarkerVisible = false
        placedQuestion = nil
    }

    func acknowledgeClarification() {
        clarificationRequested = false
    }

    var selectedEvidence: StrokeEvidenceSource {
        StrokeEvidenceSource.library.first(where: { $0.id == selectedEvidenceID })
            ?? StrokeEvidenceSource.library[0]
    }

    var pinnedEvidence: [StrokeEvidenceSource] {
        pinnedEvidenceIDs.compactMap { id in
            StrokeEvidenceSource.library.first(where: { $0.id == id })
        }
    }

    func selectEvidence(_ source: StrokeEvidenceSource) {
        selectedEvidenceID = source.id
        sourceBoundDraftVisible = false
    }

    func togglePinnedEvidence(_ source: StrokeEvidenceSource) {
        if let index = pinnedEvidenceIDs.firstIndex(of: source.id) {
            pinnedEvidenceIDs.remove(at: index)
        } else {
            pinnedEvidenceIDs.append(source.id)
        }
        sourceBoundDraftVisible = false
    }

    func composeSourceBoundDraft() {
        guard !pinnedEvidenceIDs.isEmpty else { return }
        sourceBoundDraftVisible = true
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

    /// One calm prompt for the family lens. This stays distinct from the
    /// presenter rail so peripheral copy never turns into a second script.
    var familyTimelineQuestion: String {
        switch procedureStep {
        case .chooseCase:
            "Which layer is this?"
        case .inspectOcclusion:
            "Is this blockage, injury, or swelling?"
        case .discussCare:
            "What can this surgery change—and not change?"
        }
    }

    var familyQuestionSuggestions: [String] {
        switch procedureStep {
        case .chooseCase:
            [familyTimelineQuestion, "Can you show where this is?", "What do we know for sure?"]
        case .inspectOcclusion:
            [familyTimelineQuestion, "Can we pause at the blockage?", "What remains uncertain?"]
        case .discussCare:
            [familyTimelineQuestion, "What is the goal?", "What can this not change?"]
        }
    }

    var familyComfortLabel: String {
        guard familyComfortWasSet else { return "Not shared" }
        if familyComfortCheck < 0.5 { return "Pause" }
        if familyComfortCheck < 1.5 { return "Unsure" }
        return "Okay to continue"
    }

    /// Exactly three glanceable teaching beats for each act. These are
    /// orientation cues, not patient-specific findings or outcome claims.
    var presenterTimelineKeyPoints: [String] {
        if isClinicianScholarSkullInspectionActive {
            return [
                "Generic cross-source skull",
                "Inspect shape only",
                "Specialist review pending",
            ]
        }

        return switch procedureStep {
        case .chooseCase:
            ["Generic scenario", "Whole brain first", "Not a patient scan"]
        case .inspectOcclusion:
            ["Blockage → injury → swelling", "Keep them distinct", "No prognosis inferred"]
        case .discussCare:
            ["Ask before transparency", "Room, not repair", "No outcome promise"]
        }
    }

    var journeyCaption: String {
        switch procedureStep {
        case .chooseCase:
            "This model shows one severe stroke affecting one side of the brain."
        case .inspectOcclusion:
            "In this severe stroke, swelling builds inside the fixed skull."
        case .discussCare:
            "Surgery can make room for swelling. It cannot undo the stroke injury."
        }
    }

    var journeyIntent: String {
        switch procedureStep {
        case .chooseCase: "One model. One shared starting point."
        case .inspectOcclusion: "Separate blocked flow, injury, and swelling."
        case .discussCare: "Make room, not repair."
        }
    }

    /// Presenter copy is deliberately separate from the patient narration.
    /// It supports a clinician-led explanation but never supplies a script,
    /// treatment ranking, eligibility calculation, or patient-specific claim.
    var presenterCue: String {
        switch procedureStep {
        case .chooseCase:
            "Name the frame first: a generic large-territory ischemic-stroke scenario, not this person's scan."
        case .inspectOcclusion:
            "Point to blocked flow, affected tissue, then swelling. Keep all three distinct."
        case .discussCare:
            "With permission, fade one protective layer. Explain purpose and uncertainty: room, not repair."
        }
    }

    var presenterLayerStatus: String {
        if anatomyPresentation == .exploded && pointField == .regions {
            return "Deep structures · ventricles · generic anatomy · review pending"
        }
        if pointField == .procedure,
           selectedPointEntityName?.hasPrefix("clinician-procedure-point-field-point-") == true {
            return "Authored blood flow · qualitative · not CFD"
        }
        if anatomyPresentation == .transparent {
            return "Cortex · vessels · separated skull reference"
        }
        return switch procedureStep {
        case .chooseCase:
            "Cortex · arterial map · fixed skull context"
        case .inspectOcclusion:
            "Occlusion marker · affected tissue · swelling · fixed skull"
        case .discussCare:
            "Persistent injury · protective covering · room cue"
        }
    }

    var presenterBoundary: String {
        switch procedureStep {
        case .chooseCase:
            "Generic anatomy—not this patient's scan."
        case .inspectOcclusion:
            "This fictional severe-stroke frame is not inferred from the reported signs."
        case .discussCare:
            "Not a recommendation, consent discussion, or outcome promise."
        }
    }

    var primaryActionTitle: String {
        if closingReflectionVisible { return "Return to cases" }
        return switch procedureStep {
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
            anatomyViewpoint = .free
            brainRevealProgress = 1
            vesselFocusProgress = 1
            spatialZoom = min(max(spatialZoom, 1.10), 1.30)
            orbit.y = max(orbit.y, 0.08)
        }
    }

    func setAnatomyPresentation(_ presentation: StrokeAnatomyPresentation) {
        anatomyPresentation = presentation
        if presentation == .transparent {
            // Preserve cortical landmarks when the faint clinician-only skull
            // context appears around the registered brain.
            cortexOpacity = max(cortexOpacity, 0.58)
        }
        if presentation == .assembled {
            clearPointSelection()
        }
    }

    func setEnvironmentMode(_ mode: StrokeEnvironmentMode) {
        environmentMode = mode
    }

    /// A reversible museum-like aperture into the affected region. It changes
    /// the teaching viewpoint only: no teleport, diagnosis, patient scan, CFD,
    /// tissue cut, or procedural action is implied.
    func toggleRegionPortal() {
        withAnimation(.easeInOut(duration: 0.85)) {
            if audienceLens == .clinician {
                selectedClinicianTool = .focus
            }
            regionPortalActive.toggle()
            if regionPortalActive {
                anatomyViewpoint = .free
                anatomyPresentation = .transparent
                cortexOpacity = 0.40
                pointField = .procedure
                lessonPointsVisible = true
                clearPointSelection()
                spatialZoom = 1.36
                orbit = [0.14, 0.08]
                vesselFocusProgress = 1
            } else {
                anatomyViewpoint = .threeQuarter
                anatomyPresentation = .assembled
                cortexOpacity = 0.34
                spatialZoom = 1
                orbit = .zero
                clearPointSelection()
            }
        }
    }

    func selectPoint(entityName: String, label: String) {
        selectedPointEntityName = entityName
        selectedPointLabel = label
        // The secondary reference is an outcome of selecting a teaching point,
        // not a parallel image browser. Exactly one act-matched object appears.
        switch procedureStep {
        case .chooseCase:
            teachingImagingDrawerVisible = false
        case .inspectOcclusion:
            teachingImagingLens = .affectedVessel
            teachingImagingDrawerVisible = true
        case .discussCare:
            teachingImagingLens = .makingRoomPurpose
            teachingImagingDrawerVisible = careViewPermissionGranted
        }
        // A lesson point should reveal motion, not freeze it. Family pause is a
        // separate, reversible control.
        requestedPause = false
    }

    /// A specimen-rail choice locks one authored anatomy marker without
    /// changing scale. Native two-hand magnification remains the only zoom.
    func selectLessonPoint(_ point: StrokeLessonPoint) {
        lessonPointsVisible = true
        regionPortalActive = true
        selectPoint(
            entityName: "\(pointField.entityPrefix)\(point.index)",
            label: point.fullTitle
        )
        if audienceLens == .clinician {
            anatomyPresentation = .transparent
            cortexOpacity = 0.58
            selectedClinicianTool = .focus
        }
    }

    func clearPointSelection() {
        selectedPointEntityName = nil
        selectedPointLabel = nil
        teachingImagingDrawerVisible = false
    }

    func rotateSpatialView(delta: CGSize) {
        anatomyViewpoint = .free
        orbit.x += Float(delta.width) * 0.008
        orbit.y = min(max(orbit.y + Float(delta.height) * 0.006, -0.78), 0.78)
    }

    func setAnatomyViewpoint(_ viewpoint: StrokeAnatomyViewpoint, reduceMotion: Bool = false) {
        anatomyViewpoint = viewpoint
        if reduceMotion {
            orbit = viewpoint.orbit
        } else {
            withAnimation(.easeInOut(duration: 0.42)) {
                orbit = viewpoint.orbit
            }
        }
    }

    func cycleAnatomyViewpoint(reduceMotion: Bool = false) {
        let presets: [StrokeAnatomyViewpoint] = [.anterior, .lateralA, .lateralB, .superior, .threeQuarter]
        let next: StrokeAnatomyViewpoint
        if anatomyViewpoint == .free || anatomyViewpoint == .threeQuarter {
            next = .anterior
        } else if let index = presets.firstIndex(of: anatomyViewpoint) {
            next = presets[(index + 1) % presets.count]
        } else {
            next = .threeQuarter
        }
        setAnatomyViewpoint(next, reduceMotion: reduceMotion)
    }

    func magnifySpatialView(ratio: Double) {
        spatialZoom = min(max(spatialZoom * ratio, 0.72), 1.45)
    }

    func resetSpatialView() {
        spatialZoom = 1
        anatomyViewpoint = .threeQuarter
        orbit = anatomyViewpoint.orbit
    }

    func beginCareDiscussion() {
        procedureStep = .discussCare
        withAnimation(.easeInOut(duration: 0.55)) {
            brainRevealProgress = 0.92
            vesselFocusProgress = 1
        }
    }

    func present(step: StrokeProcedureStep, reduceMotion: Bool = false) {
        if isClinicianScholarSkullInspectionActive && step != procedureStep {
            // The top timeline remains a history control. Leaving the current
            // Scholar inspection restores the normal registered assembly before
            // another teaching act introduces its own cues.
            resetCatalogPresentation()
        }
        requestedPause = false
        clarificationRequested = false
        familyComfortCheck = 1
        familyComfortWasSet = false
        clearQuestionMarker()
        clearPointSelection()
        isConsentPromptVisible = false
        regionPortalActive = false

        switch step {
        case .chooseCase:
            cancelLayerReveal()
            anatomyPresentation = .assembled
            procedureStep = .chooseCase
            withAnimation(.easeInOut(duration: 0.65)) {
                brainRevealProgress = 0
                vesselFocusProgress = 0
                planPreviewProgress = 0
            }
        case .inspectOcclusion:
            cancelLayerReveal()
            anatomyPresentation = .assembled
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
            anatomyPresentation = .transparent
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
                // A gentle transparency reveal. This is a visual study control,
                // not a literal peel, incision, or tissue-removal simulation.
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

    func toggleClinicianToolKit() {
        guard audienceLens == .clinician else { return }
        clinicianToolKitVisible.toggle()
    }

    func selectClinicianTool(_ tool: StrokeClinicianTool) {
        guard audienceLens == .clinician else { return }
        selectedClinicianTool = tool
        switch tool {
        case .focus:
            break
        case .transparency:
            setAnatomyPresentation(.transparent)
        case .layerReveal:
            present(step: .discussCare)
        case .forceps, .cranialDrill:
            // Display-only teaching props until specialist review defines a
            // safe interaction. Selection never cuts or modifies anatomy.
            break
        }
    }

    func reset() {
        cancelLayerReveal()
        procedureStep = .chooseCase
        audienceLens = .family
        resetCatalogPresentation()
        isCaseSelected = false
        spatialPhase = .caseLibrary
        spatialCaseDocked = false
        spatialCaseFilePosition = [-0.58, 1.45, -0.82]
        selectedCaseHistoryMilestone = .reportedChange
        selectedCareDiscussion = nil
        reportIsVisible = false
        requestedPause = false
        narrationEnabled = false
        closingReflectionVisible = false
        clarificationRequested = false
        clearQuestionMarker()
        pointField = .regions
        lessonPointsVisible = true
        teachingImagingDrawerVisible = false
        teachingImagingLens = .affectedVessel
        clinicianToolKitVisible = false
        selectedClinicianTool = .focus
        anatomyPresentation = .assembled
        anatomyViewpoint = .threeQuarter
        environmentMode = .warmHorizon
        cortexOpacity = 0.34
        regionPortalActive = false
        clearPointSelection()
        selectedEvidenceID = StrokeEvidenceSource.library[0].id
        pinnedEvidenceIDs = []
        sourceBoundDraftVisible = false
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
        spatialPhase = .explanation
        spatialCaseDocked = true
        spatialCaseFilePosition = [0, 1.43, -0.82]
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
            anatomyPresentation = .transparent
        }
    }

    func prepareClinicianProof(step: StrokeProcedureStep) {
        prepareProof(step: step)
        audienceLens = .clinician
    }

    func prepareMainOverviewProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        environmentMode = .surroundings
        anatomyPresentation = .transparent
        cortexOpacity = 0.66
        pointField = .regions
        lessonPointsVisible = true
        spatialZoom = 1.28
        clearPointSelection()
    }

    func prepareTeachingImagingProof() {
        prepareMainOverviewProof()
        selectPoint(
            entityName: "clinician-region-point-field-point-0",
            label: "Example affected area"
        )
    }

    func prepareScholarSkullProof() {
        // Orient is the quietest of the three existing acts: no clot-focus or
        // care-purpose cue competes with this reversible technical inspection.
        prepareClinicianProof(step: .chooseCase)
        selectDetailLevel(.scholar)
        selectCatalogAsset(id: Self.scholarSkullCatalogID)
        anatomyPresentation = .assembled
        environmentMode = .surroundings
        spatialZoom = 1.15
    }

    func prepareEvidenceProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        pointField = .procedure
        pinnedEvidenceIDs = Array(StrokeEvidenceSource.library.prefix(2).map(\.id))
        selectedEvidenceID = StrokeEvidenceSource.library[0].id
        sourceBoundDraftVisible = true
    }

    func prepareLayerStudyProof() {
        prepareClinicianProof(step: .discussCare)
        environmentMode = .surroundings
        anatomyPresentation = .exploded
        cortexOpacity = 0.30
        pointField = .regions
        selectedPointEntityName = "clinician-region-point-field-point-0"
        selectedPointLabel = "Example affected area"
    }

    func prepareProcedureFieldProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        environmentMode = .surroundings
        anatomyPresentation = .transparent
        cortexOpacity = 0.40
        regionPortalActive = true
        spatialZoom = 1.24
        pointField = .procedure
        selectedPointEntityName = "clinician-procedure-point-field-point-2"
        selectedPointLabel = "Example blockage"
    }

    func prepareClinicianToolKitProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        clinicianToolKitVisible = true
        selectedClinicianTool = .forceps
    }

    func prepareTransparentLayerProof() {
        prepareClinicianProof(step: .discussCare)
        anatomyPresentation = .transparent
        cortexOpacity = 0.40
        regionPortalActive = true
        spatialZoom = 1.36
        anatomyViewpoint = .free
        orbit = [0.14, 0.08]
        pointField = .procedure
        selectedPointEntityName = "clinician-procedure-point-field-point-2"
        selectedPointLabel = "Illustrative clot focus"
    }

    func prepareAnatomyViewpointProof(_ viewpoint: StrokeAnatomyViewpoint) {
        prepareClinicianProof(step: .inspectOcclusion)
        anatomyPresentation = .transparent
        cortexOpacity = 0.40
        regionPortalActive = true
        spatialZoom = 1.20
        pointField = .regions
        selectedPointEntityName = "clinician-region-point-field-point-0"
        selectedPointLabel = "Example affected area"
        setAnatomyViewpoint(viewpoint)
    }

    func prepareEnvironmentProof(_ mode: StrokeEnvironmentMode) {
        prepareTransparentLayerProof()
        environmentMode = mode
    }

    func prepareSpatialDockedCaseProof() {
        reset()
        audienceLens = .clinician
        spatialPhase = .caseReview
        spatialCaseDocked = true
        spatialCaseFilePosition = [0, 1.43, -0.82]
        isCaseSelected = true
        selectedCaseHistoryMilestone = .reportedChange
        procedureStep = .chooseCase
        brainRevealProgress = 0
        pointField = .regions
    }

    func prepareFamilyQuestionProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        placedQuestion = PlacedStrokeQuestion(
            rootLocalPosition: [0.046, 0.050, 0.105],
            semanticTarget: "affected brain surface"
        )
        questionMarkerVisible = true
        clarificationRequested = true
        requestedPause = true
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
