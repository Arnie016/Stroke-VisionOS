import Foundation
import RealityKit
import SwiftUI

/// Marks the sparse lesson cues as their own gaze-and-pinch target family.
/// A filtered gesture can therefore ignore the much larger anatomy collision
/// proxy that otherwise wins the indirect hit test in front of these points.
struct StrokeLessonPointTargetComponent: Component {}

/// Procedural, deliberately schematic geometry. No patient scan, no licensed
/// anatomical specimen, and no claim of clinical accuracy.
///
/// Main-actor isolated: RealityKit mesh and shape generation traps when called
/// from a background executor.
@MainActor
enum StrokeSceneFactory {
    static func registerCustomComponents() {
        StrokeLessonPointTargetComponent.registerComponent()
    }

    static let rootName = "stroke-time-root"
    private static let importedRootName = "imported-stroke-anatomy"
    private static let proceduralRootName = "procedural-stroke-fallback"
    private static let importedBrainName = "brain_anatomy_realistic_v2"
    private static let importedSkullName = "skull_semantic_realistic_v2"
    private static let importedArteriesName = "cerebral_arteries_realistic_v2"
    private static let importedClotName = "ischemic_mca_clot_v2"
    private static let importedDuraName = "dura_mater_cutaway_conceptual_v2"
    private static let importedEdemaName = "edema_swelling"
    private static let importedFlapName = "craniotomy_bone_flap"
    private static let importedPatchName = "dural_patch"
    static let importedBrainTargetName = "imported-brain-surface-target"
    static let importedClotTargetName = "imported-clot-focus-target"
    static let spatialCaseRoomName = "spatial-case-intake-room"
    static let spatialCaseArchiveName = "spatial-case-archive"
    static let spatialCaseConstellationName = "spatial-case-constellation"
    static let spatialCaseFileName = "spatial-case-file-78"
    static let spatialCaseDockName = "spatial-case-dock"
    static let spatialCaseFigureName = "spatial-case-review-figure"
    static let clinicianHeldToolRootName = "clinician-held-tool-root"

    private static let coreName = "infarct-core"
    private static let penumbraName = "penumbra-shell"
    private static let brainName = "brain-volume"
    private static let leftBrainName = "brain-left"
    private static let rightBrainName = "brain-right"
    private static let clotName = "vessel-blockage"
    private static let ringName = "time-ring"
    private static let perfusionName = "perfusion-flow"
    private static let flowArrowName = "calm-flow-direction-arrows"
    private static let registeredFlowArrowName = "registered-calm-flow-direction-arrows"
    private static let inspectionRingName = "occlusion-focus-ring"
    private static let medicinePreviewName = "medicine-review-preview"
    private static let catheterPreviewName = "catheter-review-preview"
    private static let skullName = "fixed-skull-context"
    private static let fixedBoundaryRingName = "fixed-space-boundary-ring"
    private static let boneFlapName = "bone-flap"
    private static let duraExpansionName = "dura-expansion"
    private static let layerRevealSeamName = "calm-layer-reveal-seam"
    private static let regionPointFieldName = "clinician-region-point-field"
    private static let procedurePointFieldName = "clinician-procedure-point-field"
    private static let regionPointAnchorName = "registered-region-point-anchor"
    private static let cortexLayerName = "anatomy-cortex-layer"
    private static let fixedSpaceLayerName = "anatomy-fixed-space-layer"
    private static let arteriesLayerName = "anatomy-arteries-layer"
    private static let blockageLayerName = "anatomy-blockage-layer"
    private static let duraLayerName = "anatomy-dura-layer"

    private enum HemisphereSide: Float {
        case left = -1
        case right = 1
    }

    /// Shared centreline. The vessel tube, the clot, and the perfusion droplets
    /// all read from this so flow visibly stops at the blockage rather than
    /// merely near it.
    static let vesselPath: [SIMD3<Float>] = [
        [-0.02, -0.09, 0.045],
        [-0.01, -0.045, 0.05],
        [0.005, -0.005, 0.05],
        [0.03, 0.03, 0.042],
        [0.055, 0.055, 0.028]
    ]

    /// Normalised arc position of the blockage along `vesselPath`.
    private static let clotArc: Float = 0.72

    private static let dropletCount = 64

    private static let regionPointDirections: [SIMD3<Float>] = [
        [-0.66, 0.56, 0.62], [-0.43, 0.20, 0.82],
        [-0.56, -0.43, 0.60], [0.69, 0.56, 0.54]
    ]

    private static let regionPointLabels = [
        "Example affected area", "Nearby brain tissue",
        "Brain surface", "Opposite-side context"
    ]

    /// Exact registered-v2 arterial-mesh surface samples for technical marker
    /// placement only. They are not specialist-approved anatomical landmarks;
    /// reviewed FLOW_ANCHOR exports and clinical review remain required. Index
    /// 2 is only a procedural-fallback position: registered anatomy replaces it
    /// with a marker derived from the loaded clot bounds below.
    private static let procedurePointPositions: [SIMD3<Float>] = [
        [-0.028297, -0.142271, 0.010944],
        [-0.012158, -0.059836, 0.030163],
        [0.050, 0.052, 0.039],
        [-0.043842, -0.014646, 0.029223],
        [-0.053607, -0.011508, 0.017754]
    ]

    private static let procedurePointLabels = [
        "Blood supply approaches", "Arteries branch", "Example blockage",
        "Flow beyond the blockage changes", "Affected territory"
    ]

    static func makeScene(compact: Bool = false) async -> Entity {
        let root = Entity()
        root.name = rootName

        let fallback = Entity()
        fallback.name = proceduralRootName
        fallback.addChild(makeBrainVolume())
        fallback.addChild(makeSkullContext())
        fallback.addChild(makeVesselTree())
        fallback.addChild(makePenumbra())
        fallback.addChild(makeCore())
        fallback.addChild(makeClot())
        fallback.addChild(makePerfusion(count: compact ? 24 : dropletCount))
        fallback.addChild(makeFlowArrows())
        fallback.addChild(makeCarePreview(compact: compact))
        root.addChild(fallback)

        if !compact, let imported = await makeImportedAnatomy() {
            root.addChild(imported)
        } else if !compact {
            // Fallback points share the procedural teaching frame.
            fallback.addChild(makePointField(
                name: regionPointFieldName,
                points: regionPointDirections.map { simd_normalize($0) * SIMD3<Float>(0.071, 0.100, 0.117) },
                labels: regionPointLabels,
                material: careMaterial(opacity: 0.92)
            ))
            fallback.addChild(makePointField(
                name: procedurePointFieldName,
                points: procedurePointPositions,
                labels: procedurePointLabels,
                material: warningMaterial(opacity: 0.92)
            ))
        }

        return root
    }

    /// A clinician-only presentation kit. The imported open-cranial tools are
    /// explicitly generic, low-detail concepts pending specialist review; the
    /// focus, lens, and layer tools are presentation controls rather than
    /// surgical instruments. No selection mutates anatomy or simulates a cut.
    static func makeClinicianHeldTools() async -> Entity {
        let root = Entity()
        root.name = clinicianHeldToolRootName

        let focus = ModelEntity(
            mesh: .generateBox(size: [0.006, 0.006, 0.14], cornerRadius: 0.003),
            materials: [careMaterial(opacity: 0.95)]
        )
        focus.name = "clinician-tool-focus"
        focus.position = [0, 0.035, 0.06]
        root.addChild(focus)

        let lens = ModelEntity(
            mesh: .generateSphere(radius: 0.040),
            materials: [contextMaterial(opacity: 0.23)]
        )
        lens.name = "clinician-tool-transparency"
        lens.scale = [1, 0.08, 1]
        lens.position = [0, 0.035, 0.055]
        root.addChild(lens)

        let layers = Entity()
        layers.name = "clinician-tool-layer-reveal"
        for index in 0..<3 {
            let card = ModelEntity(
                mesh: .generateBox(size: [0.070, 0.004, 0.090], cornerRadius: 0.004),
                materials: [index == 1 ? careMaterial(opacity: 0.82) : contextMaterial(opacity: 0.48)]
            )
            card.position = [Float(index - 1) * 0.014, 0.025 + Float(index) * 0.010, 0.055]
            layers.addChild(card)
        }
        root.addChild(layers)

        if let forceps = await loadBundledUSDZ(named: "suction_and_forceps") {
            root.addChild(normalizedHeldTool(forceps, name: "clinician-tool-forceps", targetSize: 0.16))
        }
        if let drill = await loadBundledUSDZ(named: "cranial_drill_generic") {
            root.addChild(normalizedHeldTool(drill, name: "clinician-tool-drill", targetSize: 0.15))
        }

        updateClinicianHeldTools(root, selected: .focus, enabled: false)
        return root
    }

    static func updateClinicianHeldTools(
        _ root: Entity,
        selected: StrokeClinicianTool,
        enabled: Bool
    ) {
        let selectedName: String
        switch selected {
        case .focus: selectedName = "clinician-tool-focus"
        case .transparency: selectedName = "clinician-tool-transparency"
        case .layerReveal: selectedName = "clinician-tool-layer-reveal"
        case .forceps: selectedName = "clinician-tool-forceps"
        case .cranialDrill: selectedName = "clinician-tool-drill"
        }
        for child in root.children {
            child.isEnabled = enabled && child.name == selectedName
        }
    }

