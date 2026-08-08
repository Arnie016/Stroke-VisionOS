# GitHub asset intake — Stroke-VisionOS PR #2

Reviewed: 2026-08-08 17:21 SGT  
Pull request: `Arnie016/Stroke-VisionOS#2`  
Base: `origin/main` at `9f8af3e`  
Reviewed head: `9453176e4ccbe87ba7c23f143becc0c67d1caefa`  
State: open draft. Eight exact files were copied into the local Stroke Care
prototype from the reviewed commit; the PR was not merged or modified.

## Decision

The asset contribution is technically substantial and much better organized
after the addition of `MASTER.md`. The 65-file source catalog remains intact in
its own repository. Stroke Care now bundles only the eight-file shortlist below
and loads the registered-v2 subset at runtime; this is a local integration test,
not a public-distribution, clinical, or device-performance clearance.

The current pull request contains 65 manifest-backed USDZ packages (36 v2 and
29 prototype-v1), totalling 180,427,924 bytes. A Git-object hash scan found no
byte-identical USDZ packages. The duplicates are semantic: component geometry
is intentionally repeated inside convenience assemblies. `MASTER.md` now
describes those exclusions and requires transitive component/assembly checks.

## Important mismatch to fix before integration

The current Stroke Care story is malignant ischemic swelling leading to a calm
discussion of decompressive hemicraniectomy. `MASTER.md` currently models
decompressive craniectomy only beneath its intracerebral-haemorrhage branch,
while its ischemic-thrombectomy invariant disables `edema_swelling` and all
open-cranial content.

Add a distinct `malignantIschemicEdema` education pathway (or an explicitly
reviewed ischemic-swelling branch) before using the master state machine. It
must remain separate from both routine thrombectomy and ICH management. This is
the only blocking content-model mismatch found in the new update.

## Stroke Care intake lanes

### A — candidate runtime set for the current three-act story

These eight packages form the smallest useful high-detail intake. They passed
an independent `/usr/bin/usdchecker --arkit --strict` check from the exact PR
head reviewed above.

| Act | Asset | Role | Gate |
| --- | --- | --- | --- |
| Orient | `brain_anatomy_realistic_v2.usdz` | Dominant anatomy | Specialist review; lazy-load/profile |
| Orient | `cerebral_arteries_realistic_v2.usdz` | Arterial context | Laterality and branching review; ShareAlike notice |
| Orient | `ischemic_mca_clot_v2.usdz` | Conceptual right-M1 marker | Never use as a measurement |
| Pressure | `skull_semantic_realistic_v2.usdz` | Constraint/context layer | Approximate cross-source registration; not a planned opening |
| Pressure | `edema_swelling.usdz` | Conceptual pressure cue | Original project asset; licence and clinical review pending |
| Make space | `dura_mater_cutaway_conceptual_v2.usdz` | Non-graphic layer reveal | Illustrative window, not an incision |
| Make space | `craniotomy_bone_flap.usdz` | Bone-opening teaching cue | Correct end-state wording for craniectomy required |
| Make space | `dural_patch.usdz` | Expansion-purpose cue | Use only in the reviewed neurosurgical branch |

Combined package payload: 33,380,866 bytes (31.83 MiB) and 383,295 triangles.
Never show or preload all eight together. Approximate visible geometry by act is
323,077 triangles for Orient, 271,094 for Pressure, and 262,720 for Make space.
Keep the existing procedural scene as the instant-loading fallback, lazy-load
the hero meshes after entry, and add lower-detail proxies before making these
the default on XCAT.

Exact independently checked SHA-256 payloads:

```text
brain_anatomy_realistic_v2       6b02ec90e808d3e50a84a9b75239390be6ca8c5903c7212b96251b633e4f0622
skull_semantic_realistic_v2      4f72afb1f9452cfdeb3263636da9805e1a1b40a6838660858ff4188f5ed7ce7d
cerebral_arteries_realistic_v2   9bc696f7b85e3dcccf0a45907cd91dbc5cc7d79b773c0fa2ac5bbbf827108aeb
ischemic_mca_clot_v2             ba07bfb3d13a2ba73d951eda1266500fec037ad416ae72886ed4d4759ae854f0
dura_mater_cutaway_conceptual_v2 6411ecc9e58dc2f3322459cab8cea13d6c7e9fd532a33a88b84eb3cb7985b809
edema_swelling                   2aa25321a2680f60d2ef73df3d6a1cb84d0e4c17aa9cf6a2c99e4d22cc546f73
craniotomy_bone_flap             ab01792dafe53b636b71a40e53ea75af908afa9f5ab547b11548828925a6134d
dural_patch                      269402dbc1139a79aef420324d59e8dcdaf4da84f96df6b2c5325fb930527f74
```

