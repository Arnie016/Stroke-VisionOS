# Inhabit the Flow V3 — branching corridor receipt

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — bounded local Simulator composition and motion gate**.

This receipt does not claim XCAT installation, wearer comfort, hand interaction,
medical-specialist review, clinical validity, CFD, patient-specific anatomy, or
a live `gpt-realtime-2.1` provider call.

## Bounded change

- Replaced the visible straight cutaway wall with a native inward-facing main
  corridor and two downstream branches. The geometry begins behind the wearer;
  the app does not create or move a camera.
- Reused the authored biconcave cell only as a visual prototype. Eighteen clones
  move, tumble, and deform along deterministic frontal and neighboring paths.
- Replaced capped segment/cone direction marks after visual rejection. The
  accepted implementation uses one continuous route mesh plus sparse V-shaped
  chevrons.
- Added three explicit states: Both paths, Frontal route, and Neighbor route.
  Selecting a route recomposes that branch around the stationary observation
  origin and makes the other route visually silent.
- Added a frontal constellation/tissue field and a separate neighboring tissue
  field. Both are explicitly illustrative and not segmentation.
- Kept the optional family guide off by default. Without its loopback proxy the
  control is disabled and the exact caption remains available.

## Source and contract proof

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (50/50).
- `git diff --check`: PASS.
- Source SHA-256:
  - `RBCJourneyScene.swift`: `c2041b1c849e10975b24133d0a38fba05c5af95671099e71061e72372f45cbeb`
  - `RBCJourneyModel.swift`: `be93b8a4ad9bdf4084209875955d347c09f2c19e568b5b629ed814c44392e1d7`
  - `RBCJourneyHUD.swift`: `2194acf6912e99d9e589a29fd45c422f68f415bddc00184dffd469610762e845`
  - `RBCJourneyImmersiveView.swift`: `7a0f376a353e09a70c21b4359ea7b7bdee8a8f137f89ec5cc2b81ec6ccb8ebe4`
  - `verify_contract.py`: `890478163ef17be9d5e1c19e16146e8035c1cb47b97fdf7982dd262f87cfdeb9`

## Build and launch proof

- Xcode: 26.6; SDK: `xrsimulator26.5`; target remains visionOS 2.0+.
- Generic unsigned Simulator build: `** BUILD SUCCEEDED **`.
- App bundle: 54,616 KiB.
- Executable: Mach-O universal `arm64` + `x86_64`.
- Installed and launched on the booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- Physical device `XCAT` was listed as `unavailable`; no device proof is claimed.

## Reviewed composition proof

- Overview: `115-branching-corridor-overview-accepted.png`
  (`b5253bb3e9e1f4539fb79581fe4690d54d6209daa419baae3913f9d13499c43c`)
- Frontal transfer: `118-branching-corridor-frontal-transfer-final.png`
  (`f2ebf9fdfcac37375b5c3d2527129c2a394e97a024bec4539353b406223b122b`)
- Neighbor transfer: `119-branching-corridor-neighbor-transfer-final.png`
  (`1e963a75b58a2b83833fd65d48e9889f59a738429df8e18c757684632269ccfd`)

Visual review accepted only the final continuous-mesh states. Earlier local
candidates were rejected for a distant fork, bead-like capped segments,
oversized imported streaks after transfer, or a clipped title. They are not
promotion artifacts.

## Motion proof

- Local recording: `120-branching-corridor-motion.mov`, H.264, 3840×2160,
  24.353333 seconds, 1,462 frames, 44,256,125 bytes, SHA-256
  `915dd655e6c104c45ac58d8c76a14e8db3091d931dad4e5e02115d0e92f9f694`.
- Eight frames sampled every three seconds produced eight distinct SHA-256
  values, confirming visible state change rather than a repeated still.
- Curated contact sheet: `121-branching-corridor-motion-contact-sheet.png`,
  SHA-256 `9ebe6b07dbe35a3c82897df421a675118035cf32829299ce87db7039eb69cf8c`.
- The 44 MB movie is deliberately excluded from the Git commit. The contact
  sheet is the promoted, reviewable repository artifact.

## Remaining gates

1. Replace the smooth translucent wall with provenance-tracked endothelial PBR
   microtexture and validate scale/UV fidelity.
2. Test transfer comfort, text placement, hand selection, and frame pacing on
   awake/unlocked XCAT with a wearer.
3. Obtain specialist review for route language and illustrative region fields.
4. Run the optional family guide only with explicit provider-test approval;
   verify returned caption hash, heard audio, cost, and interruption behavior.
5. Treat any future Mantaflow/Houdini asset as offline visual authoring only
   unless a separately reviewed scientific model supports stronger claims.
