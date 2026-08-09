import Foundation
import Observation
import SwiftUI

enum RBCJourneyStation: Int, CaseIterable, Identifiable {
    case meetTheCell
    case enterTheLumen
    case circleOfWillis
    case followTheMCA
    case meetTheBlockage
    case seeTheTerritory
    case microcirculation

    var id: Int { rawValue }

    var code: String {
        String(format: "%02d", rawValue + 1)
    }

    var shortTitle: String {
        switch self {
        case .meetTheCell: "Cell"
        case .enterTheLumen: "Lumen"
        case .circleOfWillis: "Circle"
        case .followTheMCA: "Route"
        case .meetTheBlockage: "Blockage"
        case .seeTheTerritory: "Territory"
        case .microcirculation: "Exchange"
        }
    }

    var title: String {
        switch self {
        case .meetTheCell: "Meet one red blood cell"
        case .enterTheLumen: "Enter the arterial lumen"
        case .circleOfWillis: "Choose a cerebral branch"
        case .followTheMCA: "Follow a teaching route"
        case .meetTheBlockage: "Pause before the blockage"
        case .seeTheTerritory: "Pull back to the territory"
        case .microcirculation: "Deliver oxygen at capillary scale"
        }
    }

    var concept: String {
        switch self {
        case .meetTheCell:
            "The biconcave form is flexible and specialized for transport. Its displayed scale is deliberately magnified."
        case .enterTheLumen:
            "Blood cells travel inside the lumen. The wall, cell density, speed, and streamlines here are illustrative."
        case .circleOfWillis:
            "Cerebral arteries form a branching supply network. This overlay is generic, not a person's scan."
        case .followTheMCA:
            "A conceptual marker route shows direction toward an example right-MCA teaching territory."
        case .meetTheBlockage:
            "An example clot interrupts the route. The lesson freezes here instead of simulating a collision or outcome."
        case .seeTheTerritory:
            "The important relationship is blockage, changed downstream supply, and the brain territory beyond it."
        case .microcirculation:
            "Red blood cells deform through narrow capillaries while oxygen crosses into tissue; the cell remains intravascular."
        }
    }

    var prompt: String {
        switch self {
        case .meetTheCell: "What feature helps the cell move through narrow vessels?"
        case .enterTheLumen: "Which direction is the conceptual flow moving?"
        case .circleOfWillis: "Where does the supply route branch?"
        case .followTheMCA: "Can you trace the highlighted path without moving the anatomy?"
        case .meetTheBlockage: "What changes before and beyond this point?"
        case .seeTheTerritory: "Which tissue lies downstream of the example blockage?"
        case .microcirculation: "Does the cell leave the vessel, or does oxygen cross the interface?"
        }
    }

    var didYouKnow: String {
        switch self {
        case .meetTheCell:
            "Red blood cells bend as they pass through vessels narrower than their resting diameter."
        case .enterTheLumen:
            "The lumen is the open passage inside a vessel; the vessel wall surrounds it."
        case .circleOfWillis:
            "The Circle of Willis connects anterior and posterior cerebral circulation, but its anatomy varies between people."
        case .followTheMCA:
            "The middle cerebral artery continues laterally from the internal carotid circulation and supplies a large cerebral territory."
        case .meetTheBlockage:
            "A blockage and the tissue beyond it are one spatial relationship; this generic scene does not predict an individual outcome."
        case .seeTheTerritory:
            "Cerebral arteries divide into progressively smaller branches before penetrating brain tissue."
        case .microcirculation:
            "Oxygen diffuses from capillary blood into tissue; the red blood cell remains inside the vessel."
        }
    }

    var systemImage: String {
        switch self {
        case .meetTheCell: "circle.hexagongrid.fill"
        case .enterTheLumen: "arrow.right.circle.fill"
        case .circleOfWillis: "point.3.connected.trianglepath.dotted"
        case .followTheMCA: "arrow.triangle.branch"
        case .meetTheBlockage: "exclamationmark.octagon.fill"
        case .seeTheTerritory: "brain.head.profile.fill"
        case .microcirculation: "waveform.path.ecg"
        }
    }
}

enum RBCVesselPortal: Int, CaseIterable, Identifiable {
    case lumen
    case circleOfWillis
    case exchange

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .lumen: "Lumen"
        case .circleOfWillis: "Circle"
        case .exchange: "Exchange"
        }
    }

    var region: String {
        switch self {
        case .lumen: "Arterial wall"
        case .circleOfWillis: "Cranial base"
        case .exchange: "Microcirculation"
        }
    }

    var lessonTitle: String {
        switch self {
        case .lumen: "Inside the artery wall"
        case .circleOfWillis: "Where the brain's major routes meet"
        case .exchange: "Where blood meets brain tissue"
        }
    }

    var lessonSubtitle: String {
        switch self {
        case .lumen:
            "This magnified cutaway separates the vessel wall from the open lumen. Cells, wall thickness, and flow markers are scaled for teaching."
        case .circleOfWillis:
            "At the brain's base, communicating arteries link anterior and posterior circulation. This is generic anatomy; the pattern varies between people."
        case .exchange:
            "Capillaries bring blood within diffusion distance of tissue. Oxygen crosses the vessel wall while the red blood cell remains intravascular."
        }
    }

    var didYouKnow: String {
        switch self {
        case .lumen:
            "The lumen is the passage blood travels through; the vessel wall is living tissue around it."
        case .circleOfWillis:
            "Internal carotid and vertebrobasilar routes meet through the Circle of Willis, but a complete symmetric circle is not universal."
        case .exchange:
            "Cerebral arteries branch into arterioles and dense capillary networks before blood returns through venules."
        }
    }

    var systemImage: String {
        switch self {
        case .lumen: "circle.lefthalf.filled"
        case .circleOfWillis: "point.3.connected.trianglepath.dotted"
        case .exchange: "arrow.left.arrow.right"
        }
    }
}

