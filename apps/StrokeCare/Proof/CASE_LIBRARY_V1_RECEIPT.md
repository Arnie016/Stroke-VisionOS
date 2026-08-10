# Case Library V1 receipt

Date: 2026-08-10 (Asia/Singapore)

Branch: `feature/case-intake-cabinet-v1`

Base: `origin/feat/teaching-imaging-drawer` at `ce56d25`

## Outcome

The doctor-presenter route now opens a larger fictional case library before
the room-scale case review. CASE-078 is the only implemented teaching case.
CASE-077 and CASE-079 are selectable visual previews and do not expose an
entry action. The patient/family route continues directly into its educational
experience and does not pass through the clinician archive.

The selected case uses native visionOS glass, a locally authored warm fiber
overlay, a clear History / Relationships / Timeline hierarchy, and one
explicit `Enter case` threshold. Portraits are abstract SwiftUI geometry, not
real people or claimed patient likenesses.

## Verifiers

- `python3 Tests/verify_case_library.py` -> `CASE_LIBRARY_CONTRACT=PASS`
- `python3 Tests/verify_contract.py` -> `STROKE_CARE_CONTRACT=PASS`
- Generic visionOS Simulator Debug build, unsigned -> `** BUILD SUCCEEDED **`
- Product: `/tmp/stroke-case-library-derived/Build/Products/Debug-xrsimulator/StrokeTime.app`
- Deterministic launch argument: `--proof-case-library`
- Booted Simulator: Apple Vision Pro, xrOS 26.5,
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`
- Captured frame: `Proof/96-case-library-v1-simulator.png`, 3840 x 2160,
  SHA-256 `451e6831f10c23d72cb643ccf9aae897bca6fdce603d23e95b6cbdc06e2acb5a`

## Material boundary

`TechnicalArt/CaseCabinetV1` contains a project-authored PSD source plus
base-colour, height, and roughness studies. Only the 512 px grayscale grain in
`CaseCabinetGrain.imageset` is bundled. Native visionOS material provides the
glass behavior. The height and roughness studies are reserved for a later
RealityKit cabinet pass and are not claimed as an integrated PBR material.

## What this proves

- The new SwiftUI case-library code compiles for the visionOS Simulator.
- The asset catalogue compiles and the runtime grain resolves.
- The deterministic preview launches and appears in a Simulator frame.
- The current single-case clinical/privacy boundaries remain in source.

## What this does not prove

- No XCAT build, install, launch, gaze/pinch, wearer comfort, or text legibility
  proof was performed for this branch.
- The peripheral cases are not implemented clinical scenarios.
- No portrait diversity, likeness, clinician, or clinical-language review is
  claimed.
- The room-scale procedural cabinet has not yet received this texture pack.
