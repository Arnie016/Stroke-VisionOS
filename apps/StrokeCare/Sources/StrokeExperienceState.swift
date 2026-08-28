import Foundation
import OSLog
import SwiftUI
import UIKit

/// Opt-in Simulator diagnostics for control delivery, not user telemetry.
/// Fixed event names only: no image data, filenames, gaze or hand positions.
@MainActor
enum StrokeImagingInteractionTrace {
    enum Event: String {
        case ready = "READY"
        case focusButton = "BUTTON_FOCUS"
        case backButton = "BUTTON_BACK"
        case focusRejected = "STATE_FOCUS_REJECTED"
        case focused = "STATE_FOCUSED"
        case placed = "STATE_PLACED"
        case returned = "STATE_RETURNED"
        case sceneFocused = "SCENE_FOCUSED"
        case scenePlaced = "SCENE_PLACED"
        case sceneHidden = "SCENE_HIDDEN"
    }

#if DEBUG && targetEnvironment(simulator)
    private static let logger = Logger(subsystem: "com.arnav.StrokeTime", category: "ImagingInteraction")
    private static var lastSceneEvent: Event?
#endif

    static func record(_ event: Event) {
#if DEBUG && targetEnvironment(simulator)
        guard ProcessInfo.processInfo.environment["STROKE_TRACE_IMAGING"] == "1" else { return }
        logger.notice("IMAGING_INTERACTION=\(event.rawValue, privacy: .public)")
#endif
    }

    static func sceneApplied(focused: Bool, visible: Bool) {
#if DEBUG && targetEnvironment(simulator)
        let event: Event = !visible ? .sceneHidden : (focused ? .sceneFocused : .scenePlaced)
        guard event != lastSceneEvent else { return }
        lastSceneEvent = event
        record(event)
#endif
    }
}

extension View {
    /// Applies system-managed semantic feedback where visionOS exposes it.
    /// The app's visible labels, selected state, and motion remain the full
    /// interaction contract on the visionOS 2 baseline and on any system that
    /// disables feedback, so this never becomes the sole source of meaning.
    @ViewBuilder
    func strokeSemanticSelectionFeedback(trigger: Int) -> some View {
        if #available(visionOS 26.0, *) {
            sensoryFeedback(.selection, trigger: trigger)
        } else {
            self
        }
    }
}

enum StrokeAudienceLens: String, CaseIterable, Identifiable {
    case family = "Curious learner"
    case clinician = "Doctor presenter"

    var id: String { rawValue }
}

enum StrokeSpatialPhase: String {
    case caseLibrary
    case caseReview
    case explanation
}

/// A presenter-declared description of a local raster. The app never derives
/// this value from pixels, filenames, anatomy, or patient information.
enum StrokeImagingModality: String, CaseIterable, Identifiable {
    case unspecified = "Unspecified"
    case ct = "CT"
    case cta = "CTA"
    case mri = "MRI"
    case mra = "MRA"
    case pet = "PET"
    case radiograph = "X-ray"
    case other = "Other"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .unspecified: "questionmark.square.dashed"
        case .ct: "circle.grid.cross"
        case .cta: "point.3.connected.trianglepath.dotted"
        case .mri: "waveform.path.ecg.rectangle"
        case .mra: "waveform.path.ecg.rectangle"
        case .pet: "atom"
        case .radiograph: "rays"
        case .other: "photo"
        }
    }
}

/// Authored, fictional intake records for learning and presentation rehearsal.
/// They contain no patient data and do not infer a diagnosis or treatment.
struct StrokeFictionalCase: Identifiable, Equatable {
    let id: String
    let displayName: String
    let ageBand: String
    let lead: String
    let context: String
    let elapsed: String
    let systemImage: String

    /// Original, generated fictional portrait art. The mapping is deliberately
    /// authored rather than inferred from a name, age, symptom, or identity.
    var portraitAssetName: String {
        switch id {
        case "F-078": "FictionalCasePortrait06"
        case "F-104": "FictionalCasePortrait05"
        case "F-116": "FictionalCasePortrait07"
        case "F-121": "FictionalCasePortrait04"
        case "F-133": "FictionalCasePortrait01"
        case "F-147": "FictionalCasePortrait02"
        case "F-152": "FictionalCasePortrait10"
        case "F-168": "FictionalCasePortrait08"
        case "F-174": "FictionalCasePortrait12"
        case "F-181": "FictionalCasePortrait11"
        case "F-196": "FictionalCasePortrait03"
        default: "FictionalCasePortrait09"
        }
    }

    static let library: [StrokeFictionalCase] = [
        .init(id: "F-078", displayName: "Aisha K.", ageBand: "Adult", lead: "Speech changed", context: "Arm felt weak", elapsed: "70 min", systemImage: "waveform"),
        .init(id: "F-104", displayName: "Michael T.", ageBand: "Older adult", lead: "Face felt uneven", context: "Speech less clear", elapsed: "35 min", systemImage: "face.smiling"),
        .init(id: "F-116", displayName: "David L.", ageBand: "Adult", lead: "Vision changed", context: "Balance felt different", elapsed: "50 min", systemImage: "eye"),
        .init(id: "F-121", displayName: "Mei R.", ageBand: "Older adult", lead: "One hand felt weak", context: "Family noticed change", elapsed: "25 min", systemImage: "hand.raised"),
        .init(id: "F-133", displayName: "Jonah P.", ageBand: "Adult", lead: "Sudden confusion", context: "Words were difficult", elapsed: "45 min", systemImage: "text.bubble"),
        .init(id: "F-147", displayName: "Sofia N.", ageBand: "Adult", lead: "Severe head pain", context: "Nausea was reported", elapsed: "30 min", systemImage: "bolt.head.profile"),
        .init(id: "F-152", displayName: "Harun S.", ageBand: "Older adult", lead: "Walking changed", context: "Dizziness was reported", elapsed: "60 min", systemImage: "figure.walk"),
        .init(id: "F-168", displayName: "Elena V.", ageBand: "Adult", lead: "One side felt numb", context: "Symptoms were sudden", elapsed: "40 min", systemImage: "hand.point.up.left"),
        .init(id: "F-174", displayName: "Noah C.", ageBand: "Young adult", lead: "Vision briefly dimmed", context: "Headache followed", elapsed: "55 min", systemImage: "eye.trianglebadge.exclamationmark"),
        .init(id: "F-181", displayName: "Priya M.", ageBand: "Adult", lead: "Speech slowed", context: "Grip felt different", elapsed: "20 min", systemImage: "quote.bubble"),
        .init(id: "F-196", displayName: "Omar J.", ageBand: "Older adult", lead: "Balance changed", context: "Double vision reported", elapsed: "65 min", systemImage: "scope"),
        .init(id: "F-205", displayName: "Lina G.", ageBand: "Adult", lead: "Sudden weakness", context: "Family requested clarity", elapsed: "15 min", systemImage: "person.2")
    ]
}

enum StrokeEnvironmentMode: String, CaseIterable, Identifiable {
    case surroundings = "Surroundings"
    case warmHorizon = "Warm glow"
    case focusField = "Black focus"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .surroundings: "Room"
        case .warmHorizon: "Warm"
        case .focusField: "Black"
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

/// One explicit selection for the clinician's peripheral reference ring.
/// This prevents unrelated lesson state from making two categories appear
/// active at once and gives every non-imaging category the same cleanup path.
enum StrokeScholarReferenceCategory: String, CaseIterable, Identifiable {
    case anatomy
    case imaging
    case interventions
    case medications
    case guidelines
    case teachingModel

    var id: String { rawValue }
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
                StrokeLessonPoint(index: 3, shortTitle: "Context", fullTitle: "Opposite-side context"),
                StrokeLessonPoint(
                    index: 4,
                    shortTitle: "Neuron",
                    fullTitle: "Single neuron · schematic reference"
                )
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

/// A clinician-authored arrangement of existing, reviewed teaching copy.
/// Notes are deliberately finite and source-bound: this prototype does not
/// collect patient data, transcribe speech, or invent free-form clinical text.
struct StrokeSpatialAnnotation: Identifiable, Equatable {
    let id: String
    let sourceEntityName: String
    let title: String
    let body: String
    var position: SIMD3<Float>
}

/// One clinician-created mark on the temporary, view-facing teaching overlay.
/// Points are normalized to the overlay bounds so the drawing is independent
/// of Simulator pixels and never becomes anatomy geometry or patient data.
struct StrokeSpatialInkStroke: Identifiable, Equatable {
    let id: UUID
    var points: [CGPoint]
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

    /// The outer teaching model only provides five broad, reviewed surface
    /// orientation contexts. Keep this mapping explicit so a direct pinch on
    /// that generic surface cannot be misread as a free-form lobe picker or a
    /// patient-specific anatomical label.
    static func surfaceChapter(for atlasPointIndex: Int) -> StrokeFamilyBrainAtlasChapter? {
        switch atlasPointIndex {
        case 0: return .cortex
        case 1: return .frontalLobe
        case 2: return .parietalLobe
        case 3: return .temporalLobe
        case 4: return .occipitalLobe
        default: return nil
        }
    }

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
        case .cortex:
            "HIGHLIGHT CORTEX IN 3D"
        case .frontalLobe:
            "HIGHLIGHT FRONT CONTEXT IN 3D"
        case .parietalLobe:
            "HIGHLIGHT SENSORY CONTEXT IN 3D"
        case .temporalLobe:
            "HIGHLIGHT SIDE CONTEXT IN 3D"
        case .occipitalLobe:
            "HIGHLIGHT REAR CONTEXT IN 3D"
        case .corpusCallosum, .thalamus, .hippocampus, .brainstemAndCerebellum:
            "REVEAL INTERNAL STRUCTURES IN 3D"
        }
    }

    /// Only surface concepts use the reviewed, lifted regional points in the
    /// shared family model. Deeper structures intentionally hand off to the
    /// separately installed inside-brain experience rather than mapping a
    /// generic surface marker onto unreviewed internal anatomy.
    var spatialCuePointIndex: Int? {
        switch self {
        case .cortex: 0
        case .frontalLobe: 1
        case .parietalLobe: 2
        case .temporalLobe: 3
        case .occipitalLobe: 4
        case .arterialRoutes, .corpusCallosum, .thalamus, .hippocampus, .brainstemAndCerebellum:
            nil
        }
    }

    var pointField: StrokePointField {
        self == .arterialRoutes ? .procedure : .regions
    }

    /// These chapters teach a deep-brain topic using the one reviewed combined
    /// internal mesh that is actually available. They are deliberately not
    /// presented as individually segmented 3D structures.
    var usesCombinedInternalReference: Bool {
        switch self {
        case .corpusCallosum, .thalamus, .hippocampus, .brainstemAndCerebellum:
            true
        default:
            false
        }
    }

    /// Surface Atlas chapters reuse one reviewed whole-brain teaching object,
    /// then localize the requested region inside that complete structure. The
    /// focus is an orientation cue, not a patient landmark or functional map.
    var teachingReferenceLabel: String? {
        switch self {
        case .cortex: "Cerebral cortex · generic atlas focus"
        case .frontalLobe: "Frontal lobe · generic atlas focus"
        case .parietalLobe: "Parietal lobe · generic atlas focus"
        case .temporalLobe: "Temporal lobe · generic atlas focus"
        case .occipitalLobe: "Occipital lobe · generic atlas focus"
        case .corpusCallosum, .thalamus, .hippocampus, .brainstemAndCerebellum:
            "\(title) · combined internal atlas context"
        case .arterialRoutes:
            nil
        }
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
    case endovascularSet = "Catheter set"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .focus: "scope"
        case .transparency: "circle.lefthalf.filled"
        case .layerReveal: "square.3.layers.3d"
        case .forceps: "move.3d"
        case .cranialDrill: "gearshape.2.fill"
        case .endovascularSet: "point.topleft.down.to.point.bottomright.curvepath"
        }
    }

    var boundary: String {
        switch self {
        case .focus: "Region focus · context fades"
        case .transparency: "Reversible transparency"
        case .layerReveal: "Permission-gated layer explanation"
        case .forceps: "Generic concept asset · specialist review pending"
        case .cranialDrill: "Generic concept asset · specialist review pending"
        case .endovascularSet:
            "Generic educational device comparison · no sizing or deployment guidance"
        }
    }
}

enum StrokeEndovascularConcept: String, CaseIterable, Identifiable {
    case guidewire = "Guidewire"
    case microcatheter = "Microcatheter"
    case aspirationCatheter = "Aspiration"
    case stentRetriever = "Retriever"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .guidewire: "scribble.variable"
        case .microcatheter: "point.topleft.down.to.point.bottomright.curvepath"
        case .aspirationCatheter: "arrow.up.to.line.compact"
        case .stentRetriever: "mesh"
        }
    }

    var boundary: String {
        switch self {
        case .guidewire:
            "Generic guidewire concept · navigation shape only"
        case .microcatheter:
            "Generic microcatheter concept · no sizing reference"
        case .aspirationCatheter:
            "Generic aspiration-path concept · no treatment guidance"
        case .stentRetriever:
            "Conceptual deployed lattice · no device mechanics"
        }
    }

    /// Short, inspectable structure copy derived from the bundled v2 device
    /// manifest. These are visual parts, not procedural instructions.
    var inspectionSummary: String {
        switch self {
        case .guidewire:
            "Curved distal tip · highlighted distal section"
        case .microcatheter:
            "Hollow shaft · transition · distal marker"
        case .aspirationCatheter:
            "Hollow lumen · reinforcement · two distal markers"
        case .stentRetriever:
            "Deployed lattice · end crowns · abbreviated pusher"
        }
    }

    func geometryDisclosure(for detailLevel: StrokeDetailLevel) -> String {
        switch (self, detailLevel) {
        case (.guidewire, .calm):
            "Core wire"
        case (.guidewire, .guided):
            "Core wire + distal coil"
        case (.guidewire, .scholar):
            "Complete authored guidewire hierarchy"
        case (.microcatheter, .calm):
            "Hollow shaft"
        case (.microcatheter, .guided):
            "Hollow shaft + transition"
        case (.microcatheter, .scholar):
            "Shaft + transition + distal marker"
        case (.aspirationCatheter, .calm):
            "Hollow lumen"
        case (.aspirationCatheter, .guided):
            "Hollow lumen + distal markers"
        case (.aspirationCatheter, .scholar):
            "Lumen + markers + reinforcement braid"
        case (.stentRetriever, .calm):
            "Pusher + crowns + sparse lattice"
        case (.stentRetriever, .guided):
            "Pusher + markers + alternating lattice"
        case (.stentRetriever, .scholar):
            "Complete authored lattice hierarchy"
        }
    }
}

/// A reversible, non-procedural inspection loop for the authored device
/// models. These beats teach form and spatial relationship only; they do not
/// represent navigation, deployment, treatment, or a patient-specific path.
enum StrokeClinicianDeviceStudyBeat: Int, CaseIterable, Identifiable {
    case overview
    case approach
    case structure

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .overview: "Overview"
        case .approach: "Approach concept"
        case .structure: "Structure turn"
        }
    }

    var summary: String {
        switch self {
        case .overview:
            "Inspect the authored silhouette at teaching scale."
        case .approach:
            "A calm near-and-away motion shows direction only; it stops before the anatomy."
        case .structure:
            "A slow turn exposes markers, transitions, braid, or lattice when present."
        }
    }
}

