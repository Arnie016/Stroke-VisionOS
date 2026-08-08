# Asset validation record

Validated on 2026-08-08 in macOS using Apple's USD tools and RealityKit.

## Catalog integrity

- 65 runtime USDZ packages: 36 v2 and 29 prototype v1.
- 65 unique manifest IDs, basenames, paths, and SHA-256 payloads.
- Six manifests: five v2 module manifests and one prototype manifest.
- No missing manifest-backed packages.
- `stroke_kit_asset_gallery.usdz` intentionally excluded.
- Runtime payload: 180,427,924 bytes (172.07 MiB).
- Largest package: 32,482,833 bytes; no selected file exceeds 50 MiB.
- Fresh validation of the exact repository copies with
  `/usr/bin/usdchecker --arkit --strict`: 65 pass, 0 fail.

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

## Viewer integration evidence

The complete 65-asset catalog was copied byte-for-byte into a local visionOS
simulator viewer and visually checked for the layered-head, cranial-vascular,
and animated blood-flow selections. This validates the packages and the local
viewer integration used during asset production; it does not claim that an
Xcode application is already scaffolded in this repository.

Detailed module reports are retained in [`validation`](validation).

## Remaining gates

- Specialist clinical and human-factors review.
- Physical Apple Vision Pro visual, interaction, comfort, and accessibility
  review.
- On-device RealityKit Trace profiling of the final assembled experience.
- Patient-facing language and sequencing approval.