enum BrainOrientationLandmark: String, CaseIterable, Identifiable {
    case frontal
    case parietal
    case temporal
    case occipital
    case cerebellum
    case brainstem

    var id: String { rawValue }
    var attachmentID: String { "brain-landmark-\(rawValue)" }

    var title: String {
        switch self {
        case .frontal: "Frontal lobe"
        case .parietal: "Parietal lobe"
        case .temporal: "Temporal lobe"
        case .occipital: "Occipital lobe"
        case .cerebellum: "Cerebellum"
        case .brainstem: "Brainstem"
        }
    }

    var subtitle: String {
        switch self {
        case .frontal: "Forward · planning and voluntary movement"
        case .parietal: "Upper side · touch and body position"
        case .temporal: "Lower side · hearing and memory"
        case .occipital: "Behind you · visual processing"
        case .cerebellum: "Low and behind · coordination"
        case .brainstem: "Deep and low · brain-to-body pathways"
        }
    }

    var position: SIMD3<Float> {
        switch self {
        case .frontal: [0.00, 1.92, -1.72]
        case .parietal: [-1.42, 1.78, -0.26]
        case .temporal: [1.40, 1.18, -0.14]
        case .occipital: [0.00, 1.72, 1.50]
        case .cerebellum: [-0.58, 0.86, 1.25]
        case .brainstem: [0.48, 0.72, 0.72]
        }
    }
}

enum RBCJourneyMotionMode: String, CaseIterable, Identifiable {
    case continuous = "Living flow"
    case comfort = "Comfort still"

    var id: String { rawValue }

    var explanation: String {
        switch self {
        case .continuous: "Registered flow markers loop continuously. Pause or resume at any time."
        case .comfort: "The anatomy remains visible while animation and pulse are held still."
        }
    }
}

enum RBCJourneyExperienceMode: String, CaseIterable, Identifiable {
    case entryPrelude = "Entry prelude"
    case wondrousJourney = "Wondrous journey"
    case regionAtlas = "Region portals"
    case openAtlas = "Open atlas"

    var id: String { rawValue }
}

enum RBCEntryPreludeChapter: Int, CaseIterable, Identifiable {
    case threshold
    case anatomy
    case problem
    case invitation

    var id: Int { rawValue }
    var number: String { String(format: "%02d", rawValue + 1) }

    var title: String {
        switch self {
        case .threshold: "Entering the brain."
        case .anatomy: "No region works alone."
        case .problem: "A blockage changes more than one point."
        case .invitation: "Follow one route."
        }
    }

    var subtitle: String {
        switch self {
        case .threshold:
            "Let the outside world fall quiet. The cortical shell ahead will become the room around you."
        case .anatomy:
            "The brain depends on continuous blood supply through a branching arterial network. Structure, flow, and function are spatially connected."
        case .problem:
            "A blockage matters because the tissue beyond it may no longer receive enough blood."
        case .invitation:
            "See the whole network, enter one vessel route, pause at an interruption, and pull back to understand the consequence."
        }
    }

    var actionTitle: String {
        self == .invitation ? "Enter the brain" : "Continue"
    }
}

