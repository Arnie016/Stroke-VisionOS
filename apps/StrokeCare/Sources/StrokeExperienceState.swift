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
    case craniotomy = "Access story"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .regions: "brain.head.profile"
        case .procedure: "point.3.connected.trianglepath.dotted"
        case .craniotomy: "circle.dotted.and.circle"
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
        case .craniotomy:
            [
                StrokeLessonPoint(
                    index: 0,
                    shortTitle: "Access",
                    fullTitle: "Generic craniotomy teaching story"
                )
            ]
        }
    }

    var entityPrefix: String {
        switch self {
        case .regions: "clinician-region-point-field-point-"
        case .procedure: "clinician-procedure-point-field-point-"
        case .craniotomy: "clinician-access-point-field-point-"
        }
    }

    var defaultLessonPointIndex: Int {
        switch self {
        case .regions: 0
        case .procedure: 2
        case .craniotomy: 0
        }
    }
}

struct StrokeLessonPoint: Identifiable, Equatable {
    let index: Int
    let shortTitle: String
    let fullTitle: String

    var id: Int { index }
}

/// A family-controlled discovery sequence. These are general orientation
/// concepts, not point-local diagnoses or a labelled patient scan. The current
/// room-scale teaching model remains the spatial hero; the atlas tells the
/// wearer which *reviewed* model view can give useful context next.
enum StrokeFamilyBrainAtlasChapter: Int, CaseIterable, Identifiable {
    case cortex
    case frontalLobe
    case parietalLobe
    case temporalLobe
    case occipitalLobe
    case arterialRoutes
    case corpusCallosum
    case thalamus
    case hippocampus
    case brainstemAndCerebellum

    static let detailCount = 3

    var id: Int { rawValue }
    var ordinal: Int { rawValue + 1 }

    var title: String {
        switch self {
        case .cortex: "Cerebral cortex"
        case .frontalLobe: "Frontal lobe"
        case .parietalLobe: "Parietal lobe"
        case .temporalLobe: "Temporal lobe"
        case .occipitalLobe: "Occipital lobe"
        case .arterialRoutes: "Arterial routes"
        case .corpusCallosum: "Corpus callosum"
        case .thalamus: "Thalamus"
        case .hippocampus: "Hippocampus"
        case .brainstemAndCerebellum: "Brainstem + cerebellum"
        }
    }

    var explanation: String {
        switch self {
        case .cortex:
            "The folded outer layer supports many thinking, sensing, language, and movement functions."
        case .frontalLobe:
            "The front of the brain helps with planning, decision-making, and voluntary movement."
        case .parietalLobe:
            "This area helps combine touch, body, and spatial information."
        case .temporalLobe:
            "This side region helps process sound and contributes to memory and language."
        case .occipitalLobe:
            "This rear region processes visual information."
        case .arterialRoutes:
            "Arteries carry blood toward the brain through branching routes. The motion here is qualitative, not a measurement."
        case .corpusCallosum:
            "A broad bridge of nerve fibres connects the brain’s left and right sides."
        case .thalamus:
            "A deep relay region helps route many sensory signals through the brain."
        case .hippocampus:
            "A deep structure important for forming new memories."
        case .brainstemAndCerebellum:
            "The brainstem links brain and spinal cord; the cerebellum supports balance and coordination."
        }
    }

    var discoveryPrompt: String {
        "Look for the quiet cue beside the generic 3D model. It gives spatial context without labelling a patient scan."
    }

    var conversationPrompt: String {
        "If this matters to your conversation, ask the clinician how this general structure relates to the explanation you are sharing."
    }

    var modelCue: String {
        switch self {
        case .arterialRoutes:
            "MODEL CUE · BLOOD-FLOW POINTS"
        case .cortex, .frontalLobe, .parietalLobe, .temporalLobe, .occipitalLobe:
            "MODEL CUE · OUTER BRAIN + REGIONS"
        case .corpusCallosum, .thalamus, .hippocampus, .brainstemAndCerebellum:
            "NEXT · MAGNIFY FOR THE SEPARATE INSIDE-BRAIN JOURNEY"
        }
    }

    var pointField: StrokePointField {
        self == .arterialRoutes ? .procedure : .regions
    }

    var systemImage: String {
        self == .arterialRoutes ? "point.3.connected.trianglepath.dotted" : "brain.head.profile"
    }
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

/// A presenter-controlled visibility filter for registered teaching anatomy.
/// It changes emphasis only: it never claims patient-specific registration,
/// diagnosis, treatment eligibility, or procedural simulation.
enum StrokeAnatomyFocus: String, CaseIterable, Identifiable, Hashable {
    case whole = "Whole"
    case vessels = "Vessels"
    case internalStructures = "Internal"
    case surfaceContext = "Surface"

    var id: String { rawValue }

    var boundary: String {
        switch self {
        case .whole:
            "Registered teaching assembly · not a patient scan"
        case .vessels:
            "Arterial + venous teaching atlases · colour convention · review pending"
        case .internalStructures:
            "Deep structures + ventricles · generic teaching anatomy · review pending"
        case .surfaceContext:
            "Illustrative scalp cutaway + eye context · approximate cross-source fit · review pending"
        }
    }

    var requiresScholar: Bool {
        self == .internalStructures || self == .surfaceContext
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
    case inferior = "Bottom · model frame"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .free: "View"
        case .threeQuarter: "3/4"
        case .anterior: "Front"
        case .lateralA: "Side A"
        case .lateralB: "Side B"
        case .superior: "Top"
        case .inferior: "Bottom"
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
        case .inferior: "arrow.up.to.line.circle"
        }
    }

