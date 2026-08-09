# Inhabit the Flow V10 — Cortical Microarchitecture Room

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — local source contract, generic visionOS Simulator build,
Simulator X-ray composition, and distinct RealityKit Flow frames.** XCAT,
physical pinch, wearer comfort, specialist review, histological fidelity,
patient anatomy, CFD/perfusion, and clinical or teaching value are **NOT RUN /
NOT PROVEN**.

## What changed

`Cortical layers` is an eighth scrollable destination in the existing Region
Portal Reel. The existing three-visible-card viewport and one-active-transfer
rules are unchanged. Entering the destination transforms a magnified cortical
fold around the stable observation origin; it does not show a second whole
brain and does not move an app camera.

The room contains:

- six curved, porous laminar fiber bands;
- 93 sparse illustrative cell points distributed through depth;
- five simplified radial/columnar guides;
- a curved pial artery feeding one penetrating arteriole;
- seven layer-crossing capillary branches;
- 13 arrowhead-and-tail fronts aligned to their current vessel tangent; and
- one gaze-and-pinch discovery mark that cycles Locate → X-ray → Flow.

Locate emphasizes the sampled-patch constellation. X-ray lifts laminae and
radial organization. Flow dims that context and makes pial → penetrating →
capillary direction visually dominant. Pause and Reduce Motion hold the local
RealityKit clock.

## Rejected composition

The first X-ray render used repeated translucent box tiles. Although spatially
placed, it read as a flat six-row specimen board and was rejected. Its proof
remained in `/tmp` and was not promoted.

The accepted composition replaces tiles with 24 irregular laminar fibers. The
fold bends toward the wearer at both sides and recedes at the center, so the
layers behave as a room-scale horseshoe rather than a card. The first Flow pass
was also rejected as underpowered. The accepted Flow pass adds brighter
dual-layer vessel cores and larger sparse arrow fronts while retaining dim
laminar context.

## Medical source boundary

- [NCBI Bookshelf — An Overview of Cortical Structure](https://www.ncbi.nlm.nih.gov/books/NBK10870/)
  supports six-layer neocortical organization, radial/columnar and horizontal
  connectivity, and area-dependent variation.
- [Schmid et al., PNAS/PMC — cortical vascular resistance](https://pmc.ncbi.nlm.nih.gov/articles/PMC5363755/)
  supports the pial-artery → penetrating-arteriole → deeper cortical supply
  relationship.

The five radial guides are not five identical functional modules. Layer
thickness, cell density, cell shapes, vessel diameter, branching, spacing,
color, and timing are illustrative and not to scale. The scene makes no claim
about neural firing, cognition, oxygen concentration, diffusion, perfusion,
patient anatomy, or regional diagnosis.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 57/57 checks**.
- Generic unsigned visionOS Simulator build: **BUILD SUCCEEDED**, Xcode 26.6,
  XRSimulator 26.5.
- Product: universal Mach-O (`x86_64`, `arm64`), 55,364 KiB at
  `/tmp/rbc-cortical-room-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`.
- Booted Simulator: Apple Vision Pro
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- No provider call, cloud compute, paid generation, or new external asset was
  used.

## Accepted evidence

- `142-cortical-microarchitecture-xray-accepted.png`
  - SHA-256: `2d4031a99a1ae315393cd11bd456ddbcd75f6ba8172bfe5723dedd41110b26cc`
  - Shows the six porous laminar bands and radial guides wrapping the stable
    view.
- `143-cortical-microarchitecture-flow-a-accepted.png`
  - SHA-256: `9350c6028b40762bb86313e6ab2cc88d3398e99af00db372c53751f4bb08a802`
- `144-cortical-microarchitecture-flow-b-accepted.png`
  - SHA-256: `71bd4d060c0c87ddedbf604aab13700d2efc54f37ccb0d83b9d35e617297a989`
  - A/B images were captured one second apart and have distinct hashes and
    visible arrow positions. This proves Simulator frame change, not a measured
    frame rate or physical-device motion quality.

## Source hashes

- `RBCJourneyScene.swift`:
  `356213a6605d4d48255ed566d1138b0c9ad7ece427c766c4f0011801a196c7cc`
- `RBCJourneyModel.swift`:
  `8d511cdd5246a2aaf750e30d5c642ff1c26bc04b97af29a98ac6aac3a58f804e`
- `RBCJourneyHUD.swift`:
  `322119d0682a2d5b38a908ee9319ab1da0304557159b491624addbd701bfd7be`
- `Docs/medical-content-canon.md`:
  `c0fa57ce2f105703cfbd828586239c8386d083d10181b297edb6985fe4e1938f`

## Next honest gate

On XCAT, enter `Cortical layers`, cycle X-ray → Flow with gaze and pinch, turn
left and right to judge whether the horseshoe reads as surrounding tissue, then
pause and confirm every arrow holds its exact pose. Record comfort, legibility,
and any near-field clipping separately from this Simulator receipt.
