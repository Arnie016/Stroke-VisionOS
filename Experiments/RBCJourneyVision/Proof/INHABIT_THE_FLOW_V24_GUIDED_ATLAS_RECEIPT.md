# Inside the Flow V24 — Guided 3D Atlas Receipt

Date: 2026-08-10 (Asia/Singapore)

## Verdict

PASS for the bounded local visionOS Simulator composition and guided-playback
contract. This pass makes the arterial lesson start as a continuous six-beat
journey. While it is playing, the learner has one intentional control:
Pause/Resume. The scene, caption, optional exact-copy voice request, and
stationary 3D atlas locator all derive from the same guided phase. Manual route
exploration is offered only after the tour completes.

## What changed

- 42 authored biconcave red-cell instances are distributed across the lumen;
  10 layered current strands and 18 tangent-aligned directional fronts keep
  downstream motion readable without claiming CFD, measured speed, pressure, or
  hematocrit.
- The surrounding inside-out cortical fold scaffold is restored and has a
  slow, comfort-safe living drift. It is explicitly not second-to-second
  neuroplasticity.
- The old schematic/Y-shaped map is replaced by a stationary anterior-view 3D
  atlas assembled from the same bundled cortex and cerebral-artery assets.
  Fork and right-M1 markers resolve against named USD entities. The capillary
  marker is a clearly labelled representative cortical proxy, not patient
  registration.
- Guided phases are source, division, frontal turn, frontal branch, narrowing
  toward cortex, capillary arrival, and complete. Captions remain reviewed
  exact copy. Optional voice remains loopback-proxy-only and is never a
  provider or clinical claim.

## Evidence

The required contract verifier passes 73/73 checks:

```text
python3 Tests/verify_contract.py
RBC_JOURNEY_CONTRACT=PASS
```

The generic arm64 visionOS Simulator build passes:

```text
xcodebuild -project RBCJourneyVision.xcodeproj \
  -scheme RBCJourneyVision \
  -sdk xrsimulator \
  -destination 'generic/platform=visionOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
** BUILD SUCCEEDED **
```

Runtime initialization on Apple Vision Pro Simulator
`F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` reported:

```text
RBC_SPATIAL_ATLAS=READY registered_geometry=true geometry_derived_locators=3 patient_registration=false capillary_proxy=true
RBC_LAYERED_CURRENT=READY flow_strands=10 tangent_fronts=18 full_lumen=true qualitative_only=true
RBC_FLOW_CORTEX=READY source=registered_cortical_asset inside_out=true folds=authored slow_living_motion=true not_neuroplasticity=true
RBC_FLOW_RIDE=READY authored_cells=18 journey_cells=42 ribbons=0 fork_routes=2 inward_corridor=true
RBC_GUIDED_FLOW_TOUR=PHASE phase=1 progress=02 / 06 route=overview capillary=false
RBC_GUIDED_FLOW_TOUR=PHASE phase=2 progress=03 / 06 route=overview capillary=false
RBC_GUIDED_FLOW_TOUR=PHASE phase=3 progress=04 / 06 route=frontal capillary=false
RBC_GUIDED_FLOW_TOUR=PHASE phase=4 progress=05 / 06 route=frontal capillary=false
RBC_GUIDED_FLOW_TOUR=PHASE phase=5 progress=06 / 06 route=frontal capillary=true
RBC_GUIDED_FLOW_TOUR=PHASE phase=6 progress=06 / 06 route=frontal capillary=true
```

The live capture is [`Proof/246-guided-journey-autoplay.mp4`](246-guided-journey-autoplay.mp4),
H.264 1280×720, 12 fps, 159.08 seconds, 1,909 frames, 3,177,004 bytes,
SHA-256 `fc874c3c1e806e2f77854ff3c232efd55f4f27d4cfeabba69e16cd525d93f622`.

The canonical completed state is [`Proof/245-guided-journey-complete-atlas.png`](245-guided-journey-complete-atlas.png),
SHA-256 `fde261a40329a989db5a7ada8efd98bfc93fbcb05a1aac525770d47f509069f5`.
It shows the full anterior atlas, the cortical-proxy locator, the surrounding
fold scaffold, the directional arterial field, and the post-tour controls.

## Boundaries

This receipt does not prove XCAT installation, wearer comfort, hand pinch
success, specialist medical review, patient-specific registration, clinical
accuracy, or a live external voice-provider response. No paid API call or
provider secret was used. The optional voice route is based on the verified
`gpt-realtime-2.1` integration and exact-caption transcript gate, but remains
unconfigured in this Simulator proof.
