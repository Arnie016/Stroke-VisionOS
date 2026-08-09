# Cranial support anatomy v3

> **Publishing-tree note:** this source-build record describes all 18 generated
> packages. The repository's release-safe
> `asset_manifest_cranial_detail_v3.json` contains only 16 non-held records.
> `middle_inner_ear_bilateral_v3` and
> `cranial_support_registered_assembly_v3` binaries are deliberately absent
> pending inner-ear provenance/licence clearance or verified replacement.

This module adds 16 independently selectable anatomy layers and two review
assemblies around and inside the registered v2 head. It was built from 137
exactly named Z-Anatomy / BodyParts3D source objects: 49 source curves and 88
source meshes. No nerve, muscle, organ, air space, or landmark was inferred to
fill a gap in the source atlas.

These are generic atlas-derived educational assets. They are not patient-
specific segmentations, do not encode function or pathology, and must not be
used for diagnosis, treatment planning, navigation, procedural rehearsal,
device sizing, or clinical decisions. Anatomical identity, laterality,
continuity, registration, terminology, patient-facing language, and every
healthcare deployment require specialist review.

## Runtime contract

- Manifest: `asset_manifest_cranial_detail_v3.json`
- Module: `cranial_detail_v3`
- Editable source: `blender/cranial_support_anatomy_v3.blend`
- Generator: `source/build_cranial_detail_v3.py`
- Units: metres
- USD up axis: Y
- Shared registration centre in the Z-Anatomy source frame:
  `[0.0, 0.008782502, 1.640712023]` metres
- Runtime materials: opaque PBR only. Colors differentiate selectable teaching
  layers; they do not encode conduction, motor/sensory function, impairment,
  inflammation, oxygenation, perfusion, or measured tissue properties.
- Every semantic mesh prim carries the exact source identity in
  `userProperties:anatomical_name`, even when USD sanitizes the prim identifier.
- No cameras, lights, backdrop, labels, absolute paths, physics bodies, joints,
  colliders, animations, or patient data are included in the USDZ packages.

## Independent assets

### Cranial nerves

1. `cranial_nerve_olfactory_i_bilateral_v3` — bilateral olfactory nerve
   geometry. Pair with the nasal layer only for supervised spatial explanation;
   do not infer smell function from visibility or color.
2. `cranial_nerve_optic_ii_bilateral_v3` — bilateral optic nerves. Register with
   the existing `eyes_context_realistic_v2` layer; the eyeballs are deliberately
   not duplicated here.
3. `cranial_nerves_ocular_motor_iii_iv_vi_v3` — bilateral III, IV, and VI paths
   retained as six named children. Pair with the extraocular-muscle asset.
4. `cranial_nerve_trigeminal_v_expanded_v3` — bilateral main roots plus the
   atlas-supported ophthalmic, maxillary, and mandibular divisions and selected
   distal branches. It contains 26 separately named meshes.
5. `cranial_nerve_facial_vii_bilateral_v3` — bilateral facial nerves and chorda
   tympani branches. It is an anatomical path, not a facial-expression rig.
6. `cranial_nerve_vestibulocochlear_viii_v3` — bilateral VIII trunks and the
   source-available vestibular/cochlear subdivisions. The atlas includes an
   unlatered `Cochlear nerve` mesh and a left-labelled `Cochlear nerve.l` curve;
   both identities are preserved instead of being relabelled.
7. `cranial_nerves_glossopharyngeal_ix_vagus_x_v3` — bilateral IX and X at the
   full atlas-provided extents. The long vagus geometry is why this asset extends
   substantially below the cranial vault.
8. `cranial_nerve_accessory_xi_bilateral_v3` — bilateral XI paths through the
   atlas-provided neck extent.
9. `cranial_nerve_hypoglossal_xii_bilateral_v3` — bilateral XII paths.

### Orbital, endocrine, ear, airway, and muscle context

10. `extraocular_muscles_orbital_support_v3` — all six bilateral extraocular
    muscles, bilateral levator palpebrae, common tendinous rings, and trochleae.
    Use with II/III/IV/VI and the existing eye layer; this is not an ocular motor
    simulation.
11. `pituitary_adenohypophysis_neurohypophysis_v3` — separate anterior and
    posterior pituitary source meshes. Hormonal function is outside the asset.
