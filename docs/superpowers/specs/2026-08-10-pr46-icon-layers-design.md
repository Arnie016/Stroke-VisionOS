# PR 46 layered app-icon repair

## Scope

Repair only the `Inside the Flow` visionOS AppIcon middle and foreground PNGs
called out in PR 46 review thread `discussion_r3746629417`. Keep the existing
RBC Journey back layer byte-identical. Do not modify the parallel StrokeCare
catalog, application UI, 3D assets, clinical copy, or runtime behavior.

## Visual design

The three layers remain one realistic educational composition:

- **Back:** unchanged approved brain-and-cerebral-vessel image.
- **Middle:** a subtle, aligned vascular-flow depth overlay on transparency.
  It may reinforce existing vessel structure and flow direction, but must not
  imply measured perfusion, pressure, diagnosis, or patient registration.
- **Front:** a small realistic biconcave-cell and warm focus motif on
  transparency. It must retain the authored educational RBC form without text,
  clinical symbols, decorative anatomy, or occlusion of the brain detail.

Both new overlays are 1024 by 1024 RGBA PNGs. Transparent pixels leave the
approved backplate visible. Visible content stays within the central safe area,
and the layers remain visually distinct so system parallax creates meaningful
depth.

## Verification design

Add a standalone Swift verifier that uses ImageIO/CoreGraphics to decode each
referenced icon PNG and inspect actual RGBA pixels. It must fail for:

- an unreadable or non-1024-by-1024 image;
- a non-background layer without an alpha channel;
- a uniform layer;
- an opaque-black or effectively blank non-background layer;
- a non-background layer with too little visible, colored, or varied content.

The verifier prints per-layer pixel statistics and a single pass/fail receipt.
The existing Python contract invokes it against the real AppIcon catalog, so
the current all-black files provide the required failing test before artwork is
replaced. Expectations are literal thresholds, independent of the new PNGs.

## Build and artifact checks

After replacement:

1. Validate every `Contents.json` reference and filename.
2. Run the Swift icon verifier and the full RBC contract.
3. Build `RBCJourneyVision` for both arm64 and x86_64 visionOS Simulator
   architectures with signing disabled.
4. Inspect the exact built bundle identity and compiled `Assets.car` records.
5. Render or extract the compiled icon layers and visually inspect the back,
   middle, foreground, and flattened composition.
6. Confirm the back-layer checksum is unchanged.

## Safety boundary

The icon is an educational product identity, not patient anatomy, diagnostic
imaging, quantified blood flow, clinical validation, or device validation.
