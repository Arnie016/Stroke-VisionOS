# RBC Journey Vision build proof

Verified locally: 2026-08-09 (Asia/Singapore)

## Scope

- Standalone bundle: `com.arnav.RBCJourneyVision`
- Product: full-space, seven-station registered cerebral-flow journey
- Integration into Stroke Care: **NOT AUTHORIZED / NOT PERFORMED**
- Patient-specific content: none
- Quantitative flow or CFD: none

## Evidence ladder

| Gate | Status | Meaning |
| --- | --- | --- |
| Source contract | Pass | `RBC_JOURNEY_CONTRACT=PASS` (25 checks) |
| Xcode generation | Pass | `xcodegen generate` created the project graph |
| visionOS Simulator build | Pass | `xcodebuild` exited 0 with XROS Simulator 26.5 |
| Simulator launch | Pass | Bundle launched as PID `36232` on the named Simulator |
| Registered live-flow render | Pass | 14.79-second local MP4; render/motion evidence only |
| Deterministic held-flow render | Pass | Resume control and `FLOW HELD` state rendered locally |
| Hand-gesture compile path | Pass | ARKit T/clap recognizer compiled; no wearer claim |
| XCAT machine install/launch | Blocked | XCAT `613CC48C…2491` reported `unavailable` |
| XCAT wearer comfort/interaction | Not run | Requires a human in the headset |
| Specialist review | Not run | Required before clinical-facing use |

## Exact local receipts

- Main render: `Proof/09-registered-brain-portals-composed.png`
- Living-flow video: `Proof/10-living-registered-flow.mp4`
- Held-flow / Resume state: `Proof/11-paused-resume-state.png`
- Registered vascular asset source and destination SHA-256:
  `45080b42e09cd61cdcb1215d3ad69868d4dfa08d273ee6d9aa318c3b0f6229d6`
- Built app size: 49 MB
- Built bundle contains `brain_anatomy_realistic_v2.usdz`,
  `cerebral_arteries_realistic_v2.usdz`,
  `cranial_vascular_registered_assembly_v2.usdz`,
  `cerebral_bloodflow_animation_v2.usdz`, `FlowBed.wav`, and
  `ATTRIBUTION.md`.

## Verifiers

```bash
python3 Tests/verify_contract.py
xcodebuild -quiet -project RBCJourneyVision.xcodeproj \
  -scheme RBCJourneyVision -sdk xrsimulator \
  -destination 'platform=visionOS Simulator,id=F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777' \
  -derivedDataPath .derivedData CODE_SIGNING_ALLOWED=NO build
```

The proof launch used `--proof-station-4 --proof-portals-3` for the live scene
and `--proof-station-4 --proof-portals-2 --proof-paused` for the Resume state.
Arguments are deterministic Simulator presentation routes, not hand-input proof.

This file must not convert Simulator or machine receipts into wearer,
educational, or clinical claims.
