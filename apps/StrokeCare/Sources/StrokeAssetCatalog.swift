import Foundation

/// Presentation density is independent from the three clinical teaching acts.
/// It filters explanatory metadata; it never advances a case or selects care.
enum StrokeDetailLevel: String, CaseIterable, Identifiable, Comparable {
    case calm
    case guided
    case scholar

    var id: String { rawValue }

    private var rank: Int {
        switch self {
        case .calm: 0
        case .guided: 1
        case .scholar: 2
        }
    }

    static func < (lhs: StrokeDetailLevel, rhs: StrokeDetailLevel) -> Bool {
        lhs.rank < rhs.rank
    }
}

enum StrokeAssetFamily: String, CaseIterable {
    case prototypeV1 = "prototype_v1"
    case detailV2 = "detail_v2"
    case detailV3 = "detail_v3"
}

enum StrokeAssetLane: String, CaseIterable {
    case legacyQuarantine = "legacy_quarantine"
    case coreAnatomy = "core_anatomy"
    case headAndVascular = "head_and_vascular"
    case flowAndOcclusion = "flow_and_occlusion"
    case endovascularTools = "endovascular_tools"
    case neuralDetail = "neural_detail"
    case cranialDetail = "cranial_detail"
    case microTeaching = "micro_teaching"
    case openCranialTools = "open_cranial_tools"

    var isFamilyRestricted: Bool {
        self == .legacyQuarantine || self == .openCranialTools
    }
}

/// Frame identifiers mirror the PR #8 master assembly contract. They are
/// routing metadata only; this foundation applies no transforms.
enum StrokeAssetFrameDomain: String, CaseIterable {
    case registeredV2 = "registered_v2"
    case neuralHRA = "neural_hra"
    case cranialZ = "cranial_z"
    case legacyV1 = "legacy_v1"
    case vignette
    case microSeparate = "micro_separate"
    case deviceTray = "device_tray"
}

enum StrokeAssetReviewGate: String {
    case requiresClinicalReview = "REQUIRES_CLINICAL_REVIEW"
    case requiresSpecialistReview = "REQUIRES_SPECIALIST_REVIEW"
    case requiresNeuroanatomyAndClinicalSpecialistReview = "REQUIRES_NEUROANATOMY_AND_CLINICAL_SPECIALIST_REVIEW"
    case holdForInnerEarLicenseReview = "HOLD_FOR_INNER_EAR_LICENSE_REVIEW"
}

enum StrokeAssetDisposition: String {
    case quarantinedPrototype = "QUARANTINED_PROTOTYPE"
    case candidateMetadata = "CANDIDATE_METADATA"
    case heldSourceBuild = "HELD_SOURCE_BUILD"
}

enum StrokeAssetBundleStatus: String {
    case notBundled = "NOT_BUNDLED"
    case alreadyBundledOutsideCatalog = "ALREADY_BUNDLED_OUTSIDE_CATALOG"
    case notPublished = "NOT_PUBLISHED"
}

enum StrokeAssetLoadStatus: String {
    case metadataOnlyNotRequested = "METADATA_ONLY_NOT_REQUESTED"
    case blockedByLicenseHold = "BLOCKED_BY_LICENSE_HOLD"
}

struct StrokeAssetRecord: Identifiable, Hashable {
    let id: String
    let manifest: String
    let family: StrokeAssetFamily
    let lane: StrokeAssetLane
    let frameDomain: StrokeAssetFrameDomain
    let reviewGate: StrokeAssetReviewGate
    let disposition: StrokeAssetDisposition
    let minimumDetailLevel: StrokeDetailLevel
    let bundleStatus: StrokeAssetBundleStatus
    let loadStatus: StrokeAssetLoadStatus

    /// Visibility is a presentation filter, not a clinical state transition.
    /// Family mode is always calm and never exposes quarantined/open-cranial IDs.
    func isVisible(to audience: StrokeAudienceLens, detailLevel: StrokeDetailLevel) -> Bool {
        guard disposition == .candidateMetadata,
              detailLevel >= minimumDetailLevel else { return false }

        if audience == .family {
            return detailLevel == .calm && !lane.isFamilyRestricted
        }
        return true
    }
}

/// Static, non-loading index audited against GitHub PR #8. This type does not
/// resolve a URL, add a resource to the bundle, or instantiate a RealityKit entity.
enum StrokeAssetCatalog {
    static let auditedPullRequestNumber = 8
    static let auditedPullRequestHead = "12728df2e856897a44df2bbfbe01236f8b142303"
    static let releaseRecordCount = 134
    static let v1RecordCount = 29
    static let v2RecordCount = 36
    static let v3RecordCount = 69
    static let nonV1CandidateCount = 105
    static let heldSourceBuildCount = 2

