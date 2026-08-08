# Asset validation record

Validated on 2026-08-08 in macOS using Apple's USD tools and RealityKit.

## Catalog integrity

- 108 release runtime USDZ packages: 65 original plus 43 non-held v3 packages.
- 108 unique release-manifest IDs, basenames, and paths. All 43 v3 records carry
  verified byte counts and SHA-256 values; the original package validation
  retains its payload-integrity evidence.
- Nine manifests: five v2, one prototype-v1, and three v3 module manifests.
- No missing manifest-backed packages.
- `stroke_kit_asset_gallery.usdz` intentionally excluded.
- Runtime payload: 262,040,610 bytes (249.90 MiB).
- Largest package: 32,482,833 bytes; no selected file exceeds 50 MiB.
- The original 65 repository packages passed
  `/usr/bin/usdchecker --arkit --strict`: 65 pass, 0 fail.
- Fresh strict validation of the 43 exact v3 publishing copies:
  `/usr/bin/usdchecker --arkit --strict`: 43 pass, 0 fail.

## v2 technical gate

- `/usr/bin/usdchecker --arkit --strict`: 36 pass, 0 fail.
- RealityKit `Entity.load(contentsOf:)`: 36 pass, 0 fail.
- Nonzero RealityKit `ModelComponent` instances: 664.
- `cerebral_bloodflow_animation_v2.usdz`: 26 entities and 24 animation
  resources; authored duration four seconds.

## Prototype gate

- Repository-copy `/usr/bin/usdchecker --arkit --strict`: 29 pass, 0 fail.
- RealityKit load probe: 29 pass, 0 fail.
- Prototype packages remain clearly labelled as low-poly teaching assets.

## v3 detail gates

- Neural detail: 15/15 strict USD PASS and 15/15 RealityKit load PASS with
  nonzero renderable content.
- Cranial detail source build: 18/18 strict USD PASS and 18/18 RealityKit load
  PASS. The release tree includes only the 16 non-held packages; the ear package
  and ear-containing complete assembly are omitted.
- Intracranial micro detail: 12/12 strict USD PASS, 12/12 RealityKit load PASS,
  and dedicated preview coverage PASS for 12/12.
- Technical and preview success is not clinical validation. Micro-detail
  patient-facing interpretation remains HOLD pending persistent
  magnification/conceptual warnings and specialist review.
- Detailed evidence is retained in
  [NEURAL_DETAIL_ASSET_VALIDATION_V3.md](validation/NEURAL_DETAIL_ASSET_VALIDATION_V3.md),
  [CRANIAL_DETAIL_ASSET_VALIDATION_V3.md](validation/CRANIAL_DETAIL_ASSET_VALIDATION_V3.md),
  and
  [INTRACRANIAL_MICRO_ASSET_VALIDATION_V3.md](validation/INTRACRANIAL_MICRO_ASSET_VALIDATION_V3.md).

## Viewer integration evidence

The complete release catalog was also exercised in the separate local
production viewer used to make these assets. Its final Apple Vision Pro
simulator build contained **108 models and 9 manifests** in both the local and
installed app bundles. Both bundles passed strict code-sign verification;
source-to-local-to-installed comparison found zero model or manifest byte
mismatches; and both held packages were absent. Loaded-content captures were
visually checked for a neural-detail assembly, the cranial-nerve assembly, and
the blood-brain-barrier micro vignette. The micro view retained its persistent
“not to anatomical scale” warning.

That production viewer is not the repository-owned Xcode application scaffold,
which does not exist yet. The result validates package integration in the local
simulator tool; it does not establish physical Vision Pro performance,
anatomical or clinical validity, hospital readiness, or implementation of the
planned repository experience.

Detailed module reports are retained in [`validation`](validation).

## Remaining gates

- Specialist clinical and human-factors review.
- Physical Apple Vision Pro visual, interaction, comfort, and accessibility
  review.
- On-device RealityKit Trace profiling of the final assembled experience.
- Patient-facing language and sequencing approval.
- Inner-ear source/licence clearance or replacement before either held build
  package can enter a release tree.