12. `middle_inner_ear_bilateral_v3` — bilateral mallei, incudes, stapes,
    cochleae, vestibular labyrinth meshes, tympanic membranes, and auditory
    tubes. **Hold for licence review:** the bundled Z-Anatomy README separately
    identifies an adapted University of Dundee inner-ear source under
    CC BY-NC-SA 4.0. Do not ship this package for hospital or commercial use
    until the selected meshes' provenance and permissions are resolved.
13. `nasal_cavity_paranasal_spaces_v3` — nasal mucosa, septal cartilage,
    inferior conchae, bilateral anterior/middle/posterior ethmoid cells, and the
    separately available frontal and sphenoid sinus spaces. No maxillary sinus
    mesh was available, so none was invented.
14. `pharyngeal_upper_airway_context_v3` — nasopharynx, oropharynx,
    laryngopharynx, soft palate, and epiglottis. This is static orientation
    anatomy, not a swallowing or airway-flow model.
15. `muscles_of_mastication_bilateral_v3` — bilateral temporalis, superficial
    and deep masseter, medial pterygoid, and superior/inferior lateral pterygoid
    components.
16. `head_neck_orientation_muscles_v3` — selected bilateral
    sternocleidomastoid, digastric, mylohyoid, frontalis, occipitalis, and
    orbicularis-oculi components. It supplies spatial context, not a complete
    myology atlas.

## Review assemblies

- `cranial_nerves_complete_assembly_v3` combines all nine nerve groups while
  retaining 54 source-semantic children. It is the correct review layer for
  checking I–XII registration before breaking the paths into interactive
  teaching states.
- `cranial_support_registered_assembly_v3` combines all 16 independent assets
  and retains 137 semantic children. It is a registration and authoring review
  assembly, not the recommended always-on runtime view. Because it includes the
  ear layer, it inherits the inner-ear licence hold.

## Houdini handoff

Import USD/USDZ with `metersPerUnit = 1` and Y-up preserved. Use the exact
`userProperties:anatomical_name` value as the stable semantic key; do not depend
on the sanitized USD prim path or Blender display name. Keep the 16 independent
assets as separate payloads or variants and use the two assemblies only to
verify registration.

Recommended layer relationships:

1. Register these assets to the same world transform as
   `brain_anatomy_realistic_v2`, `brain_deep_structures_v2`,
   `skull_semantic_realistic_v2`, `eyes_context_realistic_v2`, and
   `external_head_scalp_realistic_v2`. Do not apply another centre offset.
2. Treat anatomy as static reference geometry. Do not add gravity, rigid-body
   dynamics, collision response, nerve conduction, muscle contraction, airway
   flow, or tissue deformation merely because a structure is visible.
3. For reveal effects, animate opacity or clipping in a presentation-only USD
   layer while retaining an opaque, unchanged source payload for identity/QC.
4. For picking and labels, resolve the selected prim to
   `userProperties:anatomical_name`, then look up reviewed display copy in an
   external localization table. Never bake clinical claims into mesh names.
5. If clinically reviewed functional animation is later added, bind it to a
   separate versioned state graph. Preserve the source mesh and atlas identity
   as the immutable registration reference.
6. Use coarse proxy colliders only for UI selection. Never interpret them as
   tissue boundaries, surgical corridors, safe margins, or navigation volumes.
7. The complete assembly is too dense for an always-on immersive view. Stream
   phase-relevant payloads and keep unrelated layers disabled to reduce visual
   clutter and RealityKit load cost.

## Deliberate omissions

- Foramina: source hits were label/helper objects rather than independently
  defensible surface meshes.
- Cranial sutures: source collections/helpers did not expose a separate seam
  mesh suitable for this module.
- Maxillary sinuses: no separately named source mesh was found.
- Separately named semicircular canals: the names resolved to labels/helpers;
  the source `Vestibule.l/.r` meshes are retained without relabelling subparts.
- Existing eyes, generic skull, arteries, dural sinuses, brain, ventricles,
  meninges, and scalp are not duplicated.

## Visual evidence

Seven final 1400 × 1050 rendered-material previews are in
`previews/cranial_detail_v3/`. The most useful review frames are:

- `01b_cranial_nerves_head_closeup.png`
- `02_trigeminal_facial_pathways.png`
- `03_orbital_muscles_and_nerves.png`
- `04_ear_and_pituitary_detail.png`
- `05_nasal_airway_and_muscles.png`
- `06_registered_cranial_support_context.png`