### B — optional microscope lesson, not the main path

- `artery_wall_cutaway_v2.usdz`
- `artery_interior_bloodflow_v2.usdz`
- `cerebral_bloodflow_animation_v2.usdz`
- `circle_of_willis_flow_overlay_v2.usdz`
- `red_blood_cells_closeup_v2.usdz`
- `microcirculation_arterial_venous_v2.usdz`

These belong in a visibly scale-separated vignette. Use qualitative cues only;
do not label them as pressure, perfusion, velocity, CFD, or patient physiology.

### C — reference/replacement assemblies; do not ship beside their parts

- `thrombectomy_registered_hero_v2.usdz`
- `layered_head_cutaway_registered_v2.usdz`
- `meningeal_partitions_atlas_v2.usdz`
- `dural_sinuses_jugulars_realistic_v2.usdz`
- `head_neck_veins_expanded_realistic_v2.usdz`
- `cranial_vascular_registered_assembly_v2.usdz`
- `artery_cutaway_complete_v2.usdz`
- `cerebral_bloodflow_teaching_set_v2.usdz`
- `thrombectomy_device_set_educational_v2.usdz`

Treat each as a replacement view. Loading an assembly with any contained part
would create z-fighting, duplicate memory, and ambiguous interaction ownership.

### D — fallback/prototyping only

Keep v1 equivalents such as `brain_structures_generic`, `head_skin_generic`,
`skull_cranium_generic`, `cerebral_arteries_generic`, `ischemic_lvo_clot`, and
the v1 thrombectomy devices for fast sequencing tests. Do not mix them into the
registered v2 head frame. The three selected v1 swelling/open-cranial files are
available to the technical-art pipeline but disabled at runtime. The first
Simulator integration render proved that their prototype frame does not align
with the registered v2 head. Showing that composite would be misleading, so the
app uses schematic cues until a reviewed Blender/Houdini fit or registered
replacement exists.

### E — hold outside the current product slice

Room props, patient/staff figures, venous/jugular assemblies, generic
thrombectomy-device close-ups, ICH/evacuator/EVD assets, closure/dressing props,
and access-route equipment remain catalogued but out of the current
depth-first patient explanation. They are not deleted and can support a later
clinician-training module.

## Visual review

- The brain and conceptual dura are strong hero candidates and fit the calm,
  realistic direction.
- The arterial tree is visually dense and contains many abrupt open branch
  ends. Use focal reveal/highlight rather than showing the whole tree at full
  salience, and require neuroradiology review.
- The open-skull preview reads as a fragmented shell rather than a controlled
  surgical opening. Do not use that composition patient-facing. Prefer the
  clean bone-flap/dura-purpose sequence already present in Stroke Care.
- The clot is correctly tiny at anatomical scale. Reveal it with a restrained
  locator/halo and camera focus; do not enlarge it without an explicit
  magnified-view label.

## Licence and proof boundaries

- The PR states that 43 packages are original project work with no blanket
  repository licence selected. Public GitHub visibility is not an extra licence
  grant. Resolve distribution permission before shipping the three selected v1
  assets and the original-project `ischemic_mca_clot_v2` package.
- NIH/HRA derivatives require CC BY 4.0 attribution. Z-Anatomy/BodyParts3D
  derivatives require the recorded ShareAlike notices. Mixed assemblies inherit
  both relevant obligations.
- The PR reports 65/65 strict USD-checker passes and 36/36 RealityKit load
  passes. This intake independently rechecked only the eight shortlisted files.
- GitHub currently shows only the GitGuardian check as successful; it does not
  show a visionOS build, device profile, or automated clinical-content gate.
- Technical validation is not clinical validity. Specialist, patient-language,
  accessibility, physical-device performance, and wearer-comfort gates remain.

## Repeatable review protocol for future GitHub updates

1. Fetch the PR head and record the exact commit.
2. Review both the incremental change and `origin/main...PR` three-dot diff.
3. Reconcile all manifests against paths, sizes, and hashes.
4. Scan byte hashes for exact duplicates.
5. Re-run semantic component/assembly exclusion review.
6. Re-check licence, provenance, clinical wording, and pathway ownership.
7. Run strict USD validation on every candidate runtime file.
8. Update this receipt before copying or importing assets.

This protocol applies whenever a GitHub update is brought into this task. It is
not evidence of automatic monitoring between task runs.