    var orbit: SIMD2<Float> {
        switch self {
        case .free, .threeQuarter: .zero
        case .anterior: [0.42, 0]
        case .lateralA: [0.42 - Float.pi * 0.5, 0]
        case .lateralB: [0.42 + Float.pi * 0.5, 0]
        case .superior: [0.42, -Float.pi * 0.5]
        case .inferior: [0.42, Float.pi * 0.5]
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

/// Six clinician-controlled checkpoints nested inside the same three calm
/// teaching acts. They translate Page 2's procedure frames into a non-graphic
/// explanation; they are not an operative workflow or surgical-training SOP.
enum StrokePresenterTeachingBeat: Int, CaseIterable, Identifiable {
    case confirmContext
    case discussAccess
    case protectiveCovering
    case explainPurpose
    case teamChecks
    case explainClosure

    var id: Int { rawValue }
    var number: Int { rawValue + 1 }

    var title: String {
        switch self {
        case .confirmContext: "Orient the case"
        case .discussAccess: "Discuss access"
        case .protectiveCovering: "Protective layer"
        case .explainPurpose: "Explain making room"
        case .teamChecks: "What the team checks"
        case .explainClosure: "Return to whole"
        }
    }

    var shortTitle: String {
        switch self {
        case .confirmContext: "Orient"
        case .discussAccess: "Access"
        case .protectiveCovering: "Covering"
        case .explainPurpose: "Make room"
        case .teamChecks: "Checks"
        case .explainClosure: "Whole again"
        }
    }

    /// One human sentence appears only for the active or gaze-hovered beat.
    /// The detailed technical boundary remains in the presenter's peripheral
    /// cue, keeping this top history control readable at a glance.
    var summary: String {
        switch self {
        case .confirmContext: "Start with the whole teaching model."
        case .discussAccess: "Show where access may be discussed."
        case .protectiveCovering: "Reveal the protective covering gently."
        case .explainPurpose: "Explain why the team may make more room."
        case .teamChecks: "Name what the team continues to watch."
        case .explainClosure: "Bring the teaching layers back together."
        }
    }

    var procedureStep: StrokeProcedureStep {
        switch self {
        case .confirmContext:
            .chooseCase
        case .discussAccess:
            .inspectOcclusion
        case .protectiveCovering, .explainPurpose, .teamChecks, .explainClosure:
            .discussCare
        }
    }

    static func firstBeat(for step: StrokeProcedureStep) -> Self {
        switch step {
        case .chooseCase: .confirmContext
        case .inspectOcclusion: .discussAccess
        case .discussCare: .protectiveCovering
        }
    }

    var next: Self? {
        Self(rawValue: rawValue + 1)
    }

    var previous: Self? {
        Self(rawValue: rawValue - 1)
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
    static let authoredCaseHistoryMilestone: StrokeCaseHistoryMilestone = .reportedChange

    let teachingCase = TeachingStrokeCase.case78

    @Published var procedureStep: StrokeProcedureStep = .chooseCase {
        didSet {
            guard audienceLens == .clinician,
                  presenterTeachingBeat.procedureStep != procedureStep else { return }
            presenterTeachingBeat = .firstBeat(for: procedureStep)
        }
    }
    @Published var audienceLens: StrokeAudienceLens = .family {
        didSet {
            if audienceLens == .clinician {
                // The presenter speaks for themself. Changing role revokes
                // synthesized-narration eligibility at the state boundary.
                narrationEnabled = false
                selectedFamilyQuestion = nil
                presenterTeachingBeat = .firstBeat(for: procedureStep)
                return
            }
            detailLevel = .calm
            anatomyFocus = .whole
            selectedCatalogAssetID = nil
            clinicianToolKitVisible = false
            selectedClinicianTool = .focus
            selectedPresenterKeyPointIndex = nil
        }
    }
    @Published private(set) var detailLevel: StrokeDetailLevel = .calm
    @Published private(set) var selectedCatalogAssetID: String?
    @Published var isCaseSelected = false
    @Published var selectedCareDiscussion: StrokeCareDiscussion?
    @Published var reportIsVisible = false
    @Published var requestedPause = false
    @Published var clarificationRequested = false
    @Published private(set) var familyClarityCheck: Double = 1
    @Published private(set) var familyClarityWasSet = false
    @Published private(set) var selectedFamilyQuestion: String?
    @Published var familyBrainAtlasVisible = false
    @Published private(set) var familyBrainAtlasChapter: StrokeFamilyBrainAtlasChapter = .cortex
    @Published private(set) var familyBrainAtlasDetailIndex = 0
    @Published private(set) var selectedPresenterKeyPointIndex: Int?
    @Published private(set) var presenterTeachingBeat: StrokePresenterTeachingBeat = .confirmContext
    @Published var questionPlacementArmed = false
    @Published var questionMarkerVisible = false
    @Published private(set) var placedQuestion: PlacedStrokeQuestion?
    @Published var soundEnabled = true
    @Published private(set) var narrationEnabled = false
    @Published var closingReflectionVisible = false
    @Published var pointField: StrokePointField = .regions
    @Published var lessonPointsVisible = true
    @Published var teachingImagingDrawerVisible = false
    @Published var teachingImagingLens: StrokeTeachingImagingLens = .affectedVessel
    @Published var clinicianToolKitVisible = false
    @Published var selectedClinicianTool: StrokeClinicianTool = .focus
    @Published var anatomyPresentation: StrokeAnatomyPresentation = .assembled
    @Published private(set) var anatomyFocus: StrokeAnatomyFocus = .whole
    @Published private(set) var availableAnatomyFocuses: Set<StrokeAnatomyFocus> = [.whole]
    @Published private(set) var anatomyAvailabilityResolved = false
    @Published private(set) var anatomyAvailabilityNotice: String?
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
    @Published var selectedCaseHistoryMilestone: StrokeCaseHistoryMilestone =
        StrokeExperienceState.authoredCaseHistoryMilestone
    @Published private(set) var caseReviewRevealProgress: Double = 0
    @Published private(set) var pendingConsentStep: StrokeProcedureStep?
    @Published private(set) var pendingPresenterTeachingBeat: StrokePresenterTeachingBeat?
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
    private var caseReviewRevealTask: Task<Void, Never>?
    private var pendingAnatomyFocus: StrokeAnatomyFocus?

    func selectTeachingCase(reduceMotion: Bool = false) {
        guard audienceLens == .clinician else { return }
        spatialCaseDocked = true
        isCaseSelected = true
        spatialPhase = .caseReview
        selectedCaseHistoryMilestone = Self.authoredCaseHistoryMilestone
        procedureStep = .chooseCase
        startCaseReviewReveal(reduceMotion: reduceMotion)
    }

    func selectCaseHistoryMilestone(
        _ milestone: StrokeCaseHistoryMilestone,
        reduceMotion: Bool = false
    ) {
        guard audienceLens == .clinician, spatialPhase == .caseReview else { return }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.26)) {
            selectedCaseHistoryMilestone = milestone
        }
    }

    /// Detail is a presentation filter, never a fourth teaching act. Family
    /// mode is fixed to calm; a presenter may deliberately opt into more depth.
    func selectDetailLevel(_ level: StrokeDetailLevel) {
        guard audienceLens == .clinician || level == .calm else {
            resetCatalogPresentation()
            return
        }

        detailLevel = level
        if level != .scholar, anatomyFocus.requiresScholar {
            anatomyFocus = .whole
            anatomyPresentation = .assembled
            cortexOpacity = 0.66
        }
        if let selectedCatalogAssetID,
           !visibleCatalogRecords.contains(where: { $0.id == selectedCatalogAssetID }) {
            self.selectedCatalogAssetID = nil
        }
    }

    /// The atlas is explicitly opened by a family member; it does not infer an
    /// information need, anxiety level, or diagnosis. Selecting a chapter
    /// simply turns on the closest reviewed discovery-point family.
    func toggleFamilyBrainAtlas() {
        guard audienceLens == .family, spatialPhase == .explanation else { return }
        familyBrainAtlasVisible.toggle()
    }

    func selectFamilyBrainAtlasChapter(_ chapter: StrokeFamilyBrainAtlasChapter) {
        guard audienceLens == .family, spatialPhase == .explanation else { return }
        familyBrainAtlasChapter = chapter
        familyBrainAtlasDetailIndex = 0
        selectLessonFamily(chapter.pointField)
    }

    /// The arterial Atlas chapter has one deliberate spatial reveal. It starts
    /// with the same quiet discovery field as every other chapter, then a
    /// second pinch can select a generic branching cue to show qualitative
    /// motion and one local reference. This is not a vessel map or a patient
    /// measurement.
    func revealFamilyBrainAtlasModelCue() {
        guard audienceLens == .family, spatialPhase == .explanation else { return }
        let chapter = familyBrainAtlasChapter
        selectFamilyBrainAtlasChapter(chapter)
        guard chapter == .arterialRoutes,
              let branchingCue = StrokePointField.procedure.lessonPoints.first(where: { $0.index == 1 }) else {
            return
        }
        selectLessonPoint(branchingCue)
    }

    func advanceFamilyBrainAtlasChapter(by offset: Int) {
        guard audienceLens == .family, spatialPhase == .explanation else { return }
        let chapters = StrokeFamilyBrainAtlasChapter.allCases
        guard let current = chapters.firstIndex(of: familyBrainAtlasChapter) else { return }
        let next = (current + offset % chapters.count + chapters.count) % chapters.count
        selectFamilyBrainAtlasChapter(chapters[next])
    }

    /// Each Atlas chapter has three short, wearer-controlled beats. This makes
    /// the card an explorable explanation rather than a permanent label wall.
    func advanceFamilyBrainAtlasDetail(by offset: Int) {
        guard audienceLens == .family, spatialPhase == .explanation else { return }
        let count = StrokeFamilyBrainAtlasChapter.detailCount
        familyBrainAtlasDetailIndex = (familyBrainAtlasDetailIndex + offset % count + count) % count
    }

    /// Reveals one registered subsystem at a time without adding a modal or
    /// separating layers. Internal structures remain an explicit Scholar-only
    /// technical view; family mode always returns to the whole assembly.
    func selectAnatomyFocus(_ focus: StrokeAnatomyFocus) {
        guard audienceLens == .clinician, spatialPhase == .explanation else {
            anatomyFocus = .whole
            return
        }
        guard !focus.requiresScholar || detailLevel == .scholar else {
            anatomyFocus = .whole
            return
        }

        guard anatomyAvailabilityResolved else {
            pendingAnatomyFocus = focus
            anatomyAvailabilityNotice = "Checking registered anatomy layers…"
            return
        }
        guard availableAnatomyFocuses.contains(focus) else {
            pendingAnatomyFocus = nil
            anatomyFocus = .whole
            anatomyPresentation = .assembled
            cortexOpacity = 0.66
            anatomyAvailabilityNotice = switch focus {
            case .vessels:
                "Venous reference unavailable · Whole view restored"
            case .internalStructures:
                "Internal references unavailable · Whole view restored"
            case .surfaceContext:
                "Surface context unavailable · Whole view restored"
            case .whole:
                nil
            }
            return
        }

        applyAnatomyFocus(focus)
    }

    /// Receives the actual RealityKit load result. Optional detail failures
    /// stay visible in the presenter UI and can never leave a selected-but-
    /// empty subsystem. Whole always remains available through the complete
    /// procedural teaching fallback.
    func updateAvailableAnatomyFocuses(_ focuses: Set<StrokeAnatomyFocus>) {
        availableAnatomyFocuses = focuses.union([.whole])
        anatomyAvailabilityResolved = true

        if let pendingAnatomyFocus {
            self.pendingAnatomyFocus = nil
            selectAnatomyFocus(pendingAnatomyFocus)
            return
        }

        if !availableAnatomyFocuses.contains(anatomyFocus) {
            let unavailableFocus = anatomyFocus
            anatomyFocus = .whole
            anatomyPresentation = .assembled
            cortexOpacity = 0.66
            anatomyAvailabilityNotice = switch unavailableFocus {
            case .vessels:
                "Venous reference unavailable · Whole view restored"
            case .internalStructures:
                "Internal references unavailable · Whole view restored"
            case .surfaceContext:
                "Surface context unavailable · Whole view restored"
            case .whole:
                nil
            }
        }
    }

    func isAnatomyFocusAvailable(_ focus: StrokeAnatomyFocus) -> Bool {
        focus == .whole || (anatomyAvailabilityResolved && availableAnatomyFocuses.contains(focus))
    }

    var anatomyFocusStatus: String {
        anatomyAvailabilityNotice ?? anatomyFocus.boundary
    }

    private func applyAnatomyFocus(_ focus: StrokeAnatomyFocus) {
        anatomyAvailabilityNotice = nil

        anatomyFocus = focus
        pointField = .regions
        lessonPointsVisible = true
        clearPointSelection()
        switch focus {
        case .whole:
            anatomyPresentation = .assembled
            cortexOpacity = 0.66
        case .vessels:
            anatomyPresentation = .transparent
            cortexOpacity = 0.18
        case .internalStructures:
            anatomyPresentation = .transparent
            cortexOpacity = 0.12
        case .surfaceContext:
            anatomyPresentation = .transparent
            cortexOpacity = 0.20
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
        guard audienceLens == .clinician else { return }
        spatialCaseFilePosition = SIMD3<Float>(
            min(max(position.x, -0.78), 0.32),
            min(max(position.y, 1.18), 1.72),
            min(max(position.z, -1.08), -0.58)
        )
        let overDock = simd_distance(spatialCaseFilePosition, [0, 1.43, -0.82]) < 0.16
        spatialCaseDocked = overDock
        isCaseSelected = overDock
    }

    func settleSpatialCaseFile(reduceMotion: Bool = false) {
        guard audienceLens == .clinician else { return }
        if simd_distance(spatialCaseFilePosition, [0, 1.43, -0.82]) < 0.22 {
            withAnimation(.easeInOut(duration: 0.38)) {
                spatialCaseFilePosition = [0, 1.43, -0.82]
                spatialCaseDocked = true
                isCaseSelected = true
                spatialPhase = .caseReview
                selectedCaseHistoryMilestone = Self.authoredCaseHistoryMilestone
                procedureStep = .chooseCase
                brainRevealProgress = 0
            }
            startCaseReviewReveal(reduceMotion: reduceMotion)
        } else {
            cancelCaseReviewReveal()
            withAnimation(.easeInOut(duration: 0.32)) {
                spatialCaseFilePosition = [-0.58, 1.45, -0.82]
                spatialCaseDocked = false
                isCaseSelected = false
                spatialPhase = .caseLibrary
                procedureStep = .chooseCase
                brainRevealProgress = 0
                caseReviewRevealProgress = 0
            }
        }
    }

    /// The selected dossier becomes a human-scale case anchor before its
    /// history opens. This is authored presentation motion, not a patient-data
    /// inference and not a custom hand-wave recognizer.
    private func startCaseReviewReveal(reduceMotion: Bool) {
        cancelCaseReviewReveal()
        caseReviewRevealProgress = 0
        if reduceMotion {
            caseReviewRevealProgress = 1
            return
        }

        caseReviewRevealTask = Task { [weak self] in
            guard let self else { return }
            let frameCount = 58
            for frame in 1...frameCount {
                guard !Task.isCancelled else { return }
                try? await Task.sleep(for: .milliseconds(16))
                guard !Task.isCancelled else { return }
                let linear = Double(frame) / Double(frameCount)
                self.caseReviewRevealProgress = linear * linear * (3 - 2 * linear)
            }
            self.caseReviewRevealTask = nil
        }
    }

    private func cancelCaseReviewReveal() {
        caseReviewRevealTask?.cancel()
        caseReviewRevealTask = nil
    }

    /// The patient file is a threshold, not persistent furniture. The case room
    /// disappears before anatomy appears, preserving one clear spatial task.
    func beginExplanation() {
        guard audienceLens == .clinician,
              spatialPhase == .caseReview,
              spatialCaseDocked,
              isCaseSelected else { return }
        spatialPhase = .explanation
        clearPointSelection()
        procedureStep = .chooseCase
        presenterTeachingBeat = .confirmContext
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
        familyBrainAtlasVisible = false
        familyBrainAtlasChapter = .cortex
        familyBrainAtlasDetailIndex = 0
        withAnimation(.easeInOut(duration: 0.72)) {
            brainRevealProgress = 0.18
            vesselFocusProgress = 0
        }
    }

    func returnCaseToLibrary() {
        guard audienceLens == .clinician else { return }
        cancelCaseReviewReveal()
        spatialPhase = .caseLibrary
        teachingImagingDrawerVisible = false
        spatialCaseDocked = false
        isCaseSelected = false
        spatialCaseFilePosition = [-0.58, 1.45, -0.82]
        selectedCaseHistoryMilestone = Self.authoredCaseHistoryMilestone
        caseReviewRevealProgress = 0
        presenterTeachingBeat = .confirmContext
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
        if field == .procedure || field == .craniotomy {
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
        guard spatialPhase == .explanation,
              selectedPointEntityName != nil else {
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
        guard spatialPhase == .explanation,
              selectedPointEntityName != nil else {
            teachingImagingDrawerVisible = false
            return
        }
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
            if audienceLens == .clinician {
                returnCaseToLibrary()
            } else {
                // The lay route deliberately bypasses fictional case files.
                // Restart the same generic exhibit instead of revealing the
                // doctor-only archive after the closing reflection.
                reset()
                beginPatientExploration()
            }
            return
        }
        if audienceLens == .clinician, spatialPhase == .explanation {
            if let nextBeat = presenterTeachingBeat.next {
                selectPresenterTeachingBeat(nextBeat)
            } else {
                requestedPause = false
                closingReflectionVisible = true
            }
            return
        }
        requestedPause = false
        selectedFamilyQuestion = nil
        selectedPresenterKeyPointIndex = nil
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
        let requestedBeat = pendingPresenterTeachingBeat
        pendingConsentStep = nil
        pendingPresenterTeachingBeat = nil
        if let requestedBeat {
            selectPresenterTeachingBeat(requestedBeat, reduceMotion: reduceMotion)
        } else if requestedStep == .discussCare {
            present(step: .discussCare, reduceMotion: reduceMotion)
        } else {
            advanceJourney()
        }
    }

    func declineCareView() {
        isConsentPromptVisible = false
        pendingConsentStep = nil
        pendingPresenterTeachingBeat = nil
        requestedPause = true
    }

    func retreatJourney() {
        if audienceLens == .clinician,
           spatialPhase == .explanation,
           let previousBeat = presenterTeachingBeat.previous {
            selectPresenterTeachingBeat(previousBeat)
            return
        }
        requestedPause = false
        selectedFamilyQuestion = nil
        selectedPresenterKeyPointIndex = nil
        presenterTeachingBeat = .confirmContext
        isConsentPromptVisible = false
        pendingConsentStep = nil
        pendingPresenterTeachingBeat = nil
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

    /// Narration is an opt-in family teaching aid. Doctor-presenter mode has
    /// no synthesized voice because the clinician is already speaking.
    func setNarrationEnabled(_ enabled: Bool) {
        guard audienceLens == .family else {
            narrationEnabled = false
            return
        }
        narrationEnabled = enabled
    }

    /// Explicit family feedback replaces any attempt to infer anxiety from
    /// face, voice, gaze, or physiology. It pauses the story and gives the
    /// clinician a calm clarification cue.
    func requestClarification() {
        clarificationRequested = true
        requestedPause = true
    }

    /// A family member explicitly reports how clear the current explanation
    /// feels. This is not an anxiety score and is never inferred from gaze,
    /// voice, face, physiology, diagnosis, or patient data.
    func setFamilyClarityCheck(_ value: Double) {
        familyClarityCheck = min(max(value, 0), 2)
        familyClarityWasSet = true
        if let selectedFamilyQuestion,
           !familyQuestionSuggestions.contains(selectedFamilyQuestion) {
            self.selectedFamilyQuestion = nil
        }
        if familyClarityCheck < 0.5 {
            requestClarification()
        }
    }

    /// Suggestions are a finite, authored question set. Choosing one merely
    /// marks it and pauses the current lesson; it never calls a medical model.
    func selectFamilyQuestion(_ question: String) {
        guard audienceLens == .family,
              familyQuestionSuggestions.contains(question) else { return }
        selectedFamilyQuestion = question
        clarificationRequested = true
        requestedPause = true
    }

    /// Technical prompts expand into one authored plain-language sentence.
    /// There is intentionally no runtime-generated paraphrase in this path.
    func selectPresenterKeyPoint(_ index: Int) {
        guard audienceLens == .clinician,
              presenterTimelineKeyPoints.indices.contains(index),
              presenterPlainLanguagePoints.indices.contains(index) else { return }
        selectedPresenterKeyPointIndex = selectedPresenterKeyPointIndex == index ? nil : index
    }

    /// Directly revisits one authored presenter checkpoint. The six beats are
    /// nested inside the same three acts, so all existing anatomy, consent,
    /// and non-graphic boundaries remain authoritative.
    func selectPresenterTeachingBeat(
        _ beat: StrokePresenterTeachingBeat,
        reduceMotion: Bool = false
    ) {
        guard audienceLens == .clinician, spatialPhase == .explanation else { return }

        let preservedAccessSelection: (entityName: String, label: String)? = {
            guard let entityName = selectedPointEntityName,
                  entityName.hasPrefix("clinician-access-point-field-point-"),
                  let label = selectedPointLabel else { return nil }
            return (entityName, label)
        }()
        if beat.procedureStep == .discussCare, !careViewPermissionGranted {
            pendingPresenterTeachingBeat = beat
            present(step: .discussCare, reduceMotion: reduceMotion)
            configurePresenterPointField(for: beat, preserving: preservedAccessSelection)
            return
        }

        pendingPresenterTeachingBeat = nil
        present(step: beat.procedureStep, reduceMotion: reduceMotion)
        guard procedureStep == beat.procedureStep else { return }
        presenterTeachingBeat = beat
        configurePresenterPointField(for: beat, preserving: preservedAccessSelection)
        if beat == .explainClosure {
            cancelLayerReveal()
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.55)) {
                anatomyPresentation = .assembled
                brainRevealProgress = 0.28
            }
        }
    }

    /// Each presenter checkpoint owns its own discovery state. In particular,
    /// the single generic access invitation appears only at Access; it never
    /// persists as a misleading skull dot through the covering, purpose,
    /// checks, or closure discussions.
    private func configurePresenterPointField(
        for beat: StrokePresenterTeachingBeat,
        preserving selection: (entityName: String, label: String)?
    ) {
        switch beat {
        case .confirmContext:
            pointField = .regions
            lessonPointsVisible = true
            clearPointSelection()
        case .discussAccess:
            activatePresenterAccessStory(preserving: selection)
        case .protectiveCovering, .explainPurpose, .teamChecks, .explainClosure:
            lessonPointsVisible = false
            clearPointSelection()
        }
    }

    /// The top Access checkpoint is the authoritative way into the bounded
    /// craniotomy teaching story. It reveals one quiet, anatomy-referenced
    /// invitation; only a deliberate pinch opens its local explanation.
    private func activatePresenterAccessStory(
        preserving selection: (entityName: String, label: String)?
    ) {
        selectDetailLevel(.scholar)
        pointField = .craniotomy
        lessonPointsVisible = true
        if let selection {
            selectedPointEntityName = selection.entityName
            selectedPointLabel = selection.label
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
        if familyClarityWasSet, familyClarityCheck < 0.5 {
            return switch procedureStep {
            case .chooseCase:
                ["Can we start with the whole brain again?", "Where is the affected area?", "What do we know for sure?"]
            case .inspectOcclusion:
                ["Can you show the blockage again?", "Which change is pressure?", "What remains uncertain?"]
            case .discussCare:
                ["Can you show the purpose again?", "What can this change?", "What can this not change?"]
            }
        }
        if familyClarityWasSet, familyClarityCheck < 1.5 {
            return switch procedureStep {
            case .chooseCase:
                ["Can you point to the affected side?", "Which layer am I seeing?", "Is this a teaching model?"]
            case .inspectOcclusion:
                ["Can we compare blockage and swelling?", "Why is space limited?", "Can we pause here?"]
            case .discussCare:
                ["Where is more room being made?", "What will the team check?", "What remains uncertain?"]
            }
        }
        return switch procedureStep {
        case .chooseCase:
            [familyTimelineQuestion, "Can you show where this is?", "What do we know for sure?"]
        case .inspectOcclusion:
            [familyTimelineQuestion, "Can we pause at the blockage?", "What remains uncertain?"]
        case .discussCare:
            [familyTimelineQuestion, "What is the goal?", "What can this not change?"]
        }
    }

    /// A selected family question opens one bounded clarification card in the
    /// shared scene. These sentences are authored teaching language, never a
    /// generated diagnosis, treatment recommendation, or patient-specific
    /// prediction.
    var selectedFamilyQuestionAnswer: String? {
        guard let question = selectedFamilyQuestion else { return nil }
        let lowercasedQuestion = question.lowercased()

        switch procedureStep {
        case .chooseCase:
            if lowercasedQuestion.contains("teaching model") || lowercasedQuestion.contains("know for sure") {
                return "This is generic teaching anatomy. It helps explain the conversation; it is not a personal scan or a conclusion about one person."
            }
            return "We can begin with the whole brain, then use one quiet point to show the area being discussed."

        case .inspectOcclusion:
            if lowercasedQuestion.contains("pressure") || lowercasedQuestion.contains("space") {
                return "The skull is a fixed space. This teaching view keeps blocked flow, affected tissue, and pressure as separate ideas."
            }
            if lowercasedQuestion.contains("uncertain") {
                return "This exhibit can explain terms and questions. It does not decide an individual diagnosis or what will happen next."
            }
            return "The highlighted vessel is a teaching cue for interrupted flow. We can pause here and compare it with the surrounding brain."

        case .discussCare:
            if lowercasedQuestion.contains("not change") || lowercasedQuestion.contains("uncertain") {
                return "The purpose shown is making more room when pressure is a concern. It is not a promise of recovery or a prediction of outcome."
            }
            return "This is a non-graphic explanation of why a team may discuss creating more room and what they continue to monitor."
        }
    }

    var familyClarityLabel: String {
        guard familyClarityWasSet else { return "Not shared" }
        if familyClarityCheck < 0.5 { return "Please explain again" }
        if familyClarityCheck < 1.5 { return "Still unsure" }
        return "Clear enough to continue"
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

        if detailLevel == .calm {
            return switch presenterTeachingBeat {
            case .confirmContext: ["Teaching model", "Whole brain first", "Not a patient scan"]
            case .discussAccess: ["Show the blockage", "Name each change", "Pause for questions"]
            case .protectiveCovering: ["Ask before reveal", "Protective layer", "Concept only"]
            case .explainPurpose: ["Ask before reveal", "More room", "Not repaired tissue"]
            case .teamChecks: ["What the team checks", "Imaging may guide", "No result shown"]
            case .explainClosure: ["Bring layers together", "No graphic detail", "Invite questions"]
            }
        }

        if detailLevel == .scholar {
            return switch presenterTeachingBeat {
            case .confirmContext: ["Generic registered-v2 assembly", "Cortex before subsystems", "Registration review pending"]
            case .discussAccess: ["Occlusion, injury, pressure", "Keep causal claims bounded", "No prognosis inferred"]
            case .protectiveCovering: ["Permission before separation", "Conceptual dura reference", "No operative technique"]
            case .explainPurpose: ["Permission before separation", "Decompression concept", "No outcome promise"]
            case .teamChecks: ["Pressure and bleeding checks", "Imaging and monitoring", "No pass/fail result"]
            case .explainClosure: ["Return authored layers", "No fixation simulation", "Restate model limits"]
            }
        }

        return switch presenterTeachingBeat {
        case .confirmContext:
            ["Generic scenario", "Whole brain first", "Not a patient scan"]
        case .discussAccess:
            ["Blockage → injury → swelling", "Keep them distinct", "No prognosis inferred"]
        case .protectiveCovering:
            ["Ask before transparency", "Dura is protective", "Conceptual layer only"]
        case .explainPurpose:
            ["Ask before transparency", "Room, not repair", "No outcome promise"]
        case .teamChecks:
            ["Pressure and bleeding", "Imaging and monitoring", "No pass/fail result"]
        case .explainClosure:
            ["Return layers together", "No suturing shown", "End with questions"]
        }
    }

    /// One concise, authored lay explanation for each technical pointer.
    var presenterPlainLanguagePoints: [String] {
        if isClinicianScholarSkullInspectionActive {
            return [
                "This skull is a generic teaching reference from multiple sources.",
                "Use it only to discuss shape and relative position.",
                "A specialist still needs to review this anatomy.",
            ]
        }

        if detailLevel == .calm {
            return switch presenterTeachingBeat {
            case .confirmContext: [
                "This is a general teaching model.",
                "We will begin with the whole brain.",
                "It is not the person's scan.",
            ]
            case .discussAccess: [
                "This marker opens a calm explanation of the affected area.",
                "We will name the blockage, injury, and pressure separately.",
                "Please stop me whenever something is unclear.",
            ]
            case .protectiveCovering: [
                "I will ask before showing the next layer.",
                "This layer protects the brain.",
                "The motion explains an idea, not an operation.",
            ]
            case .explainPurpose: [
                "I will ask before showing deeper layers.",
                "This view explains making more room.",
                "It does not show injured tissue becoming repaired.",
            ]
            case .teamChecks: [
                "This is what the clinical team may check.",
                "Imaging can help the team reassess.",
                "The app is not reporting a result.",
            ]
            case .explainClosure: [
                "The teaching layers come back together.",
                "Graphic closure details are not shown.",
                "We can return to any question.",
            ]
            }
        }

        if detailLevel == .scholar {
            return switch presenterTeachingBeat {
            case .confirmContext: [
                "This generic assembly uses registered-v2 source layers pending specialist review.",
                "Establish cortex orientation before isolating vascular or internal subsystems.",
                "Do not describe this model as patient-specific imaging.",
            ]
            case .discussAccess: [
                "Keep arterial occlusion, ischemic injury, and pressure effects conceptually distinct.",
                "Use the authored access cue only as a teaching reference.",
                "Do not infer prognosis, eligibility, or a patient-specific access site.",
            ]
            case .protectiveCovering: [
                "Obtain permission before separating the conceptual dura reference.",
                "The dura cue communicates a protective boundary, not tissue mechanics.",
                "No operative opening or instrument technique is simulated.",
            ]
            case .explainPurpose: [
                "Obtain permission before revealing the decompression concept.",
                "The authored separation communicates additional room within a fixed boundary.",
                "The model does not promise reversal of established injury.",
            ]
            case .teamChecks: [
                "The team may reassess pressure, bleeding, imaging, and monitoring information.",
                "These references support communication, not automated decision-making.",
                "No measurement, pass/fail result, or clinical validation is implied.",
            ]
            case .explainClosure: [
                "Return the authored layers to the assembled teaching state.",
                "Do not represent suturing, fixation, or closure mechanics.",
                "Restate the generic-model and review-pending boundaries.",
            ]
            }
        }

        return switch presenterTeachingBeat {
        case .confirmContext:
            [
                "This is a teaching example, not the person's scan.",
                "Start with the whole brain before moving closer.",
                "The anatomy explains the idea, not an individual diagnosis.",
            ]
        case .discussAccess:
            [
                "The blockage, tissue injury, and swelling are different changes.",
                "Point to each change separately before connecting them.",
                "This model does not predict what will happen.",
            ]
        case .protectiveCovering:
            [
                "Ask before making the protective covering transparent.",
                "The dura is shown as a protective layer around the brain.",
                "This is a conceptual view, not an operative opening.",
            ]
        case .explainPurpose:
            [
                "Ask permission before revealing deeper layers.",
                "The goal shown is more room, not repaired tissue.",
                "This view does not promise an outcome.",
            ]
        case .teamChecks:
            [
                "The clinical team may check pressure and bleeding.",
                "Imaging and monitoring help the team reassess the situation.",
                "This teaching view does not report a result.",
            ]
        case .explainClosure:
            [
                "The model returns the teaching layers to an assembled view.",
                "It does not demonstrate stitches, plates, or fixation.",
                "Finish with the family's questions and the limits of the model.",
            ]
        }
    }

    var journeyCaption: String {
        // Family presentation adapts only after an explicit, reversible
        // self-report. It never infers emotion, comprehension, or health from
        // a face, voice, physiology, or patient record.
        if audienceLens == .family, familyClarityWasSet {
            if familyClarityCheck < 0.5 {
                return switch procedureStep {
                case .chooseCase:
                    "Let’s start with the whole brain. This teaching model shows a blocked blood vessel on one side."
                case .inspectOcclusion:
                    "Let’s slow down. The blockage, the affected tissue, and swelling are three different things."
                case .discussCare:
                    "This view explains making more room. It does not show the brain being repaired."
                }
            }
            if familyClarityCheck < 1.5 {
                return switch procedureStep {
                case .chooseCase:
                    "This teaching model shows a stroke-related blockage on one side of the brain."
                case .inspectOcclusion:
                    "The blockage can reduce blood flow, while swelling can build inside the fixed skull."
                case .discussCare:
                    "The purpose shown is creating more room for swelling, not undoing existing injury."
                }
            }
        }
        return switch procedureStep {
        case .chooseCase:
            "This model shows one severe stroke affecting one side of the brain."
        case .inspectOcclusion:
            "In this severe stroke, swelling builds inside the fixed skull."
        case .discussCare:
            "Surgery can make room for swelling. It cannot undo the stroke injury."
        }
    }

    var journeyIntent: String {
        if audienceLens == .family, familyClarityWasSet {
            if familyClarityCheck < 0.5 {
                return "Pause, ask a question, or return to the whole brain at any time."
            }
            if familyClarityCheck < 1.5 {
                return "One change at a time: location, blockage, then pressure."
            }
        }
        return switch procedureStep {
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
            return "Flow overlay + authored markers · qualitative · not CFD"
        }
        if anatomyPresentation == .transparent,
           audienceLens == .clinician,
           detailLevel >= .guided {
            return "Cortex · vessels · separated skull reference"
        }
        if anatomyPresentation == .transparent {
            return "Cortex · vessels · selected teaching reference"
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
        if closingReflectionVisible {
            return audienceLens == .family ? "Restart exhibit" : "Return to cases"
        }
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
        if pointField == .craniotomy {
            // The access point opens the six-checkpoint clinician story rather
            // than the generic vessel miniature. The point stays attached to
            // the authored access region while the top timeline changes only
            // reversible presentation states.
            teachingImagingDrawerVisible = false
            requestedPause = false
            if audienceLens == .clinician {
                if presenterTeachingBeat == .confirmContext {
                    selectPresenterTeachingBeat(.discussAccess)
                }
                clinicianToolKitVisible = true
            }
            // `selectPresenterTeachingBeat` intentionally clears a stale point
            // while it changes acts. Store this deliberate selection after the
            // act transition so the anatomy-attached access marker remains the
            // source of the teaching story.
            selectedPointEntityName = entityName
            selectedPointLabel = label
            return
        }

        let isFlowPoint = entityName.hasPrefix(StrokePointField.procedure.entityPrefix)
        if isFlowPoint {
            // Selecting a flow cue is the explicit close-up path. Move the
            // complete registered teaching assembly closer as one object via
            // the existing root scale; never offset an artery, clot, marker,
            // or other authored layer out of its registered frame. The wearer
            // can continue magnifying toward the separate interior threshold.
            let isBlockagePoint = entityName == "\(StrokePointField.procedure.entityPrefix)2"
            withAnimation(.easeInOut(duration: 0.58)) {
                regionPortalActive = true
                anatomyViewpoint = .free
                anatomyPresentation = .transparent
                cortexOpacity = 0.16
                vesselFocusProgress = 1
                spatialZoom = max(spatialZoom, isBlockagePoint ? 2.05 : 1.58)
                if isBlockagePoint {
                    orbit = [0.12, 0.06]
                }
            }
        }
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
        let presets: [StrokeAnatomyViewpoint] = [
            .anterior, .lateralA, .lateralB, .superior, .inferior, .threeQuarter
        ]
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
        // A wide but finite numerical envelope supports tabletop, life-size,
        // and room-scale inspection. The app never teleports on scale alone;
        // a future interior-brain experience can use the explicit threshold.
        spatialZoom = min(max(spatialZoom * ratio, 0.18), 8.0)
    }

    var isInteriorPortalAvailable: Bool { spatialZoom >= 3.2 }

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
        familyClarityCheck = 1
        familyClarityWasSet = false
        selectedFamilyQuestion = nil
        selectedPresenterKeyPointIndex = nil
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
        cancelCaseReviewReveal()
        procedureStep = .chooseCase
        audienceLens = .family
        presenterTeachingBeat = .confirmContext
        resetCatalogPresentation()
        isCaseSelected = false
        spatialPhase = .caseLibrary
        spatialCaseDocked = false
        spatialCaseFilePosition = [-0.58, 1.45, -0.82]
        selectedCaseHistoryMilestone = .reportedChange
        caseReviewRevealProgress = 0
        selectedCareDiscussion = nil
        reportIsVisible = false
        requestedPause = false
        narrationEnabled = false
        closingReflectionVisible = false
        clarificationRequested = false
        familyClarityCheck = 1
        familyClarityWasSet = false
        selectedFamilyQuestion = nil
        familyBrainAtlasVisible = false
        familyBrainAtlasChapter = .cortex
        familyBrainAtlasDetailIndex = 0
        selectedPresenterKeyPointIndex = nil
        clearQuestionMarker()
        pointField = .regions
        lessonPointsVisible = true
        teachingImagingDrawerVisible = false
        teachingImagingLens = .affectedVessel
        clinicianToolKitVisible = false
        selectedClinicianTool = .focus
        anatomyPresentation = .assembled
        anatomyFocus = .whole
        pendingAnatomyFocus = nil
        anatomyAvailabilityNotice = nil
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
        pendingPresenterTeachingBeat = nil
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

    func prepareFamilyPressureStoryProof() {
        prepareProof(step: .inspectOcclusion)
        environmentMode = .surroundings
        pointField = .regions
        lessonPointsVisible = true
        spatialZoom = 1.24
        clearPointSelection()
    }

    func prepareFamilyBrainAtlasProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        spatialZoom = 1.22
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.arterialRoutes)
        advanceFamilyBrainAtlasDetail(by: 1)
    }

    /// Deterministic proof that the arterial Atlas can lead to one
    /// anatomy-attached 3D qualitative-flow reference without exposing a
    /// permanent label cloud or a patient-specific vessel map.
    func prepareFamilyArterialAtlasFlowProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.arterialRoutes)
        revealFamilyBrainAtlasModelCue()
    }

    func prepareClinicianPressureStoryProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        environmentMode = .surroundings
        anatomyPresentation = .transparent
        cortexOpacity = 0.58
        pointField = .regions
        lessonPointsVisible = true
        spatialZoom = 1.24
        clearPointSelection()
    }

