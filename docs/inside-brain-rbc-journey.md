# Inside the Brain — branch and publishing guide

This document is the handoff for `feature/inside-brain-rbc-journey`. The branch
contains a standalone, buildable visionOS experiment at
`Experiments/RBCJourneyVision`. It does **not** integrate the experiment into the
shipping `apps/StrokeCare` target.

## Product intent

The wearer is inside a generic cerebral atlas, not looking at a second brain in
a window. The short judge path is:

1. A four-beat threshold introduces anatomy, the problem, and the invitation.
2. The surrounding cortex becomes the room.
3. A maximum of three user-controlled portals reveal local lessons.
4. The frontal observatory can shift between Locate, X-ray, and Flow.
5. One optional branch ride surrounds a stationary wearer with a native
   inward-facing fork, a provenance-tracked PBR wall layer, a continuous
   direction mesh, sparse chevrons, and moving biconcave cells. The wearer can
   explicitly transfer into either path.
6. An optional family guide paces orientation, passage, and arrival captions
   through the ride. A local GPT Realtime proxy may read the exact visible copy;
   captions remain available without it. The guide is off by default and is not
   clinician tooling.
7. The selected frontal route resolves from artery to penetrating arteriole and
   an organic 34-node capillary web inside the existing regional outline. It is
   an expanded-scale relationship lesson, not a patient-specific cortical bed.
8. A pinch on that field or one Simulator-safe control expands only the
   capillary destination while the wearer remains still. The artery and regional
   outline recede; **Return to artery** reverses the transition. If the optional
   family guide is running, its visible and spoken copy advances to the matching
   arrival explanation.

Everything is generic education. No scene is patient-specific anatomy, CFD,
perfusion, velocity, pressure, diagnosis, treatment guidance, or an outcome
prediction.

## Build the experiment

```bash
cd Experiments/RBCJourneyVision
xcodegen generate
python3 Tests/verify_contract.py
xcodebuild -project RBCJourneyVision.xcodeproj \
  -scheme RBCJourneyVision \
  -sdk xrsimulator \
  -destination 'generic/platform=visionOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

The deterministic arterial-ride UI is launched with:

```text
--proof-flow-ride
--proof-flow-ride --proof-flow-route-frontal
--proof-flow-ride --proof-flow-route-neighbor
--proof-flow-ride --proof-family-guide
--proof-flow-ride --proof-family-guide --proof-family-guide-beat-2 --proof-flow-route-frontal
--proof-capillary-focus --proof-family-guide --proof-family-guide-beat-2
```

That launch flag proves only the selected interface state. It does not prove a
provider call, audio playback, physical-device comfort, hand interaction, or
clinical accuracy. See
`Experiments/RBCJourneyVision/Proof/INHABIT_THE_FLOW_V4_FAMILY_VOYAGE_RECEIPT.md`
for the paced-guide evidence boundary,
`Experiments/RBCJourneyVision/Proof/FAMILY_VOYAGE_PROXY_READINESS_RECEIPT.md`
for the zero-cost secure-transport check, and
`Experiments/RBCJourneyVision/Proof/INHABIT_THE_FLOW_V5_PBR_WALL_RECEIPT.md`
for the wall-material gate, and
`Experiments/RBCJourneyVision/Proof/INHABIT_THE_FLOW_V6_MACRO_MICRO_RECEIPT.md`
for the artery-to-capillary destination gate, and
`Experiments/RBCJourneyVision/Proof/INHABIT_THE_FLOW_V7_CAPILLARY_FOCUS_RECEIPT.md`
for the user-triggered scale-transfer and family-arrival gate.

## Optional family narration

The three-beat caption journey is local and available without a key. The app
contains no permanent OpenAI key and no direct provider URL. The optional local
proxy owns the key, locks model `gpt-realtime-2.1`, locks the exact visible
family copy, and returns a caption hash that the app verifies before audio
playback.

```bash
cd Experiments/RBCJourneyVision
Scripts/run_rbc_realtime_proxy.zsh
```

Do not commit `.env` files, paste keys into Swift, log secrets, or replace the
proxy with a client-side permanent key. Credential availability is not approval
to spend credits. A live narration test requires explicit approval and its own
receipt.

## How teammates and coding agents should work

1. Start from the feature branch and create a narrower child branch:

   ```bash
   git switch feature/inside-brain-rbc-journey
   git pull --ff-only origin feature/inside-brain-rbc-journey
   git switch -c feature/<name>-inside-brain-<scope>
   ```

2. Read `Experiments/RBCJourneyVision/AGENTS.md` before editing.
3. Keep `apps/StrokeCare` untouched unless Arnav explicitly asks for
   integration.
4. Prefer one visible spatial improvement at a time. Preserve a fixed wearer,
   no app camera, explicit pause/leave/exit agency, and no more than three open
   portals.
5. Run the 54-check contract and generic Simulator build before publishing.
6. Label proof literally: source, build, Simulator render, XCAT, wearer,
   specialist, and clinical evidence are separate gates.
7. Inspect staged files, secret scan, and binary sizes before committing.
8. Push the child branch and open a pull request into
   `feature/inside-brain-rbc-journey`, not directly into `main`.

## Asset and evidence policy

- Runtime USDZ files and their provenance stay together.
- Do not add an asset with unclear rights, patient data, or missing scale/origin
  notes.
- Do not commit DerivedData, local caches, private recordings, provider output,
  or rejected full-resolution movies.
- Curated PNGs demonstrate composition and local movement. They are not wearer
  or device evidence.
- Keep rejected evidence local unless it explains a decisive engineering
  lesson. Do not turn the repository into an asset dump.

## Promotion rule

The experiment may be proposed for the main app only after all of these are
true: stable XCAT placement, comfortable wearer review, a clear three-minute
story, specialist-reviewed wording, known asset provenance, acceptable frame
pacing, and an explicit integration decision from Arnav. Until then, keep this
as parallel spatial R&D.
