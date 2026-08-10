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
    case occipitalLobe
    case brainstem

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
        case .occipitalLobe: "Occipital lobe"
        case .brainstem: "Brainstem"
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
        case .occipitalLobe: "Visual cortex"
        case .brainstem: "Brainstem bridge"
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
            "Stand among central deep-brain relationships while the enclosing cortex recedes into environmental context."
        case .frontalLobe:
            "Stand inside the forward cortical region. A restrained outline holds its orientation while illuminated arterial branches make blood-flow direction visible around you."
        case .corticalMicroarchitecture:
            "Enter a magnified cortical fold. Six laminar bands and simplified radial guides surround a penetrating arteriole as it branches toward capillary exchange."
        case .occipitalLobe:
            "Stand inside the posterior cortical vault. A constellation locates the calcarine region while qualitative posterior-cerebral branches reveal how arterial routes approach visual cortex."
        case .brainstem:
            "Enter the vertical bridge between cerebrum, cerebellum, and spinal cord. Midbrain, pons, and medulla gather around the basilar route without moving the wearer."
        }
    }

    var fact: String {
        switch self {
        case .arterialLumen: "The lumen is the open space enclosed by the vessel wall."
        case .circleOfWillis: "The Circle of Willis links major anterior and posterior routes, with substantial anatomical variation between people."
        case .corticalExchange: "Oxygen crosses from capillary blood into tissue; red blood cells remain inside the vessel."
        case .ventricularSystem: "The ventricular system contains cerebrospinal fluid and is not part of the arterial blood-flow network."
        case .cerebellum: "The cerebellum sits posterior and inferior to the cerebral hemispheres and contributes to coordinated movement."
        case .deepStructures: "Deep structures receive blood from several small perforator families; this is not diagnostic segmentation or a patient scan."
        case .frontalLobe: "The frontal lobe contributes to planning, inhibition, speech, and voluntary movement. The outline is an orientation guide, not diagnostic segmentation."
        case .corticalMicroarchitecture: "Most cerebral cortex is six-layered neocortex, but layer thickness, cell density, and columnar organization vary across cortical areas."
        case .occipitalLobe: "Primary visual cortex lies along the banks of the calcarine sulcus. This scene is an orientation abstraction, not functional mapping or diagnostic segmentation."
        case .brainstem: "The brainstem contains the midbrain, pons, and medulla. This scene teaches their relationships and posterior circulation qualitatively, not patient anatomy or measured perfusion."
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
        case .occipitalLobe: "eye.fill"
        case .brainstem: "arrow.up.and.down.circle.fill"
        }
    }

    var station: RBCJourneyStation {
        switch self {
        case .arterialLumen: .enterTheLumen
        case .circleOfWillis: .circleOfWillis
        case .corticalExchange: .microcirculation
        case .ventricularSystem, .cerebellum, .deepStructures, .brainstem: .circleOfWillis
        case .frontalLobe: .followTheMCA
        case .corticalMicroarchitecture: .microcirculation
        case .occipitalLobe: .circleOfWillis
        }
    }
}

enum RBCWillisRouteFocus: String, CaseIterable, Identifiable {
    case overview
    case anterior
    case posterior

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .overview: "Whole circle"
        case .anterior: "Anterior"
        case .posterior: "Posterior"
        }
    }

    var title: String {
        switch self {
        case .overview: "A crossroads at the brain's base"
        case .anterior: "Follow the anterior route"
        case .posterior: "Follow the posterior route"
        }
    }

    var subtitle: String {
        switch self {
        case .overview:
            "Paired internal carotid routes and the basilar route meet through communicating arteries. Follow the moving fronts to see how the network connects."
        case .anterior:
            "The anterior reading lifts the paired carotid approach and the routes continuing toward the front while the posterior network recedes."
        case .posterior:
            "The posterior reading lifts the basilar approach and the routes continuing toward the back while the anterior network recedes."
        }
    }

    var fact: String {
        "Circle of Willis anatomy varies between people. These arrows show qualitative teaching directions, not an individual's collateral flow."
    }

    var systemImage: String {
        switch self {
        case .overview: "point.3.connected.trianglepath.dotted"
        case .anterior: "arrow.up.and.line.horizontal.and.arrow.down"
        case .posterior: "arrow.triangle.branch"
        }
    }
}

enum RBCAnteriorPassagePhase: Int, CaseIterable, Identifiable {
    case carotidApproach
    case circleCrossroads
    case middleCerebralContinuation

    var id: Int { rawValue }

    var shortTitle: String {
        switch self {
        case .carotidApproach: "Approach"
        case .circleCrossroads: "Crossroads"
        case .middleCerebralContinuation: "Continue"
        }
    }

    var title: String {
        switch self {
        case .carotidApproach: "Two carotid routes rise"
        case .circleCrossroads: "At the arterial crossroads"
        case .middleCerebralContinuation: "Follow one right MCA route"
        }
    }

    var subtitle: String {
        switch self {
        case .carotidApproach:
            "The paired internal-carotid approaches lift from below and gather around the Circle. Direction lights move upward while your viewpoint remains still."
        case .circleCrossroads:
            "Anterior, middle-cerebral, and communicating paths meet in one connected teaching network. The crossings stay visible without claiming a universal collateral-flow direction."
        case .middleCerebralContinuation:
            "One example right middle-cerebral route stays bright while the opposite side recedes as orientation context. Look at its warm threshold and pinch to inhabit the artery, or open the frontal field around it."
        }
    }

