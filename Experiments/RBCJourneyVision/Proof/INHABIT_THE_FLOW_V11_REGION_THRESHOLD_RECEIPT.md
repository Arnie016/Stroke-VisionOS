# Inhabit the Flow V11 — Region Threshold

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — bounded native implementation, 58/58 source-contract checks,
generic visionOS Simulator build, deterministic mid-transition composition,
and automatic arrival in the selected region.** XCAT, physical gaze/pinch,
wearer comfort, specialist review, patient anatomy, CFD/perfusion, and clinical
or teaching value are **NOT RUN / NOT PROVEN**.

## What changed

Region selection is no longer an instantaneous software swap. Every card in
the existing Region Portal Reel now calls a model-owned request phase. While a
destination is pending:

- the chosen card says **Opening…**;
- competing destinations are temporarily disabled;
- the previous scene yields without moving an app camera;
- four broken, depth-staggered laminar contours and 32 small tangent fibers
  expand around the fixed observation origin;
- the selected region begins resolving behind that threshold; and
- after 1.45 seconds, the model commits exactly one active destination.

The transition HUD uses one title and one short sentence: **The room moves. You
stay.** Reduce Motion uses a 420 ms nearly static threshold. The pending state
is task-keyed and destination-checked before commit, so a cancelled or replaced
task cannot arrive in a stale region.

## Rejected compositions

The first visual pass used three complete bright ellipses and 28 radial bars.
It read as a timer dial over an empty dark scene, so it remained in `/tmp` and
was not promoted. The accepted pass breaks each contour into four uneven arcs,
staggers them in depth, shortens and turns the fibers tangentially, and reveals
the incoming region behind the opening.

One automatic-arrival screenshot was captured during Simulator launch warm-up
and was entirely black. It was rejected and overwritten only after the same
running process visibly completed the transition. This receipt does not treat
a black or stale capture as acceptance evidence.

## Deterministic routes

- Mid-transition: `--proof-region-transition-7
  --proof-region-transition-progress-55`
- Automatic completion: `--proof-region-transition-7`
- Existing direct destination route remains available as `--proof-region-7`.

The progress flag holds visual progress only for Simulator inspection. Without
it, the ordinary asynchronous completion path runs.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 58/58 checks**.
- Generic unsigned visionOS Simulator build: **BUILD SUCCEEDED**, Xcode 26.6,
  XRSimulator 26.5.
- Product: universal Mach-O (`x86_64`, `arm64`), 55,612 KiB at
  `/tmp/rbc-region-threshold-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`.
- Booted Simulator: Apple Vision Pro
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- No provider call, cloud compute, paid generation, new asset, app camera, or
  Stroke Care source was used.

## Accepted evidence

- `145-region-threshold-cortical-mid-accepted.png`
  - SHA-256: `22fb278631e230b0cce855d7c232f1f115a41d27a223e17f9c476a8814fab25d`
  - Shows the 55-percent threshold, concise opening copy, broken contours, and
    Cortical layers beginning to resolve behind the opening.
- `146-region-threshold-cortical-arrival-accepted.png`
  - SHA-256: `11f09f39e8a2e64333a80efe4bcafe2808303f601d94a0af1d98bdf08a9c024a`
  - Captured from the same `--proof-region-transition-7` launch after its live
    delayed commit. The threshold is gone and exactly one Cortical layers room
    is active.

These images prove Simulator composition and the model's automatic arrival
path. They do not prove physical depth, peripheral comfort, device frame rate,
or gaze/pinch quality.

## Source hashes

- `RBCJourneyModel.swift`:
  `c205a442fc73610c462c25240a7d60ce65cae9609cf395396c860269f8700037`
- `RBCJourneyHUD.swift`:
  `115b5da0a197d910e9a7947f1bfcdf1711fabe6ee0a3b2e1e66272d76504c160`
- `RBCJourneyImmersiveView.swift`:
  `89816238fcfa47b6ddb120fe14764fd9497fd91af60302d933fe8f03f3a86e94`
- `RBCJourneyScene.swift`:
  `85a8560f6c988f7a79f9791a113c0833b19234cb1842cdbd1e6fca4eb54c9df9`
- `verify_contract.py`:
  `0ef5b294962009dcbc8549ae07d5bd455c9f95af07538eedce9b59a3d91f016a`
- `README.md`:
  `3ed3cae1a43e1299c3786e19e311ad75acee5ff54a213421dbc75a1d0ce65c7d`

## Next honest gate

On XCAT, choose a region from the reel, keep the head still, and judge whether
the broken contours feel like the surrounding room yielding or like a flat
ring. Repeat with Reduce Motion. Record legibility, peripheral comfort,
perceived depth, and whether the 1.45-second dwell feels intentional before
changing timing or scale.
