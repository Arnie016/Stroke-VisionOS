# Inhabit the Flow V21 — direct MCA gateway

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — native RealityKit interaction route, 68/68 contract checks,
generic visionOS Simulator build, transcript-integrity self-test, and one
reviewed Simulator composition. LIMITED — no XCAT hover/pinch, wearer,
provider-audio, paid inference, or clinical proof.**

## What changed

The selected right-MCA aperture is now the control, not only decoration:

- The aperture root carries `InputTargetComponent` for direct and indirect
  input, a bounded 0.205-metre collision sphere, and the system
  `HoverEffectComponent`.
- The existing targeted `TapGesture` walks the selected entity's ancestors,
  identifies the named MCA gateway, and calls the established
  `chooseAnteriorDestination(.arterialLumen)` handoff.
- On Vision Pro, the intended interaction is look for system hover, then pinch.
  The app receives the targeted entity—not an eye-gaze vector—and does not
  store or infer gaze.
- The labelled **Enter artery** control remains the accessible motor and
  Simulator fallback for the exact same action.
- The visible Family-companion sentence now says: look at the warm threshold
  and pinch. Exact-caption narration inherits that reviewed wording without
  gaining scene authority.

No second hand recognizer, custom ray cast, app camera, forced locomotion, or
new 3D asset was added.

## Visual review

- `216-anterior-gateway-direct-pinch-accepted.png`
  - 3840 × 2160
  - SHA-256: `99dca8be565f8955c6420e669cf1163019307934f047b8296a9071e5015c98d2`
  - The action sentence remains readable, the spatial aperture is dominant,
    and the labelled fallback is visible without becoming another dashboard.

The screenshot proves Simulator composition only. It does not prove system
hover, collision comfort, pinch selection, hand accessibility, or physical
scale.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 68/68**.
- `git diff --check`: **PASS**.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: **PASS**.
- `node Scripts/rbc_realtime_narration_proxy.mjs --integrity-self-test`:
  `RBC_NARRATION_INTEGRITY_SELF_TEST=PASS cases=2`.
- `zsh -n Scripts/run_rbc_realtime_proxy.zsh`: **PASS**.
- Generic build:

  ```text
  xcodebuild -project RBCJourneyVision.xcodeproj \
    -scheme RBCJourneyVision \
    -sdk xrsimulator \
    -destination 'generic/platform=visionOS Simulator' \
    -derivedDataPath /tmp/rbc-journey-v21-derived \
    CODE_SIGNING_ALLOWED=NO build
  ** BUILD SUCCEEDED **
  ```

- SDK: `xrsimulator26.5`; deployment target: visionOS 2.0.
- Product: universal arm64 + x86_64 Simulator app; 57,388 KiB.
- Installed and launched on booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` with
  `--proof-anterior-passage-mca`.

## Source receipts

- `RBCJourneyModel.swift`: `8493b0eee0c71e6f073df0a4bd321f423eda555e4f5fbd1548171267c82748b3`
- `RBCJourneyScene.swift`: `ac870109d041ea03a020b38e9d54d8813ea6e219665ab4ce484c9d6804e6e77e`
- `RBCJourneyImmersiveView.swift`: `2de961ce6293eb394bc28f09886a723a7fc354ce8e642a708885d3531acb29bb`
- `verify_contract.py`: `a47f9fe9ab782d2ea3b58e764e7163ce2e5499f5658854497e5c5c0f9c69b04e`
- `README.md`: `8c8ac3b6e04126067746d2d3c97fe6b424b69f9525770d11e07ad13e2a7de248`
- `AGENTS.md`: `c85c6f7a09d932d1239e210bb19cfafd11d2963817c5e5d3b55373c25e4b69c7`
- `medical-content-canon.md`: `9890dee8ff3b25bbbe8a4b68732c1ac28b16e6a2ce04b15e5e12fad68f5b88a0`

## Next gate

On XCAT, stand at the normal origin and verify that the aperture gains the
system hover cue without requiring uncomfortable head rotation, then pinch it
five times. Record target acquisition, accidental activations, successful
lumen handoffs, and whether **Enter artery** is still needed. That wearer test
is the only basis for tuning the collision volume or claiming the direct
interaction succeeds physically.