    static let records: [StrokeAssetRecord] = manifestGroups.flatMap { group in
        group.ids.map { id in
            StrokeAssetRecord(
                id: id,
                manifest: group.manifest,
                family: group.family,
                lane: group.lane,
                frameDomain: group.frameDomain(for: id),
                reviewGate: group.reviewGate,
                disposition: group.disposition,
                minimumDetailLevel: group.minimumDetailLevel,
                bundleStatus: existingProjectBundleIDs.contains(id) ? .alreadyBundledOutsideCatalog : .notBundled,
                loadStatus: .metadataOnlyNotRequested
            )
        }
    }

    /// These source-build IDs are deliberately absent from `records` and from
    /// the publishing tree. They must remain non-resolvable until the hold clears.
    static let heldSourceBuildRecords: [StrokeAssetRecord] = heldSourceBuildIDs.map { id in
        StrokeAssetRecord(
            id: id,
            manifest: "asset_manifest_cranial_detail_v3.json (omitted source-build ID)",
            family: .detailV3,
            lane: .cranialDetail,
            frameDomain: .cranialZ,
            reviewGate: .holdForInnerEarLicenseReview,
            disposition: .heldSourceBuild,
            minimumDetailLevel: .scholar,
            bundleStatus: .notPublished,
            loadStatus: .blockedByLicenseHold
        )
    }

    static func record(id: String) -> StrokeAssetRecord? {
        records.first { $0.id == id }
    }

    static func visibleRecords(
        for audience: StrokeAudienceLens,
        detailLevel: StrokeDetailLevel
    ) -> [StrokeAssetRecord] {
        records.filter { $0.isVisible(to: audience, detailLevel: detailLevel) }
    }

    private struct ManifestGroup {
        let manifest: String
        let family: StrokeAssetFamily
        let lane: StrokeAssetLane
        let defaultFrameDomain: StrokeAssetFrameDomain
        let frameOverrides: [String: StrokeAssetFrameDomain]
        let reviewGate: StrokeAssetReviewGate
        let disposition: StrokeAssetDisposition
        let minimumDetailLevel: StrokeDetailLevel
        let ids: [String]

        func frameDomain(for id: String) -> StrokeAssetFrameDomain {
            frameOverrides[id] ?? defaultFrameDomain
        }
    }

    private static let manifestGroups: [ManifestGroup] = [
        ManifestGroup(
            manifest: "asset_manifest.json",
            family: .prototypeV1,
            lane: .legacyQuarantine,
            defaultFrameDomain: .legacyV1,
            frameOverrides: [:],
            reviewGate: .requiresClinicalReview,
            disposition: .quarantinedPrototype,
            minimumDetailLevel: .scholar,
            ids: v1PrototypeIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_v2.json",
            family: .detailV2,
            lane: .coreAnatomy,
            defaultFrameDomain: .registeredV2,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .calm,
            ids: v2CoreIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_head_details_v2.json",
            family: .detailV2,
            lane: .headAndVascular,
            defaultFrameDomain: .registeredV2,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .guided,
            ids: v2HeadDetailIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_cranial_vascular_v2.json",
            family: .detailV2,
            lane: .headAndVascular,
            defaultFrameDomain: .registeredV2,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .guided,
            ids: v2CranialVascularIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_bloodflow_v2.json",
            family: .detailV2,
            lane: .flowAndOcclusion,
            defaultFrameDomain: .vignette,
            frameOverrides: [
                "circle_of_willis_flow_overlay_v2": .registeredV2,
                "cerebral_bloodflow_animation_v2": .registeredV2
            ],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .calm,
            ids: v2BloodFlowIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_devices_v2.json",
            family: .detailV2,
            lane: .endovascularTools,
            defaultFrameDomain: .deviceTray,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .guided,
            ids: v2DeviceIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_cranial_detail_v3.json",
            family: .detailV3,
            lane: .cranialDetail,
            defaultFrameDomain: .cranialZ,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .scholar,
            ids: v3CranialDetailIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_neural_detail_v3.json",
            family: .detailV3,
            lane: .neuralDetail,
            defaultFrameDomain: .neuralHRA,
            frameOverrides: [:],
            reviewGate: .requiresNeuroanatomyAndClinicalSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .scholar,
            ids: v3NeuralDetailIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_intracranial_micro_v3.json",
            family: .detailV3,
            lane: .microTeaching,
            defaultFrameDomain: .microSeparate,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .scholar,
            ids: v3MicroTeachingIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_endovascular_tools_v3.json",
            family: .detailV3,
            lane: .endovascularTools,
            defaultFrameDomain: .deviceTray,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .scholar,
            ids: v3EndovascularToolIDs
        ),
        ManifestGroup(
            manifest: "asset_manifest_open_cranial_tools_v3.json",
            family: .detailV3,
            lane: .openCranialTools,
            defaultFrameDomain: .deviceTray,
            frameOverrides: [:],
            reviewGate: .requiresSpecialistReview,
            disposition: .candidateMetadata,
            minimumDetailLevel: .scholar,
            ids: v3OpenCranialToolIDs
        )
    ]