enum RBCBrainRegionDestination: Int, CaseIterable, Identifiable {
    case arterialLumen
    case circleOfWillis
    case corticalExchange
    case ventricularSystem
    case cerebellum
    case deepStructures
    case frontalLobe
    case corticalMicroarchitecture

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .arterialLumen: "Arterial lumen"
        case .circleOfWillis: "Circle of Willis"
        case .corticalExchange: "Cortical exchange"
        case .ventricularSystem: "Ventricular system"
        case .cerebellum: "Cerebellum"
        case .deepStructures: "Deep structures"
        case .frontalLobe: "Frontal lobe"
        case .corticalMicroarchitecture: "Cortical microarchitecture"
        }
    }

    var shortTitle: String {
        switch self {
        case .arterialLumen: "Lumen"
        case .circleOfWillis: "Circle"
        case .corticalExchange: "Exchange"
        case .ventricularSystem: "Ventricles"
        case .cerebellum: "Cerebellum"
        case .deepStructures: "Deep brain"
        case .frontalLobe: "Frontal"
        case .corticalMicroarchitecture: "Cortical layers"
        }
    }

    var subtitle: String {
        switch self {
        case .arterialLumen:
            "Move from the surrounding arterial atlas into a magnified vessel interior and inspect the passage where blood travels."
        case .circleOfWillis:
            "Stand at the branching arterial crossroads at the base of the brain while the cortical vault remains around you."
        case .corticalExchange:
            "Enter a magnified teaching model of arteriole, capillary lanes, red cells, and venous return near cortical tissue."
        case .ventricularSystem:
            "Reveal the internal fluid-filled ventricular geometry as a distinct orientation system inside the same brain environment."
        case .cerebellum:
            "Shift behind and below the cerebral hemispheres to study the cerebellar form without leaving the enclosing cortical world."
        case .deepStructures:
            "Bring the central deep-brain assembly forward while the outer cortex recedes into environmental context."
        case .frontalLobe:
            "Stand inside the forward cortical region. A restrained outline holds its orientation while illuminated arterial branches make blood-flow direction visible around you."
        case .corticalMicroarchitecture:
            "Enter a magnified cortical fold. Six laminar bands and simplified radial guides surround a penetrating arteriole as it branches toward capillary exchange."
        }
    }

    var fact: String {
        switch self {
        case .arterialLumen: "The lumen is the open space enclosed by the vessel wall."
        case .circleOfWillis: "The Circle of Willis links major anterior and posterior routes, with substantial anatomical variation between people."
        case .corticalExchange: "Oxygen crosses from capillary blood into tissue; red blood cells remain inside the vessel."
        case .ventricularSystem: "The ventricular system contains cerebrospinal fluid and is not part of the arterial blood-flow network."
        case .cerebellum: "The cerebellum sits posterior and inferior to the cerebral hemispheres and contributes to coordinated movement."
        case .deepStructures: "This is an orientation view of central anatomy, not a diagnostic segmentation or patient scan."
        case .frontalLobe: "The frontal lobe contributes to planning, inhibition, speech, and voluntary movement. The outline is an orientation guide, not diagnostic segmentation."
        case .corticalMicroarchitecture: "Most cerebral cortex is six-layered neocortex, but layer thickness, cell density, and columnar organization vary across cortical areas."
        }
    }

    var systemImage: String {
        switch self {
        case .arterialLumen: "circle.dashed.inset.filled"
        case .circleOfWillis: "point.3.connected.trianglepath.dotted"
        case .corticalExchange: "waveform.path.ecg"
        case .ventricularSystem: "drop.degreesign.fill"
        case .cerebellum: "brain.head.profile.fill"
        case .deepStructures: "scope"
        case .frontalLobe: "brain.head.profile.fill"
        case .corticalMicroarchitecture: "square.3.layers.3d"
        }
    }

    var station: RBCJourneyStation {
        switch self {
        case .arterialLumen: .enterTheLumen
        case .circleOfWillis: .circleOfWillis
        case .corticalExchange: .microcirculation
        case .ventricularSystem, .cerebellum, .deepStructures: .circleOfWillis
        case .frontalLobe: .followTheMCA
        case .corticalMicroarchitecture: .microcirculation
        }
    }
}

enum RBCRegionVisualizationMode: String, CaseIterable, Identifiable {
    case locate
    case xray
    case flow

    var id: String { rawValue }

    var title: String {
        switch self {
        case .locate: "Locate"
        case .xray: "X-ray"
        case .flow: "Flow"
        }
    }

    var systemImage: String {
        switch self {
        case .locate: "scope"
        case .xray: "viewfinder.circle"
        case .flow: "waveform.path.ecg"
        }
    }
}

enum RBCFlowRideRoute: String, CaseIterable, Identifiable {
    case overview
    case frontal
    case neighboring

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .overview: "Both paths"
        case .frontal: "Frontal route"
        case .neighboring: "Neighbor route"
        }
    }

    var systemImage: String {
        switch self {
        case .overview: "arrow.triangle.branch"
        case .frontal: "brain.head.profile.fill"
        case .neighboring: "arrow.up.right"
        }
    }

    var title: String {
        switch self {
        case .overview: "A fork inside the brain"
        case .frontal: "From artery to cortex"
        case .neighboring: "Compare the neighboring route"
        }
    }

    var subtitle: String {
        switch self {
        case .overview:
            "The vessel surrounds you and divides ahead. Red cells and traveling light reveal both downstream directions while you remain physically still."
        case .frontal:
            "The coral branch narrows toward penetrating arterioles and an interconnected capillary field. The expanded scale makes the relationship visible without claiming patient anatomy."
        case .neighboring:
            "The second branch stays visible to show that a vascular journey belongs to a network, not a single isolated tube. This route is illustrative rather than patient anatomy."
        }
    }

    var fact: String {
        switch self {
        case .overview:
            "Cerebral arteries branch repeatedly as they distribute blood through different territories."
        case .frontal:
            "Cerebral arteries divide into smaller arteries and arterioles before dense capillary networks exchange oxygen and nutrients with tissue."
        case .neighboring:
            "Neighboring arterial routes and collateral connections vary between people, so this scene does not predict individual blood supply."
        }
    }

    func familyNarration(for moment: RBCFamilyNarrationMoment) -> RBCFamilyNarrationCue {
        switch (self, moment) {
        case (.overview, .orientation):
            RBCFamilyNarrationCue(
                title: "The fork comes into view",
                caption: "You are inside a teaching model of a cerebral artery. The moving light shows which way blood is traveling."
            )
        case (.overview, .passage):
            RBCFamilyNarrationCue(
                title: "Two paths share one source",
                caption: "Red cells divide between the branches. This is a direction lesson, not a measurement of speed, pressure, or your anatomy."
            )
        case (.overview, .arrival):
            RBCFamilyNarrationCue(
                title: "Choose where to look next",
                caption: "Follow the coral path toward a frontal-region guide, or the teal path to compare a neighboring route."
            )
        case (.frontal, .orientation):
            RBCFamilyNarrationCue(
                title: "Turn with the frontal branch",
                caption: "Coral light marks the selected route. The vessel shifts around you so your body can remain comfortably still."
            )
        case (.frontal, .passage):
            RBCFamilyNarrationCue(
                title: "Flow carries oxygen forward",
                caption: "Red blood cells pass through the lumen, the open space inside the vessel, toward smaller downstream branches."
            )
        case (.frontal, .arrival):
            RBCFamilyNarrationCue(
                title: "A network meets the cortex",
                caption: "Red cells stay inside this capillary bed while oxygen passes toward nearby tissue. The soft rings show that exchange conceptually, not real scale or measured flow."
            )
        case (.neighboring, .orientation):
            RBCFamilyNarrationCue(
                title: "Turn toward the neighboring route",
                caption: "Teal light marks a second route through the same branching network. The surrounding corridor moves; you do not."
            )
        case (.neighboring, .passage):
            RBCFamilyNarrationCue(
                title: "One network, many routes",
                caption: "Cerebral arteries branch again and again as they distribute blood toward different territories of the brain."
            )
        case (.neighboring, .arrival):
            RBCFamilyNarrationCue(
                title: "Anatomy can vary",
                caption: "Neighboring routes and collateral connections differ between people, so this scene teaches relationships rather than predicting an individual blood supply."
            )
        }
    }
}