    func prepareFamilyMakeSpacePurposeProof() {
        prepareProof(step: .discussCare)
        environmentMode = .surroundings
        pointField = .regions
        lessonPointsVisible = true
        spatialZoom = 1.24
        clearPointSelection()
    }

    func prepareClinicianSixBeatTimelineProof() {
        prepareClinicianProof(step: .discussCare)
        environmentMode = .surroundings
        selectDetailLevel(.guided)
        pointField = .regions
        lessonPointsVisible = true
        clearPointSelection()
        selectPresenterTeachingBeat(.teamChecks, reduceMotion: true)
        spatialZoom = 1.18
    }

    func prepareClinicianProtectiveCoveringProof() {
        prepareClinicianProof(step: .discussCare)
        environmentMode = .surroundings
        selectDetailLevel(.guided)
        pointField = .regions
        lessonPointsVisible = true
        clearPointSelection()
        selectPresenterTeachingBeat(.protectiveCovering, reduceMotion: true)
        spatialZoom = 1.28
    }

    func prepareClinicianCraniotomyStoryProof() {
        prepareClinicianProof(step: .discussCare)
        environmentMode = .surroundings
        selectDetailLevel(.scholar)
        pointField = .craniotomy
        lessonPointsVisible = true
        careViewPermissionGranted = true
        selectPresenterTeachingBeat(.explainPurpose, reduceMotion: true)
        selectedPointEntityName = "clinician-access-point-field-point-0"
        selectedPointLabel = "Generic craniotomy teaching story"
        selectedClinicianTool = .cranialDrill
        clinicianToolKitVisible = true
        anatomyPresentation = .transparent
        cortexOpacity = 0.58
        setAnatomyViewpoint(.lateralA, reduceMotion: true)
        spatialZoom = 1.12
    }