    /// These fifteen resources are explicitly listed in project.yml. The
    /// static catalog itself still adds no implicit bundle membership.
    private static let existingProjectBundleIDs: Set<String> = [
        "brain_anatomy_realistic_v2",
        "cerebral_arteries_realistic_v2",
        "dural_sinuses_jugulars_realistic_v2",
        "ischemic_mca_clot_v2",
        "skull_semantic_realistic_v2",
        "dura_mater_cutaway_conceptual_v2",
        "brain_deep_structures_v2",
        "brain_ventricles_v2",
        "cerebral_bloodflow_animation_v2",
        "circle_of_willis_flow_overlay_v2",
        "edema_swelling",
        "craniotomy_bone_flap",
        "dural_patch",
        "cranial_drill_generic",
        "suction_and_forceps"
    ]

    private static let v1PrototypeIDs: [String] = [
        "head_skin_generic",
        "skull_cranium_generic",
        "brain_structures_generic",
        "cerebral_arteries_generic",
        "ischemic_lvo_clot",
        "ich_hematoma",
        "edema_swelling",
        "patient_supine_generic",
        "angiography_operating_table",
        "angiography_c_arm",
        "vital_sign_monitor",
        "iv_pole_and_bag",
        "clinical_team_generic",
        "arterial_access_site",
        "catheter_body_to_brain_route",
        "guidewire_microcatheter_set",
        "stent_retriever",
        "aspiration_catheter",
        "angiography_contrast_flow",
        "scalp_incision_flap",
        "craniotomy_bone_flap",
        "cranial_drill_generic",
        "suction_and_forceps",
        "scalp_closure_sutures",
        "dural_patch",
        "minimally_invasive_evacuator_port",
        "optional_evd_system",
        "postoperative_head_dressing",
        "spatial_step_markers"
    ]

    private static let v2CoreIDs: [String] = [
        "brain_anatomy_realistic_v2",
        "brain_deep_structures_v2",
        "brain_ventricles_v2",
        "skull_semantic_realistic_v2",
        "cerebral_arteries_realistic_v2",
        "ischemic_mca_clot_v2",
        "thrombectomy_registered_hero_v2"
    ]

    private static let v2HeadDetailIDs: [String] = [
        "external_head_scalp_realistic_v2",
        "external_head_scalp_cutaway_v2",
        "eyes_context_realistic_v2",
        "dura_mater_conceptual_v2",
        "dura_mater_cutaway_conceptual_v2",
        "falx_cerebri_atlas_v2",
        "tentorium_cerebelli_atlas_v2",
        "meningeal_partitions_atlas_v2",
        "layered_head_cutaway_registered_v2"
    ]

    private static let v2CranialVascularIDs: [String] = [
        "dural_venous_sinuses_realistic_v2",
        "internal_jugular_veins_realistic_v2",
        "dural_sinuses_jugulars_realistic_v2",
        "head_neck_veins_supplemental_v2",
        "head_neck_veins_expanded_realistic_v2",
        "neck_access_arteries_realistic_v2",
        "cranial_vascular_registered_assembly_v2"
    ]

    private static let v2BloodFlowIDs: [String] = [
        "artery_wall_cutaway_v2",
        "artery_interior_bloodflow_v2",
        "artery_cutaway_complete_v2",
        "circle_of_willis_flow_overlay_v2",
        "red_blood_cells_closeup_v2",
        "microcirculation_arterial_venous_v2",
        "cerebral_bloodflow_animation_v2",
        "cerebral_bloodflow_teaching_set_v2"
    ]

    private static let v2DeviceIDs: [String] = [
        "guidewire_educational_v2",
        "microcatheter_educational_v2",
        "aspiration_catheter_educational_v2",
        "stent_retriever_educational_v2",
        "thrombectomy_device_set_educational_v2"
    ]