    var fact: String {
        switch self {
        case .carotidApproach:
            "The internal carotid arteries contribute to anterior cerebral circulation and give rise to middle cerebral arteries."
        case .circleCrossroads:
            "Circle of Willis anatomy varies substantially, and communicating routes do not imply one fixed direction of blood flow."
        case .middleCerebralContinuation:
            "Middle cerebral arteries travel laterally and branch repeatedly. This right-sided route is an enlarged teaching exemplar, not a patient-specific pathway."
        }
    }

    var nextActionTitle: String? {
        switch self {
        case .carotidApproach: "Reach the crossroads"
        case .circleCrossroads: "Reveal MCA routes"
        case .middleCerebralContinuation: nil
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

enum RBCPosteriorVoyagePhase: Int, CaseIterable, Identifiable {
    case convergence
    case basilarBridge
    case destinations

    var id: Int { rawValue }

    var shortTitle: String {
        switch self {
        case .convergence: "Converge"
        case .basilarBridge: "Bridge"
        case .destinations: "Choose"
        }
    }

    var title: String {
        switch self {
        case .convergence: "Two routes approach"
        case .basilarBridge: "Inside the basilar bridge"
        case .destinations: "Where should the route continue?"
        }
    }

    var subtitle: String {
        switch self {
        case .convergence:
            "The paired vertebral approaches lift from either side and meet below the pons. The world gathers around you; your viewpoint remains still."
        case .basilarBridge:
            "The single basilar trunk now carries the lesson upward along the pons. Small pontine approaches remain visible without assigning a fixed territory."
        case .destinations:
            "Posterior circulation continues toward both cerebellar routes and posterior cerebral routes. Open one destination only when you are ready."
        }
    }

    var fact: String {
        switch self {
        case .convergence:
            "The paired vertebral arteries join to form the basilar artery near the lower border of the pons."
        case .basilarBridge:
            "The basilar artery gives rise to pontine and cerebellar branches before ending as the posterior cerebral arteries."
        case .destinations:
            "These two choices teach connected routes, not fixed territories, measured flow, or an individual's anatomy."
        }
    }

    var nextActionTitle: String? {
        switch self {
        case .convergence: "Reach the bridge"
        case .basilarBridge: "Open destinations"
        case .destinations: nil
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
            "The artery surrounds you. Wide red currents and moving cells show one source dividing into two downstream routes while your body stays still."
        case .frontal:
            "The coral branch narrows toward penetrating arterioles and an interconnected capillary field. The expanded scale makes the relationship visible without claiming patient anatomy."
        case .neighboring:
            "The warm guide follows a second branch, showing that circulation belongs to a network rather than one isolated tube. This route is illustrative, not patient anatomy."
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
                title: "You are inside a cerebral artery",
                caption: "The three-dimensional brain atlas marks this teaching fork. Around you, layered currents, arrow fronts, and red cells move downstream while cortical folds remain visible beyond the vessel."
            )
        case (.overview, .passage):
            RBCFamilyNarrationCue(
                title: "Two paths share one source",
                caption: "Follow the moving fronts away from the source. Red cells divide between the branches; this choreography shows direction, not measured speed, pressure, or your anatomy."
            )
        case (.overview, .arrival):
            RBCFamilyNarrationCue(
                title: "The journey turns toward frontal cortex",
                caption: "The guided journey turns into the coral frontal route next. The atlas marker moves with it, while the amber branch remains visible as neighboring context."
            )
        case (.frontal, .orientation):
            RBCFamilyNarrationCue(
                title: "The locator enters the frontal branch",
                caption: "Coral light marks the selected route and the atlas names your position. The vessel and cortical environment shift around you so your body can remain still."
            )
        case (.frontal, .passage):
            RBCFamilyNarrationCue(
                title: "The route narrows toward cortex",
                caption: "Red cells pass through the lumen, the open space inside the vessel, toward smaller arteries and arterioles. The moving fronts keep downstream direction visible."
            )
        case (.frontal, .arrival):
            RBCFamilyNarrationCue(
                title: "A network meets the cortex",
                caption: "At the capillary field, the atlas marks a new teaching scale. Red cells stay inside the vessels while soft rings show exchange with nearby tissue conceptually, not at real scale or measured flow."
            )
        case (.neighboring, .orientation):
            RBCFamilyNarrationCue(
                title: "The locator enters a neighboring branch",
                caption: "Warm amber light marks a second route through the same network. The map updates while the corridor and surrounding folds move around your still body."
            )
        case (.neighboring, .passage):
            RBCFamilyNarrationCue(
                title: "One network, many routes",
                caption: "Cerebral arteries branch repeatedly as they distribute blood toward different territories. The moving cells make the shared source and divided paths visible."
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

/// One authored route through the arterial lesson. The wearer never has to
/// infer which button advances the story: scene, locator, caption, and optional
/// voice all derive from this single phase.
enum RBCGuidedFlowTourPhase: Int, CaseIterable, Identifiable, Sendable {
    case source
    case division
    case chooseFrontal
    case enterFrontal
    case narrowTowardCortex
    case capillaryArrival
    case complete

    var id: Int { rawValue }

    var progressNumber: String {
        let bounded = min(rawValue + 1, 6)
        return String(format: "%02d / 06", bounded)
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
    var willisRouteFocus: RBCWillisRouteFocus
    var flowRideRoute: RBCFlowRideRoute = .overview
    var anteriorPassagePhase: RBCAnteriorPassagePhase?
    var isAnteriorGatewayTransitionActive = false
    var posteriorVoyagePhase: RBCPosteriorVoyagePhase?
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
    var guidedFlowTourPhase: RBCGuidedFlowTourPhase = .source
    var isGuidedFlowTourActive = false
    var guidedFlowTourRun = 0
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
    var proofAutoLaunchConsumed = false
    let regionTransferProofProgress: Float?
    let anteriorGatewayTransitionProofProgress: Float?
    let flowRideProofPhase: Float?

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
        let genericPendingRegionDestination = regionTransitionIndex.flatMap(
            RBCBrainRegionDestination.init(rawValue:)
        )
        let regionTransitionProgressArgument = arguments.first {
            $0.hasPrefix("--proof-region-transition-progress-")
        }
        let requestedRegionTransitionProgress = regionTransitionProgressArgument.flatMap {
            Float($0.replacingOccurrences(of: "--proof-region-transition-progress-", with: ""))
        }
        let willisRouteProofRequested = arguments.contains("--proof-willis-route-overview")
            || arguments.contains("--proof-willis-route-anterior")
            || arguments.contains("--proof-willis-route-posterior")
        let capillaryFocusProofRequested = arguments.contains("--proof-capillary-focus")
        let flowRideProofPhaseArgument = arguments.first {
            $0.hasPrefix("--proof-flow-phase-")
        }
        let requestedFlowRideProofPhase = flowRideProofPhaseArgument.flatMap {
            Float($0.replacingOccurrences(of: "--proof-flow-phase-", with: ""))
        }.map { min(max($0 / 100, 0), 1) }
        let flowRideProofRequested = arguments.contains("--proof-flow-ride")
            || capillaryFocusProofRequested
            || requestedFlowRideProofPhase != nil
        let anteriorGatewayTransitionArgument = arguments.first {
            $0.hasPrefix("--proof-anterior-gateway-transition-")
        }
        let requestedAnteriorGatewayTransitionProgress = anteriorGatewayTransitionArgument.flatMap {
            Float($0.replacingOccurrences(of: "--proof-anterior-gateway-transition-", with: ""))
        }.map { min(max($0 / 100, 0), 1) }
        let anteriorGatewayTransitionProofRequested = requestedAnteriorGatewayTransitionProgress != nil
        let initialPendingRegionDestination: RBCBrainRegionDestination? = anteriorGatewayTransitionProofRequested
            ? .arterialLumen
            : genericPendingRegionDestination
        let anteriorPassageProofPhase: RBCAnteriorPassagePhase? = if anteriorGatewayTransitionProofRequested {
            .middleCerebralContinuation
        } else if arguments.contains("--proof-anterior-passage-crossroads") {
            .circleCrossroads
        } else if arguments.contains("--proof-anterior-passage-mca") {
            .middleCerebralContinuation
        } else if arguments.contains("--proof-anterior-passage-carotid") {
            .carotidApproach
        } else {
            nil
        }
        let posteriorVoyageProofPhase: RBCPosteriorVoyagePhase? = if arguments.contains("--proof-posterior-voyage-bridge") {
            .basilarBridge
        } else if arguments.contains("--proof-posterior-voyage-choice") {
            .destinations
        } else if arguments.contains("--proof-posterior-voyage-convergence") {
            .convergence
        } else {
            nil
        }
        let familyGuideProofRequested = arguments.contains("--proof-family-guide")
        let regionFamilyCompanionProofRequested = arguments.contains("--proof-region-family-companion")
        let familyGuideBeatArgument = arguments.first { $0.hasPrefix("--proof-family-guide-beat-") }
        let familyGuideBeatIndex = familyGuideBeatArgument.flatMap {
            Int($0.replacingOccurrences(of: "--proof-family-guide-beat-", with: ""))
        }
        let initialRegionDestination: RBCBrainRegionDestination? = if anteriorGatewayTransitionProofRequested {
            .circleOfWillis
        } else if initialPendingRegionDestination != nil {
            nil
        } else if flowRideProofRequested {
            .arterialLumen
        } else if anteriorPassageProofPhase != nil {
            .circleOfWillis
        } else if posteriorVoyageProofPhase != nil {
            .brainstem
        } else if willisRouteProofRequested
            || (regionFamilyCompanionProofRequested && regionIndex == nil) {
            .circleOfWillis
        } else {
            regionIndex.flatMap(RBCBrainRegionDestination.init(rawValue:))
        }
        regionVisualization = if posteriorVoyageProofPhase != nil {
            .flow
        } else if arguments.contains("--proof-region-mode-xray") {
            .xray
        } else if arguments.contains("--proof-region-mode-flow") {
            .flow
        } else {
            .locate
        }
        willisRouteFocus = if anteriorPassageProofPhase != nil || arguments.contains("--proof-willis-route-anterior") {
            .anterior
        } else if arguments.contains("--proof-willis-route-posterior") {
            .posterior
        } else {
            .overview
        }
        isFrontalClotScenarioActive = arguments.contains("--proof-frontal-clot")
        isFlowRideActive = flowRideProofRequested
        let initialFlowRideRoute: RBCFlowRideRoute = if arguments.contains("--proof-flow-route-frontal")
            || capillaryFocusProofRequested {
            .frontal
        } else if arguments.contains("--proof-flow-route-neighbor") {
            .neighboring
        } else {
            .overview
        }
        flowRideRoute = initialFlowRideRoute
        isCapillaryFieldFocused = capillaryFocusProofRequested
        anteriorPassagePhase = anteriorPassageProofPhase
        isAnteriorGatewayTransitionActive = anteriorGatewayTransitionProofRequested
        anteriorGatewayTransitionProofProgress = requestedAnteriorGatewayTransitionProgress
        flowRideProofPhase = requestedFlowRideProofPhase
        posteriorVoyagePhase = posteriorVoyageProofPhase
        familyNarrationEnabled = flowRideProofRequested || familyGuideProofRequested || regionFamilyCompanionProofRequested
        familyNarrationConfigured = familyGuideProofRequested || regionFamilyCompanionProofRequested
        let initialFamilyNarrationMoment = familyGuideBeatIndex
            .flatMap(RBCFamilyNarrationMoment.init(rawValue:))
            ?? .orientation
        familyNarrationMoment = initialFamilyNarrationMoment
        isGuidedFlowTourActive = flowRideProofRequested
        guidedFlowTourPhase = if capillaryFocusProofRequested {
            .capillaryArrival
        } else if initialFlowRideRoute == .frontal {
            initialFamilyNarrationMoment == .passage ? .narrowTowardCortex : .enterFrontal
        } else {
            switch initialFamilyNarrationMoment {
            case .orientation: .source
            case .passage: .division
            case .arrival: .chooseFrontal
            }
        }
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
        station = (anteriorGatewayTransitionProofRequested ? RBCJourneyStation.circleOfWillis : nil)
            ?? initialPendingRegionDestination?.station
            ?? initialRegionDestination?.station
            ?? initialExhibitBeat?.station
            ?? proofIndex.flatMap(RBCJourneyStation.init(rawValue:))
            ?? .circleOfWillis
        motionMode = arguments.contains("--proof-comfort-still") ? .comfort : .continuous
        if anteriorGatewayTransitionProofRequested {
            openPortalIDs = []
            focusedPortalID = nil
            transferredPortalID = RBCBrainRegionDestination.circleOfWillis.id
        } else if initialPendingRegionDestination != nil {
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
            || willisRouteProofRequested
            || preludeArgument != nil
            || arguments.contains("--proof-comfort-still")
            || arguments.contains("--proof-paused")
            || arguments.contains("--proof-frontal-clot")
            || familyGuideProofRequested
            || regionFamilyCompanionProofRequested
            || familyGuideBeatArgument != nil
            || flowRideProofRequested
            || capillaryFocusProofRequested
            || anteriorPassageProofPhase != nil
            || anteriorGatewayTransitionProofRequested
            || posteriorVoyageProofPhase != nil
            || initialFocus != nil
            || initialTransfer != nil
    }

    var effectiveReducedMotion: Bool {
        systemReduceMotion || motionMode == .comfort
    }

    /// Versioned, family-facing copy. The Realtime provider is instructed to
    /// read this exact text and may not add medical interpretation. Outside
    /// the route journey, the companion reads the same title and explanation
    /// already visible for the selected region—never a hidden model answer.
    var familyNarrationText: String {
        if pendingRegionDestination != nil {
            return "\(regionTransferFamilyTitle). \(regionTransferFamilySubtitle)"
        }
        guard experienceMode == .regionAtlas,
              activeRegionDestination != nil
        else { return "" }
        if isFlowRideActive {
            return "\(familyNarrationCue.title). \(familyNarrationCue.caption)"
        }
        return "\(regionFamilyCompanionTitle). \(regionFamilyCompanionSubtitle)"
    }

    /// These two lines are shared verbatim by the spatial threshold and the
    /// family narrator. They stay deliberately short so a region transfer can
    /// feel paced without becoming a spoken lecture.
    var regionTransferFamilyTitle: String {
        if isAnteriorGatewayTransitionActive { return "The route becomes a place" }
        guard let destination = pendingRegionDestination else { return "" }
        return "Entering \(destination.shortTitle)"
    }

    var regionTransferFamilySubtitle: String {
        if isAnteriorGatewayTransitionActive {
            return "The branch opens around you. Your body stays still."
        }
        return pendingRegionDestination == nil ? "" : "The room moves. You stay."
    }

    var regionFamilyCompanionTitle: String {
        guard let region = activeRegionDestination else { return "" }
        switch region {
        case .arterialLumen:
            return "Inside a blood vessel"
        case .circleOfWillis:
            if let anteriorPassagePhase {
                return switch anteriorPassagePhase {
                case .carotidApproach: "Two routes rise toward the brain"
                case .circleCrossroads: "The main routes meet and connect"
                case .middleCerebralContinuation: "Follow one route toward the side of the brain"
                }
            }
            return switch willisRouteFocus {
            case .overview: "Where the brain's main blood routes meet"
            case .anterior: "Routes toward the front of the brain"
            case .posterior: "Routes toward the back of the brain"
            }
        case .corticalExchange:
            return "Where blood supports brain tissue"
        case .ventricularSystem:
            return "Fluid spaces inside the brain"
        case .cerebellum:
            return switch regionVisualization {
            case .locate: "A folded area low at the back"
            case .xray: "Branches inside the folds"
            case .flow: "Blood routes approach the folded surface"
            }
        case .deepStructures:
            return switch regionVisualization {
            case .locate: "Structures deep inside the brain"
            case .xray: "A pathway corridor between them"
            case .flow: "Small arteries reach deep tissue"
            }
        case .frontalLobe:
            return isFrontalClotScenarioActive ? "One branch, interrupted" : "The front of the brain"
        case .corticalMicroarchitecture:
            return "Layers in the brain's outer surface"
        case .occipitalLobe:
            return switch regionVisualization {
            case .locate: "The brain area that receives visual signals"
            case .xray: "A folded surface involved in vision"
            case .flow: "Blood routes reach the visual area"
            }
        case .brainstem:
            if let posteriorVoyagePhase {
                return switch posteriorVoyagePhase {
                case .convergence: "Two blood routes approach"
                case .basilarBridge: "The routes join into one bridge"
                case .destinations: "Choose where to continue"
                }
            }
            return switch regionVisualization {
            case .locate: "The bridge between brain and body"
            case .xray: "Many pathways pass through a small space"
            case .flow: "Two blood routes join into one"
            }
        }
    }

    var regionFamilyCompanionSubtitle: String {
        guard let region = activeRegionDestination else { return "" }
        switch region {
        case .arterialLumen:
            return "This enlarged view shows the open channel where blood cells move. The wall around it is living tissue."
        case .circleOfWillis:
            if let anteriorPassagePhase {
                return switch anteriorPassagePhase {
                case .carotidApproach:
                    "A pair of arteries carries blood upward toward the connected network at the base of the brain."
                case .circleCrossroads:
                    "Several arteries meet here. The connections can offer alternate routes, but the pattern differs from person to person."
                case .middleCerebralContinuation:
                    "One example route stays bright as it continues toward the side of the brain. This is a teaching path, not patient-specific anatomy."
                }
            }
            return switch willisRouteFocus {
            case .overview:
                "Several arteries connect near the base of the brain. The exact pattern is different from person to person."
            case .anterior:
                "This view highlights blood routes continuing toward the front and sides of the brain."
            case .posterior:
                "This view highlights blood routes continuing toward the back of the brain."
            }
        case .corticalExchange:
            return "Very small vessels bring blood close to brain tissue. Oxygen can cross the vessel wall while blood cells remain inside."
        case .ventricularSystem:
            return "These connected spaces hold protective fluid. They are separate from the blood-vessel network."
        case .cerebellum:
            return switch regionVisualization {
            case .locate:
                "This folded part sits behind and below the larger brain. It helps coordinate movement."
            case .xray:
                "The teaching view opens the folds to show a branching inner pattern. It is enlarged and simplified for orientation."
            case .flow:
                "Several arteries approach this folded surface from the circulation at the back of the brain. Their exact paths vary."
            }
        case .deepStructures:
            return switch regionVisualization {
            case .locate:
                "Several important structures sit close together beneath the brain's outer surface. The outlines show their relationship."
            case .xray:
                "A compact passage carries many connections between the brain's surface and the rest of the body."
            case .flow:
                "Small branching arteries bring blood into deep brain tissue. A blockage here can affect nearby pathways."
            }
        case .frontalLobe:
            if isFrontalClotScenarioActive {
                return "A teaching blockage interrupts one example branch. The view shows the tissue beyond it without predicting an individual outcome."
            }
            return "This forward part of the brain supports planning, movement, speech, and behavior. Bright markers show an example blood route."
        case .corticalMicroarchitecture:
            return "This enlarged teaching fold shows layers around a small blood vessel. It is an orientation model, not a tissue sample."
        case .occipitalLobe:
            return switch regionVisualization {
            case .locate:
                "This area at the back of the brain helps process visual information. The opposite side stays visible for orientation."
            case .xray:
                "The teaching view opens a folded inner surface linked with vision. It is enlarged and is not a patient scan."
            case .flow:
                "Several arteries approach the brain's visual area from the circulation at the back. Their exact paths vary."
            }
        case .brainstem:
            if let posteriorVoyagePhase {
                return switch posteriorVoyagePhase {
                case .convergence:
                    "A pair of arteries approaches from below while the wearer stays still."
                case .basilarBridge:
                    "The two routes join and continue upward along the front of the brainstem."
                case .destinations:
                    "From this bridge, blood routes continue toward the folded area for coordination and the area for vision."
                }
            }
            return switch regionVisualization {
            case .locate:
                "This compact bridge connects the brain with the spinal cord and sits in front of the cerebellum."
            case .xray:
                "Many pathways pass through this compact area. The view separates them for teaching rather than showing a tissue scan."
            case .flow:
                "A pair of arteries joins into one main route, then branches toward nearby brain areas. The pattern varies between people."
            }
        }
    }

    var regionFamilyCompanionFact: String {
        guard let region = activeRegionDestination else { return "" }
        return switch region {
        case .arterialLumen:
            "Blood cells stay inside the vessel as they travel through its open channel."
        case .circleOfWillis:
            "The connected arterial pattern is not identical in every person."
        case .corticalExchange:
            "Oxygen crosses toward tissue; the red blood cell remains inside the vessel."
        case .ventricularSystem:
            "The brain's fluid spaces are not part of its arterial blood-flow network."
        case .cerebellum:
            "This area lies low at the back of the brain and helps coordinate movement."
        case .deepStructures:
            "Several small artery groups can supply deep tissue, and the pattern varies."
        case .frontalLobe:
            "This generic teaching view cannot predict what a particular person will experience."
        case .corticalMicroarchitecture:
            "The outer brain has layers, but their thickness and cell patterns vary by area."
        case .occipitalLobe:
            "The area at the back of the brain is central to processing visual information."
        case .brainstem:
            "The brainstem contains many pathways and supports vital connections between brain and body."
        }
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
        "\(pendingRegionDestination?.rawValue ?? -1)-\(regionTransferRun)-\(isAnteriorGatewayTransitionActive)"
    }

    var regionTransferDurationMilliseconds: Int {
        if isAnteriorGatewayTransitionActive {
            return effectiveReducedMotion ? 480 : 1_650
        }
        return effectiveReducedMotion ? 420 : 1_450
    }

    /// Live voice may hold the visual threshold long enough to finish its
    /// short reviewed line, but network or provider failure can never trap the
    /// wearer between regions.
    var regionTransferNarrationWaitLimitMilliseconds: Int { 7_000 }

    var activeWillisTitle: String {
        anteriorPassagePhase?.title ?? willisRouteFocus.title
    }

    var activeWillisSubtitle: String {
        anteriorPassagePhase?.subtitle ?? willisRouteFocus.subtitle
    }

    var activeWillisFact: String {
        anteriorPassagePhase?.fact ?? willisRouteFocus.fact
    }

    var activeCerebellumTitle: String {
        return switch regionVisualization {
        case .locate: "A folded world behind the brain"
        case .xray: "The tree inside the folds"
        case .flow: "Three routes from posterior circulation"
        }
    }

    var activeCerebellumSubtitle: String {
        return switch regionVisualization {
        case .locate:
            "The two cerebellar hemispheres and their midline vermis surround you as a constellation of repeated folds, posterior and inferior to the cerebrum."
        case .xray:
            "Parallel folia frame a branching white-matter guide called the arbor vitae. This enlarged reading is an orientation abstraction, not histology or measured anatomy."
        case .flow:
            "Gold fronts follow illustrative SCA, AICA, and PICA approaches around the cerebellar surface. Their paths show relationships, not a complete or individual vascular map."
        }
    }

    var activeCerebellumFact: String {
        return switch regionVisualization {
        case .locate:
            "The cerebellum lies behind the brainstem and below the posterior cerebrum."
        case .xray:
            "Its cortex forms many folia around branching white matter known as the arbor vitae."
        case .flow:
            "SCA, AICA, and PICA arise from the vertebrobasilar system; their anatomy and relative size vary."
        }
    }

    var activeDeepStructuresTitle: String {
        switch regionVisualization {
        case .locate: "Structures beneath the cortex"
        case .xray: "The corridor between the nuclei"
        case .flow: "Small branches, deep consequences"
        }
    }

    var activeDeepStructuresSubtitle: String {
        switch regionVisualization {
        case .locate:
            "The thalamus, caudate, and lentiform nuclei gather around a narrow central passage. Their outlines orient the relationship without claiming segmentation."
        case .xray:
            "The internal capsule carries dense white-matter pathways between deep gray structures. This enlarged luminous corridor is a spatial guide, not tractography or measured anatomy."
        case .flow:
            "Gold fronts follow illustrative M1 lenticulostriate, anterior choroidal, and posterior perforator approaches. They show routes into deep tissue, not fixed territories or individual blood supply."
        }
    }

    var activeDeepStructuresFact: String {
        switch regionVisualization {
        case .locate:
            "The internal capsule lies between the caudate and thalamus medially and the lentiform nucleus laterally."
        case .xray:
            "Its fibers connect the cerebral cortex with subcortical structures, brainstem, and spinal cord."
        case .flow:
            "Deep structures receive blood from several small perforator families; anatomy and territories vary."
        }
    }

    var activeOccipitalTitle: String {
        switch regionVisualization {
        case .locate: "The cortex that receives sight"
        case .xray: "A folded shoreline for vision"
        case .flow: "Posterior routes enter the visual cortex"
        }
    }

    var activeOccipitalSubtitle: String {
        switch regionVisualization {
        case .locate:
            "One medial occipital wall opens around you while the opposite hemisphere remains in the dim registered cortex. A sparse constellation locates the calcarine region without pretending to segment visual cortex."
        case .xray:
            "The upper and lower banks of the calcarine sulcus hold primary visual cortex. The luminous fold is enlarged for orientation, not measured anatomy or retinotopic mapping."
        case .flow:
            "Gold fronts follow illustrative posterior-cerebral, calcarine, parieto-occipital, and lingual approaches. They show route relationships, not fixed territories or individual blood supply."
        }
    }

    var activeOccipitalFact: String {
        switch regionVisualization {
        case .locate:
            "The occipital lobe is the posterior part of the cerebral hemisphere and is central to visual processing."
        case .xray:
            "Primary visual cortex lies along the calcarine sulcus on the medial occipital surface."
        case .flow:
            "Cortical branches of the posterior cerebral artery supply most of the occipital lobe; branch patterns and territories vary."
        }
    }

    var activeBrainstemTitle: String {
        if let posteriorVoyagePhase { return posteriorVoyagePhase.title }
        return switch regionVisualization {
        case .locate: "The bridge beneath the brain"
        case .xray: "Three levels, many pathways"
        case .flow: "Two vertebral routes become one"
        }
    }

    var activeBrainstemSubtitle: String {
        if let posteriorVoyagePhase { return posteriorVoyagePhase.subtitle }
        return switch regionVisualization {
        case .locate:
            "Midbrain, pons, and medulla form one continuous vertical passage between the cerebrum and spinal cord, with the cerebellum behind. Broken contours keep all three levels legible without claiming segmentation."
        case .xray:
            "Long ascending and descending pathway guides pass through all three levels while transverse pontine fibers cross the middle. The luminous layers are an enlarged relationship lesson, not tractography or measured anatomy."
        case .flow:
            "Paired vertebral approaches join into the basilar trunk along the pons. Gold fronts continue toward illustrative PICA, AICA, SCA, posterior-cerebral, and small pontine approaches without assigning fixed territories."
        }
    }

    var activeBrainstemFact: String {
        if let posteriorVoyagePhase { return posteriorVoyagePhase.fact }
        return switch regionVisualization {
        case .locate:
            "The brainstem comprises the midbrain, pons, and medulla and connects the cerebrum with the spinal cord and cerebellum."
        case .xray:
            "Brainstem gray matter and major ascending and descending pathways occupy a compact space, so this view separates relationships rather than reproducing histology."
        case .flow:
            "The vertebral arteries join to form the basilar artery; posterior-circulation branches and perforators approach the brainstem at several levels and vary between people."
        }
    }

    var familyNarrationProgressLabel: String {
        "FAMILY GUIDE  ·  \(familyNarrationMoment.guidanceVerb)  ·  \(familyNarrationMoment.number) / 03"
    }

    var guidedFlowTourProgressLabel: String {
        guidedFlowTourPhase == .complete
            ? "GUIDED JOURNEY  ·  COMPLETE"
            : "GUIDED JOURNEY  ·  \(guidedFlowTourPhase.progressNumber)"
    }

    var guidedFlowTourSequenceKey: String {
        "\(isFlowRideActive)-\(isGuidedFlowTourActive)-\(guidedFlowTourRun)"
    }

    var isGuidedFlowTourPlaying: Bool {
        isFlowRideActive && isGuidedFlowTourActive && guidedFlowTourPhase != .complete
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
        guard !isGuidedFlowTourActive else { return }
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
        guard !isGuidedFlowTourActive else { return }
        guard isFlowRideActive, flowRideRoute == .frontal else { return }
        isCapillaryFieldFocused.toggle()
        if isCapillaryFieldFocused {
            setFamilyNarrationMoment(.arrival)
        }
    }

    func advanceGuidedFlowTour() {
        guard isGuidedFlowTourPlaying,
              let next = RBCGuidedFlowTourPhase(rawValue: guidedFlowTourPhase.rawValue + 1)
        else { return }
        applyGuidedFlowTourPhase(next)
    }

    func restartGuidedFlowTour() {
        guard isFlowRideActive else { return }
        isGuidedFlowTourActive = true
        familyNarrationEnabled = true
        guidedFlowTourRun += 1
        applyGuidedFlowTourPhase(.source)
        isPaused = false
    }

    func enterFreeFlowExploration() {
        guard isFlowRideActive else { return }
        isGuidedFlowTourActive = false
        familyNarrationEnabled = false
        isPaused = false
    }

    private func applyGuidedFlowTourPhase(_ phase: RBCGuidedFlowTourPhase) {
        guidedFlowTourPhase = phase
        switch phase {
        case .source:
            flowRideRoute = .overview
            isCapillaryFieldFocused = false
            familyNarrationMoment = .orientation
        case .division:
            flowRideRoute = .overview
            isCapillaryFieldFocused = false
            familyNarrationMoment = .passage
        case .chooseFrontal:
            flowRideRoute = .overview
            isCapillaryFieldFocused = false
            familyNarrationMoment = .arrival
        case .enterFrontal:
            flowRideRoute = .frontal
            isCapillaryFieldFocused = false
            familyNarrationMoment = .orientation
        case .narrowTowardCortex:
            flowRideRoute = .frontal
            isCapillaryFieldFocused = false
            familyNarrationMoment = .passage
        case .capillaryArrival, .complete:
            flowRideRoute = .frontal
            isCapillaryFieldFocused = true
            familyNarrationMoment = .arrival
        }
        isPaused = false
        print("RBC_GUIDED_FLOW_TOUR=PHASE phase=\(phase.rawValue) progress=\(phase.progressNumber) route=\(flowRideRoute.id) capillary=\(isCapillaryFieldFocused)")
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
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
        familyNarrationEnabled = false
        exhibitBeat = .route
        station = exhibitBeat.station
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
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
        familyNarrationEnabled = false
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
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
        familyNarrationEnabled = false
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
        willisRouteFocus = .overview
        isFrontalClotScenarioActive = false
        isFlowRideActive = false
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
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
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
        isCapillaryFieldFocused = false
        isPaused = false
        isExhibitFactExpanded = false
    }

    func completePendingRegionTransfer() {
        guard let destination = pendingRegionDestination else { return }
        if isAnteriorGatewayTransitionActive, destination == .arterialLumen {
            pendingRegionDestination = nil
            isAnteriorGatewayTransitionActive = false
            startFlowRide()
            return
        }
        enterRegion(destination)
    }

    func selectWillisRouteFocus(_ focus: RBCWillisRouteFocus) {
        guard activeRegionDestination == .circleOfWillis,
              pendingRegionDestination == nil
        else { return }
        willisRouteFocus = focus
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        isPaused = false
    }

    func startAnteriorPassage() {
        guard activeRegionDestination == .circleOfWillis,
              pendingRegionDestination == nil
        else { return }
        willisRouteFocus = .anterior
        anteriorPassagePhase = .carotidApproach
        isPaused = false
    }

    func advanceAnteriorPassage() {
        guard let anteriorPassagePhase else { return }
        switch anteriorPassagePhase {
        case .carotidApproach:
            self.anteriorPassagePhase = .circleCrossroads
        case .circleCrossroads:
            self.anteriorPassagePhase = .middleCerebralContinuation
        case .middleCerebralContinuation:
            break
        }
        isPaused = false
    }

    func chooseAnteriorDestination(_ destination: RBCBrainRegionDestination) {
        guard anteriorPassagePhase == .middleCerebralContinuation,
              destination == .arterialLumen || destination == .frontalLobe
        else { return }
        if destination == .arterialLumen {
            beginAnteriorGatewayTransition()
        } else {
            requestRegion(destination)
        }
    }

    func beginAnteriorGatewayTransition() {
        guard anteriorPassagePhase == .middleCerebralContinuation,
              activeRegionDestination == .circleOfWillis,
              pendingRegionDestination == nil
        else { return }
        pendingRegionDestination = .arterialLumen
        isAnteriorGatewayTransitionActive = true
        regionTransferRun += 1
        isPaused = false
        isExhibitFactExpanded = false
    }

    func stopAnteriorPassage() {
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        isPaused = false
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
            anteriorPassagePhase = nil
            isAnteriorGatewayTransitionActive = false
            posteriorVoyagePhase = nil
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

    func selectRegionVisualization(_ mode: RBCRegionVisualizationMode) {
        regionVisualization = mode
        if mode != .flow {
            isFrontalClotScenarioActive = false
            anteriorPassagePhase = nil
            isAnteriorGatewayTransitionActive = false
            posteriorVoyagePhase = nil
        }
        isPaused = false
    }

    func startPosteriorVoyage() {
        guard activeRegionDestination == .brainstem,
              pendingRegionDestination == nil
        else { return }
        regionVisualization = .flow
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = .convergence
        isPaused = false
    }

    func advancePosteriorVoyage() {
        guard let posteriorVoyagePhase else { return }
        switch posteriorVoyagePhase {
        case .convergence:
            self.posteriorVoyagePhase = .basilarBridge
        case .basilarBridge:
            self.posteriorVoyagePhase = .destinations
        case .destinations:
            break
        }
        isPaused = false
    }

    func choosePosteriorDestination(_ destination: RBCBrainRegionDestination) {
        guard posteriorVoyagePhase == .destinations,
              destination == .cerebellum || destination == .occipitalLobe
        else { return }
        requestRegion(destination)
    }

    func stopPosteriorVoyage() {
        posteriorVoyagePhase = nil
        isPaused = false
    }

    func startFlowRide() {
        experienceMode = .regionAtlas
        pendingRegionDestination = nil
        activeRegionDestination = .arterialLumen
        station = .enterTheLumen
        openPortalIDs = []
        focusedPortalID = nil
        transferredPortalID = RBCBrainRegionDestination.arterialLumen.id
        regionVisualization = .flow
        isFrontalClotScenarioActive = false
        isFlowRideActive = true
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
        flowRideRoute = .overview
        isCapillaryFieldFocused = false
        isGuidedFlowTourActive = true
        guidedFlowTourPhase = .source
        guidedFlowTourRun += 1
        familyNarrationEnabled = true
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
        anteriorPassagePhase = nil
        isAnteriorGatewayTransitionActive = false
        posteriorVoyagePhase = nil
        isCapillaryFieldFocused = false
        isGuidedFlowTourActive = false
        guidedFlowTourPhase = .source
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

    @discardableResult
    func openNextPortal() -> Bool {
        guard let next = (0..<3).first(where: { !openPortalIDs.contains($0) }) else { return false }
        openPortalIDs.insert(next)
        focusedPortalID = next
        return true
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
