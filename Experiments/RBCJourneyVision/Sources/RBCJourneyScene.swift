import Combine
import RealityKit
import SwiftUI
import UIKit

@MainActor
final class RBCJourneyScene {
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
    private let flowRideRoot = Entity()
    private let flowRideDirectionFieldRoot = Entity()
    private let flowRideInteriorShellRoot = Entity()
    private let flowRideForkFieldRoot = Entity()
    private let flowRideFrontalDestinationRoot = Entity()
    private let flowRideNeighborDestinationRoot = Entity()

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
    private var flowRideRuntimeRoute: RBCFlowRideRoute = .overview
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
        flowRideRoot.name = "inside-arterial-lumen-flow-ride"
        flowRideDirectionFieldRoot.name = "continuous-intraluminal-direction-field-not-cfd"
        flowRideInteriorShellRoot.name = "native-inward-facing-arterial-corridor"
        flowRideForkFieldRoot.name = "user-selected-branching-flow-field-not-cfd"
        flowRideFrontalDestinationRoot.name = "frontal-route-constellation-outline-not-segmentation"
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
        worldRoot.addChild(portalRoot)
        worldRoot.addChild(regionGuideRoot)
        corticalVaultRoot.addChild(registeredContent)

        buildLightingRig()
        buildObservationField()
        buildIdentityEchoField()
        await buildRegisteredAnatomy()
        await buildPortals()
        buildExtendedRegionInteriors()
        buildFrontalRegionInterior()
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
        regionVisualization: RBCRegionVisualizationMode,
        frontalClotScenarioActive: Bool,
        flowRideActive: Bool,
        flowRideRoute: RBCFlowRideRoute,
        time: TimeInterval,
        paused: Bool,
        reducedMotion: Bool,
        soundEnabled: Bool,
        showTeachingPoints: Bool
    ) {
        let motionHeld = paused || reducedMotion
        setAnimationsPaused(motionHeld)

        let t = Float(time)
        let preludeActive = preludeChapter != nil
        let transferActive = transferredPortalID != nil && !preludeActive
        let frontalRegionActive = transferredPortalID == RBCBrainRegionDestination.frontalLobe.id
        let lumenRideActive = flowRideActive
            && transferredPortalID == RBCBrainRegionDestination.arterialLumen.id
            && !preludeActive
        portalRoot.isEnabled = !transferActive && !preludeActive
        regionInteriorRoot.isEnabled = transferActive
        regionGuideRoot.isEnabled = showTeachingPoints && !transferActive && !preludeActive && focusedPortalID == nil
        observationRoot.isEnabled = !preludeActive

        updatePreludeComposition(
            chapter: preludeChapter,
            reducedMotion: reducedMotion
        )

        let identityOpacity: Float = if preludeActive {
            0.035
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
            let active = transferredPortalID == id && !(lumenRideActive && id == RBCBrainRegionDestination.arterialLumen.id)
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
        updateFlowRide(
            active: lumenRideActive,
            route: flowRideRoute,
            time: t,
            motionHeld: motionHeld
        )
        if let infoAttachment {
            let target: SIMD3<Float> = lumenRideActive
                ? [0, 1.72, -0.70]
                : [0, 2.08, -1.04]
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
        flowController?.gain = soundEnabled ? exhibitGain : -96
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

            if definition.id == 1, let arteryLayer {
                let arterialContext = arteryLayer.clone(recursive: true)
                arterialContext.name = "circle-transfer-high-resolution-cerebral-tree-context"
                normalize(arterialContext, targetExtent: 2.72)
                arterialContext.position += [0, 1.43, -1.48]
                arterialContext.components.set(OpacityComponent(opacity: 0.42))
                region.addChild(arterialContext)
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
                buildInhabitedArterialCorridor(cellPrototype: authoredCellPrototype)
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
            installExtendedRegionInterior(
                id: RBCBrainRegionDestination.cerebellum.id,
                source: cerebellum,
                name: "cerebellum-region-portal",
                targetExtent: 2.02
            )
        }

        if let deepLayer {
            installExtendedRegionInterior(
                id: RBCBrainRegionDestination.deepStructures.id,
                source: deepLayer,
                name: "deep-structures-region-portal",
                targetExtent: 1.90
            )
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

    private func buildInhabitedArterialCorridor(cellPrototype: Entity?) {
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
        buildDestinationPointField(
            center: frontalDestination + SIMD3<Float>(-0.10, 0.04, -0.30),
            color: UIColor(red: 1.0, green: 0.19, blue: 0.28, alpha: 0.48),
            count: 48,
            name: "frontal-route-cortical-point-field",
            parent: flowRideFrontalDestinationRoot
        )
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
        name: String
    ) {
        guard let mesh = try? makeInwardFacingTubeMesh(
            path: path,
            startRadius: startRadius,
            endRadius: endRadius,
            radialSegments: 56,
            name: name
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
        inwardFacing: Bool = true
    ) throws -> MeshResource {
        guard path.count > 1, radialSegments >= 8 else {
            throw NSError(domain: "RBCJourneyTube", code: 1)
        }

        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var indices: [UInt32] = []
        positions.reserveCapacity(path.count * radialSegments)
        normals.reserveCapacity(path.count * radialSegments)
        indices.reserveCapacity((path.count - 1) * radialSegments * 6)

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

            for radialIndex in 0..<radialSegments {
                let angle = Float(radialIndex) / Float(radialSegments) * 2 * .pi
                let organicRipple = 1 + sin(angle * 5 + progress * 4.2) * 0.018
                let radialDirection = right * cos(angle) + up * sin(angle)
                positions.append(path[ringIndex] + radialDirection * baseRadius * organicRipple)
                normals.append(inwardFacing ? -radialDirection : radialDirection)
            }
        }

        for ringIndex in 0..<(path.count - 1) {
            for radialIndex in 0..<radialSegments {
                let nextRadial = (radialIndex + 1) % radialSegments
                let a = UInt32(ringIndex * radialSegments + radialIndex)
                let b = UInt32(ringIndex * radialSegments + nextRadial)
                let c = UInt32((ringIndex + 1) * radialSegments + radialIndex)
                let d = UInt32((ringIndex + 1) * radialSegments + nextRadial)
                indices.append(contentsOf: [a, b, c, b, d, c])
            }
        }

        var descriptor = MeshDescriptor(name: name)
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
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
            flowRideFrontalDestinationRoot.addChild(star)
        }
        if let first = outlinePoints.first { outlinePoints.append(first) }
        addTubePath(
            outlinePoints,
            to: flowRideFrontalDestinationRoot,
            radius: 0.0035,
            material: material,
            name: "frontal-route-constellation-arc"
        )
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
        time _: Float,
        motionHeld: Bool
    ) {
        flowRideRuntimeActive = active
        flowRideRuntimeHeld = motionHeld
        flowRideRuntimeRoute = route
        flowRideRoot.isEnabled = active
        guard active else {
            flowRideWasActive = false
            flowRideElapsed = 0
            return
        }

        if !flowRideWasActive {
            flowRideWasActive = true
            flowRideElapsed = 0
        }
        applyFlowRidePose()
    }

    private func advanceFlowRideFrame(deltaTime: Float) {
        guard flowRideRuntimeActive else { return }
        if !flowRideRuntimeHeld {
            flowRideElapsed += min(max(deltaTime, 0), 0.10)
        }
        applyFlowRidePose()
    }

    private func applyFlowRidePose() {
        // Authored USDZ positions span approximately -0.08...+0.08 along
        // local X. The room-scale hero rotates that axis forward into -Z.
        // Moving children in local space preserves the textured wall and avoids
        // moving the wearer's camera or entire world.
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
        flowRideFrontalDestinationRoot.scale = [destinationPulse, destinationPulse, destinationPulse]
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
        flowRideRoot.position = routePosition
        flowRideRoot.orientation = routeOrientation

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