    func prepareClinicianLayerHierarchyProof() {
        prepareMainOverviewProof()
        // Scholar keeps the generic registered-v2 venous reference visible and
        // also proves the peripheral reference hierarchy. This remains a
        // presenter-only composition, not a patient scan or flow state.
        selectDetailLevel(.scholar)
    }

    func prepareAnatomyInternalFocusProof() {
        prepareMainOverviewProof()
        selectDetailLevel(.scholar)
        selectAnatomyFocus(.internalStructures)
        spatialZoom = 1.30
    }

    func prepareAnatomyVesselsFocusProof() {
        prepareMainOverviewProof()
        selectDetailLevel(.scholar)
        selectAnatomyFocus(.vessels)
        spatialZoom = 1.30
    }

    func prepareAnatomySurfaceFocusProof() {
        prepareMainOverviewProof()
        selectDetailLevel(.scholar)
        selectAnatomyFocus(.surfaceContext)
        spatialZoom = 1.24
    }

    func prepareTeachingImagingProof() {
        prepareMainOverviewProof()
        selectPoint(
            entityName: "clinician-region-point-field-point-0",
            label: "Example affected area"
        )
    }

    /// Family-specific receipt for the same point -> spatial teaching object
    /// relationship. This deliberately avoids clinician rails and makes no
    /// claim that the point or the vessel map is a patient image.
    func prepareFamilyTeachingReferenceProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        pointField = .regions
        lessonPointsVisible = true
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