@MainActor
final class StrokeExperienceState: ObservableObject {
    static let scholarSkullCatalogID = "skull_semantic_realistic_v2"
    static let authoredCaseHistoryMilestone: StrokeCaseHistoryMilestone = .reportedChange
    nonisolated static let spatialImagingImportByteLimit = 24 * 1_024 * 1_024
    /// Keep the complete image and its Back/Focus targets in the forward-right
    /// field. The old near-peripheral pose clipped half the plate at launch.
    /// Focus remains the deliberate large reading view; placement stays movable.
    static let spatialImagingDefaultPlatePosition = SIMD3<Float>(0.34, 1.55, -0.96)
    /// The exterior reading pose for the one selected blockage lesson. The
    /// interior threshold is deliberately larger, but it is not a readable
    /// exterior composition to return a family learner to.
    static let selectedBlockageExteriorZoom: Double = 2.05
    static let selectedBlockageExteriorOrbit = SIMD2<Float>(0.12, 0.06)

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
            endAccessLayerStudy()
            closeReferenceWorkspace()
            if audienceLens == .clinician {
                // The presenter speaks for themself. Changing role revokes
                // synthesized-narration eligibility at the state boundary.
                familyAtlasCerebellumJourneyRequested = false
                dismissFamilyDiscoveryHint()
                narrationEnabled = false
                familyNarrationPromptVisible = false
                activeFamilyNarrationText = nil
                familyNarrationTranscriptVisible = false
                selectedFamilyQuestion = nil
                presenterTeachingBeat = .firstBeat(for: procedureStep)
                return
            }
            detailLevel = .calm
            anatomyFocus = .whole
            selectedCatalogAssetID = nil
            clinicianToolKitVisible = false
            spatialImagingPlateVisible = false
            spatialImagingComparisonEnabled = false
            spatialImagingDragOrigin = nil
            spatialImagingScaleOrigin = nil
            resetSpatialImagingAnnotation()
            clearSpatialImagingLocalImage()
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
    /// The chapter whose optional spatial cue the family member explicitly
    /// revealed. It is deliberately separate from the generic selected-point
    /// state so changing chapters cannot make an old marker look relevant to
    /// a new explanation.
    @Published private(set) var familyBrainAtlasCueChapter: StrokeFamilyBrainAtlasChapter?
    @Published private(set) var selectedPresenterKeyPointIndex: Int?
    @Published private(set) var presenterTeachingBeat: StrokePresenterTeachingBeat = .confirmContext
    @Published var questionPlacementArmed = false
    @Published var questionMarkerVisible = false
    @Published private(set) var placedQuestion: PlacedStrokeQuestion?
    /// Ambient sound is optional by default. A wearer explicitly enables it
    /// from the doorway or peripheral controls; it never starts on launch.
    @Published var soundEnabled = false
    /// A rate-limited, semantic trigger for system-managed visionOS sensory
    /// feedback. It supplements visible state changes and has no clinical,
    /// diagnostic, or emotion-reading meaning.
    @Published private(set) var interactionFeedbackToken = 0
    private var lastInteractionFeedbackAt = Date.distantPast
    @Published private(set) var narrationEnabled = false
    /// Voice is optional and point-led. Looking at or pinching a point never
    /// starts audio by itself; it only reveals a finite authored invitation.
    @Published private(set) var familyNarrationPromptVisible = false
    @Published private(set) var activeFamilyNarrationText: String?
    /// When voice setup is unavailable, the same authored point explanation
    /// remains available as finite on-screen progressive disclosure. This is
    /// never a transcript of recorded speech and never starts audio.
    @Published private(set) var familyNarrationTranscriptVisible = false
    @Published private(set) var narrationSetupAvailable = false
    /// A short first-action cue for the Curious Learner route. It is never a
    /// permanent label cloud: the first point selection dismisses it, and an
    /// untouched cue retires after eight seconds.
    @Published private(set) var familyDiscoveryHintVisible = false
    @Published var closingReflectionVisible = false
    @Published var pointField: StrokePointField = .regions
    @Published private(set) var selectedScholarReferenceCategory: StrokeScholarReferenceCategory = .anatomy
    @Published private(set) var focusedReferenceWorkspace: StrokeReferenceWorkspace? {
        didSet {
            if focusedReferenceWorkspace != .imagingGallery { imagingGallery.cancelImport() }
            if oldValue == .imagingGallery && focusedReferenceWorkspace != .imagingGallery {
                imagingGallery.clearLocalImages()
            }
        }
    }
    @Published var imagingGallery = StrokeImagingGalleryModel()
    /// The one explicitly placed gallery image outlives the gallery workspace,
    /// but is released on Back, study replacement or leaving the teaching view.
    @Published private(set) var spatialImagingGalleryImage: StrokeGalleryImage?
    @Published private(set) var selectedMedicineID = "antiplatelets"
    @Published private(set) var medicineExhibitYaw: Float = 0
    @Published var presenterPanelScale: Double = 1
    @Published var lessonPointsVisible = true
    @Published var teachingImagingDrawerVisible = false
    @Published var teachingImagingLens: StrokeTeachingImagingLens = .affectedVessel
    @Published var spatialImagingPlateVisible = false {
        didSet {
            if !spatialImagingPlateVisible { spatialImagingImportSession.cancel() }
        }
    }
    private var spatialImagingImportSession = StrokeImagingImportSession()
    @Published var spatialImagingReference: StrokeTeachingImageReference = .ctGuide
    @Published private(set) var spatialImagingComparisonEnabled = false
    /// A clinician-selected image lives in memory only for the current
    /// teaching view. It is never uploaded, persisted, registered to the
    /// anatomy, interpreted, or presented as a diagnosis.
    @Published private(set) var spatialImagingLocalImageData: Data?
    @Published private(set) var spatialImagingLocalImageName: String?
    @Published private(set) var spatialImagingLocalImageModality: StrokeImagingModality = .unspecified
    /// An optional second local raster shares the same temporary spatial
    /// board. It is comparison context only: the app does not register the
    /// images, infer correspondence, or retain either payload.
    @Published private(set) var spatialImagingLocalComparisonImageData: Data?
    @Published private(set) var spatialImagingLocalComparisonImageName: String?
    @Published private(set) var spatialImagingLocalComparisonImageModality: StrokeImagingModality = .unspecified
    @Published private(set) var spatialImagingComparisonDetached = false
    @Published var spatialImagingPlatePosition = StrokeExperienceState.spatialImagingDefaultPlatePosition
    @Published private(set) var spatialImagingPlateScale: Float = 1
    @Published private(set) var spatialImagingFocusActive = false
    private var spatialImagingDragOrigin: SIMD3<Float>?
    private var spatialImagingScaleOrigin: Float?
    private var spatialImagingFocusReturnPosition: SIMD3<Float>?
    private var spatialImagingFocusReturnScale: Float?
    @Published var spatialImagingComparisonPlatePosition = SIMD3<Float>(-0.42, 1.42, -0.66)
    @Published private(set) var spatialImagingComparisonPlateScale: Float = 0.84
    private var spatialImagingComparisonDragOrigin: SIMD3<Float>?
    private var spatialImagingComparisonScaleOrigin: Float?
    @Published private(set) var spatialImagingAnnotationEnabled = false
    @Published private(set) var spatialImagingInkStrokes: [StrokeSpatialInkStroke] = []
    private var activeSpatialImagingInkStrokeID: UUID?
    @Published private(set) var spatialImagingComparisonInkStrokes: [StrokeSpatialInkStroke] = []
    private var activeSpatialImagingComparisonInkStrokeID: UUID?
    @Published private(set) var spatialImagingPrimaryContextTitle: String?
    @Published private(set) var spatialImagingPrimaryContextBody: String?
    @Published private(set) var spatialImagingPrimaryContextAnchor: CGPoint?
    @Published private(set) var spatialImagingComparisonContextTitle: String?
    @Published private(set) var spatialImagingComparisonContextBody: String?
    @Published private(set) var spatialImagingComparisonContextAnchor: CGPoint?
    @Published private(set) var spatialAnnotations: [StrokeSpatialAnnotation] = []
    private var spatialAnnotationDragOrigins: [String: SIMD3<Float>] = [:]
    @Published private(set) var spatialInkVisible = false
    @Published private(set) var spatialInkStrokes: [StrokeSpatialInkStroke] = []
    private var activeSpatialInkStrokeID: UUID?
    @Published var clinicianToolKitVisible = false
    @Published var selectedClinicianTool: StrokeClinicianTool = .focus
    @Published var selectedEndovascularConcept: StrokeEndovascularConcept = .microcatheter
    @Published var clinicianDeviceInspectionYaw: Float = 0
    @Published var clinicianDeviceStudyBeat: StrokeClinicianDeviceStudyBeat = .overview
    @Published private(set) var accessLayerStudy = StrokeAccessLayerStudy()
    @Published private(set) var accessLayerStudyAssetsAvailable = false
    private var accessLayerMotionTask: Task<Void, Never>?
    private var accessLayerDragOrigin: (position: SIMD3<Float>, progress: Float)?
    private var accessLayerStudyEntryPending = false
    private var accessLayerStudyOrbit = StrokeAnatomyViewpoint.lateralB.orbit
    private var pendingAccessLayerStudyProofOpen: Bool?
    private var accessStudyReturnState: (
        presentation: StrokeAnatomyPresentation, opacity: Double, viewpoint: StrokeAnatomyViewpoint,
        orbit: SIMD2<Float>, zoom: Double, paused: Bool, tool: StrokeClinicianTool, kitVisible: Bool
    )?
    @Published var anatomyPresentation: StrokeAnatomyPresentation = .assembled
    @Published private(set) var anatomyFocus: StrokeAnatomyFocus = .whole
    @Published private(set) var availableAnatomyFocuses: Set<StrokeAnatomyFocus> = [.whole]
    @Published private(set) var anatomyAvailabilityResolved = false
    @Published private(set) var anatomyAvailabilityNotice: String?
    @Published private(set) var anatomyViewpoint: StrokeAnatomyViewpoint = .threeQuarter
    @Published var environmentMode: StrokeEnvironmentMode = .focusField
    @Published var cortexOpacity: Double = 0.34
    @Published var regionPortalActive = false
    @Published private(set) var selectedPointEntityName: String?
    @Published private(set) var selectedPointLabel: String?
    /// Family explanations disclose one idea first. The secondary 3D reference
    /// is an explicit follow-up, never a second competing object on selection.
    @Published private(set) var selectedPointReferenceExpanded = false

    /// Opening the family-safe plain-language explanation is also an explicit
    /// request to reveal the qualitative cue along this one generic neuron.
    /// It never represents measured neural activity, a recording, or patient
    /// data, and it resets as soon as the learner changes or closes a point.
    var isSelectedNeuronSignalTraceActive: Bool {
        audienceLens == .family &&
            selectedPointReferenceExpanded &&
            familyNarrationTranscriptVisible &&
            selectedPointLabel == "Single neuron · schematic reference"
    }

    /// Surface lessons already disclose one complete generic brain in the
    /// secondary field. When a family learner explicitly opens its plain
    /// wording, the existing local patch becomes a little more legible. This
    /// is an orientation cue only: it does not segment tissue, infer a
    /// functional boundary, or identify a patient finding.
    var isSelectedSurfacePlainWordsFocusActive: Bool {
        audienceLens == .family &&
            selectedPointReferenceExpanded &&
            familyNarrationTranscriptVisible &&
            selectedPointLabel != nil &&
            teachingImagingLens == .brainSurface
    }

    /// Deep Atlas chapters are intentionally represented by one combined mesh
    /// plus its ventricular system. When a learner explicitly asks for the
    /// plain-language explanation, make the named *available* ventricular
    /// object easier to inspect, without pretending the source mesh separately
    /// segments the chapter named in the card.
    var isSelectedInternalPlainWordsFocusActive: Bool {
        audienceLens == .family &&
            selectedPointReferenceExpanded &&
            familyNarrationTranscriptVisible &&
            selectedPointLabel?.hasSuffix("· combined internal atlas context") == true &&
            teachingImagingLens == .internalStructures
    }
    @Published var selectedEvidenceID: String = StrokeEvidenceSource.library[0].id
    @Published private(set) var pinnedEvidenceIDs: [String] = []
    @Published var sourceBoundDraftVisible = false
    @Published var careViewPermissionGranted = false
    @Published var isConsentPromptVisible = false
    @Published var isImmersivePresented = false
    @Published var spatialPhase: StrokeSpatialPhase = .caseLibrary
    @Published private(set) var selectedFictionalCaseIndex = 0
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
    /// A deliberate mode of the same Stroke Care immersive space. Scaling only
    /// reveals the threshold; entering and returning always require an action.
    @Published private(set) var internalBrainModeActive = false
    /// A narrow, chapter-owned handoff into the existing generic cerebellum
    /// observatory. This avoids treating the outer combined internal mesh as
    /// though it were a separately segmented cerebellum.
    @Published private(set) var familyAtlasCerebellumJourneyRequested = false

    /// 0...1 animation channels. They drive a deterministic spatial teaching rig,
    /// not a patient scan, surgical simulation, or physiology calculation.
    @Published private(set) var brainRevealProgress: Double = 0
    @Published private(set) var vesselFocusProgress: Double = 0
    @Published private(set) var planPreviewProgress: Double = 0
    @Published private(set) var layerRevealProgress: Double = 0
    private var layerRevealTask: Task<Void, Never>?
    private var caseReviewRevealTask: Task<Void, Never>?
    private var familyDiscoveryHintTask: Task<Void, Never>?
    private var pendingAnatomyFocus: StrokeAnatomyFocus?

    var selectedFictionalCase: StrokeFictionalCase {
        StrokeFictionalCase.library[selectedFictionalCaseIndex]
    }

    /// Keeps the chosen fictional dossier visible through review without
    /// turning the generic teaching anatomy into a patient-specific scan.
    func caseHistoryTimeLabel(for milestone: StrokeCaseHistoryMilestone) -> String {
        switch milestone {
        case .everydayContext: "BEFORE TODAY"
        case .reportedChange: "\(selectedFictionalCase.elapsed.uppercased()) AGO"
        case .teamReview: "NOW"
        case .sharedQuestions: "NEXT"
        }
    }

    func caseHistoryWebValue(for milestone: StrokeCaseHistoryMilestone) -> String {
        switch milestone {
        case .everydayContext:
            "\(selectedFictionalCase.displayName) · \(selectedFictionalCase.ageBand)"
        case .reportedChange:
            "\(selectedFictionalCase.lead) · \(selectedFictionalCase.context)"
        case .teamReview:
            "Reviewed pictures · teaching model separate"
        case .sharedQuestions:
            "Known · uncertain · next"
        }
    }

    func selectFictionalCase(at index: Int) {
        guard audienceLens == .clinician, spatialPhase == .caseLibrary else { return }
        selectedFictionalCaseIndex = min(max(index, 0), StrokeFictionalCase.library.count - 1)
    }

    func stepFictionalCase(by delta: Int) {
        guard audienceLens == .clinician, spatialPhase == .caseLibrary else { return }
        let count = StrokeFictionalCase.library.count
        selectedFictionalCaseIndex = (selectedFictionalCaseIndex + delta + count) % count
    }

