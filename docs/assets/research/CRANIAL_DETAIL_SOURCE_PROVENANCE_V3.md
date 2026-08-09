# Cranial detail v3 source provenance

## Source snapshot

- Local atlas: `vendor/z_anatomy/Z-Anatomy/Startup.blend`
- SHA-256: `9f08a17ea0115fed80b2a73ecdf0a1bc2ab2f6956f37c593ce23d513ea35afcd`
- Bundled template archive: `vendor/z_anatomy/Z-Anatomy.zip`
- Archive SHA-256:
  `e029688545627bd0214b269e1063143abb580aad72b2c2445d6d8a9a0d9da736`
- Upstream read-only discovery audit (SHA retained below; the 621-candidate
  development inventory is not duplicated in this runtime publishing tree):
  `research/cranial_detail_source_audit_v3.json`
- Audit SHA-256:
  `1337eb0111110b3683a72414e990911add91a9a057100d297e15ae855d1f847b`
- Published curated 137-object build QC:
  [`cranial_detail_source_qc_v3.json`](cranial_detail_source_qc_v3.json)
- Build software: Blender 5.2.0 LTS

The publishing copy of the curated QC changes only `source_blend` from the
builder workstation's absolute path to
`vendor/z_anatomy/Z-Anatomy/Startup.blend`; the object/QC records are
otherwise preserved.

The discovery audit records 621 candidate objects whose exact names or
collection ancestry match the cranial-support vocabulary. The generator then
selects 137 exact source names: 49 curves and 88 meshes. Missing exact names are
a hard build failure.

## Attribution and licences

The local atlas documentation requires the following model attributions:

- “BodyParts3D - The Database Center for Life Science - CC-BY-SA 2.1 Japan”
- “Z-Anatomy - The libre 3D atlas of anatomy - CC-BY-SA 4.0”

These exports are derivatives. Attribution and ShareAlike obligations must be
preserved when the geometry or database derivative is distributed.

The bundled README also lists “Cranial Nerves and Foramina - by University of
Dundee, CAHID - CC-BY 4.0” among referenced, included, and adapted models.
Because the local source does not provide a per-object provenance ledger, retain
that attribution for the cranial-nerve exports pending a definitive source
review.

### Inner-ear licence hold

The same bundled Z-Anatomy README separately lists “Anatomy of the Inner Ear -
by University of Dundee School of Medicine - CC-BY-NC-SA 4.0” among references,
included works, and adaptations. The current local files do not provide a
per-object provenance ledger sufficient to prove which selected ear meshes are
or are not derived from that work.

Consequently:

- `middle_inner_ear_bilateral_v3` is
  `HOLD_FOR_INNER_EAR_LICENSE_REVIEW`.
- `cranial_support_registered_assembly_v3` inherits the same hold because it
  contains that ear geometry.
- Neither package should be shipped for hospital, commercial, or other
  potentially non-qualifying use until counsel/source owners confirm provenance
  and licence compatibility or the ear geometry is replaced with a verified
  source.
- This publishing repository therefore omits both USDZ binaries and both
  runtime-manifest records; their names remain only as auditable held
  source-build records.

This notice is a conservative provenance control, not legal advice.

## Geometry processing

Every selected source object is evaluated from the atlas scene and transformed
by the same centre used by the existing v2 cerebral-cortex registration:
`[0.0, 0.008782502, 1.640712023]` metres. Mesh geometry is preserved. Curve
tessellation is capped at source resolution 6 and bevel resolution 2 to avoid
unnecessary runtime density, but curve paths are not redrawn or bridged.

The build does not:

- synthesize missing anatomy;
- mirror a missing side;
- relabel helper geometry as anatomy;
- bridge discontinuities;
- infer foramina, sutures, maxillary sinuses, or separate semicircular canals;
- use an AI-generated image as anatomical geometry;
- include patient data or patient-derived imaging.

Exact source semantics are stored on each USD mesh as
`userProperties:anatomical_name`. The generator also records direct source
collections, audited and output triangle counts, output dimensions, and assigned
material in `research/cranial_detail_source_qc_v3.json`.

## Use boundary

The source atlas and these derivatives are educational reference anatomy. They
are not clinically validated segmentations and are not suitable for diagnostic,
planning, navigation, rehearsal, measurement, or treatment decisions. A
hospital-quality product needs separate clinical validation, human-factors
testing, software lifecycle controls, privacy/security review, device/regulatory
assessment, and verified rights for every included source.