struct RBCFamilyNarrationCue: Equatable, Sendable {
    let title: String
    let caption: String

    /// Holds a caption long enough to read at a calm museum-guide pace. Live
    /// audio may hold it longer, but never shorter.
    var minimumDwellSeconds: Double {
        let wordCount = (title + " " + caption).split(whereSeparator: \Character.isWhitespace).count
        return min(max(Double(wordCount) / 2.2 + 1.5, 8.0), 14.0)
    }
}

enum RBCFamilyNarrationMoment: Int, CaseIterable, Identifiable, Sendable {
    case orientation
    case passage
    case arrival

    var id: Int { rawValue }
    var number: String { String(format: "%02d", rawValue + 1) }

    var guidanceVerb: String {
        switch self {
        case .orientation: "NOTICE"
        case .passage: "FOLLOW"
        case .arrival: "CONNECT"
        }
    }
}

enum RBCExhibitBeat: Int, CaseIterable, Identifiable {
    case route
    case blockage
    case consequence

    var id: Int { rawValue }
    var number: String { String(format: "%02d", rawValue + 1) }

    var title: String {
        switch self {
        case .route: "First, see the whole supply network"
        case .blockage: "Now follow one route to its interruption"
        case .consequence: "Then see what the interruption puts at risk"
        }
    }

    var subtitle: String {
        switch self {
        case .route:
            "The arterial tree surrounds you. A thin illuminated lumen selects one example route through that larger network; it is a guide, not a separate blood vessel."
        case .blockage:
            "Enter the circular portal and the selected route resolves around an example right-M1 obstruction. Flow light stops here because supply beyond this point is interrupted."
        case .consequence:
            "Pull back to connect vessel, obstruction, and downstream tissue in one view. The violet tissue field is illustrative, not a patient scan or outcome prediction."
        }
    }

    var fact: String {
        switch self {
        case .route:
            "The middle cerebral artery supplies a large lateral cerebral territory through progressively smaller branches."
        case .blockage:
            "A large-vessel occlusion can reduce blood supply beyond the obstruction; this scene does not estimate an individual outcome."
        case .consequence:
            "The downstream field expresses a causal relationship, not an exact tissue segmentation or measured blood-flow simulation."
        }
    }

    var actionTitle: String {
        switch self {
        case .route: "Enter one route"
        case .blockage: "Reveal downstream effect"
        case .consequence: "Begin again"
        }
    }

    var systemImage: String {
        switch self {
        case .route: "point.3.connected.trianglepath.dotted"
        case .blockage: "exclamationmark.octagon.fill"
        case .consequence: "brain.head.profile.fill"
        }
    }

    var station: RBCJourneyStation {
        switch self {
        case .route: .followTheMCA
        case .blockage: .meetTheBlockage
        case .consequence: .seeTheTerritory
        }
    }
}

@MainActor
@Observable
final class RBCJourneyModel {
    static let trailheadID = "rbc-journey-trailhead"
    static let immersiveID = "rbc-journey-full-space"

    var station: RBCJourneyStation
    var experienceMode: RBCJourneyExperienceMode
    var exhibitBeat: RBCExhibitBeat
    var entryPreludeChapter: RBCEntryPreludeChapter
    var activeRegionDestination: RBCBrainRegionDestination?
    var pendingRegionDestination: RBCBrainRegionDestination?
    var regionTransferRun = 0
    var regionVisualization: RBCRegionVisualizationMode
    var flowRideRoute: RBCFlowRideRoute = .overview
    var isFrontalClotScenarioActive = false
    var isFlowRideActive = false
    var isCapillaryFieldFocused = false
    var motionMode: RBCJourneyMotionMode
    var isPresented = false
    var isSceneReady = false
    var isPaused = false
    var soundEnabled = true
    var familyNarrationEnabled = false
    var familyNarrationConfigured = false
    var familyNarrationMoment: RBCFamilyNarrationMoment = .orientation
    var familyNarrationRun = 0
    var familyNarrationReplayRun = 0
    let familyNarrationProofLocked: Bool
    var showTeachingPoints = true
    var systemReduceMotion = false
    var openPortalIDs: Set<Int>
    var focusedPortalID: Int?
    var transferredPortalID: Int?
    var savedLearningIDs: Set<String>
    var isExhibitFactExpanded = false
    var handTrackingStatus = "Hand gestures require Apple Vision Pro"
    let proofMode: Bool
    let regionTransferProofProgress: Float?