    private static let v3CranialDetailIDs: [String] = [
        "cranial_nerve_olfactory_i_bilateral_v3",
        "cranial_nerve_optic_ii_bilateral_v3",
        "cranial_nerves_ocular_motor_iii_iv_vi_v3",
        "cranial_nerve_trigeminal_v_expanded_v3",
        "cranial_nerve_facial_vii_bilateral_v3",
        "cranial_nerve_vestibulocochlear_viii_v3",
        "cranial_nerves_glossopharyngeal_ix_vagus_x_v3",
        "cranial_nerve_accessory_xi_bilateral_v3",
        "cranial_nerve_hypoglossal_xii_bilateral_v3",
        "extraocular_muscles_orbital_support_v3",
        "pituitary_adenohypophysis_neurohypophysis_v3",
        "nasal_cavity_paranasal_spaces_v3",
        "pharyngeal_upper_airway_context_v3",
        "muscles_of_mastication_bilateral_v3",
        "head_neck_orientation_muscles_v3",
        "cranial_nerves_complete_assembly_v3"
    ]

    private static let v3NeuralDetailIDs: [String] = [
        "frontal_cortex_parcellation_v3",
        "parietal_cortex_parcellation_v3",
        "temporal_cortex_parcellation_v3",
        "occipital_cortex_parcellation_v3",
        "insular_opercular_cortex_v3",
        "cingulate_parahippocampal_cortex_v3",
        "cerebellar_substructures_v3",
        "brainstem_substructures_v3",
        "basal_ganglia_deep_nuclei_v3",
        "thalamic_hypothalamic_nuclei_v3",
        "hippocampal_amygdala_limbic_nuclei_v3",
        "ventricular_spaces_v3",
        "major_white_matter_regions_v3",
        "commissural_sensory_pathways_v3",
        "neural_detail_registered_review_assembly_v3"
    ]

    private static let v3MicroTeachingIDs: [String] = [
        "blood_brain_barrier_neurovascular_unit_conceptual_v3",
        "capillary_endothelium_tight_junctions_conceptual_v3",
        "formed_blood_elements_magnified_v3",
        "platelet_fibrin_thrombus_microstructure_conceptual_v3",
        "multipolar_neuron_detailed_conceptual_v3",
        "astrocyte_capillary_endfeet_conceptual_v3",
        "oligodendrocyte_myelinated_axons_conceptual_v3",
        "myelinated_axon_node_of_ranvier_conceptual_v3",
        "chemical_synapse_closeup_conceptual_v3",
        "choroid_plexus_csf_interface_conceptual_v3",
        "ischemic_tissue_zones_conceptual_v3",
        "intracranial_micro_teaching_set_v3"
    ]

    private static let v3EndovascularToolIDs: [String] = [
        "vascular_access_needle_educational_v3",
        "vascular_access_wire_educational_v3",
        "introducer_sheath_dilator_set_educational_v3",
        "guide_catheter_hemostatic_valve_educational_v3",
        "aspiration_pump_canister_tubing_educational_v3",
        "contrast_manifold_syringe_flush_educational_v3",
        "torque_device_y_connector_accessories_educational_v3",
        "puncture_site_hemostasis_options_educational_v3",
        "sterile_endovascular_instrument_tray_educational_v3",
        "angiography_suite_controls_educational_v3",
        "vascular_access_setup_review_assembly_v3",
        "endovascular_tools_workflow_review_assembly_v3"
    ]

    private static let v3OpenCranialToolIDs: [String] = [
        "surface_marking_ruler_set_open_neurosurgery_v3",
        "scalpel_dissector_set_open_neurosurgery_v3",
        "scalp_retractor_hemostat_set_open_neurosurgery_v3",
        "perforator_craniotome_system_open_neurosurgery_v3",
        "bone_flap_fixation_set_open_neurosurgery_v3",
        "dural_scissors_hooks_forceps_set_open_neurosurgery_v3",
        "bipolar_forceps_irrigation_set_open_neurosurgery_v3",
        "suction_microdissector_set_open_neurosurgery_v3",
        "brain_spatula_retractor_set_open_neurosurgery_v3",
        "microscope_microinstrument_tray_open_neurosurgery_v3",
        "dural_closure_suture_patch_set_open_neurosurgery_v3",
        "conditional_csf_access_instrument_set_open_neurosurgery_v3",
        "cranial_access_tools_review_assembly_open_neurosurgery_v3",
        "intradural_closure_tools_review_assembly_open_neurosurgery_v3"
    ]

    private static let heldSourceBuildIDs: [String] = [
        "middle_inner_ear_bilateral_v3",
        "cranial_support_registered_assembly_v3"
    ]
}
