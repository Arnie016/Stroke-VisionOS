import Combine
import RealityKit
import SwiftUI
import UIKit

@MainActor
final class RBCJourneyScene {
    private enum WillisPathFamily {
        case anterior
        case posterior
        case connector
    }

    private enum WillisAnteriorSegment {
        case carotid
        case crossroads
        case middleCerebral
        case anteriorCerebralContext
    }

    private struct WillisPathRecord {
        let points: [SIMD3<Float>]
        let family: WillisPathFamily
        let anteriorSegment: WillisAnteriorSegment?
        let isSelectedAnteriorExemplar: Bool
    }

    let root = Entity()

    private let worldRoot = Entity()
    private let registeredContent = Entity()
    private let portalRoot = Entity()
    private let hudRoot = Entity()
    private let observationRoot = Entity()
    private let corticalVaultRoot = Entity()
    private let identityEchoRoot = Entity()
    private let causalStoryRoot = Entity()
    private let causalRouteRoot = Entity()
    private let downstreamTerritoryRoot = Entity()
    private let regionInteriorRoot = Entity()
    private let regionGuideRoot = Entity()
    private let regionTransferThresholdRoot = Entity()
    private let willisNetworkRoot = Entity()
    private let willisAnteriorRouteRoot = Entity()
    private let willisCarotidPassageRoot = Entity()
    private let willisCrossroadsPassageRoot = Entity()
    private let willisMiddleCerebralPassageRoot = Entity()
    private let willisSelectedMCAPassageRoot = Entity()
    private let willisContralateralMCAContextRoot = Entity()
    private let willisAnteriorGatewayRoot = Entity()
    private let willisAnteriorCerebralContextRoot = Entity()
    private let willisPosteriorRouteRoot = Entity()
    private let willisConnectorRoot = Entity()
    private let flowRideRoot = Entity()
    private let flowRideDirectionFieldRoot = Entity()
    private let flowRideInteriorShellRoot = Entity()
    private let flowRideForkFieldRoot = Entity()
    private let flowRideFrontalDestinationRoot = Entity()
    private let flowRideFrontalOutlineRoot = Entity()
    private let flowRideFrontalArterioleRoot = Entity()
    private let flowRideCapillaryWebRoot = Entity()
    private let flowRideNeighborDestinationRoot = Entity()
    private var flowRideCapillaryFocusTarget: Entity?
    private var flowRideFrontalDestinationCenter: SIMD3<Float> = .zero

    private var cortexLayer: Entity?
    private var deepLayer: Entity?
    private var ventricleLayer: Entity?
    private var arteryLayer: Entity?
    private var cranialVascularLayer: Entity?
    private var clotLayer: Entity?
    private var flowLayer: Entity?
    private var circleFlowLayer: Entity?
    private var blockageBeacon: Entity?
    private weak var infoAttachment: Entity?
    private var causalRouteSegments: [(entity: ModelEntity, phase: Float)] = []
    private var causalPulseMarkers: [(entity: ModelEntity, offset: Float)] = []
    private var causalRoutePath: [SIMD3<Float>] = []
    private var downstreamFacets: [(entity: ModelEntity, phase: Float)] = []
    private var frontalFlowPaths: [[SIMD3<Float>]] = []
    private var frontalFlowArrows: [(entity: Entity, pathIndex: Int, offset: Float)] = []
    private var frontalConstellationStars: [(entity: ModelEntity, phase: Float)] = []
    private var frontalConstellationRoot: Entity?
    private var frontalVesselRoot: Entity?
    private var frontalClotRoot: Entity?
    private var frontalDiscoveryTargets: [Entity] = []
    private var corticalMicroarchitectureOutlineRoot: Entity?
    private var corticalMicroarchitectureLayerRoot: Entity?
    private var corticalMicroarchitectureColumnRoot: Entity?
    private var corticalMicroarchitectureVesselRoot: Entity?
    private var corticalMicroarchitectureDiscoveryTargets: [Entity] = []
    private var corticalMicroarchitectureStars: [(entity: ModelEntity, phase: Float)] = []
    private var corticalMicroarchitectureFlowPaths: [[SIMD3<Float>]] = []
    private var corticalMicroarchitectureFlowArrows: [(entity: Entity, pathIndex: Int, offset: Float)] = []
    private var corticalMicroarchitectureRuntimeActive = false
    private var corticalMicroarchitectureRuntimeHeld = false
    private var corticalMicroarchitectureRuntimeVisualization: RBCRegionVisualizationMode = .locate
    private var corticalMicroarchitectureElapsed: Float = 0
    private var cerebellumAuthoredHero: Entity?
    private var cerebellumOutlineRoot: Entity?
    private var cerebellumFoliaRoot: Entity?
    private var cerebellumArborRoot: Entity?
    private var cerebellumVesselRoot: Entity?
    private var cerebellumDiscoveryTargets: [Entity] = []
    private var cerebellumGuideStars: [(entity: ModelEntity, phase: Float)] = []
    private var cerebellumFlowPaths: [[SIMD3<Float>]] = []
    private var cerebellumFlowArrows: [(entity: Entity, pathIndex: Int, offset: Float)] = []
    private var cerebellumRuntimeActive = false
    private var cerebellumRuntimeHeld = false
    private var cerebellumRuntimeVisualization: RBCRegionVisualizationMode = .locate
    private var cerebellumElapsed: Float = 0
    private var deepStructuresAuthoredHero: Entity?
    private var deepStructuresOutlineRoot: Entity?
    private var deepStructuresNucleiRoot: Entity?
    private var deepStructuresCapsuleRoot: Entity?
    private var deepStructuresVesselRoot: Entity?
    private var deepStructuresDiscoveryTargets: [Entity] = []
    private var deepStructuresGuideStars: [(entity: ModelEntity, phase: Float)] = []
    private var deepStructuresFlowPaths: [[SIMD3<Float>]] = []
    private var deepStructuresFlowArrows: [(entity: Entity, pathIndex: Int, offset: Float)] = []
    private var deepStructuresRuntimeActive = false
    private var deepStructuresRuntimeHeld = false
    private var deepStructuresRuntimeVisualization: RBCRegionVisualizationMode = .locate
    private var deepStructuresElapsed: Float = 0
    private var occipitalAuthoredHero: Entity?
    private var occipitalOutlineRoot: Entity?
    private var occipitalFoldRoot: Entity?
    private var occipitalCalcarineRoot: Entity?
    private var occipitalVesselRoot: Entity?
    private var occipitalDiscoveryTargets: [Entity] = []
    private var occipitalGuideStars: [(entity: ModelEntity, phase: Float)] = []
    private var occipitalFlowPaths: [[SIMD3<Float>]] = []
    private var occipitalFlowArrows: [(entity: Entity, pathIndex: Int, offset: Float)] = []
    private var occipitalRuntimeActive = false
    private var occipitalRuntimeHeld = false
    private var occipitalRuntimeVisualization: RBCRegionVisualizationMode = .locate
    private var occipitalElapsed: Float = 0
    private var brainstemAuthoredContext: Entity?
    private var brainstemOutlineRoot: Entity?
    private var brainstemPathwayRoot: Entity?
    private var brainstemVesselRoot: Entity?
    private let brainstemConvergenceRouteRoot = Entity()
    private let brainstemCerebellarRouteRoot = Entity()
    private let brainstemVisualRouteRoot = Entity()
    private let brainstemPontineRouteRoot = Entity()
    private var brainstemDiscoveryTargets: [Entity] = []
    private var brainstemGuideStars: [(entity: ModelEntity, phase: Float)] = []
    private var brainstemFlowPaths: [[SIMD3<Float>]] = []
    private var brainstemFlowFronts: [(entity: Entity, pathIndex: Int, offset: Float)] = []
    private var brainstemRuntimeActive = false
    private var brainstemRuntimeHeld = false
    private var brainstemRuntimeVisualization: RBCRegionVisualizationMode = .locate
    private var brainstemRuntimeVoyagePhase: RBCPosteriorVoyagePhase?
    private var brainstemVoyageTransitionProgress: Float = 1
    private var brainstemVoyageStartTransforms: [Transform] = []
    private var brainstemVoyageTargetTransforms: [Transform] = []
    private var brainstemVoyageStartOpacities: [Float] = [1, 1, 1, 1]
    private var brainstemVoyageTargetOpacities: [Float] = [1, 1, 1, 1]
    private var brainstemVoyageCurrentOpacities: [Float] = [1, 1, 1, 1]
    private var brainstemElapsed: Float = 0
    private var brainstemVoyageRouteRoots: [Entity] {
        [
            brainstemConvergenceRouteRoot,
            brainstemCerebellarRouteRoot,
            brainstemVisualRouteRoot,
            brainstemPontineRouteRoot,
        ]
    }
    private var regionTransferRings: [(
        entity: Entity,
        phase: Float,
        baseOrientation: simd_quatf
    )] = []
    private var regionTransferShards: [(
        entity: Entity,
        origin: SIMD3<Float>,
        direction: SIMD3<Float>,
        baseOrientation: simd_quatf,
        phase: Float
    )] = []
    private var regionTransferRuntimeID: Int?
    private var regionTransferRuntimeProofProgress: Float?
    private var regionTransferElapsed: Float = 0
    private var regionTransferReducedMotion = false
    private var regionTransferVisualProgress: Float = 0
    private weak var willisAuthoredHero: Entity?
    private weak var willisArterialContext: Entity?
    private var willisFlowPaths: [WillisPathRecord] = []
    private var willisFlowFronts: [(
        entity: Entity,
        pathIndex: Int,
        offset: Float
    )] = []
    private var willisRuntimeActive = false
    private var willisRuntimeHeld = false
    private var willisRuntimeFocus: RBCWillisRouteFocus = .overview
    private var willisRuntimeAnteriorPassagePhase: RBCAnteriorPassagePhase?
    private var willisElapsed: Float = 0
    private var flowRideCells: [(
        entity: Entity,
        origin: SIMD3<Float>,
        baseScale: SIMD3<Float>,
        baseOrientation: simd_quatf,
        phase: Float
    )] = []
    private var flowRideRibbonPaths: [[SIMD3<Float>]] = []
    private var flowRideRibbonSegments: [(
        entity: ModelEntity,
        progress: Float,
        laneOffset: Float
    )] = []
    private var flowRideForkSegments: [(
        entity: ModelEntity,
        progress: Float,
        route: RBCFlowRideRoute
    )] = []
    private var flowRideJourneyCells: [(
        entity: Entity,
        path: [SIMD3<Float>],
        baseScale: SIMD3<Float>,
        radialOffset: SIMD2<Float>,
        phase: Float,
        route: RBCFlowRideRoute
    )] = []
    private var flowRideMicrovascularGlints: [(
        entity: Entity,
        path: [SIMD3<Float>],
        offset: Float,
        speed: Float
    )] = []
    private var flowRideCapillaryExchangeRipples: [(
        entity: Entity,
        origin: SIMD3<Float>,
        phase: Float
    )] = []
    private var flowRideRuntimeRoute: RBCFlowRideRoute = .overview
    private var flowRideRuntimeCapillaryFocus = false
    private var flowRideCapillaryFocusMix: Float = 0
    private var flowRideElapsed: Float = 0
    private var flowRideWasActive = false
    private var flowRideRuntimeActive = false
    private var flowRideRuntimeHeld = false
    private var frameUpdateSubscription: (any Cancellable)?

    private var portals: [Int: Entity] = [:]
    private var portalEnergyRoots: [Int: Entity] = [:]
    private var portalOpacity: [Int: Float] = [:]
    private var portalBasePositions: [Int: SIMD3<Float>] = [:]
    private var portalBaseOrientations: [Int: simd_quatf] = [:]
    private var portalAnchorGuides: [Int: Entity] = [:]
    private var regionInteriors: [Int: Entity] = [:]
    private var regionBaseScales: [Int: SIMD3<Float>] = [:]
    private var flowAnimationControllers: [AnimationPlaybackController] = []
    private var flowController: AudioPlaybackController?
    private var animationsPaused = false
    private var built = false

    func build() async {
        guard !built else { return }
        built = true

        root.name = "rbc-journey-full-space-root"
        worldRoot.name = "calm-anatomical-atrium"
        registeredContent.name = "registered-living-brain-system"
        portalRoot.name = "multi-vessel-portal-system"
        hudRoot.name = "world-anchored-journey-hud"
        observationRoot.name = "stable-observation-field"
        corticalVaultRoot.name = "inside-cortical-vault"
        identityEchoRoot.name = "artistic-identity-echo-field-not-clinical"
        causalStoryRoot.name = "portal-projected-causal-story-field-pending-specialist-review"
        causalRouteRoot.name = "route-from-circle-to-example-right-m1"
        downstreamTerritoryRoot.name = "illustrative-downstream-consequence-field-not-segmentation"
        regionInteriorRoot.name = "user-controlled-region-transfer"
        regionGuideRoot.name = "surrounding-brain-orientation-guides"
        regionTransferThresholdRoot.name = "region-transfer-threshold-stationary-wearer-no-camera-locomotion"
        willisNetworkRoot.name = "room-scale-circle-of-willis-network-not-patient-specific"
        willisAnteriorRouteRoot.name = "qualitative-anterior-route-family"
        willisCarotidPassageRoot.name = "anterior-passage-paired-internal-carotid-approaches"
        willisCrossroadsPassageRoot.name = "anterior-passage-circle-crossroads"
        willisMiddleCerebralPassageRoot.name = "anterior-passage-middle-cerebral-continuations"
        willisSelectedMCAPassageRoot.name = "anterior-passage-selected-right-mca-exemplar-not-patient-specific"
        willisContralateralMCAContextRoot.name = "contralateral-mca-context-not-selected-route"
        willisAnteriorGatewayRoot.name = "right-mca-entry-threshold-to-inhabited-arterial-lumen"
        willisAnteriorCerebralContextRoot.name = "anterior-cerebral-context-not-selected-route"
        willisPosteriorRouteRoot.name = "qualitative-posterior-route-family"
        willisConnectorRoot.name = "communicating-artery-connection-family-no-fixed-flow-claim"
        flowRideRoot.name = "inside-arterial-lumen-flow-ride"
        flowRideDirectionFieldRoot.name = "continuous-intraluminal-direction-field-not-cfd"
        flowRideInteriorShellRoot.name = "native-inward-facing-arterial-corridor"
        flowRideForkFieldRoot.name = "user-selected-branching-flow-field-not-cfd"
        flowRideFrontalDestinationRoot.name = "frontal-route-constellation-outline-not-segmentation"
        flowRideFrontalOutlineRoot.name = "frontal-route-orientation-outline"
        flowRideFrontalArterioleRoot.name = "frontal-route-macro-arteriole-context"
        flowRideCapillaryWebRoot.name = "frontal-route-capillary-field-focus"
        flowRideNeighborDestinationRoot.name = "neighbor-route-tissue-point-field-not-segmentation"

        root.addChild(worldRoot)
        root.addChild(hudRoot)
        worldRoot.addChild(observationRoot)
        worldRoot.addChild(corticalVaultRoot)
        worldRoot.addChild(identityEchoRoot)
        worldRoot.addChild(causalStoryRoot)
        causalStoryRoot.addChild(causalRouteRoot)
        causalStoryRoot.addChild(downstreamTerritoryRoot)
        worldRoot.addChild(regionInteriorRoot)
        regionInteriorRoot.addChild(flowRideRoot)
        flowRideRoot.addChild(flowRideInteriorShellRoot)
        flowRideRoot.addChild(flowRideForkFieldRoot)
        flowRideRoot.addChild(flowRideFrontalDestinationRoot)
        flowRideRoot.addChild(flowRideNeighborDestinationRoot)
        flowRideFrontalDestinationRoot.addChild(flowRideFrontalOutlineRoot)
        worldRoot.addChild(portalRoot)
        worldRoot.addChild(regionGuideRoot)
        worldRoot.addChild(regionTransferThresholdRoot)
        corticalVaultRoot.addChild(registeredContent)

        buildLightingRig()
        buildObservationField()
        buildIdentityEchoField()
        await buildRegisteredAnatomy()
        await buildPortals()
        buildExtendedRegionInteriors()
        buildWillisNetworkInterior()
        buildFrontalRegionInterior()
        buildCorticalMicroarchitectureInterior()
        buildOccipitalRegionInterior()
        buildBrainstemRegionInterior()
        buildRegionTransferThreshold()
        buildCausalStoryField()
    }

    func installFrameUpdates() {
        guard frameUpdateSubscription == nil else { return }
        guard let scene = root.scene else {
            print("RBC_FRAME_UPDATES=PENDING reason=root_not_in_scene")
            return
        }
        frameUpdateSubscription = scene.subscribe(to: SceneEvents.Update.self) { [weak self] event in
            let deltaTime = Float(event.deltaTime)
            Task { @MainActor [weak self] in
                self?.advanceRegionTransferFrame(deltaTime: deltaTime)
                self?.advanceWillisNetworkFrame(deltaTime: deltaTime)
                self?.advanceCorticalMicroarchitectureFrame(deltaTime: deltaTime)
                self?.advanceCerebellumFrame(deltaTime: deltaTime)
                self?.advanceDeepStructuresFrame(deltaTime: deltaTime)
                self?.advanceOccipitalFrame(deltaTime: deltaTime)
                self?.advanceBrainstemFrame(deltaTime: deltaTime)
                self?.advanceFlowRideFrame(deltaTime: deltaTime)
            }
        }
        print("RBC_FRAME_UPDATES=READY source=RealityKit.SceneEvents.Update")
    }

    func update(
        station: RBCJourneyStation,
        preludeChapter: RBCEntryPreludeChapter?,
        exhibitBeat: RBCExhibitBeat?,
        openPortalIDs: Set<Int>,
        focusedPortalID: Int?,
        transferredPortalID: Int?,
        pendingRegionID: Int?,
        regionTransferProofProgress: Float?,
        regionVisualization: RBCRegionVisualizationMode,
        willisRouteFocus: RBCWillisRouteFocus,
        frontalClotScenarioActive: Bool,
        anteriorPassagePhase: RBCAnteriorPassagePhase?,
        posteriorVoyagePhase: RBCPosteriorVoyagePhase?,
        flowRideActive: Bool,
        flowRideRoute: RBCFlowRideRoute,
        capillaryFieldFocused: Bool,
        time: TimeInterval,
        paused: Bool,
        reducedMotion: Bool,
        soundEnabled: Bool,
        narrationDucking: Bool,
        showTeachingPoints: Bool
    ) {
        let motionHeld = paused || reducedMotion
        setAnimationsPaused(motionHeld)

        let t = Float(time)
        let preludeActive = preludeChapter != nil
        let transferActive = transferredPortalID != nil && !preludeActive
        let regionTransferPending = pendingRegionID != nil && !preludeActive
        let renderedRegionID = pendingRegionID ?? transferredPortalID
        let frontalRegionActive = renderedRegionID == RBCBrainRegionDestination.frontalLobe.id
        let willisRegionActive = renderedRegionID == RBCBrainRegionDestination.circleOfWillis.id
        let cerebellumRegionActive = renderedRegionID == RBCBrainRegionDestination.cerebellum.id
        let deepStructuresRegionActive = renderedRegionID == RBCBrainRegionDestination.deepStructures.id
        let occipitalRegionActive = renderedRegionID == RBCBrainRegionDestination.occipitalLobe.id
        let brainstemRegionActive = renderedRegionID == RBCBrainRegionDestination.brainstem.id
        let lumenRideActive = flowRideActive
            && transferredPortalID == RBCBrainRegionDestination.arterialLumen.id
            && !preludeActive
        portalRoot.isEnabled = !transferActive && !regionTransferPending && !preludeActive
        regionInteriorRoot.isEnabled = transferActive || regionTransferPending
        regionGuideRoot.isEnabled = showTeachingPoints
            && !transferActive
            && !regionTransferPending
            && !preludeActive
            && focusedPortalID == nil
        observationRoot.isEnabled = !preludeActive

        updateRegionTransferThreshold(
            pendingRegionID: pendingRegionID,
            proofProgress: regionTransferProofProgress,
            reducedMotion: reducedMotion
        )
        let arrivingRegionOpacity: Float = regionTransferPending
            ? 0.08 + regionTransferVisualProgress * 0.42
            : 1
        regionInteriorRoot.components.set(OpacityComponent(opacity: arrivingRegionOpacity))

        updatePreludeComposition(
            chapter: preludeChapter,
            reducedMotion: reducedMotion
        )

        let identityOpacity: Float = if preludeActive {
            0.035
        } else if regionTransferPending {
            0.055
        } else if transferActive {
            0.34
        } else {
            switch exhibitBeat {
            case .route: 0.12
            case .blockage: 0.22
            case .consequence: 0.30
            case nil: 0.18
            }
        }
        identityEchoRoot.components.set(OpacityComponent(opacity: identityOpacity))
        if !motionHeld {
            identityEchoRoot.orientation = simd_quatf(angle: sin(t * 0.07) * 0.025, axis: [0, 1, 0])
        }

        for (id, region) in regionInteriors {
            let active = renderedRegionID == id && !(lumenRideActive && id == RBCBrainRegionDestination.arterialLumen.id)
            region.isEnabled = active
            guard active, let baseScale = regionBaseScales[id] else { continue }
            let breath: Float = motionHeld ? 1 : 1 + sin(t * 0.55) * 0.012
            region.scale = baseScale * breath
        }
        updateFrontalRegion(
            active: frontalRegionActive,
            visualization: regionVisualization,
            clotScenarioActive: frontalClotScenarioActive,
            time: t,
            motionHeld: motionHeld
        )
        updateCorticalMicroarchitectureRegion(
            active: renderedRegionID == RBCBrainRegionDestination.corticalMicroarchitecture.id,
            visualization: regionVisualization,
            time: t,
            motionHeld: motionHeld
        )
        updateCerebellumRegion(
            active: cerebellumRegionActive,
            visualization: regionVisualization,
            motionHeld: motionHeld
        )
        updateDeepStructuresRegion(
            active: deepStructuresRegionActive,
            visualization: regionVisualization,
            motionHeld: motionHeld
        )
        updateOccipitalRegion(
            active: occipitalRegionActive,
            visualization: regionVisualization,
            motionHeld: motionHeld
        )
        updateBrainstemRegion(
            active: brainstemRegionActive,
            visualization: regionVisualization,
            voyagePhase: posteriorVoyagePhase,
            motionHeld: motionHeld
        )
        updateWillisNetwork(
            active: willisRegionActive,
            focus: willisRouteFocus,
            anteriorPassagePhase: anteriorPassagePhase,
            motionHeld: motionHeld,
            reducedMotion: reducedMotion
        )
        updateFlowRide(
            active: lumenRideActive,
            route: flowRideRoute,
            capillaryFieldFocused: capillaryFieldFocused,
            time: t,
            motionHeld: motionHeld
        )
        if let infoAttachment {
            let target: SIMD3<Float> = if anteriorPassagePhase != nil && willisRegionActive {
                [0, 1.78, -0.70]
            } else if posteriorVoyagePhase != nil && brainstemRegionActive {
                [0, 1.76, -0.70]
            } else if lumenRideActive && capillaryFieldFocused {
                [0, 1.78, -0.70]
            } else if lumenRideActive {
                [0, 1.72, -0.70]
            } else {
                [0, 2.08, -1.04]
            }
            infoAttachment.position += (target - infoAttachment.position) * (reducedMotion ? 1 : 0.22)
        }

        let blockageFocused = station == .meetTheBlockage || station == .seeTheTerritory
        let frontalCortexOpacity: Float = regionVisualization == .xray ? 0.045 : 0.10
        let frontalArteryOpacity: Float = regionVisualization == .locate ? 0.34 : 0.66
        cortexLayer?.components.set(OpacityComponent(opacity: preludeActive ? 0.28 : (frontalRegionActive ? frontalCortexOpacity : (transferActive ? 0.10 : (blockageFocused ? 0.16 : 0.20)))))
        deepLayer?.components.set(OpacityComponent(opacity: preludeActive ? 0.025 : (frontalRegionActive ? 0.14 : (transferActive ? 0.10 : (blockageFocused ? 0.18 : 0.22)))))
        ventricleLayer?.components.set(OpacityComponent(opacity: preludeActive ? 0.025 : (transferActive ? 0.12 : (blockageFocused ? 0.20 : 0.26))))
        arteryLayer?.components.set(OpacityComponent(opacity: preludeActive ? 0.018 : (frontalRegionActive ? frontalArteryOpacity : (transferActive ? 0.10 : 0.30))))
        cranialVascularLayer?.components.set(OpacityComponent(opacity: preludeActive ? 0.018 : (frontalRegionActive ? 0.24 : (transferActive ? 0.16 : (blockageFocused ? 0.34 : 0.42)))))
        let circleOpacity: Float = switch exhibitBeat {
        case .route: 0.78
        case .blockage: 0.52
        case .consequence: 0.20
        case nil: transferActive ? 0.12 : 0.42
        }
        circleFlowLayer?.components.set(OpacityComponent(opacity: circleOpacity))
        let clotOpacity: Float = switch exhibitBeat {
        case .route: 0.10
        case .blockage: 1.0
        case .consequence: 0.88
        case nil: transferActive ? 0.22 : (blockageFocused ? 1 : 0.90)
        }
        clotLayer?.components.set(OpacityComponent(opacity: clotOpacity))

        if let flowLayer {
            let frontalFlowBase: Float = regionVisualization == .flow ? 0.68 : 0.22
            let flowPulse: Float = frontalRegionActive
                ? (motionHeld ? frontalFlowBase : frontalFlowBase + sin(t * 2.1) * 0.10)
                : (motionHeld ? 0.30 : 0.28 + sin(t * 2.1) * 0.07)
            flowLayer.components.set(OpacityComponent(opacity: flowPulse))
        }
        if let blockageBeacon {
            let beaconPulse: Float = motionHeld ? 1 : 1 + sin(t * 3.4) * 0.20
            blockageBeacon.scale = [beaconPulse, beaconPulse, beaconPulse]
            blockageBeacon.isEnabled = blockageFocused
        }

        updateCausalStory(
            beat: exhibitBeat,
            time: t,
            motionHeld: motionHeld
        )

        for id in 0..<3 {
            guard let portal = portals[id] else { continue }
            let isOpen = openPortalIDs.contains(id)
            let target: Float = isOpen ? 1 : 0
            let current = portalOpacity[id] ?? target
            let next = reducedMotion ? target : current + (target - current) * 0.14
            portalOpacity[id] = next
            portal.isEnabled = next > 0.015
            portal.components.set(OpacityComponent(opacity: next))
            let emphasis: Float = focusedPortalID == id ? 1.22 : 0.86
            let openingScale = max(0.05, next) * emphasis
            portal.scale = [openingScale, openingScale, openingScale]
            if let basePosition = portalBasePositions[id] {
                let focusPosition = SIMD3<Float>(0, 1.68, -0.96)
                let targetPosition = focusedPortalID == id && isOpen ? focusPosition : basePosition
                portal.position += (targetPosition - portal.position) * (reducedMotion ? 1 : 0.14)
            }
            if let baseOrientation = portalBaseOrientations[id] {
                let targetOrientation = focusedPortalID == id && isOpen ? simd_quatf(angle: 0, axis: [0, 1, 0]) : baseOrientation
                portal.orientation = reducedMotion
                    ? targetOrientation
                    : simd_slerp(portal.orientation, targetOrientation, 0.14)
            }

            if let energy = portalEnergyRoots[id] {
                let energyPulse: Float = motionHeld ? 1 : 1 + sin(t * 2.8 + Float(id) * 0.9) * 0.035
                energy.scale = [energyPulse, energyPulse, 1]
            }

            if let guide = portalAnchorGuides[id] {
                guide.isEnabled = isOpen && focusedPortalID != id
                guide.components.set(OpacityComponent(opacity: next * 0.56))
            }
        }

        let exhibitGain: Double = switch exhibitBeat {
        case .route: -22
        case .blockage: -31
        case .consequence: -35
        case nil: -25
        }
        let mixedGain = narrationDucking ? min(exhibitGain, -42.0) : exhibitGain
        flowController?.gain = soundEnabled ? mixedGain : -96
    }