    init(arguments: [String] = CommandLine.arguments) {
        let proofArgument = arguments.first { $0.hasPrefix("--proof-station-") }
        let proofIndex = proofArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-station-", with: ""))
        }
        let portalArgument = arguments.first { $0.hasPrefix("--proof-portals-") }
        let portalCount = portalArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-portals-", with: ""))
        } ?? 0

        let initialTransfer = arguments.first { $0.hasPrefix("--proof-transfer-") }.flatMap {
            Int($0.replacingOccurrences(of: "--proof-transfer-", with: ""))
        }
        let initialFocus = arguments.first { $0.hasPrefix("--proof-focus-") }.flatMap {
            Int($0.replacingOccurrences(of: "--proof-focus-", with: ""))
        }
        let exhibitArgument = arguments.first { $0.hasPrefix("--proof-exhibit-") }
        let exhibitIndex = exhibitArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-exhibit-", with: ""))
        }
        let initialExhibitBeat = exhibitIndex.flatMap(RBCExhibitBeat.init(rawValue:))
        let preludeArgument = arguments.first { $0.hasPrefix("--proof-prelude-") }
        let preludeIndex = preludeArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-prelude-", with: ""))
        }
        let initialPreludeChapter = preludeIndex.flatMap(RBCEntryPreludeChapter.init(rawValue:))
        let regionArgument = arguments.first {
            guard $0.hasPrefix("--proof-region-") else { return false }
            return Int($0.replacingOccurrences(of: "--proof-region-", with: "")) != nil
        }
        let regionIndex = regionArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-region-", with: ""))
        }
        let regionTransitionArgument = arguments.first {
            $0.hasPrefix("--proof-region-transition-")
                && !$0.hasPrefix("--proof-region-transition-progress-")
        }
        let regionTransitionIndex = regionTransitionArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-region-transition-", with: ""))
        }
        let initialPendingRegionDestination = regionTransitionIndex.flatMap(
            RBCBrainRegionDestination.init(rawValue:)
        )
        let regionTransitionProgressArgument = arguments.first {
            $0.hasPrefix("--proof-region-transition-progress-")
        }
        let requestedRegionTransitionProgress = regionTransitionProgressArgument.flatMap {
            Float($0.replacingOccurrences(of: "--proof-region-transition-progress-", with: ""))
        }
        let capillaryFocusProofRequested = arguments.contains("--proof-capillary-focus")
        let flowRideProofRequested = arguments.contains("--proof-flow-ride")
            || capillaryFocusProofRequested
        let familyGuideProofRequested = arguments.contains("--proof-family-guide")
        let familyGuideBeatArgument = arguments.first { $0.hasPrefix("--proof-family-guide-beat-") }
        let familyGuideBeatIndex = familyGuideBeatArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-family-guide-beat-", with: ""))
        }
        let initialRegionDestination = initialPendingRegionDestination == nil && flowRideProofRequested
            ? RBCBrainRegionDestination.arterialLumen
            : (initialPendingRegionDestination == nil
                ? regionIndex.flatMap(RBCBrainRegionDestination.init(rawValue:))
                : nil)
        regionVisualization = if arguments.contains("--proof-region-mode-xray") {
            .xray
        } else if arguments.contains("--proof-region-mode-flow") {
            .flow
        } else {
            .locate
        }
        isFrontalClotScenarioActive = arguments.contains("--proof-frontal-clot")
        isFlowRideActive = flowRideProofRequested
        flowRideRoute = if arguments.contains("--proof-flow-route-frontal")
            || capillaryFocusProofRequested {
            .frontal
        } else if arguments.contains("--proof-flow-route-neighbor") {
            .neighboring
        } else {
            .overview
        }
        isCapillaryFieldFocused = capillaryFocusProofRequested
        familyNarrationEnabled = familyGuideProofRequested
        familyNarrationConfigured = familyGuideProofRequested
        familyNarrationMoment = familyGuideBeatIndex
            .flatMap(RBCFamilyNarrationMoment.init(rawValue:))
            ?? .orientation
        familyNarrationProofLocked = familyGuideBeatArgument != nil
        var initialOpenPortals = Set(0..<min(max(portalCount, 0), 3))
        if let initialTransfer, RBCVesselPortal(rawValue: initialTransfer) != nil {
            initialOpenPortals.insert(initialTransfer)
        }
        if let initialFocus, RBCVesselPortal(rawValue: initialFocus) != nil {
            initialOpenPortals.insert(initialFocus)
        }

        exhibitBeat = initialExhibitBeat ?? .route
        entryPreludeChapter = initialPreludeChapter ?? .threshold
        activeRegionDestination = initialRegionDestination
        pendingRegionDestination = initialPendingRegionDestination
        regionTransferProofProgress = requestedRegionTransitionProgress.map {
            min(max($0 / 100, 0), 1)
        }
        let legacyProofRequested = proofArgument != nil
            || portalArgument != nil
            || initialFocus != nil
            || initialTransfer != nil
        experienceMode = if initialPreludeChapter != nil {
            .entryPrelude
        } else if initialRegionDestination != nil || initialPendingRegionDestination != nil {
            .regionAtlas
        } else {
            legacyProofRequested ? .openAtlas : .wondrousJourney
        }
        station = initialPendingRegionDestination?.station
            ?? initialRegionDestination?.station
            ?? initialExhibitBeat?.station
            ?? proofIndex.flatMap(RBCJourneyStation.init(rawValue:))
            ?? .circleOfWillis
        motionMode = arguments.contains("--proof-comfort-still") ? .comfort : .continuous
        if initialPendingRegionDestination != nil {
            openPortalIDs = []
            focusedPortalID = nil
            transferredPortalID = nil
        } else if let initialRegionDestination {
            openPortalIDs = []
            focusedPortalID = nil
            transferredPortalID = initialRegionDestination.id
        } else if let initialExhibitBeat {
            openPortalIDs = [RBCVesselPortal.circleOfWillis.id]
            focusedPortalID = initialExhibitBeat == .blockage
                ? RBCVesselPortal.circleOfWillis.id
                : nil
            transferredPortalID = initialExhibitBeat == .consequence
                ? RBCVesselPortal.circleOfWillis.id
                : nil
        } else {
            openPortalIDs = initialOpenPortals
            focusedPortalID = initialTransfer ?? initialFocus
            transferredPortalID = initialTransfer
        }
        let savedDefaults = UserDefaults.standard.array(forKey: "rbc-journey-saved-learnings") as? [String]
        let legacyStationIDs = UserDefaults.standard.array(forKey: "rbc-journey-saved-stations") as? [Int] ?? []
        savedLearningIDs = Set(savedDefaults ?? legacyStationIDs.map { "station-\($0)" })
        isPaused = arguments.contains("--proof-paused")
            || initialExhibitBeat == .blockage
            || initialExhibitBeat == .consequence
        proofMode = proofArgument != nil
            || portalArgument != nil
            || exhibitArgument != nil
            || regionArgument != nil
            || regionTransitionArgument != nil
            || regionTransitionProgressArgument != nil
            || preludeArgument != nil
            || arguments.contains("--proof-comfort-still")
            || arguments.contains("--proof-paused")
            || arguments.contains("--proof-frontal-clot")
            || familyGuideProofRequested
            || familyGuideBeatArgument != nil
            || flowRideProofRequested
            || capillaryFocusProofRequested
            || initialFocus != nil
            || initialTransfer != nil
    }

    var effectiveReducedMotion: Bool {
        systemReduceMotion || motionMode == .comfort
    }

    /// Versioned, family-facing copy. The Realtime provider is instructed to
    /// read this exact text and may not add medical interpretation.
    var familyNarrationText: String {
        guard isFlowRideActive else { return "" }
        return "\(familyNarrationCue.title). \(familyNarrationCue.caption)"
    }

    var familyNarrationCue: RBCFamilyNarrationCue {
        flowRideRoute.familyNarration(for: familyNarrationMoment)
    }

    var activeFlowRideTitle: String {
        isCapillaryFieldFocused ? "Inside the capillary field" : flowRideRoute.title
    }

    var activeFlowRideSubtitle: String {
        if isCapillaryFieldFocused {
            return "The network expands around you while your body stays still. Gold arrows stay inside the vessels; soft rings mark the exchange idea at nearby tissue."
        }
        return flowRideRoute.subtitle
    }

    var activeFlowRideFact: String {
        if isCapillaryFieldFocused {
            return "Capillary networks are where blood and nearby tissue exchange oxygen and nutrients."
        }
        return flowRideRoute.fact
    }

    var familyNarrationSequenceKey: String {
        "\(isFlowRideActive)-\(familyNarrationEnabled)-\(flowRideRoute.rawValue)-\(familyNarrationRun)"
    }

    var regionTransferSequenceKey: String {
        "\(pendingRegionDestination?.rawValue ?? -1)-\(regionTransferRun)"
    }

    var regionTransferDurationMilliseconds: Int {
        effectiveReducedMotion ? 420 : 1_450
    }

    var familyNarrationProgressLabel: String {
        "FAMILY GUIDE  ·  \(familyNarrationMoment.guidanceVerb)  ·  \(familyNarrationMoment.number) / 03"
    }

    var familyNarrationAdvanceTitle: String {
        if flowRideRoute == .frontal,
           familyNarrationMoment == .passage,
           !isCapillaryFieldFocused {
            return "Enter field"
        }
        return "Next idea"
    }

    func toggleFamilyNarration() {
        familyNarrationEnabled.toggle()
        familyNarrationMoment = .orientation
        familyNarrationRun += 1
    }

    func selectFlowRideRoute(_ route: RBCFlowRideRoute) {
        guard flowRideRoute != route else { return }
        flowRideRoute = route
        isCapillaryFieldFocused = false
        familyNarrationMoment = .orientation
        familyNarrationRun += 1
    }

    func setFamilyNarrationMoment(_ moment: RBCFamilyNarrationMoment) {
        guard !familyNarrationProofLocked else { return }
        guard moment.rawValue >= familyNarrationMoment.rawValue else { return }
        familyNarrationMoment = moment
    }

    func advanceFamilyNarration() {
        guard familyNarrationEnabled, !familyNarrationProofLocked else { return }
        if flowRideRoute == .frontal,
           familyNarrationMoment == .passage,
           !isCapillaryFieldFocused {
            toggleCapillaryFieldFocus()
            return
        }
        guard let next = RBCFamilyNarrationMoment(rawValue: familyNarrationMoment.rawValue + 1) else { return }
        setFamilyNarrationMoment(next)
    }

    func replayFamilyNarration() {
        guard familyNarrationEnabled else { return }
        familyNarrationReplayRun += 1
    }

    func toggleCapillaryFieldFocus() {
        guard isFlowRideActive, flowRideRoute == .frontal else { return }
        isCapillaryFieldFocused.toggle()
        if isCapillaryFieldFocused {
            setFamilyNarrationMoment(.arrival)
        }
    }

    var progress: Double {
        if experienceMode == .wondrousJourney {
            return Double(exhibitBeat.rawValue + 1) / Double(RBCExhibitBeat.allCases.count)
        }
        return Double(station.rawValue + 1) / Double(RBCJourneyStation.allCases.count)
    }

    var canGoBack: Bool { station.rawValue > 0 }
    var canAdvance: Bool { station.rawValue < RBCJourneyStation.allCases.count - 1 }
    var openPortalCount: Int { openPortalIDs.count }
    var focusedPortal: RBCVesselPortal? { focusedPortalID.flatMap(RBCVesselPortal.init(rawValue:)) }
    var transferredPortal: RBCVesselPortal? { transferredPortalID.flatMap(RBCVesselPortal.init(rawValue:)) }
    var currentLearningID: String {
        if let activeRegionDestination {
            return "region-\(activeRegionDestination.rawValue)"
        }
        if experienceMode == .wondrousJourney {
            return "exhibit-\(exhibitBeat.rawValue)"
        }
        if let portal = transferredPortal ?? focusedPortal {
            return "portal-\(portal.rawValue)"
        }
        return "station-\(station.rawValue)"
    }

    var isCurrentLessonSaved: Bool { savedLearningIDs.contains(currentLearningID) }
    var savedLearningCount: Int { savedLearningIDs.count }

    var lessonEyebrow: String {
        if experienceMode == .wondrousJourney {
            return "INSIDE THE FLOW  ·  \(exhibitBeat.number) / 03"
        }
        if let portal = transferredPortal ?? focusedPortal {
            return transferredPortal == nil ? "PORTAL PREVIEW · \(portal.title.uppercased())" : "INSIDE REGION · \(portal.title.uppercased())"
        }
        return "LESSON \(station.code)"
    }

    var lessonTitle: String {
        experienceMode == .wondrousJourney
            ? exhibitBeat.title
            : (transferredPortal ?? focusedPortal)?.lessonTitle ?? station.title
    }
    var lessonSubtitle: String {
        experienceMode == .wondrousJourney
            ? exhibitBeat.subtitle
            : (transferredPortal ?? focusedPortal)?.lessonSubtitle ?? station.concept
    }
    var lessonFact: String {
        experienceMode == .wondrousJourney
            ? exhibitBeat.fact
            : (transferredPortal ?? focusedPortal)?.didYouKnow ?? station.didYouKnow
    }

    var portalSummary: String {
        switch openPortalCount {
        case 0: "Choose any vessel lens"
        case 1: "1 of 3 lenses open"
        default: "\(openPortalCount) of 3 lenses open"
        }
    }

    func select(_ station: RBCJourneyStation) {
        experienceMode = .openAtlas
        self.station = station
        isPaused = false
    }

    func startWondrousJourney() {
        experienceMode = .wondrousJourney
        pendingRegionDestination = nil
        activeRegionDestination = nil
        isFrontalClotScenarioActive = false
        isFlowRideActive = false
        exhibitBeat = .route
        station = exhibitBeat.station
        motionMode = .continuous
        isPaused = false
        isExhibitFactExpanded = false
        openPortalIDs = [RBCVesselPortal.circleOfWillis.id]
        focusedPortalID = nil
        transferredPortalID = nil
    }

    func startEntryPrelude() {
        experienceMode = .entryPrelude
        entryPreludeChapter = .threshold
        pendingRegionDestination = nil
        activeRegionDestination = nil
        isFrontalClotScenarioActive = false
        isFlowRideActive = false
        station = .circleOfWillis
        isPaused = true
        isExhibitFactExpanded = false
        closeAllPortals()
    }

    func advanceEntryPrelude() {
        guard experienceMode == .entryPrelude else { return }
        if let next = RBCEntryPreludeChapter(rawValue: entryPreludeChapter.rawValue + 1) {
            entryPreludeChapter = next
        } else {
            startWondrousJourney()
        }
    }

    func startOpenAtlas() {
        experienceMode = .openAtlas
        pendingRegionDestination = nil
        activeRegionDestination = nil
        isFrontalClotScenarioActive = false
        isFlowRideActive = false
        station = .circleOfWillis
        isPaused = false
        isExhibitFactExpanded = false
        closeAllPortals()
    }

    func enterRegion(_ destination: RBCBrainRegionDestination) {
        experienceMode = .regionAtlas
        pendingRegionDestination = nil
        activeRegionDestination = destination
        station = destination.station
        openPortalIDs = []
        focusedPortalID = nil
        transferredPortalID = destination.id
        regionVisualization = .locate
        isFrontalClotScenarioActive = false
        isFlowRideActive = false
        isPaused = destination == .arterialLumen || destination == .corticalExchange
        isExhibitFactExpanded = false
    }

    /// Region selection opens a spatial threshold first. The destination is
    /// committed only after that threshold finishes, so the wearer controls
    /// when a region appears without being moved through an app camera.
    func requestRegion(_ destination: RBCBrainRegionDestination) {
        guard pendingRegionDestination == nil else { return }
        guard activeRegionDestination != destination || experienceMode != .regionAtlas else { return }
        experienceMode = .regionAtlas
        pendingRegionDestination = destination
        regionTransferRun += 1
        isFrontalClotScenarioActive = false
        isFlowRideActive = false
        isCapillaryFieldFocused = false
        isPaused = false
        isExhibitFactExpanded = false
    }

    func completePendingRegionTransfer() {
        guard let destination = pendingRegionDestination else { return }
        enterRegion(destination)
    }

    /// Standard gaze + pinch discovery: first pinch enters a region; later
    /// pinches cycle the three readings without adding another floating panel.
    func activateRegionDiscovery(_ id: Int) {
        guard let destination = RBCBrainRegionDestination(rawValue: id) else { return }
        guard activeRegionDestination == destination, experienceMode == .regionAtlas else {
            requestRegion(destination)
            return
        }
        regionVisualization = switch regionVisualization {
        case .locate: .xray
        case .xray: .flow
        case .flow: .locate
        }
        if regionVisualization != .flow {
            isFrontalClotScenarioActive = false
        }
        isPaused = false
    }

    func toggleFrontalClotScenario() {
        guard activeRegionDestination == .frontalLobe else {
            enterRegion(.frontalLobe)
            regionVisualization = .flow
            isFrontalClotScenarioActive = true
            return
        }
        regionVisualization = .flow
        isFrontalClotScenarioActive.toggle()
        isPaused = false
    }

    func startFlowRide() {
        experienceMode = .regionAtlas
        activeRegionDestination = .arterialLumen
        station = .enterTheLumen
        openPortalIDs = []
        focusedPortalID = nil
        transferredPortalID = RBCBrainRegionDestination.arterialLumen.id
        regionVisualization = .flow
        isFrontalClotScenarioActive = false
        isFlowRideActive = true
        flowRideRoute = .overview
        isCapillaryFieldFocused = false
        familyNarrationMoment = .orientation
        familyNarrationRun += 1
        isPaused = false
        isExhibitFactExpanded = false
    }

    func stopFlowRide() {
        experienceMode = .regionAtlas
        activeRegionDestination = .frontalLobe
        station = .followTheMCA
        openPortalIDs = []
        focusedPortalID = nil
        transferredPortalID = RBCBrainRegionDestination.frontalLobe.id
        regionVisualization = .flow
        isFlowRideActive = false
        isCapillaryFieldFocused = false
        familyNarrationEnabled = false
        familyNarrationMoment = .orientation
        familyNarrationRun += 1
        isPaused = false
    }

    func advanceExhibit() {
        guard experienceMode == .wondrousJourney else { return }
        isExhibitFactExpanded = false
        switch exhibitBeat {
        case .route:
            exhibitBeat = .blockage
            station = exhibitBeat.station
            openPortalIDs = [RBCVesselPortal.circleOfWillis.id]
            focusedPortalID = RBCVesselPortal.circleOfWillis.id
            transferredPortalID = nil
            isPaused = true
        case .blockage:
            exhibitBeat = .consequence
            station = exhibitBeat.station
            openPortalIDs = [RBCVesselPortal.circleOfWillis.id]
            focusedPortalID = RBCVesselPortal.circleOfWillis.id
            transferredPortalID = RBCVesselPortal.circleOfWillis.id
            isPaused = true
        case .consequence:
            startWondrousJourney()
        }
    }

    func retreatExhibit() {
        guard experienceMode == .wondrousJourney else { return }
        isExhibitFactExpanded = false
        switch exhibitBeat {
        case .route:
            return
        case .blockage:
            startWondrousJourney()
        case .consequence:
            exhibitBeat = .blockage
            station = exhibitBeat.station
            openPortalIDs = [RBCVesselPortal.circleOfWillis.id]
            focusedPortalID = RBCVesselPortal.circleOfWillis.id
            transferredPortalID = nil
            isPaused = true
        }
    }

    func back() {
        guard let previous = RBCJourneyStation(rawValue: station.rawValue - 1) else { return }
        select(previous)
    }

    func advance() {
        guard let next = RBCJourneyStation(rawValue: station.rawValue + 1) else { return }
        select(next)
    }

    func restart() {
        select(.meetTheCell)
        closeAllPortals()
    }

    func openNextPortal() {
        guard let next = (0..<3).first(where: { !openPortalIDs.contains($0) }) else { return }
        openPortalIDs.insert(next)
        focusedPortalID = next
    }

    func togglePortal(_ id: Int) {
        guard (0..<3).contains(id) else { return }
        if openPortalIDs.contains(id) {
            openPortalIDs.remove(id)
            if focusedPortalID == id { focusedPortalID = nil }
            if transferredPortalID == id { transferredPortalID = nil }
        } else {
            openPortalIDs.insert(id)
            focusedPortalID = id
        }
    }

    func focusPortal(_ id: Int) {
        guard RBCVesselPortal(rawValue: id) != nil else { return }
        openPortalIDs.insert(id)
        focusedPortalID = id
        transferredPortalID = nil
    }

    func transferToFocusedPortal() {
        guard let focusedPortalID, openPortalIDs.contains(focusedPortalID) else { return }
        transferredPortalID = focusedPortalID
    }

    func returnToOverview() {
        transferredPortalID = nil
        focusedPortalID = nil
    }

    func closeAllPortals() {
        openPortalIDs.removeAll()
        focusedPortalID = nil
        transferredPortalID = nil
    }

    func toggleSavedCurrentStation() {
        if isCurrentLessonSaved {
            savedLearningIDs.remove(currentLearningID)
        } else {
            savedLearningIDs.insert(currentLearningID)
        }
        UserDefaults.standard.set(savedLearningIDs.sorted(), forKey: "rbc-journey-saved-learnings")
    }
}
