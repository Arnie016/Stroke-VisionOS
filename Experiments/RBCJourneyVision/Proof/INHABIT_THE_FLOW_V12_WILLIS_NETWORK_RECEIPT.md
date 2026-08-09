# Inhabit the Flow V12 — Circle of Willis network-to-branch receipt

Date: 2026-08-10

Verdict: **PASS — local contract, generic visionOS Simulator build, and bounded Simulator composition/motion proof.** This is not XCAT, wearer-comfort, hand-interaction, clinical, or teaching-value proof.

## What changed

- Replaced the destination's diagram-like presentation with a room-scale, continuous vascular network around a stationary wearer.
- Authored 26 continuous native RealityKit tube paths: the paired internal-carotid, basilar, communicating, anterior, middle, and posterior route families plus smaller downstream branches.
- Added 16 small tangent-aligned flow fronts that travel along the routes. Communicating connectors deliberately have no directional arrows because this generic lesson does not claim a fixed collateral-flow direction.
- Added one user-controlled reading on the existing information surface: **Whole circle**, **Anterior**, or **Posterior**. Only one focus is active at a time; choosing a focus dims rather than deletes the surrounding network.
- Kept the wearer fixed. This slice does not move the camera or force a ride.
- Kept the original imported Circle asset for provenance/portal use but hid its duplicate destination rendering, which competed with the new continuous network.

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS`, **59/59** checks.
- `xcodebuild -project RBCJourneyVision.xcodeproj -scheme RBCJourneyVision -sdk xrsimulator -destination 'generic/platform=visionOS Simulator' -derivedDataPath /tmp/rbc-willis-network-derived CODE_SIGNING_ALLOWED=NO build`: `** BUILD SUCCEEDED **`.
- Toolchain: Xcode 26.6, build 17F113.
- Product: universal x86_64/arm64 visionOS Simulator Mach-O; app bundle 55,848 KiB.
- Deterministic proof flags:
  - `--proof-willis-route-overview`
  - `--proof-willis-route-anterior`
  - `--proof-willis-route-posterior`

## Accepted proof

| Artifact | SHA-256 | What it proves |
|---|---|---|
| `147-willis-network-overview-a-accepted.png` | `dc10e3972940582897f65a2db520468c0cdf6096e0073eed41c2ae429ba15807` | Overview composition with the network surrounding the wearer. |
| `148-willis-network-overview-b-accepted.png` | `dfd3416afeacc5392bba3581e9ffd00332e2736cd6232e704cc8f3d8ff09bd7e` | A later overview frame; differing hash and visible front positions establish non-static motion. |
| `149-willis-anterior-focus-accepted.png` | `328317d72254914305e6243fd192d129b057ad6fa96ea5e235e647f2f0826bb4` | User-selected anterior reading with the posterior family still present but visually receded. |

## Source integrity

- `RBCJourneyModel.swift`: `76dee344e36693d7b00fce1ea11f51abf8f8b2b7f7ceaa92b8903ca80d8c059c`
- `RBCJourneyHUD.swift`: `1efaad12b726566b1acf464d2f6cfbe1cdf6854f30c9b7807cdf49521e46d679`
- `RBCJourneyImmersiveView.swift`: `dc8259f6e4c74f4b23c7c2e4da5431fa9b807da587089c0e84cf8455315dec14`
- `RBCJourneyScene.swift`: `0d3f1ef4f23e220659067fb43659a1c6429ff964d72cf0068670ff84ad40a164`
- `verify_contract.py`: `b79cc9c3dd43daa4dcf409c5186041bc6379405863deb3b39ef5d6ea49a8bd5f`

## Honest rejection trail

- Rejected the first pass because the imported asset and native route system produced two competing networks, orange cuff-like markers, and oversized diagram arrows.
- Rejected stacked-cylinder route geometry because seams made the vessels read as manufactured tubes.
- Promoted continuous UV-capable meshes, smaller fronts, stronger depth separation, and twelve secondary branches only after the A/B overview and selected-focus frames were legible.
- Rejected working captures remain outside the commit boundary.

## Medical and proof boundary

This is a qualitative, generic anatomy lesson. It does **not** represent a patient's anatomy, complete population variation, universal collateral-flow direction, perfusion, pressure, clot dynamics, CFD, diagnosis, or treatment advice. Wording remains constrained by the project's existing NCBI Circle of Willis and cerebral-circulation canon.

These images prove only local Simulator rendering and a deterministic state change. They do not prove physical depth, gaze/pinch targeting, comfort, accessibility, clinical correctness, or educational effectiveness on XCAT.

## Next physical gate

On XCAT, a wearer should choose **Whole circle → Anterior → Posterior**, confirm that the moving fronts remain readable at depth without chasing the eyes, and report whether dimmed context helps orientation or creates visual noise. No further complexity should be promoted before that judgment.
