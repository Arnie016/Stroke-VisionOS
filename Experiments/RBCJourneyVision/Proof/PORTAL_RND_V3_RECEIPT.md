# Portal R&D v3 receipt

Date: 2026-08-09

Status: **PASS — source contract, generic arm64 Simulator build, focused-lens composition, and entered-region composition**

## Outcome

- Removed the duplicated brain model from the forward view. The full-resolution
  cortex is now the room around the wearer.
- Loaded the cortex, deep structures, ventricles, cerebral arterial tree,
  Circle routes, teaching clot, and flow animation into one expanded atlas.
- Kept the 6.1 MB head-and-neck vascular assembly bundled for provenance but
  disabled its room-scale rendering after it failed the eye-line gate.
- Added six optional world-anchored orientation cards. They are simplified
  directions, not lobe segmentation.
- Limited portal state to Lumen, Circle, and Exchange. Each portal uses a named
  USD entity direction projected to a 1.26 m interaction sphere.
- Focus and transfer now change the top title, paragraph, fact, and saved
  learning key to the actual portal lesson.
- Added a faint full cerebral arterial-tree underlay behind the enlarged Circle
  route so the transfer reads as an anatomical layer rather than a flat diagram.

## Deterministic checks

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` with 36 checks.
- Build: `** BUILD SUCCEEDED **` using Swift 6, `xrsimulator26.5`, unsigned
  generic arm64, derived data at `/tmp/rbc-journey-portal-v3-derived`.
- Product: `/tmp/rbc-journey-portal-v3-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`.
- Product size: 50,672 KiB allocated.
- Binary: Mach-O 64-bit arm64.
- Bundle ID: `com.arnav.RBCJourneyVision`.
- Final Simulator launch PID: `72041` on
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` with
  `--proof-station-2 --proof-transfer-1`.

## Accepted visual evidence

- `19-inside-brain-circle-focus-v3-accepted.png` — focused 64-segment Circle
  lens, contextual lesson copy, clear central observation pocket; SHA-256
  `6fe2a36dab2a40dbd2a7bb53e68b06f5783dc13f1294b774525f1a4d15c5b5ee`.
- `21-inside-brain-circle-transfer-hires-v3.png` — enlarged Circle with faint
  high-resolution cerebral arterial context; SHA-256
  `620c7539b824dec0808704962d9b774175843c4312339e69d68305fc2d2b4cfd`.

## Rejected visual evidence

- `15-inside-brain-anchored-portals-v3.png` — rejected: expanded head/neck
  vessels crossed the viewing origin.
- `16-inside-brain-atlas-v3b.png` — rejected: the cerebral tree remained too
  opaque and the portal relationship was not legible.

These files remain as regression evidence; neither is a promoted composition.

## Trust boundary

`Resources/Provenance/portal-anchor-manifest.json` records the source entities,
hashes, comfort projection, and proxy limitation. Portal placement is
geometry-derived and deterministic, but **not specialist-reviewed clinical
registration**. The exchange portal uses a representative cortical-direction
proxy because the magnified capillary asset is not tied to a specific cortical
capillary bed.

This receipt does not prove XCAT installation, physical hand interaction,
binocular comfort, readable labels behind the wearer, clinical correctness,
teaching efficacy, or specialist approval. Those remain separate gates.