    func portalID(for entity: Entity) -> Int? {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name.hasPrefix("vascular-portal-"),
               let id = Int(current.name.replacingOccurrences(of: "vascular-portal-", with: "")) {
                return id
            }
            candidate = current.parent
        }
        return nil
    }

    func brainRegionID(for entity: Entity) -> Int? {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name.hasPrefix("brain-region-discovery-target-"),
               let idToken = current.name
                .replacingOccurrences(of: "brain-region-discovery-target-", with: "")
                .split(separator: "-")
                .first,
               let id = Int(idToken) {
                return id
            }
            candidate = current.parent
        }
        return nil
    }

    func isFrontalClotTarget(_ entity: Entity) -> Bool {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name.hasPrefix("illustrative-frontal-branch-occlusion-not-patient-specific") {
                return true
            }
            candidate = current.parent
        }
        return false
    }

    func isCapillaryFocusTarget(_ entity: Entity) -> Bool {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name == "frontal-capillary-field-focus-target" {
                return true
            }
            candidate = current.parent
        }
        return false
    }

    func attachTimeline(_ entity: Entity) {
        guard entity.parent == nil else { return }
        entity.name = "journey-timeline-attachment"
        entity.position = [0, 1.88, -0.70]
        entity.scale = [1.02, 1.02, 1.02]
        entity.components.set(BillboardComponent())
        hudRoot.addChild(entity)
    }

    func attachInfo(_ entity: Entity) {
        guard entity.parent == nil else { return }
        infoAttachment = entity
        entity.name = "journey-info-attachment"
        entity.position = [0, 2.08, -1.04]
        entity.scale = [0.86, 0.86, 0.86]
        entity.components.set(BillboardComponent())
        hudRoot.addChild(entity)
    }

    func prepareForPrelude(_ chapter: RBCEntryPreludeChapter) {
        let state = preludeTransform(for: chapter, reducedMotion: false)
        corticalVaultRoot.scale = [state.scale, state.scale, state.scale]
        corticalVaultRoot.position = state.position
    }

    func attachControls(_ entity: Entity) {
        guard entity.parent == nil else { return }
        entity.name = "journey-controls-attachment"
        entity.position = [0, 1.00, -0.52]
        entity.scale = [0.92, 0.92, 0.92]
        entity.components.set(BillboardComponent())
        hudRoot.addChild(entity)
    }

    func attachRegionReel(_ entity: Entity) {
        guard entity.parent == nil else { return }
        entity.name = "region-portal-reel-attachment"
        entity.position = [0, 0.62, -0.90]
        entity.scale = [0.62, 0.62, 0.62]
        entity.components.set(BillboardComponent())
        hudRoot.addChild(entity)
    }

    func attachLandmark(_ entity: Entity, landmark: BrainOrientationLandmark) {
        guard entity.parent == nil else { return }
        entity.name = landmark.attachmentID
        entity.position = landmark.position
        entity.scale = [0.72, 0.72, 0.72]
        entity.components.set(BillboardComponent())
        regionGuideRoot.addChild(entity)
    }

    /// A bounded, front-facing threshold communicates a region change while
    /// the wearer remains at the same observation origin. The broken laminar
    /// contours and outward fibers borrow the language of the surrounding
    /// tissue without pretending to be anatomy.
    private func buildRegionTransferThreshold() {
        regionTransferThresholdRoot.position = [0, 1.28, -1.34]

        let teal = glowMaterial(
            color: UIColor(red: 0.30, green: 0.92, blue: 0.74, alpha: 0.88),
            intensity: 3.0
        )
        let crimson = glowMaterial(
            color: UIColor(red: 0.94, green: 0.16, blue: 0.25, alpha: 0.82),
            intensity: 2.7
        )

        for ringIndex in 0..<4 {
            let ring = Entity()
            ring.name = "irregular-laminar-region-threshold-contour-\(ringIndex)"
            let ringPhase = Float(ringIndex) * 0.73
            let xRadius: Float = 0.43 + Float(ringIndex) * 0.047
            let yRadius: Float = 0.31 + Float(ringIndex) * 0.039
            var points: [SIMD3<Float>] = []
            for index in 0..<72 {
                let angle = Float(index) / 72 * .pi * 2
                let irregularity = 1
                    + sin(angle * 3 + ringPhase) * 0.072
                    + cos(angle * 5 - ringPhase) * 0.032
                points.append([
                    cos(angle) * xRadius * irregularity + sin(angle * 2 + ringPhase) * 0.018,
                    sin(angle) * yRadius * irregularity + cos(angle * 3 - ringPhase) * 0.014,
                    sin(angle * 4 + ringPhase) * 0.024 + (Float(ringIndex) - 1.5) * 0.028,
                ])
            }
            // Four separated arcs keep this from reading as a flat bullseye.
            for arcIndex in 0..<4 {
                let start = arcIndex * 18 + 1 + ((ringIndex + arcIndex) % 3)
                let end = min(start + 13 + ((ringIndex + arcIndex) % 2), points.count - 1)
                addTubePath(
                    Array(points[start...end]),
                    to: ring,
                    radius: 0.0024 - Float(ringIndex) * 0.00022,
                    material: ringIndex == 2 ? crimson : teal,
                    name: "region-threshold-broken-laminar-filament-\(ringIndex)-\(arcIndex)"
                )
            }
            let baseOrientation = simd_quatf(
                angle: (Float(ringIndex) - 1) * 0.035,
                axis: [0, 0, 1]
            )
            ring.orientation = baseOrientation
            regionTransferThresholdRoot.addChild(ring)
            regionTransferRings.append((ring, ringPhase, baseOrientation))
        }

        for index in 0..<32 {
            let phase = Float(index) / 32
            let angle = phase * .pi * 2
            let xRadius: Float = 0.52 + sin(Float(index) * 1.7) * 0.035
            let yRadius: Float = 0.39 + cos(Float(index) * 1.3) * 0.028
            let origin = SIMD3<Float>(
                cos(angle) * xRadius,
                sin(angle) * yRadius,
                sin(Float(index) * 0.91) * 0.028
            )
            let direction = simd_normalize(SIMD3<Float>(origin.x, origin.y, origin.z * 0.35))
            let length: Float = 0.026 + Float(index % 5) * 0.007
            let shard = ModelEntity(
                mesh: .generateBox(
                    size: [0.004 + Float(index % 3) * 0.001, length, 0.003],
                    cornerRadius: 0.0015
                ),
                materials: [index.isMultiple(of: 7) ? crimson : teal]
            )
            shard.name = "outward-cortical-fiber-threshold-shard-\(index)"
            let baseOrientation = simd_quatf(angle: angle, axis: [0, 0, 1])
                * simd_quatf(angle: sin(Float(index) * 1.41) * 0.16, axis: [1, 0, 0])
            shard.position = origin
            shard.orientation = baseOrientation
            regionTransferThresholdRoot.addChild(shard)
            regionTransferShards.append((shard, origin, direction, baseOrientation, phase))
        }

        regionTransferThresholdRoot.components.set(OpacityComponent(opacity: 0))
        regionTransferThresholdRoot.isEnabled = false
        print("RBC_REGION_THRESHOLD=READY contours=4 broken_arcs=16 fibers=32 camera_motion=none")
    }

    private func updateRegionTransferThreshold(
        pendingRegionID: Int?,
        proofProgress: Float?,
        reducedMotion: Bool
    ) {
        guard let pendingRegionID else {
            regionTransferRuntimeID = nil
            regionTransferRuntimeProofProgress = nil
            regionTransferElapsed = 0
            regionTransferVisualProgress = 0
            regionTransferThresholdRoot.isEnabled = false
            return
        }

        if regionTransferRuntimeID != pendingRegionID {
            regionTransferRuntimeID = pendingRegionID
            regionTransferElapsed = 0
        }
        regionTransferRuntimeProofProgress = proofProgress
        regionTransferReducedMotion = reducedMotion
        regionTransferThresholdRoot.isEnabled = true

        if let proofProgress {
            applyRegionTransferThreshold(progress: proofProgress, reducedMotion: reducedMotion)
        } else if reducedMotion {
            applyRegionTransferThreshold(progress: 0.56, reducedMotion: true)
        }
    }

    private func advanceRegionTransferFrame(deltaTime: Float) {
        guard regionTransferRuntimeID != nil,
              regionTransferRuntimeProofProgress == nil,
              !regionTransferReducedMotion
        else { return }

        regionTransferElapsed = min(regionTransferElapsed + deltaTime, 1.45)
        applyRegionTransferThreshold(
            progress: regionTransferElapsed / 1.45,
            reducedMotion: false
        )
    }

    private func applyRegionTransferThreshold(progress rawProgress: Float, reducedMotion: Bool) {
        let progress = min(max(rawProgress, 0), 1)
        regionTransferVisualProgress = progress
        let eased = progress * progress * (3 - 2 * progress)
        let apertureScale: Float = reducedMotion
            ? 1.18
            : 0.34 + eased * 1.95
        regionTransferThresholdRoot.scale = [apertureScale, apertureScale, apertureScale]
        let opacity: Float = reducedMotion
            ? 0.72
            : max(0.04, sin(progress * .pi) * 0.96)
        regionTransferThresholdRoot.components.set(OpacityComponent(opacity: opacity))

        for ring in regionTransferRings {
            let pulse = reducedMotion
                ? 1
                : 1 + sin(progress * .pi * 2 + ring.phase) * 0.035
            ring.entity.scale = [pulse, pulse, 1]
            ring.entity.orientation = ring.baseOrientation * simd_quatf(
                angle: reducedMotion ? 0 : (eased - 0.5) * 0.10 * sin(ring.phase + 0.8),
                axis: [0, 0, 1]
            )
        }

        for shard in regionTransferShards {
            let stagger = min(max((progress - shard.phase * 0.10) / 0.90, 0), 1)
            let travel: Float = reducedMotion ? 0.035 : stagger * stagger * 0.38
            shard.entity.position = shard.origin + shard.direction * travel
            shard.entity.orientation = shard.baseOrientation * simd_quatf(
                angle: reducedMotion ? 0 : stagger * 0.24 * sin(shard.phase * 17),
                axis: [0, 0, 1]
            )
            let stretch: Float = 0.72 + stagger * 0.82
            shard.entity.scale = [1, stretch, 1]
        }
    }

    func installSpatialAudio() async {
        guard flowController == nil,
              let url = Bundle.main.url(forResource: "FlowBed", withExtension: "wav")
        else { return }

        let configuration = AudioFileResource.Configuration(shouldLoop: true)
        guard let resource = try? await AudioFileResource(
            contentsOf: url,
            withName: "registered-cerebral-flow-bed",
            configuration: configuration
        ) else { return }

        let emitter = Entity()
        emitter.name = "anatomy-bound-spatial-flow-emitter"
        emitter.position = [0, 1.42, -0.30]
        emitter.spatialAudio = SpatialAudioComponent(gain: -25)
        worldRoot.addChild(emitter)

        let controller = emitter.prepareAudio(resource)
        controller.gain = -25
        controller.play()
        flowController = controller
    }

    func stopAudio() {
        flowController?.stop()
        flowController = nil
    }

    private func buildRegisteredAnatomy() async {
        let layers: [(name: String, opacity: Float)] = [
            ("brain_anatomy_realistic_v2", 0.20),
            ("brain_deep_structures_v2", 0.38),
            ("brain_ventricles_v2", 0.52),
            ("cerebral_arteries_realistic_v2", 0.94),
            ("cranial_vascular_registered_assembly_v2", 0.42),
            ("circle_of_willis_flow_overlay_v2", 0.74),
            ("ischemic_mca_clot_v2", 0.90),
            ("cerebral_bloodflow_animation_v2", 0.72)
        ]

        for layerSpec in layers {
            guard let layer = await loadBundledUSDZ(named: layerSpec.name) else { continue }
            layer.name = "registered-layer-\(layerSpec.name)"
            layer.components.set(OpacityComponent(opacity: layerSpec.opacity))

            switch layerSpec.name {
            case "brain_anatomy_realistic_v2":
                cortexLayer = layer
                applyMaterialRecursively(corticalVaultMaterial(), to: layer)
                if let cerebellum = layer.findEntity(named: "Cerebellum") {
                    applyMaterialRecursively(
                        tissueContextMaterial(
                            color: UIColor(red: 0.34, green: 0.12, blue: 0.17, alpha: 0.34),
                            emissive: UIColor(red: 0.42, green: 0.10, blue: 0.16, alpha: 1)
                        ),
                        to: cerebellum
                    )
                }
                if let brainstem = layer.findEntity(named: "Brainstem") {
                    applyMaterialRecursively(
                        tissueContextMaterial(
                            color: UIColor(red: 0.30, green: 0.12, blue: 0.22, alpha: 0.38),
                            emissive: UIColor(red: 0.34, green: 0.12, blue: 0.30, alpha: 1)
                        ),
                        to: brainstem
                    )
                }
            case "brain_deep_structures_v2":
                deepLayer = layer
                applyMaterialRecursively(
                    tissueContextMaterial(
                        color: UIColor(red: 0.36, green: 0.16, blue: 0.38, alpha: 0.05),
                        emissive: UIColor(red: 0.46, green: 0.18, blue: 0.56, alpha: 1)
                    ),
                    to: layer
                )
            case "brain_ventricles_v2":
                ventricleLayer = layer
                applyMaterialRecursively(
                    tissueContextMaterial(
                        color: UIColor(red: 0.20, green: 0.54, blue: 0.68, alpha: 0.06),
                        emissive: UIColor(red: 0.22, green: 0.72, blue: 0.90, alpha: 1)
                    ),
                    to: layer
                )
            case "cerebral_arteries_realistic_v2":
                arteryLayer = layer
                applyMaterialRecursively(
                    tissueContextMaterial(
                        color: UIColor(red: 0.76, green: 0.11, blue: 0.13, alpha: 0.07),
                        emissive: UIColor(red: 0.92, green: 0.12, blue: 0.14, alpha: 1)
                    ),
                    to: layer
                )
            case "cranial_vascular_registered_assembly_v2":
                cranialVascularLayer = layer
                layer.isEnabled = false
            case "circle_of_willis_flow_overlay_v2": circleFlowLayer = layer
            case "ischemic_mca_clot_v2":
                clotLayer = layer
                applyMaterialRecursively(
                    glowMaterial(
                        color: UIColor(red: 1.0, green: 0.23, blue: 0.035, alpha: 1),
                        intensity: 2.8
                    ),
                    to: layer
                )
                addBlockageBeacon(to: layer)
            case "cerebral_bloodflow_animation_v2":
                flowLayer = layer
                playAllAnimations(in: layer)
            default: break
            }
            registeredContent.addChild(layer)
        }

        if let cortexLayer {
            normalize(registeredContent, around: cortexLayer, targetExtent: 5.2)
        } else {
            normalize(registeredContent, targetExtent: 5.2)
        }
        registeredContent.name = "large-inside-out-cortical-vault"
        corticalVaultRoot.position = [0.58, 1.10, -0.18]
        corticalVaultRoot.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
    }

    private func updatePreludeComposition(
        chapter: RBCEntryPreludeChapter?,
        reducedMotion: Bool
    ) {
        let target = chapter.map { preludeTransform(for: $0, reducedMotion: reducedMotion) }
            ?? (scale: Float(1), position: SIMD3<Float>(0.58, 1.10, -0.18))
        let response: Float = reducedMotion ? 1 : 0.055
        let uniformTarget = SIMD3<Float>(repeating: target.scale)
        corticalVaultRoot.scale += (uniformTarget - corticalVaultRoot.scale) * response
        corticalVaultRoot.position += (target.position - corticalVaultRoot.position) * response

        if let infoAttachment {
            let position: SIMD3<Float> = chapter == nil
                ? [0, 2.08, -1.04]
                : [0, 1.58, -0.72]
            let scale: Float = chapter == nil ? 0.86 : 0.66
            let attachmentResponse: Float = reducedMotion ? 1 : 0.12
            infoAttachment.position += (position - infoAttachment.position) * attachmentResponse
            infoAttachment.scale += (SIMD3<Float>(repeating: scale) - infoAttachment.scale) * attachmentResponse
        }
    }

    private func preludeTransform(
        for chapter: RBCEntryPreludeChapter,
        reducedMotion: Bool
    ) -> (scale: Float, position: SIMD3<Float>) {
        if reducedMotion {
            return (0.56, [0.32, 1.14, -0.92])
        }
        switch chapter {
        case .threshold: return (0.17, [0.08, 1.25, -2.30])
        case .anatomy: return (0.29, [0.20, 1.20, -1.62])
        case .problem: return (0.46, [0.36, 1.15, -0.92])
        case .invitation: return (0.68, [0.50, 1.11, -0.42])
        }
    }

    private func buildIdentityEchoField() {
        let facetMesh = MeshResource.generateBox(
            size: [0.055, 0.012, 0.020],
            cornerRadius: 0.008
        )
        let facetMaterial = glowMaterial(
            color: UIColor(red: 0.54, green: 0.26, blue: 0.34, alpha: 0.32),
            intensity: 0.34
        )

        for layer in 0..<3 {
            let radius = 1.28 + Float(layer) * 0.32
            let height = 1.08 + Float(layer) * 0.26
            for index in 0..<24 {
                let angle = Float(index) / 24 * 2 * .pi + Float(layer) * 0.22
                let facet = ModelEntity(mesh: facetMesh, materials: [facetMaterial])
                facet.name = "identity-memory-facet-\(layer)-\(index)"
                facet.position = [
                    cos(angle) * radius,
                    height + sin(angle * 2) * 0.16,
                    -0.32 + sin(angle) * radius
                ]
                facet.orientation = simd_quatf(angle: -angle, axis: [0, 1, 0])
                identityEchoRoot.addChild(facet)
            }
        }
    }

    private func buildCausalStoryField() {
        guard
            let routePoint = portalBasePositions[RBCVesselPortal.circleOfWillis.id],
            let blockagePoint = portalBasePositions[RBCVesselPortal.lumen.id]
        else {
            print("RBC_CAUSAL_FIELD=DISABLED reason=missing_portal_projection")
            causalStoryRoot.isEnabled = false
            return
        }

        // The same named-entity directions and 1.26 m comfort projection used
        // by the portals define the exhibit trail. It visualizes a teaching
        // relationship without pretending to be vessel centerline data.
        // Preserve which anatomical directions are being related, then bring
        // that relation into the fixed observation pocket. This intentional
        // presentation projection is legible from a seated pose; it is not a
        // vessel centerline or a claim that these points share a flat plane.
        let blockageX = min(max(blockagePoint.x * 0.56, -0.42), 0.42)
        let approachSign: Float = blockageX >= 0 ? -1 : 1
        let projectedRouteX = min(max(routePoint.x * 0.56, -0.42), 0.42)
        let startX = abs(projectedRouteX - blockageX) >= 0.38
            ? projectedRouteX
            : blockageX + approachSign * 0.66
        let blockage = SIMD3<Float>(blockageX, 1.34, -0.70)
        let start = SIMD3<Float>(startX, 1.62, -0.70)
        let rawDirection = blockage - start
        let length = simd_length(rawDirection)
        guard length > 0.04 else {
            print("RBC_CAUSAL_FIELD=DISABLED reason=collapsed_projection")
            causalStoryRoot.isEnabled = false
            return
        }

        let direction = rawDirection / length
        let referenceUp = abs(simd_dot(direction, SIMD3<Float>(0, 1, 0))) > 0.92
            ? SIMD3<Float>(1, 0, 0)
            : SIMD3<Float>(0, 1, 0)
        let lateral = simd_normalize(simd_cross(direction, referenceUp))
        let vertical = simd_normalize(simd_cross(lateral, direction))

        let lumenMaterial = glowMaterial(
            color: UIColor(red: 0.70, green: 0.035, blue: 0.055, alpha: 0.88),
            intensity: 1.05
        )
        let flowMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.66, blue: 0.46, alpha: 0.98),
            intensity: 3.4
        )
        let control = (start + blockage) * 0.5 + vertical * min(length * 0.24, 0.18)

        for index in 0..<49 {
            let progress = Float(index) / 48
            let inverse = 1 - progress
            let point = inverse * inverse * start
                + 2 * inverse * progress * control
                + progress * progress * blockage
            causalRoutePath.append(point)
        }

        for index in 1..<causalRoutePath.count {
            let from = causalRoutePath[index - 1]
            let to = causalRoutePath[index]
            let delta = to - from
            let segmentLength = simd_length(delta)
            guard segmentLength > 0.0001 else { continue }
            let segment = ModelEntity(
                mesh: .generateCylinder(height: segmentLength * 1.08, radius: 0.0090),
                materials: [lumenMaterial]
            )
            segment.name = "continuous-selected-lumen-segment-\(index)"
            segment.position = (from + to) * 0.5
            segment.orientation = simd_quatf(from: [0, 1, 0], to: delta / segmentLength)
            let flowCore = ModelEntity(
                mesh: .generateCylinder(height: segmentLength * 1.09, radius: 0.0028),
                materials: [flowMaterial]
            )
            flowCore.name = "continuous-flow-core-\(index)"
            segment.addChild(flowCore)
            causalRouteRoot.addChild(segment)
            causalRouteSegments.append((segment, Float(index) / Float(causalRoutePath.count - 1)))
        }

        let pulseMesh = MeshResource.generateCone(height: 0.052, radius: 0.015)
        for index in 0..<11 {
            let pulse = ModelEntity(mesh: pulseMesh, materials: [flowMaterial])
            pulse.name = "intraluminal-flow-direction-arrow-\(index)"
            causalRouteRoot.addChild(pulse)
            causalPulseMarkers.append((pulse, Float(index) / 11))
        }

        let territoryMaterial = glowMaterial(
            color: UIColor(red: 0.50, green: 0.14, blue: 0.34, alpha: 0.68),
            intensity: 1.42
        )
        // A restrained field of thin facets reads as downstream tissue context.
        // It is deliberately an exhibit metaphor, not perfusion segmentation.
        let fieldCenter = blockage + SIMD3<Float>(approachSign * -0.16, 0.12, -0.035)
        let facetMesh = MeshResource.generateBox(
            size: [0.020, 0.0035, 0.008],
            cornerRadius: 0.002
        )
        let goldenAngle: Float = 2.399_963
        for index in 0..<72 {
            let phase = Float(index + 1) / 72
            let angle = Float(index) * goldenAngle
            let radius = sqrt(phase) * 0.20
            let depth = (Float(index % 7) / 6 - 0.5) * 0.07
            let facet = ModelEntity(mesh: facetMesh, materials: [territoryMaterial])
            facet.name = "downstream-teaching-facet-\(index)"
            facet.position = fieldCenter
                + lateral * cos(angle) * radius
                + vertical * sin(angle) * radius * 0.74
                + direction * depth
            facet.orientation = simd_quatf(angle: angle + phase * 0.8, axis: direction)
            downstreamTerritoryRoot.addChild(facet)
            downstreamFacets.append((facet, phase))
        }

        causalStoryRoot.isEnabled = false
        print("RBC_CAUSAL_FIELD=READY lumen_segments=\(causalRouteSegments.count) flow_pulses=\(causalPulseMarkers.count) downstream_branches=\(downstreamFacets.count)")
    }

    private func updateCausalStory(
        beat: RBCExhibitBeat?,
        time: Float,
        motionHeld: Bool
    ) {
        guard let beat else {
            causalStoryRoot.isEnabled = false
            return
        }
        causalStoryRoot.isEnabled = true

        let routeOpacity: Float = switch beat {
        case .route: 0.92
        case .blockage: 0.48
        case .consequence: 0.18
        }
        let territoryOpacity: Float = switch beat {
        case .route: 0.025
        case .blockage: 0.12
        case .consequence: 0.76
        }
        causalRouteRoot.components.set(OpacityComponent(opacity: routeOpacity))
        downstreamTerritoryRoot.components.set(OpacityComponent(opacity: territoryOpacity))

        for item in causalRouteSegments {
            let breathingLight = motionHeld ? 0.96 : 0.93 + 0.07 * sin(time * 1.6 - item.phase * 4.2)
            item.entity.scale = [breathingLight, 1, breathingLight]
        }

        for item in causalPulseMarkers {
            let progress = motionHeld
                ? min(0.72, item.offset)
                : (item.offset + time * 0.14).truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: causalRoutePath, progress: progress)
            let ahead = interpolatedPoint(on: causalRoutePath, progress: min(progress + 0.025, 1))
            item.entity.position = point + SIMD3<Float>(0, 0, 0.024)
            let tangent = ahead - point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(from: [0, 1, 0], to: simd_normalize(tangent))
            }
            let pulseScale: Float = beat == .route ? 1 : (beat == .blockage ? 0.74 : 0.48)
            item.entity.scale = [pulseScale, pulseScale, pulseScale]
        }

        for item in downstreamFacets {
            let wave = motionHeld
                ? 0.82
                : 0.76 + sin(time * 1.4 - item.phase * 4.8) * 0.18
            let consequenceScale = beat == .consequence
                ? wave * (0.78 + item.phase * 0.42)
                : 0.58
            item.entity.scale = [consequenceScale, consequenceScale, consequenceScale]
        }
    }

    private func interpolatedPoint(on path: [SIMD3<Float>], progress: Float) -> SIMD3<Float> {
        guard path.count > 1 else { return path.first ?? .zero }
        let clamped = min(max(progress, 0), 1)
        let scaled = clamped * Float(path.count - 1)
        let lower = min(Int(scaled), path.count - 2)
        let fraction = scaled - Float(lower)
        return simd_mix(path[lower], path[lower + 1], SIMD3<Float>(repeating: fraction))
    }

    private func buildPortals() async {
        let definitions: [(id: Int, asset: String, anchorEntity: String, fallback: SIMD3<Float>)] = [
            (0, "artery_cutaway_complete_v2", "Right_M1_Large_Vessel_Occlusion", [-1.04, 1.42, -1.02]),
            (1, "circle_of_willis_flow_overlay_v2", "Flow_Route_Anterior_Communicating", [0.00, 0.98, 1.12]),
            (2, "microcirculation_arterial_venous_v2", "Cerebral_Cortex_R", [1.04, 1.42, -1.02])
        ]

        for definition in definitions {
            guard let preview = await loadBundledUSDZ(named: definition.asset) else { continue }
            let anchor = geometryDerivedPortalAnchor(
                sourceEntityName: definition.anchorEntity,
                fallback: definition.fallback
            )
            let portal = Entity()
            portal.name = "vascular-portal-\(definition.id)"
            portal.position = anchor.interactionPoint
            portalBasePositions[definition.id] = anchor.interactionPoint
            let directionToWearer = SIMD3<Float>(0, 1.42, 0) - anchor.interactionPoint
            let portalOrientation = simd_quatf(
                angle: atan2(directionToWearer.x, directionToWearer.z),
                axis: [0, 1, 0]
            )
            portal.orientation = portalOrientation
            portalBaseOrientations[definition.id] = portalOrientation
            portal.components.set(OpacityComponent(opacity: 0))
            portal.components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))
            portal.components.set(CollisionComponent(shapes: [.generateBox(size: [0.42, 0.42, 0.09])]))
            portal.components.set(HoverEffectComponent())
            portal.isEnabled = false

            let aperture = ModelEntity(
                mesh: .generateCylinder(height: 0.009, radius: 0.168),
                materials: [
                    glowMaterial(
                        color: UIColor(red: 0.018, green: 0.012, blue: 0.020, alpha: 0.94),
                        intensity: 0.08
                    )
                ]
            )
            aperture.name = "portal-aperture-\(definition.id)"
            aperture.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
            aperture.position.z = -0.012
            portal.addChild(aperture)

            let energy = makePortalEnergyRing(id: definition.id)
            portal.addChild(energy)
            portalEnergyRoots[definition.id] = energy

            preview.name = "portal-preview-\(definition.asset)"
            let region = Entity()
            region.name = "transferred-region-interior-\(definition.id)"
            let regionHero = preview.clone(recursive: true)
            regionHero.name = "transferred-region-hero-\(definition.id)"
            normalize(regionHero, targetExtent: definition.id == 1 ? 2.15 : 1.85)
            regionHero.position += [0, 1.44, -1.32]
            region.addChild(regionHero)
            if definition.id == RBCBrainRegionDestination.circleOfWillis.id {
                willisAuthoredHero = regionHero
            }

            if definition.id == 1, let arteryLayer {
                let arterialContext = arteryLayer.clone(recursive: true)
                arterialContext.name = "circle-transfer-high-resolution-cerebral-tree-context"
                normalize(arterialContext, targetExtent: 2.72)
                arterialContext.position += [0, 1.43, -1.48]
                arterialContext.components.set(OpacityComponent(opacity: 0.42))
                region.addChild(arterialContext)
                willisArterialContext = arterialContext
            }
            region.isEnabled = false
            regionInteriorRoot.addChild(region)
            regionInteriors[definition.id] = region
            regionBaseScales[definition.id] = region.scale

            if definition.id == RBCBrainRegionDestination.arterialLumen.id {
                let rideHero = preview.clone(recursive: true)
                rideHero.name = "room-scale-arterial-cutaway-authored-asset"
                normalize(rideHero, targetExtent: 9.20)
                let forwardRotation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
                let openCutawayUpward = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
                rideHero.orientation = forwardRotation * openCutawayUpward
                // Keep the cutaway mouth beyond the near-field comfort zone.
                // The user looks down the lumen rather than intersecting walls.
                rideHero.position += [0, 1.50, -5.60]
                flowRideRoot.addChild(rideHero)

                let authoredWallMaterial = firstPhysicallyBasedMaterial(
                    in: rideHero,
                    namePrefix: "Combined_Artery_Media"
                )
                for outerWall in descendants(in: rideHero, namePrefix: "Combined_Artery_Adventitia") {
                    outerWall.isEnabled = false
                }
                for middleWall in descendants(in: rideHero, namePrefix: "Combined_Artery_Media") {
                    middleWall.isEnabled = false
                }
                for innerWall in descendants(in: rideHero, namePrefix: "Combined_Artery_Intima") {
                    innerWall.isEnabled = false
                }

                let cells = descendants(in: rideHero, namePrefix: "Combined_Blood_RBC_")
                let authoredCellPrototype = cells.first?.clone(recursive: true)
                let cellMaterial = bloodCellMaterial()
                for cell in cells {
                    cell.scale *= 0.28
                    replaceMaterials(in: cell, with: cellMaterial)
                    cell.isEnabled = false
                }
                flowRideCells = cells.enumerated().map { index, entity in
                    (
                        entity,
                        entity.position,
                        entity.scale,
                        entity.orientation,
                        Float(index) / Float(max(cells.count, 1))
                    )
                }
                let arrows = descendants(in: rideHero, namePrefix: "Combined_Blood_Arrow_")
                for arrow in arrows {
                    // Replace the imported yellow droplet-like arrows with a
                    // restrained continuous field and six clear coral fronts.
                    arrow.isEnabled = false
                }
                for streamline in descendants(in: rideHero, namePrefix: "Combined_Blood_Streamline_") {
                    streamline.isEnabled = false
                }
                for bloodVolume in descendants(in: rideHero, namePrefix: "Combined_Blood_Volume") {
                    bloodVolume.isEnabled = false
                }
                // The imported straight-cutaway direction field is retained
                // as an authored reference but hidden here. Its local scaling
                // produced oversized lines after a route transfer; the native
                // branching corridor now owns the visible continuous route.
                flowRideDirectionFieldRoot.isEnabled = false
                buildInhabitedArterialCorridor(
                    cellPrototype: authoredCellPrototype,
                    authoredWallMaterial: authoredWallMaterial
                )
                flowRideRoot.isEnabled = false
                print("RBC_FLOW_RIDE=READY authored_cells=\(flowRideCells.count) journey_cells=\(flowRideJourneyCells.count) ribbons=\(flowRideRibbonPaths.count) fork_routes=2 inward_corridor=true")
            }

            normalize(preview, targetExtent: definition.id == 1 ? 0.32 : 0.31)
            if definition.id == 0 {
                preview.orientation = simd_quatf(angle: -.pi / 2, axis: [0, 1, 0])
            }
            preview.position.z = 0.025
            portal.addChild(preview)

            portalRoot.addChild(portal)
            let guide = makeAnchorGuide(
                id: definition.id,
                from: anchor.interactionPoint,
                to: anchor.sourcePoint,
                sourceEntityName: definition.anchorEntity,
                usedFallback: anchor.usedFallback
            )
            portalRoot.addChild(guide)
            portalAnchorGuides[definition.id] = guide
            portals[definition.id] = portal
            portalOpacity[definition.id] = 0
        }
    }

    private func buildExtendedRegionInteriors() {
        if let ventricleLayer {
            installExtendedRegionInterior(
                id: RBCBrainRegionDestination.ventricularSystem.id,
                source: ventricleLayer,
                name: "ventricular-system-region-portal",
                targetExtent: 1.86
            )
        }

        if let cerebellum = cortexLayer?.findEntity(named: "Cerebellum") {
            buildCerebellumRegionInterior(source: cerebellum)
        }

        if let deepLayer {
            buildDeepStructuresRegionInterior(source: deepLayer)
        }
    }

    /// A room-scale cerebellar observatory. The registered mesh remains as a
    /// dim positional reference, while the native outline, repeated folial
    /// bands, arbor-vitae guide, and vertebrobasilar approaches expand around
    /// the wearer. This is an orientation abstraction—not histology, territory
    /// segmentation, patient anatomy, or a complete vascular reconstruction.
    private func buildCerebellumRegionInterior(source: Entity) {
        let id = RBCBrainRegionDestination.cerebellum.id
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-cerebellum-region-portal-cerebellar-observatory"

        let authoredHero = source.clone(recursive: true)
        authoredHero.name = "registered-cerebellum-reference-expanded-environment-not-floating-model"
        normalize(authoredHero, targetExtent: 2.65)
        authoredHero.position += [0, 1.40, -2.16]
        authoredHero.components.set(OpacityComponent(opacity: 0.13))
        region.addChild(authoredHero)
        cerebellumAuthoredHero = authoredHero

        let outlineRoot = Entity()
        outlineRoot.name = "cerebellum-constellation-outline-not-segmentation"
        region.addChild(outlineRoot)
        cerebellumOutlineRoot = outlineRoot

        let foliaRoot = Entity()
        foliaRoot.name = "magnified-cerebellar-folia-orientation-bands-not-histology"
        region.addChild(foliaRoot)
        cerebellumFoliaRoot = foliaRoot

        let arborRoot = Entity()
        arborRoot.name = "magnified-arbor-vitae-orientation-abstraction-not-histology"
        region.addChild(arborRoot)
        cerebellumArborRoot = arborRoot

        let vesselRoot = Entity()
        vesselRoot.name = "qualitative-sca-aica-pica-vertebrobasilar-approaches-not-patient-specific"
        region.addChild(vesselRoot)
        cerebellumVesselRoot = vesselRoot

        let outlineMaterial = glowMaterial(
            color: UIColor(red: 0.46, green: 0.96, blue: 0.82, alpha: 0.74),
            intensity: 1.75
        )
        let starMaterial = glowMaterial(
            color: UIColor(red: 0.84, green: 1.00, blue: 0.93, alpha: 0.96),
            intensity: 3.0
        )
        let foliaMaterial = tissueContextMaterial(
            color: UIColor(red: 0.40, green: 0.21, blue: 0.22, alpha: 0.48),
            emissive: UIColor(red: 0.66, green: 0.38, blue: 0.33, alpha: 1)
        )
        let arborMaterial = glowMaterial(
            color: UIColor(red: 0.90, green: 0.84, blue: 0.64, alpha: 0.76),
            intensity: 1.25
        )

        let silhouetteControls: [SIMD3<Float>] = [
            [-0.10, 0.70, -1.90], [-0.70, 0.64, -1.98],
            [-1.28, 0.80, -2.10], [-1.58, 1.20, -2.22],
            [-1.49, 1.70, -2.30], [-1.14, 2.03, -2.22],
            [-0.64, 2.17, -2.08], [-0.19, 2.05, -1.96],
            [0.00, 1.80, -1.88], [0.21, 2.08, -1.97],
            [0.69, 2.20, -2.10], [1.19, 1.99, -2.25],
            [1.52, 1.64, -2.31], [1.57, 1.16, -2.23],
            [1.25, 0.77, -2.09], [0.68, 0.62, -1.97],
            [0.10, 0.70, -1.90],
        ]
        let silhouette = sampleClosedCatmullRom(silhouetteControls, samplesPerSegment: 6)
        addContinuousTubePath(
            silhouette,
            to: outlineRoot,
            startRadius: 0.0026,
            endRadius: 0.0026,
            material: outlineMaterial,
            name: "cerebellar-hemisphere-vermis-constellation-contour",
            radialSegments: 8
        )

        let starMesh = MeshResource.generateSphere(radius: 0.008)
        for (index, point) in silhouetteControls.enumerated() {
            let star = ModelEntity(mesh: starMesh, materials: [starMaterial])
            star.name = "cerebellar-constellation-guide-star-\(index)"
            star.position = point + SIMD3<Float>(0, 0, 0.006)
            outlineRoot.addChild(star)
            cerebellumGuideStars.append((star, Float(index) * 0.63))
        }

        // Side ribs extend the silhouette toward peripheral vision so the
        // destination reads as a place around the wearer, not a small object.
        for ribIndex in 0..<7 {
            let progress = Float(ribIndex) / 6
            let y = 0.86 + progress * 1.10
            let spread = 1.30 + sin(progress * .pi) * 0.24
            for side: Float in [-1, 1] {
                let rib = sampleCubicBezier(
                    [side * spread, y, -2.11],
                    [side * 1.62, y + 0.035, -1.86],
                    [side * 1.78, y + 0.065, -1.46],
                    [side * 1.66, y + 0.10, -1.16],
                    samples: 30
                )
                addContinuousTubePath(
                    rib,
                    to: outlineRoot,
                    startRadius: 0.0024,
                    endRadius: 0.0012,
                    material: outlineMaterial,
                    name: "cerebellar-peripheral-depth-rib-\(ribIndex)-\(side < 0 ? "left" : "right")",
                    radialSegments: 7
                )
            }
        }

        // Parallel leaf-like bands establish the cerebellum's repeated-fold
        // visual signature. Spacing and curvature are illustrative.
        for bandIndex in 0..<19 {
            let progress = Float(bandIndex) / 18
            let y = 0.76 + progress * 1.34
            let width = 0.56 + sin(progress * .pi) * 0.80
            let phase = Float(bandIndex) * 0.71
            let depth = -1.91 - cos(progress * .pi * 2 + 0.35) * 0.10
            for side: Float in [-1, 1] {
                let band = sampleCubicBezier(
                    [side * 0.07, y + sin(phase) * 0.035, depth + 0.10],
                    [side * (0.28 + width * 0.18), y + 0.15 + cos(phase) * 0.035, depth - 0.04],
                    [side * (0.44 + width * 0.68), y - 0.12 + sin(phase * 1.4) * 0.04, depth - 0.14],
                    [side * (0.46 + width), y + sin(phase + side * 0.8) * 0.07, depth + 0.02],
                    samples: 38
                )
                addContinuousTubePath(
                    band,
                    to: foliaRoot,
                    startRadius: 0.0052,
                    endRadius: 0.0020,
                    material: foliaMaterial,
                    name: "cerebellar-folium-guide-band-\(bandIndex)-\(side < 0 ? "left" : "right")",
                    radialSegments: 9
                )
            }
        }
        for bandIndex in 0..<9 {
            let progress = Float(bandIndex) / 8
            let y = 0.82 + progress * 1.08
            let vermisBand = sampleCubicBezier(
                [-0.25, y, -1.94], [-0.10, y + 0.06, -1.87],
                [0.10, y + 0.06, -1.87], [0.25, y, -1.94],
                samples: 24
            )
            addContinuousTubePath(
                vermisBand,
                to: foliaRoot,
                startRadius: 0.0034,
                endRadius: 0.0034,
                material: foliaMaterial,
                name: "cerebellar-vermis-fold-guide-\(bandIndex)",
                radialSegments: 8
            )
        }

        let arborPaths: [(String, [SIMD3<Float>], Float, Float)] = [
            ("central-trunk", sampleCubicBezier([0, 0.72, -1.91], [0, 1.05, -1.94], [0, 1.66, -1.96], [0, 2.05, -1.99], samples: 46), 0.015, 0.007),
            ("left-superior", sampleCubicBezier([0, 1.72, -1.96], [-0.28, 1.84, -1.97], [-0.66, 2.02, -2.00], [-1.10, 2.06, -2.04], samples: 38), 0.009, 0.003),
            ("right-superior", sampleCubicBezier([0, 1.72, -1.96], [0.28, 1.84, -1.97], [0.66, 2.02, -2.00], [1.10, 2.06, -2.04], samples: 38), 0.009, 0.003),
            ("left-middle", sampleCubicBezier([0, 1.43, -1.95], [-0.30, 1.50, -1.97], [-0.82, 1.63, -2.02], [-1.32, 1.62, -2.07], samples: 40), 0.010, 0.003),
            ("right-middle", sampleCubicBezier([0, 1.43, -1.95], [0.30, 1.50, -1.97], [0.82, 1.63, -2.02], [1.32, 1.62, -2.07], samples: 40), 0.010, 0.003),
            ("left-inferior", sampleCubicBezier([0, 1.14, -1.94], [-0.28, 1.08, -1.98], [-0.72, 0.88, -2.03], [-1.18, 0.78, -2.06], samples: 38), 0.010, 0.003),
            ("right-inferior", sampleCubicBezier([0, 1.14, -1.94], [0.28, 1.08, -1.98], [0.72, 0.88, -2.03], [1.18, 0.78, -2.06], samples: 38), 0.010, 0.003),
            ("left-superior-crown", sampleCubicBezier([-0.48, 1.93, -1.99], [-0.63, 2.05, -2.03], [-0.86, 2.13, -2.08], [-1.17, 2.15, -2.12], samples: 28), 0.0055, 0.0018),
            ("right-superior-crown", sampleCubicBezier([0.48, 1.93, -1.99], [0.63, 2.05, -2.03], [0.86, 2.13, -2.08], [1.17, 2.15, -2.12], samples: 28), 0.0055, 0.0018),
            ("left-middle-fan", sampleCubicBezier([-0.55, 1.56, -2.00], [-0.72, 1.67, -2.04], [-0.99, 1.76, -2.10], [-1.31, 1.78, -2.16], samples: 28), 0.0055, 0.0018),
            ("right-middle-fan", sampleCubicBezier([0.55, 1.56, -2.00], [0.72, 1.67, -2.04], [0.99, 1.76, -2.10], [1.31, 1.78, -2.16], samples: 28), 0.0055, 0.0018),
            ("left-inferior-fan", sampleCubicBezier([-0.49, 1.00, -1.99], [-0.68, 0.91, -2.03], [-0.91, 0.76, -2.09], [-1.20, 0.68, -2.13], samples: 28), 0.0050, 0.0016),
            ("right-inferior-fan", sampleCubicBezier([0.49, 1.00, -1.99], [0.68, 0.91, -2.03], [0.91, 0.76, -2.09], [1.20, 0.68, -2.13], samples: 28), 0.0050, 0.0016),
        ]
        for path in arborPaths {
            addContinuousTubePath(
                path.1,
                to: arborRoot,
                startRadius: path.2,
                endRadius: path.3,
                material: arborMaterial,
                name: "arbor-vitae-guide-\(path.0)",
                radialSegments: 10
            )
        }

        let vesselMaterial = tissueContextMaterial(
            color: UIColor(red: 0.42, green: 0.012, blue: 0.025, alpha: 0.86),
            emissive: UIColor(red: 0.72, green: 0.018, blue: 0.036, alpha: 1)
        )
        let flowCoreMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.24, blue: 0.15, alpha: 0.30),
            intensity: 1.1
        )
        let flowFrontMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.78, blue: 0.42, alpha: 0.98),
            intensity: 4.1
        )
        typealias CerebellarPathSpec = (
            name: String,
            controls: (SIMD3<Float>, SIMD3<Float>, SIMD3<Float>, SIMD3<Float>),
            startRadius: Float,
            endRadius: Float,
            fronts: Int
        )
        let vesselSpecs: [CerebellarPathSpec] = [
            ("left-vertebral-approach", ([-0.25, 0.34, -1.36], [-0.21, 0.54, -1.39], [-0.10, 0.72, -1.43], [0, 0.84, -1.46]), 0.018, 0.014, 1),
            ("right-vertebral-approach", ([0.25, 0.34, -1.36], [0.21, 0.54, -1.39], [0.10, 0.72, -1.43], [0, 0.84, -1.46]), 0.018, 0.014, 1),
            ("basilar-trunk", ([0, 0.84, -1.46], [0, 1.08, -1.49], [0, 1.48, -1.52], [0, 1.76, -1.55]), 0.019, 0.014, 2),
            ("left-sca-approach", ([0, 1.69, -1.55], [-0.28, 1.77, -1.58], [-0.78, 1.92, -1.69], [-1.30, 2.00, -1.82]), 0.012, 0.0045, 2),
            ("right-sca-approach", ([0, 1.69, -1.55], [0.28, 1.77, -1.58], [0.78, 1.92, -1.69], [1.30, 2.00, -1.82]), 0.012, 0.0045, 2),
            ("left-aica-approach", ([0, 1.23, -1.50], [-0.30, 1.28, -1.56], [-0.82, 1.33, -1.66], [-1.36, 1.37, -1.79]), 0.011, 0.0042, 2),
            ("right-aica-approach", ([0, 1.23, -1.50], [0.30, 1.28, -1.56], [0.82, 1.33, -1.66], [1.36, 1.37, -1.79]), 0.011, 0.0042, 2),
            ("left-pica-approach", ([-0.20, 0.53, -1.39], [-0.42, 0.59, -1.52], [-0.82, 0.72, -1.72], [-1.24, 0.84, -1.88]), 0.011, 0.0040, 2),
            ("right-pica-approach", ([0.20, 0.53, -1.39], [0.42, 0.59, -1.52], [0.82, 0.72, -1.72], [1.24, 0.84, -1.88]), 0.011, 0.0040, 2),
            ("left-sca-folial-continuation", ([-1.30, 2.00, -1.82], [-1.39, 2.10, -1.94], [-1.47, 1.96, -2.10], [-1.54, 1.82, -2.20]), 0.0045, 0.0022, 1),
            ("right-sca-folial-continuation", ([1.30, 2.00, -1.82], [1.39, 2.10, -1.94], [1.47, 1.96, -2.10], [1.54, 1.82, -2.20]), 0.0045, 0.0022, 1),
            ("left-aica-folial-continuation", ([-1.36, 1.37, -1.79], [-1.48, 1.47, -1.91], [-1.50, 1.31, -2.09], [-1.56, 1.16, -2.20]), 0.0042, 0.0020, 1),
            ("right-aica-folial-continuation", ([1.36, 1.37, -1.79], [1.48, 1.47, -1.91], [1.50, 1.31, -2.09], [1.56, 1.16, -2.20]), 0.0042, 0.0020, 1),
            ("left-pica-folial-continuation", ([-1.24, 0.84, -1.88], [-1.35, 0.76, -1.98], [-1.42, 0.66, -2.10], [-1.31, 0.61, -2.17]), 0.0040, 0.0018, 1),
            ("right-pica-folial-continuation", ([1.24, 0.84, -1.88], [1.35, 0.76, -1.98], [1.42, 0.66, -2.10], [1.31, 0.61, -2.17]), 0.0040, 0.0018, 1),
        ]
        let arrowHeadMesh = MeshResource.generateCone(height: 0.024, radius: 0.0075)
        let arrowTailMesh = MeshResource.generateCylinder(height: 0.034, radius: 0.0021)
        for (pathIndex, spec) in vesselSpecs.enumerated() {
            let path = sampleCubicBezier(
                spec.controls.0, spec.controls.1, spec.controls.2, spec.controls.3,
                samples: 50
            )
            cerebellumFlowPaths.append(path)
            addContinuousTubePath(
                path,
                to: vesselRoot,
                startRadius: spec.startRadius,
                endRadius: spec.endRadius,
                material: vesselMaterial,
                name: "cerebellar-\(spec.name)-continuous-wall",
                radialSegments: 16
            )
            addContinuousTubePath(
                path,
                to: vesselRoot,
                startRadius: spec.startRadius * 0.30,
                endRadius: spec.endRadius * 0.32,
                material: flowCoreMaterial,
                name: "cerebellar-\(spec.name)-continuous-flow-core",
                radialSegments: 9
            )
            for frontIndex in 0..<spec.fronts {
                let arrow = Entity()
                arrow.name = "cerebellar-tangent-flow-front-\(spec.name)-\(frontIndex)"
                let head = ModelEntity(mesh: arrowHeadMesh, materials: [flowFrontMaterial])
                head.name = "cerebellar-flow-front-arrowhead"
                head.position.y = 0.022
                let tail = ModelEntity(mesh: arrowTailMesh, materials: [flowFrontMaterial])
                tail.name = "cerebellar-flow-front-tail"
                tail.position.y = -0.022
                arrow.addChild(head)
                arrow.addChild(tail)
                vesselRoot.addChild(arrow)
                cerebellumFlowArrows.append((
                    arrow,
                    pathIndex,
                    (Float(frontIndex) / Float(max(spec.fronts, 1)) + Float(pathIndex) * 0.113)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        let overviewTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "overview",
            position: [1.20, 1.02, -1.46],
            collisionRadius: 0.20
        )
        regionGuideRoot.addChild(overviewTarget)
        cerebellumDiscoveryTargets.append(overviewTarget)
        let activeTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "active",
            position: [1.30, 1.24, -1.58],
            collisionRadius: 0.22
        )
        region.addChild(activeTarget)
        cerebellumDiscoveryTargets.append(activeTarget)

        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
        print("RBC_CEREBELLAR_OBSERVATORY=READY folia_bands=47 arbor_paths=13 arterial_paths=15 moving_fronts=22 registered_reference=true")
    }

    /// A surrounding relationship lesson for central anatomy. The imported
    /// mesh is one combined source without semantic submeshes, so it remains a
    /// dim registered reference. Native constellations identify only broad
    /// relationships among thalamus, basal ganglia, and the internal capsule;
    /// they are not segmentation, tractography, or patient anatomy.
    private func buildDeepStructuresRegionInterior(source: Entity) {
        let id = RBCBrainRegionDestination.deepStructures.id
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-deep-structures-region-portal-observatory"

        let authoredHero = source.clone(recursive: true)
        authoredHero.name = "registered-combined-deep-structures-reference-expanded-environment-not-segmentation"
        normalize(authoredHero, targetExtent: 2.52)
        authoredHero.position += [0, 1.42, -2.04]
        authoredHero.components.set(OpacityComponent(opacity: 0.12))
        region.addChild(authoredHero)
        deepStructuresAuthoredHero = authoredHero

        let outlineRoot = Entity()
        outlineRoot.name = "deep-nuclei-constellation-outlines-not-segmentation"
        region.addChild(outlineRoot)
        deepStructuresOutlineRoot = outlineRoot

        let nucleiRoot = Entity()
        nucleiRoot.name = "thalamus-caudate-lentiform-relational-guides-not-measured-anatomy"
        region.addChild(nucleiRoot)
        deepStructuresNucleiRoot = nucleiRoot

        let capsuleRoot = Entity()
        capsuleRoot.name = "internal-capsule-corridor-orientation-abstraction-not-tractography"
        region.addChild(capsuleRoot)
        deepStructuresCapsuleRoot = capsuleRoot

        let vesselRoot = Entity()
        vesselRoot.name = "qualitative-deep-perforator-approaches-not-fixed-territories"
        region.addChild(vesselRoot)
        deepStructuresVesselRoot = vesselRoot

        let outlineMaterial = glowMaterial(
            color: UIColor(red: 0.46, green: 0.92, blue: 0.82, alpha: 0.80),
            intensity: 1.8
        )
        let starMaterial = glowMaterial(
            color: UIColor(red: 0.82, green: 1.0, blue: 0.94, alpha: 0.96),
            intensity: 2.8
        )
        let thalamusMaterial = tissueContextMaterial(
            color: UIColor(red: 0.34, green: 0.22, blue: 0.48, alpha: 0.46),
            emissive: UIColor(red: 0.50, green: 0.30, blue: 0.72, alpha: 1)
        )
        let basalGangliaMaterial = tissueContextMaterial(
            color: UIColor(red: 0.42, green: 0.18, blue: 0.30, alpha: 0.46),
            emissive: UIColor(red: 0.66, green: 0.26, blue: 0.46, alpha: 1)
        )
        let capsuleMaterial = glowMaterial(
            color: UIColor(red: 0.91, green: 0.85, blue: 0.66, alpha: 0.84),
            intensity: 1.6
        )

        func irregularLoop(
            center: SIMD3<Float>,
            radii: SIMD2<Float>,
            phase: Float,
            depth: Float
        ) -> [SIMD3<Float>] {
            (0..<12).map { index in
                let angle = Float(index) / 12 * .pi * 2
                let irregularity = 1 + sin(angle * 3 + phase) * 0.055
                return [
                    center.x + cos(angle) * radii.x * irregularity,
                    center.y + sin(angle) * radii.y * (1 + cos(angle * 2 + phase) * 0.045),
                    center.z + sin(angle * 2 + phase) * depth,
                ]
            }
        }

        typealias NucleusGuide = (
            name: String,
            center: SIMD3<Float>,
            radii: SIMD2<Float>,
            phase: Float,
            depth: Float,
            material: RealityKit.Material
        )
        let nucleusGuides: [NucleusGuide] = [
            ("left-thalamus", [-0.30, 1.39, -1.91], [0.30, 0.42], 0.2, 0.16, thalamusMaterial),
            ("right-thalamus", [0.30, 1.39, -1.95], [0.30, 0.42], 1.1, 0.16, thalamusMaterial),
            ("left-lentiform", [-0.84, 1.40, -1.88], [0.38, 0.54], 0.8, 0.22, basalGangliaMaterial),
            ("right-lentiform", [0.84, 1.40, -1.92], [0.38, 0.54], 1.7, 0.22, basalGangliaMaterial),
        ]
        for (guideIndex, guide) in nucleusGuides.enumerated() {
            let controls = irregularLoop(
                center: guide.center,
                radii: guide.radii,
                phase: guide.phase,
                depth: guide.depth * 0.56
            )
            let path = sampleClosedCatmullRom(controls, samplesPerSegment: 6)
            addContinuousTubePath(
                path,
                to: nucleiRoot,
                startRadius: 0.0028,
                endRadius: 0.0028,
                material: guide.material,
                name: "deep-nucleus-relational-contour-\(guide.name)",
                radialSegments: 9
            )
            for (pointIndex, point) in controls.enumerated() where pointIndex.isMultiple(of: 3) {
                let star = ModelEntity(
                    mesh: .generateSphere(radius: 0.0065),
                    materials: [starMaterial]
                )
                star.name = "deep-nucleus-constellation-star-\(guide.name)-\(pointIndex)"
                star.position = point
                outlineRoot.addChild(star)
                deepStructuresGuideStars.append((star, Float(guideIndex * 4 + pointIndex) * 0.37))
            }

            // A deterministic Fibonacci shell gives the nuclei readable
            // volume from changing viewpoints without claiming a segmented
            // surface or packing the scene with solid toy shapes.
            let pointMesh = MeshResource.generateSphere(radius: 0.0046)
            for pointIndex in 0..<48 {
                let unitY = 1 - (Float(pointIndex) + 0.5) / 48 * 2
                let radial = sqrt(max(0, 1 - unitY * unitY))
                let theta = Float(pointIndex) * 2.399_963 + guide.phase
                let point = ModelEntity(mesh: pointMesh, materials: [guide.material])
                point.name = "deep-nucleus-sparse-point-cloud-orientation-not-segmentation-\(guide.name)-\(pointIndex)"
                point.position = guide.center + [
                    cos(theta) * radial * guide.radii.x,
                    unitY * guide.radii.y,
                    sin(theta) * radial * guide.depth,
                ]
                point.scale = [
                    0.80 + Float(pointIndex % 5) * 0.07,
                    0.80 + Float((pointIndex + 2) % 5) * 0.06,
                    0.80 + Float((pointIndex + 4) % 5) * 0.05,
                ]
                nucleiRoot.addChild(point)
            }
        }

        // The caudate is represented as an open C-like orientation arc on each
        // side instead of a closed region boundary.
        for side: Float in [-1, 1] {
            let caudatePath = sampleCubicBezier(
                [side * 0.24, 1.92, -1.86],
                [side * 0.68, 2.13, -2.00],
                [side * 0.84, 1.72, -2.13],
                [side * 0.56, 1.34, -2.02],
                samples: 48
            )
            addContinuousTubePath(
                caudatePath,
                to: nucleiRoot,
                startRadius: 0.0050,
                endRadius: 0.0026,
                material: basalGangliaMaterial,
                name: "deep-nucleus-relational-contour-\(side < 0 ? "left" : "right")-caudate-open-arc",
                radialSegments: 9
            )
            for progress: Float in [0.08, 0.34, 0.62, 0.90] {
                let star = ModelEntity(
                    mesh: .generateSphere(radius: 0.008),
                    materials: [starMaterial]
                )
                star.name = "deep-nucleus-constellation-star-\(side < 0 ? "left" : "right")-caudate-\(Int(progress * 100))"
                star.position = interpolatedPoint(on: caudatePath, progress: progress)
                outlineRoot.addChild(star)
                deepStructuresGuideStars.append((star, progress * 7 + side))
            }
        }

        // Ten luminous fibers define a narrow capsule corridor with a superior
        // fan and inferior convergence. They are not individual tracts.
        for side: Float in [-1, 1] {
            for fiberIndex in 0..<5 {
                let offset = Float(fiberIndex - 2) * 0.035
                let capsulePath = sampleCubicBezier(
                    [side * (0.45 + offset * 1.8), 2.20, -2.14 + offset * 1.6],
                    [side * (0.64 + offset * 1.2), 1.88, -2.01 - offset * 0.9],
                    [side * (0.50 + offset * 0.3), 1.12, -1.75 + offset * 0.8],
                    [side * (0.32 + offset * 0.7), 0.66, -1.53 - offset * 0.5],
                    samples: 52
                )
                addContinuousTubePath(
                    capsulePath,
                    to: capsuleRoot,
                    startRadius: 0.0035 - Float(abs(fiberIndex - 2)) * 0.00035,
                    endRadius: 0.0017,
                    material: capsuleMaterial,
                    name: "internal-capsule-simplified-fiber-guide-\(side < 0 ? "left" : "right")-\(fiberIndex)",
                    radialSegments: 8
                )
            }
        }

        let vesselMaterial = tissueContextMaterial(
            color: UIColor(red: 0.48, green: 0.012, blue: 0.030, alpha: 0.68),
            emissive: UIColor(red: 0.68, green: 0.016, blue: 0.038, alpha: 1)
        )
        let flowCoreMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.24, blue: 0.15, alpha: 0.30),
            intensity: 1.2
        )
        let flowFrontMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.78, blue: 0.42, alpha: 0.98),
            intensity: 4.2
        )
        typealias DeepPathSpec = (
            name: String,
            points: [SIMD3<Float>],
            startRadius: Float,
            endRadius: Float,
            fronts: Int
        )
        var vesselSpecs: [DeepPathSpec] = []
        for side: Float in [-1, 1] {
            let sideName = side < 0 ? "left" : "right"
            let m1Path = sampleCubicBezier(
                [side * 0.16, 0.64, -1.49],
                [side * 0.52, 0.66, -1.51],
                [side * 1.04, 0.71, -1.56],
                [side * 1.54, 0.77, -1.63],
                samples: 56
            )
            vesselSpecs.append(("\(sideName)-m1-parent-approach", m1Path, 0.017, 0.012, 2))

            for branchIndex in 0..<6 {
                let branchProgress = 0.25 + Float(branchIndex) * 0.11
                let start = interpolatedPoint(on: m1Path, progress: branchProgress)
                let endX = side * (0.34 + Float(branchIndex) * 0.11)
                let endY = 1.24 + Float(branchIndex) * 0.105
                let endZ = -1.78 - sin(Float(branchIndex) * 0.72) * 0.14
                let perforatorPath = sampleCubicBezier(
                    start,
                    start + SIMD3<Float>(side * 0.15, 0.23, -0.15),
                    [endX - side * 0.18, endY - 0.24, endZ + 0.16],
                    [endX, endY, endZ],
                    samples: 44
                )
                vesselSpecs.append(("\(sideName)-m1-lenticulostriate-\(branchIndex)", perforatorPath, 0.0044, 0.0017, 1))
            }

            let anteriorChoroidal = sampleCubicBezier(
                [side * 0.22, 0.58, -1.48],
                [side * 0.34, 0.82, -1.60],
                [side * 0.51, 1.10, -1.82],
                [side * 0.55, 1.34, -1.98],
                samples: 48
            )
            vesselSpecs.append(("\(sideName)-anterior-choroidal-approach", anteriorChoroidal, 0.0070, 0.0027, 1))

            let posteriorPerforator = sampleCubicBezier(
                [side * 0.08, 0.70, -1.56],
                [side * 0.12, 0.94, -1.66],
                [side * 0.25, 1.25, -1.86],
                [side * 0.30, 1.51, -1.98],
                samples: 48
            )
            vesselSpecs.append(("\(sideName)-posterior-thalamic-perforator-approach", posteriorPerforator, 0.0065, 0.0025, 1))
        }

        let arrowHeadMesh = MeshResource.generateCone(height: 0.019, radius: 0.0058)
        let arrowTailMesh = MeshResource.generateCylinder(height: 0.027, radius: 0.0017)
        for (pathIndex, spec) in vesselSpecs.enumerated() {
            deepStructuresFlowPaths.append(spec.points)
            addContinuousTubePath(
                spec.points,
                to: vesselRoot,
                startRadius: spec.startRadius,
                endRadius: spec.endRadius,
                material: vesselMaterial,
                name: "deep-structure-\(spec.name)-continuous-wall",
                radialSegments: 14
            )
            addContinuousTubePath(
                spec.points,
                to: vesselRoot,
                startRadius: spec.startRadius * 0.30,
                endRadius: spec.endRadius * 0.32,
                material: flowCoreMaterial,
                name: "deep-structure-\(spec.name)-continuous-flow-core",
                radialSegments: 8
            )
            for frontIndex in 0..<spec.fronts {
                let arrow = Entity()
                arrow.name = "deep-perforator-tangent-flow-front-\(spec.name)-\(frontIndex)"
                let head = ModelEntity(mesh: arrowHeadMesh, materials: [flowFrontMaterial])
                head.name = "deep-perforator-flow-front-arrowhead"
                head.position.y = 0.021
                let tail = ModelEntity(mesh: arrowTailMesh, materials: [flowFrontMaterial])
                tail.name = "deep-perforator-flow-front-tail"
                tail.position.y = -0.021
                arrow.addChild(head)
                arrow.addChild(tail)
                vesselRoot.addChild(arrow)
                deepStructuresFlowArrows.append((
                    arrow,
                    pathIndex,
                    (Float(frontIndex) / Float(max(spec.fronts, 1)) + Float(pathIndex) * 0.097)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        let overviewTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "overview",
            position: [-1.12, 1.14, -1.50],
            collisionRadius: 0.20
        )
        regionGuideRoot.addChild(overviewTarget)
        deepStructuresDiscoveryTargets.append(overviewTarget)
        let activeTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "active",
            position: [-1.22, 1.29, -1.60],
            collisionRadius: 0.22
        )
        region.addChild(activeTarget)
        deepStructuresDiscoveryTargets.append(activeTarget)

        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
        print("RBC_DEEP_OBSERVATORY=READY nuclei_guides=6 nucleus_points=192 capsule_fibers=10 arterial_paths=18 moving_fronts=20 registered_reference=true")
    }

    /// A posterior cortical observatory inspired by a night-sky finder. The
    /// authored cortex is enlarged around the wearer as positional context;
    /// sparse constellation guides locate the occipital poles and calcarine
    /// banks. Native posterior-cerebral paths add legible direction without
    /// claiming segmentation, retinotopy, patient anatomy, or measured flow.
    private func buildOccipitalRegionInterior() {
        guard let cortexLayer else { return }
        let id = RBCBrainRegionDestination.occipitalLobe.id
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-occipital-visual-cortex-observatory"

        let authoredHero = cortexLayer.clone(recursive: true)
        authoredHero.name = "registered-cortex-expanded-around-wearer-occipital-context-not-segmentation"
        normalize(authoredHero, targetExtent: 5.35)
        authoredHero.position = [0, 1.10, -0.16]
        authoredHero.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        authoredHero.components.set(OpacityComponent(opacity: 0.10))
        region.addChild(authoredHero)
        occipitalAuthoredHero = authoredHero

        let outlineRoot = Entity()
        outlineRoot.name = "occipital-pole-constellation-outline-not-segmentation"
        region.addChild(outlineRoot)
        occipitalOutlineRoot = outlineRoot

        let calcarineRoot = Entity()
        calcarineRoot.name = "calcarine-upper-lower-bank-orientation-guide-not-retinotopy"
        region.addChild(calcarineRoot)
        occipitalCalcarineRoot = calcarineRoot

        let foldRoot = Entity()
        foldRoot.name = "occipital-surface-fold-fragments-orientation-not-histology"
        region.addChild(foldRoot)
        occipitalFoldRoot = foldRoot

        let vesselRoot = Entity()
        vesselRoot.name = "qualitative-pca-calcarine-parieto-occipital-lingual-routes-not-fixed-territories"
        region.addChild(vesselRoot)
        occipitalVesselRoot = vesselRoot

        let outlineMaterial = glowMaterial(
            color: UIColor(red: 0.46, green: 0.78, blue: 1.00, alpha: 0.18),
            intensity: 0.24
        )
        let starMaterial = glowMaterial(
            color: UIColor(red: 0.74, green: 0.92, blue: 1.00, alpha: 0.96),
            intensity: 2.75
        )
        let fieldPointMaterial = glowMaterial(
            color: UIColor(red: 0.49, green: 0.31, blue: 0.88, alpha: 0.58),
            intensity: 0.76
        )
        let calcarineMaterial = glowMaterial(
            color: UIColor(red: 0.93, green: 0.72, blue: 0.98, alpha: 0.74),
            intensity: 1.35
        )
        let calcarinePointMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.88, blue: 0.98, alpha: 0.96),
            intensity: 2.85
        )
        let foldMaterial = tissueContextMaterial(
            color: UIColor(red: 0.23, green: 0.08, blue: 0.29, alpha: 0.42),
            emissive: UIColor(red: 0.44, green: 0.16, blue: 0.54, alpha: 1)
        )

        let outlineStarMesh = MeshResource.generateSphere(radius: 0.010)
        let fieldPointMesh = MeshResource.generateSphere(radius: 0.0042)
        let calcarineStarMesh = MeshResource.generateSphere(radius: 0.0075)
        let goldenAngle: Float = 2.399_963

        // Open one selected medial occipital wall at exhibit scale. The
        // opposite hemisphere remains in the dim registered cortex; drawing
        // two equal outlines made the lesson read like an eye-mask icon.
        for sideIndex in 0..<1 {
            let side: Float = -1
            let sideName = "left"
            let lateralScale: Float = 1.0
            let verticalShift: Float = 0.0
            let depthShift: Float = 0.0
            let lateralOffset: Float = 0.72
            let place: (Float, Float, Float) -> SIMD3<Float> = { x, y, z in
                [lateralOffset + side * x * lateralScale, y + verticalShift, z + depthShift]
            }
            let boundaryControls: [[SIMD3<Float>]] = [
                [
                    place(0.16, 1.56, -1.70), place(0.32, 1.94, -1.90),
                    place(0.72, 2.33, -2.00), place(1.10, 2.22, -1.80),
                ],
                [
                    place(1.10, 2.22, -1.80), place(1.32, 1.94, -1.68),
                    place(1.32, 1.38, -1.70), place(1.08, 1.12, -1.82),
                ],
                [
                    place(1.08, 1.12, -1.82), place(0.82, 0.91, -1.98),
                    place(0.42, 0.99, -2.00), place(0.24, 1.20, -1.86),
                ],
            ]
            for (arcIndex, controls) in boundaryControls.enumerated() {
                let boundaryArc = sampleCubicBezier(
                    controls[0], controls[1], controls[2], controls[3], samples: 34
                )
                addTubePath(
                    boundaryArc,
                    to: outlineRoot,
                    radius: 0.0009,
                    material: outlineMaterial,
                    name: "\(sideName)-occipital-pole-broken-constellation-arc-\(arcIndex)"
                )
            }
            let poleGuidePoints = boundaryControls.flatMap { $0 }.enumerated().compactMap { index, point in
                (!index.isMultiple(of: 4) || index == 0) ? point : nil
            }
            for (index, point) in poleGuidePoints.enumerated() {
                let star = ModelEntity(mesh: outlineStarMesh, materials: [starMaterial])
                star.name = "\(sideName)-occipital-pole-guide-star-\(index)"
                star.position = point + SIMD3<Float>(0, 0, 0.010)
                outlineRoot.addChild(star)
                occipitalGuideStars.append((star, Float(sideIndex * poleGuidePoints.count + index) * 0.61))
            }

            // Sparse volume points make the region read as a place around the
            // wearer rather than a single drawn outline. Distribution is
            // deterministic and purely orienting—not functional parcellation.
            for index in 0..<168 {
                let fraction = (Float(index) + 0.5) / 168
                let angle = Float(index) * goldenAngle + Float(sideIndex) * 0.41
                let radial = sqrt(fraction)
                let point = SIMD3<Float>(
                    lateralOffset + side * (0.28 + radial * 0.82 * abs(cos(angle))) * lateralScale,
                    1.18 + verticalShift + radial * 0.94 * sin(angle) * 0.72 + fraction * 0.22,
                    -1.68 + depthShift - 0.30 * sin(angle * 1.73) - 0.18 * fraction
                )
                let mote = ModelEntity(mesh: fieldPointMesh, materials: [fieldPointMaterial])
                mote.name = "occipital-sparse-point-cloud-orientation-not-retinotopy-\(sideName)-\(index)"
                mote.position = point
                let scale = 0.64 + Float(index % 7) * 0.07
                mote.scale = [scale, scale, scale]
                outlineRoot.addChild(mote)
            }

            let upperBank = sampleCubicBezier(
                place(0.14, 1.66, -1.64),
                place(0.38, 1.86, -1.71),
                place(0.76, 1.94, -1.84),
                place(1.12, 1.81, -1.74),
                samples: 54
            )
            let lowerBank = sampleCubicBezier(
                place(0.14, 1.52, -1.66),
                place(0.37, 1.35, -1.75),
                place(0.77, 1.30, -1.87),
                place(1.11, 1.43, -1.76),
                samples: 54
            )
            for bankIndex in 0..<2 {
                let bank = bankIndex == 0 ? upperBank : lowerBank
                let bankName = bankIndex == 0 ? "upper-bank-cuneus" : "lower-bank-lingual"
                for layerIndex in 0..<3 {
                    let startProgress = 0.03 + Float(layerIndex) * 0.08
                    let endProgress = 0.97 - Float(layerIndex) * 0.08
                    let layerPath = (0..<42).map { sampleIndex in
                        let fraction = Float(sampleIndex) / 41
                        let progress = startProgress + (endProgress - startProgress) * fraction
                        let base = interpolatedPoint(on: bank, progress: progress)
                        let lift: Float = bankIndex == 0 ? 1 : -1
                        return base + SIMD3<Float>(
                            0,
                            lift * Float(layerIndex) * (0.026 + sin(fraction * .pi) * 0.018),
                            -Float(layerIndex) * 0.058
                        )
                    }
                    addContinuousTubePath(
                        layerPath,
                        to: calcarineRoot,
                        startRadius: layerIndex == 0 ? 0.0052 : 0.0022,
                        endRadius: layerIndex == 0 ? 0.0028 : 0.0013,
                        material: calcarineMaterial,
                        name: "\(sideName)-calcarine-\(bankName)-depth-layer-\(layerIndex)",
                        radialSegments: layerIndex == 0 ? 12 : 8
                    )
                }
                for starIndex in 0..<7 {
                    let progress = 0.08 + Float(starIndex) * 0.14
                    let point = interpolatedPoint(on: bank, progress: progress)
                    let star = ModelEntity(mesh: calcarineStarMesh, materials: [calcarinePointMaterial])
                    star.name = "calcarine-bank-guide-star-\(sideName)-\(bankIndex)-\(starIndex)"
                    star.position = point
                    calcarineRoot.addChild(star)
                    occipitalGuideStars.append((star, Float(sideIndex * 14 + bankIndex * 7 + starIndex) * 0.47 + 0.33))
                }
            }

            // Irregular short ridges suggest the folded posterior surface in
            // depth without drawing a fake sulcal atlas. They deliberately do
            // not connect into named boundaries or functional parcels.
            for foldIndex in 0..<28 {
                let fraction = (Float(foldIndex) + 0.5) / 28
                let angle = Float(foldIndex) * goldenAngle + 0.37
                let radial = sqrt(fraction)
                let center = SIMD3<Float>(
                    lateralOffset - 0.34 + cos(angle) * radial * 0.52,
                    1.58 + sin(angle) * radial * 0.64,
                    -1.87 - 0.18 * sin(angle * 1.43) - 0.10 * fraction
                )
                let tangent = simd_normalize(SIMD3<Float>(
                    cos(angle * 1.71),
                    sin(angle * 1.23) * 0.62,
                    sin(angle * 0.79) * 0.22
                ))
                let normal = simd_normalize(SIMD3<Float>(-tangent.y, tangent.x, 0.24))
                let halfLength = 0.11 + Float(foldIndex % 5) * 0.024
                let bend = (Float(foldIndex % 7) - 3) * 0.010
                let foldPath = sampleCubicBezier(
                    center - tangent * halfLength,
                    center - tangent * halfLength * 0.30 + normal * bend + SIMD3<Float>(0, 0, -0.035),
                    center + tangent * halfLength * 0.30 - normal * bend + SIMD3<Float>(0, 0, 0.035),
                    center + tangent * halfLength,
                    samples: 30
                )
                addContinuousTubePath(
                    foldPath,
                    to: foldRoot,
                    startRadius: 0.0064,
                    endRadius: 0.0038,
                    material: foldMaterial,
                    name: "occipital-fold-fragment-orientation-only-\(foldIndex)",
                    radialSegments: 10
                )
            }
        }

        let vesselMaterial = tissueContextMaterial(
            color: UIColor(red: 0.30, green: 0.012, blue: 0.034, alpha: 0.70),
            emissive: UIColor(red: 0.63, green: 0.025, blue: 0.065, alpha: 1)
        )
        let flowCoreMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.26, blue: 0.20, alpha: 0.16),
            intensity: 0.58
        )
        let flowFrontMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.84, blue: 0.48, alpha: 0.98),
            intensity: 3.65
        )
        var vesselSpecs: [(name: String, points: [SIMD3<Float>], startRadius: Float, endRadius: Float, fronts: Int)] = []

        for _ in 0..<1 {
            let side: Float = -1
            let sideName = "left"
            let lateralOffset: Float = 0.72
            let place: (Float, Float, Float) -> SIMD3<Float> = { x, y, z in
                [lateralOffset + side * x, y, z]
            }
            let pcaTrunk = sampleCubicBezier(
                place(0.08, 0.52, -1.46),
                place(0.18, 0.79, -1.58),
                place(0.37, 1.06, -1.88),
                place(0.54, 1.29, -2.02),
                samples: 54
            )
            vesselSpecs.append(("\(sideName)-posterior-cerebral-approach", pcaTrunk, 0.0140, 0.0080, 2))

            let calcarine = sampleCubicBezier(
                pcaTrunk.last ?? place(0.54, 1.29, -2.02),
                place(0.67, 1.45, -2.04),
                place(0.91, 1.61, -1.90),
                place(1.16, 1.63, -1.72),
                samples: 56
            )
            vesselSpecs.append(("\(sideName)-calcarine-approach", calcarine, 0.0080, 0.0032, 2))

            let parietoOccipital = sampleCubicBezier(
                interpolatedPoint(on: pcaTrunk, progress: 0.79),
                place(0.61, 1.50, -1.98),
                place(0.77, 1.91, -1.88),
                place(0.91, 2.24, -1.78),
                samples: 48
            )
            vesselSpecs.append(("\(sideName)-parieto-occipital-approach", parietoOccipital, 0.0067, 0.0024, 1))

            let lingual = sampleCubicBezier(
                interpolatedPoint(on: pcaTrunk, progress: 0.70),
                place(0.61, 1.18, -1.98),
                place(0.76, 1.00, -1.87),
                place(0.94, 0.93, -1.70),
                samples: 48
            )
            vesselSpecs.append(("\(sideName)-lingual-gyrus-approach", lingual, 0.0064, 0.0023, 1))

            let posteriorTemporal = sampleCubicBezier(
                interpolatedPoint(on: pcaTrunk, progress: 0.56),
                place(0.50, 1.10, -1.91),
                place(0.80, 1.06, -1.76),
                place(1.13, 1.13, -1.58),
                samples: 48
            )
            vesselSpecs.append(("\(sideName)-posterior-temporal-approach", posteriorTemporal, 0.0058, 0.0022, 1))

            for twigIndex in 0..<5 {
                let progress = 0.32 + Float(twigIndex) * 0.13
                let start = interpolatedPoint(on: calcarine, progress: progress)
                let upper = twigIndex.isMultiple(of: 2)
                let end = SIMD3<Float>(
                    lateralOffset + side * (0.70 + Float(twigIndex) * 0.105),
                    upper ? 1.80 + Float(twigIndex) * 0.045 : 1.36 - Float(twigIndex) * 0.018,
                    -1.69 - Float(twigIndex) * 0.035
                )
                let twig = sampleCubicBezier(
                    start,
                    start + SIMD3<Float>(side * 0.08, upper ? 0.12 : -0.10, 0.02),
                    end + SIMD3<Float>(-side * 0.08, upper ? -0.05 : 0.06, -0.03),
                    end,
                    samples: 38
                )
                vesselSpecs.append(("\(sideName)-calcarine-cortical-twig-\(twigIndex)", twig, 0.0037, 0.0014, 1))
            }
        }

        let arrowHeadMesh = MeshResource.generateCone(height: 0.020, radius: 0.0060)
        let arrowTailMesh = MeshResource.generateCylinder(height: 0.030, radius: 0.0018)
        for (pathIndex, spec) in vesselSpecs.enumerated() {
            occipitalFlowPaths.append(spec.points)
            addContinuousTubePath(
                spec.points,
                to: vesselRoot,
                startRadius: spec.startRadius,
                endRadius: spec.endRadius,
                material: vesselMaterial,
                name: "occipital-\(spec.name)-continuous-wall",
                radialSegments: 14
            )
            addContinuousTubePath(
                spec.points,
                to: vesselRoot,
                startRadius: spec.startRadius * 0.30,
                endRadius: spec.endRadius * 0.32,
                material: flowCoreMaterial,
                name: "occipital-\(spec.name)-continuous-flow-core",
                radialSegments: 8
            )
            for frontIndex in 0..<spec.fronts {
                let arrow = Entity()
                arrow.name = "occipital-posterior-route-tangent-flow-front-\(spec.name)-\(frontIndex)"
                let head = ModelEntity(mesh: arrowHeadMesh, materials: [flowFrontMaterial])
                head.name = "occipital-flow-front-arrowhead"
                head.position.y = 0.022
                let tail = ModelEntity(mesh: arrowTailMesh, materials: [flowFrontMaterial])
                tail.name = "occipital-flow-front-tail"
                tail.position.y = -0.022
                arrow.addChild(head)
                arrow.addChild(tail)
                vesselRoot.addChild(arrow)
                occipitalFlowArrows.append((
                    arrow,
                    pathIndex,
                    (Float(frontIndex) / Float(max(spec.fronts, 1)) + Float(pathIndex) * 0.083)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        let overviewTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "overview",
            position: [1.17, 1.12, -1.48],
            collisionRadius: 0.20
        )
        regionGuideRoot.addChild(overviewTarget)
        occipitalDiscoveryTargets.append(overviewTarget)
        let activeTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "active",
            position: [1.22, 1.30, -1.54],
            collisionRadius: 0.22
        )
        region.addChild(activeTarget)
        occipitalDiscoveryTargets.append(activeTarget)

        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
        print("RBC_OCCIPITAL_OBSERVATORY=READY selected_medial_wall=left broken_boundary_arcs=3 field_points=168 fold_fragments=28 calcarine_bank_layers=6 arterial_paths=10 moving_fronts=12 registered_reference=true")
    }

    /// A room-scale bridge lesson linking the posterior circulation destinations.
    /// The source deep-brain asset is a single combined mesh, so it remains dim
    /// context rather than being presented as segmented brainstem anatomy. The
    /// paired vertebral nodes are preserved as registered vascular references;
    /// all readable levels, pathway guides, and flow routes are native teaching
    /// geometry, not a patient scan, tractography, CFD, or fixed territory map.
    private func buildBrainstemRegionInterior() {
        let id = RBCBrainRegionDestination.brainstem.id
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-brainstem-posterior-circulation-bridge"

        let authoredContext = Entity()
        authoredContext.name = "registered-brainstem-relational-context-combined-source-not-segmentation"
        if let deepLayer {
            let deepReference = deepLayer.clone(recursive: true)
            deepReference.name = "registered-combined-deep-structures-context-behind-brainstem"
            normalize(deepReference, targetExtent: 2.82)
            deepReference.position += [0, 1.42, -2.34]
            authoredContext.addChild(deepReference)
        }
        if let cranialVascularLayer {
            let pairedVertebralReference = Entity()
            pairedVertebralReference.name = "registered-paired-vertebral-artery-reference-source-nodes"
            for sourceName in ["Assembly__Vertebral_artery_l", "Assembly__Vertebral_artery_r"] {
                if let source = cranialVascularLayer.findEntity(named: sourceName) {
                    pairedVertebralReference.addChild(source.clone(recursive: true))
                }
            }
            normalize(pairedVertebralReference, targetExtent: 2.14)
            pairedVertebralReference.position += [0, 1.28, -2.06]
            // The source nodes are preserved for registration provenance, but
            // their combined catalogue transform reads as two dark loops at
            // environmental scale. The native continuous routes below are the
            // visible lesson until a semantically segmented replacement exists.
            pairedVertebralReference.isEnabled = false
            authoredContext.addChild(pairedVertebralReference)
        }
        authoredContext.components.set(OpacityComponent(opacity: 0.11))
        region.addChild(authoredContext)
        brainstemAuthoredContext = authoredContext

        let outlineRoot = Entity()
        outlineRoot.name = "midbrain-pons-medulla-broken-contours-not-segmentation"
        region.addChild(outlineRoot)
        brainstemOutlineRoot = outlineRoot

        let pathwayRoot = Entity()
        pathwayRoot.name = "brainstem-longitudinal-and-transverse-pathway-guides-not-tractography"
        region.addChild(pathwayRoot)
        brainstemPathwayRoot = pathwayRoot

        let vesselRoot = Entity()
        vesselRoot.name = "qualitative-vertebral-basilar-pica-aica-sca-pca-and-pontine-routes-not-fixed-territories"
        region.addChild(vesselRoot)
        brainstemVesselRoot = vesselRoot
        brainstemConvergenceRouteRoot.name = "posterior-voyage-vertebral-to-basilar-convergence"
        brainstemCerebellarRouteRoot.name = "posterior-voyage-cerebellar-route-family"
        brainstemVisualRouteRoot.name = "posterior-voyage-posterior-cerebral-route-family"
        brainstemPontineRouteRoot.name = "posterior-voyage-small-pontine-approaches"
        for routeRoot in brainstemVoyageRouteRoots {
            vesselRoot.addChild(routeRoot)
        }

        let outlineMaterial = glowMaterial(
            color: UIColor(red: 0.44, green: 0.96, blue: 0.82, alpha: 0.82),
            intensity: 1.9
        )
        let starMaterial = glowMaterial(
            color: UIColor(red: 0.84, green: 1.0, blue: 0.94, alpha: 0.96),
            intensity: 3.0
        )
        let pathwayMaterial = glowMaterial(
            color: UIColor(red: 0.94, green: 0.79, blue: 0.56, alpha: 0.66),
            intensity: 1.15
        )
        let transverseMaterial = tissueContextMaterial(
            color: UIColor(red: 0.38, green: 0.22, blue: 0.48, alpha: 0.42),
            emissive: UIColor(red: 0.56, green: 0.34, blue: 0.72, alpha: 1)
        )
        let centralChannelMaterial = glowMaterial(
            color: UIColor(red: 0.34, green: 0.76, blue: 0.92, alpha: 0.72),
            intensity: 1.55
        )
        let corridorWallMaterials: [RealityKit.Material] = [
            tissueContextMaterial(
                color: UIColor(red: 0.22, green: 0.075, blue: 0.12, alpha: 0.50),
                emissive: UIColor(red: 0.62, green: 0.12, blue: 0.20, alpha: 1)
            ),
            tissueContextMaterial(
                color: UIColor(red: 0.070, green: 0.090, blue: 0.25, alpha: 0.42),
                emissive: UIColor(red: 0.15, green: 0.25, blue: 0.68, alpha: 1)
            ),
        ]

        // Four low-density folded sheets turn the front-facing guide into a
        // corridor with side and rear depth. They are an atmospheric boundary,
        // not brainstem surface reconstruction or segmented anatomy.
        for side: Float in [-1, 1] {
            for layerIndex in 0..<2 {
                if let mesh = try? makeBrainstemCorridorWallMesh(
                    side: side,
                    layer: layerIndex,
                    phase: (side < 0 ? 0.35 : 1.10) + Float(layerIndex) * 0.77
                ) {
                    let wall = ModelEntity(
                        mesh: mesh,
                        materials: [corridorWallMaterials[layerIndex]]
                    )
                    wall.name = "brainstem-folded-environment-wall-not-surface-segmentation-\(side < 0 ? "left" : "right")-\(layerIndex)"
                    outlineRoot.addChild(wall)
                }
            }
        }

        typealias BrainstemLevel = (
            name: String,
            center: SIMD3<Float>,
            radii: SIMD2<Float>,
            phase: Float,
            depth: Float
        )
        let levels: [BrainstemLevel] = [
            ("midbrain", [-0.09, 2.08, -1.91], [0.57, 0.35], 0.30, 0.24),
            ("pons", [0.08, 1.43, -1.80], [0.82, 0.48], 1.10, 0.31),
            ("medulla", [-0.055, 0.70, -1.88], [0.46, 0.57], 2.00, 0.26),
        ]
        let outlineStarMesh = MeshResource.generateSphere(radius: 0.008)
        for (levelIndex, level) in levels.enumerated() {
            let controls = (0..<16).map { index -> SIMD3<Float> in
                let angle = Float(index) / 16 * .pi * 2
                let irregularity = 1
                    + sin(angle * 3 + level.phase) * 0.10
                    + cos(angle * 5 - level.phase) * 0.035
                return [
                    level.center.x + cos(angle) * level.radii.x * irregularity,
                    level.center.y + sin(angle) * level.radii.y * (1 + cos(angle * 2 + level.phase) * 0.075),
                    level.center.z
                        + sin(angle + level.phase) * level.depth
                        + cos(angle * 2.4 - level.phase) * 0.055,
                ]
            }
            let contour = sampleClosedCatmullRom(controls, samplesPerSegment: 5)
            let arcRanges = [2..<18, 31..<45, 58..<73]
            for (arcIndex, range) in arcRanges.enumerated() {
                addContinuousTubePath(
                    Array(contour[range]),
                    to: outlineRoot,
                    startRadius: levelIndex == 1 ? 0.0046 : 0.0038,
                    endRadius: 0.0022,
                    material: outlineMaterial,
                    name: "brainstem-\(level.name)-broken-constellation-arc-\(arcIndex)",
                    radialSegments: 8
                )
            }
            for (index, point) in controls.enumerated() where !index.isMultiple(of: 3) {
                let star = ModelEntity(mesh: outlineStarMesh, materials: [starMaterial])
                star.name = "brainstem-\(level.name)-guide-star-\(index)"
                star.position = point + SIMD3<Float>(0, 0, 0.010)
                outlineRoot.addChild(star)
                brainstemGuideStars.append((star, Float(levelIndex * 16 + index) * 0.43))
            }
        }

        // Peripheral ribs make the vertical lesson inhabit a room rather than
        // collapse into a front-facing diagram.
        for ribIndex in 0..<8 {
            let progress = Float(ribIndex) / 7
            let y = 0.46 + progress * 1.86
            let width = 0.58 + sin(progress * .pi) * 0.46
            for side: Float in [-1, 1] {
                let rib = sampleCubicBezier(
                    [side * width, y, -1.86],
                    [side * (width + 0.34), y + 0.04, -1.72],
                    [side * (1.30 + progress * 0.15), y + 0.08, -1.12],
                    [side * (1.62 + sin(progress * .pi) * 0.16), y + 0.13, -0.62],
                    samples: 34
                )
                addContinuousTubePath(
                    rib,
                    to: outlineRoot,
                    startRadius: 0.0028,
                    endRadius: 0.0012,
                    material: outlineMaterial,
                    name: "brainstem-peripheral-depth-rib-\(ribIndex)-\(side < 0 ? "left" : "right")",
                    radialSegments: 7
                )
            }
        }

        // Three vertical laminae are separated for spatial reading; their
        // placement is illustrative and must not be read as a tract atlas.
        let laminaOffsets: [(name: String, x: Float, z: Float)] = [
            ("left", -0.31, -1.80),
            ("central", 0.0, -1.92),
            ("right", 0.31, -1.80),
        ]
        for (laneIndex, lane) in laminaOffsets.enumerated() {
            for depthIndex in 0..<3 {
                let depthOffset = Float(depthIndex - 1) * 0.095
                let xDrift = Float(depthIndex - 1) * 0.12
                let path = sampleCubicBezier(
                    [lane.x - xDrift * 1.7, 0.22, lane.z + depthOffset + 0.12],
                    [lane.x + 0.14 * sin(Float(laneIndex) + 0.4), 0.86, lane.z + depthOffset - 0.18],
                    [lane.x - 0.12 * cos(Float(depthIndex) + 0.3), 1.70, lane.z + depthOffset + 0.15],
                    [lane.x + xDrift * 1.5, 2.46, lane.z + depthOffset - 0.11],
                    samples: 58
                )
                addContinuousTubePath(
                    path,
                    to: pathwayRoot,
                    startRadius: depthIndex == 1 ? 0.0070 : 0.0032,
                    endRadius: depthIndex == 1 ? 0.0054 : 0.0020,
                    material: pathwayMaterial,
                    name: "brainstem-\(lane.name)-longitudinal-pathway-guide-\(depthIndex)",
                    radialSegments: depthIndex == 1 ? 10 : 7
                )
            }
        }
        for fiberIndex in 0..<9 {
            let fraction = Float(fiberIndex) / 8
            let y = 1.08 + fraction * 0.68
            let bow = 0.13 + sin(fraction * .pi) * 0.10
            let transversePath = sampleCubicBezier(
                [-0.76, y - 0.035, -1.73 - fraction * 0.14],
                [-0.34, y + bow, -1.55 - sin(fraction * .pi) * 0.18],
                [0.29, y - bow * 0.46, -1.91 + cos(fraction * .pi) * 0.12],
                [0.74, y + sin(Float(fiberIndex) * 0.82) * 0.065, -1.69 - (1 - fraction) * 0.17],
                samples: 44
            )
            addContinuousTubePath(
                transversePath,
                to: pathwayRoot,
                startRadius: 0.0044,
                endRadius: 0.0030,
                material: transverseMaterial,
                name: "brainstem-transverse-pontine-fiber-guide-\(fiberIndex)",
                radialSegments: 8
            )
        }
        let centralChannel = sampleCubicBezier(
            [0, 1.26, -2.00], [0.01, 1.52, -2.03],
            [-0.01, 1.89, -2.02], [0, 2.26, -1.98],
            samples: 48
        )
        addContinuousTubePath(
            centralChannel,
            to: pathwayRoot,
            startRadius: 0.012,
            endRadius: 0.008,
            material: centralChannelMaterial,
            name: "central-aqueduct-to-fourth-ventricle-orientation-guide-not-segmentation",
            radialSegments: 12
        )

        let fieldPointMesh = MeshResource.generateSphere(radius: 0.0062)
        let fieldPointMaterial = glowMaterial(
            color: UIColor(red: 0.72, green: 0.60, blue: 0.94, alpha: 0.58),
            intensity: 1.15
        )
        let goldenAngle: Float = 2.3999632
        for index in 0..<72 {
            let fraction = (Float(index) + 0.5) / 72
            let angle = Float(index) * goldenAngle
            let point = SIMD3<Float>(
                cos(angle) * (0.12 + sqrt(fraction) * 0.46),
                0.50 + fraction * 1.68 + sin(angle * 1.7) * 0.075,
                -1.92 + sin(angle) * (0.08 + fraction * 0.15)
            )
            let mote = ModelEntity(mesh: fieldPointMesh, materials: [fieldPointMaterial])
            mote.name = "brainstem-sparse-tegmental-point-field-not-nuclei-map-\(index)"
            mote.position = point
            let scale = 0.66 + Float(index % 6) * 0.075
            mote.scale = [scale, scale, scale]
            pathwayRoot.addChild(mote)
        }

        let vesselMaterial = tissueContextMaterial(
            color: UIColor(red: 0.46, green: 0.010, blue: 0.026, alpha: 0.86),
            emissive: UIColor(red: 0.74, green: 0.018, blue: 0.040, alpha: 1)
        )
        let flowCoreMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.21, blue: 0.13, alpha: 0.32),
            intensity: 1.25
        )
        let cerebellarFlowCoreMaterial = glowMaterial(
            color: UIColor(red: 0.22, green: 0.88, blue: 0.73, alpha: 0.38),
            intensity: 1.65
        )
        let visualFlowCoreMaterial = glowMaterial(
            color: UIColor(red: 0.56, green: 0.45, blue: 1.0, alpha: 0.40),
            intensity: 1.75
        )
        let cerebellarRouteHaloMaterial = glowMaterial(
            color: UIColor(red: 0.20, green: 0.88, blue: 0.72, alpha: 0.15),
            intensity: 1.55
        )
        let visualRouteHaloMaterial = glowMaterial(
            color: UIColor(red: 0.55, green: 0.42, blue: 1.0, alpha: 0.16),
            intensity: 1.65
        )
        let flowFrontMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.80, blue: 0.44, alpha: 0.98),
            intensity: 4.4
        )
        let flowWakeMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.38, blue: 0.17, alpha: 0.64),
            intensity: 2.0
        )
        let cerebellarFrontMaterial = glowMaterial(
            color: UIColor(red: 0.56, green: 1.0, blue: 0.84, alpha: 0.98),
            intensity: 4.5
        )
        let visualFrontMaterial = glowMaterial(
            color: UIColor(red: 0.78, green: 0.70, blue: 1.0, alpha: 0.98),
            intensity: 4.7
        )
        let cerebellarWakeMaterial = glowMaterial(
            color: UIColor(red: 0.16, green: 0.70, blue: 0.62, alpha: 0.70),
            intensity: 2.2
        )
        let visualWakeMaterial = glowMaterial(
            color: UIColor(red: 0.42, green: 0.30, blue: 0.90, alpha: 0.72),
            intensity: 2.3
        )
        typealias BrainstemPathSpec = (
            name: String,
            points: [SIMD3<Float>],
            startRadius: Float,
            endRadius: Float,
            fronts: Int
        )
        let leftVertebral = sampleCubicBezier(
            [-0.30, 0.12, -1.43], [-0.27, 0.34, -1.45],
            [-0.17, 0.58, -1.47], [0, 0.74, -1.50], samples: 56
        )
        let rightVertebral = sampleCubicBezier(
            [0.30, 0.12, -1.43], [0.27, 0.34, -1.45],
            [0.17, 0.58, -1.47], [0, 0.74, -1.50], samples: 56
        )
        let basilar = sampleCubicBezier(
            [0, 0.74, -1.50], [-0.070, 1.08, -1.43],
            [0.085, 1.68, -1.54], [-0.030, 2.08, -1.48], samples: 76
        )
        var vesselSpecs: [BrainstemPathSpec] = [
            ("left-vertebral-approach", leftVertebral, 0.022, 0.018, 2),
            ("right-vertebral-approach", rightVertebral, 0.022, 0.018, 2),
            ("basilar-trunk", basilar, 0.024, 0.017, 3),
        ]
        for side: Float in [-1, 1] {
            let sideName = side < 0 ? "left" : "right"
            let vertebralPath = side < 0 ? leftVertebral : rightVertebral
            let picaStart = interpolatedPoint(on: vertebralPath, progress: 0.58)
            let pica = sampleCubicBezier(
                picaStart,
                picaStart + SIMD3<Float>(side * 0.18, 0.08, -0.08),
                [side * 0.72, 0.61, -1.70],
                [side * 1.15, 0.78, -1.88],
                samples: 50
            )
            vesselSpecs.append(("\(sideName)-pica-approach", pica, 0.010, 0.0038, 1))

            let aicaStart = interpolatedPoint(on: basilar, progress: 0.34)
            let aica = sampleCubicBezier(
                aicaStart,
                aicaStart + SIMD3<Float>(side * 0.24, 0.04, -0.04),
                [side * 0.76, 1.21, -1.66],
                [side * 1.20, 1.30, -1.82],
                samples: 50
            )
            vesselSpecs.append(("\(sideName)-aica-approach", aica, 0.011, 0.0040, 1))

            let scaStart = interpolatedPoint(on: basilar, progress: 0.78)
            let sca = sampleCubicBezier(
                scaStart,
                scaStart + SIMD3<Float>(side * 0.26, 0.06, -0.04),
                [side * 0.72, 1.84, -1.66],
                [side * 1.13, 1.96, -1.84],
                samples: 50
            )
            vesselSpecs.append(("\(sideName)-sca-approach", sca, 0.0105, 0.0038, 1))

            let pca = sampleCubicBezier(
                basilar.last ?? [0, 2.08, -1.48],
                [side * 0.24, 2.17, -1.42],
                [side * 0.70, 2.31, -1.62],
                [side * 1.20, 2.25 + side * 0.045, -1.82],
                samples: 56
            )
            vesselSpecs.append(("\(sideName)-posterior-cerebral-continuation", pca, 0.015, 0.0070, 2))

            for perforatorIndex in 0..<3 {
                let progress = 0.27 + Float(perforatorIndex) * 0.20
                let start = interpolatedPoint(on: basilar, progress: progress)
                let end = SIMD3<Float>(
                    side * (0.34 + Float(perforatorIndex) * 0.08),
                    start.y + 0.08 + Float(perforatorIndex) * 0.03,
                    -1.96 - Float(perforatorIndex) * 0.035
                )
                let perforator = sampleCubicBezier(
                    start,
                    start + SIMD3<Float>(side * 0.11, 0.01, -0.10),
                    end + SIMD3<Float>(-side * 0.08, -0.02, 0.08),
                    end,
                    samples: 38
                )
                vesselSpecs.append(("\(sideName)-paramedian-pontine-approach-\(perforatorIndex)", perforator, 0.0046, 0.0017, 1))
            }
        }

        let arrowHeadMesh = MeshResource.generateCone(height: 0.020, radius: 0.0058)
        let arrowTailMesh = MeshResource.generateCylinder(height: 0.030, radius: 0.0018)
        let arrowWakeMesh = MeshResource.generateCylinder(height: 0.046, radius: 0.00115)
        for (pathIndex, spec) in vesselSpecs.enumerated() {
            brainstemFlowPaths.append(spec.points)
            let routeParent: Entity = if spec.name.contains("pica")
                || spec.name.contains("aica")
                || spec.name.contains("sca") {
                brainstemCerebellarRouteRoot
            } else if spec.name.contains("posterior-cerebral") {
                brainstemVisualRouteRoot
            } else if spec.name.contains("pontine") {
                brainstemPontineRouteRoot
            } else {
                brainstemConvergenceRouteRoot
            }
            let routeCoreMaterial: RealityKit.Material = if routeParent === brainstemCerebellarRouteRoot {
                cerebellarFlowCoreMaterial
            } else if routeParent === brainstemVisualRouteRoot {
                visualFlowCoreMaterial
            } else {
                flowCoreMaterial
            }
            let routeFrontMaterial: RealityKit.Material = if routeParent === brainstemCerebellarRouteRoot {
                cerebellarFrontMaterial
            } else if routeParent === brainstemVisualRouteRoot {
                visualFrontMaterial
            } else {
                flowFrontMaterial
            }
            let routeWakeMaterial: RealityKit.Material = if routeParent === brainstemCerebellarRouteRoot {
                cerebellarWakeMaterial
            } else if routeParent === brainstemVisualRouteRoot {
                visualWakeMaterial
            } else {
                flowWakeMaterial
            }
            let routeHaloMaterial: RealityKit.Material? = if routeParent === brainstemCerebellarRouteRoot {
                cerebellarRouteHaloMaterial
            } else if routeParent === brainstemVisualRouteRoot {
                visualRouteHaloMaterial
            } else {
                nil
            }
            if let routeHaloMaterial {
                addContinuousTubePath(
                    spec.points,
                    to: routeParent,
                    startRadius: spec.startRadius * 1.26,
                    endRadius: spec.endRadius * 1.30,
                    material: routeHaloMaterial,
                    name: "brainstem-\(spec.name)-destination-teaching-halo-not-vessel-color",
                    radialSegments: 12
                )
            }
            addContinuousTubePath(
                spec.points,
                to: routeParent,
                startRadius: spec.startRadius,
                endRadius: spec.endRadius,
                material: vesselMaterial,
                name: "brainstem-\(spec.name)-continuous-wall",
                radialSegments: spec.startRadius > 0.016 ? 16 : 12
            )
            addContinuousTubePath(
                spec.points,
                to: routeParent,
                startRadius: spec.startRadius * 0.30,
                endRadius: spec.endRadius * 0.32,
                material: routeCoreMaterial,
                name: "brainstem-\(spec.name)-continuous-flow-core",
                radialSegments: 8
            )
            for frontIndex in 0..<spec.fronts {
                let front = Entity()
                front.name = "brainstem-posterior-circulation-tangent-flow-front-\(spec.name)-\(frontIndex)"
                let head = ModelEntity(mesh: arrowHeadMesh, materials: [routeFrontMaterial])
                head.name = "brainstem-flow-front-arrowhead"
                head.position.y = 0.025
                let tail = ModelEntity(mesh: arrowTailMesh, materials: [routeFrontMaterial])
                tail.name = "brainstem-flow-front-tail"
                tail.position.y = -0.016
                let wake = ModelEntity(mesh: arrowWakeMesh, materials: [routeWakeMaterial])
                wake.name = "brainstem-flow-front-afterglow"
                wake.position.y = -0.052
                front.addChild(head)
                front.addChild(tail)
                front.addChild(wake)
                routeParent.addChild(front)
                brainstemFlowFronts.append((
                    front,
                    pathIndex,
                    (Float(frontIndex) / Float(max(spec.fronts, 1)) + Float(pathIndex) * 0.089)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        let overviewTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "overview",
            position: [-1.05, 0.96, -1.45],
            collisionRadius: 0.20
        )
        regionGuideRoot.addChild(overviewTarget)
        brainstemDiscoveryTargets.append(overviewTarget)
        let activeTarget = makeRegionDiscoveryTarget(
            id: id,
            variant: "active",
            position: [-1.18, 1.26, -1.52],
            collisionRadius: 0.22
        )
        region.addChild(activeTarget)
        brainstemDiscoveryTargets.append(activeTarget)

        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
        print("RBC_BRAINSTEM_OBSERVATORY=READY levels=3 broken_outline_arcs=9 environmental_wall_sheets=4 peripheral_ribs=16 longitudinal_guides=9 transverse_pons_guides=9 tegmental_points=72 arterial_paths=17 moving_fronts=23 voyage_route_groups=4 destination_route_halos=8 registered_deep_context=true registered_vertebral_nodes=2")
    }

    private func makeBrainstemCorridorWallMesh(
        side: Float,
        layer: Int,
        phase: Float
    ) throws -> MeshResource {
        let columns = 13
        let rows = 35
        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var textureCoordinates: [SIMD2<Float>] = []
        var indices: [UInt32] = []
        positions.reserveCapacity(columns * rows)
        normals.reserveCapacity(columns * rows)
        textureCoordinates.reserveCapacity(columns * rows)
        indices.reserveCapacity((columns - 1) * (rows - 1) * 6)

        let layerOffset = Float(layer) * 0.12
        for row in 0..<rows {
            let v = Float(row) / Float(rows - 1)
            let y = 0.12 + v * 2.50
            for column in 0..<columns {
                let u = Float(column) / Float(columns - 1)
                let envelope = sin(v * .pi)
                let foldedX = 0.50 + u * 1.10
                    + sin(v * .pi * 3.2 + phase) * 0.12
                    + cos((u + v) * .pi * 4.4 + phase) * 0.045
                let foldedZ = -0.82 - u * 1.52 - layerOffset
                    + sin(v * .pi * 4.1 - phase) * 0.095
                    + cos(u * .pi * 2.2 + v * .pi * 1.6) * 0.055
                positions.append([
                    side * (foldedX + envelope * 0.13),
                    y + sin(u * .pi * 2.0 + phase) * 0.035,
                    foldedZ,
                ])
                normals.append(simd_normalize(SIMD3<Float>(-side * 0.82, 0.08, 0.56)))
                textureCoordinates.append([u, v])
            }
        }
        for row in 0..<(rows - 1) {
            for column in 0..<(columns - 1) {
                let a = UInt32(row * columns + column)
                let b = UInt32(row * columns + column + 1)
                let c = UInt32((row + 1) * columns + column)
                let d = UInt32((row + 1) * columns + column + 1)
                indices.append(contentsOf: [a, c, b, b, c, d])
            }
        }
        var descriptor = MeshDescriptor(name: "brainstem-folded-environment-wall")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        descriptor.primitives = .triangles(indices)
        return try MeshResource.generate(from: [descriptor])
    }

    /// A room-scale teaching map of the arterial crossroads. The authored
    /// asset remains as dim anatomical context; these continuous native paths
    /// provide readable direction and a user-controlled anterior/posterior
    /// emphasis. Connecting paths intentionally carry no arrowheads because
    /// this generic lesson must not imply a universal collateral-flow pattern.
    private func buildWillisNetworkInterior() {
        let id = RBCBrainRegionDestination.circleOfWillis.id
        guard let region = regionInteriors[id] else { return }

        willisNetworkRoot.addChild(willisAnteriorRouteRoot)
        willisNetworkRoot.addChild(willisPosteriorRouteRoot)
        willisNetworkRoot.addChild(willisConnectorRoot)
        willisAnteriorRouteRoot.addChild(willisCarotidPassageRoot)
        willisAnteriorRouteRoot.addChild(willisCrossroadsPassageRoot)
        willisAnteriorRouteRoot.addChild(willisMiddleCerebralPassageRoot)
        willisAnteriorRouteRoot.addChild(willisAnteriorCerebralContextRoot)
        willisMiddleCerebralPassageRoot.addChild(willisSelectedMCAPassageRoot)
        willisMiddleCerebralPassageRoot.addChild(willisContralateralMCAContextRoot)
        willisSelectedMCAPassageRoot.addChild(willisAnteriorGatewayRoot)
        region.addChild(willisNetworkRoot)
        // The imported Circle hero is useful as portal provenance but, at room
        // scale, its dark tubes and orange cuffs compete with this directional
        // lesson. Keep only the registered arterial-tree context here.
        willisAuthoredHero?.isEnabled = false

        let arterialWallMaterial = tissueContextMaterial(
            color: UIColor(red: 0.46, green: 0.012, blue: 0.026, alpha: 0.84),
            emissive: UIColor(red: 0.76, green: 0.018, blue: 0.034, alpha: 1)
        )
        let flowCoreMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.25, blue: 0.16, alpha: 0.34),
            intensity: 1.25
        )
        let connectorMaterial = tissueContextMaterial(
            color: UIColor(red: 0.42, green: 0.17, blue: 0.12, alpha: 0.52),
            emissive: UIColor(red: 0.72, green: 0.34, blue: 0.20, alpha: 1)
        )
        let flowFrontMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.76, blue: 0.42, alpha: 0.98),
            intensity: 4.0
        )
        let middleCerebralPassageHaloMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.24, blue: 0.34, alpha: 0.12),
            intensity: 1.15
        )
        let anteriorGatewayMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.66, blue: 0.30, alpha: 0.86),
            intensity: 3.4
        )

        typealias PathSpec = (
            name: String,
            family: WillisPathFamily,
            controls: (SIMD3<Float>, SIMD3<Float>, SIMD3<Float>, SIMD3<Float>),
            startRadius: Float,
            endRadius: Float,
            fronts: Int
        )
        let specs: [PathSpec] = [
            (
                "left-internal-carotid-approach", .anterior,
                ([-0.66, 0.42, -1.04], [-0.70, 0.76, -1.16], [-0.54, 1.10, -1.30], [-0.43, 1.30, -1.39]),
                0.021, 0.016, 2
            ),
            (
                "right-internal-carotid-approach", .anterior,
                ([0.66, 0.42, -1.04], [0.70, 0.76, -1.16], [0.54, 1.10, -1.30], [0.43, 1.30, -1.39]),
                0.021, 0.016, 2
            ),
            (
                "basilar-approach", .posterior,
                ([0, 0.38, -2.10], [0.02, 0.70, -2.02], [-0.02, 0.96, -1.86], [0, 1.16, -1.74]),
                0.022, 0.016, 2
            ),
            (
                "left-posterior-cerebral-outflow", .posterior,
                ([0, 1.16, -1.74], [-0.22, 1.22, -1.86], [-0.64, 1.30, -2.02], [-1.12, 1.38, -2.10]),
                0.015, 0.009, 1
            ),
            (
                "right-posterior-cerebral-outflow", .posterior,
                ([0, 1.16, -1.74], [0.22, 1.22, -1.86], [0.64, 1.30, -2.02], [1.12, 1.38, -2.10]),
                0.015, 0.009, 1
            ),
            (
                "left-posterior-communicating-connection", .connector,
                ([-0.48, 1.27, -1.96], [-0.52, 1.24, -1.78], [-0.49, 1.27, -1.54], [-0.43, 1.30, -1.39]),
                0.009, 0.008, 0
            ),
            (
                "right-posterior-communicating-connection", .connector,
                ([0.48, 1.27, -1.96], [0.52, 1.24, -1.78], [0.49, 1.27, -1.54], [0.43, 1.30, -1.39]),
                0.009, 0.008, 0
            ),
            (
                "left-anterior-cerebral-a1", .anterior,
                ([-0.43, 1.30, -1.39], [-0.34, 1.37, -1.42], [-0.22, 1.45, -1.44], [-0.09, 1.50, -1.44]),
                0.013, 0.009, 1
            ),
            (
                "right-anterior-cerebral-a1", .anterior,
                ([0.43, 1.30, -1.39], [0.34, 1.37, -1.42], [0.22, 1.45, -1.44], [0.09, 1.50, -1.44]),
                0.013, 0.009, 1
            ),
            (
                "anterior-communicating-connection", .connector,
                ([-0.09, 1.50, -1.44], [-0.03, 1.53, -1.45], [0.03, 1.53, -1.45], [0.09, 1.50, -1.44]),
                0.007, 0.007, 0
            ),
            (
                "left-anterior-cerebral-continuation", .anterior,
                ([-0.09, 1.50, -1.44], [-0.13, 1.68, -1.47], [-0.24, 1.90, -1.45], [-0.36, 2.12, -1.39]),
                0.009, 0.004, 1
            ),
            (
                "right-anterior-cerebral-continuation", .anterior,
                ([0.09, 1.50, -1.44], [0.13, 1.68, -1.47], [0.24, 1.90, -1.45], [0.36, 2.12, -1.39]),
                0.009, 0.004, 1
            ),
            (
                "left-middle-cerebral-outflow", .anterior,
                ([-0.43, 1.30, -1.39], [-0.63, 1.40, -1.29], [-0.90, 1.53, -1.16], [-1.30, 1.70, -1.02]),
                0.014, 0.006, 2
            ),
            (
                "right-middle-cerebral-outflow", .anterior,
                ([0.43, 1.30, -1.39], [0.63, 1.40, -1.29], [0.90, 1.53, -1.16], [1.30, 1.70, -1.02]),
                0.014, 0.006, 2
            ),
            (
                "left-middle-cerebral-superior-branch", .anterior,
                ([-1.30, 1.70, -1.02], [-1.38, 1.80, -1.06], [-1.50, 1.90, -1.14], [-1.64, 2.00, -1.22]),
                0.006, 0.0025, 0
            ),
            (
                "left-middle-cerebral-inferior-branch", .anterior,
                ([-1.30, 1.70, -1.02], [-1.39, 1.63, -0.98], [-1.49, 1.52, -0.93], [-1.58, 1.42, -0.90]),
                0.006, 0.0025, 0
            ),
            (
                "right-middle-cerebral-superior-branch", .anterior,
                ([1.30, 1.70, -1.02], [1.38, 1.80, -1.06], [1.50, 1.90, -1.14], [1.64, 2.00, -1.22]),
                0.006, 0.0025, 0
            ),
            (
                "right-middle-cerebral-inferior-branch", .anterior,
                ([1.30, 1.70, -1.02], [1.39, 1.63, -0.98], [1.49, 1.52, -0.93], [1.58, 1.42, -0.90]),
                0.006, 0.0025, 0
            ),
            (
                "left-anterior-cerebral-medial-branch", .anterior,
                ([-0.36, 2.12, -1.39], [-0.39, 2.24, -1.43], [-0.47, 2.34, -1.50], [-0.56, 2.42, -1.57]),
                0.004, 0.0018, 0
            ),
            (
                "right-anterior-cerebral-medial-branch", .anterior,
                ([0.36, 2.12, -1.39], [0.39, 2.24, -1.43], [0.47, 2.34, -1.50], [0.56, 2.42, -1.57]),
                0.004, 0.0018, 0
            ),
            (
                "left-anterior-cerebral-forward-branch", .anterior,
                ([-0.36, 2.12, -1.39], [-0.33, 2.26, -1.33], [-0.28, 2.38, -1.25], [-0.22, 2.48, -1.18]),
                0.004, 0.0018, 0
            ),
            (
                "right-anterior-cerebral-forward-branch", .anterior,
                ([0.36, 2.12, -1.39], [0.33, 2.26, -1.33], [0.28, 2.38, -1.25], [0.22, 2.48, -1.18]),
                0.004, 0.0018, 0
            ),
            (
                "left-posterior-cerebral-lateral-branch", .posterior,
                ([-1.12, 1.38, -2.10], [-1.24, 1.44, -2.16], [-1.38, 1.53, -2.22], [-1.54, 1.62, -2.28]),
                0.006, 0.0025, 0
            ),
            (
                "right-posterior-cerebral-lateral-branch", .posterior,
                ([1.12, 1.38, -2.10], [1.24, 1.44, -2.16], [1.38, 1.53, -2.22], [1.54, 1.62, -2.28]),
                0.006, 0.0025, 0
            ),
            (
                "left-posterior-cerebral-inferior-branch", .posterior,
                ([-1.12, 1.38, -2.10], [-1.20, 1.29, -2.18], [-1.28, 1.19, -2.25], [-1.36, 1.10, -2.31]),
                0.006, 0.0025, 0
            ),
            (
                "right-posterior-cerebral-inferior-branch", .posterior,
                ([1.12, 1.38, -2.10], [1.20, 1.29, -2.18], [1.28, 1.19, -2.25], [1.36, 1.10, -2.31]),
                0.006, 0.0025, 0
            ),
        ]

        let arrowHeadMesh = MeshResource.generateCone(height: 0.026, radius: 0.0085)
        let arrowTailMesh = MeshResource.generateCylinder(height: 0.038, radius: 0.0023)
        for (pathIndex, spec) in specs.enumerated() {
            let path = sampleCubicBezier(
                spec.controls.0,
                spec.controls.1,
                spec.controls.2,
                spec.controls.3,
                samples: 54
            )
            let anteriorSegment: WillisAnteriorSegment? = if spec.family != .anterior {
                nil
            } else if spec.name.contains("internal-carotid") {
                .carotid
            } else if spec.name.contains("middle-cerebral") {
                .middleCerebral
            } else if spec.name.contains("anterior-cerebral-a1") {
                .crossroads
            } else {
                .anteriorCerebralContext
            }
            let isSelectedAnteriorExemplar = spec.name.contains("right-middle-cerebral")
            willisFlowPaths.append(WillisPathRecord(
                points: path,
                family: spec.family,
                anteriorSegment: anteriorSegment,
                isSelectedAnteriorExemplar: isSelectedAnteriorExemplar
            ))
            let parent: Entity = switch spec.family {
            case .anterior:
                switch anteriorSegment {
                case .carotid: willisCarotidPassageRoot
                case .crossroads: willisCrossroadsPassageRoot
                case .middleCerebral:
                    isSelectedAnteriorExemplar
                        ? willisSelectedMCAPassageRoot
                        : willisContralateralMCAContextRoot
                case .anteriorCerebralContext, nil: willisAnteriorCerebralContextRoot
                }
            case .posterior: willisPosteriorRouteRoot
            case .connector: willisConnectorRoot
            }
            let wallMaterial = spec.family == .connector ? connectorMaterial : arterialWallMaterial
            addContinuousTubePath(
                path,
                to: parent,
                startRadius: spec.startRadius,
                endRadius: spec.endRadius,
                material: wallMaterial,
                name: "willis-\(spec.name)-continuous-wall",
                radialSegments: 18
            )
            if spec.family != .connector {
                addContinuousTubePath(
                    path,
                    to: parent,
                    startRadius: spec.startRadius * 0.30,
                    endRadius: spec.endRadius * 0.32,
                    material: flowCoreMaterial,
                    name: "willis-\(spec.name)-continuous-flow-core",
                    radialSegments: 10
                )
            }
            if isSelectedAnteriorExemplar {
                addContinuousTubePath(
                    path,
                    to: parent,
                    startRadius: spec.startRadius * 1.32,
                    endRadius: spec.endRadius * 1.36,
                    material: middleCerebralPassageHaloMaterial,
                    name: "anterior-passage-mca-navigation-halo-not-vessel-color",
                    radialSegments: 12
                )
            }
            for frontIndex in 0..<spec.fronts {
                let front = Entity()
                front.name = "willis-tangent-flow-front-\(spec.name)-\(frontIndex)"
                let head = ModelEntity(mesh: arrowHeadMesh, materials: [flowFrontMaterial])
                head.name = "willis-flow-front-arrowhead"
                head.position.y = 0.025
                let tail = ModelEntity(mesh: arrowTailMesh, materials: [flowFrontMaterial])
                tail.name = "willis-flow-front-tail"
                tail.position.y = -0.026
                front.addChild(head)
                front.addChild(tail)
                parent.addChild(front)
                willisFlowFronts.append((
                    front,
                    pathIndex,
                    (Float(frontIndex) / Float(max(spec.fronts, 1)) + Float(pathIndex) * 0.083)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        buildAnteriorPassageGateway(material: anteriorGatewayMaterial)

        let junctionMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.48, blue: 0.30, alpha: 0.84),
            intensity: 2.5
        )
        let junctionMesh = MeshResource.generateSphere(radius: 0.013)
        let junctions: [SIMD3<Float>] = [
            [-0.43, 1.30, -1.39], [0.43, 1.30, -1.39],
            [0, 1.16, -1.74], [-0.09, 1.50, -1.44], [0.09, 1.50, -1.44],
        ]
        for (index, position) in junctions.enumerated() {
            let junction = ModelEntity(mesh: junctionMesh, materials: [junctionMaterial])
            junction.name = "willis-network-junction-\(index)"
            junction.position = position
            willisConnectorRoot.addChild(junction)
        }

        willisNetworkRoot.isEnabled = false
        print("RBC_WILLIS_NETWORK=READY paths=26 moving_fronts=16 connector_fronts=0 anterior_passage_groups=6 selected_route_halos=3 gateway=1 stable_wearer=true")
    }

    /// A deliberately oblique, broken threshold marks the exact handoff from
    /// the room-scale map into the existing inhabited lumen. It is a teaching
    /// gateway around one example right MCA branch, not an anatomical device
    /// or a patient-specific navigation target.
    private func buildAnteriorPassageGateway(material: RealityKit.Material) {
        // Sit around the single bright M1 continuation before its visible
        // bifurcation. A shallow oblique angle keeps the aperture spatial but
        // readable from the stable teaching origin.
        willisAnteriorGatewayRoot.position = [1.07, 1.48, -1.11]
        willisAnteriorGatewayRoot.orientation = simd_quatf(angle: -.pi * 0.08, axis: [0, 1, 0])

        for ringIndex in 0..<3 {
            let contour = Entity()
            contour.name = "right-mca-entry-broken-contour-\(ringIndex)"
            let ringPhase = Float(ringIndex) * 0.81
            let xRadius: Float = 0.13 + Float(ringIndex) * 0.020
            let yRadius: Float = 0.16 + Float(ringIndex) * 0.018
            var points: [SIMD3<Float>] = []
            for index in 0..<64 {
                let angle = Float(index) / 64 * .pi * 2
                let irregularity = 1
                    + sin(angle * 3 + ringPhase) * 0.052
                    + cos(angle * 5 - ringPhase) * 0.024
                points.append([
                    cos(angle) * xRadius * irregularity,
                    sin(angle) * yRadius * irregularity,
                    sin(angle * 4 + ringPhase) * 0.012 + Float(ringIndex - 1) * 0.012,
                ])
            }
            for arcIndex in 0..<4 {
                let start = arcIndex * 16 + 1 + ((ringIndex + arcIndex) % 2)
                let end = min(start + 11 + ((ringIndex + arcIndex) % 3), points.count - 1)
                addTubePath(
                    Array(points[start...end]),
                    to: contour,
                    radius: 0.0031 - Float(ringIndex) * 0.00035,
                    material: material,
                    name: "right-mca-entry-threshold-arc-\(ringIndex)-\(arcIndex)"
                )
            }
            willisAnteriorGatewayRoot.addChild(contour)
        }
        willisAnteriorGatewayRoot.isEnabled = false
    }

    private func updateWillisNetwork(
        active: Bool,
        focus: RBCWillisRouteFocus,
        anteriorPassagePhase: RBCAnteriorPassagePhase?,
        motionHeld: Bool,
        reducedMotion: Bool
    ) {
        willisRuntimeActive = active
        willisRuntimeHeld = motionHeld
        willisRuntimeFocus = focus
        willisRuntimeAnteriorPassagePhase = anteriorPassagePhase
        willisNetworkRoot.isEnabled = active
        guard active else { return }

        let anteriorOpacity: Float
        let posteriorOpacity: Float
        let connectorOpacity: Float
        let targetScale: Float
        let targetPosition: SIMD3<Float>
        if let anteriorPassagePhase {
            anteriorOpacity = 1
            posteriorOpacity = 0.035
            switch anteriorPassagePhase {
            case .carotidApproach:
                connectorOpacity = 0.12
                targetScale = 1.20
                targetPosition = [0, -0.12, 0.18]
            case .circleCrossroads:
                connectorOpacity = 0.82
                targetScale = 1.28
                targetPosition = [0, -0.22, 0.24]
            case .middleCerebralContinuation:
                connectorOpacity = 0.22
                targetScale = 1.17
                targetPosition = [-0.80, -0.10, 0.20]
            }
        } else {
            switch focus {
            case .overview:
                anteriorOpacity = 0.90
                posteriorOpacity = 0.68
                connectorOpacity = 0.72
                targetScale = 1
                targetPosition = .zero
            case .anterior:
                anteriorOpacity = 1
                posteriorOpacity = 0.09
                connectorOpacity = 0.38
                targetScale = 1.10
                targetPosition = [0, -0.045, 0.10]
            case .posterior:
                anteriorOpacity = 0.09
                posteriorOpacity = 1
                connectorOpacity = 0.38
                targetScale = 1.12
                targetPosition = [0, 0.035, 0.15]
            }
        }
        willisAnteriorRouteRoot.components.set(OpacityComponent(opacity: anteriorOpacity))
        willisPosteriorRouteRoot.components.set(OpacityComponent(opacity: posteriorOpacity))
        willisConnectorRoot.components.set(OpacityComponent(opacity: connectorOpacity))
        willisArterialContext?.components.set(OpacityComponent(
            opacity: anteriorPassagePhase == nil && focus == .overview ? 0.10 : 0.025
        ))

        let passageOpacities: (carotid: Float, crossroads: Float, middleCerebral: Float, context: Float) = switch anteriorPassagePhase {
        case .carotidApproach: (1, 0.24, 0.08, 0.06)
        case .circleCrossroads: (0.48, 1, 0.24, 0.18)
        case .middleCerebralContinuation: (0.14, 0.48, 1, 0.10)
        case nil: (1, 1, 1, 1)
        }
        applyWillisPassageEmphasis(
            willisCarotidPassageRoot,
            opacity: passageOpacities.carotid,
            emphasized: anteriorPassagePhase == .carotidApproach,
            reducedMotion: reducedMotion
        )
        applyWillisPassageEmphasis(
            willisCrossroadsPassageRoot,
            opacity: passageOpacities.crossroads,
            emphasized: anteriorPassagePhase == .circleCrossroads,
            reducedMotion: reducedMotion
        )
        applyWillisPassageEmphasis(
            willisMiddleCerebralPassageRoot,
            opacity: passageOpacities.middleCerebral,
            emphasized: anteriorPassagePhase == .middleCerebralContinuation,
            reducedMotion: reducedMotion
        )
        willisSelectedMCAPassageRoot.components.set(OpacityComponent(opacity: 1))
        willisContralateralMCAContextRoot.components.set(OpacityComponent(
            opacity: anteriorPassagePhase == .middleCerebralContinuation ? 0.085 : 1
        ))
        willisAnteriorGatewayRoot.isEnabled = anteriorPassagePhase == .middleCerebralContinuation
        applyWillisPassageEmphasis(
            willisAnteriorCerebralContextRoot,
            opacity: passageOpacities.context,
            emphasized: false,
            reducedMotion: reducedMotion
        )

        let targetScaleVector = SIMD3<Float>(repeating: targetScale)
        if reducedMotion {
            willisNetworkRoot.scale = targetScaleVector
            willisNetworkRoot.position = targetPosition
        } else {
            willisNetworkRoot.scale += (targetScaleVector - willisNetworkRoot.scale) * 0.16
            willisNetworkRoot.position += (targetPosition - willisNetworkRoot.position) * 0.16
        }
        applyWillisFlowFrame()
    }

    private func applyWillisPassageEmphasis(
        _ root: Entity,
        opacity: Float,
        emphasized: Bool,
        reducedMotion: Bool
    ) {
        root.components.set(OpacityComponent(opacity: opacity))
        let targetScale = SIMD3<Float>(repeating: emphasized ? 1.075 : 1)
        let targetPosition: SIMD3<Float> = emphasized ? [0, 0.015, 0.055] : .zero
        if reducedMotion {
            root.scale = targetScale
            root.position = targetPosition
        } else {
            root.scale += (targetScale - root.scale) * 0.18
            root.position += (targetPosition - root.position) * 0.18
        }
    }

    private func advanceWillisNetworkFrame(deltaTime: Float) {
        guard willisRuntimeActive, !willisRuntimeHeld else { return }
        willisElapsed += deltaTime
        applyWillisFlowFrame()
    }

    private func applyWillisFlowFrame() {
        guard !willisFlowPaths.isEmpty else { return }
        for front in willisFlowFronts {
            guard willisFlowPaths.indices.contains(front.pathIndex) else { continue }
            let record = willisFlowPaths[front.pathIndex]
            let speed: Float = record.family == .posterior ? 0.105 : 0.125
            let progress = (willisElapsed * speed + front.offset)
                .truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: record.points, progress: progress)
            let ahead = interpolatedPoint(on: record.points, progress: min(progress + 0.012, 1))
            let behind = interpolatedPoint(on: record.points, progress: max(progress - 0.012, 0))
            let tangent = ahead - behind
            front.entity.position = point
            if simd_length_squared(tangent) > 0.000_001 {
                front.entity.orientation = simd_quatf(from: [0, 1, 0], to: simd_normalize(tangent))
            }
            let selected: Bool = if let phase = willisRuntimeAnteriorPassagePhase {
                switch phase {
                case .carotidApproach:
                    record.anteriorSegment == .carotid
                case .circleCrossroads:
                    record.anteriorSegment == .carotid || record.anteriorSegment == .crossroads
                case .middleCerebralContinuation:
                    record.isSelectedAnteriorExemplar
                }
            } else {
                willisRuntimeFocus == .overview
                    || (willisRuntimeFocus == .anterior && record.family == .anterior)
                    || (willisRuntimeFocus == .posterior && record.family == .posterior)
            }
            front.entity.isEnabled = selected
        }
        if willisAnteriorGatewayRoot.isEnabled {
            let pulse: Float = willisRuntimeHeld
                ? 1
                : 1 + sin(willisElapsed * .pi * 1.3) * 0.055
            willisAnteriorGatewayRoot.scale = SIMD3<Float>(repeating: pulse)
        } else {
            willisAnteriorGatewayRoot.scale = .one
        }
    }

    /// A brain-observatory view of one frontal territory. The sparse guide is
    /// intentionally constellation-like rather than a giant cerebral diagram.
    /// It locates the territory while the registered anatomy remains visible;
    /// X-ray and Flow are separate user-controlled readings of the same place.
    private func buildFrontalRegionInterior() {
        let id = RBCBrainRegionDestination.frontalLobe.id
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-frontal-lobe"

        let outlineRoot = Entity()
        outlineRoot.name = "frontal-region-orientation-outline-not-segmentation"
        region.addChild(outlineRoot)
        frontalConstellationRoot = outlineRoot

        let outlineMaterial = glowMaterial(
            color: UIColor(red: 0.55, green: 0.96, blue: 0.80, alpha: 0.72),
            intensity: 1.65
        )
        let starMaterial = glowMaterial(
            color: UIColor(red: 0.82, green: 1.00, blue: 0.91, alpha: 0.96),
            intensity: 3.1
        )
        let prefrontalControls: [SIMD3<Float>] = [
            [-0.72, 1.52, -1.49], [-0.76, 1.73, -1.54],
            [-0.66, 1.96, -1.61], [-0.44, 2.10, -1.67],
            [-0.20, 2.06, -1.63], [-0.10, 1.88, -1.55],
            [-0.15, 1.65, -1.48], [-0.36, 1.48, -1.44],
            [-0.58, 1.44, -1.46],
        ]
        let localContour = sampleClosedCatmullRom(prefrontalControls, samplesPerSegment: 8)
        addTubePath(
            localContour,
            to: outlineRoot,
            radius: 0.0017,
            material: outlineMaterial,
            name: "prefrontal-constellation-connector"
        )
        let innerGuideControls: [SIMD3<Float>] = [
            [-0.66, 1.72, -1.475], [-0.53, 1.89, -1.505],
            [-0.35, 1.92, -1.515], [-0.18, 1.82, -1.49],
        ]
        let innerGuide = sampleCubicBezier(
            innerGuideControls[0], innerGuideControls[1],
            innerGuideControls[2], innerGuideControls[3], samples: 32
        )
        addTubePath(
            innerGuide,
            to: outlineRoot,
            radius: 0.0011,
            material: outlineMaterial,
            name: "prefrontal-constellation-inner-arc"
        )
        let guideStars = prefrontalControls + innerGuideControls
        let starMesh = MeshResource.generateSphere(radius: 0.010)
        for (index, point) in guideStars.enumerated() {
            let star = ModelEntity(mesh: starMesh, materials: [starMaterial])
            star.name = "prefrontal-constellation-guide-star-\(index)"
            star.position = point + SIMD3<Float>(0, 0, 0.008)
            outlineRoot.addChild(star)
            frontalConstellationStars.append((star, Float(index) * 0.71))
        }

        // The overview beacon is a spatial analogue of a constellation label:
        // looking reveals the system hover state; pinching enters this territory.
        let overviewDiscovery = makeRegionDiscoveryTarget(
            id: id,
            variant: "overview",
            position: [-0.43, 1.80, -1.42],
            collisionRadius: 0.20
        )
        regionGuideRoot.addChild(overviewDiscovery)
        frontalDiscoveryTargets.append(overviewDiscovery)

        // Once inside, the same discoverable mark cycles Locate, X-ray, and
        // Flow. It is intentionally small enough to remain part of the scene.
        let activeDiscovery = makeRegionDiscoveryTarget(
            id: id,
            variant: "active",
            position: [-0.43, 1.80, -1.40],
            collisionRadius: 0.22
        )
        region.addChild(activeDiscovery)
        frontalDiscoveryTargets.append(activeDiscovery)

        let vesselRoot = Entity()
        vesselRoot.name = "frontal-lobe-directional-blood-flow-field"
        region.addChild(vesselRoot)
        frontalVesselRoot = vesselRoot
        let vesselMaterial = tissueContextMaterial(
            color: UIColor(red: 0.34, green: 0.012, blue: 0.026, alpha: 0.78),
            emissive: UIColor(red: 0.62, green: 0.018, blue: 0.038, alpha: 1)
        )
        let flowCoreMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.34, blue: 0.19, alpha: 0.20),
            intensity: 0.78
        )
        let flowDartMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.78, blue: 0.46, alpha: 0.94),
            intensity: 3.8
        )
        let controlSets: [(SIMD3<Float>, SIMD3<Float>, SIMD3<Float>, SIMD3<Float>, Float, Float)] = [
            ([-0.32, 1.08, -1.67], [-0.32, 1.28, -1.68], [-0.37, 1.49, -1.68], [-0.42, 1.66, -1.67], 0.0140, 0.0100),
            ([-0.42, 1.66, -1.67], [-0.42, 1.78, -1.69], [-0.39, 1.94, -1.70], [-0.34, 2.07, -1.68], 0.0100, 0.0055),
            ([-0.42, 1.66, -1.67], [-0.50, 1.74, -1.64], [-0.59, 1.84, -1.61], [-0.68, 1.94, -1.59], 0.0095, 0.0050),
            ([-0.42, 1.60, -1.66], [-0.50, 1.57, -1.63], [-0.62, 1.53, -1.58], [-0.74, 1.50, -1.53], 0.0090, 0.0045),
            ([-0.39, 1.70, -1.67], [-0.32, 1.76, -1.63], [-0.22, 1.83, -1.58], [-0.12, 1.89, -1.54], 0.0085, 0.0040),
            ([-0.36, 1.92, -1.70], [-0.29, 2.00, -1.68], [-0.23, 2.06, -1.64], [-0.17, 2.08, -1.61], 0.0055, 0.0027),
            ([-0.54, 1.80, -1.63], [-0.59, 1.90, -1.65], [-0.61, 2.00, -1.64], [-0.59, 2.08, -1.61], 0.0050, 0.0025),
            ([-0.60, 1.84, -1.61], [-0.68, 1.82, -1.59], [-0.73, 1.76, -1.56], [-0.77, 1.69, -1.53], 0.0048, 0.0024),
            ([-0.58, 1.54, -1.60], [-0.63, 1.45, -1.58], [-0.68, 1.39, -1.54], [-0.70, 1.33, -1.50], 0.0048, 0.0023),
            ([-0.25, 1.80, -1.60], [-0.20, 1.72, -1.57], [-0.17, 1.63, -1.53], [-0.16, 1.54, -1.49], 0.0045, 0.0022),
            ([-0.34, 2.02, -1.68], [-0.40, 2.09, -1.67], [-0.48, 2.12, -1.65], [-0.55, 2.12, -1.62], 0.0042, 0.0020),
            ([-0.70, 1.51, -1.55], [-0.75, 1.57, -1.56], [-0.78, 1.63, -1.54], [-0.79, 1.71, -1.51], 0.0040, 0.0019),
            ([-0.20, 1.84, -1.57], [-0.14, 1.91, -1.54], [-0.10, 1.98, -1.51], [-0.08, 2.04, -1.48], 0.0040, 0.0018),
        ]
        let arrowMesh = MeshResource.generateCone(height: 0.018, radius: 0.0060)
        let trailMesh = MeshResource.generateCylinder(height: 0.026, radius: 0.0022)
        for (pathIndex, controls) in controlSets.enumerated() {
            let path = sampleCubicBezier(
                controls.0,
                controls.1,
                controls.2,
                controls.3,
                samples: 42
            )
            frontalFlowPaths.append(path)
            addTaperedTubePath(
                path,
                to: vesselRoot,
                startRadius: controls.4,
                endRadius: controls.5,
                material: vesselMaterial,
                name: "frontal-arterial-branch-\(pathIndex)"
            )
            addTaperedTubePath(
                path,
                to: vesselRoot,
                startRadius: controls.4 * 0.30,
                endRadius: controls.5 * 0.32,
                material: flowCoreMaterial,
                name: "frontal-flow-core-\(pathIndex)"
            )
            let arrowCount = pathIndex < 5 ? 2 : 1
            for arrowIndex in 0..<arrowCount {
                let arrow = Entity()
                arrow.name = "frontal-flow-direction-arrow-\(pathIndex)-\(arrowIndex)"
                let head = ModelEntity(mesh: arrowMesh, materials: [flowDartMaterial])
                head.name = "frontal-flow-dart-head"
                head.position.y = 0.012
                let trail = ModelEntity(mesh: trailMesh, materials: [flowDartMaterial])
                trail.name = "frontal-flow-dart-trail"
                trail.position.y = -0.010
                arrow.addChild(head)
                arrow.addChild(trail)
                vesselRoot.addChild(arrow)
                frontalFlowArrows.append((
                    arrow,
                    pathIndex,
                    (0.18 + Float(arrowIndex) / Float(arrowCount) + Float(pathIndex) * 0.057)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        if frontalFlowPaths.indices.contains(2) {
            let affectedPath = frontalFlowPaths[2]
            let clotProgress: Float = 0.61
            let clotPoint = interpolatedPoint(on: affectedPath, progress: clotProgress)
            let ahead = interpolatedPoint(on: affectedPath, progress: min(clotProgress + 0.02, 1))

            let clot = Entity()
            clot.name = "illustrative-frontal-branch-occlusion-not-patient-specific"
            clot.position = clotPoint
            let tangent = ahead - clotPoint
            if simd_length_squared(tangent) > 0.000_001 {
                clot.orientation = simd_quatf(from: [0, 1, 0], to: simd_normalize(tangent))
            }
            let clotMaterial = tissueContextMaterial(
                color: UIColor(red: 0.29, green: 0.012, blue: 0.018, alpha: 1),
                emissive: UIColor(red: 0.55, green: 0.018, blue: 0.012, alpha: 1)
            )
            let fibrinMaterial = glowMaterial(
                color: UIColor(red: 1.0, green: 0.32, blue: 0.08, alpha: 0.72),
                intensity: 1.2
            )
            let lobeMesh = MeshResource.generateSphere(radius: 0.018)
            let lobeOffsets: [(SIMD3<Float>, SIMD3<Float>)] = [
                ([-0.010, -0.020, 0.002], [1.25, 0.86, 0.78]),
                ([ 0.009, -0.009, 0.004], [0.82, 1.16, 0.90]),
                ([-0.006,  0.004, 0.000], [1.18, 0.94, 0.84]),
                ([ 0.008,  0.017, 0.001], [0.90, 1.18, 0.76]),
                ([-0.004,  0.030, 0.003], [1.10, 0.82, 0.88]),
            ]
            for (index, item) in lobeOffsets.enumerated() {
                let lobe = ModelEntity(mesh: lobeMesh, materials: [clotMaterial])
                lobe.name = "illustrative-clot-irregular-lobe-\(index)"
                lobe.position = item.0
                lobe.scale = item.1
                clot.addChild(lobe)
            }
            for index in 0..<3 {
                let strand = ModelEntity(
                    mesh: .generateCylinder(height: 0.068, radius: 0.0012),
                    materials: [fibrinMaterial]
                )
                strand.name = "illustrative-fibrin-thread-\(index)"
                strand.orientation = simd_quatf(
                    angle: Float(index - 1) * 0.72,
                    axis: [0, 0, 1]
                )
                clot.addChild(strand)
            }
            let warningHalo = ModelEntity(
                mesh: .generateSphere(radius: 0.046),
                materials: [glowMaterial(
                    color: UIColor(red: 1.0, green: 0.22, blue: 0.05, alpha: 0.08),
                    intensity: 0.18
                )]
            )
            warningHalo.name = "illustrative-occlusion-soft-warning-field"
            clot.addChild(warningHalo)
            clot.components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))
            clot.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.062)]))
            clot.components.set(HoverEffectComponent())
            clot.isEnabled = false
            region.addChild(clot)
            frontalClotRoot = clot
        }

        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
        print("RBC_FRONTAL_REGION=READY constellation=prefrontal branches=13 direction_arrows=18")
    }

    /// A magnified, room-scale teaching section through cortical tissue. The
    /// six bands show laminar organization, while the radial guides show the
    /// idea of vertical/columnar connectivity. Their width and spacing are
    /// deliberately schematic: cortical areas vary and this is not histology,
    /// a uniform functional-module claim, or patient-specific segmentation.
    private func buildCorticalMicroarchitectureInterior() {
        let id = RBCBrainRegionDestination.corticalMicroarchitecture.id
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-cortical-microarchitecture"

        let outlineRoot = Entity()
        outlineRoot.name = "cortical-microarchitecture-constellation-outline-not-segmentation"
        region.addChild(outlineRoot)
        corticalMicroarchitectureOutlineRoot = outlineRoot

        let layerRoot = Entity()
        layerRoot.name = "six-cortical-laminae-magnified-teaching-model-not-to-scale"
        region.addChild(layerRoot)
        corticalMicroarchitectureLayerRoot = layerRoot

        let columnRoot = Entity()
        columnRoot.name = "simplified-radial-columnar-guides-area-variation-explicit"
        region.addChild(columnRoot)
        corticalMicroarchitectureColumnRoot = columnRoot

        let vesselRoot = Entity()
        vesselRoot.name = "pial-to-penetrating-arteriole-to-capillary-direction-field-not-cfd"
        region.addChild(vesselRoot)
        corticalMicroarchitectureVesselRoot = vesselRoot

        let outlineMaterial = glowMaterial(
            color: UIColor(red: 0.47, green: 0.95, blue: 0.80, alpha: 0.78),
            intensity: 1.8
        )
        let starMaterial = glowMaterial(
            color: UIColor(red: 0.79, green: 1.00, blue: 0.90, alpha: 0.96),
            intensity: 3.4
        )
        let columnMaterial = glowMaterial(
            color: UIColor(red: 0.36, green: 0.76, blue: 0.92, alpha: 0.30),
            intensity: 0.72
        )

        let pialOutline = sampleCubicBezier(
            [-1.78, 2.40, -1.32],
            [-1.18, 2.58, -3.26],
            [1.18, 2.58, -3.26],
            [1.78, 2.40, -1.32],
            samples: 32
        )
        let deepOutline = sampleCubicBezier(
            [-1.78, 0.66, -1.32],
            [-1.18, 0.50, -3.26],
            [1.18, 0.50, -3.26],
            [1.78, 0.66, -1.32],
            samples: 32
        )
        addTubePath(
            pialOutline,
            to: outlineRoot,
            radius: 0.0065,
            material: outlineMaterial,
            name: "cortical-pial-surface-constellation"
        )
        addTubePath(
            deepOutline,
            to: outlineRoot,
            radius: 0.0045,
            material: outlineMaterial,
            name: "cortical-deep-boundary-constellation"
        )
        addTubePath(
            [pialOutline[0], deepOutline[0]],
            to: outlineRoot,
            radius: 0.0045,
            material: outlineMaterial,
            name: "cortical-patch-left-boundary"
        )
        addTubePath(
            [pialOutline[pialOutline.count - 1], deepOutline[deepOutline.count - 1]],
            to: outlineRoot,
            radius: 0.0045,
            material: outlineMaterial,
            name: "cortical-patch-right-boundary"
        )

        let outlineStarMesh = MeshResource.generateSphere(radius: 0.011)
        let starPoints = [
            pialOutline[0], pialOutline[8], pialOutline[16], pialOutline[24], pialOutline[31],
            deepOutline[0], deepOutline[8], deepOutline[16], deepOutline[24], deepOutline[31],
        ]
        for (index, point) in starPoints.enumerated() {
            let star = ModelEntity(mesh: outlineStarMesh, materials: [starMaterial])
            star.name = "cortical-microarchitecture-constellation-star-\(index)"
            star.position = point
            outlineRoot.addChild(star)
            corticalMicroarchitectureStars.append((star, Float(index) * 0.67))
        }

        let layerColors: [UIColor] = [
            UIColor(red: 0.23, green: 0.48, blue: 0.61, alpha: 0.42),
            UIColor(red: 0.29, green: 0.57, blue: 0.67, alpha: 0.44),
            UIColor(red: 0.36, green: 0.64, blue: 0.69, alpha: 0.46),
            UIColor(red: 0.43, green: 0.67, blue: 0.64, alpha: 0.48),
            UIColor(red: 0.50, green: 0.61, blue: 0.58, alpha: 0.50),
            UIColor(red: 0.39, green: 0.50, blue: 0.61, alpha: 0.52),
        ]
        let layerY: [Float] = [2.22, 1.95, 1.68, 1.41, 1.12, 0.82]
        let cellCounts = [9, 18, 15, 22, 13, 16]
        for layerIndex in 0..<6 {
            let bandMaterial = tissueContextMaterial(
                color: layerColors[layerIndex],
                emissive: layerColors[layerIndex].withAlphaComponent(0.32)
            )
            let bandPath = sampleCubicBezier(
                [-1.70, layerY[layerIndex], -1.36],
                [-1.10, layerY[layerIndex] + 0.09, -3.20],
                [1.10, layerY[layerIndex] + 0.09, -3.20],
                [1.70, layerY[layerIndex], -1.36],
                samples: 36
            )
            let strandOffsets: [(Float, Float, Float)] = [
                (-0.072, -0.055, 0.010),
                (-0.026, 0.020, 0.008),
                (0.026, -0.012, 0.010),
                (0.072, 0.045, 0.007),
            ]
            for (strandIndex, strandOffset) in strandOffsets.enumerated() {
                let strandPath = bandPath.enumerated().map { pathIndex, point in
                    point + SIMD3<Float>(
                        0,
                        strandOffset.0 + sin(Float(pathIndex) * 0.52 + Float(layerIndex)) * 0.012,
                        strandOffset.1 + cos(Float(pathIndex) * 0.47 + Float(strandIndex)) * 0.022
                    )
                }
                addTubePath(
                    strandPath,
                    to: layerRoot,
                    radius: strandOffset.2,
                    material: bandMaterial,
                    name: "cortical-lamina-\(layerIndex + 1)-porous-fiber-\(strandIndex)"
                )
            }

            let cellMaterial = glowMaterial(
                color: layerColors[layerIndex].withAlphaComponent(0.86),
                intensity: layerIndex == 3 ? 1.7 : 1.15
            )
            for cellIndex in 0..<cellCounts[layerIndex] {
                let progress = Float(cellIndex + 1) / Float(cellCounts[layerIndex] + 1)
                let point = interpolatedPoint(on: bandPath, progress: progress)
                let depthOffset = sin(Float(cellIndex * 7 + layerIndex * 3)) * 0.095
                let radius: Float = layerIndex == 4 ? 0.019 : (layerIndex == 0 ? 0.010 : 0.014)
                let cell = ModelEntity(
                    mesh: .generateSphere(radius: radius),
                    materials: [cellMaterial]
                )
                cell.name = "cortical-lamina-\(layerIndex + 1)-illustrative-cell-\(cellIndex)"
                cell.position = point + [0, sin(Float(cellIndex) * 1.91) * 0.048, depthOffset]
                layerRoot.addChild(cell)
            }
        }

        let guideXs: [Float] = [-1.22, -0.61, 0.00, 0.61, 1.22]
        for (index, x) in guideXs.enumerated() {
            let guideDepth = -3.02 + abs(x) * 0.82
            let radialPath = sampleCubicBezier(
                [x, 2.37, guideDepth],
                [x - 0.05, 1.96, guideDepth - 0.08],
                [x + 0.06, 1.12, guideDepth - 0.08],
                [x, 0.69, guideDepth],
                samples: 26
            )
            addTubePath(
                radialPath,
                to: columnRoot,
                radius: 0.0032,
                material: columnMaterial,
                name: "simplified-cortical-radial-guide-\(index)"
            )
            for layerIndex in 1..<6 {
                let point = interpolatedPoint(on: radialPath, progress: Float(layerIndex) / 6)
                let node = ModelEntity(
                    mesh: .generateSphere(radius: 0.008),
                    materials: [columnMaterial]
                )
                node.name = "radial-guide-layer-crossing-\(index)-\(layerIndex)"
                node.position = point
                columnRoot.addChild(node)
            }
        }

        let arterialMaterial = tissueContextMaterial(
            color: UIColor(red: 0.64, green: 0.022, blue: 0.040, alpha: 0.96),
            emissive: UIColor(red: 0.90, green: 0.028, blue: 0.034, alpha: 1)
        )
        let capillaryMaterial = tissueContextMaterial(
            color: UIColor(red: 0.48, green: 0.030, blue: 0.060, alpha: 0.90),
            emissive: UIColor(red: 0.66, green: 0.038, blue: 0.070, alpha: 1)
        )
        let vesselCoreMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.20, blue: 0.13, alpha: 0.72),
            intensity: 2.8
        )
        let flowMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.78, blue: 0.40, alpha: 0.96),
            intensity: 4.0
        )
        let pialPath = sampleCubicBezier(
            [-1.65, 2.31, -1.28],
            [-1.08, 2.46, -3.12],
            [1.00, 2.40, -3.18],
            [1.60, 2.26, -1.30],
            samples: 42
        )
        let penetratingPath = sampleCubicBezier(
            [0.18, 2.39, -2.99],
            [0.16, 2.16, -3.10],
            [0.10, 1.49, -3.08],
            [0.08, 0.78, -2.92],
            samples: 44
        )
        let vesselPaths: [[SIMD3<Float>]] = [pialPath, penetratingPath]
        for (index, path) in vesselPaths.enumerated() {
            corticalMicroarchitectureFlowPaths.append(path)
            addTaperedTubePath(
                path,
                to: vesselRoot,
                startRadius: index == 0 ? 0.030 : 0.024,
                endRadius: index == 0 ? 0.020 : 0.009,
                material: arterialMaterial,
                name: index == 0 ? "cortical-pial-artery" : "cortical-penetrating-arteriole"
            )
            addTaperedTubePath(
                path,
                to: vesselRoot,
                startRadius: index == 0 ? 0.010 : 0.008,
                endRadius: index == 0 ? 0.006 : 0.0032,
                material: vesselCoreMaterial,
                name: index == 0 ? "cortical-pial-flow-core" : "cortical-penetrating-flow-core"
            )
        }

        let branchDefinitions: [(Float, SIMD3<Float>, SIMD3<Float>, SIMD3<Float>)] = [
            (0.25, [-0.22, 1.88, -2.37], [-0.58, 2.00, -2.24], [-0.86, 1.82, -2.18]),
            (0.33, [ 0.39, 1.78, -2.38], [ 0.74, 1.92, -2.25], [ 1.02, 1.68, -2.17]),
            (0.45, [-0.20, 1.52, -2.39], [-0.58, 1.61, -2.26], [-0.96, 1.38, -2.18]),
            (0.53, [ 0.34, 1.38, -2.39], [ 0.67, 1.50, -2.29], [ 0.94, 1.26, -2.20]),
            (0.62, [-0.17, 1.17, -2.37], [-0.52, 1.23, -2.26], [-0.79, 1.04, -2.19]),
            (0.71, [ 0.30, 1.01, -2.35], [ 0.61, 1.08, -2.25], [ 0.83, 0.91, -2.18]),
            (0.80, [-0.14, 0.89, -2.33], [-0.39, 0.82, -2.24], [-0.58, 0.72, -2.17]),
        ]
        for (branchIndex, definition) in branchDefinitions.enumerated() {
            let start = interpolatedPoint(on: penetratingPath, progress: definition.0)
            let branch = sampleCubicBezier(
                start,
                definition.1,
                definition.2,
                definition.3,
                samples: 30
            )
            corticalMicroarchitectureFlowPaths.append(branch)
            addTaperedTubePath(
                branch,
                to: vesselRoot,
                startRadius: 0.0085,
                endRadius: 0.0032,
                material: capillaryMaterial,
                name: "cortical-layer-capillary-branch-\(branchIndex)"
            )
            addTaperedTubePath(
                branch,
                to: vesselRoot,
                startRadius: 0.0030,
                endRadius: 0.0012,
                material: vesselCoreMaterial,
                name: "cortical-layer-capillary-flow-core-\(branchIndex)"
            )
        }

        let arrowHeadMesh = MeshResource.generateCone(height: 0.085, radius: 0.027)
        let arrowTailMesh = MeshResource.generateCylinder(height: 0.110, radius: 0.0070)
        for pathIndex in corticalMicroarchitectureFlowPaths.indices {
            let arrowCount = pathIndex < 2 ? 3 : 1
            for arrowIndex in 0..<arrowCount {
                let arrow = Entity()
                arrow.name = "cortical-microarchitecture-flow-arrow-\(pathIndex)-\(arrowIndex)"
                let head = ModelEntity(mesh: arrowHeadMesh, materials: [flowMaterial])
                head.name = "cortical-microarchitecture-flow-arrowhead"
                head.position.y = 0.052
                let tail = ModelEntity(mesh: arrowTailMesh, materials: [flowMaterial])
                tail.name = "cortical-microarchitecture-flow-arrow-tail"
                tail.position.y = -0.058
                arrow.addChild(head)
                arrow.addChild(tail)
                vesselRoot.addChild(arrow)
                corticalMicroarchitectureFlowArrows.append((
                    arrow,
                    pathIndex,
                    (Float(arrowIndex) / Float(arrowCount) + Float(pathIndex) * 0.117)
                        .truncatingRemainder(dividingBy: 1)
                ))
            }
        }

        let discovery = makeRegionDiscoveryTarget(
            id: id,
            variant: "active",
            position: [1.24, 1.66, -1.48],
            collisionRadius: 0.22
        )
        region.addChild(discovery)
        corticalMicroarchitectureDiscoveryTargets.append(discovery)

        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
        print("RBC_CORTICAL_MICROARCHITECTURE=READY laminae=6 radial_guides=5 illustrative_cells=93 vascular_paths=9 direction_arrows=13")
    }

    private func updateCorticalMicroarchitectureRegion(
        active: Bool,
        visualization: RBCRegionVisualizationMode,
        time _: Float,
        motionHeld: Bool
    ) {
        corticalMicroarchitectureRuntimeActive = active
        corticalMicroarchitectureRuntimeHeld = motionHeld
        corticalMicroarchitectureRuntimeVisualization = visualization
        guard active else {
            corticalMicroarchitectureElapsed = 0
            return
        }
        let outlineOpacity: Float = switch visualization {
        case .locate: 0.92
        case .xray: 0.34
        case .flow: 0.16
        }
        let layerOpacity: Float = switch visualization {
        case .locate: 0.22
        case .xray: 0.92
        case .flow: 0.11
        }
        let columnOpacity: Float = switch visualization {
        case .locate: 0.16
        case .xray: 0.82
        case .flow: 0.09
        }
        let vesselOpacity: Float = switch visualization {
        case .locate: 0.20
        case .xray: 0.32
        case .flow: 1.0
        }
        corticalMicroarchitectureOutlineRoot?.components.set(OpacityComponent(opacity: outlineOpacity))
        corticalMicroarchitectureLayerRoot?.components.set(OpacityComponent(opacity: layerOpacity))
        corticalMicroarchitectureColumnRoot?.components.set(OpacityComponent(opacity: columnOpacity))
        corticalMicroarchitectureVesselRoot?.components.set(OpacityComponent(opacity: vesselOpacity))

        for target in corticalMicroarchitectureDiscoveryTargets {
            target.components.set(OpacityComponent(opacity: visualization == .locate ? 0.72 : 0.34))
        }
        applyCorticalMicroarchitectureMotion()
    }

    private func advanceCorticalMicroarchitectureFrame(deltaTime: Float) {
        guard corticalMicroarchitectureRuntimeActive else { return }
        if !corticalMicroarchitectureRuntimeHeld {
            corticalMicroarchitectureElapsed += min(max(deltaTime, 0), 0.10)
        }
        applyCorticalMicroarchitectureMotion()
    }

    private func applyCorticalMicroarchitectureMotion() {
        let time = corticalMicroarchitectureElapsed
        for item in corticalMicroarchitectureStars {
            let pulse = corticalMicroarchitectureRuntimeHeld
                ? 1
                : 0.84 + sin(time * 1.55 + item.phase) * 0.18
            item.entity.scale = [pulse, pulse, pulse]
        }
        for item in corticalMicroarchitectureFlowArrows {
            item.entity.isEnabled = corticalMicroarchitectureRuntimeVisualization == .flow
            guard item.pathIndex < corticalMicroarchitectureFlowPaths.count else { continue }
            let path = corticalMicroarchitectureFlowPaths[item.pathIndex]
            let progress = corticalMicroarchitectureRuntimeHeld
                ? item.offset
                : (item.offset + time * (item.pathIndex < 2 ? 0.10 : 0.075))
                    .truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: path, progress: progress)
            let ahead = interpolatedPoint(on: path, progress: min(progress + 0.022, 1))
            item.entity.position = point
            let tangent = ahead - point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: [0, 1, 0],
                    to: simd_normalize(tangent)
                )
            }
            let pulse = corticalMicroarchitectureRuntimeHeld
                ? 1
                : 0.94 + sin(time * 4.2 + item.offset * 7.0) * 0.08
            item.entity.scale = [pulse, pulse, pulse]
        }
    }

    private func updateCerebellumRegion(
        active: Bool,
        visualization: RBCRegionVisualizationMode,
        motionHeld: Bool
    ) {
        cerebellumRuntimeActive = active
        cerebellumRuntimeHeld = motionHeld
        cerebellumRuntimeVisualization = visualization
        guard active else {
            cerebellumElapsed = 0
            return
        }

        let referenceOpacity: Float
        let outlineOpacity: Float
        let foliaOpacity: Float
        let arborOpacity: Float
        let vesselOpacity: Float
        switch visualization {
        case .locate:
            referenceOpacity = 0.13
            outlineOpacity = 0.68
            foliaOpacity = 0.44
            arborOpacity = 0.055
            vesselOpacity = 0.075
        case .xray:
            referenceOpacity = 0.045
            outlineOpacity = 0.15
            foliaOpacity = 0.72
            arborOpacity = 0.96
            vesselOpacity = 0.11
        case .flow:
            referenceOpacity = 0.025
            outlineOpacity = 0.065
            foliaOpacity = 0.18
            arborOpacity = 0.11
            vesselOpacity = 1.0
        }
        cerebellumAuthoredHero?.components.set(OpacityComponent(opacity: referenceOpacity))
        cerebellumOutlineRoot?.components.set(OpacityComponent(opacity: outlineOpacity))
        cerebellumFoliaRoot?.components.set(OpacityComponent(opacity: foliaOpacity))
        cerebellumArborRoot?.components.set(OpacityComponent(opacity: arborOpacity))
        cerebellumVesselRoot?.components.set(OpacityComponent(opacity: vesselOpacity))
        for target in cerebellumDiscoveryTargets where target.name.hasSuffix("-active") {
            let opacity: Float = switch visualization {
            case .locate: 0.72
            case .xray: 0.42
            case .flow: 0.30
            }
            target.components.set(OpacityComponent(opacity: opacity))
        }
        applyCerebellumMotion()
    }

    private func advanceCerebellumFrame(deltaTime: Float) {
        guard cerebellumRuntimeActive else { return }
        if !cerebellumRuntimeHeld {
            cerebellumElapsed += min(max(deltaTime, 0), 0.10)
        }
        applyCerebellumMotion()
    }

    private func applyCerebellumMotion() {
        for item in cerebellumGuideStars {
            let pulse = cerebellumRuntimeHeld
                ? 1
                : 0.86 + sin(cerebellumElapsed * 1.42 + item.phase) * 0.16
            item.entity.scale = [pulse, pulse, pulse]
        }
        for item in cerebellumFlowArrows {
            item.entity.isEnabled = cerebellumRuntimeVisualization == .flow
            guard cerebellumFlowPaths.indices.contains(item.pathIndex) else { continue }
            let path = cerebellumFlowPaths[item.pathIndex]
            let speed: Float = item.pathIndex < 3 ? 0.10 : 0.082
            let progress = cerebellumRuntimeHeld
                ? item.offset
                : (item.offset + cerebellumElapsed * speed).truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: path, progress: progress)
            let ahead = interpolatedPoint(on: path, progress: min(progress + 0.016, 1))
            let behind = interpolatedPoint(on: path, progress: max(progress - 0.016, 0))
            let tangent = ahead - behind
            item.entity.position = point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: [0, 1, 0],
                    to: simd_normalize(tangent)
                )
            }
            let pulse = cerebellumRuntimeHeld
                ? 1
                : 0.94 + sin(cerebellumElapsed * 4.0 + item.offset * 7.2) * 0.08
            item.entity.scale = [pulse, pulse, pulse]
        }
    }

    private func updateDeepStructuresRegion(
        active: Bool,
        visualization: RBCRegionVisualizationMode,
        motionHeld: Bool
    ) {
        deepStructuresRuntimeActive = active
        deepStructuresRuntimeHeld = motionHeld
        deepStructuresRuntimeVisualization = visualization
        guard active else {
            deepStructuresElapsed = 0
            return
        }

        let referenceOpacity: Float
        let outlineOpacity: Float
        let nucleiOpacity: Float
        let capsuleOpacity: Float
        let vesselOpacity: Float
        switch visualization {
        case .locate:
            referenceOpacity = 0.18
            outlineOpacity = 0.56
            nucleiOpacity = 0.34
            capsuleOpacity = 0.035
            vesselOpacity = 0.018
        case .xray:
            referenceOpacity = 0.045
            outlineOpacity = 0.16
            nucleiOpacity = 0.78
            capsuleOpacity = 0.66
            vesselOpacity = 0.030
        case .flow:
            referenceOpacity = 0.025
            outlineOpacity = 0.065
            nucleiOpacity = 0.34
            capsuleOpacity = 0.12
            vesselOpacity = 1.0
        }
        deepStructuresAuthoredHero?.components.set(OpacityComponent(opacity: referenceOpacity))
        deepStructuresOutlineRoot?.components.set(OpacityComponent(opacity: outlineOpacity))
        deepStructuresNucleiRoot?.components.set(OpacityComponent(opacity: nucleiOpacity))
        deepStructuresCapsuleRoot?.components.set(OpacityComponent(opacity: capsuleOpacity))
        deepStructuresVesselRoot?.components.set(OpacityComponent(opacity: vesselOpacity))
        for target in deepStructuresDiscoveryTargets where target.name.hasSuffix("-active") {
            let opacity: Float = switch visualization {
            case .locate: 0.72
            case .xray: 0.40
            case .flow: 0.28
            }
            target.components.set(OpacityComponent(opacity: opacity))
        }
        applyDeepStructuresMotion()
    }

    private func advanceDeepStructuresFrame(deltaTime: Float) {
        guard deepStructuresRuntimeActive else { return }
        if !deepStructuresRuntimeHeld {
            deepStructuresElapsed += min(max(deltaTime, 0), 0.10)
        }
        applyDeepStructuresMotion()
    }

    private func applyDeepStructuresMotion() {
        for item in deepStructuresGuideStars {
            let pulse = deepStructuresRuntimeHeld
                ? 1
                : 0.86 + sin(deepStructuresElapsed * 1.48 + item.phase) * 0.16
            item.entity.scale = [pulse, pulse, pulse]
        }
        for item in deepStructuresFlowArrows {
            item.entity.isEnabled = deepStructuresRuntimeVisualization == .flow
            guard deepStructuresFlowPaths.indices.contains(item.pathIndex) else { continue }
            let path = deepStructuresFlowPaths[item.pathIndex]
            let speed: Float = item.pathIndex == 0 || item.pathIndex == 9 ? 0.11 : 0.080
            let progress = deepStructuresRuntimeHeld
                ? item.offset
                : (item.offset + deepStructuresElapsed * speed).truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: path, progress: progress)
            let ahead = interpolatedPoint(on: path, progress: min(progress + 0.018, 1))
            let behind = interpolatedPoint(on: path, progress: max(progress - 0.018, 0))
            let tangent = ahead - behind
            item.entity.position = point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: [0, 1, 0],
                    to: simd_normalize(tangent)
                )
            }
            let pulse = deepStructuresRuntimeHeld
                ? 1
                : 0.94 + sin(deepStructuresElapsed * 4.1 + item.offset * 7.4) * 0.08
            item.entity.scale = [pulse, pulse, pulse]
        }
    }

    private func updateOccipitalRegion(
        active: Bool,
        visualization: RBCRegionVisualizationMode,
        motionHeld: Bool
    ) {
        occipitalRuntimeActive = active
        occipitalRuntimeHeld = motionHeld
        occipitalRuntimeVisualization = visualization
        guard active else {
            occipitalElapsed = 0
            return
        }

        let referenceOpacity: Float
        let outlineOpacity: Float
        let foldOpacity: Float
        let calcarineOpacity: Float
        let vesselOpacity: Float
        switch visualization {
        case .locate:
            referenceOpacity = 0.10
            outlineOpacity = 0.62
            foldOpacity = 0.54
            calcarineOpacity = 0.13
            vesselOpacity = 0.025
        case .xray:
            referenceOpacity = 0.035
            outlineOpacity = 0.16
            foldOpacity = 0.68
            calcarineOpacity = 0.92
            vesselOpacity = 0.055
        case .flow:
            referenceOpacity = 0.020
            outlineOpacity = 0.075
            foldOpacity = 0.16
            calcarineOpacity = 0.16
            vesselOpacity = 1.0
        }
        occipitalAuthoredHero?.components.set(OpacityComponent(opacity: referenceOpacity))
        occipitalOutlineRoot?.components.set(OpacityComponent(opacity: outlineOpacity))
        occipitalFoldRoot?.components.set(OpacityComponent(opacity: foldOpacity))
        occipitalCalcarineRoot?.components.set(OpacityComponent(opacity: calcarineOpacity))
        occipitalVesselRoot?.components.set(OpacityComponent(opacity: vesselOpacity))
        for target in occipitalDiscoveryTargets where target.name.hasSuffix("-active") {
            let opacity: Float = switch visualization {
            case .locate: 0.72
            case .xray: 0.40
            case .flow: 0.28
            }
            target.components.set(OpacityComponent(opacity: opacity))
        }
        applyOccipitalMotion()
    }

    private func advanceOccipitalFrame(deltaTime: Float) {
        guard occipitalRuntimeActive else { return }
        if !occipitalRuntimeHeld {
            occipitalElapsed += min(max(deltaTime, 0), 0.10)
        }
        applyOccipitalMotion()
    }

    private func applyOccipitalMotion() {
        for item in occipitalGuideStars {
            let pulse = occipitalRuntimeHeld
                ? 1
                : 0.84 + sin(occipitalElapsed * 1.36 + item.phase) * 0.18
            item.entity.scale = [pulse, pulse, pulse]
        }
        for item in occipitalFlowArrows {
            item.entity.isEnabled = occipitalRuntimeVisualization == .flow
            guard occipitalFlowPaths.indices.contains(item.pathIndex) else { continue }
            let path = occipitalFlowPaths[item.pathIndex]
            let speed: Float = item.pathIndex.isMultiple(of: 8) ? 0.108 : 0.082
            let progress = occipitalRuntimeHeld
                ? item.offset
                : (item.offset + occipitalElapsed * speed).truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: path, progress: progress)
            let ahead = interpolatedPoint(on: path, progress: min(progress + 0.017, 1))
            let behind = interpolatedPoint(on: path, progress: max(progress - 0.017, 0))
            let tangent = ahead - behind
            item.entity.position = point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: [0, 1, 0],
                    to: simd_normalize(tangent)
                )
            }
            let pulse = occipitalRuntimeHeld
                ? 1
                : 0.94 + sin(occipitalElapsed * 4.3 + item.offset * 7.6) * 0.08
            item.entity.scale = [pulse, pulse, pulse]
        }
    }

    private func updateBrainstemRegion(
        active: Bool,
        visualization: RBCRegionVisualizationMode,
        voyagePhase: RBCPosteriorVoyagePhase?,
        motionHeld: Bool
    ) {
        brainstemRuntimeActive = active
        brainstemRuntimeHeld = motionHeld
        brainstemRuntimeVisualization = visualization
        let requestedVoyagePhase = active && visualization == .flow ? voyagePhase : nil
        if brainstemRuntimeVoyagePhase != requestedVoyagePhase {
            configureBrainstemVoyageTransition(
                to: requestedVoyagePhase,
                motionHeld: motionHeld || !active
            )
            brainstemRuntimeVoyagePhase = requestedVoyagePhase
        }
        guard active else {
            brainstemElapsed = 0
            return
        }

        let contextOpacity: Float
        let outlineOpacity: Float
        let pathwayOpacity: Float
        let vesselOpacity: Float
        switch visualization {
        case .locate:
            contextOpacity = 0.11
            outlineOpacity = 0.72
            pathwayOpacity = 0.055
            vesselOpacity = 0.030
        case .xray:
            contextOpacity = 0.035
            outlineOpacity = 0.15
            pathwayOpacity = 0.92
            vesselOpacity = 0.055
        case .flow:
            contextOpacity = 0.025
            outlineOpacity = requestedVoyagePhase == nil ? 0.085 : 0.050
            pathwayOpacity = requestedVoyagePhase == nil ? 0.13 : 0.080
            vesselOpacity = 1.0
        }
        brainstemAuthoredContext?.components.set(OpacityComponent(opacity: contextOpacity))
        brainstemOutlineRoot?.components.set(OpacityComponent(opacity: outlineOpacity))
        brainstemPathwayRoot?.components.set(OpacityComponent(opacity: pathwayOpacity))
        brainstemVesselRoot?.components.set(OpacityComponent(opacity: vesselOpacity))
        for target in brainstemDiscoveryTargets where target.name.hasSuffix("-active") {
            let opacity: Float = switch visualization {
            case .locate: 0.72
            case .xray: 0.40
            case .flow: 0.28
            }
            target.components.set(OpacityComponent(opacity: opacity))
        }
        applyBrainstemMotion()
    }

    private func advanceBrainstemFrame(deltaTime: Float) {
        guard brainstemRuntimeActive else { return }
        if !brainstemRuntimeHeld {
            brainstemElapsed += min(max(deltaTime, 0), 0.10)
            brainstemVoyageTransitionProgress = min(
                1,
                brainstemVoyageTransitionProgress + min(max(deltaTime, 0), 0.10) / 1.10
            )
        }
        applyBrainstemVoyageComposition()
        applyBrainstemMotion()
    }

    private func configureBrainstemVoyageTransition(
        to phase: RBCPosteriorVoyagePhase?,
        motionHeld: Bool
    ) {
        let roots = brainstemVoyageRouteRoots
        brainstemVoyageStartTransforms = roots.map(\.transform)
        brainstemVoyageStartOpacities = brainstemVoyageCurrentOpacities
        let layout = brainstemVoyageLayout(for: phase)
        brainstemVoyageTargetTransforms = layout.transforms
        brainstemVoyageTargetOpacities = layout.opacities
        brainstemVoyageTransitionProgress = motionHeld ? 1 : 0
        applyBrainstemVoyageComposition()
    }

    private func brainstemVoyageLayout(
        for phase: RBCPosteriorVoyagePhase?
    ) -> (transforms: [Transform], opacities: [Float]) {
        func layoutTransform(
            scale: Float = 1,
            yaw: Float = 0,
            translation: SIMD3<Float> = .zero
        ) -> Transform {
            Transform(
                scale: SIMD3<Float>(repeating: scale),
                rotation: simd_quatf(angle: yaw, axis: [0, 1, 0]),
                translation: translation
            )
        }

        switch phase {
        case .convergence:
            return (
                [
                    layoutTransform(scale: 1.18, yaw: -0.06, translation: [0, -0.06, 0.14]),
                    layoutTransform(),
                    layoutTransform(),
                    layoutTransform(),
                ],
                [1.0, 0.06, 0.06, 0.12]
            )
        case .basilarBridge:
            return (
                [
                    layoutTransform(scale: 1.32, yaw: -0.16, translation: [0.04, -0.18, 0.24]),
                    layoutTransform(scale: 0.92),
                    layoutTransform(scale: 0.92),
                    layoutTransform(scale: 1.08, yaw: 0.12, translation: [-0.03, -0.03, 0.08]),
                ],
                [1.0, 0.08, 0.08, 0.44]
            )
        case .destinations:
            return (
                [
                    layoutTransform(scale: 1.02, translation: [0, -0.02, 0.05]),
                    layoutTransform(scale: 1.10, yaw: 0.10, translation: [-0.10, 0.02, 0.12]),
                    layoutTransform(scale: 1.10, yaw: -0.10, translation: [0.10, 0.03, 0.11]),
                    layoutTransform(),
                ],
                [0.38, 1.0, 1.0, 0.10]
            )
        case nil:
            return (
                [layoutTransform(), layoutTransform(), layoutTransform(), layoutTransform()],
                [1.0, 1.0, 1.0, 1.0]
            )
        }
    }

    private func applyBrainstemVoyageComposition() {
        let roots = brainstemVoyageRouteRoots
        guard roots.count == brainstemVoyageStartTransforms.count,
              roots.count == brainstemVoyageTargetTransforms.count,
              roots.count == brainstemVoyageStartOpacities.count,
              roots.count == brainstemVoyageTargetOpacities.count
        else { return }
        let rawProgress = min(max(brainstemVoyageTransitionProgress, 0), 1)
        let progress = rawProgress * rawProgress * (3 - 2 * rawProgress)
        for index in roots.indices {
            let start = brainstemVoyageStartTransforms[index]
            let target = brainstemVoyageTargetTransforms[index]
            roots[index].transform = Transform(
                scale: simd_mix(start.scale, target.scale, SIMD3<Float>(repeating: progress)),
                rotation: simd_slerp(start.rotation, target.rotation, progress),
                translation: simd_mix(start.translation, target.translation, SIMD3<Float>(repeating: progress))
            )
            let opacity = brainstemVoyageStartOpacities[index]
                + (brainstemVoyageTargetOpacities[index] - brainstemVoyageStartOpacities[index]) * progress
            brainstemVoyageCurrentOpacities[index] = opacity
            roots[index].components.set(OpacityComponent(opacity: opacity))
        }
    }

    private func applyBrainstemMotion() {
        for item in brainstemGuideStars {
            let pulse = brainstemRuntimeHeld
                ? 1
                : 0.84 + sin(brainstemElapsed * 1.40 + item.phase) * 0.17
            item.entity.scale = [pulse, pulse, pulse]
        }
        for item in brainstemFlowFronts {
            item.entity.isEnabled = brainstemRuntimeVisualization == .flow
            guard brainstemFlowPaths.indices.contains(item.pathIndex) else { continue }
            let path = brainstemFlowPaths[item.pathIndex]
            let speed: Float = item.pathIndex < 3 ? 0.105 : 0.080
            let progress = brainstemRuntimeHeld
                ? item.offset
                : (item.offset + brainstemElapsed * speed).truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: path, progress: progress)
            let ahead = interpolatedPoint(on: path, progress: min(progress + 0.017, 1))
            let behind = interpolatedPoint(on: path, progress: max(progress - 0.017, 0))
            let tangent = ahead - behind
            item.entity.position = point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: [0, 1, 0],
                    to: simd_normalize(tangent)
                )
            }
            let pulse = brainstemRuntimeHeld
                ? 1
                : 0.94 + sin(brainstemElapsed * 4.25 + item.offset * 7.5) * 0.08
            item.entity.scale = [pulse, pulse, pulse]
        }
    }

    private func updateFrontalRegion(
        active: Bool,
        visualization: RBCRegionVisualizationMode,
        clotScenarioActive: Bool,
        time: Float,
        motionHeld: Bool
    ) {
        frontalClotRoot?.isEnabled = active && visualization == .flow && clotScenarioActive
        guard active else { return }
        let constellationOpacity: Float = switch visualization {
        case .locate: 0.88
        case .xray: 0.30
        case .flow: 0.10
        }
        let vesselOpacity: Float = switch visualization {
        case .locate: 0.055
        case .xray: 0.92
        case .flow: 1.0
        }
        frontalConstellationRoot?.components.set(OpacityComponent(opacity: constellationOpacity))
        frontalVesselRoot?.components.set(OpacityComponent(opacity: vesselOpacity))

        for target in frontalDiscoveryTargets where target.name.hasSuffix("-active") {
            let opacity: Float = switch visualization {
            case .locate: 0.74
            case .xray: 0.48
            case .flow: 0.30
            }
            target.components.set(OpacityComponent(opacity: opacity))
        }
        if let frontalClotRoot, frontalClotRoot.isEnabled {
            let clotPulse: Float = motionHeld ? 1.26 : 1.26 + sin(time * 3.1) * 0.055
            frontalClotRoot.scale = [clotPulse, clotPulse, clotPulse]
        }

        for item in frontalConstellationStars {
            let twinkle = motionHeld ? 1 : 0.82 + 0.22 * sin(time * 1.7 + item.phase)
            item.entity.scale = [twinkle, twinkle, twinkle]
        }
        for item in frontalFlowArrows {
            item.entity.isEnabled = visualization == .flow
            guard item.pathIndex < frontalFlowPaths.count else { continue }
            let path = frontalFlowPaths[item.pathIndex]
            var progress = motionHeld
                ? item.offset
                : (item.offset + time * 0.115).truncatingRemainder(dividingBy: 1)
            if clotScenarioActive && item.pathIndex == 2 {
                // Hold the illustrative glints upstream. This is a qualitative
                // teaching response, not CFD or a patient-specific prediction.
                progress *= 0.57
            }
            let point = interpolatedPoint(on: path, progress: progress)
            let ahead = interpolatedPoint(on: path, progress: min(progress + 0.018, 1))
            item.entity.position = point
            let tangent = ahead - point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: [0, 1, 0],
                    to: simd_normalize(tangent)
                )
            }
            let pulse = motionHeld ? 1 : 0.94 + sin(time * 4.6 + item.offset * 8) * 0.10
            item.entity.scale = [pulse, pulse, pulse]
        }
    }

    private func buildInhabitedArterialCorridor(
        cellPrototype: Entity?,
        authoredWallMaterial: PhysicallyBasedMaterial?
    ) {
        let mainShellPath = sampleCubicBezier(
            [0.00, 1.49, 3.00],
            [0.12, 1.54, 0.20],
            [-0.10, 1.46, -1.80],
            [0.00, 1.58, -2.72],
            samples: 22
        )
        let frontalShellPath = sampleCubicBezier(
            mainShellPath.last ?? [0, 1.58, -2.72],
            [-0.38, 1.66, -3.22],
            [-1.02, 1.80, -4.16],
            [-1.50, 1.96, -5.02],
            samples: 16
        )
        let neighboringShellPath = sampleCubicBezier(
            mainShellPath.last ?? [0, 1.58, -2.72],
            [0.36, 1.53, -3.22],
            [1.00, 1.39, -4.16],
            [1.50, 1.24, -5.02],
            samples: 16
        )

        let intimaMaterial = vesselInteriorMaterial(
            tint: UIColor(red: 0.50, green: 0.030, blue: 0.052, alpha: 1),
            emissive: UIColor(red: 0.28, green: 0.010, blue: 0.024, alpha: 1),
            opacity: 0.50,
            roughness: 0.47
        )
        let mediaMaterial = vesselInteriorMaterial(
            tint: UIColor(red: 0.26, green: 0.018, blue: 0.034, alpha: 1),
            emissive: UIColor(red: 0.16, green: 0.006, blue: 0.018, alpha: 1),
            opacity: 0.25,
            roughness: 0.72
        )

        addInwardFacingTube(
            path: mainShellPath,
            startRadius: 2.62,
            endRadius: 1.30,
            material: intimaMaterial,
            name: "inhabited-main-arterial-intima"
        )
        addInwardFacingTube(
            path: mainShellPath,
            startRadius: 2.78,
            endRadius: 1.44,
            material: mediaMaterial,
            name: "inhabited-main-arterial-media"
        )
        addInwardFacingTube(
            path: frontalShellPath,
            startRadius: 1.31,
            endRadius: 0.88,
            material: intimaMaterial,
            name: "inhabited-frontal-destination-branch"
        )
        addInwardFacingTube(
            path: neighboringShellPath,
            startRadius: 1.31,
            endRadius: 0.88,
            material: intimaMaterial,
            name: "inhabited-neighboring-destination-branch"
        )

        if let authoredWallMaterial {
            let microtextureMaterial = adaptedArterialWallMaterial(authoredWallMaterial)
            addInwardFacingTube(
                path: mainShellPath,
                startRadius: 2.58,
                endRadius: 1.275,
                material: microtextureMaterial,
                name: "provenance-tracked-arterial-wall-pbr-microtexture-main",
                longitudinalRepeatsPerMeter: 1.9,
                circumferentialRepeats: 12
            )
            addInwardFacingTube(
                path: frontalShellPath,
                startRadius: 1.285,
                endRadius: 0.86,
                material: microtextureMaterial,
                name: "provenance-tracked-arterial-wall-pbr-microtexture-frontal",
                longitudinalRepeatsPerMeter: 2.2,
                circumferentialRepeats: 9
            )
            addInwardFacingTube(
                path: neighboringShellPath,
                startRadius: 1.285,
                endRadius: 0.86,
                material: microtextureMaterial,
                name: "provenance-tracked-arterial-wall-pbr-microtexture-neighbor",
                longitudinalRepeatsPerMeter: 2.2,
                circumferentialRepeats: 9
            )
            print("RBC_FLOW_WALL_PBR=READY source=Combined_Artery_Media maps=albedo+normal+roughness uv_seam=true")
        } else {
            print("RBC_FLOW_WALL_PBR=FALLBACK reason=authored_material_unavailable")
        }

        let mainJourneyPath = sampleCubicBezier(
            [0.00, 1.49, -0.72],
            [0.08, 1.52, -1.28],
            [-0.06, 1.52, -2.18],
            [0.00, 1.58, -2.72],
            samples: 20
        )
        let frontalJourneyPath = mainJourneyPath + frontalShellPath.dropFirst()
        let neighboringJourneyPath = mainJourneyPath + neighboringShellPath.dropFirst()

        let mainFlowMaterial = glowMaterial(
            color: UIColor(red: 0.88, green: 0.055, blue: 0.080, alpha: 0.76),
            intensity: 2.35
        )
        let frontalFlowMaterial = glowMaterial(
            color: UIColor(red: 1.00, green: 0.16, blue: 0.21, alpha: 0.90),
            intensity: 3.0
        )
        let neighboringFlowMaterial = glowMaterial(
            color: UIColor(red: 0.18, green: 0.80, blue: 0.72, alpha: 0.72),
            intensity: 2.35
        )
        addRideRoutePath(
            mainJourneyPath,
            route: .overview,
            radius: 0.004,
            material: mainFlowMaterial,
            name: "continuous-main-direction-ribbon"
        )
        addRideRoutePath(
            frontalShellPath,
            route: .frontal,
            radius: 0.005,
            material: frontalFlowMaterial,
            name: "frontal-destination-direction-ribbon"
        )
        addRideRoutePath(
            neighboringShellPath,
            route: .neighboring,
            radius: 0.004,
            material: neighboringFlowMaterial,
            name: "neighboring-destination-direction-ribbon"
        )

        if let cellPrototype {
            for index in 0..<18 {
                let route: RBCFlowRideRoute = index.isMultiple(of: 2) ? .frontal : .neighboring
                let path = route == .frontal ? frontalJourneyPath : neighboringJourneyPath
                let container = Entity()
                container.name = "authored-biconcave-journey-cell-\(index)-route-\(route.rawValue)"
                let visual = cellPrototype.clone(recursive: true)
                visual.isEnabled = true
                normalize(visual, targetExtent: 0.070 + Float(index % 3) * 0.006)
                replaceMaterials(in: visual, with: bloodCellMaterial())
                container.addChild(visual)
                let angle = Float(index) * 2.399_963
                let radialOffset = SIMD2<Float>(cos(angle), sin(angle)) * (0.11 + Float(index % 4) * 0.026)
                flowRideInteriorShellRoot.addChild(container)
                flowRideJourneyCells.append((
                    container,
                    path,
                    container.scale,
                    radialOffset,
                    Float(index) / 18,
                    route
                ))
            }
        }

        let frontalDestination = frontalShellPath.last ?? [-1.50, 1.96, -5.02]
        let neighboringDestination = neighboringShellPath.last ?? [1.50, 1.24, -5.02]
        buildFrontalRouteConstellation(center: frontalDestination)
        buildFrontalMacroToMicroDestination(center: frontalDestination)
        buildDestinationPointField(
            center: neighboringDestination + SIMD3<Float>(0.10, -0.03, -0.30),
            color: UIColor(red: 0.16, green: 0.78, blue: 0.70, alpha: 0.42),
            count: 40,
            name: "neighbor-route-cortical-point-field",
            parent: flowRideNeighborDestinationRoot
        )
    }

    private func addInwardFacingTube(
        path: [SIMD3<Float>],
        startRadius: Float,
        endRadius: Float,
        material: RealityKit.Material,
        name: String,
        longitudinalRepeatsPerMeter: Float = 1,
        circumferentialRepeats: Float = 1
    ) {
        guard let mesh = try? makeInwardFacingTubeMesh(
            path: path,
            startRadius: startRadius,
            endRadius: endRadius,
            radialSegments: 56,
            name: name,
            longitudinalRepeatsPerMeter: longitudinalRepeatsPerMeter,
            circumferentialRepeats: circumferentialRepeats
        ) else { return }
        let tube = ModelEntity(mesh: mesh, materials: [material])
        tube.name = name
        flowRideInteriorShellRoot.addChild(tube)
    }

    private func makeInwardFacingTubeMesh(
        path: [SIMD3<Float>],
        startRadius: Float,
        endRadius: Float,
        radialSegments: Int,
        name: String,
        inwardFacing: Bool = true,
        longitudinalRepeatsPerMeter: Float = 1,
        circumferentialRepeats: Float = 1
    ) throws -> MeshResource {
        guard path.count > 1, radialSegments >= 8 else {
            throw NSError(domain: "RBCJourneyTube", code: 1)
        }

        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var tangents: [SIMD3<Float>] = []
        var bitangents: [SIMD3<Float>] = []
        var textureCoordinates: [SIMD2<Float>] = []
        var indices: [UInt32] = []
        let ringStride = radialSegments + 1
        positions.reserveCapacity(path.count * ringStride)
        normals.reserveCapacity(path.count * ringStride)
        tangents.reserveCapacity(path.count * ringStride)
        bitangents.reserveCapacity(path.count * ringStride)
        textureCoordinates.reserveCapacity(path.count * ringStride)
        indices.reserveCapacity((path.count - 1) * radialSegments * 6)

        var cumulativeDistances = Array(repeating: Float.zero, count: path.count)
        if path.count > 1 {
            for index in 1..<path.count {
                cumulativeDistances[index] = cumulativeDistances[index - 1]
                    + simd_distance(path[index - 1], path[index])
            }
        }

        for ringIndex in path.indices {
            let previous = path[max(0, ringIndex - 1)]
            let next = path[min(path.count - 1, ringIndex + 1)]
            let tangent = simd_normalize(next - previous)
            var right = simd_cross(SIMD3<Float>(0, 1, 0), tangent)
            if simd_length_squared(right) < 0.000_1 {
                right = [1, 0, 0]
            } else {
                right = simd_normalize(right)
            }
            let up = simd_normalize(simd_cross(tangent, right))
            let progress = Float(ringIndex) / Float(path.count - 1)
            let baseRadius = simd_mix(startRadius, endRadius, progress)

            for radialIndex in 0...radialSegments {
                let angle = Float(radialIndex) / Float(radialSegments) * 2 * .pi
                let organicRipple = 1 + sin(angle * 5 + progress * 4.2) * 0.018
                let radialDirection = right * cos(angle) + up * sin(angle)
                let normal = inwardFacing ? -radialDirection : radialDirection
                positions.append(path[ringIndex] + radialDirection * baseRadius * organicRipple)
                normals.append(normal)
                tangents.append(tangent)
                bitangents.append(simd_normalize(simd_cross(normal, tangent)))
                textureCoordinates.append([
                    cumulativeDistances[ringIndex] * longitudinalRepeatsPerMeter,
                    Float(radialIndex) / Float(radialSegments) * circumferentialRepeats
                ])
            }
        }

        for ringIndex in 0..<(path.count - 1) {
            for radialIndex in 0..<radialSegments {
                let a = UInt32(ringIndex * ringStride + radialIndex)
                let b = UInt32(ringIndex * ringStride + radialIndex + 1)
                let c = UInt32((ringIndex + 1) * ringStride + radialIndex)
                let d = UInt32((ringIndex + 1) * ringStride + radialIndex + 1)
                indices.append(contentsOf: [a, b, c, b, d, c])
            }
        }

        var descriptor = MeshDescriptor(name: name)
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.tangents = MeshBuffers.Tangents(tangents)
        descriptor.bitangents = MeshBuffers.Tangents(bitangents)
        descriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        descriptor.primitives = .triangles(indices)
        return try MeshResource.generate(from: [descriptor])
    }

    private func addRideRoutePath(
        _ points: [SIMD3<Float>],
        route: RBCFlowRideRoute,
        radius: Float,
        material: RealityKit.Material,
        name: String
    ) {
        guard points.count > 1 else { return }
        if let routeMesh = try? makeInwardFacingTubeMesh(
            path: points,
            startRadius: radius,
            endRadius: radius,
            radialSegments: 8,
            name: name,
            inwardFacing: false
        ) {
            let routeLine = ModelEntity(mesh: routeMesh, materials: [material])
            routeLine.name = "\(name)-continuous-mesh"
            flowRideForkFieldRoot.addChild(routeLine)
            flowRideForkSegments.append((routeLine, 0.5, route))
        }

        for index in stride(from: 4, to: points.count, by: 5) {
            let tip = points[index]
            let previous = points[index - 1]
            let tangent = simd_normalize(tip - previous)
            var side = simd_cross(tangent, SIMD3<Float>(0, 1, 0))
            side = simd_length_squared(side) < 0.000_1
                ? SIMD3<Float>(1, 0, 0)
                : simd_normalize(side)
            let back = tip - tangent * 0.082

            for sideSign: Float in [-1, 1] {
                let from = back + side * sideSign * 0.034
                let delta = tip - from
                let length = simd_length(delta)
                let arm = ModelEntity(
                    mesh: .generateCylinder(height: length * 1.04, radius: radius * 0.82),
                    materials: [material]
                )
                arm.name = "\(name)-direction-chevron-\(index)-\(sideSign < 0 ? "left" : "right")"
                arm.position = (from + tip) * 0.5
                arm.orientation = simd_quatf(from: [0, 1, 0], to: delta / length)
                flowRideForkFieldRoot.addChild(arm)
                flowRideForkSegments.append((
                    arm,
                    Float(index) / Float(points.count - 1),
                    route
                ))
            }
        }
    }

    private func buildFrontalRouteConstellation(center: SIMD3<Float>) {
        let material = glowMaterial(
            color: UIColor(red: 1.0, green: 0.24, blue: 0.32, alpha: 0.92),
            intensity: 3.2
        )
        var outlinePoints: [SIMD3<Float>] = []
        for index in 0..<28 {
            let angle = Float(index) / 28 * 2 * .pi
            let irregularity = 1 + sin(angle * 3.0) * 0.11 + cos(angle * 5.0) * 0.055
            let point = center + SIMD3<Float>(
                cos(angle) * 0.72 * irregularity,
                sin(angle) * 0.49 * irregularity,
                sin(angle * 2) * 0.055
            )
            outlinePoints.append(point)
            let star = ModelEntity(mesh: .generateSphere(radius: index.isMultiple(of: 4) ? 0.017 : 0.010), materials: [material])
            star.name = "frontal-route-constellation-star-\(index)"
            star.position = point
            flowRideFrontalOutlineRoot.addChild(star)
        }
        if let first = outlinePoints.first { outlinePoints.append(first) }
        addTubePath(
            outlinePoints,
            to: flowRideFrontalOutlineRoot,
            radius: 0.0035,
            material: material,
            name: "frontal-route-constellation-arc"
        )
    }

    /// Expands the selected frontal route into an authored scale transition:
    /// artery -> penetrating arteriole -> interconnected capillary field. This
    /// is a qualitative spatial relationship, not a patient vessel, measured
    /// perfusion, or a literal size comparison.
    private func buildFrontalMacroToMicroDestination(center: SIMD3<Float>) {
        flowRideFrontalDestinationCenter = center + SIMD3<Float>(0, 0.04, -0.55)
        let microvascularRoot = Entity()
        microvascularRoot.name = "frontal-route-arteriole-capillary-transition-not-to-scale"
        flowRideFrontalDestinationRoot.addChild(microvascularRoot)
        microvascularRoot.addChild(flowRideFrontalArterioleRoot)
        microvascularRoot.addChild(flowRideCapillaryWebRoot)

        let focusTarget = Entity()
        focusTarget.name = "frontal-capillary-field-focus-target"
        focusTarget.position = flowRideFrontalDestinationCenter
        focusTarget.components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))
        focusTarget.components.set(CollisionComponent(shapes: [
            .generateBox(size: [1.24, 0.94, 0.26])
        ]))
        focusTarget.components.set(HoverEffectComponent())
        flowRideCapillaryWebRoot.addChild(focusTarget)
        flowRideCapillaryFocusTarget = focusTarget

        if let sheetMesh = try? makeCorticalExchangeSheet(
            center: center + SIMD3<Float>(0, 0.08, -0.58),
            width: 1.42,
            height: 1.02,
            columns: 15,
            rows: 11
        ) {
            let sheetMaterial = tissueContextMaterial(
                color: UIColor(red: 0.23, green: 0.055, blue: 0.078, alpha: 0.26),
                emissive: UIColor(red: 0.25, green: 0.025, blue: 0.055, alpha: 1)
            )
            let sheet = ModelEntity(mesh: sheetMesh, materials: [sheetMaterial])
            sheet.name = "frontal-route-cortical-exchange-surface-not-segmentation"
            flowRideCapillaryWebRoot.addChild(sheet)
        }

        let arterioleMaterial = tissueContextMaterial(
            color: UIColor(red: 0.46, green: 0.014, blue: 0.032, alpha: 0.86),
            emissive: UIColor(red: 0.70, green: 0.025, blue: 0.055, alpha: 1)
        )
        let capillaryMaterial = tissueContextMaterial(
            color: UIColor(red: 0.34, green: 0.018, blue: 0.038, alpha: 0.82),
            emissive: UIColor(red: 0.46, green: 0.010, blue: 0.028, alpha: 1)
        )
        let flowFrontMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.62, blue: 0.28, alpha: 0.94),
            intensity: 4.0
        )
        let exchangeRippleMaterial = glowMaterial(
            color: UIColor(red: 1.0, green: 0.73, blue: 0.38, alpha: 0.36),
            intensity: 1.35
        )

        let penetratingArteriole = sampleCubicBezier(
            center + SIMD3<Float>(0, 0, -0.03),
            center + SIMD3<Float>(0.02, -0.08, -0.17),
            center + SIMD3<Float>(-0.04, -0.25, -0.32),
            center + SIMD3<Float>(0, -0.34, -0.42),
            samples: 22
        )
        addMicrovascularTube(
            penetratingArteriole,
            to: flowRideFrontalArterioleRoot,
            startRadius: 0.030,
            endRadius: 0.014,
            material: arterioleMaterial,
            name: "frontal-route-penetrating-arteriole"
        )

        let nodeCount = 34
        let goldenAngle = Float.pi * (3 - sqrt(5 as Float))
        let nodes: [SIMD3<Float>] = (0..<nodeCount).map { index in
            let fraction = (Float(index) + 0.7) / Float(nodeCount)
            let radius = sqrt(fraction)
            let angle = Float(index) * goldenAngle + sin(Float(index) * 0.73) * 0.11
            return center + SIMD3<Float>(
                cos(angle) * radius * 0.61,
                sin(angle) * radius * 0.45 + 0.05,
                -0.55
                    + sin(angle * 1.7) * 0.17
                    + cos(radius * .pi * 2.2) * 0.080
            )
        }
        let junction = penetratingArteriole.last ?? center
        var edgeIndices: [(Int, Int)] = []
        var edgeKeys: Set<String> = []
        for index in nodes.indices {
            let neighbors = nodes.indices
                .filter { $0 != index }
                .sorted {
                    simd_distance(nodes[index], nodes[$0])
                        < simd_distance(nodes[index], nodes[$1])
                }
            let connectionCount = index.isMultiple(of: 5) ? 4 : 3
            for neighbor in neighbors.prefix(connectionCount) {
                let start = min(index, neighbor)
                let end = max(index, neighbor)
                let key = "\(start)-\(end)"
                if edgeKeys.insert(key).inserted {
                    edgeIndices.append((start, end))
                }
            }
        }
        var microPaths: [[SIMD3<Float>]] = []
        let feederTargets = nodes
            .sorted { $0.y < $1.y }
            .prefix(3)
        for (index, target) in feederTargets.enumerated() {
            let lateral = (Float(index) - 1) * 0.050
            let path = sampleCubicBezier(
                junction,
                junction + SIMD3<Float>(lateral, -0.04, -0.10),
                target + SIMD3<Float>(-lateral * 0.5, -0.04, 0.08),
                target,
                samples: 13
            )
            addMicrovascularTube(
                path,
                to: flowRideFrontalArterioleRoot,
                startRadius: 0.012,
                endRadius: 0.0065,
                material: arterioleMaterial,
                name: "frontal-route-precapillary-feeder-\(index)"
            )
        }

        for (index, edge) in edgeIndices.enumerated() {
            let start = nodes[edge.0]
            let end = nodes[edge.1]
            let delta = end - start
            var side = simd_cross(delta, SIMD3<Float>(0, 0, 1))
            side = simd_length_squared(side) < 0.000_1
                ? SIMD3<Float>(0, 1, 0)
                : simd_normalize(side)
            let bow = (Float(index % 5) - 2) * 0.018
            let lateralWave = sin(Float(index) * 1.618) * 0.042
            let verticalWave = cos(Float(index) * 0.91) * 0.048
            let path = sampleCubicBezier(
                start,
                start + delta * 0.28 + side * (bow + lateralWave)
                    + SIMD3<Float>(0, verticalWave, -0.040),
                start + delta * 0.72 - side * (bow - lateralWave * 0.45)
                    + SIMD3<Float>(0, -verticalWave * 0.72, 0.040),
                end,
                samples: 11
            )
            addMicrovascularTube(
                path,
                to: flowRideCapillaryWebRoot,
                startRadius: 0.0046,
                endRadius: 0.0028,
                material: capillaryMaterial,
                name: "frontal-route-capillary-link-\(index)"
            )
            microPaths.append(path)
        }

        let frontHeadMesh = MeshResource.generateCone(height: 0.020, radius: 0.0082)
        let frontTrailMesh = MeshResource.generateCylinder(height: 0.026, radius: 0.0028)
        for (index, path) in microPaths.enumerated() where index < 24 && index.isMultiple(of: 2) {
            let front = Entity()
            front.name = "frontal-route-capillary-traveling-flow-front-\(index)"
            front.position = path.first ?? center

            let head = ModelEntity(mesh: frontHeadMesh, materials: [flowFrontMaterial])
            head.name = "capillary-flow-front-arrowhead"
            head.position.y = 0.014
            let trail = ModelEntity(mesh: frontTrailMesh, materials: [flowFrontMaterial])
            trail.name = "capillary-flow-front-tail"
            trail.position.y = -0.009
            front.addChild(head)
            front.addChild(trail)
            flowRideCapillaryWebRoot.addChild(front)
            flowRideMicrovascularGlints.append((
                front,
                path,
                Float(index) / Float(max(microPaths.count, 1)),
                0.045 + Float(index % 4) * 0.007
            ))
        }

        for (index, nodeIndex) in [2, 7, 12, 18, 24, 30].enumerated() {
            guard nodes.indices.contains(nodeIndex) else { continue }
            let ripple = Entity()
            ripple.name = "frontal-capillary-exchange-ripple-not-diffusion-measurement-\(index)"
            let origin = nodes[nodeIndex] + SIMD3<Float>(0, 0, 0.018)
            ripple.position = origin

            var ring: [SIMD3<Float>] = []
            for segment in 0...30 {
                let angle = Float(segment) / 30 * 2 * .pi
                ring.append([cos(angle) * 0.026, sin(angle) * 0.026, 0])
            }
            addTubePath(
                ring,
                to: ripple,
                radius: 0.0014,
                material: exchangeRippleMaterial,
                name: "capillary-to-tissue-exchange-wave"
            )
            ripple.components.set(OpacityComponent(opacity: 0))
            flowRideCapillaryWebRoot.addChild(ripple)
            flowRideCapillaryExchangeRipples.append((
                ripple,
                origin,
                Float(index) / 6
            ))
        }

        print("RBC_FRONTAL_MICROVASCULAR_DESTINATION=READY arteriole=1 feeders=3 capillary_nodes=34 organic_links=nearest_neighbor flow_fronts=12 arrow_fronts=12 exchange_ripples=6 not_to_scale=true")
    }

    private func addMicrovascularTube(
        _ path: [SIMD3<Float>],
        to parent: Entity,
        startRadius: Float,
        endRadius: Float,
        material: RealityKit.Material,
        name: String
    ) {
        guard let mesh = try? makeInwardFacingTubeMesh(
            path: path,
            startRadius: startRadius,
            endRadius: endRadius,
            radialSegments: 8,
            name: name,
            inwardFacing: false
        ) else { return }
        let vessel = ModelEntity(mesh: mesh, materials: [material])
        vessel.name = "\(name)-continuous-mesh"
        parent.addChild(vessel)
    }

    private func makeCorticalExchangeSheet(
        center: SIMD3<Float>,
        width: Float,
        height: Float,
        columns: Int,
        rows: Int
    ) throws -> MeshResource {
        guard columns > 1, rows > 1 else {
            throw NSError(domain: "RBCCorticalExchangeSheet", code: 1)
        }
        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var indices: [UInt32] = []
        positions.reserveCapacity(columns * rows)
        normals.reserveCapacity(columns * rows)
        indices.reserveCapacity((columns - 1) * (rows - 1) * 6)

        for row in 0..<rows {
            let v = Float(row) / Float(rows - 1)
            let y = (v - 0.5) * height
            for column in 0..<columns {
                let u = Float(column) / Float(columns - 1)
                let x = (u - 0.5) * width
                let fold = sin(u * .pi * 3.2) * 0.070
                    + cos(v * .pi * 2.4) * 0.045
                    + sin((u + v) * .pi * 2.1) * 0.026
                positions.append(center + SIMD3<Float>(x, y, fold))
                normals.append([0, 0, 1])
            }
        }
        for row in 0..<(rows - 1) {
            for column in 0..<(columns - 1) {
                let a = UInt32(row * columns + column)
                let b = UInt32(row * columns + column + 1)
                let c = UInt32((row + 1) * columns + column)
                let d = UInt32((row + 1) * columns + column + 1)
                indices.append(contentsOf: [a, c, b, b, c, d])
            }
        }
        var descriptor = MeshDescriptor(name: "frontal-route-cortical-exchange-sheet")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.primitives = .triangles(indices)
        return try MeshResource.generate(from: [descriptor])
    }

    private func buildDestinationPointField(
        center: SIMD3<Float>,
        color: UIColor,
        count: Int,
        name: String,
        parent: Entity
    ) {
        guard count > 0 else { return }
        let pointMaterial = glowMaterial(color: color, intensity: 2.25)
        let goldenAngle = Float.pi * (3 - sqrt(5 as Float))

        for index in 0..<count {
            let fraction = (Float(index) + 0.5) / Float(count)
            let y = 1 - 2 * fraction
            let radial = sqrt(max(0, 1 - y * y))
            let angle = Float(index) * goldenAngle
            let depthRipple = 0.70 + Float(index % 7) * 0.055
            let position = center + SIMD3<Float>(
                cos(angle) * radial * 0.88 * depthRipple,
                y * 0.64,
                sin(angle) * radial * 0.50 * depthRipple
            )
            let pointRadius = 0.010 + Float((index * 5) % 7) * 0.0017
            let point = ModelEntity(
                mesh: .generateSphere(radius: pointRadius),
                materials: [pointMaterial]
            )
            point.name = "\(name)-point-\(index)"
            point.position = position
            parent.addChild(point)
        }
    }

    private func buildFlowRideDirectionField(in rideHero: Entity) {
        let laneSpecs: [(
            y: Float,
            z: Float,
            phase: Float,
            color: UIColor
        )] = [
            (-0.007, -0.003, 0.00, UIColor(red: 0.90, green: 0.06, blue: 0.09, alpha: 0.62)),
            ( 0.001,  0.006, 0.37, UIColor(red: 1.00, green: 0.18, blue: 0.17, alpha: 0.58)),
            ( 0.008, -0.005, 0.71, UIColor(red: 0.76, green: 0.018, blue: 0.055, alpha: 0.58))
        ]
        // The authored cutaway mouth is close to the viewer. Start the field
        // deeper inside the branch so no line crosses the near comfort volume.
        let near: Float = -0.038
        let span: Float = 0.112
        let samples = 33

        for (laneIndex, spec) in laneSpecs.enumerated() {
            var path: [SIMD3<Float>] = []
            path.reserveCapacity(samples)
            for sample in 0..<samples {
                let progress = Float(sample) / Float(samples - 1)
                let softBend = sin(progress * .pi * 1.35 + spec.phase * .pi * 2)
                let secondary = sin(progress * .pi * 2.10 + spec.phase * .pi)
                path.append([
                    near + progress * span,
                    spec.y + softBend * 0.0022,
                    spec.z + secondary * 0.0015
                ])
            }
            flowRideRibbonPaths.append(path)

            let material = glowMaterial(color: spec.color, intensity: 2.10)
            for index in 1..<path.count {
                let from = path[index - 1]
                let to = path[index]
                let delta = to - from
                let length = simd_length(delta)
                guard length > 0.000_01 else { continue }
                let segment = ModelEntity(
                    mesh: .generateCylinder(height: length * 1.08, radius: 0.00012),
                    materials: [material]
                )
                segment.name = "continuous-intraluminal-direction-ribbon-with-traveling-luminance-front-lane-\(laneIndex)-segment-\(index)"
                segment.position = (from + to) * 0.5
                segment.orientation = simd_quatf(from: [0, 1, 0], to: delta / length)
                segment.components.set(OpacityComponent(opacity: 0.08))
                flowRideDirectionFieldRoot.addChild(segment)
                flowRideRibbonSegments.append((
                    segment,
                    Float(index) / Float(path.count - 1),
                    Float(laneIndex) / Float(laneSpecs.count)
                ))
            }
        }

        rideHero.addChild(flowRideDirectionFieldRoot)
    }

    private func updateFlowRide(
        active: Bool,
        route: RBCFlowRideRoute,
        capillaryFieldFocused: Bool,
        time _: Float,
        motionHeld: Bool
    ) {
        flowRideRuntimeActive = active
        flowRideRuntimeHeld = motionHeld
        flowRideRuntimeRoute = route
        flowRideRuntimeCapillaryFocus = capillaryFieldFocused && route == .frontal
        flowRideRoot.isEnabled = active
        guard active else {
            flowRideWasActive = false
            flowRideElapsed = 0
            flowRideCapillaryFocusMix = 0
            return
        }

        if !flowRideWasActive {
            flowRideWasActive = true
            flowRideElapsed = 0
        }
        if flowRideRuntimeHeld {
            flowRideCapillaryFocusMix = flowRideRuntimeCapillaryFocus ? 1 : 0
        }
        applyFlowRidePose()
    }

    private func advanceFlowRideFrame(deltaTime: Float) {
        guard flowRideRuntimeActive else { return }
        if !flowRideRuntimeHeld {
            flowRideElapsed += min(max(deltaTime, 0), 0.10)
            let focusTarget: Float = flowRideRuntimeCapillaryFocus ? 1 : 0
            let focusStep = min(max(deltaTime, 0), 0.10) * 0.82
            if flowRideCapillaryFocusMix < focusTarget {
                flowRideCapillaryFocusMix = min(focusTarget, flowRideCapillaryFocusMix + focusStep)
            } else if flowRideCapillaryFocusMix > focusTarget {
                flowRideCapillaryFocusMix = max(focusTarget, flowRideCapillaryFocusMix - focusStep)
            }
        }
        applyFlowRidePose()
    }

    private func applyFlowRidePose() {
        // Authored USDZ positions span approximately -0.08...+0.08 along
        // local X. The room-scale hero rotates that axis forward into -Z.
        // Moving children in local space preserves the textured wall and avoids
        // moving the wearer's camera or entire world.
        let focusMix = flowRideCapillaryFocusMix * flowRideCapillaryFocusMix
            * (3 - 2 * flowRideCapillaryFocusMix)
        let near: Float = -0.038
        let span: Float = 0.112
        for item in flowRideCells {
            let progress = (item.phase + flowRideElapsed * 0.055)
                .truncatingRemainder(dividingBy: 1)
            item.entity.position = SIMD3<Float>(
                near + progress * span,
                item.origin.y,
                item.origin.z
            )
            let tumble = flowRideElapsed * 1.05 + item.phase * .pi * 2
            let drift = sin(flowRideElapsed * 1.8 + item.phase * 8) * 0.0004
            item.entity.position.y += drift
            let tumbleAxis = simd_normalize(SIMD3<Float>(0.16, 0.92, 0.36))
            item.entity.orientation = item.baseOrientation
                * simd_quatf(angle: tumble, axis: tumbleAxis)
            let deformation = sin(tumble * 0.73)
            item.entity.scale = item.baseScale * SIMD3<Float>(
                1 + deformation * 0.08,
                1 - deformation * 0.05,
                1 - deformation * 0.03
            )
            item.entity.components.set(OpacityComponent(opacity: 1 - focusMix * 0.96))
        }

        for item in flowRideRibbonSegments {
            let travel = (flowRideElapsed * 0.18 + item.laneOffset)
                .truncatingRemainder(dividingBy: 1)
            let rawDistance = abs(item.progress - travel)
            let wrappedDistance = min(rawDistance, 1 - rawDistance)
            let wave = max(0, 1 - wrappedDistance / 0.16)
            item.entity.components.set(OpacityComponent(opacity: 0.08 + wave * wave * wave * 0.92))
        }

        for item in flowRideJourneyCells {
            let progress = (item.phase + flowRideElapsed * 0.042)
                .truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: item.path, progress: progress)
            let ahead = interpolatedPoint(on: item.path, progress: min(progress + 0.012, 1))
            let drift = sin(flowRideElapsed * 1.3 + item.phase * 17) * 0.018
            item.entity.position = point + SIMD3<Float>(
                item.radialOffset.x,
                item.radialOffset.y + drift,
                0
            )
            let tangent = ahead - point
            let routeOrientation = simd_length_squared(tangent) > 0.000_001
                ? simd_quatf(from: SIMD3<Float>(0, 0, -1), to: simd_normalize(tangent))
                : simd_quatf(angle: 0, axis: [0, 1, 0])
            let tumble = simd_quatf(
                angle: flowRideElapsed * 1.22 + item.phase * .pi * 2,
                axis: simd_normalize(SIMD3<Float>(0.82, 0.28, 0.50))
            )
            item.entity.orientation = routeOrientation * tumble
            let deformation = sin(flowRideElapsed * 1.7 + item.phase * 11)
            item.entity.scale = item.baseScale * SIMD3<Float>(
                1 + deformation * 0.10,
                1 - deformation * 0.055,
                1 - deformation * 0.045
            )
            let selected = flowRideRuntimeRoute == .overview || flowRideRuntimeRoute == item.route
            item.entity.components.set(OpacityComponent(opacity: selected ? 1 : 0.08))
        }

        for item in flowRideMicrovascularGlints {
            let progress = (item.offset + flowRideElapsed * item.speed)
                .truncatingRemainder(dividingBy: 1)
            let point = interpolatedPoint(on: item.path, progress: progress)
            let ahead = interpolatedPoint(on: item.path, progress: min(progress + 0.025, 1))
            item.entity.position = point
            let tangent = ahead - point
            if simd_length_squared(tangent) > 0.000_001 {
                item.entity.orientation = simd_quatf(
                    from: SIMD3<Float>(0, 1, 0),
                    to: simd_normalize(tangent)
                )
            }
            let pulse = flowRideRuntimeHeld
                ? 0.92
                : 0.88 + sin(flowRideElapsed * 3.1 + item.offset * 9) * 0.12
            item.entity.scale = [pulse, pulse, pulse]
        }

        // A sparse radial response distinguishes molecular exchange from blood
        // travel. The red cell and arrow fronts remain intravascular; these
        // rings are a qualitative tissue-facing cue, not a diffusion or oxygen
        // concentration measurement.
        for item in flowRideCapillaryExchangeRipples {
            let cycle = (item.phase + flowRideElapsed * 0.14)
                .truncatingRemainder(dividingBy: 1)
            let envelope = sin(cycle * .pi)
            let scale = 0.58 + cycle * 1.02
            item.entity.position = item.origin + SIMD3<Float>(0, 0, cycle * 0.072)
            item.entity.scale = [scale, scale, scale]
            item.entity.components.set(OpacityComponent(
                opacity: focusMix * envelope * envelope * 0.46
            ))
        }

        for item in flowRideForkSegments {
            let selectedWeight: Float = switch (flowRideRuntimeRoute, item.route) {
                case (.overview, .overview): 0.92
                case (.overview, _): 0.62
                case let (selected, route) where selected == route: 1.0
                default: 0
            }
            let travel = (flowRideElapsed * 0.20 + (item.route == .neighboring ? 0.46 : 0))
                .truncatingRemainder(dividingBy: 1)
            let rawDistance = abs(item.progress - travel)
            let wrappedDistance = min(rawDistance, 1 - rawDistance)
            let wave = max(0, 1 - wrappedDistance / 0.18)
            item.entity.components.set(OpacityComponent(
                opacity: selectedWeight * (0.18 + wave * wave * 0.38)
            ))
        }

        let frontalOutlineOpacity: Float = switch flowRideRuntimeRoute {
        case .overview: 0.72
        case .frontal: 1.0
        case .neighboring: 0.10
        }
        flowRideFrontalDestinationRoot.components.set(OpacityComponent(opacity: frontalOutlineOpacity))
        let neighborFieldOpacity: Float = switch flowRideRuntimeRoute {
        case .overview: 0.58
        case .frontal: 0.08
        case .neighboring: 1.0
        }
        flowRideNeighborDestinationRoot.components.set(OpacityComponent(opacity: neighborFieldOpacity))
        let destinationPulse: Float = flowRideRuntimeHeld
            ? 1
            : 1 + sin(flowRideElapsed * 1.8) * 0.035
        let capillaryScale = 1 + focusMix * 0.56
        flowRideFrontalDestinationRoot.scale = [
            destinationPulse * capillaryScale,
            destinationPulse * capillaryScale,
            destinationPulse * (1 + focusMix * 0.92)
        ]
        let destinationTilt = simd_slerp(
            simd_quatf(angle: 0, axis: [0, 1, 0]),
            simd_quatf(angle: -0.16, axis: [0, 1, 0])
                * simd_quatf(angle: 0.055, axis: [1, 0, 0]),
            focusMix
        )
        flowRideFrontalDestinationRoot.orientation = destinationTilt
        flowRideFrontalOutlineRoot.components.set(OpacityComponent(opacity: 1 - focusMix))
        flowRideFrontalArterioleRoot.components.set(OpacityComponent(opacity: 1 - focusMix))
        let neighborPulse: Float = flowRideRuntimeHeld
            ? 1
            : 1 + cos(flowRideElapsed * 1.65) * 0.028
        flowRideNeighborDestinationRoot.scale = [neighborPulse, neighborPulse, neighborPulse]

        // Route selection is an explicit user-triggered spatial transfer. The
        // selected branch is recomposed around the stationary wearer instead
        // of forcing a camera ride or silently moving the whole brain scene.
        let routePosition: SIMD3<Float>
        let routeOrientation: simd_quatf
        switch flowRideRuntimeRoute {
        case .overview:
            routePosition = .zero
            routeOrientation = simd_quatf(angle: 0, axis: [0, 1, 0])
        case .frontal:
            routePosition = [-1.09, -0.25, 1.50]
            routeOrientation = simd_quatf(angle: -0.50, axis: [0, 1, 0])
        case .neighboring:
            routePosition = [1.09, 0.08, 1.50]
            routeOrientation = simd_quatf(angle: 0.50, axis: [0, 1, 0])
        }
        let focusedDestinationScale = SIMD3<Float>(
            destinationPulse * capillaryScale,
            destinationPulse * capillaryScale,
            destinationPulse * (1 + focusMix * 0.92)
        )
        let focusedCenter = destinationTilt.act(flowRideFrontalDestinationCenter * focusedDestinationScale)
        let focusWorldTarget = SIMD3<Float>(0.20, 1.40, -2.08)
        let focusedRoutePosition = focusWorldTarget - routeOrientation.act(focusedCenter)
        flowRideRoot.position = routePosition + (focusedRoutePosition - routePosition) * focusMix
        flowRideRoot.orientation = routeOrientation

        flowRideCapillaryFocusTarget?.isEnabled = flowRideRuntimeRoute == .frontal
        flowRideInteriorShellRoot.components.set(OpacityComponent(opacity: 1 - focusMix))
        flowRideForkFieldRoot.components.set(OpacityComponent(opacity: 1 - focusMix * 0.98))
        flowRideDirectionFieldRoot.components.set(OpacityComponent(opacity: 1 - focusMix * 0.98))

        // The local clock stops while held, so the vessel, ribbons, and cells
        // retain their exact pose instead of snapping to a generic still pose.
        let environmentPulse: Float = 1 + sin(flowRideElapsed * 1.2) * 0.006
        flowRideRoot.scale = [environmentPulse, environmentPulse, environmentPulse]
    }

    private func descendants(in root: Entity, namePrefix: String) -> [Entity] {
        var matches: [Entity] = []
        for child in root.children {
            if child.name.hasPrefix(namePrefix) {
                matches.append(child)
            }
            matches.append(contentsOf: descendants(in: child, namePrefix: namePrefix))
        }
        return matches
    }

    private func makeRegionDiscoveryTarget(
        id: Int,
        variant: String,
        position: SIMD3<Float>,
        collisionRadius: Float
    ) -> Entity {
        let target = Entity()
        target.name = "brain-region-discovery-target-\(id)-\(variant)"
        target.position = position

        let beaconMaterial = glowMaterial(
            color: UIColor(red: 0.44, green: 1.0, blue: 0.80, alpha: 0.86),
            intensity: 2.6
        )
        let core = ModelEntity(
            mesh: .generateBox(size: 0.022, cornerRadius: 0.006),
            materials: [beaconMaterial]
        )
        core.name = "region-discovery-constellation-core"
        core.orientation = simd_quatf(angle: .pi / 4, axis: [0, 0, 1])
        target.addChild(core)

        let pointMesh = MeshResource.generateSphere(radius: 0.0062)
        let radius: Float = variant == "active" ? 0.072 : 0.060
        for index in 0..<8 {
            let angle = Float(index) / 8 * .pi * 2
            let point = ModelEntity(mesh: pointMesh, materials: [beaconMaterial])
            point.name = "region-discovery-constellation-point-\(index)"
            point.position = [cos(angle) * radius, sin(angle) * radius, 0]
            target.addChild(point)
        }
        target.components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))
        target.components.set(CollisionComponent(shapes: [.generateSphere(radius: collisionRadius)]))
        target.components.set(HoverEffectComponent())
        return target
    }

    private func addTubePath(
        _ points: [SIMD3<Float>],
        to parent: Entity,
        radius: Float,
        material: RealityKit.Material,
        name: String
    ) {
        guard points.count > 1 else { return }
        for index in 1..<points.count {
            let from = points[index - 1]
            let to = points[index]
            let delta = to - from
            let length = simd_length(delta)
            guard length > 0.0001 else { continue }
            let segment = ModelEntity(
                mesh: .generateCylinder(height: length * 1.04, radius: radius),
                materials: [material]
            )
            segment.name = "\(name)-segment-\(index)"
            segment.position = (from + to) * 0.5
            segment.orientation = simd_quatf(from: [0, 1, 0], to: delta / length)
            parent.addChild(segment)
        }
    }

    private func addContinuousTubePath(
        _ points: [SIMD3<Float>],
        to parent: Entity,
        startRadius: Float,
        endRadius: Float,
        material: RealityKit.Material,
        name: String,
        radialSegments: Int
    ) {
        guard let mesh = try? makeInwardFacingTubeMesh(
            path: points,
            startRadius: startRadius,
            endRadius: endRadius,
            radialSegments: radialSegments,
            name: name,
            inwardFacing: false,
            longitudinalRepeatsPerMeter: 4,
            circumferentialRepeats: 1
        ) else { return }
        let tube = ModelEntity(mesh: mesh, materials: [material])
        tube.name = name
        parent.addChild(tube)
    }

    private func addTaperedTubePath(
        _ points: [SIMD3<Float>],
        to parent: Entity,
        startRadius: Float,
        endRadius: Float,
        material: RealityKit.Material,
        name: String
    ) {
        guard points.count > 1 else { return }
        for index in 1..<points.count {
            let from = points[index - 1]
            let to = points[index]
            let delta = to - from
            let length = simd_length(delta)
            guard length > 0.0001 else { continue }
            let progress = Float(index - 1) / Float(points.count - 1)
            let radius = simd_mix(startRadius, endRadius, progress)
            let segment = ModelEntity(
                mesh: .generateCylinder(height: length * 1.06, radius: radius),
                materials: [material]
            )
            segment.name = "\(name)-segment-\(index)"
            segment.position = (from + to) * 0.5
            segment.orientation = simd_quatf(from: [0, 1, 0], to: delta / length)
            parent.addChild(segment)
        }
    }

    private func sampleClosedCatmullRom(
        _ controls: [SIMD3<Float>],
        samplesPerSegment: Int
    ) -> [SIMD3<Float>] {
        guard controls.count >= 4, samplesPerSegment > 0 else { return controls }
        var result: [SIMD3<Float>] = []
        result.reserveCapacity(controls.count * samplesPerSegment + 1)
        for index in controls.indices {
            let p0 = controls[(index - 1 + controls.count) % controls.count]
            let p1 = controls[index]
            let p2 = controls[(index + 1) % controls.count]
            let p3 = controls[(index + 2) % controls.count]
            for sample in 0..<samplesPerSegment {
                let t = Float(sample) / Float(samplesPerSegment)
                let t2 = t * t
                let t3 = t2 * t
                let positionTerm = p1 * 2
                let tangentTerm = (p2 - p0) * t
                let curvatureVector = p0 * 2 - p1 * 5 + p2 * 4 - p3
                let curvatureTerm = curvatureVector * t2
                let cubicVector = -p0 + p1 * 3 - p2 * 3 + p3
                let cubicTerm = cubicVector * t3
                let sampledPoint = (positionTerm + tangentTerm + curvatureTerm + cubicTerm) * 0.5
                result.append(sampledPoint)
            }
        }
        if let first = result.first { result.append(first) }
        return result
    }

    private func sampleCubicBezier(
        _ start: SIMD3<Float>,
        _ firstControl: SIMD3<Float>,
        _ secondControl: SIMD3<Float>,
        _ end: SIMD3<Float>,
        samples: Int
    ) -> [SIMD3<Float>] {
        guard samples > 1 else { return [start, end] }
        return (0..<samples).map { index in
            let progress = Float(index) / Float(samples - 1)
            let inverse = 1 - progress
            return inverse * inverse * inverse * start
                + 3 * inverse * inverse * progress * firstControl
                + 3 * inverse * progress * progress * secondControl
                + progress * progress * progress * end
        }
    }

    private func installExtendedRegionInterior(
        id: Int,
        source: Entity,
        name: String,
        targetExtent: Float
    ) {
        let region = Entity()
        region.name = "transferred-region-interior-\(id)-\(name)"
        let hero = source.clone(recursive: true)
        hero.name = "transferred-region-hero-\(id)-\(name)"
        normalize(hero, targetExtent: targetExtent)
        hero.position += [0, 1.44, -1.34]
        region.addChild(hero)
        region.isEnabled = false
        regionInteriorRoot.addChild(region)
        regionInteriors[id] = region
        regionBaseScales[id] = region.scale
    }

    private func makePortalEnergyRing(id: Int) -> Entity {
        let energy = Entity()
        energy.name = "portal-energy-ring-\(id)"
        let segmentMesh = MeshResource.generateBox(
            size: [0.022, 0.008, 0.009],
            cornerRadius: 0.004
        )
        let accent: UIColor = switch id {
        case 0: UIColor(red: 1.0, green: 0.42, blue: 0.20, alpha: 0.96)
        case 1: UIColor(red: 1.0, green: 0.20, blue: 0.30, alpha: 0.96)
        default: UIColor(red: 0.18, green: 0.84, blue: 0.78, alpha: 0.96)
        }
        let material = glowMaterial(color: accent, intensity: 1.72)
        let radius: Float = 0.190

        for index in 0..<64 {
            let angle = Float(index) / 64 * 2 * .pi
            let segment = ModelEntity(mesh: segmentMesh, materials: [material])
            segment.name = "portal-energy-segment-\(id)-\(index)"
            segment.position = [cos(angle) * radius, sin(angle) * radius, 0]
            segment.orientation = simd_quatf(angle: angle + .pi / 2, axis: [0, 0, 1])
            let stagger: Float = index.isMultiple(of: 3) ? 1.18 : 1
            segment.scale = [stagger, 1, 1]
            energy.addChild(segment)
        }
        return energy
    }

    private func geometryDerivedPortalAnchor(
        sourceEntityName: String,
        fallback: SIMD3<Float>
    ) -> (interactionPoint: SIMD3<Float>, sourcePoint: SIMD3<Float>, usedFallback: Bool) {
        guard let source = corticalVaultRoot.findEntity(named: sourceEntityName) else {
            return (fallback, fallback, true)
        }

        let sourcePoint = source.visualBounds(relativeTo: portalRoot).center
        let wearerReference = SIMD3<Float>(0, 1.42, 0)
        var direction = sourcePoint - wearerReference
        direction.y *= 0.72
        let magnitude = simd_length(direction)
        guard magnitude > 0.05 else {
            return (fallback, sourcePoint, true)
        }

        var interactionPoint = wearerReference + (direction / magnitude) * 1.26
        interactionPoint.y = min(max(interactionPoint.y, 0.88), 1.82)
        return (interactionPoint, sourcePoint, false)
    }

    private func makeAnchorGuide(
        id: Int,
        from interactionPoint: SIMD3<Float>,
        to sourcePoint: SIMD3<Float>,
        sourceEntityName: String,
        usedFallback: Bool
    ) -> Entity {
        let guide = Entity()
        let status = usedFallback ? "fallback-pending-specialist-review" : "geometry-derived-pending-specialist-review"
        guide.name = "portal-anchor-guide-\(id)-\(status)-\(sourceEntityName)"
        guide.components.set(OpacityComponent(opacity: 0))
        guide.isEnabled = false

        let vector = sourcePoint - interactionPoint
        guard simd_length(vector) > 0.08 else { return guide }
        let material = glowMaterial(
            color: UIColor(red: 0.52, green: 0.92, blue: 0.82, alpha: 0.44),
            intensity: 0.76
        )
        let beadMesh = MeshResource.generateSphere(radius: 0.006)

        for index in 0..<12 {
            let progress = 0.10 + Float(index) / 11 * 0.78
            let bead = ModelEntity(mesh: beadMesh, materials: [material])
            bead.name = "anchor-tether-bead-\(id)-\(index)"
            bead.position = interactionPoint + vector * progress
            guide.addChild(bead)
        }
        return guide
    }

    private func buildLightingRig() {
        let key = Entity()
        key.name = "warm-anatomy-key-light"
        key.components.set(DirectionalLightComponent(
            color: UIColor(red: 1.0, green: 0.78, blue: 0.70, alpha: 1),
            intensity: 1_750
        ))
        key.orientation = simd_quatf(angle: -0.42, axis: [1, 0, 0])
            * simd_quatf(angle: 0.58, axis: [0, 1, 0])
        worldRoot.addChild(key)

        let fill = Entity()
        fill.name = "cool-vascular-fill-light"
        fill.components.set(DirectionalLightComponent(
            color: UIColor(red: 0.48, green: 0.66, blue: 1.0, alpha: 1),
            intensity: 780
        ))
        fill.orientation = simd_quatf(angle: 0.30, axis: [1, 0, 0])
            * simd_quatf(angle: -0.80, axis: [0, 1, 0])
        worldRoot.addChild(fill)
    }

    private func buildObservationField() {
        let segmentMesh = MeshResource.generateBox(
            size: [0.045, 0.004, 0.009],
            cornerRadius: 0.003
        )
        let material = glowMaterial(
            color: UIColor(red: 0.36, green: 0.78, blue: 0.73, alpha: 0.24),
            intensity: 0.36
        )
        let center = SIMD3<Float>(0.03, 0.79, -1.20)
        let radius: Float = 0.78

        for index in 0..<48 {
            let angle = Float(index) / 48 * 2 * .pi
            let segment = ModelEntity(mesh: segmentMesh, materials: [material])
            segment.name = "stable-observation-field-segment-\(index)"
            segment.position = center + [cos(angle) * radius, 0, sin(angle) * radius]
            segment.orientation = simd_quatf(angle: -angle, axis: [0, 1, 0])
            observationRoot.addChild(segment)
        }
    }

    private func setAnimationsPaused(_ shouldPause: Bool) {
        guard animationsPaused != shouldPause else { return }
        animationsPaused = shouldPause
        for controller in flowAnimationControllers {
            if shouldPause {
                controller.pause()
            } else {
                controller.resume()
            }
        }
    }

    private func playAllAnimations(in entity: Entity) {
        for animation in entity.availableAnimations {
            let controller = entity.playAnimation(
                animation.repeat(),
                transitionDuration: 0.18,
                startsPaused: false
            )
            flowAnimationControllers.append(controller)
        }
        for child in entity.children {
            playAllAnimations(in: child)
        }
    }

    private func loadBundledUSDZ(named name: String) async -> Entity? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "usdz") else { return nil }
        return try? await Entity(contentsOf: url)
    }

    private func normalize(_ entity: Entity, targetExtent: Float) {
        let bounds = entity.visualBounds(relativeTo: entity)
        let extent = max(bounds.extents.x, max(bounds.extents.y, bounds.extents.z))
        guard extent > 0.000_1 else { return }
        let factor = targetExtent / extent
        entity.scale = [factor, factor, factor]
        entity.position = -bounds.center * factor
    }

    private func normalize(_ entity: Entity, around reference: Entity, targetExtent: Float) {
        let bounds = reference.visualBounds(relativeTo: entity)
        let extent = max(bounds.extents.x, max(bounds.extents.y, bounds.extents.z))
        guard extent > 0.000_1 else { return }
        let factor = targetExtent / extent
        entity.scale = [factor, factor, factor]
        entity.position = -bounds.center * factor
    }

    private func applyMaterialRecursively(_ material: RealityKit.Material, to entity: Entity) {
        if var model = entity.components[ModelComponent.self] {
            model.materials = [material]
            entity.components.set(model)
        }
        for child in entity.children {
            applyMaterialRecursively(material, to: child)
        }
    }

    private func addBlockageBeacon(to clotAsset: Entity) {
        guard let clot = clotAsset.findEntity(named: "Right_M1_Large_Vessel_Occlusion") else { return }
        let halo = ModelEntity(
            mesh: .generateSphere(radius: 0.0075),
            materials: [
                glowMaterial(
                    color: UIColor(red: 1.0, green: 0.31, blue: 0.04, alpha: 0.42),
                    intensity: 3.0
                )
            ]
        )
        halo.name = "example-right-m1-blockage-halo"
        clot.addChild(halo)
        blockageBeacon = halo
    }

    private func glowMaterial(color: UIColor, intensity: Float) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: color)
        material.blending = .transparent(opacity: .init(floatLiteral: Float(color.cgColor.alpha)))
        material.emissiveColor = .init(color: color.withAlphaComponent(1))
        material.emissiveIntensity = intensity
        material.roughness = 0.38
        return material
    }

    private func bloodCellMaterial() -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.54, green: 0.012, blue: 0.025, alpha: 1))
        material.emissiveColor = .init(color: UIColor(red: 0.22, green: 0.002, blue: 0.006, alpha: 1))
        material.emissiveIntensity = 0.14
        material.roughness = 0.22
        material.metallic = .init(floatLiteral: 0)
        return material
    }

    private func vesselInteriorMaterial(
        tint: UIColor,
        emissive: UIColor,
        opacity: Float,
        roughness: Float
    ) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: tint)
        material.emissiveColor = .init(color: emissive)
        material.emissiveIntensity = 0.30
        material.roughness = .init(floatLiteral: roughness)
        material.metallic = .init(floatLiteral: 0)
        material.blending = .transparent(opacity: .init(floatLiteral: opacity))
        material.faceCulling = .none
        material.readsDepth = true
        material.writesDepth = false
        return material
    }

    private func firstPhysicallyBasedMaterial(
        in entity: Entity,
        namePrefix: String
    ) -> PhysicallyBasedMaterial? {
        for candidate in descendants(in: entity, namePrefix: namePrefix) {
            guard let model = candidate.components[ModelComponent.self] else { continue }
            for material in model.materials {
                if let pbr = material as? PhysicallyBasedMaterial,
                   pbr.baseColor.texture != nil,
                   pbr.normal.texture != nil,
                   pbr.roughness.texture != nil {
                    return pbr
                }
            }
        }
        return nil
    }

    private func adaptedArterialWallMaterial(
        _ source: PhysicallyBasedMaterial
    ) -> PhysicallyBasedMaterial {
        var material = source
        material.faceCulling = .none
        material.blending = .transparent(opacity: .init(floatLiteral: 0.30))
        material.readsDepth = true
        material.writesDepth = false
        return material
    }

    private func replaceMaterials(in entity: Entity, with material: RealityKit.Material) {
        if var model = entity.components[ModelComponent.self] {
            model.materials = Array(repeating: material, count: max(model.materials.count, 1))
            entity.components.set(model)
        }
        for child in entity.children {
            replaceMaterials(in: child, with: material)
        }
    }

    private func corticalVaultMaterial() -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        let color = UIColor(red: 0.20, green: 0.055, blue: 0.075, alpha: 1)
        material.baseColor = .init(tint: color)
        material.emissiveColor = .init(color: UIColor(red: 0.18, green: 0.035, blue: 0.055, alpha: 1))
        material.emissiveIntensity = 0.20
        material.roughness = 0.62
        material.metallic = .init(floatLiteral: 0)
        material.blending = .transparent(opacity: .init(floatLiteral: 0.16))
        material.faceCulling = .none
        material.readsDepth = true
        material.writesDepth = false
        return material
    }

    private func tissueContextMaterial(color: UIColor, emissive: UIColor) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: color)
        material.emissiveColor = .init(color: emissive)
        material.emissiveIntensity = 0.30
        material.roughness = 0.58
        material.metallic = .init(floatLiteral: 0)
        material.blending = .transparent(opacity: .init(floatLiteral: Float(color.cgColor.alpha)))
        material.faceCulling = .none
        material.readsDepth = true
        material.writesDepth = false
        return material
    }
}