    /// Deterministic family-scale receipt for the explicit handoff into the
    /// separately installed Inside the Flow experience. This is a teaching
    /// viewpoint at room scale, never a claim that a person has entered an
    /// individual patient's brain or vessel.
    func prepareInteriorHandoffProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        anatomyPresentation = .transparent
        cortexOpacity = 0.16
        pointField = .procedure
        lessonPointsVisible = true
        regionPortalActive = true
        spatialZoom = 3.2
        selectedPointEntityName = "\(StrokePointField.procedure.entityPrefix)2"
        selectedPointLabel = "Illustrative blockage focus"
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
        environmentMode = .surroundings
        spatialPhase = .caseReview
        spatialCaseDocked = true
        spatialCaseFilePosition = [0, 1.43, -0.82]
        isCaseSelected = true
        selectedCaseHistoryMilestone = .reportedChange
        caseReviewRevealProgress = 1
        procedureStep = .chooseCase
        brainRevealProgress = 0
        pointField = .regions
    }

    /// Current deterministic case-unfold proof. Unlike the retired window
    /// mock, this state drives the room-scale dossier-to-history composition.
    func prepareCaseHistoryWebProof() {
        prepareSpatialDockedCaseProof()
        selectedCaseHistoryMilestone = .teamReview
        caseReviewRevealProgress = 1
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

    func prepareFamilyClarityProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        setFamilyClarityCheck(1)
        if familyQuestionSuggestions.indices.contains(1) {
            selectFamilyQuestion(familyQuestionSuggestions[1])
        }
    }

    func preparePresenterPlainLanguageProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        setFamilyClarityCheck(1)
        selectPresenterKeyPoint(0)
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