    private static func normalizedHeldTool(
        _ entity: Entity,
        name: String,
        targetSize: Float
    ) -> Entity {
        let wrapper = Entity()
        wrapper.name = name
        let bounds = entity.visualBounds(relativeTo: entity)
        let size = bounds.max - bounds.min
        let largest = max(size.x, max(size.y, size.z))
        if largest > 0.0001 {
            entity.position = -((bounds.min + bounds.max) / 2)
            let scale = targetSize / largest
            entity.scale = [scale, scale, scale]
        }
        wrapper.position = [0, 0.04, 0.065]
        wrapper.addChild(entity)
        return wrapper
    }

    /// A room-scale intake object: the file starts in a physical cabinet at
    /// the wearer's left and must be carried to the central dock. This is the
    /// product's spatial threshold, not a floating notes window.
    static func makeSpatialCaseIntake() -> Entity {
        let room = Entity()
        room.name = spatialCaseRoomName

        let rail = SimpleMaterial(
            color: UIColor(red: 0.26, green: 0.24, blue: 0.22, alpha: 0.88),
            roughness: 0.54,
            isMetallic: true
        )
        let paper = SimpleMaterial(
            color: UIColor(red: 0.90, green: 0.74, blue: 0.42, alpha: 1),
            roughness: 0.72,
            isMetallic: false
        )
        let filament = SimpleMaterial(
            color: UIColor(red: 0.72, green: 0.39, blue: 0.19, alpha: 0.46),
            roughness: 0.66,
            isMetallic: true
        )

        let archive = Entity()
        archive.name = spatialCaseArchiveName
        archive.position = [-0.62, 1.43, -0.92]
        archive.orientation = simd_quatf(angle: 0.16, axis: [0, 1, 0])
        room.addChild(archive)

        let cabinet = Entity()
        cabinet.name = "case-cabinet"
        let bay = ModelEntity(
            mesh: .generateBox(size: [0.40, 0.30, 0.026], cornerRadius: 0.024),
            materials: [rail]
        )
        bay.name = "archive-dossier-bay"
        cabinet.addChild(bay)

        let cradle = ModelEntity(
            mesh: .generateBox(size: [0.42, 0.020, 0.078], cornerRadius: 0.010),
            materials: [rail]
        )
        cradle.name = "archive-dossier-cradle"
        cradle.position = [0, -0.16, 0.030]
        cabinet.addChild(cradle)

        let dossierColors: [UIColor] = [
            UIColor(red: 0.20, green: 0.17, blue: 0.15, alpha: 1),
            UIColor(red: 0.30, green: 0.22, blue: 0.17, alpha: 1),
            UIColor(red: 0.23, green: 0.24, blue: 0.20, alpha: 1),
            UIColor(red: 0.39, green: 0.28, blue: 0.19, alpha: 1),
            UIColor(red: 0.25, green: 0.20, blue: 0.18, alpha: 1)
        ]
        let dossierPositions: [SIMD3<Float>] = [
            [-0.055, -0.022, 0.030], [-0.034, -0.014, 0.043],
            [-0.012, -0.006, 0.056], [0.012, 0.002, 0.069],
            [0.036, 0.010, 0.082]
        ]
        for index in dossierPositions.indices {
            let material = SimpleMaterial(
                color: dossierColors[index],
                roughness: 0.80,
                isMetallic: false
            )
            let dossier = ModelEntity(
                mesh: .generateBox(size: [0.23, 0.17, 0.012], cornerRadius: 0.014),
                materials: [material]
            )
            dossier.name = "archived-case-\(index + 1)"
            dossier.position = dossierPositions[index]
            dossier.orientation = simd_quatf(
                angle: -0.10 + Float(index) * 0.050,
                axis: [0, 0, 1]
            )
            cabinet.addChild(dossier)
        }
        archive.addChild(cabinet)

        // The selected case unfolds around one central human-scale anchor.
        // This root starts hidden so the archive remains the only visible
        // intake affordance until FILE 78 has been deliberately placed.
        let constellation = Entity()
        constellation.name = spatialCaseConstellationName
        constellation.position = [0, 1.60, -0.82]
        constellation.isEnabled = false
        room.addChild(constellation)

        // A deliberately generic 3D case figure: it gives the selected file a
        // human-scale anchor without claiming a MetaHuman, patient likeness, or
        // scan-derived avatar. It is shown only during case review.
        let figure = Entity()
        figure.name = spatialCaseFigureName
        figure.position = [0, -0.02, -0.06]

        let head = ModelEntity(
            mesh: .generateSphere(radius: 0.085),
            materials: [contextMaterial(opacity: 0.72)]
        )
        head.name = "generic-case-head"
        head.scale = [0.78, 1, 0.82]
        figure.addChild(head)

        let neck = ModelEntity(
            mesh: .generateCylinder(height: 0.075, radius: 0.030),
            materials: [contextMaterial(opacity: 0.58)]
        )
        neck.position = [0, -0.105, 0]
        figure.addChild(neck)

        let shoulders = ModelEntity(
            mesh: .generateSphere(radius: 0.115),
            materials: [careMaterial(opacity: 0.36)]
        )
        shoulders.position = [0, -0.205, 0]
        shoulders.scale = [1.35, 0.58, 0.58]
        figure.addChild(shoulders)

        let status = ModelEntity(
            mesh: .generateCylinder(height: 0.012, radius: 0.135),
            materials: [warningMaterial(opacity: 0.34)]
        )
        status.position = [0, -0.29, 0]
        figure.addChild(status)
        constellation.addChild(figure)

        let caseFilaments: [(String, [SIMD3<Float>])] = [
            (
                "case-constellation-filament-speech",
                [[-0.02, 0.04, 0.015], [-0.15, 0.14, 0.025], [-0.34, 0.25, 0.040]]
            ),
            (
                "case-constellation-filament-arm",
                [[-0.03, -0.03, 0.015], [-0.17, -0.07, 0.025], [-0.36, -0.13, 0.040]]
            ),
            (
                "case-constellation-filament-time",
                [[0.03, -0.03, 0.015], [0.17, -0.07, 0.025], [0.36, -0.13, 0.040]]
            ),
            (
                "case-constellation-filament-open-question",
                [[0.02, 0.04, 0.015], [0.15, 0.14, 0.025], [0.34, 0.25, 0.040]]
            )
        ]
        for (name, path) in caseFilaments {
            addTubePath(path, radius: 0.00135, material: filament, to: constellation, prefix: name)
        }

        let file = ModelEntity(
            mesh: .generateBox(size: [0.19, 0.25, 0.018], cornerRadius: 0.014),
            materials: [paper]
        )
        file.name = spatialCaseFileName
        file.position = [-0.58, 1.45, -0.82]
        file.orientation = simd_quatf(angle: -0.16, axis: [0, 1, 0])
        file.components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))
        file.components.set(CollisionComponent(shapes: [.generateBox(size: [0.21, 0.27, 0.045])]))
        file.components.set(HoverEffectComponent())
        room.addChild(file)

        let dock = ModelEntity(
            mesh: .generateCylinder(height: 0.014, radius: 0.19),
            materials: [careMaterial(opacity: 0.26)]
        )
        dock.name = spatialCaseDockName
        dock.position = [0, 1.28, -0.82]
        room.addChild(dock)

        let dockCore = ModelEntity(
            mesh: .generateCylinder(height: 0.017, radius: 0.08),
            materials: [careMaterial(opacity: 0.52)]
        )
        dockCore.name = "case-dock-core"
        dockCore.position = [0, 0.002, 0]
        dock.addChild(dockCore)

        return room
    }

    static func isSpatialCaseFileTarget(_ entity: Entity) -> Bool {
        var candidate: Entity? = entity
        while let current = candidate {
            if current.name == spatialCaseFileName { return true }
            candidate = current.parent
        }
        return false
    }

    /// Loads the exact USDZ shortlist from Stroke-VisionOS PR #2. The v2
    /// anatomy remains in its authored registered frame. Three prototype-v1
    /// pressure-purpose cues stay under a distinct legacy root with one manual
    /// fit transform, matching the source catalog's registration contract.
    private static func makeImportedAnatomy() async -> Entity? {
        let imported = Entity()
        imported.name = importedRootName

        let registered = Entity()
        registered.name = "registered-v2-head-root"
        // The package transforms remain untouched. This parent only stages the
        // complete registered set for a patient-friendly three-quarter view.
        registered.position = [0, 0.018, 0]
        registered.scale = [0.88, 0.88, 0.88]
        registered.orientation = simd_quatf(angle: -0.42, axis: [0, 1, 0])
        imported.addChild(registered)

        let legacy = Entity()
        legacy.name = "legacy-v1-pressure-root"
        legacy.scale = [0.66, 0.66, 0.66]
        // Prototype-v1 assets use a different staging frame. They remain
        // bundled for technical-art registration, but are never shown in the
        // patient path until that fit has been reviewed.
        legacy.isEnabled = false
        imported.addChild(legacy)

        for name in [
            importedBrainName,
            importedSkullName,
            importedArteriesName,
            importedClotName,
            importedDuraName
        ] {
            if let entity = await loadBundledUSDZ(named: name) {
                entity.name = name
                let layer = Entity()
                layer.name = semanticLayerName(for: name)
                // Install HierarchicalFade before the imported hierarchy is
                // attached. Runtime updates then mutate it only when teaching
                // state actually changes instead of replacing the same
                // component on every display frame.
                layer.components.set(OpacityComponent(
                    opacity: initialSemanticLayerOpacity(for: name)
                ))
                layer.addChild(entity)
                registered.addChild(layer)
            }
        }

        for name in [importedEdemaName, importedFlapName, importedPatchName] {
            if let entity = await loadBundledUSDZ(named: name) {
                entity.name = name
                legacy.addChild(entity)
            }
        }

        guard let importedBrain = registered.findEntity(named: importedBrainName) else {
            return nil
        }

        // Derive the region landmarks from the loaded cortex bounds and add
        // them inside the exact registered-v2 parent. Each normalized direction
        // lands on the teaching ellipsoid around the actual brain bounds, so a
        // point cannot drift into unrelated world space when staging changes.
        let brainBounds = importedBrain.visualBounds(relativeTo: registered)
        let brainCenter = (brainBounds.min + brainBounds.max) / 2
        // Keep the landmarks just inside the translucent cortical envelope.
        // This makes them read as region anchors instead of a decorative halo,
        // while preserving visibility through the teaching material.
        let brainRadii = (brainBounds.max - brainBounds.min) / 2 * 0.98
        let registeredRegionPoints = regionPointDirections.map { direction in
            brainCenter + brainRadii * simd_normalize(direction)
        }
        let cortexLayer = registered.findEntity(named: cortexLayerName) ?? registered
        let arteriesLayer = registered.findEntity(named: arteriesLayerName) ?? registered
        let blockageLayer = registered.findEntity(named: blockageLayerName) ?? registered

        // Point 2 is derived from the actual registered clot bounds. Points
        // 0/1/3/4 use exact registered-v2 arterial-mesh surface samples. These
        // are technical anchors, not specialist-approved anatomy; reviewed
        // FLOW_ANCHOR exports and clinical review remain required.
        let arteryBounds = registered.findEntity(named: importedArteriesName)?.visualBounds(relativeTo: registered)
            ?? brainBounds
        let arteryCenter = (arteryBounds.min + arteryBounds.max) / 2
        let clotBounds = registered.findEntity(named: importedClotName)?.visualBounds(relativeTo: registered)
        let clotCenter = clotBounds.map { ($0.min + $0.max) / 2 } ?? arteryCenter
        let clotSurfaceMarker = clotBounds.map { bounds in
            let center = (bounds.min + bounds.max) / 2
            return SIMD3<Float>(center.x, center.y, bounds.max.z + 0.003)
        } ?? clotCenter
        let registeredFlowPoints = procedurePointPositions.enumerated().map { index, position in
            // Keep the blockage marker 3 mm beyond the loaded clot surface so
            // it remains visibly attached instead of being hidden inside it.
            index == 2 ? clotSurfaceMarker : position
        }

        let regionPointAnchor = Entity()
        regionPointAnchor.name = regionPointAnchorName
        registered.addChild(regionPointAnchor)
        regionPointAnchor.addChild(makePointField(
            name: regionPointFieldName,
            points: registeredRegionPoints,
            labels: regionPointLabels,
            material: careMaterial(opacity: 0.92)
        ))
        arteriesLayer.addChild(makePointField(
            name: procedurePointFieldName,
            points: registeredFlowPoints,
            labels: procedurePointLabels,
            material: warningMaterial(opacity: 0.92)
        ))
        arteriesLayer.addChild(makeRegisteredFlowArrows(points: registeredFlowPoints))

        // Stable semantic gaze/hand targets without generating collisions from
        // the 236k-triangle cortex. The ellipsoidal brain proxy follows the
        // head more closely than the old box, so a confirmed question retains
        // useful surface depth without putting invisible dense-mesh collision
        // work on the device.
        let brainTarget = Entity()
        brainTarget.name = importedBrainTargetName
        brainTarget.scale = [0.82, 1.0, 0.92]
        brainTarget.components.set(InputTargetComponent())
        brainTarget.components.set(CollisionComponent(shapes: [
            .generateSphere(radius: 0.112)
        ]))
        brainTarget.components.set(HoverEffectComponent())
        cortexLayer.addChild(brainTarget)

        let clotTarget = Entity()
        clotTarget.name = importedClotTargetName
        clotTarget.position = [0.036, 0.026, 0.072]
        clotTarget.components.set(InputTargetComponent())
        clotTarget.components.set(CollisionComponent(shapes: [
            .generateSphere(radius: 0.015)
        ]))
        clotTarget.components.set(HoverEffectComponent())
        blockageLayer.addChild(clotTarget)

        return imported
    }

    private static func semanticLayerName(for assetName: String) -> String {
        switch assetName {
        case importedBrainName:
            cortexLayerName
        case importedSkullName:
            fixedSpaceLayerName
        case importedArteriesName:
            arteriesLayerName
        case importedClotName:
            blockageLayerName
        case importedDuraName:
            duraLayerName
        default:
            "anatomy-context-layer"
        }
    }

    private static func initialSemanticLayerOpacity(for assetName: String) -> Float {
        switch assetName {
        case importedArteriesName:
            0.90
        case importedDuraName:
            0.14
        default:
            1
        }
    }

    /// `OpacityComponent` owns RealityKit's HierarchicalFade network state.
    /// Replacing an unchanged component at display rate needlessly dirties the
    /// complete imported hierarchy and produces NetworkComponent diagnostics.
    /// A slider or presentation change still applies on the next scene update;
    /// stable frames perform no hierarchy component write.
    private static func setSemanticLayerOpacity(
        _ targetOpacity: Float,
        on entity: Entity?
    ) {
        guard let entity else { return }
        if let currentOpacity = entity.components[OpacityComponent.self]?.opacity,
           abs(currentOpacity - targetOpacity) <= 0.000_001 {
            return
        }
        entity.components.set(OpacityComponent(opacity: targetOpacity))
    }

    private static func setEnabledIfChanged(_ enabled: Bool, on entity: Entity?) {
        guard let entity, entity.isEnabled != enabled else { return }
        entity.isEnabled = enabled
    }

    private static func loadBundledUSDZ(named name: String) async -> Entity? {
        let url = Bundle.main.url(forResource: name, withExtension: "usdz", subdirectory: "StrokeAssets")
            ?? Bundle.main.url(forResource: name, withExtension: "usdz")
        guard let url else { return nil }
        return try? await Entity(contentsOf: url)
    }

    /// A deliberately non-graphic pressure frame. The translucent shell makes
    /// the fixed-volume problem visible; the disc is a schematic bone flap,
    /// not an incision guide or surgical simulation.
    private static func makeSkullContext() -> Entity {
        let group = Entity()
        group.name = skullName

        let shell = ModelEntity(
            mesh: .generateSphere(radius: 0.128),
            materials: [skullMaterial(opacity: 0.09)]
        )
        shell.name = "skull-shell"
        shell.scale = [0.78, 0.90, 1.0]
        group.addChild(shell)

        // A sparse boundary reads clearly in mixed reality without placing a
        // dark transparent bubble over the high-detail cortex.
        let boundary = Entity()
        boundary.name = fixedBoundaryRingName
        let boundaryMesh = MeshResource.generateBox(size: [0.020, 0.0025, 0.003], cornerRadius: 0.0012)
        for index in 0..<22 {
            let angle = Float(index) / 22 * 2 * .pi
            let tick = ModelEntity(
                mesh: boundaryMesh,
                materials: [skullMaterial(opacity: 0.34)]
            )
            tick.position = [cos(angle) * 0.117, sin(angle) * 0.137, 0.082]
            tick.orientation = simd_quatf(angle: angle + .pi / 2, axis: [0, 0, 1])
            boundary.addChild(tick)
        }
        boundary.isEnabled = false
        group.addChild(boundary)

        let flap = ModelEntity(
            mesh: .generateCylinder(height: 0.0035, radius: 0.050),
            materials: [skullMaterial(opacity: 0.62)]
        )
        flap.name = boneFlapName
        flap.position = [0.096, 0.025, 0]
        flap.orientation = simd_quatf(angle: .pi / 2, axis: [0, 0, 1])
        flap.isEnabled = false
        group.addChild(flap)

        let dura = ModelEntity(
            mesh: .generateSphere(radius: 0.060),
            materials: [careMaterial(opacity: 0.20)]
        )
        dura.name = duraExpansionName
        dura.position = [0.075, 0.025, 0]
        dura.scale = [0.55, 1.0, 0.88]
        dura.isEnabled = false
        group.addChild(dura)

        // A quiet fallback seam helps low-detail procedural anatomy disclose
        // its layers. Imported anatomy uses transparency instead.
        let revealSeam = Entity()
        revealSeam.name = layerRevealSeamName
        let seamMesh = MeshResource.generateBox(size: [0.010, 0.0024, 0.0032], cornerRadius: 0.0012)
        for index in 0..<18 {
            let progress = Float(index) / 17
            let angle = -Float.pi * 0.58 + progress * Float.pi * 1.16
            let stitch = ModelEntity(mesh: seamMesh, materials: [careMaterial(opacity: 0.22)])
            stitch.name = "reveal-stitch-\(index)"
            stitch.position = [0.078 + cos(angle) * 0.040, 0.024 + sin(angle) * 0.058, 0.086]
            stitch.orientation = simd_quatf(angle: angle + .pi / 2, axis: [0, 0, 1])
            revealSeam.addChild(stitch)
        }
        revealSeam.isEnabled = false
        group.addChild(revealSeam)

        return group
    }

    // MARK: - Path sampling

    /// Arc-length parameterised sample so droplets travel at even speed instead
    /// of sprinting through short segments.
    private static func samplePath(_ t: Float) -> SIMD3<Float> {
        let clamped = min(max(t, 0), 1)
        var lengths: [Float] = []
        var total: Float = 0
        for index in 0..<(vesselPath.count - 1) {
            let d = simd_distance(vesselPath[index], vesselPath[index + 1])
            lengths.append(d)
            total += d
        }
        guard total > 0 else { return vesselPath[0] }

        var travelled = clamped * total
        for index in 0..<lengths.count {
            if travelled <= lengths[index] {
                let f = lengths[index] > 0 ? travelled / lengths[index] : 0
                return simd_mix(vesselPath[index], vesselPath[index + 1], SIMD3(repeating: f))
            }
            travelled -= lengths[index]
        }
        return vesselPath[vesselPath.count - 1]
    }

    // MARK: - Construction

    private static func makeBrainVolume() -> Entity {
        let brain = Entity()
        brain.name = brainName

        let left = makeHemisphere(side: .left, name: leftBrainName)
        let right = makeHemisphere(side: .right, name: rightBrainName)

        for hemisphere in [left, right] {
            hemisphere.components.set(InputTargetComponent())
            // Input uses a cheap proxy. The folded render mesh is never asked
            // to be a collider, keeping gaze/hand targeting stable on device.
            hemisphere.components.set(CollisionComponent(shapes: [
                .generateBox(size: [0.075, 0.185, 0.205])
            ]))
            hemisphere.components.set(HoverEffectComponent())
            brain.addChild(hemisphere)
        }

        let seam = ModelEntity(
            mesh: .generateBox(size: [0.004, 0.17, 0.19], cornerRadius: 0.002),
            materials: [contextMaterial(opacity: 0.18)]
        )
        seam.name = "brain-midline-seam"
        brain.addChild(seam)
        return brain
    }

    /// A deterministic, locally generated cortical shell. It is more
    /// recognisably brain-shaped than two scaled spheres while remaining an
    /// authored teaching model rather than imported patient anatomy.
    private static func makeHemisphere(side: HemisphereSide, name: String) -> ModelEntity {
        let mesh = (try? makeCorticalMesh(side: side)) ?? .generateSphere(radius: 0.10)
        let hemisphere = ModelEntity(mesh: mesh, materials: [brainMaterial(opacity: 0.72)])
        hemisphere.name = name
        hemisphere.position = [side.rawValue * 0.041, 0, 0]

        let furrows = makeCorticalFurrows(side: side)
        furrows.name = "\(name)-furrows"
        hemisphere.addChild(furrows)
        return hemisphere
    }

    private static func makeCorticalMesh(side: HemisphereSide) throws -> MeshResource {
        let latitudeSegments = 36
        let longitudeSegments = 56
        let radii = SIMD3<Float>(0.070, 0.100, 0.116)

        var positions: [SIMD3<Float>] = [[0, radii.y, 0]]

        for latitude in 1..<latitudeSegments {
            let theta = Float(latitude) / Float(latitudeSegments) * .pi
            let sinTheta = sin(theta)
            let cosTheta = cos(theta)

            for longitude in 0..<longitudeSegments {
                let phi = Float(longitude) / Float(longitudeSegments) * 2 * .pi
                let phase = side.rawValue * 0.38

                // Two low-amplitude harmonic bands suggest gyri without
                // pretending to reproduce an individual's cortical anatomy.
                let foldA = sin(phi * 9 + theta * 5 + phase) * 0.030
                let foldB = sin(phi * 5 - theta * 8 - phase) * 0.020
                let polarFade = pow(sinTheta, 0.72)
                let radial = 1 + (foldA + foldB) * polarFade

                positions.append([
                    radii.x * radial * sinTheta * cos(phi),
                    radii.y * radial * cosTheta,
                    radii.z * radial * sinTheta * sin(phi)
                ])
            }
        }

        let bottomIndex = UInt32(positions.count)
        positions.append([0, -radii.y, 0])

        var indices: [UInt32] = []
        indices.reserveCapacity(latitudeSegments * longitudeSegments * 6)

        // Top cap.
        for longitude in 0..<longitudeSegments {
            let current = UInt32(1 + longitude)
            let next = UInt32(1 + (longitude + 1) % longitudeSegments)
            indices.append(contentsOf: [0, next, current])
        }

        // Folded shell.
        for latitude in 0..<(latitudeSegments - 2) {
            let row = 1 + latitude * longitudeSegments
            let nextRow = row + longitudeSegments
            for longitude in 0..<longitudeSegments {
                let nextLongitude = (longitude + 1) % longitudeSegments
                let a = UInt32(row + longitude)
                let b = UInt32(row + nextLongitude)
                let c = UInt32(nextRow + nextLongitude)
                let d = UInt32(nextRow + longitude)
                indices.append(contentsOf: [a, b, c, a, c, d])
            }
        }

        // Bottom cap.
        let finalRow = 1 + (latitudeSegments - 2) * longitudeSegments
        for longitude in 0..<longitudeSegments {
            let current = UInt32(finalRow + longitude)
            let next = UInt32(finalRow + (longitude + 1) % longitudeSegments)
            indices.append(contentsOf: [bottomIndex, current, next])
        }

        let normals = vertexNormals(positions: positions, indices: indices)
        var descriptor = MeshDescriptor(name: "procedural-cortical-hemisphere")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.primitives = .triangles(indices)
        return try MeshResource.generate(from: [descriptor])
    }

    private static func vertexNormals(
        positions: [SIMD3<Float>],
        indices: [UInt32]
    ) -> [SIMD3<Float>] {
        var normals = Array(repeating: SIMD3<Float>.zero, count: positions.count)
        for triangle in stride(from: 0, to: indices.count, by: 3) {
            let ia = Int(indices[triangle])
            let ib = Int(indices[triangle + 1])
            let ic = Int(indices[triangle + 2])
            let face = simd_cross(positions[ib] - positions[ia], positions[ic] - positions[ia])
            normals[ia] += face
            normals[ib] += face
            normals[ic] += face
        }
        return normals.enumerated().map { index, normal in
            let length = simd_length(normal)
            guard length > 0.000_001 else { return simd_normalize(positions[index]) }
            return normal / length
        }
    }

    /// Thin surface-following curves make the cortical folds readable at the
    /// app's seated viewing distance. They are visual landmarks only.
    private static func makeCorticalFurrows(side: HemisphereSide) -> Entity {
        let furrows = Entity()
        let material = furrowMaterial(opacity: 0.46)

        for band in 0..<7 {
            let baseTheta = 0.42 + Float(band) * 0.34
            var path: [SIMD3<Float>] = []
            for sample in 0...14 {
                let t = Float(sample) / 14 * 2 - 1
                let theta = baseTheta + sin(t * 5.4 + Float(band)) * 0.055
                let phi = .pi / 2 + t * 1.04 + sin(t * 3.1) * 0.055
                path.append(corticalSurfacePoint(theta: theta, phi: phi, outward: 1.012))
            }
            addTubePath(path, radius: 0.00125, material: material, to: furrows, prefix: "sulcus-h-\(band)")
        }

        for band in 0..<4 {
            var path: [SIMD3<Float>] = []
            for sample in 0...12 {
                let t = Float(sample) / 12
                let theta = 0.50 + t * 2.05
                let phi = .pi / 2 + (Float(band) - 1.5) * 0.42 + sin(t * 8 + Float(band)) * 0.07
                path.append(corticalSurfacePoint(theta: theta, phi: phi, outward: 1.014))
            }
            addTubePath(path, radius: 0.0011, material: material, to: furrows, prefix: "sulcus-v-\(band)")
        }

        return furrows
    }

    private static func corticalSurfacePoint(
        theta: Float,
        phi: Float,
        outward: Float
    ) -> SIMD3<Float> {
        let sinTheta = sin(theta)
        return [
            0.070 * outward * sinTheta * cos(phi),
            0.100 * outward * cos(theta),
            0.116 * outward * sinTheta * sin(phi)
        ]
    }

    private static func addTubePath(
        _ path: [SIMD3<Float>],
        radius: Float,
        material: RealityKit.Material,
        to parent: Entity,
        prefix: String
    ) {
        guard path.count > 1 else { return }
        for index in 0..<(path.count - 1) {
            let start = path[index]
            let end = path[index + 1]
            let segment = ModelEntity(
                mesh: .generateCylinder(height: simd_distance(start, end), radius: radius),
                materials: [material]
            )
            segment.name = "\(prefix)-\(index)"
            segment.position = (start + end) / 2
            segment.orientation = orientation(from: start, to: end)
            parent.addChild(segment)
        }
    }

    /// Two deliberately conceptual previews. The medicine halo and catheter
    /// path explain what question is being discussed; neither simulates a dose,
    /// procedure, access route, result, or recommendation.
    private static func makeCarePreview(compact: Bool) -> Entity {
        let group = Entity()
        group.name = "care-discussion-previews"

        let halo = ModelEntity(
            mesh: .generateSphere(radius: 0.020),
            materials: [careMaterial(opacity: 0.24)]
        )
        halo.name = medicinePreviewName
        halo.position = [0.03, 0.03, 0.042]
        halo.isEnabled = false
        group.addChild(halo)

        let catheter = Entity()
        catheter.name = catheterPreviewName
        let path: [SIMD3<Float>] = compact
            ? [
                [-0.075, -0.070, 0.070],
                [-0.035, -0.025, 0.058],
                [0.022, 0.022, 0.045]
            ]
            : [
                [-0.16, -0.16, 0.09],
                [-0.10, -0.10, 0.075],
                [-0.04, -0.035, 0.058],
                [0.022, 0.022, 0.045]
            ]
        for index in 0..<(path.count - 1) {
            let start = path[index]
            let end = path[index + 1]
            let segment = ModelEntity(
                mesh: .generateCylinder(height: simd_distance(start, end), radius: 0.0022),
                materials: [careMaterial(opacity: 0.82)]
            )
            segment.position = (start + end) / 2
            segment.orientation = orientation(from: start, to: end)
            catheter.addChild(segment)
        }
        catheter.isEnabled = false
        group.addChild(catheter)

        let ring = ModelEntity(
            mesh: .generateCylinder(height: 0.002, radius: 0.018),
            materials: [warningMaterial(opacity: 0.65)]
        )
        ring.name = inspectionRingName
        ring.position = [0.03, 0.03, 0.042]
        ring.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        group.addChild(ring)
        return group
    }

    /// One simplified supply branch. Segment count is kept low so the blocked
    /// segment stays legible at conversational distance.
    private static func makeVesselTree() -> Entity {
        let tree = Entity()
        tree.name = "vessel-tree"

        let path = vesselPath

        for index in 0..<(path.count - 1) {
            let start = path[index]
            let end = path[index + 1]
            let segment = ModelEntity(
                mesh: .generateCylinder(height: simd_distance(start, end), radius: 0.0070),
                materials: [flowMaterial(opacity: 0.9)]
            )
            segment.name = "vessel-segment-\(index)"
            segment.position = (start + end) / 2
            segment.orientation = orientation(from: start, to: end)
            tree.addChild(segment)
        }

        let branchMaterial = flowMaterial(opacity: 0.62)
        let branches: [[SIMD3<Float>]] = [
            [[0.005, -0.005, 0.05], [-0.030, 0.030, 0.060], [-0.058, 0.054, 0.050]],
            [[0.030, 0.030, 0.042], [0.046, 0.068, 0.010], [0.040, 0.090, -0.024]],
            [[0.030, 0.030, 0.042], [0.066, 0.042, 0.006], [0.086, 0.050, -0.022]]
        ]
        for (branchIndex, branch) in branches.enumerated() {
            addTubePath(
                branch,
                radius: branchIndex == 0 ? 0.0044 : 0.0037,
                material: branchMaterial,
                to: tree,
                prefix: "vessel-branch-\(branchIndex)"
            )
        }

        return tree
    }

    /// Perfusion read as liquid rather than as a red tube. Droplets march the
    /// centreline; past the blockage they thin out as the delay grows, so the
    /// scene shows supply stopping instead of asserting it in a caption.
    private static func makePerfusion(count: Int) -> Entity {
        let flow = Entity()
        flow.name = perfusionName

        // One mesh and one material instance shared across droplets — rebuilding
        // either per frame is what makes RealityKit scenes stutter.
        let mesh = MeshResource.generateSphere(radius: 0.0032)
        for index in 0..<count {
            let droplet = ModelEntity(mesh: mesh, materials: [flowMaterial(opacity: 0.95)])
            droplet.name = "droplet-\(index)"
            flow.addChild(droplet)
        }

        return flow
    }

    /// Sparse chevrons answer "which way is blood moving?" without turning the
    /// vessel into an alarm graphic. They appear only inside the blood-flow
    /// lesson and share the exact centreline used by droplets and blockage.
    private static func makeFlowArrows() -> Entity {
        let arrows = Entity()
        arrows.name = flowArrowName
        let shaftMesh = MeshResource.generateBox(size: [0.0018, 0.0018, 0.011], cornerRadius: 0.0008)
        let wingMesh = MeshResource.generateBox(size: [0.0018, 0.0018, 0.006], cornerRadius: 0.0008)

        for index in 0..<6 {
            let arrow = Entity()
            arrow.name = "flow-arrow-\(index)"
            let material = flowMaterial(opacity: 0.72)

            let shaft = ModelEntity(mesh: shaftMesh, materials: [material])
            shaft.position = [0, 0, -0.002]
            arrow.addChild(shaft)

            let left = ModelEntity(mesh: wingMesh, materials: [material])
            left.position = [-0.0023, 0, 0.004]
            left.orientation = simd_quatf(angle: -0.62, axis: [0, 1, 0])
            arrow.addChild(left)

            let right = ModelEntity(mesh: wingMesh, materials: [material])
            right.position = [0.0023, 0, 0.004]
            right.orientation = simd_quatf(angle: 0.62, axis: [0, 1, 0])
            arrow.addChild(right)
            arrows.addChild(arrow)
        }

        arrows.isEnabled = false
        return arrows
    }

    private static func makeRegisteredFlowArrows(points: [SIMD3<Float>]) -> Entity {
        let arrows = Entity()
        arrows.name = registeredFlowArrowName
        guard points.count > 1 else { return arrows }

        for index in 0..<(points.count - 1) {
            let start = points[index]
            let end = points[index + 1]
            let direction = end - start
            let arrow = makeFlowArrowGlyph(index: index, scale: 1.55)
            arrow.position = (start + end) / 2
            if simd_length(direction) > 0.000_01 {
                arrow.orientation = simd_quatf(from: [0, 0, 1], to: simd_normalize(direction))
            }
            arrows.addChild(arrow)
        }
        arrows.isEnabled = false
        return arrows
    }

    private static func makeFlowArrowGlyph(index: Int, scale: Float) -> Entity {
        let arrow = Entity()
        arrow.name = "registered-flow-arrow-\(index)"
        arrow.scale = [scale, scale, scale]
        let material = flowMaterial(opacity: 0.88)
        let shaft = ModelEntity(
            mesh: .generateBox(size: [0.0018, 0.0018, 0.011], cornerRadius: 0.0008),
            materials: [material]
        )
        shaft.position = [0, 0, -0.002]
        arrow.addChild(shaft)

        for side: Float in [-1, 1] {
            let wing = ModelEntity(
                mesh: .generateBox(size: [0.0018, 0.0018, 0.006], cornerRadius: 0.0008),
                materials: [material]
            )
            wing.position = [side * 0.0023, 0, 0.004]
            wing.orientation = simd_quatf(angle: side * 0.62, axis: [0, 1, 0])
            arrow.addChild(wing)
        }
        return arrow
    }

    /// Tissue that is starving but not yet lost. Built from overlapping lobes
    /// rather than one sphere: a perfect ball reads as a diagram, a lumpy
    /// breathing mass reads as tissue.
    private static func makePenumbra() -> Entity {
        let shell = Entity()
        shell.name = penumbraName
        shell.position = [0.045, 0.042, 0.03]

        let tissue = ModelEntity(
            mesh: (try? makeRiskRegionMesh()) ?? .generateSphere(radius: 0.046),
            materials: [warningMaterial(opacity: 0.34)]
        )
        tissue.name = "penumbra-tissue"
        shell.addChild(tissue)

        shell.components.set(InputTargetComponent())
        shell.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.058)]))
        shell.components.set(HoverEffectComponent())
        return shell
    }

    private static func makeRiskRegionMesh() throws -> MeshResource {
        let latitudeSegments = 20
        let longitudeSegments = 28
        let radii = SIMD3<Float>(0.052, 0.043, 0.039)
        var positions: [SIMD3<Float>] = [[0, radii.y, 0]]

        for latitude in 1..<latitudeSegments {
            let theta = Float(latitude) / Float(latitudeSegments) * .pi
            for longitude in 0..<longitudeSegments {
                let phi = Float(longitude) / Float(longitudeSegments) * 2 * .pi
                let variation = 1
                    + sin(phi * 4 + theta * 3) * 0.075
                    + sin(phi * 7 - theta * 5) * 0.035
                positions.append([
                    radii.x * variation * sin(theta) * cos(phi),
                    radii.y * variation * cos(theta),
                    radii.z * variation * sin(theta) * sin(phi)
                ])
            }
        }

        let bottomIndex = UInt32(positions.count)
        positions.append([0, -radii.y, 0])
        var indices: [UInt32] = []

        for longitude in 0..<longitudeSegments {
            let current = UInt32(1 + longitude)
            let next = UInt32(1 + (longitude + 1) % longitudeSegments)
            indices.append(contentsOf: [0, next, current])
        }

        for latitude in 0..<(latitudeSegments - 2) {
            let row = 1 + latitude * longitudeSegments
            let nextRow = row + longitudeSegments
            for longitude in 0..<longitudeSegments {
                let nextLongitude = (longitude + 1) % longitudeSegments
                let a = UInt32(row + longitude)
                let b = UInt32(row + nextLongitude)
                let c = UInt32(nextRow + nextLongitude)
                let d = UInt32(nextRow + longitude)
                indices.append(contentsOf: [a, b, c, a, c, d])
            }
        }

        let finalRow = 1 + (latitudeSegments - 2) * longitudeSegments
        for longitude in 0..<longitudeSegments {
            let current = UInt32(finalRow + longitude)
            let next = UInt32(finalRow + (longitude + 1) % longitudeSegments)
            indices.append(contentsOf: [bottomIndex, current, next])
        }

        var descriptor = MeshDescriptor(name: "procedural-tissue-at-risk")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(vertexNormals(positions: positions, indices: indices))
        descriptor.primitives = .triangles(indices)
        return try MeshResource.generate(from: [descriptor])
    }

    private static func makeCore() -> Entity {
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.018),
            materials: [lostMaterial(opacity: 0.85)]
        )
        entity.name = coreName
        entity.position = [0.045, 0.042, 0.03]
        return entity
    }

    private static func makeClot() -> Entity {
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.009),
            materials: [lostMaterial(opacity: 0.95)]
        )
        entity.name = clotName
        entity.position = [0.03, 0.03, 0.042]
        entity.scale = [1.4, 0.8, 0.8]
        entity.components.set(InputTargetComponent())
        entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.012)]))
        entity.components.set(HoverEffectComponent())
        return entity
    }

    static func isAnatomyInteractionTarget(_ entity: Entity) -> Bool {
        var candidate: Entity? = entity
        while let current = candidate {
            if isPointFieldInteractionTarget(current) {
                return true
            }
            if [
                importedBrainTargetName,
                importedClotTargetName,
                leftBrainName,
                rightBrainName,
                penumbraName,
                clotName
            ].contains(current.name) {
                return true
            }
            candidate = current.parent
        }
        return false
    }

    static func isPointFieldInteractionTarget(_ entity: Entity) -> Bool {
        entity.name.hasPrefix("\(regionPointFieldName)-point-") ||
            entity.name.hasPrefix("\(procedurePointFieldName)-point-")
    }

    static func pointFieldSelection(for entity: Entity) -> (entityName: String, label: String)? {
        var candidate: Entity? = entity
        while let current = candidate {
            let name = current.name
            if name.hasPrefix("\(regionPointFieldName)-point-"),
               let index = Int(name.replacingOccurrences(of: "\(regionPointFieldName)-point-", with: "")),
               regionPointLabels.indices.contains(index) {
                return (name, regionPointLabels[index])
            }
            if name.hasPrefix("\(procedurePointFieldName)-point-"),
               let index = Int(name.replacingOccurrences(of: "\(procedurePointFieldName)-point-", with: "")),
               procedurePointLabels.indices.contains(index) {
                return (name, procedurePointLabels[index])
            }
            candidate = current.parent
        }
        return nil
    }

    static func semanticTarget(for entity: Entity) -> String {
        if let selection = pointFieldSelection(for: entity) {
            return selection.label
        }
        var candidate: Entity? = entity
        while let current = candidate {
            switch current.name {
            case importedClotTargetName, clotName:
                return "blocked vessel"
            case penumbraName:
                return "affected brain region"
            case importedBrainTargetName, leftBrainName, rightBrainName:
                return "brain surface"
            default:
                candidate = current.parent
            }
        }
        return "teaching anatomy"
    }

    /// Two sparse, switchable spatial reference frames. They are intentionally
    /// points rather than labels: the shared brain remains primary, while a
    /// clinician can choose either regional context or the story's causal path.
    private static func makePointField(
        name: String,
        points: [SIMD3<Float>],
        labels: [String],
        material: RealityKit.Material
    ) -> Entity {
        let field = Entity()
        field.name = name
        let mesh = MeshResource.generateSphere(radius: 0.0025)

        for (index, position) in points.enumerated() {
            let point = ModelEntity(mesh: mesh, materials: [material])
            point.name = "\(name)-point-\(index)"
            point.position = position
            point.components.set(StrokeLessonPointTargetComponent())
            point.components.set(InputTargetComponent(allowedInputTypes: [.direct, .indirect]))
            // Preserve the precise 6 mm selection radius: two registered flow
            // cues are only about 15 mm apart. The filtered gesture below fixes
            // anatomy-proxy occlusion without making adjacent targets overlap.
            point.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.006)]))
            point.components.set(HoverEffectComponent())
            field.addChild(point)
        }

        field.isEnabled = false
        return field
    }

    /// A world-locked ring under the model. It is the clock: the lesson's single
    /// variable is expressed as something occupying space, not only a label.
    private static func makeTimeRing() -> Entity {
        let ring = Entity()
        ring.name = ringName

        let segmentCount = 36
        for index in 0..<segmentCount {
            let angle = Float(index) / Float(segmentCount) * 2 * .pi
            let tick = ModelEntity(
                mesh: .generateBox(size: [0.006, 0.002, 0.022]),
                materials: [contextMaterial(opacity: 0.55)]
            )
            tick.name = "time-tick-\(index)"
            tick.position = [cos(angle) * 0.16, -0.13, sin(angle) * 0.16]
            tick.orientation = simd_quatf(angle: -angle, axis: [0, 1, 0])
            ring.addChild(tick)
        }

        return ring
    }

    // MARK: - Per-frame update

    static func update(root: Entity, experience: StrokeExperienceState, time: TimeInterval) {
        let reveal = Float(experience.brainRevealProgress)
        let focus = Float(experience.vesselFocusProgress)

        updateBrainReveal(root: root, experience: experience, reveal: reveal, focus: focus)
        updatePressurePurpose(root: root, experience: experience, time: time)

        // The at-risk shell breathes subtly to remain legible as tissue. This is
        // authored teaching motion, not perfusion measurement or physiology.
        if let penumbra = root.findEntity(named: penumbraName) {
            let emphasis = 1 + focus * 0.22
            penumbra.scale = [emphasis, emphasis, emphasis]
            if let tissue = penumbra.findEntity(named: "penumbra-tissue") as? ModelEntity {
                let breath = 1 + sin(Float(time) * 1.1) * 0.028
                tissue.scale = [breath, breath, breath]
                tissue.model?.materials = [warningMaterial(opacity: 0.34 + CGFloat(focus) * 0.08)]
            }
        }

        updatePerfusion(root: root, step: experience.procedureStep, time: time)
        updateFlowArrows(root: root, experience: experience, time: time)

        if let core = root.findEntity(named: coreName) as? ModelEntity {
            let growth = 1 + focus * 0.52
            core.scale = [growth, growth, growth]
        }

        // Slow breathing pulse on the healthy supply so the scene reads alive
        // rather than frozen, and dims downstream as the delay grows.
        let pulse = Float(0.72 + sin(time * 1.6) * 0.06)
        if let tree = root.findEntity(named: "vessel-tree") {
            for child in tree.children {
                guard let segment = child as? ModelEntity else { continue }
                let isDownstream = child.name == "vessel-segment-3"
                let opacity = isDownstream && experience.procedureStep != .chooseCase
                    ? CGFloat(pulse * 0.24)
                    : CGFloat(pulse)
                segment.model?.materials = [flowMaterial(opacity: opacity)]
            }
        }

        if let clot = root.findEntity(named: clotName) as? ModelEntity {
            let throb = Float(1 + sin(time * 2.4) * 0.07)
            clot.scale = [1.4 * throb, 0.8 * throb, 0.8 * throb]
        }

        // The ring fills as the learner reveals the anatomy, turning the
        // sketch's zoom gesture into visible spatial state.
        if let ring = root.findEntity(named: ringName) {
            let litCount = Int((Double(reveal) * Double(ring.children.count)).rounded())
            for (index, child) in ring.children.enumerated() {
                guard let tick = child as? ModelEntity else { continue }
                let isLit = index < litCount
                tick.model?.materials = [
                    isLit
                        ? warningMaterial(opacity: 0.8)
                        : contextMaterial(opacity: 0.48)
                ]
                tick.scale = isLit ? [1, 2.4, 1] : [1, 1, 1]
            }
        }

        updateCarePreview(root: root, experience: experience, time: time)
        updatePointFields(root: root, experience: experience, time: time)
        updateImportedAnatomy(root: root, experience: experience, time: time)
    }

    private static func updatePointFields(
        root: Entity,
        experience: StrokeExperienceState,
        time: TimeInterval
    ) {
        let regionField = root.findEntity(named: regionPointFieldName)
        let procedureField = root.findEntity(named: procedurePointFieldName)

        let showLessons = experience.spatialPhase == .explanation && experience.lessonPointsVisible
        regionField?.isEnabled = showLessons && experience.pointField == .regions
        procedureField?.isEnabled = showLessons && experience.pointField == .procedure

        let active = experience.pointField == .regions ? regionField : procedureField
        if let active {
            // All region anchors can be inspected through the transparent
            // cortex because they are bound to the registered brain envelope.
            // Procedure points 0/1/3/4 remain single-focus technical anchors
            // until reviewed FLOW_ANCHOR exports and clinical review replace
            // their unapproved registered-v2 mesh samples.
            let revealAll = experience.pointField == .regions && (
                experience.anatomyPresentation == .transparent || (
                    experience.audienceLens == .family &&
                    experience.procedureStep == .discussCare &&
                    experience.careViewPermissionGranted
                )
            )
            for (index, child) in active.children.enumerated() {
                guard let point = child as? ModelEntity else { continue }
                let phase = Float(time) * 0.85 + Float(index) * 0.42
                let pulse = 0.96 + sin(phase) * 0.045
                let isSelected = child.name == experience.selectedPointEntityName
                // Opaque anatomy keeps one precise focus. See-through anatomy
                // reveals the complete lesson family while retaining one
                // dominant selected marker for gaze + pinch control agency.
                child.isEnabled = revealAll || isSelected || (
                    experience.selectedPointEntityName == nil &&
                    index == experience.pointField.defaultLessonPointIndex
                )
                let emphasis: Float = isSelected ? 1.85 : (revealAll ? 1.04 : 1)
                child.scale = [pulse * emphasis, pulse * emphasis, pulse * emphasis]
                point.model?.materials = [
                    isSelected
                        ? contextMaterial(opacity: 1)
                        : (experience.pointField == .regions
                            ? careMaterial(opacity: revealAll ? 0.68 : 0.92)
                            : warningMaterial(opacity: revealAll ? 0.68 : 0.92))
                ]
            }
        }
    }

    private static func updateImportedAnatomy(
        root: Entity,
        experience: StrokeExperienceState,
        time: TimeInterval
    ) {
        guard let imported = root.findEntity(named: importedRootName) else { return }

        let showsPurpose = experience.procedureStep == .discussCare && experience.careViewPermissionGranted
        let presentation: StrokeAnatomyPresentation = experience.audienceLens == .clinician
            ? experience.anatomyPresentation
            : (showsPurpose ? .transparent : .assembled)
        let separation: Float = presentation == .exploded ? 1 : 0
        let cortexOpacity: Float
        switch presentation {
        case .assembled:
            cortexOpacity = 1
        case .transparent:
            cortexOpacity = Float(experience.cortexOpacity)
        case .exploded:
            cortexOpacity = max(Float(experience.cortexOpacity), 0.52)
        }

        func approach(_ entity: Entity?, _ target: SIMD3<Float>) {
            guard let entity else { return }
            let delta = target - entity.position
            // Preserve the existing eased layer motion, then stop touching the
            // imported parent transform once it is within 0.1 mm of target.
            // This removes indefinite idle writes without a visible snap.
            if simd_length_squared(delta) <= 0.000_000_01 {
                if entity.position != target { entity.position = target }
                return
            }
            entity.position += delta * 0.14
        }

        let cortexLayer = imported.findEntity(named: cortexLayerName)
        let regionPointAnchor = imported.findEntity(named: regionPointAnchorName)
        let arteriesLayer = imported.findEntity(named: arteriesLayerName)
        let blockageLayer = imported.findEntity(named: blockageLayerName)
        let duraLayer = imported.findEntity(named: duraLayerName)

        approach(cortexLayer, [-0.026 * separation, 0, 0])
        approach(regionPointAnchor, [-0.026 * separation, 0, 0])
        approach(arteriesLayer, [0.014 * separation, 0, 0.004 * separation])
        approach(blockageLayer, [0.014 * separation, 0, 0.004 * separation])
        approach(duraLayer, [0.036 * separation, 0, 0])

        setSemanticLayerOpacity(cortexOpacity, on: cortexLayer)
        setSemanticLayerOpacity(presentation == .assembled ? 0.90 : 1, on: arteriesLayer)
        setSemanticLayerOpacity(1, on: blockageLayer)
        setSemanticLayerOpacity(presentation == .exploded ? 0.20 : 0.14, on: duraLayer)

        // Once the hero brain exists, procedural anatomy becomes an explicit
        // fallback rather than a competing visible model. The transparent
        // skull boundary and semantic focus ring remain useful teaching cues.
        root.findEntity(named: brainName)?.isEnabled = false
        root.findEntity(named: "vessel-tree")?.isEnabled = false
        root.findEntity(named: clotName)?.isEnabled = false
        root.findEntity(named: perfusionName)?.isEnabled = false
        root.findEntity(named: penumbraName)?.isEnabled = false
        root.findEntity(named: coreName)?.isEnabled = false

        setEnabledIfChanged(true, on: imported.findEntity(named: importedBrainName))
        setEnabledIfChanged(true, on: imported.findEntity(named: importedArteriesName))
        setEnabledIfChanged(
            experience.procedureStep != .chooseCase || presentation == .exploded,
            on: imported.findEntity(named: importedClotName)
        )
        setEnabledIfChanged(showsPurpose, on: imported.findEntity(named: importedDuraName))

        // These prototype-v1 meshes are intentionally quarantined. The first
        // integration render proved that their coordinate frame does not match
        // the registered v2 anatomy; displaying them now would imply a false
        // anatomical relationship. The app keeps the files for the Houdini /
        // Blender registration pass and uses reviewed schematic cues meanwhile.
        setEnabledIfChanged(false, on: imported.findEntity(named: importedEdemaName))
        setEnabledIfChanged(false, on: imported.findEntity(named: importedFlapName))
        setEnabledIfChanged(false, on: imported.findEntity(named: importedPatchName))

        // The full semantic skull is kept off in the patient path because its
        // atlas registration is approximate and its opaque shell would conceal
        // the brain. The procedural fixed-space shell carries that one message.
        setEnabledIfChanged(false, on: imported.findEntity(named: importedSkullName))

        _ = time
    }

    private static func updateBrainReveal(
        root: Entity,
        experience: StrokeExperienceState,
        reveal: Float,
        focus: Float
    ) {
        let purposeStage = experience.procedureStep == .discussCare
        if let left = root.findEntity(named: leftBrainName) as? ModelEntity {
            left.position = [-0.042 - reveal * 0.012, 0, 0]
            left.orientation = simd_quatf(angle: -reveal * 0.05, axis: [0, 1, 0])
            left.model?.materials = [brainMaterial(opacity: CGFloat(0.82 - focus * 0.10))]
        }
        if let right = root.findEntity(named: rightBrainName) as? ModelEntity {
            // Swelling is a small authored scale change inside a fixed shell.
            // The care stage does not restore or shrink established injury.
            let swelling: Float = experience.procedureStep == .chooseCase ? 1 : (purposeStage ? 1.09 : 1.07)
            right.position = [0.042 + reveal * 0.008, 0, 0]
            right.orientation = simd_quatf(angle: reveal * 0.04, axis: [0, 1, 0])
            right.scale = [swelling, swelling, swelling]
            right.model?.materials = [brainMaterial(opacity: CGFloat(0.82 - focus * 0.10))]
        }
        root.findEntity(named: "brain-midline-seam")?.isEnabled = true

        let pathologyVisible = experience.procedureStep != .chooseCase
        root.findEntity(named: clotName)?.isEnabled = pathologyVisible
        root.findEntity(named: penumbraName)?.isEnabled = pathologyVisible
        root.findEntity(named: coreName)?.isEnabled = pathologyVisible
    }

    private static func updatePressurePurpose(
        root: Entity,
        experience: StrokeExperienceState,
        time: TimeInterval
    ) {
        let showsPurpose = experience.procedureStep == .discussCare && experience.careViewPermissionGranted
        let hasImportedBrain = root.findEntity(named: importedRootName) != nil

        if let shell = root.findEntity(named: "skull-shell") as? ModelEntity {
            shell.isEnabled = !hasImportedBrain && experience.procedureStep != .chooseCase
            let opacity: CGFloat
            if hasImportedBrain {
                opacity = showsPurpose ? 0.032 : 0.020
            } else {
                opacity = showsPurpose ? 0.045 : 0.09
            }
            shell.model?.materials = [skullMaterial(opacity: opacity)]
        }

        if let boundary = root.findEntity(named: fixedBoundaryRingName) {
            boundary.isEnabled = experience.procedureStep != .chooseCase
            let pulse = Float(1 + sin(time * 0.72) * 0.012)
            boundary.scale = [pulse, pulse, pulse]
        }

        if let flap = root.findEntity(named: boneFlapName) as? ModelEntity {
            flap.isEnabled = showsPurpose && (!hasImportedBrain || (
                experience.audienceLens == .clinician && experience.anatomyPresentation == .exploded
            ))
            let reveal = Float(experience.layerRevealProgress)
            let calmOscillation = sin(Float(time) * 0.7) * 0.0012
            let drift: Float = showsPurpose ? 0.020 * reveal + calmOscillation : 0
            flap.position = [0.096 + drift, 0.025, 0]
            flap.orientation = simd_quatf(angle: Float.pi / 2 + reveal * 0.12, axis: [0, 0, 1])
        }

        if let dura = root.findEntity(named: duraExpansionName) as? ModelEntity {
            dura.isEnabled = showsPurpose && !hasImportedBrain
            let reveal = Float(experience.layerRevealProgress)
            let breath: Float = showsPurpose ? 1 + sin(Float(time) * 0.8) * 0.010 : 1
            dura.scale = [0.55 * breath * reveal, breath * reveal, 0.88 * breath * reveal]
        }

        if let seam = root.findEntity(named: layerRevealSeamName) {
            seam.isEnabled = showsPurpose && !hasImportedBrain
            let reveal = Float(experience.layerRevealProgress)
            for (index, child) in seam.children.enumerated() {
                guard let stitch = child as? ModelEntity else { continue }
                let threshold = Float(index + 1) / Float(seam.children.count)
                let opened = reveal >= threshold
                stitch.model?.materials = [careMaterial(opacity: opened ? 0.78 : 0.18)]
                stitch.scale = opened ? [1.0, 1.8, 1.0] : [0.72, 0.72, 0.72]
            }
        }
    }

    private static func updateCarePreview(root: Entity, experience: StrokeExperienceState, time: TimeInterval) {
        let preview = Float(experience.planPreviewProgress)
        let pulse = Float(1 + sin(time * 2.2) * 0.14)

        if let ring = root.findEntity(named: inspectionRingName) as? ModelEntity {
            let scale = 0.65 + Float(experience.vesselFocusProgress) * 0.55 + sin(Float(time) * 2) * 0.04
            ring.scale = [scale, 1, scale]
            ring.isEnabled = experience.procedureStep != .chooseCase
        }

        if let medicine = root.findEntity(named: medicinePreviewName) {
            medicine.isEnabled = experience.selectedCareDiscussion == .medicineReview && !experience.requestedPause
            medicine.scale = [preview * pulse, preview * pulse, preview * pulse]
        }

        if let catheter = root.findEntity(named: catheterPreviewName) {
            catheter.isEnabled = experience.selectedCareDiscussion == .thrombectomyReview && !experience.requestedPause
            catheter.scale = [preview, preview, preview]
        }
    }

    /// Droplets loop the centreline on staggered phases. Downstream of the
    /// blockage they fade and shrink toward nothing as the delay grows — the
    /// visual claim is "supply stopped", made out of motion rather than colour.
    private static func updatePerfusion(root: Entity, step: StrokeProcedureStep, time: TimeInterval) {
        guard let flow = root.findEntity(named: perfusionName) else { return }

        let speed: Float = 0.16
        let count = Float(flow.children.count)

        for (index, child) in flow.children.enumerated() {
            guard let droplet = child as? ModelEntity else { continue }

            // Even spacing plus a wrapping march gives a continuous stream from
            // a fixed pool of entities.
            let offset = Float(index) / count
            let arc = (offset + Float(time) * speed).truncatingRemainder(dividingBy: 1)

            let downstream = arc > clotArc
            // A fixed residual downstream cue keeps the blockage visible. It is
            // not a patient measurement or a claim about collateral flow.
            let survival: Float = downstream && step != .chooseCase ? 0.18 : 1

            droplet.position = samplePath(arc)
            droplet.isEnabled = survival > 0.04

            let jitter = 1 + sin(Float(time) * 6 + Float(index)) * 0.12
            let size = (downstream ? 0.7 + 0.3 * survival : 1) * jitter
            droplet.scale = [size, size, size]
            droplet.model?.materials = [flowMaterial(opacity: CGFloat(0.95 * survival))]
        }
    }

    private static func updateFlowArrows(
        root: Entity,
        experience: StrokeExperienceState,
        time: TimeInterval
    ) {
        guard let arrows = root.findEntity(named: flowArrowName) else { return }
        let shouldShow = experience.spatialPhase == .explanation
            && experience.lessonPointsVisible
            && experience.pointField == .procedure
        let hasRegisteredAnatomy = root.findEntity(named: importedRootName) != nil
        arrows.isEnabled = shouldShow && !hasRegisteredAnatomy
        if let registeredArrows = root.findEntity(named: registeredFlowArrowName) {
            // These authored-frame glyphs read as detached vessel fragments
            // around the imported brain. Keep them quarantined until their
            // centreline registration is reviewed; the procedural arrows below
            // remain constrained to the qualitative vessel path.
            registeredArrows.isEnabled = false
        }
        // Procedural arrows do not share the registered-v2 authored frame.
        // Hiding them is safer than showing detached vessel fragments around
        // the hero brain; registered qualitative flow remains a review gate.
        guard shouldShow && !hasRegisteredAnatomy else { return }

        let count = Float(max(arrows.children.count, 1))
        for (index, arrow) in arrows.children.enumerated() {
            let offset = Float(index) / count
            let arc = (offset + Float(time) * 0.065).truncatingRemainder(dividingBy: 1)
            let nextArc = min(arc + 0.015, 1)
            let position = samplePath(arc)
            let next = samplePath(nextArc)
            let direction = next - position
            if simd_length(direction) > 0.000_01 {
                arrow.orientation = simd_quatf(from: [0, 0, 1], to: simd_normalize(direction))
            }
            arrow.position = position

            let downstream = arc > clotArc
            let scale: Float = downstream && experience.procedureStep != .chooseCase ? 0.52 : 1
            arrow.scale = [scale, scale, scale]
            arrow.isEnabled = !experience.requestedPause
        }
    }

    // MARK: - Materials

    private enum MaterialKind: Hashable { case context, brain, furrow, warning, lost, flow, care, skull }

    /// The scene touches ~110 entities per frame. Building a fresh
    /// PhysicallyBasedMaterial for each one every frame hitches visibly, so
    /// opacity is quantised to 2% steps and the result reused.
    private static var materialCache: [MaterialKind: [Int: RealityKit.Material]] = [:]

    private static func cached(
        _ kind: MaterialKind,
        opacity: CGFloat,
        build: (CGFloat) -> RealityKit.Material
    ) -> RealityKit.Material {
        let clamped = min(max(opacity, 0), 1)
        let bucket = Int((clamped * 50).rounded())
        if let hit = materialCache[kind]?[bucket] { return hit }
        let made = build(CGFloat(bucket) / 50)
        materialCache[kind, default: [:]][bucket] = made
        return made
    }

    private static func contextMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.context, opacity: opacity, build: buildContextMaterial)
    }

    private static func warningMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.warning, opacity: opacity, build: buildWarningMaterial)
    }

    private static func brainMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.brain, opacity: opacity, build: buildBrainMaterial)
    }

    private static func furrowMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.furrow, opacity: opacity, build: buildFurrowMaterial)
    }

    private static func lostMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.lost, opacity: opacity, build: buildLostMaterial)
    }

    private static func flowMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.flow, opacity: opacity, build: buildFlowMaterial)
    }

    private static func careMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.care, opacity: opacity, build: buildCareMaterial)
    }

    private static func skullMaterial(opacity: CGFloat) -> RealityKit.Material {
        cached(.skull, opacity: opacity, build: buildSkullMaterial)
    }

    /// Grey is retained context. Amber is the problem. Nothing else competes.
    private static func buildContextMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(white: 0.72, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.roughness = 0.85
        return material
    }

    private static func buildSkullMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.84, green: 0.82, blue: 0.74, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.roughness = 0.68
        return material
    }

    private static func buildBrainMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.78, green: 0.57, blue: 0.54, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.roughness = 0.72
        return material
    }

    private static func buildFurrowMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.22, green: 0.10, blue: 0.11, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.roughness = 0.88
        return material
    }

    private static func buildWarningMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.98, green: 0.62, blue: 0.16, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.emissiveColor = .init(color: UIColor(red: 0.98, green: 0.55, blue: 0.12, alpha: 1))
        material.emissiveIntensity = 0.35
        return material
    }

    private static func buildLostMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.34, green: 0.13, blue: 0.10, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.roughness = 0.7
        return material
    }

    private static func buildFlowMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.86, green: 0.24, blue: 0.28, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.emissiveColor = .init(color: UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1))
        material.emissiveIntensity = 0.22
        return material
    }

    private static func buildCareMaterial(opacity: CGFloat) -> RealityKit.Material {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: UIColor(red: 0.28, green: 0.72, blue: 0.56, alpha: opacity))
        material.blending = .transparent(opacity: .init(floatLiteral: Float(opacity)))
        material.emissiveColor = .init(color: UIColor(red: 0.24, green: 0.68, blue: 0.50, alpha: 1))
        material.emissiveIntensity = 0.24
        return material
    }

    private static func orientation(from start: SIMD3<Float>, to end: SIMD3<Float>) -> simd_quatf {
        let direction = simd_normalize(end - start)
        let up = SIMD3<Float>(0, 1, 0)
        if abs(simd_dot(direction, up)) > 0.999 {
            return simd_quatf(angle: 0, axis: up)
        }
        return simd_quatf(from: up, to: direction)
    }
}
