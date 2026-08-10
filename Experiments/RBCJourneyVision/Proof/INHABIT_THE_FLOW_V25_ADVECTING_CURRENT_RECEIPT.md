# Inhabit the Flow V25 — Advecting Current Receipt

**Verdict:** `PASS_SIMULATOR_RENDER_AND_BUILD_GATE` — limited to local visionOS Simulator composition, deterministic surface-motion evidence, source contract, and compilation. This is not physical-device, wearer-comfort, clinical, patient-specific, or CFD proof.

**Reviewed:** 2026-08-10T04:46:32Z

## Promoted slice

- The inhabited lumen now carries **10 continuous rounded current volumes** built from the existing route curves. The implementation does not move cards, beads, arrows, or cone-front assemblies through the vessel.
- One generated **256 × 16 opaque luminance texture** is shared by all current materials. RealityKit advances its UV offset downstream; the material tint supplies the blood-red color. Texture and meshes are created once, outside the frame loop.
- The route keeps **10 small fixed chevrons** as a redundant direction cue and creates **zero moving-front entities**.
- The 42 authored biconcave cells are distributed as 18 shared-stem cells, 12 frontal-branch cells, and 12 neighboring-branch cells. This avoids duplicating two full trains on the common stem.
- Route selection still weights the shared stem and chosen branch; the treatment is qualitative choreography, not velocity, pressure, wall-shear, hematocrit, or cerebral perfusion measurement.

## Deterministic visual evidence

Both stills hold the same route, lesson, geometry, and canonical journey phase. Only the texture pulse phase differs:

- [`260-advecting-current-pulse-p18.png`](260-advecting-current-pulse-p18.png) — `--proof-flow-ride --proof-flow-phase-18 --proof-flow-pulse-18`
- [`261-advecting-current-pulse-p68.png`](261-advecting-current-pulse-p68.png) — `--proof-flow-ride --proof-flow-phase-18 --proof-flow-pulse-68`
- [`262-advecting-current-pulse-ab-contact-sheet.png`](262-advecting-current-pulse-ab-contact-sheet.png) — side-by-side comparison. The continuous volumes remain registered while their broad highlights occupy different downstream positions.
- [`264-advecting-current-live-motion-6s.mp4`](264-advecting-current-live-motion-6s.mp4) — 6.000 s, H.264, 1920 × 1080, 30 fps, 180 frames, 830,178 bytes. This is a local Simulator motion receipt, not a measured frame-rate claim.

Artifact SHA-256:

```text
db81a6c5c85b4c50fbe0bc8cbe0266c7acf9c01bbbb5e641a51d742ce3389ffb  260-advecting-current-pulse-p18.png
32bc4edcf20dba7e01cb8162ac3bf375fa6c4ea4e40dc35760658332f551dfbf  261-advecting-current-pulse-p68.png
4d758eba552beedee263d948e99f5bd8152578199a56eceeb6115dbf18a59cb7  262-advecting-current-pulse-ab-contact-sheet.png
1e5579cf6abf0f9e8b23f92fc9b59040ed69bf2a26ba65cbc3e48466c7c32065  264-advecting-current-live-motion-6s.mp4
```

The Simulator's retained head pose placed the route low in these captures. The app does not move a custom camera, and no production placement was distorted to compensate for that Simulator-only pose.

## Rejection ledger

The following exploratory captures remain unpromoted and are not branch evidence:

- `250`: segmented box bands read as flat red slabs.
- `251`: crossed sheet ribbons repeated the rejected card-like failure.
- `252`: moving head/tail/wake assemblies read as droplets and tentacles.
- `253`: rounded geometry removed those artifacts, but motion was still too dependent on discrete fronts.
- `254` / `255`: texture-driven material opacity invalidated the immersive composition and produced black captures.
- `256` / `257` / `258`: opaque texture restored the scene, but pulse contrast was too weak to certify from the matched stills.

Only the continuous opaque-luminance route shown in 260–264 is promoted.

## Verification

- `python3 Tests/verify_contract.py` → **73 / 73 PASS**, `RBC_JOURNEY_CONTRACT=PASS`.
- Isolated exact-commit verifier: `4d54993df7e6d3cbbab6f1e3c0112eedc23ce77b`.
- Generic unsigned visionOS Simulator build using XRSimulator 26.5 → `** BUILD SUCCEEDED **`.
- Exact-commit built app: 57,896 KiB; universal Simulator executable contains arm64 and x86_64.
- `git diff --check` → clean before staging.
- Existing compiler warning remains: the pre-existing local `outlineMaterial` value near `RBCJourneyScene.swift:2157` is unused. It is unrelated to this slice.

## Physical-device gate

At review time, `XCAT` was `available (paired)` over CoreDevice (`613CC48C-A6AD-5170-A238-D518B6012491`). The app has **not** been installed or visually judged on XCAT. A signed build remains blocked because Xcode has no signed-in account/provisioning profile for `com.arnav.RBCJourneyVision`; Simulator success does not satisfy that gate.

The next safe action is to sign into **Xcode → Settings → Accounts** for team `VV6YGTA587`, then rerun the signed XCAT build/install/launch and capture wearer feedback separately.

## Claim boundary

This is an artistic, anatomy-oriented spatial teaching prototype using qualitative route choreography. It does not simulate non-Newtonian blood rheology, predict treatment, reproduce a patient's anatomy, validate stroke physiology, or replace clinician explanation. Medical wording and anatomy anchors remain pending specialist review where marked in the project.
