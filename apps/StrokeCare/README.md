# Stroke Care

A clinician-paced visionOS explanation that uses spatial change—not a dashboard—to
tell one difficult story in three visual acts:

1. **Orient** — a whole brain rests inside a fixed skull while vessels supply it.
2. **Pressure** — a blockage and affected tissue appear; the affected side swells
   slightly while the skull stays fixed.
3. **Make space** — after explicit permission, a non-graphic bone-flap and dural
   expansion view explains mechanical purpose without implying that established
   injury is restored.

The launch window begins with a two-beat calm prelude, then asks whether the
purpose is **Doctor → family** or **Clinician teaching**. Inside the immersive
space, the file itself is the control: carrying it from the exhibit into the
centre opens a distinct case-review constellation. The wearer must explicitly
enter the selected case before the complete intake room disappears and the
brain appears. Patient-file furniture never persists beside the anatomy.

The companion window has two views over the same spatial state:

- **Family** keeps one calm sentence plus only pause and clarification controls.
  It does not expose clinician progression or reset controls.
- **Presenter** exposes direct act targeting, the visible anatomy layers, and a
  concise wording boundary. It never bypasses the permission gate or supplies a
  treatment script.

Both roles can switch between two sparse lesson fields (`Brain regions` and
`Blood flow`). The blood-flow lesson adds quiet directional chevrons on the
same centreline as the vessel droplets. Presenter mode can also open a separate upper evidence window. The
evidence window exposes full citations, stable source links, support/limitation
context, pinning, and a deterministic source-bound teaching draft. It is hidden
from family mode and remains **clinical review pending**.

The clinician layer study adds three reversible presentations: assembled
**Layers**, adjustable **See through**, and a gently offset **Study apart**
view. A selected point stays attached to its anatomical parent and becomes a
handle for orbit and magnification of the whole registered model; markers never
tear away from the brain.

## Spatial rig

- The default immersive path loads the exact PR #2 registered-v2 brain,
  cerebral arteries, right-M1 teaching marker, and conceptual dura from the
  canonical repository asset catalog. The app project references only its
  eight-file shortlist and does not duplicate the 65-asset source library.
  Authored child transforms are not
  rewritten; one outer placement root owns orbit, zoom, and the initial
  three-quarter presentation.
- Procedural hemispheres, vessels, clot, at-risk tissue, and flow remain an
  instant-loading fallback when the hero brain cannot load.
- A sparse fixed-space boundary ring replaces the earlier dark transparent
  skull bubble once the imported anatomy is present.
- The prototype-v1 edema, bone-flap, and patch files are bundled for a future
  Blender/Houdini registration pass but quarantined from the patient path.
  They must not be overlaid on v2 anatomy until the fit is reviewed.
- Downstream droplets become a fixed residual cue after the occlusion. This is
  qualitative animation, not CFD or a collateral-flow estimate.
- Quiet mono audio beds are anchored separately to the vessel and affected
  hemisphere. Their mix follows the visible act; it never responds to inferred
  emotion, gaze, voice, heart rate, or a patient measurement.
- Optional narration sends only the exact, versioned family caption to a
  developer-controlled proxy for `gpt-realtime-2.1`. The permanent OpenAI key
  remains server-side. There is no system-speech fallback, patient data, or
  generative medical answer in the client.
- A warm low-contrast ground and horizon replace the simulator's ominous black
  void. This is an unvalidated comfort hypothesis, not a therapeutic claim.
- Tap the occlusion to focus it. Pause, back, mute, exit, and all progression are
  explicit user or clinician actions. There is no success animation.
- A compact spatial patient drawer, specimen rail, and family question marker
  move the explanation into the room. The side rails carry controls and safety
  boundaries rather than repeating the lesson as text.

## Clinical and privacy boundary

The app uses `CASE-078`, a fictional scenario with no name, image, medical
record, or real person. It is educational communication support—not a scan,
diagnosis, emergency instruction, consent form, treatment recommendation,
eligibility calculator, clinical decision aid, or medical record.

The current wording is source-aligned to the American Heart Association's 2026
acute ischemic stroke materials and the team's merged open cranial stroke surgery
research, but remains **clinician review pending**. It does not establish whether
decompressive surgery, thrombolysis, thrombectomy, or any other intervention is
appropriate for a person.

- [2026 AHA/ASA acute ischemic stroke guideline hub](https://professional.heart.org/en/science-news/2026-guideline-for-the-early-management-of-patients-with-acute-ischemic-stroke)
- [AHA key patient messages](https://professional.heart.org/en/-/media/PHD-Files-2/Science-News/k/Key-Patient-Messages-The-2026-Acute-Ischemic-Stroke-Guideline.pdf)
- [NICE NG128 recommendations](https://www.nice.org.uk/guidance/ng128/chapter/recommendations)
- [NICE decompressive hemicraniectomy decision-aid guide](https://www.nice.org.uk/guidance/ng128/resources/decompressive-hemicraniectomy-surgery-patient-decision-aid-user-guide-pdf-6775901391)

## Build and proof

```bash
cd apps/StrokeCare
xcodegen generate
xcodebuild -project StrokeTime.xcodeproj -scheme StrokeTime \
  -sdk xrsimulator \
  -destination 'platform=visionOS Simulator,id=F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777' \
  CODE_SIGNING_ALLOWED=NO build
python3 Tests/verify_contract.py
```

Deterministic Simulator routes:

```bash
xcrun simctl launch --terminate-running-process \
  F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777 \
  com.arnav.StrokeTime --hackathon-demo

# Patient pressure/care states and clinician presentation state
... com.arnav.StrokeTime --proof-pressure
... com.arnav.StrokeTime --proof-care-purpose
... com.arnav.StrokeTime --proof-clinician-pressure
```

Simulator builds and screenshots do not prove XCAT performance, physical
comfort, clinical accuracy, or clinician acceptance.

Current proof debt is tracked openly: the side-parked files, concise rails, and
spatial drawer/reticle compile in Simulator, but the newest immersive-room
capture still needs a user-initiated launch on an unlocked Mac. XCAT wearer and
clinical review remain separate gates.

When XCAT is powered on, worn, unlocked, and reachable, run the guarded physical
deployment receipt:

```bash
Scripts/deploy_xcat.zsh
```

The command refuses to build or install while XCAT is unavailable. The machine
receipt and the separate 90-second wearer protocol are documented in
`Proof/XCAT_ACCEPTANCE.md`.

The product promise, museum-like patient-file discovery, 3D case-bust safety
contract, point-field behavior, role separation, and 90-second judging script
are maintained in `Docs/PRESENTATION_DESIGN_CANON.md`.

The executed Blender/USD receipt and the deliberately unexecuted Houdini and
Unreal spokes are documented in `Docs/DCC_LAYER_STUDY_PIPELINE.md`.

The complete room choreography, screen/state inventory, annotation contract,
gesture map, implementation map, and image report are in
`Docs/STROKE_CARE_PRODUCT_UI_MAP.md`.

The clinician-only left-palm selector, right-palm held-tool rig, family/doctor
visibility split, and high-resolution asset debt are documented in
`Docs/CLINICIAN_HAND_TOOLKIT.md`.

The calm environment rationale, audio contract, and the explicit gates that
keep unvalidated brain-scan AI out of the patient path are documented in
`Docs/ENVIRONMENT_AND_SCAN_GATES.md`.