    private func showFamilyDiscoveryHint(autoDismiss: Bool = true) {
        familyDiscoveryHintTask?.cancel()
        guard audienceLens == .family else {
            familyDiscoveryHintVisible = false
            return
        }
        familyDiscoveryHintVisible = true
        guard autoDismiss else { return }
        familyDiscoveryHintTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(8))
            guard !Task.isCancelled, let self else { return }
            withAnimation(.easeOut(duration: 0.45)) {
                self.familyDiscoveryHintVisible = false
            }
        }
    }

    private func dismissFamilyDiscoveryHint() {
        familyDiscoveryHintTask?.cancel()
        familyDiscoveryHintTask = nil
        familyDiscoveryHintVisible = false
    }

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

    /// A secondary visual preference lives in Settings, not the explanation
    /// surface. Direct previous/next steps keep the control spatial and
    /// discoverable without turning the three detail tiers into a slider.
    func cycleDetailLevel(by offset: Int) {
        guard audienceLens == .clinician else { return }
        let levels = StrokeDetailLevel.allCases
        guard let currentIndex = levels.firstIndex(of: detailLevel) else { return }
        let nextIndex = (currentIndex + offset + levels.count) % levels.count
        selectDetailLevel(levels[nextIndex])
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
        familyBrainAtlasCueChapter = nil
        selectLessonFamily(chapter.pointField)
    }

    /// Lets a family learner use the generic outer-brain object itself as an
    /// alternate entry point. The surface hit resolves only to one of the
    /// existing broad Atlas contexts and immediately reuses that chapter's
    /// reviewed point + reference path. It does not inspect raw gaze, segment
    /// tissue, infer a clinical finding, or place a label on patient anatomy.
    func selectFamilyAtlasSurfaceContext(atlasPointIndex: Int) {
        guard audienceLens == .family,
              spatialPhase == .explanation,
              let chapter = StrokeFamilyBrainAtlasChapter.surfaceChapter(for: atlasPointIndex)
        else { return }

        // The confirmed surface pinch is itself an explicit request to
        // explore. Open the otherwise optional Atlas as the result of that
        // action, instead of making a family member find a separate control
        // before the generic brain can be useful.
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(chapter)
        revealFamilyBrainAtlasModelCue()
    }

    /// Every atlas chapter has one deliberate spatial reveal. Surface chapters
    /// select one real lifted regional cue; arterial routes select the existing
    /// qualitative-flow cue; deep chapters only prepare the explicit separate
    /// inside-brain handoff. None of these are patient-specific labels,
    /// measurements, or hidden diagnostic claims.
    func revealFamilyBrainAtlasModelCue() {
        guard audienceLens == .family, spatialPhase == .explanation else { return }
        let chapter = familyBrainAtlasChapter
        selectFamilyBrainAtlasChapter(chapter)
        if chapter == .arterialRoutes,
           let branchingCue = StrokePointField.procedure.lessonPoints.first(where: { $0.index == 1 }) {
            selectLessonPoint(branchingCue)
            familyBrainAtlasCueChapter = chapter
            return
        }
        if let index = chapter.spatialCuePointIndex {
            selectPoint(
                entityName: "family-atlas-point-field-point-\(index)",
                label: chapter.teachingReferenceLabel ?? "\(chapter.title) · generic atlas focus"
            )
            // The point is the invitation; the right field now reveals the
            // complete generic brain with this chapter's localized focus.
            teachingImagingLens = .brainSurface
            teachingImagingDrawerVisible = true
            familyBrainAtlasCueChapter = chapter
            return
        }
        // The source package exposes one combined deep-structures mesh and one
        // ventricular mesh, not separately named chapter structures. Reveal
        // that complete registered context without inventing a precise marker;
        // the optional room-scale journey remains a separate next action.
        let internalLabel = chapter.teachingReferenceLabel ??
            "\(chapter.title) · combined internal atlas context"
        selectedPointEntityName = "family-atlas-internal-reference"
        selectedPointLabel = internalLabel
        selectedPointReferenceExpanded = true
        teachingImagingLens = .internalStructures
        teachingImagingDrawerVisible = true
        activeFamilyNarrationText = nil
        familyNarrationTranscriptVisible = false
        familyNarrationPromptVisible = true
        familyBrainAtlasCueChapter = chapter
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
        // The complete registered assembly arrives after the compact opening
        // placeholder. Whole is always actionable while that load runs; the
        // optional references below stay pending until their actual USDZ
        // hierarchy has reported availability.
        if focus == .whole {
            pendingAnatomyFocus = nil
            applyAnatomyFocus(.whole)
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
        // An explicitly selected internal study needs enough starting scale
        // for its authored geometry to read as a real 3D reference. Preserve
        // a wearer's larger hand-selected zoom rather than snapping them back
        // to a smaller generic view.
        let minimumFocusZoom: Double = focus == .internalStructures ? 1.70 : 1.28
        spatialZoom = max(spatialZoom, minimumFocusZoom)
    }

    /// Starts a new asynchronous registered-anatomy availability check. The
    /// compact opening root deliberately contains only the reliable whole-brain
    /// fallback, so it must not erase a clinician's requested Internal,
    /// Vessels, or Surface focus before the detailed root has finished loading.
    func beginAnatomyAvailabilityCheck() {
        anatomyAvailabilityResolved = false
        availableAnatomyFocuses = [.whole]
        anatomyAvailabilityNotice = nil

        if anatomyFocus != .whole {
            pendingAnatomyFocus = anatomyFocus
            anatomyFocus = .whole
        }
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
            // The internal study should read as authored deep geometry, not a
            // faded exterior brain. Keep only a very light orientation shell;
            // the clinician can still select another environment from the
            // peripheral controls when room context is useful.
            cortexOpacity = 0.08
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
        spatialImagingPlateVisible = false
        spatialImagingComparisonEnabled = false
        resetSpatialImagingAnnotation()
        familyBrainAtlasVisible = false
        familyBrainAtlasChapter = .cortex
        familyBrainAtlasDetailIndex = 0
        familyBrainAtlasCueChapter = nil
        showFamilyDiscoveryHint()
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
        spatialImagingPlateVisible = false
        spatialImagingComparisonEnabled = false
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
        resetSpatialImagingAnnotation()
        clearSpatialImagingLocalImage()
        spatialAnnotations = []
        spatialAnnotationDragOrigins = [:]
        spatialInkVisible = false
        spatialInkStrokes = []
        activeSpatialInkStrokeID = nil
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
        familyNarrationPromptVisible = false
        activeFamilyNarrationText = nil
        familyNarrationTranscriptVisible = false
    }

    func selectLessonFamily(_ field: StrokePointField) {
        endAccessLayerStudy()
        pointField = field
        if audienceLens == .clinician {
            switch field {
            case .regions:
                selectedScholarReferenceCategory = .anatomy
            case .craniotomy:
                selectedScholarReferenceCategory = .interventions
            case .procedure:
                break
            }
        }
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

    /// Makes the Scholar ring exclusive. Moving away from Imaging always
    /// removes its placed card and point drawer, so the presenter cannot leave
    /// a stale image floating behind another selected category.
    func selectScholarReferenceCategory(_ category: StrokeScholarReferenceCategory) {
        guard audienceLens == .clinician, spatialPhase == .explanation else { return }
        focusedReferenceWorkspace = nil
        selectedScholarReferenceCategory = category
        guard category != .imaging else { return }
        teachingImagingDrawerVisible = false
        spatialImagingPlateVisible = false
        spatialImagingComparisonEnabled = false
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
        resetSpatialImagingAnnotation()
        clearSpatialImagingLocalImage()
    }

    func openReferenceWorkspace(_ workspace: StrokeReferenceWorkspace) {
        guard audienceLens == .clinician, spatialPhase == .explanation else { return }
        endAccessLayerStudy()
        cancelSpatialImagingFocus(resetTransform: true)
        teachingImagingDrawerVisible = false
        spatialImagingPlateVisible = false
        spatialImagingComparisonEnabled = false
        spatialImagingAnnotationEnabled = false
        questionPlacementArmed = false
        sourceBoundDraftVisible = false
        focusedReferenceWorkspace = workspace
        switch workspace {
        case .imagingGallery: selectedScholarReferenceCategory = .imaging
        case .settings: selectedScholarReferenceCategory = .teachingModel
        case .guides: selectedScholarReferenceCategory = .guidelines
        case .medications: selectedScholarReferenceCategory = .medications
        }
    }

    func closeReferenceWorkspace() {
        if focusedReferenceWorkspace == .imagingGallery { imagingGallery.clearLocalImages() }
        if focusedReferenceWorkspace != nil {
            selectedScholarReferenceCategory = pointField == .craniotomy ? .interventions : .anatomy
        }
        focusedReferenceWorkspace = nil
        sourceBoundDraftVisible = false
    }

    func selectSpatialMedicine(_ id: String) {
        guard focusedReferenceWorkspace == .medications,
              StrokeMedicineTopic.library.contains(where: { $0.id == id }) else { return }
        selectedMedicineID = id
        medicineExhibitYaw = 0
    }

    func rotateSpatialMedicine(by delta: Float) {
        guard focusedReferenceWorkspace == .medications, delta.isFinite else { return }
        medicineExhibitYaw = (medicineExhibitYaw + delta).truncatingRemainder(dividingBy: .pi * 2)
    }

    func resetSpatialMedicine() { medicineExhibitYaw = 0 }

    var spatialImagingGalleryRaster: UIImage? {
        guard let image = spatialImagingGalleryImage else { return nil }
        if let data = image.data { return UIImage(data: data) }
        return image.assetName.flatMap { UIImage(named: $0) }
    }

    /// Snapshot before closing the gallery: closing invalidates imports and
    /// releases its other images. Only this selected image and its marks travel.
    @discardableResult
    func placeImagingGalleryImage(_ id: UUID) -> Bool {
        guard audienceLens == .clinician, spatialPhase == .explanation,
              focusedReferenceWorkspace == .imagingGallery,
              let image = imagingGallery.images.first(where: { $0.id == id }) else { return false }
        if let data = image.data {
            guard !data.isEmpty, data.count <= Self.spatialImagingImportByteLimit,
                  UIImage(data: data) != nil else { return false }
        } else {
            guard let name = image.assetName, UIImage(named: name) != nil,
                  image.modality == .ct || image.modality == .mri else { return false }
        }
        cancelSpatialImagingFocus(resetTransform: true)
        discardSpatialImagingLocalImagePayload()
        if let data = image.data {
            guard placeSpatialImagingLocalImage(data: data, displayName: image.name) else { return false }
            let modality: StrokeImagingModality = switch image.modality {
            case .ct: .ct
            case .mri: .mri
            case .xray: .radiograph
            case .unspecified: .unspecified
            }
            selectSpatialImagingModality(modality, comparison: false)
        } else {
            placeSpatialImagingPlate(image.modality == .ct ? .ctGuide : .mriGuide)
        }
        resetSpatialImagingAnnotation()
        spatialImagingInkStrokes = image.strokes.map { StrokeSpatialInkStroke(id: UUID(), points: $0) }
        var source = image
        source.strokes = [] // one editable ink owner after placement
        spatialImagingGalleryImage = source
        return true
    }

    /// Places a generic imaging teaching card in the shared spatial scene.
    /// It is explicitly clinician-controlled and never represents patient
    /// imaging, a finding, or a diagnostic result.
    func placeSpatialImagingPlate(_ reference: StrokeTeachingImageReference) {
        spatialImagingImportSession.cancel()
        guard audienceLens == .clinician, spatialPhase == .explanation else {
            spatialImagingPlateVisible = false
            spatialImagingComparisonEnabled = false
            resetSpatialImagingAnnotation()
            return
        }
        if spatialImagingReference != reference || spatialImagingLocalImageData != nil || spatialImagingGalleryImage != nil {
            resetSpatialImagingAnnotation()
        }
        closeReferenceWorkspace()
        // Switching studies keeps the imaging room and its return position.
        // Clearing an imported payload must not silently navigate back out.
        discardSpatialImagingLocalImagePayload()
        spatialImagingReference = reference
        spatialImagingComparisonEnabled = false
        selectedScholarReferenceCategory = .imaging
        // One secondary surface at a time: placing an image replaces the
        // point drawer and its 3D miniature instead of stacking four panels
        // in the clinician's right visual field.
        teachingImagingDrawerVisible = false
        spatialImagingPlateVisible = true
    }

    func beginSpatialImagingImport(target: StrokeLocalImageImportTarget) -> StrokeImagingImportRequest? {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible,
              focusedReferenceWorkspace == nil,
              target != .comparison || spatialImagingLocalImageData != nil else { return nil }
        return spatialImagingImportSession.begin(target: target)
    }

    func isCurrentSpatialImagingImport(_ request: StrokeImagingImportRequest) -> Bool {
        spatialImagingImportSession.isCurrent(request)
    }

    func cancelSpatialImagingImport(_ request: StrokeImagingImportRequest) {
        _ = spatialImagingImportSession.consume(request)
    }

    @discardableResult
    func completeSpatialImagingImport(
        _ request: StrokeImagingImportRequest,
        data: Data,
        displayName: String
    ) -> Bool {
        guard spatialImagingImportSession.consume(request),
              audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible,
              focusedReferenceWorkspace == nil else { return false }
        switch request.target {
        case .primary:
            return placeSpatialImagingLocalImage(data: data, displayName: displayName)
        case .comparison:
            return placeSpatialImagingLocalComparisonImage(data: data, displayName: displayName)
        }
    }

    /// Accepts a local raster image only after a deliberate clinician action.
    /// The payload is bounded and decoded before it can replace an atlas
    /// template. No filename, pixels, or markup leave this process.
    @discardableResult
    func placeSpatialImagingLocalImage(data: Data, displayName: String) -> Bool {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              !data.isEmpty,
              data.count <= Self.spatialImagingImportByteLimit,
              UIImage(data: data) != nil else { return false }

        closeReferenceWorkspace()
        spatialImagingImportSession.cancel()
        resetSpatialImagingAnnotation()
        spatialImagingGalleryImage = nil
        spatialImagingLocalImageData = data
        spatialImagingLocalImageName = String(displayName.prefix(72))
        spatialImagingLocalImageModality = .unspecified
        spatialImagingComparisonEnabled = spatialImagingLocalComparisonImageData != nil
        selectedScholarReferenceCategory = .imaging
        teachingImagingDrawerVisible = false
        spatialImagingPlateVisible = true
        return true
    }

    /// Adds one second, independently chosen raster to the local comparison
    /// board. The primary image must already be present so a dropped file can
    /// never create a hidden or context-free secondary payload.
    @discardableResult
    func placeSpatialImagingLocalComparisonImage(data: Data, displayName: String) -> Bool {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingLocalImageData != nil,
              !data.isEmpty,
              data.count <= Self.spatialImagingImportByteLimit,
              UIImage(data: data) != nil else { return false }

        spatialImagingImportSession.cancel()
        resetSpatialImagingAnnotation()
        spatialImagingGalleryImage = nil
        spatialImagingLocalComparisonImageData = data
        spatialImagingLocalComparisonImageName = String(displayName.prefix(72))
        spatialImagingLocalComparisonImageModality = .unspecified
        spatialImagingComparisonEnabled = true
        selectedScholarReferenceCategory = .imaging
        teachingImagingDrawerVisible = false
        spatialImagingPlateVisible = true
        return true
    }

    func clearSpatialImagingLocalImage() {
        spatialImagingImportSession.cancel()
        resetSpatialImagingAnnotation()
        cancelSpatialImagingFocus(resetTransform: true)
        discardSpatialImagingLocalImagePayload()
    }

    private func discardSpatialImagingLocalImagePayload() {
        spatialImagingGalleryImage = nil
        spatialImagingLocalImageData = nil
        spatialImagingLocalImageName = nil
        spatialImagingLocalImageModality = .unspecified
        clearSpatialImagingPointContext(comparison: false)
        clearSpatialImagingLocalComparisonImage()
    }

    func clearSpatialImagingLocalComparisonImage() {
        spatialImagingImportSession.cancel()
        spatialImagingLocalComparisonImageData = nil
        spatialImagingLocalComparisonImageName = nil
        spatialImagingLocalComparisonImageModality = .unspecified
        spatialImagingComparisonEnabled = false
        spatialImagingComparisonDetached = false
        spatialImagingComparisonDragOrigin = nil
        spatialImagingComparisonScaleOrigin = nil
        spatialImagingComparisonInkStrokes = []
        activeSpatialImagingComparisonInkStrokeID = nil
        clearSpatialImagingPointContext(comparison: true)
    }

    /// Names a local image only after an explicit presenter choice. This is
    /// descriptive session context—not image classification or interpretation.
    func selectSpatialImagingModality(_ modality: StrokeImagingModality, comparison: Bool) {
        guard audienceLens == .clinician,
              spatialPhase == .explanation else { return }
        if comparison {
            guard spatialImagingLocalComparisonImageData != nil else { return }
            spatialImagingLocalComparisonImageModality = modality
        } else {
            guard spatialImagingLocalImageData != nil else { return }
            spatialImagingLocalImageModality = modality
        }
    }

    func cycleSpatialImagingModality(comparison: Bool) {
        let options: [StrokeImagingModality] = [
            .ct, .cta, .mri, .mra, .pet, .radiograph, .other, .unspecified
        ]
        let current = comparison
            ? spatialImagingLocalComparisonImageModality
            : spatialImagingLocalImageModality
        let nextIndex = ((options.firstIndex(of: current) ?? -1) + 1) % options.count
        selectSpatialImagingModality(options[nextIndex], comparison: comparison)
    }

    /// Copies one reviewed point explanation onto a chosen local image as a
    /// discussion prompt. This is intentionally manual and reversible: the
    /// app never infers that the point corresponds to pixels in the image.
    func attachSelectedPointContextToSpatialImaging(comparison: Bool) {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              let selectedPointLabel else { return }
        if comparison {
            guard spatialImagingLocalComparisonImageData != nil else { return }
            spatialImagingComparisonContextTitle = selectedPointLabel
            spatialImagingComparisonContextBody = spatialAnnotationBody(for: selectedPointLabel)
            spatialImagingComparisonContextAnchor = CGPoint(x: 0.64, y: 0.38)
        } else {
            guard spatialImagingLocalImageData != nil else { return }
            spatialImagingPrimaryContextTitle = selectedPointLabel
            spatialImagingPrimaryContextBody = spatialAnnotationBody(for: selectedPointLabel)
            spatialImagingPrimaryContextAnchor = CGPoint(x: 0.68, y: 0.38)
        }
    }

    /// Repositions a clinician-placed discussion marker over a local image.
    /// The normalized point is a presentation aid only; it is not stored as
    /// image registration, a measurement, or an inferred anatomical finding.
    func moveSpatialImagingPointContextAnchor(to point: CGPoint, comparison: Bool) {
        guard audienceLens == .clinician,
              spatialPhase == .explanation else { return }
        let clamped = clampedInkPoint(point)
        if comparison {
            guard spatialImagingLocalComparisonImageData != nil,
                  spatialImagingComparisonContextTitle != nil else { return }
            spatialImagingComparisonContextAnchor = clamped
        } else {
            guard spatialImagingLocalImageData != nil,
                  spatialImagingPrimaryContextTitle != nil else { return }
            spatialImagingPrimaryContextAnchor = clamped
        }
    }

    func clearSpatialImagingPointContext(comparison: Bool) {
        if comparison {
            spatialImagingComparisonContextTitle = nil
            spatialImagingComparisonContextBody = nil
            spatialImagingComparisonContextAnchor = nil
        } else {
            spatialImagingPrimaryContextTitle = nil
            spatialImagingPrimaryContextBody = nil
            spatialImagingPrimaryContextAnchor = nil
        }
    }

    /// Lets a clinician compare two local rasters as separate spatial objects
    /// or return them to a single side-by-side board. Separation never implies
    /// registration: the two plates remain independently positioned and the
    /// app computes no correspondence between their pixels.
    func toggleSpatialImagingComparisonSeparation() {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible,
              spatialImagingLocalImageData != nil,
              spatialImagingLocalComparisonImageData != nil else { return }
        spatialImagingComparisonDetached.toggle()
        spatialImagingComparisonEnabled = true
        if spatialImagingComparisonDetached {
            spatialImagingComparisonPlatePosition = [-0.42, 1.42, -0.66]
            spatialImagingComparisonPlateScale = 0.84
        }
        spatialImagingComparisonDragOrigin = nil
        spatialImagingComparisonScaleOrigin = nil
    }

    func beginSpatialImagingComparisonPlateDrag() {
        guard audienceLens == .clinician,
              spatialImagingComparisonDetached else { return }
        spatialImagingComparisonDragOrigin = spatialImagingComparisonPlatePosition
    }

    func moveSpatialImagingComparisonPlate(translation: CGSize) {
        guard audienceLens == .clinician,
              spatialImagingComparisonDetached,
              let origin = spatialImagingComparisonDragOrigin else { return }
        spatialImagingComparisonPlatePosition.x = min(
            0.68,
            max(-0.68, origin.x + Float(translation.width) * 0.00075)
        )
        spatialImagingComparisonPlatePosition.y = min(
            1.94,
            max(0.92, origin.y - Float(translation.height) * 0.00075)
        )
    }

    func endSpatialImagingComparisonPlateDrag() {
        spatialImagingComparisonDragOrigin = nil
    }

    func beginSpatialImagingComparisonPlateScale() {
        guard audienceLens == .clinician,
              spatialImagingComparisonDetached else { return }
        spatialImagingComparisonScaleOrigin = spatialImagingComparisonPlateScale
    }

    func scaleSpatialImagingComparisonPlate(by magnification: CGFloat) {
        guard audienceLens == .clinician,
              spatialImagingComparisonDetached,
              let origin = spatialImagingComparisonScaleOrigin else { return }
        spatialImagingComparisonPlateScale = min(
            2.5,
            max(0.55, origin * Float(magnification))
        )
    }

    func endSpatialImagingComparisonPlateScale() {
        spatialImagingComparisonScaleOrigin = nil
    }

    /// Keeps the two openly licensed atlas templates on one coherent spatial
    /// board. This is a teaching comparison—not multimodal patient imaging or
    /// registration—and the same temporary ink layer can mark either side.
    func toggleSpatialImagingComparison() {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible else { return }
        if spatialImagingGalleryImage != nil {
            spatialImagingGalleryImage = nil
            resetSpatialImagingAnnotation()
        }
        spatialImagingComparisonEnabled.toggle()
        if spatialImagingComparisonEnabled {
            spatialImagingReference = .ctGuide
        }
    }

    /// The outermost recovery route for a placed teaching image. Local
    /// navigation remains explicit: term note → study, focused study → beside
    /// brain, and this action → the anatomy explanation. Keeping the state
    /// reset here prevents a hidden focused, comparison, annotation, or local
    /// image state from surviving after the presenter returns to the brain.
    func returnToAnatomyFromSpatialImaging() {
        spatialImagingPlateVisible = false
        spatialImagingComparisonEnabled = false
        spatialImagingFocusActive = false
        spatialImagingFocusReturnPosition = nil
        spatialImagingFocusReturnScale = nil
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
        resetSpatialImagingAnnotation()
        clearSpatialImagingLocalImage()
        selectedScholarReferenceCategory = pointField == .craniotomy ? .interventions : .anatomy
    }

    /// Compatibility entry point for existing callers. New controls should
    /// name their destination rather than presenting this as an ambiguous
    /// close action.
    func hideSpatialImagingPlate() {
        returnToAnatomyFromSpatialImaging()
    }

    func beginSpatialImagingPlateDrag() {
        guard audienceLens == .clinician, spatialImagingPlateVisible else { return }
        spatialImagingDragOrigin = spatialImagingPlatePosition
    }

    func moveSpatialImagingPlate(translation: CGSize) {
        guard audienceLens == .clinician,
              spatialImagingPlateVisible,
              let origin = spatialImagingDragOrigin else { return }
        spatialImagingPlatePosition.x = min(
            0.68,
            max(-0.68, origin.x + Float(translation.width) * 0.00075)
        )
        spatialImagingPlatePosition.y = min(
            1.94,
            max(0.92, origin.y - Float(translation.height) * 0.00075)
        )
    }

    func endSpatialImagingPlateDrag() {
        spatialImagingDragOrigin = nil
    }

    func beginSpatialImagingPlateScale() {
        guard audienceLens == .clinician, spatialImagingPlateVisible else { return }
        spatialImagingScaleOrigin = spatialImagingPlateScale
    }

    func scaleSpatialImagingPlate(by magnification: CGFloat) {
        guard audienceLens == .clinician,
              spatialImagingPlateVisible,
              let origin = spatialImagingScaleOrigin else { return }
        spatialImagingPlateScale = min(
            2.5,
            max(0.55, origin * Float(magnification))
        )
    }

    func endSpatialImagingPlateScale() {
        spatialImagingScaleOrigin = nil
    }

    func resetSpatialImagingPlateTransform() {
        guard audienceLens == .clinician, spatialImagingPlateVisible else { return }
        spatialImagingPlatePosition = Self.spatialImagingDefaultPlatePosition
        spatialImagingPlateScale = 1
        spatialImagingFocusActive = false
        spatialImagingFocusReturnPosition = nil
        spatialImagingFocusReturnScale = nil
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
    }

    /// Brings the actual placed plate to a stable reading position in the
    /// room, then restores the presenter's prior transform. This deliberately
    /// avoids opening a second generic window that could be mistaken for the
    /// local image the presenter chose.
    func toggleSpatialImagingFocus() {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible else {
            StrokeImagingInteractionTrace.record(.focusRejected)
            return
        }

        if spatialImagingFocusActive {
            spatialImagingPlatePosition = spatialImagingFocusReturnPosition
                ?? Self.spatialImagingDefaultPlatePosition
            spatialImagingPlateScale = spatialImagingFocusReturnScale ?? 1
            spatialImagingFocusActive = false
            spatialImagingFocusReturnPosition = nil
            spatialImagingFocusReturnScale = nil
        } else {
            spatialImagingFocusReturnPosition = spatialImagingPlatePosition
            spatialImagingFocusReturnScale = spatialImagingPlateScale
            spatialImagingPlatePosition = [0, 1.62, -0.90]
            spatialImagingPlateScale = 1.12
            spatialImagingFocusActive = true
        }
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
        StrokeImagingInteractionTrace.record(spatialImagingFocusActive ? .focused : .placed)
    }

    private func cancelSpatialImagingFocus(resetTransform: Bool) {
        spatialImagingFocusActive = false
        spatialImagingFocusReturnPosition = nil
        spatialImagingFocusReturnScale = nil
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
        if resetTransform {
            spatialImagingPlatePosition = Self.spatialImagingDefaultPlatePosition
            spatialImagingPlateScale = 1
        }
    }

    /// Enables temporary markup directly on the placed generic atlas image.
    /// This uses ordinary targeted pinch-drag input; it records neither gaze
    /// nor patient data and never writes into the underlying image asset.
    func toggleSpatialImagingAnnotation() {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible else { return }
        spatialImagingAnnotationEnabled.toggle()
        activeSpatialImagingInkStrokeID = nil
    }

    func beginSpatialImagingInk(at point: CGPoint) {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingPlateVisible,
              spatialImagingAnnotationEnabled else { return }
        let stroke = StrokeSpatialInkStroke(
            id: UUID(),
            points: [clampedInkPoint(point)]
        )
        spatialImagingInkStrokes.append(stroke)
        activeSpatialImagingInkStrokeID = stroke.id
    }

    func continueSpatialImagingInk(at point: CGPoint) {
        guard let id = activeSpatialImagingInkStrokeID,
              let index = spatialImagingInkStrokes.firstIndex(where: { $0.id == id }) else { return }
        let next = clampedInkPoint(point)
        if let previous = spatialImagingInkStrokes[index].points.last,
           hypot(next.x - previous.x, next.y - previous.y) < 0.006 {
            return
        }
        spatialImagingInkStrokes[index].points.append(next)
    }

    func endSpatialImagingInk(at point: CGPoint) {
        continueSpatialImagingInk(at: point)
        activeSpatialImagingInkStrokeID = nil
    }

    func undoSpatialImagingInk() {
        guard audienceLens == .clinician else { return }
        activeSpatialImagingInkStrokeID = nil
        if !spatialImagingInkStrokes.isEmpty {
            spatialImagingInkStrokes.removeLast()
        }
    }

    func clearSpatialImagingInk() {
        guard audienceLens == .clinician else { return }
        activeSpatialImagingInkStrokeID = nil
        spatialImagingInkStrokes = []
    }

    func beginSpatialImagingComparisonInk(at point: CGPoint) {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialImagingComparisonDetached,
              spatialImagingAnnotationEnabled else { return }
        let stroke = StrokeSpatialInkStroke(
            id: UUID(),
            points: [clampedInkPoint(point)]
        )
        spatialImagingComparisonInkStrokes.append(stroke)
        activeSpatialImagingComparisonInkStrokeID = stroke.id
    }

    func continueSpatialImagingComparisonInk(at point: CGPoint) {
        guard let id = activeSpatialImagingComparisonInkStrokeID,
              let index = spatialImagingComparisonInkStrokes.firstIndex(where: { $0.id == id }) else { return }
        let next = clampedInkPoint(point)
        if let previous = spatialImagingComparisonInkStrokes[index].points.last,
           hypot(next.x - previous.x, next.y - previous.y) < 0.006 {
            return
        }
        spatialImagingComparisonInkStrokes[index].points.append(next)
    }

    func endSpatialImagingComparisonInk(at point: CGPoint) {
        continueSpatialImagingComparisonInk(at: point)
        activeSpatialImagingComparisonInkStrokeID = nil
    }

    func undoSpatialImagingComparisonInk() {
        guard audienceLens == .clinician else { return }
        activeSpatialImagingComparisonInkStrokeID = nil
        if !spatialImagingComparisonInkStrokes.isEmpty {
            spatialImagingComparisonInkStrokes.removeLast()
        }
    }

    func clearSpatialImagingComparisonInk() {
        guard audienceLens == .clinician else { return }
        activeSpatialImagingComparisonInkStrokeID = nil
        spatialImagingComparisonInkStrokes = []
    }

    private func resetSpatialImagingAnnotation() {
        spatialImagingAnnotationEnabled = false
        activeSpatialImagingInkStrokeID = nil
        spatialImagingInkStrokes = []
        activeSpatialImagingComparisonInkStrokeID = nil
        spatialImagingComparisonInkStrokes = []
        spatialImagingPrimaryContextTitle = nil
        spatialImagingPrimaryContextBody = nil
        spatialImagingComparisonContextTitle = nil
        spatialImagingComparisonContextBody = nil
    }

    var selectedPointNoteIsPinned: Bool {
        guard let selectedPointEntityName else { return false }
        return spatialAnnotations.contains { $0.sourceEntityName == selectedPointEntityName }
    }

    /// Pins the selected authored point explanation into the clinician's
    /// shared spatial workspace. Three notes are enough for comparison while
    /// preventing the room from becoming a wall of floating windows.
    func pinSelectedPointNote() {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              let sourceEntityName = selectedPointEntityName,
              let title = selectedPointLabel else { return }

        if spatialAnnotations.contains(where: { $0.sourceEntityName == sourceEntityName }) {
            return
        }

        if spatialAnnotations.count == 3 {
            spatialAnnotations.removeFirst()
        }
        let slots: [SIMD3<Float>] = [
            [-0.66, 1.22, -0.88],
            [-0.66, 0.96, -0.88],
            [-0.32, 0.96, -0.88]
        ]
        let annotation = StrokeSpatialAnnotation(
            id: sourceEntityName,
            sourceEntityName: sourceEntityName,
            title: title,
            body: spatialAnnotationBody(for: title),
            position: slots[spatialAnnotations.count]
        )
        spatialAnnotations.append(annotation)
    }

    func removeSpatialAnnotation(id: String) {
        spatialAnnotations.removeAll { $0.id == id }
        spatialAnnotationDragOrigins[id] = nil
    }

    func beginSpatialAnnotationDrag(id: String) {
        guard audienceLens == .clinician,
              let annotation = spatialAnnotations.first(where: { $0.id == id }) else { return }
        spatialAnnotationDragOrigins[id] = annotation.position
    }

    func moveSpatialAnnotation(id: String, translation: CGSize) {
        guard audienceLens == .clinician,
              let origin = spatialAnnotationDragOrigins[id],
              let index = spatialAnnotations.firstIndex(where: { $0.id == id }) else { return }
        spatialAnnotations[index].position.x = min(
            0.76,
            max(-0.76, origin.x + Float(translation.width) * 0.00075)
        )
        spatialAnnotations[index].position.y = min(
            1.98,
            max(0.98, origin.y - Float(translation.height) * 0.00075)
        )
    }

    func endSpatialAnnotationDrag(id: String) {
        spatialAnnotationDragOrigins[id] = nil
    }

    /// Reopens the anatomy relationship owned by a pinned note. The note is a
    /// navigation aid, never a new finding or independent medical assertion.
    func locateSpatialAnnotation(id: String) {
        guard audienceLens == .clinician,
              let annotation = spatialAnnotations.first(where: { $0.id == id }) else { return }
        selectPoint(entityName: annotation.sourceEntityName, label: annotation.title)
    }

    func toggleSpatialInk() {
        guard audienceLens == .clinician, spatialPhase == .explanation else { return }
        spatialInkVisible.toggle()
        activeSpatialInkStrokeID = nil
    }

    func finishSpatialInk() {
        spatialInkVisible = false
        activeSpatialInkStrokeID = nil
    }

    func beginSpatialInk(at point: CGPoint) {
        guard audienceLens == .clinician,
              spatialPhase == .explanation,
              spatialInkVisible else { return }
        let stroke = StrokeSpatialInkStroke(id: UUID(), points: [clampedInkPoint(point)])
        spatialInkStrokes.append(stroke)
        activeSpatialInkStrokeID = stroke.id
    }

    func continueSpatialInk(at point: CGPoint) {
        guard let id = activeSpatialInkStrokeID,
              let index = spatialInkStrokes.firstIndex(where: { $0.id == id }) else { return }
        let next = clampedInkPoint(point)
        if let previous = spatialInkStrokes[index].points.last,
           hypot(next.x - previous.x, next.y - previous.y) < 0.006 {
            return
        }
        spatialInkStrokes[index].points.append(next)
    }

    func endSpatialInk(at point: CGPoint) {
        continueSpatialInk(at: point)
        activeSpatialInkStrokeID = nil
    }

    func undoSpatialInk() {
        guard audienceLens == .clinician else { return }
        activeSpatialInkStrokeID = nil
        if !spatialInkStrokes.isEmpty {
            spatialInkStrokes.removeLast()
        }
    }

    func clearSpatialInk() {
        guard audienceLens == .clinician else { return }
        activeSpatialInkStrokeID = nil
        spatialInkStrokes = []
    }

    private func clampedInkPoint(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: min(1, max(0, point.x)),
            y: min(1, max(0, point.y))
        )
    }

    private func spatialAnnotationBody(for label: String) -> String {
        switch label {
        case "Example affected area":
            "Generic example only—not a scan or measured injury."
        case "Nearby brain tissue":
            "Nearby tissue stays visible so the explanation keeps context."
        case "Brain surface":
            "Surface orientation only; no incision or access site is planned."
        case "Opposite-side context":
            "A comparison reference—not a claim of normal function."
        case "Single neuron · schematic reference":
            "Generic schematic only. Not patient tissue, a recording, or a measurement."
        case "Blood supply approaches":
            "Follow the route toward the brain: direction only, not speed or volume."
        case "Arteries branch":
            "Branches distribute supply; this generic map is not patient-specific."
        case "Example blockage":
            "A teaching clot interrupts the route; motion is qualitative—not CFD."
        case "Flow beyond the blockage changes":
            "Fewer cues continue beyond the example blockage; no perfusion value is inferred."
        case "Affected territory":
            "The highlighted territory explains risk—not prognosis or measured damage."
        case "Generic craniotomy teaching story":
            "Layer relationship only—not an access site, surgical plan, or rehearsal."
        default:
            "Generic teaching reference—not a patient scan or measurement."
        }
    }

    /// Toggles the already-selected point's related spatial teaching object.
    /// Point selection opens the matching reference; this remains the explicit,
    /// reversible Hide/Show action and never infers a viewer preference.
    func toggleSelectedPointReference() {
        guard spatialPhase == .explanation,
              selectedPointEntityName != nil else { return }

        if procedureStep == .discussCare && !careViewPermissionGranted {
            return
        }
        selectedPointReferenceExpanded.toggle()
        teachingImagingLens = teachingLens(for: selectedPointLabel)
        teachingImagingDrawerVisible = selectedPointReferenceExpanded
    }

    /// Maps a quiet anatomy-attached invitation to one coherent full teaching
    /// structure. This is a generic atlas relationship, never a patient scan.
    func teachingReferenceActionTitle(for label: String? = nil) -> String {
        switch teachingLens(for: label ?? selectedPointLabel) {
        case .affectedVessel: "full arterial tree"
        case .brainSurface: "whole brain surface"
        case .neuron: "single neuron"
        case .internalStructures: "internal structures"
        case .makingRoomPurpose: "layer view"
        }
    }

    /// A single-cell schematic is already legible as a self-contained spatial
    /// object. Keeping a second reference card beside it would repeat the
    /// selected-point explanation rather than add a new relationship.
    var selectedTeachingReferenceNeedsDrawer: Bool {
        teachingImagingLens != .neuron
    }

    /// Explains why the selected invitation owns the complete 3D reference.
    /// The wording stays relational and generic: it does not turn technical
    /// marker samples into approved landmarks or a patient-specific finding.
    func teachingReferenceRelationship(for label: String? = nil) -> String {
        switch label ?? selectedPointLabel {
        case "Example affected area":
            "TISSUE RELATIONSHIP · THIS AREA DEPENDS ON THE VESSEL ROUTE"
        case "Nearby brain tissue":
            "NEARBY TISSUE · CONTEXT OUTSIDE THE SELECTED AREA"
        case "Brain surface":
            "SURFACE · THE BRAIN'S OUTER FOLDED LAYER"
        case "Opposite-side context":
            "CONTEXT · COMPARE THE OTHER SIDE OF THE SAME BRAIN"
        case "Cerebral cortex · generic atlas focus":
            "ATLAS FOCUS · FOLDED OUTER CORTEX IN THE WHOLE BRAIN"
        case "Frontal lobe · generic atlas focus":
            "ATLAS FOCUS · FRONT REGION IN WHOLE-BRAIN CONTEXT"
        case "Parietal lobe · generic atlas focus":
            "ATLAS FOCUS · UPPER REAR REGION IN WHOLE-BRAIN CONTEXT"
        case "Temporal lobe · generic atlas focus":
            "ATLAS FOCUS · SIDE REGION IN WHOLE-BRAIN CONTEXT"
        case "Occipital lobe · generic atlas focus":
            "ATLAS FOCUS · REAR REGION IN WHOLE-BRAIN CONTEXT"
        case let label? where label.hasSuffix("· combined internal atlas context"):
            "ATLAS CONTEXT · COMBINED INTERNAL STRUCTURES + VENTRICLES"
        case "Blood supply approaches":
            "ROUTE · BLOOD APPROACHES THROUGH LARGER ARTERIES"
        case "Arteries branch":
            "BRANCHING · ONE ROUTE DIVIDES INTO SMALLER PATHS"
        case "Example blockage":
            "BLOCKAGE · GENERIC FLOW INTERRUPTION"
        case "Flow beyond the blockage changes":
            "DOWNSTREAM · COMPARE FLOW BEYOND THE BLOCKAGE"
        case "Affected territory":
            "TERRITORY · THIS REGION DEPENDS ON THE UPSTREAM ROUTE"
        case "Generic craniotomy teaching story":
            "LAYERS · SKULL, DURA, AND BRAIN — NOT A SITE PLAN"
        case "Single neuron · schematic reference":
            "SCHEMATIC NEURON · BRANCHES AND ONE QUALITATIVE SIGNAL PATH"
        case nil:
            "GENERIC TEACHING RELATIONSHIP"
        default:
            "GENERIC TEACHING RELATIONSHIP"
        }
    }

    /// A short family-facing explanation of why one quiet point opens a larger
    /// teaching object. It deliberately describes relationships, not findings.
    func teachingReferencePlainSummary(for label: String? = nil) -> String {
        switch label ?? selectedPointLabel {
        case "Example affected area":
            "This area relies on the highlighted vessel route."
        case "Nearby brain tissue":
            "Nearby tissue stays visible so this point is not viewed alone."
        case "Brain surface":
            "The folded outer surface gives this point its whole-brain context."
        case "Opposite-side context":
            "The other side helps with orientation; it is not a diagnostic comparison."
        case "Blood supply approaches":
            "Follow the larger artery as blood approaches this teaching route."
        case "Arteries branch":
            "One larger route divides into smaller arterial paths."
        case "Example blockage":
            "The marker introduces a generic interruption in the flow route."
        case "Flow beyond the blockage changes":
            "Look beyond the interruption to see how the downstream route changes."
        case "Affected territory":
            "This teaching region depends on the upstream vessel route."
        case "Generic craniotomy teaching story":
            "See the skull, protective covering, and brain as separate teaching layers."
        case "Single neuron · schematic reference":
            "One generic cell makes the branching relationship easier to inspect."
        default:
            "The selected point opens its larger teaching context."
        }
    }

    private func teachingLens(for label: String?) -> StrokeTeachingImagingLens {
        if procedureStep == .discussCare { return .makingRoomPurpose }
        return switch label {
        case "Example affected area",
             "Blood supply approaches",
             "Arteries branch",
             "Example blockage",
             "Flow beyond the blockage changes",
             "Affected territory":
            .affectedVessel
        case "Nearby brain tissue", "Brain surface", "Opposite-side context",
             "Cerebral cortex · generic atlas focus",
             "Frontal lobe · generic atlas focus",
             "Parietal lobe · generic atlas focus",
             "Temporal lobe · generic atlas focus",
             "Occipital lobe · generic atlas focus":
            .brainSurface
        case "Single neuron · schematic reference":
            .neuron
        case let label? where label.hasSuffix("· combined internal atlas context"):
            .internalStructures
        case "Generic craniotomy teaching story":
            .makingRoomPurpose
        case nil:
            // No point is selected at this boundary; preserve the quiet
            // generic surface view rather than guessing at a vascular claim.
            .brainSurface
        default:
            .brainSurface
        }
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
        if accessLayerStudyEntryPending {
            accessLayerStudyEntryPending = false
            pendingConsentStep = nil
            pendingPresenterTeachingBeat = nil
            startAccessLayerStudy()
            return
        }
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
        accessLayerStudyEntryPending = false
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

    /// System sensory feedback is deliberately reserved for a confirmed,
    /// visible spatial-control action. Repeated pinches inside this short
    /// interval remain visually functional but do not stack feedback.
    func registerInteractionFeedback() {
        let now = Date()
        guard now.timeIntervalSince(lastInteractionFeedbackAt) >= 0.22 else { return }
        lastInteractionFeedbackAt = now
        interactionFeedbackToken &+= 1
    }

    /// Narration is an opt-in family teaching aid. Doctor-presenter mode has
    /// no synthesized voice because the clinician is already speaking.
    func setNarrationEnabled(_ enabled: Bool) {
        guard audienceLens == .family else {
            narrationEnabled = false
            familyNarrationPromptVisible = false
            activeFamilyNarrationText = nil
            familyNarrationTranscriptVisible = false
            return
        }
        if !enabled {
            narrationEnabled = false
            familyNarrationPromptVisible = false
            activeFamilyNarrationText = nil
            familyNarrationTranscriptVisible = false
        } else if selectedPointEntityName != nil {
            // The control arms the explicit point-level invitation. It never
            // speaks the timeline or starts audio by itself.
            familyNarrationPromptVisible = true
        } else {
            narrationEnabled = false
            familyNarrationPromptVisible = false
        }
    }

    /// Reports only whether the app's configured Realtime proxy exists. It is
    /// not a network-success claim and never starts a microphone or recording.
    func setNarrationSetupAvailable(_ available: Bool) {
        narrationSetupAvailable = available
    }

    /// A deliberate Play audio action is the only path from a selected
    /// discovery point to narrated audio. The line remains authored, generic,
    /// and non-diagnostic.
    func acceptFamilyNarrationPrompt() {
        guard audienceLens == .family,
              narrationSetupAvailable,
              selectedPointEntityName != nil,
              let selectedPointLabel else { return }
        narrationEnabled = true
        familyNarrationPromptVisible = false
        familyNarrationTranscriptVisible = false
        activeFamilyNarrationText = familyNarrationText(for: selectedPointLabel)
    }

    /// A missing local voice proxy must not turn the point invitation into a
    /// disabled control. The learner can read the exact same authored line,
    /// silently and locally, without changing anatomy or starting recording.
    func showFamilyNarrationTranscript() {
        guard audienceLens == .family,
              !narrationSetupAvailable,
              selectedPointEntityName != nil,
              let selectedPointLabel else { return }
        narrationEnabled = false
        familyNarrationPromptVisible = false
        activeFamilyNarrationText = familyNarrationText(for: selectedPointLabel)
        familyNarrationTranscriptVisible = true
    }

    /// Closing the optional explanation is a real no-op: it stops any point
    /// narration without changing anatomy, timeline, or lesson state.
    func dismissFamilyNarrationPrompt() {
        guard audienceLens == .family else { return }
        narrationEnabled = false
        familyNarrationPromptVisible = false
        activeFamilyNarrationText = nil
        familyNarrationTranscriptVisible = false
    }

    private func familyNarrationText(for label: String) -> String {
        switch label {
        case "Example affected area":
            "This highlighted area is a generic teaching example. It shows how a brain region can depend on an upstream vessel, not what happened in a particular person's scan."
        case "Nearby brain tissue":
            "The nearby folds stay visible for context. A stroke explanation should keep the affected area and the surrounding brain distinct."
        case "Brain surface":
            "This is the folded outer surface of the brain. The folds create more surface area, but this model does not mark a surgical site."
        case "Opposite-side context":
            "The other side is shown as an orientation reference. It is not a claim that one side is normal or that function can be predicted here."
        case "Blood supply approaches":
            "The larger arteries approach the brain before dividing. The moving cues show direction only, not measured speed, pressure, or volume."
        case "Arteries branch":
            "One larger route divides into smaller branches that reach different territories. This is a generic arterial map, not a patient-specific vessel scan."
        case "Example blockage":
            "This teaching blockage interrupts one route. Less flow continues beyond it in the animation, but no perfusion value or treatment decision is calculated."
        case "Flow beyond the blockage changes":
            "Beyond the example blockage, fewer flow cues continue. That helps explain the relationship without predicting injury or outcome."
        case "Affected territory":
            "This territory helps connect a vessel route to the tissue it supplies. It explains a relationship, not measured damage or prognosis."
        case "Generic craniotomy teaching story":
            "This calm layer view separates skull, protective covering, and brain to explain the making-room concept. It is not an access plan or surgical instruction."
        case "Single neuron · schematic reference":
            "Think of this as a tree-like brain cell: branches take in messages and one long fiber passes a signal on. The colors show a teaching path, not a recording."
        case let label where label.hasSuffix("· generic atlas focus"):
            "This lit focus locates \(label.replacingOccurrences(of: " · generic atlas focus", with: "")) within a complete generic brain. It is an orientation aid, not a patient scan or a precise functional boundary."
        case let label where label.hasSuffix("· combined internal atlas context"):
            "This view shows the complete combined internal-structures mesh and ventricular system available in this generic atlas. It helps with orientation, but it does not separately outline \(label.replacingOccurrences(of: " · combined internal atlas context", with: "")) or represent a patient scan."
        default:
            "This is a generic teaching reference. It can help orient the next question, but it is not a patient scan, measurement, or diagnosis."
        }
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

    /// Suggestions are a finite, authored exploration set. Spatial actions
    /// move to another reviewed teaching point; boundary actions pause and
    /// explain what the generic model cannot establish. Neither path calls a
    /// medical model or infers a diagnosis from the wearer's focus.
    func selectFamilyQuestion(_ question: String) {
        guard audienceLens == .family,
              familyQuestionSuggestions.contains(question) else { return }
        selectedFamilyQuestion = question

        if let destination = familyExploreDestination(for: question),
           let point = destination.field.lessonPoints.first(where: { $0.index == destination.pointIndex }) {
            clarificationRequested = false
            requestedPause = false
            pointField = destination.field
            selectLessonPoint(point)
            return
        }

        if question == "Enter the brain at room scale" {
            clarificationRequested = false
            requestedPause = false
            withAnimation(.easeInOut(duration: 0.58)) {
                spatialZoom = max(spatialZoom, 3.2)
            }
            return
        }

        clarificationRequested = true
        requestedPause = true
    }

    /// Returns only authored point destinations. This makes the left rail a
    /// spatial navigation surface instead of a second text-answer feed.
    func familyExploreDestination(
        for action: String
    ) -> (field: StrokePointField, pointIndex: Int)? {
        switch action {
        case "Start with one glowing point":
            (.regions, 0)
        case "Follow one vessel story", "Follow this vessel route":
            (.procedure, 0)
        case "Locate this in the whole brain":
            (.regions, 2)
        case "Keep nearby anatomy in view":
            (.regions, 1)
        case "Compare before and beyond the blockage":
            (.procedure, 3)
        case "Unfold the teaching layers":
            (.craniotomy, 0)
        default:
            nil
        }
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
            "Explore the protective layers."
        case .inspectOcclusion:
            "Trace supply, blockage, and the tissue beyond."
        case .discussCare:
            "Review what generic access can—and cannot—show."
        }
    }

    var familyQuestionSuggestions: [String] {
        guard let selectedPointLabel else {
            return ["Start with one glowing point"]
        }

        if selectedPointLabel == "Generic craniotomy teaching story" {
            return [
                "Unfold the teaching layers",
                "Keep the access view generic",
                "Review what is not simulated"
            ]
        }

        if selectedPointEntityName?.hasPrefix(StrokePointField.procedure.entityPrefix) == true {
            return [
                "Follow this vessel route",
                "Compare before and beyond the blockage",
                "See what this model cannot measure"
            ]
        }

        return [
            "Locate this in the whole brain",
            "Keep nearby anatomy in view",
            "See what this model cannot conclude"
        ]
    }

    /// Only a boundary action opens a clarification card. Spatial actions
    /// navigate directly to their point and matching 3D reference, so the
    /// rail does not duplicate the teaching object with another text answer.
    var selectedFamilyQuestionAnswer: String? {
        guard let question = selectedFamilyQuestion else { return nil }
        let lowercasedQuestion = question.lowercased()

        if lowercasedQuestion.contains("cannot measure") || lowercasedQuestion.contains("cannot conclude") {
            return "This generic teaching model shows relationships and direction. It does not measure flow, identify a diagnosis, or predict an outcome."
        }
        if lowercasedQuestion.contains("access view generic") || lowercasedQuestion.contains("not simulated") {
            return "The access story separates generic layers to support explanation. It is not a site plan, operative rehearsal, or treatment recommendation."
        }
        return nil
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
        // The first successful point interaction is stronger orientation than
        // any helper copy. Retire the transient cue before revealing the local
        // explanation and its matching full 3D teaching reference.
        dismissFamilyDiscoveryHint()
        if pointField == .craniotomy {
            // The access point opens the six-checkpoint clinician story rather
            // than the generic vessel miniature. The point stays attached to
            // the authored access region while the top timeline changes only
            // reversible presentation states.
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
            if audienceLens == .family {
                activeFamilyNarrationText = nil
                familyNarrationTranscriptVisible = false
                familyNarrationPromptVisible = true
            }
            // The access story shares the same point-first disclosure rule as
            // vascular and surface cues. Its only extra condition is the
            // existing explicit, reversible non-graphic permission boundary.
            selectedPointReferenceExpanded = careViewPermissionGranted
            teachingImagingLens = .makingRoomPurpose
            teachingImagingDrawerVisible = careViewPermissionGranted
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
                spatialZoom = max(spatialZoom, isBlockagePoint ? Self.selectedBlockageExteriorZoom : 1.58)
                if isBlockagePoint {
                    orbit = Self.selectedBlockageExteriorOrbit
                }
            }
        }
        selectedPointEntityName = entityName
        selectedPointLabel = label
        if audienceLens == .family {
            // Point selection reveals an invitation, never audio. A separate
            // Yes action is required before the Realtime request can begin.
            activeFamilyNarrationText = nil
            familyNarrationTranscriptVisible = false
            familyNarrationPromptVisible = true
        }
        // Every anatomy-attached point owns one matching spatial reference.
        // A direct gaze-and-pinch discloses it immediately for both roles;
        // the existing Hide action makes the disclosure reversible without
        // turning the right field into a parallel image browser.
        selectedPointReferenceExpanded = true
        switch procedureStep {
        case .chooseCase:
            teachingImagingDrawerVisible = false
        case .inspectOcclusion:
            teachingImagingLens = teachingLens(for: label)
            teachingImagingDrawerVisible = true
        case .discussCare:
            teachingImagingLens = .makingRoomPurpose
            teachingImagingDrawerVisible = careViewPermissionGranted
        }
        // A lesson point should reveal motion, not freeze it. Family pause is a
        // separate, reversible control.
        requestedPause = false
    }

    /// Advances through the five authored vascular relationships while keeping
    /// the complete arterial teaching reference in the right spatial field.
    /// This is a route-reading interaction, not a treatment sequence: it never
    /// removes the example blockage or implies that an intervention succeeded.
    func traceProcedureRoute(by offset: Int) {
        guard spatialPhase == .explanation,
              pointField == .procedure,
              !StrokePointField.procedure.lessonPoints.isEmpty else { return }

        let points = StrokePointField.procedure.lessonPoints
        let currentIndex = selectedProcedurePointIndex
            ?? StrokePointField.procedure.defaultLessonPointIndex
        let nextIndex = (currentIndex + offset % points.count + points.count) % points.count
        let point = points[nextIndex]
        selectPoint(
            entityName: "\(StrokePointField.procedure.entityPrefix)\(point.index)",
            label: point.fullTitle
        )

        // A repeated route step should not repeatedly interrupt discovery with
        // the optional voice invitation. A fresh direct point pinch may offer
        // it again; the route trace itself stays visual and quiet.
        if audienceLens == .family {
            narrationEnabled = false
            familyNarrationPromptVisible = false
            activeFamilyNarrationText = nil
            familyNarrationTranscriptVisible = false
        }
    }

    var selectedProcedurePointIndex: Int? {
        guard let selectedPointEntityName,
              selectedPointEntityName.hasPrefix(StrokePointField.procedure.entityPrefix)
        else { return nil }
        return Int(selectedPointEntityName.dropFirst(StrokePointField.procedure.entityPrefix.count))
    }

    var procedureRouteProgressLabel: String {
        let ordinal = (selectedProcedurePointIndex
            ?? StrokePointField.procedure.defaultLessonPointIndex) + 1
        return "\(ordinal) OF \(StrokePointField.procedure.lessonPoints.count)"
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
        endAccessLayerStudy()
        selectedPointEntityName = nil
        selectedPointLabel = nil
        selectedPointReferenceExpanded = false
        teachingImagingDrawerVisible = false
        familyNarrationPromptVisible = false
        activeFamilyNarrationText = nil
        familyNarrationTranscriptVisible = false
    }

    func rotateSpatialView(delta: CGSize) {
        guard !accessLayerStudy.isActive else { return }
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
        guard !accessLayerStudy.isActive else { return }
        // A wide but finite numerical envelope supports tabletop, life-size,
        // and room-scale inspection. The app never teleports on scale alone;
        // a future interior-brain experience can use the explicit threshold.
        spatialZoom = min(max(spatialZoom * ratio, 0.18), 8.0)
    }

    var isInteriorPortalAvailable: Bool { spatialZoom >= 3.2 }

    func enterInternalBrainMode() {
        guard isInteriorPortalAvailable else { return }
        familyAtlasCerebellumJourneyRequested = false
        internalBrainModeActive = true
        requestedPause = false
        activeFamilyNarrationText = nil
        familyNarrationTranscriptVisible = false
        familyNarrationPromptVisible = false
    }

    /// The selected example blockage is also an explicit spatial doorway.
    /// Unlike magnification alone, this action is a deliberate wearer choice
    /// and opens a separate generic lesson; it does not simulate diagnosis,
    /// vessel cutting, treatment selection, or a treatment outcome.
    func enterSelectedBlockageLesson() {
        guard pointField == .procedure,
              selectedPointEntityName == "\(StrokePointField.procedure.entityPrefix)2"
        else { return }
        spatialZoom = max(spatialZoom, 3.2)
        enterInternalBrainMode()
    }

    /// The Brainstem + cerebellum Atlas chapter can hand off to the dedicated
    /// generic cerebellum observatory. It is intentionally a separate scene:
    /// the outer model remains a combined internal reference, while the
    /// observatory can show folded form, vessel paths, and qualitative flow
    /// without claiming patient anatomy, histology, or diagnostic detail.
    func enterFamilyAtlasCerebellumJourney() {
        guard audienceLens == .family,
              spatialPhase == .explanation,
              familyBrainAtlasChapter == .brainstemAndCerebellum
        else { return }

        spatialZoom = max(spatialZoom, 3.2)
        enterInternalBrainMode()
        familyAtlasCerebellumJourneyRequested = true
    }

    func leaveInternalBrainMode() {
        internalBrainModeActive = false
        familyAtlasCerebellumJourneyRequested = false
        requestedPause = false
    }

    /// Returns a point-launched interior lesson to the same generic outer
    /// explanation, using its intentional reading pose rather than retaining
    /// the larger portal-entry scale. Other interior entries keep their own
    /// exterior pose unchanged.
    func returnToExteriorLessonContext() {
        if selectedPointEntityName == "\(StrokePointField.procedure.entityPrefix)2" {
            withAnimation(.easeInOut(duration: 0.42)) {
                spatialZoom = Self.selectedBlockageExteriorZoom
                orbit = Self.selectedBlockageExteriorOrbit
            }
        }
        leaveInternalBrainMode()
    }

    func resetSpatialView() {
        spatialZoom = 1
        internalBrainModeActive = false
        familyAtlasCerebellumJourneyRequested = false
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
        if audienceLens == .clinician, discussion == .medicineReview {
            selectedScholarReferenceCategory = .medications
        }
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
        accessLayerMotionTask?.cancel()
        selectedClinicianTool = tool
        if accessLayerStudy.isActive { return }
        switch tool {
        case .focus:
            break
        case .transparency:
            setAnatomyPresentation(.transparent)
        case .layerReveal:
            present(step: .discussCare)
        case .forceps, .cranialDrill, .endovascularSet:
            // Display-only teaching props until specialist review defines a
            // safe interaction. Selection never cuts or modifies anatomy.
            break
        }
    }

    func selectEndovascularConcept(_ concept: StrokeEndovascularConcept) {
        guard audienceLens == .clinician else { return }
        selectedClinicianTool = .endovascularSet
        selectedEndovascularConcept = concept
        clinicianDeviceInspectionYaw = 0
        clinicianDeviceStudyBeat = .overview
    }

    func advanceEndovascularConcept() {
        guard audienceLens == .clinician,
              selectedClinicianTool == .endovascularSet else { return }
        let concepts = StrokeEndovascularConcept.allCases
        guard let index = concepts.firstIndex(of: selectedEndovascularConcept) else { return }
        selectedEndovascularConcept = concepts[(index + 1) % concepts.count]
        clinicianDeviceInspectionYaw = 0
        clinicianDeviceStudyBeat = .overview
    }

    func advanceClinicianDeviceStudyBeat() {
        guard audienceLens == .clinician,
              selectedClinicianTool == .endovascularSet else { return }
        let beats = StrokeClinicianDeviceStudyBeat.allCases
        guard let index = beats.firstIndex(of: clinicianDeviceStudyBeat) else { return }
        clinicianDeviceStudyBeat = beats[(index + 1) % beats.count]
    }

    func rotateClinicianDeviceInspection(delta: CGSize) {
        guard audienceLens == .clinician,
              selectedClinicianTool == .endovascularSet else { return }
        let fullTurn = Float.pi * 2
        clinicianDeviceInspectionYaw = (
            clinicianDeviceInspectionYaw + Float(delta.width) * 0.006
        ).truncatingRemainder(dividingBy: fullTurn)
    }

    // MARK: - Deliberate, non-operative access-layer interaction

    func resolveAccessLayerStudyAvailability(_ available: Bool, viewingOrbit: SIMD2<Float>? = nil) {
        accessLayerStudyAssetsAvailable = available
        if let viewingOrbit { accessLayerStudyOrbit = viewingOrbit }
        if !available { endAccessLayerStudy() }
        if available, let opened = pendingAccessLayerStudyProofOpen {
            pendingAccessLayerStudyProofOpen = nil
            startAccessLayerStudy()
            moveAccessStudyLayer(to: 1, reduceMotion: true)
            selectAccessStudyLayer(.dura)
            moveAccessStudyLayer(to: 1, reduceMotion: true)
            if !opened { resetAccessLayerStudy() }
        }
    }

    func startAccessLayerStudy() {
        guard audienceLens == .clinician, spatialPhase == .explanation,
              accessLayerStudyAssetsAvailable, pointField == .craniotomy else { return }
        guard careViewPermissionGranted else {
            accessLayerStudyEntryPending = true
            isConsentPromptVisible = true
            return
        }
        closeReferenceWorkspace()
        cancelSpatialImagingFocus(resetTransform: true)
        spatialImagingPlateVisible = false
        accessLayerMotionTask?.cancel()
        accessLayerDragOrigin = nil
        if !accessLayerStudy.isActive {
            accessStudyReturnState = (
                anatomyPresentation, cortexOpacity, anatomyViewpoint, orbit, spatialZoom,
                requestedPause, selectedClinicianTool, clinicianToolKitVisible
            )
        }
        accessLayerStudy.start()
        selectedClinicianTool = .forceps
        clinicianToolKitVisible = true
        teachingImagingDrawerVisible = false
        selectedPointReferenceExpanded = false
        requestedPause = true
        questionPlacementArmed = false
        spatialInkVisible = false
        anatomyPresentation = .assembled
        cortexOpacity = 0.92
        anatomyViewpoint = .lateralB
        orbit = accessLayerStudyOrbit
        spatialZoom = 0.92
    }

    func selectAccessStudyLayer(_ layer: StrokeAccessStudyLayer) {
        accessLayerMotionTask?.cancel()
        accessLayerDragOrigin = nil
        accessLayerStudy.select(layer)
    }

    func dragAccessStudyLayer(at position: SIMD3<Float>, along travel: SIMD3<Float>) {
        guard audienceLens == .clinician, selectedClinicianTool == .forceps,
              accessLayerStudy.canMoveSelectedLayer else { return }
        accessLayerMotionTask?.cancel()
        let travelSquared = travel.x * travel.x + travel.y * travel.y + travel.z * travel.z
        guard travelSquared > 0.000_001 else { return }
        if accessLayerDragOrigin == nil {
            accessLayerDragOrigin = (position, accessLayerStudy.selectedProgress)
        }
        guard let origin = accessLayerDragOrigin else { return }
        let delta = position - origin.position
        let along = (delta.x * travel.x + delta.y * travel.y + delta.z * travel.z) / travelSquared
        accessLayerStudy.move(to: origin.progress + along)
    }

    func finishAccessStudyDrag() {
        accessLayerDragOrigin = nil
    }

    func toggleAccessStudyLayer(reduceMotion: Bool) {
        moveAccessStudyLayer(to: accessLayerStudy.selectedProgress < 0.5 ? 1 : 0, reduceMotion: reduceMotion)
    }

    func moveAccessStudyLayer(to target: Float, reduceMotion: Bool) {
        guard audienceLens == .clinician, selectedClinicianTool == .forceps,
              accessLayerStudy.canMoveSelectedLayer, target.isFinite else { return }
        accessLayerMotionTask?.cancel()
        accessLayerDragOrigin = nil
        let start = accessLayerStudy.selectedProgress
        let target = min(1, max(0, target))
        if reduceMotion {
            accessLayerStudy.move(to: target)
            return
        }
        accessLayerMotionTask = Task { @MainActor [weak self] in
            for frame in 1...30 {
                do { try await Task.sleep(for: .milliseconds(24)) } catch { return }
                guard let self, !Task.isCancelled, self.accessLayerStudy.isActive else { return }
                let t = Float(frame) / 30
                self.accessLayerStudy.move(to: start + (target - start) * t * t * (3 - 2 * t))
            }
        }
    }

    func resetAccessLayerStudy() {
        accessLayerMotionTask?.cancel()
        accessLayerDragOrigin = nil
        accessLayerStudy.reset()
    }

    func endAccessLayerStudy() {
        accessLayerMotionTask?.cancel()
        accessLayerMotionTask = nil
        accessLayerDragOrigin = nil
        accessLayerStudyEntryPending = false
        accessLayerStudy.end()
        if let previous = accessStudyReturnState {
            accessStudyReturnState = nil
            anatomyPresentation = previous.presentation
            cortexOpacity = previous.opacity
            anatomyViewpoint = previous.viewpoint
            orbit = previous.orbit
            spatialZoom = previous.zoom
            requestedPause = previous.paused
            selectedClinicianTool = previous.tool
            clinicianToolKitVisible = previous.kitVisible
        }
    }

    func reset() {
        closeReferenceWorkspace()
        cancelLayerReveal()
        cancelCaseReviewReveal()
        dismissFamilyDiscoveryHint()
        procedureStep = .chooseCase
        audienceLens = .family
        presenterTeachingBeat = .confirmContext
        resetCatalogPresentation()
        isCaseSelected = false
        spatialPhase = .caseLibrary
        selectedFictionalCaseIndex = 0
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
        familyBrainAtlasCueChapter = nil
        selectedPresenterKeyPointIndex = nil
        clearQuestionMarker()
        pointField = .regions
        selectedScholarReferenceCategory = .anatomy
        lessonPointsVisible = true
        teachingImagingDrawerVisible = false
        teachingImagingLens = .affectedVessel
        spatialImagingPlateVisible = false
        spatialImagingComparisonEnabled = false
        spatialImagingReference = .ctGuide
        spatialImagingPlatePosition = Self.spatialImagingDefaultPlatePosition
        spatialImagingPlateScale = 1
        spatialImagingDragOrigin = nil
        spatialImagingScaleOrigin = nil
        resetSpatialImagingAnnotation()
        clearSpatialImagingLocalImage()
        spatialAnnotations = []
        spatialAnnotationDragOrigins = [:]
        spatialInkVisible = false
        spatialInkStrokes = []
        activeSpatialInkStrokeID = nil
        clinicianToolKitVisible = false
        selectedClinicianTool = .focus
        selectedEndovascularConcept = .microcatheter
        clinicianDeviceInspectionYaw = 0
        clinicianDeviceStudyBeat = .overview
        anatomyPresentation = .assembled
        anatomyFocus = .whole
        availableAnatomyFocuses = [.whole]
        anatomyAvailabilityResolved = false
        pendingAnatomyFocus = nil
        anatomyAvailabilityNotice = nil
        anatomyViewpoint = .threeQuarter
        environmentMode = .focusField
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

    /// Deterministic receipt for the first-action cue. Normal use dismisses it
    /// after eight seconds; proof mode holds it so route OCR can verify the
    /// instruction without turning the hint into permanent product UI.
    func prepareFamilyEntryHintProof() {
        prepareFamilyPressureStoryProof()
        showFamilyDiscoveryHint(autoDismiss: false)
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

    /// Deterministic regression receipt: after the wearer leaves a revealed
    /// arterial chapter, the next chapter must invite a new cue instead of
    /// claiming that the previous point belongs to it.
    func prepareFamilyAtlasNextChapterProof() {
        prepareFamilyArterialAtlasFlowProof()
        advanceFamilyBrainAtlasChapter(by: 1)
    }

    /// Deterministic receipt for a deep Atlas chapter at the explicit
    /// room-scale threshold. This stays a generic handoff to a separately
    /// installed journey rather than an assertion about internal patient
    /// anatomy.
    func prepareFamilyAtlasInteriorReadyProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        anatomyPresentation = .transparent
        cortexOpacity = 0.16
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.corpusCallosum)
        revealFamilyBrainAtlasModelCue()
        spatialZoom = 3.2
    }

    /// Proves the bounded in-app reference separately from the optional
    /// room-scale journey. The source asset is one combined internal mesh plus
    /// ventricles, so this route never claims a precise thalamic segmentation.
    func prepareFamilyAtlasInternalReferenceProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        spatialZoom = 1.22
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.thalamus)
        advanceFamilyBrainAtlasDetail(by: 1)
        revealFamilyBrainAtlasModelCue()
    }

    /// Deterministic receipt for the object-first plain-language follow-up on
    /// a combined deep Atlas chapter. The focused ventricular system is a
    /// named source object; it is not a label or segmentation of the chapter
    /// named in the teaching card.
    func prepareFamilyAtlasInternalPlainWordsProof() {
        prepareFamilyAtlasInternalReferenceProof()
        setNarrationSetupAvailable(false)
        showFamilyNarrationTranscript()
    }

    /// Deterministic receipt for the one deep chapter with a dedicated
    /// cerebellum observatory. The route preserves the generic-model boundary
    /// and deliberately begins on a quiet orientation view before the learner
    /// chooses any optional fold or flow reading.
    func prepareFamilyAtlasCerebellumJourneyProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .focusField
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.brainstemAndCerebellum)
        revealFamilyBrainAtlasModelCue()
        enterFamilyAtlasCerebellumJourney()
    }

    /// Deterministic receipt for the Atlas's 3D surface-context handoff. It
    /// starts on the frontal chapter because the selected point has a visible
    /// tether to the outer teaching model rather than implying a deep or
    /// patient-specific landmark.
    func prepareFamilyAtlasSurfaceCueProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        spatialZoom = 1.22
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.frontalLobe)
        advanceFamilyBrainAtlasDetail(by: 1)
        revealFamilyBrainAtlasModelCue()
    }

    /// A second surface receipt proves that Atlas chapters do not reuse the
    /// frontal marker. Temporal context owns a separate side-lobe invitation.
    func prepareFamilyAtlasTemporalCueProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        spatialZoom = 1.22
        familyBrainAtlasVisible = true
        selectFamilyBrainAtlasChapter(.temporalLobe)
        advanceFamilyBrainAtlasDetail(by: 1)
        revealFamilyBrainAtlasModelCue()
    }

    /// Deterministic receipt for the alternate direct-brain entry point. The
    /// state matches a temporal surface hit only after that hit has been
    /// resolved to one reviewed generic Atlas context; it is not a substitute
    /// for physical focus-and-pinch validation.
    func prepareFamilyAtlasDirectSurfacePickProof() {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        // The normal teaching experience opens in Black focus. Keep this
        // receipt in that honest default so it verifies the direct surface
        // pinch against the same high-contrast material presentation a new
        // family learner receives.
        environmentMode = .focusField
        spatialZoom = 1.22
        familyBrainAtlasVisible = true
        selectFamilyAtlasSurfaceContext(atlasPointIndex: 3)
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

    func prepareAccessLayerStudyProof(opened: Bool) {
        prepareClinicianCraniotomyStoryProof()
        environmentMode = .focusField
        pendingAccessLayerStudyProofOpen = opened
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
        // The clinician explicitly selects a neutral field for this proof.
        // `selectAnatomyFocus` itself supplies the live Internal minimum scale,
        // so the route does not depend on a proof-only zoom correction.
        environmentMode = .focusField
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
        selectDetailLevel(.scholar)
        selectPoint(
            entityName: "clinician-region-point-field-point-0",
            label: "Example affected area"
        )
        placeSpatialImagingPlate(.ctGuide)
        spatialImagingPlatePosition = [0.30, 1.43, -0.82]
        spatialImagingPlateScale = 1.06
        spatialImagingComparisonEnabled = true
        spatialImagingAnnotationEnabled = true
        let ring: (CGFloat, CGFloat) -> StrokeSpatialInkStroke = { centerX, radiusX in
            let points = (0...28).map { step -> CGPoint in
                let angle = (Double(step) / 28) * Double.pi * 2
                return CGPoint(
                    x: centerX + cos(angle) * radiusX,
                    y: 0.48 + sin(angle) * 0.15
                )
            }
            return StrokeSpatialInkStroke(id: UUID(), points: points)
        }
        spatialImagingInkStrokes = [
            ring(0.27, 0.10),
            ring(0.73, 0.10),
        ]
    }

    /// A compact, source-aware vascular-study proof. The CTA card remains a
    /// generic teaching schematic and the selected point remains a discussion
    /// cue, not a claim that this image belongs to the fictional case.
    func prepareImagingModalityReferenceProof() {
        prepareMainOverviewProof()
        selectDetailLevel(.scholar)
        selectPoint(
            entityName: "clinician-procedure-point-field-point-2",
            label: "Example blockage"
        )
        placeSpatialImagingPlate(.ctaGuide)
        spatialImagingPlatePosition = [0.54, 1.43, -0.82]
        spatialImagingPlateScale = 1.04
        spatialImagingComparisonEnabled = false
    }

    /// A functional-imaging source-note receipt. PET remains a generic
    /// teaching concept with an explicit public-science source; it is never
    /// presented as a stroke study choice, patient scan, or result.
    func prepareImagingPETTermNoteProof() {
        prepareImagingModalityReferenceProof()
        placeSpatialImagingPlate(.petOverview)
        spatialImagingPlatePosition = [0.54, 1.43, -0.82]
        spatialImagingPlateScale = 1.04
    }

    /// Shows the existing in-space study deck as a compact, vertical index of
    /// structural, vascular, and functional teaching references. It remains
    /// a generic reference picker rather than a patient-imaging workflow.
    func prepareImagingStudyDeckProof() {
        prepareImagingModalityReferenceProof()
    }

    /// Exercises the same state-clearing route as the visible Back control.
    /// The proof intentionally enters an annotated, focused study first so a
    /// clean returned anatomy state cannot be mistaken for a route that never
    /// had a placed study to recover from.
    func prepareImagingReturnToAnatomyProof() {
        prepareImagingModalityReferenceProof()
        spatialImagingAnnotationEnabled = true
        toggleSpatialImagingFocus()
        returnToAnatomyFromSpatialImaging()
    }

    /// Prepares the same placed generic reference used by the automated
    /// deck-to-Back-to-reopen receipt. The attachment performs the timed
    /// sequence only under its proof argument so shipping behavior remains
    /// wholly presenter-driven.
    func prepareImagingReturnReopenProof() {
        prepareImagingModalityReferenceProof()
    }

    /// Prepares the same CTA teaching reference for a source-note-to-Back
    /// recovery receipt. The attachment alone performs the timed transition
    /// under its proof argument; normal source-note navigation stays manual.
    func prepareImagingTermReturnReopenProof() {
        prepareImagingModalityReferenceProof()
    }

    /// Exercises the same memory-only payload used by Files and drag import
    /// with the bundled de-identified CT atlas image. This proves composition,
    /// not access to or handling of a real clinical record.
    func prepareLocalImagingImportProof() {
        prepareMainOverviewProof()
        selectDetailLevel(.scholar)
        guard let ctData = UIImage(named: "StrokeCTTemplate")?.pngData(),
              let mriData = UIImage(named: "StrokeMRITemplate")?.pngData() else { return }
        _ = placeSpatialImagingLocalImage(
            data: ctData,
            displayName: "De-identified CT teaching image.png"
        )
        _ = placeSpatialImagingLocalComparisonImage(
            data: mriData,
            displayName: "De-identified MRI teaching image.png"
        )
        selectSpatialImagingModality(.ct, comparison: false)
        selectSpatialImagingModality(.mri, comparison: true)
        spatialImagingPlatePosition = [0.42, 1.40, -0.68]
        spatialImagingPlateScale = 0.90
        toggleSpatialImagingComparisonSeparation()
        toggleSpatialImagingFocus()
        selectedPointEntityName = "clinician-region-point-field-point-0"
        selectedPointLabel = "Example affected area"
        attachSelectedPointContextToSpatialImaging(comparison: false)
        attachSelectedPointContextToSpatialImaging(comparison: true)
        clearPointSelection()
    }

    /// Deterministic proof of the spatial document layer: one authored note
    /// and one generic image can coexist, move independently, and retain their
    /// point provenance without becoming patient data.
    func prepareSpatialAnnotationProof() {
        prepareMainOverviewProof()
        selectLessonFamily(.procedure)
        selectPoint(
            entityName: "clinician-procedure-point-field-point-2",
            label: "Example blockage"
        )
        pinSelectedPointNote()
        placeSpatialImagingPlate(.ctGuide)
        spatialImagingPlatePosition = [0.46, 1.48, -0.82]
    }

    /// Deterministic composition receipt for the clinician-only spatial ink
    /// overlay. The seeded loop is generic markup around a teaching point, not
    /// an access plan, measurement, or patient-specific contour.
    func prepareSpatialInkProof() {
        prepareMainOverviewProof()
        selectLessonFamily(.procedure)
        selectPoint(
            entityName: "clinician-procedure-point-field-point-2",
            label: "Example blockage"
        )
        spatialInkVisible = true
        let points = (0...36).map { step -> CGPoint in
            let angle = (Double(step) / 36) * Double.pi * 2
            return CGPoint(
                x: 0.61 + cos(angle) * 0.09,
                y: 0.48 + sin(angle) * 0.14
            )
        }
        spatialInkStrokes = [StrokeSpatialInkStroke(id: UUID(), points: points)]
    }

    /// Family-specific receipt for the same point -> spatial teaching object
    /// relationship. This deliberately avoids clinician rails and makes no
    /// claim that the point or the vessel map is a patient image.
    func prepareFamilyTeachingReferenceProof() {
        prepareFamilyAffectedReferenceProof()
    }

    /// The affected-area invitation deliberately opens the complete arterial
    /// dependency reference rather than implying that the tissue cue itself
    /// is a segmented lesion or patient scan.
    func prepareFamilyAffectedReferenceProof() {
        prepareFamilyRegionalReferenceProof(pointIndex: 0, label: "Example affected area")
    }

    /// Receipt for a surface/context point that owns a distinct full 3D
    /// brain-surface object after the Family wearer asks for it.
    func prepareFamilySurfaceReferenceProof() {
        prepareFamilyRegionalReferenceProof(pointIndex: 2, label: "Brain surface")
    }

    /// Deterministic receipt for the no-proxy fallback. It proves that a
    /// selected family point remains useful without starting voice, recording,
    /// or silently accepting narration consent.
    func prepareFamilyReadMoreProof() {
        prepareFamilySurfaceReferenceProof()
        setNarrationSetupAvailable(false)
        showFamilyNarrationTranscript()
    }

    func prepareFamilyNearbyReferenceProof() {
        prepareFamilyRegionalReferenceProof(pointIndex: 1, label: "Nearby brain tissue")
    }

    /// Interaction receipt: the left exploration rail, not a direct proof
    /// setter, changes the active anatomy point and its right-side reference.
    func prepareFamilyExploreNearbyProof() {
        prepareFamilyAffectedReferenceProof()
        selectFamilyQuestion("Keep nearby anatomy in view")
    }

    func prepareFamilyOppositeReferenceProof() {
        prepareFamilyRegionalReferenceProof(pointIndex: 3, label: "Opposite-side context")
    }

    private func prepareFamilyRegionalReferenceProof(pointIndex: Int, label: String) {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        pointField = .regions
        lessonPointsVisible = true
        selectPoint(
            entityName: "clinician-region-point-field-point-\(pointIndex)",
            label: label
        )
    }

    /// Deterministic receipt for a point-led 3D teaching object. The neuron is
    /// a generic schematic in the secondary field, never patient tissue or a
    /// claim about an individual person's neural activity.
    func prepareFamilyNeuronReferenceProof() {
        prepareFamilyRegionalReferenceProof(
            pointIndex: 4,
            label: "Single neuron · schematic reference"
        )
        spatialZoom = 1.18
    }

    /// Deterministic family receipt for the local written fallback. It keeps
    /// the selected schematic neuron in place and shows a shorter, authored
    /// explanation without starting audio, recording, or inferring a need.
    func prepareFamilyNeuronPlainWordsProof() {
        prepareFamilyNeuronReferenceProof()
        setNarrationSetupAvailable(false)
        showFamilyNarrationTranscript()
    }

    /// Receipt for a vascular point that owns the complete registered arterial
    /// tree, presented as generic teaching anatomy rather than a patient map.
    func prepareFamilyArterialReferenceProof() {
        prepareFamilyArterialReferenceProof(
            pointIndex: 2,
            label: "Example blockage"
        )
    }

    /// Comparison receipt: the same complete arterial tree must visibly
    /// localise its upstream supply segment, not merely swap caption text.
    func prepareFamilyArterialSupplyReferenceProof() {
        prepareFamilyArterialReferenceProof(
            pointIndex: 0,
            label: "Blood supply approaches"
        )
    }

    /// Comparison receipt for the branch point's one-to-many route trace.
    func prepareFamilyArterialBranchReferenceProof() {
        prepareFamilyArterialReferenceProof(
            pointIndex: 1,
            label: "Arteries branch"
        )
    }

    /// Comparison receipt: the same complete arterial tree must visibly
    /// localise the downstream relationship beyond the teaching blockage.
    func prepareFamilyArterialBeyondReferenceProof() {
        prepareFamilyArterialReferenceProof(
            pointIndex: 3,
            label: "Flow beyond the blockage changes"
        )
    }

    /// Interaction receipt for a second rail-driven reference transition.
    func prepareFamilyExploreBeyondProof() {
        prepareFamilyArterialReferenceProof()
        selectFamilyQuestion("Compare before and beyond the blockage")
    }

    /// Comparison receipt for the quiet dependency-area cue at the end of the
    /// selected generic route. This is not an infarct or perfusion boundary.
    func prepareFamilyArterialTerritoryReferenceProof() {
        prepareFamilyArterialReferenceProof(
            pointIndex: 4,
            label: "Affected territory"
        )
    }

    /// Deterministic receipt for the second-click route interaction in the
    /// right teaching field: blockage advances to downstream context while the
    /// example blockage remains part of the same generic arterial reference.
    func prepareFamilyVesselRouteTraceProof() {
        prepareFamilyArterialReferenceProof()
        traceProcedureRoute(by: 1)
    }

    /// Deterministic end state for the contextual second scene launched from
    /// the example blockage reference. The internal model owns the rendered
    /// blockage lesson; this state only proves the exterior selection and the
    /// explicit handoff into that scene.
    func prepareFamilyBlockageInteriorProof() {
        prepareFamilyArterialReferenceProof()
        spatialZoom = 3.2
        enterSelectedBlockageLesson()
    }

    /// Uses the same selected example blockage state as the interior proof,
    /// then lets the immersive view exercise its real return handler.
    func prepareFamilyBlockageReturnProof() {
        prepareFamilyBlockageInteriorProof()
    }

    private func prepareFamilyArterialReferenceProof(
        pointIndex: Int,
        label: String
    ) {
        prepareProof(step: .inspectOcclusion)
        audienceLens = .family
        environmentMode = .surroundings
        pointField = .procedure
        lessonPointsVisible = true
        selectPoint(
            entityName: "clinician-procedure-point-field-point-\(pointIndex)",
            label: label
        )
    }

    /// Receipt for the access-story point. This is deliberately a generic,
    /// permission-granted layer relationship—not an operative simulation or
    /// patient-specific procedure plan.
    func prepareFamilyLayerReferenceProof() {
        prepareProof(step: .discussCare)
        audienceLens = .family
        environmentMode = .surroundings
        pointField = .craniotomy
        lessonPointsVisible = true
        selectPoint(
            entityName: "clinician-access-point-field-point-0",
            label: "Generic craniotomy teaching story"
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

    func prepareIntegratedInteriorProof() {
        prepareInteriorHandoffProof()
        enterInternalBrainMode()
    }

    func prepareClinicianToolKitProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        clinicianToolKitVisible = true
        selectedClinicianTool = .endovascularSet
        selectedEndovascularConcept = .microcatheter
        clinicianDeviceInspectionYaw = 0
        clinicianDeviceStudyBeat = .overview
    }

    func prepareClinicianToolKitFullProof() {
        prepareClinicianToolKitProof()
        selectDetailLevel(.scholar)
    }

    func prepareClinicianToolKitMotionProof() {
        prepareClinicianToolKitProof()
        selectDetailLevel(.scholar)
        clinicianDeviceStudyBeat = .approach
    }

    /// Holds the presenter scene in its paused, distraction-reduced state so
    /// the control surface proves both an explicit Resume action and the clean
    /// black environment. This is state/render proof, not wearer reach proof.
    func preparePresenterControlsProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        selectDetailLevel(.scholar)
        environmentMode = .focusField
        requestedPause = true
        anatomyPresentation = .assembled
        pointField = .regions
        lessonPointsVisible = true
        clearPointSelection()
    }

    /// Deterministic receipt for the secondary presentation controls. The
    /// presenter checklist stays language-led while supporting-anatomy choices
    /// remain in the right-side Settings tab.
    func preparePresentationSettingsProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        selectDetailLevel(.scholar)
        environmentMode = .focusField
        anatomyPresentation = .transparent
        cortexOpacity = 0.58
        pointField = .regions
        lessonPointsVisible = true
        clearPointSelection()
        selectScholarReferenceCategory(.teachingModel)
        openReferenceWorkspace(.settings)
        spatialZoom = 1.18
    }

    func prepareReferenceWorkspaceProof(_ workspace: StrokeReferenceWorkspace) {
        preparePresenterControlsProof()
        openReferenceWorkspace(workspace)
    }

    func prepareImagingGalleryProof(layout: StrokeGalleryLayout = .two, returns: Bool = false) {
        preparePresenterControlsProof()
        imagingGallery = StrokeImagingGalleryModel()
        imagingGallery.layout = layout
        openReferenceWorkspace(.imagingGallery)
        if returns {
            let request = imagingGallery.beginImport()
            closeReferenceWorkspace()
            precondition(imagingGallery.pendingImport == nil)
            precondition(imagingGallery.completeImport(request, images: []) == 0)
            precondition(focusedReferenceWorkspace == nil && !spatialImagingFocusActive)
        }
    }

    /// Runtime state proof, not a Files-picker or wearer gesture test. Uses
    /// only bundled research rasters, including an explicitly named local fixture.
    func prepareImagingGalleryPlacementProof(local: Bool = false, returns: Bool = false) {
        prepareImagingGalleryProof()
        var checks = 0
        func check(_ value: Bool) { precondition(value); checks += 1 }
        let step = procedureStep
        let zoom = spatialZoom
        let originalOrbit = orbit
        let points = [CGPoint(x: 0.35, y: 0.45), CGPoint(x: 0.50, y: 0.38), CGPoint(x: 0.65, y: 0.45)]
        let atlasID = imagingGallery.images[0].id
        imagingGallery.appendStroke(points, to: atlasID)
        let pending = imagingGallery.beginImport()
        check(!placeImagingGalleryImage(UUID()))
        check(imagingGallery.pendingImport == pending)
        check(placeImagingGalleryImage(atlasID))
        check(focusedReferenceWorkspace == nil && spatialImagingPlateVisible)
        check(!spatialImagingFocusActive && !teachingImagingDrawerVisible)
        check(spatialImagingGalleryImage?.id == atlasID && spatialImagingLocalImageData == nil)
        check(spatialImagingReference == .ctGuide && spatialImagingGalleryRaster != nil)
        check(spatialImagingInkStrokes.map(\.points) == [points])
        check(imagingGallery.pendingImport == nil && imagingGallery.images.allSatisfy { $0.strokes.isEmpty })
        check(imagingGallery.completeImport(pending, images: []) == 0)
        let placement = spatialImagingPlatePosition
        toggleSpatialImagingFocus()
        toggleSpatialImagingFocus()
        check(spatialImagingPlatePosition == placement && spatialImagingInkStrokes.map(\.points) == [points])
        toggleSpatialImagingAnnotation()
        beginSpatialImagingInk(at: CGPoint(x: 0.1, y: 0.1))
        endSpatialImagingInk(at: CGPoint(x: 0.2, y: 0.2))
        check(spatialImagingInkStrokes.count == 2)
        undoSpatialImagingInk()
        check(spatialImagingInkStrokes.map(\.points) == [points])
        returnToAnatomyFromSpatialImaging()
        check(spatialImagingGalleryImage == nil && spatialImagingInkStrokes.isEmpty && !spatialImagingPlateVisible)
        check(procedureStep == step && spatialZoom == zoom && orbit == originalOrbit)

        openReferenceWorkspace(.imagingGallery)
        let invalid = StrokeGalleryImage(name: "Invalid test fixture", modality: .unspecified, data: Data([1]))
        let invalidRequest = imagingGallery.beginImport()
        check(imagingGallery.completeImport(invalidRequest, images: [invalid]) == 1)
        check(!placeImagingGalleryImage(invalid.id) && focusedReferenceWorkspace == .imagingGallery)
        imagingGallery.remove(invalid.id)
        guard let data = UIImage(named: "StrokeMRITemplate")?.pngData() else { preconditionFailure("Missing MRI research atlas") }
        let fixture = StrokeGalleryImage(name: "MRI atlas local test copy", modality: .unspecified, data: data)
        let request = imagingGallery.beginImport()
        check(imagingGallery.completeImport(request, images: [fixture]) == 1)
        imagingGallery.setModality(.mri, for: fixture.id)
        imagingGallery.appendStroke(points, to: fixture.id)
        check(placeImagingGalleryImage(fixture.id))
        check(spatialImagingLocalImageData == data && spatialImagingLocalImageModality == .mri)
        check(spatialImagingGalleryImage?.name == fixture.name && spatialImagingGalleryImage?.isLocal == true)
        check(spatialImagingInkStrokes.map(\.points) == [points] && imagingGallery.localBytes == 0)
        check(spatialImagingLocalComparisonImageData == nil && !spatialImagingComparisonEnabled)
        if returns || !local {
            returnToAnatomyFromSpatialImaging()
            check(spatialImagingLocalImageData == nil && spatialImagingGalleryImage == nil && spatialImagingInkStrokes.isEmpty)
        }
        if !returns && !local {
            openReferenceWorkspace(.imagingGallery)
            imagingGallery.appendStroke(points, to: atlasID)
            check(placeImagingGalleryImage(atlasID))
        }
        check(returns ? !spatialImagingPlateVisible : spatialImagingPlateVisible)
        check(returns ? spatialImagingGalleryImage == nil : spatialImagingGalleryImage != nil)
        print("IMAGING_GALLERY_PLACEMENT=PASS checks=\(checks) visible=\(spatialImagingPlateVisible)")
    }

    /// Exercise the same exclusive destinations and Back actions as the UI.
    /// The final frame must restore the original anatomy, point and timeline.
    func prepareReferenceReturnProof() {
        preparePresenterControlsProof()
        let originalStep = procedureStep
        let originalOrbit = orbit
        let originalZoom = spatialZoom
        placeSpatialImagingPlate(.ctGuide)
        toggleSpatialImagingFocus()
        openReferenceWorkspace(.medications)
        openReferenceWorkspace(.guides)
        openReferenceWorkspace(.settings)
        // A visual preference must not remove the menu needed to change it.
        selectDetailLevel(.calm)
        closeReferenceWorkspace()
        assert(focusedReferenceWorkspace == nil && !spatialImagingFocusActive)
        assert(!spatialImagingPlateVisible && !teachingImagingDrawerVisible)
        assert(detailLevel == .calm)
        assert(procedureStep == originalStep && orbit == originalOrbit && spatialZoom == originalZoom)
    }

    func prepareImagingRoomProof() {
        preparePresenterControlsProof()
        placeSpatialImagingPlate(.ctGuide)
        toggleSpatialImagingFocus()
        // Study switching must remain inside the focused imaging workspace.
        placeSpatialImagingPlate(.mriGuide)
        placeSpatialImagingPlate(.ctGuide)
        assert(spatialImagingFocusActive && spatialImagingPlateVisible)
    }

    /// Runs the real import/markup/navigation state handlers with a bundled
    /// licensed atlas raster. This does not exercise Files UI or a pinch.
    func prepareImagingImportLifecycleProof(returnToAnatomy: Bool = false) {
        prepareImagingRoomProof()
        guard let imageData = UIImage(named: "StrokeCTTemplate")?.pngData() else {
            preconditionFailure("Import proof needs the bundled licensed CT raster")
        }
        var checks = 0
        func check(_ condition: Bool, _ message: String) {
            precondition(condition, message)
            checks += 1
        }
        func request(_ target: StrokeLocalImageImportTarget = .primary) -> StrokeImagingImportRequest {
            guard let result = beginSpatialImagingImport(target: target) else {
                preconditionFailure("Expected an active imaging import destination")
            }
            return result
        }
        func finish(_ request: StrokeImagingImportRequest, data: Data? = nil) -> Bool {
            completeSpatialImagingImport(request, data: data ?? imageData, displayName: "Open atlas CT.png")
        }

        let beforeBack = request()
        returnToAnatomyFromSpatialImaging()
        check(!finish(beforeBack), "Late import after Back must be rejected")
        check(!spatialImagingPlateVisible && !spatialImagingFocusActive, "Back must stay on anatomy")
        check(spatialImagingLocalImageData == nil, "Back releases the local payload")

        placeSpatialImagingPlate(.ctGuide)
        toggleSpatialImagingFocus()
        let beforeSettings = request()
        openReferenceWorkspace(.settings)
        check(!finish(beforeSettings), "Late import cannot close Settings")
        check(focusedReferenceWorkspace == .settings && !spatialImagingPlateVisible, "Settings keeps sole focus")
        closeReferenceWorkspace()

        placeSpatialImagingPlate(.ctGuide)
        toggleSpatialImagingFocus()
        let beforeStudyChange = request()
        placeSpatialImagingPlate(.mriGuide)
        check(!finish(beforeStudyChange), "Changing studies cancels the earlier import")
        check(spatialImagingReference == .mriGuide && spatialImagingFocusActive, "New study retains focus")

        let older = request()
        let newest = request()
        check(!finish(older), "Older reads cannot replace the newest choice")
        check(finish(newest), "The newest request imports successfully")
        check(!finish(newest), "Duplicate completion cannot replace an image")
        selectSpatialImagingModality(.ct, comparison: false)
        toggleSpatialImagingAnnotation()
        beginSpatialImagingInk(at: CGPoint(x: 0.42, y: 0.48))
        continueSpatialImagingInk(at: CGPoint(x: 0.49, y: 0.43))
        endSpatialImagingInk(at: CGPoint(x: 0.57, y: 0.49))
        toggleSpatialImagingAnnotation()
        let originalInk = spatialImagingInkStrokes
        check(originalInk.count == 1, "Imported image accepts a surface mark")

        let unreadable = request()
        check(!finish(unreadable, data: Data([0, 1, 2])), "Unreadable image is rejected")
        check(spatialImagingInkStrokes == originalInk, "Rejected import preserves the current markup")
        check(spatialImagingLocalImageData == imageData, "Rejected import preserves the current image")
        toggleSpatialImagingFocus()
        toggleSpatialImagingFocus()
        check(spatialImagingInkStrokes == originalInk, "Placing and refocusing preserves markup")

        clearSpatialImagingLocalImage()
        check(spatialImagingInkStrokes.isEmpty, "Removing an image removes its marks")
        check(finish(request()), "A new import still works after removing a local image")
        toggleSpatialImagingAnnotation()
        beginSpatialImagingInk(at: CGPoint(x: 0.45, y: 0.47))
        endSpatialImagingInk(at: CGPoint(x: 0.55, y: 0.47))
        placeSpatialImagingPlate(.mriGuide)
        check(spatialImagingInkStrokes.isEmpty, "Atlas template cannot inherit local-image marks")

        check(finish(request()), "Import recovers after a study change")
        selectSpatialImagingModality(.ct, comparison: false)
        toggleSpatialImagingAnnotation()
        beginSpatialImagingInk(at: CGPoint(x: 0.40, y: 0.53))
        continueSpatialImagingInk(at: CGPoint(x: 0.45, y: 0.43))
        continueSpatialImagingInk(at: CGPoint(x: 0.52, y: 0.42))
        endSpatialImagingInk(at: CGPoint(x: 0.58, y: 0.52))
        toggleSpatialImagingAnnotation()
        if !spatialImagingFocusActive { toggleSpatialImagingFocus() }
        if returnToAnatomy {
            let pending = request()
            returnToAnatomyFromSpatialImaging()
            check(!finish(pending), "Final Back rejects an in-flight import")
            check(spatialImagingLocalImageData == nil && spatialImagingInkStrokes.isEmpty,
                  "Final Back releases temporary images and markup")
        }
        print("IMAGING_IMPORT_LIFECYCLE=PASS checks=\(checks) returned=\(returnToAnatomy)")
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

    /// Proves that a non-default dossier survives selection, review, and the
    /// explicit threshold into the generic anatomy explanation.
    func prepareSelectedCaseHandoffProof() {
        prepareSpatialDockedCaseProof()
        selectedFictionalCaseIndex = 7
        selectedCaseHistoryMilestone = .reportedChange
        caseReviewRevealProgress = 1
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
        selectFamilyQuestion("Start with one glowing point")
        setFamilyClarityCheck(1)
    }

    func preparePresenterPlainLanguageProof() {
        prepareClinicianProof(step: .inspectOcclusion)
        setFamilyClarityCheck(1)
        selectPresenterKeyPoint(0)
    }

    var discussionReport: String {
        let plan = selectedCareDiscussion?.title ?? "No pathway selected"
        return """
        \(selectedFictionalCase.id) · FICTIONAL
        Seen: schematic blockage + tissue at risk.
        Open: \(plan).
        Ask: What did imaging show? Which options now? What happens next?
        Discussion aid only—not diagnosis, recommendation, consent, or record.
        """
    }
}
