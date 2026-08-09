# Stroke Care proof receipt — 2026-08-09 01:49 SGT

## Current source

- Product: `Stroke Care`
- Bundle: `com.arnav.StrokeTime`
- Current source/build candidate: `0.6 (18)` on the feature branch. Older signed
  XCAT deployment receipts are versioned separately below and do not prove this
  candidate on device.
- Workflow: `Orient → Pressure → Make space` (exactly three internal acts)
- Patient data: none; `CASE-078` is fictional.
- Clinical content version: `SC-AIS-001.7`; clinician review pending.
- Heart Field: removed from XCAT at the user's request.

The default experience is a progressive spatial story rather than the old
dashboard. A quiet threshold opens into a dominant RealityKit brain; a small
companion strip controls pace, captions, mute, pause/back, and exit. The story
uses a fixed skull, conceptual swelling, a bone-flap reveal, and a dural-purpose
cue without pretending that established injury is reversed.

The companion now has two views over the same state. Patient view keeps one
calm sentence and one next action. Presenter view exposes direct act targeting,
visible-layer status, and a wording boundary; it does not bypass consent.

The current Simulator build also loads the reviewed PR #2 shortlist. Registered
v2 brain, cerebral arteries, right-M1 teaching marker, and conceptual dura are
visible in the three-act path. Prototype-v1 edema/flap/patch remain bundled but
disabled after a visual integration render demonstrated a mismatched frame.

The 0.6 spatial-workspace pass separates the experience into three explicit
phases: one angled dossier archive, a connected case review, and explanation.
Docking a file does not reveal anatomy; the wearer must deliberately enter the
selected case. The entire intake room then disappears. The brain space adds two
sparse lesson families, registered blood-flow direction chevrons, optional
GPT-Realtime-2.1-only narration, a quiet audio bed, deliberate environment
modes, and a closing reflection. None of these proves physical comfort or
clinical value.

## Static contract and Simulator

```text
STROKE_CARE_CONTRACT=PASS
procedure_steps=3
default_experience=PROGRESSIVE_SPATIAL_STORY
spatial_audio=ENTITY_ANCHORED_MONO
graphic_content=EXPLICIT_PERMISSION_REQUIRED
presentation_modes=PATIENT_FAMILY_AND_CLINICIAN
patient_data=NONE_FICTIONAL_ONLY
clinical_review=PENDING
physical_device=NOT_PROVEN
```

The current source built for the visionOS Simulator on 2026-08-09:

```text
xcodebuild ... -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  CODE_SIGNING_ALLOWED=NO build
** BUILD SUCCEEDED **
```

The current `0.6 (6)` source built and signed for the generic physical visionOS
destination at 01:48 SGT on 2026-08-09:

```text
destination=generic/platform=visionOS
derivedDataPath=/tmp/stroke-care-xcat-derived-data
Signing Identity=Apple Development certificate (identity redacted)
Provisioning Profile=iOS Team Provisioning Profile: com.arnav.StrokeTime
codesign --verify --deep --strict=PASS
bundle version=0.6 (6)
TeamIdentifier=VV6YGTA587
CDHash=47e085ccb50db832af966a6b3c09c5bb84321a65
XCAT hardware UDID in embedded profile=PASS
profile expiration=2026-08-15 15:56:35 SGT
** BUILD SUCCEEDED **
```

This proves a valid signed app bundle on the Mac. It does not prove installation
or launch on XCAT.

| State | Artifact | SHA-256 |
| --- | --- | --- |
| Threshold | `progressive-story/00-threshold-simulator.png` | `973ab1ab3980b68b5843bce308a86d3c3cdf1396914a28b0b9fa4918e39c84eb` |
| Orient | `progressive-story/01-orient-simulator.png` | `7d80a55fb43e858caba8caffaf795606f3d6379dc22663d2caabeed0abc0f45d` |
| Pressure | `progressive-story/02-pressure-simulator.png` | `c2aa7b43847868415a7c781c24cd396748943f34df62894abc858da81c86aa31` |
| Make space | `progressive-story/03-care-purpose-simulator.png` | `1182c5e853e97e9978fc6a24353b6a7d73006649a9b4a02c0b69834d1fe1a86b` |
| Clinician pressure | `progressive-story/04-clinician-pressure-simulator.png` | `028ca8ea2534f6e60489efd9be89a2e662d0e781f43d8dd0958179cc46b76294` |
| PR2 Orient | `progressive-story/08-pr2-orient-simulator.png` | `a9a79022f9859762cbbd21f217fb0a89a6be23239c1dbba505b2444cfbc99e64` |
| PR2 Pressure | `progressive-story/09-pr2-pressure-simulator.png` | `c18fd10e9775246dfaa1387d76a5df07200b1d8c4d49715ef194f24ed00ae5da` |
| PR2 Make space | `progressive-story/10-pr2-care-purpose-simulator.png` | `ca8f90147dd3053d84aa9551fe79a1c9a36e2015fe9d3b068f56ba10086cff19` |
| PR2 three-act sheet | `progressive-story/11-pr2-three-act-contact-sheet.png` | `fa53ed44543e2e6ce2dda07814e36192b1339b296986e7f8e1b3ddbd61600697` |
| Spatial case threshold | `14-spatial-case-unfold-simulator.png` | `748da0c08360ef8e5726b82bc6cab152e4c2397308aa9bf103b0c9e4d8d84cde` |
| Presenter side rail | `15-presenter-side-rail-simulator.png` | `8bb6420f8d8c5462f8ca60fe437640bd01fa8b3b0488aa73ec6da5b31b563437` |
| Family visual-field composition | `16-family-question-surface-simulator.png` | `80feac40810e1e5957078ea2523c39047396e8119e0002ccde4036416a2d4a14` |
| Purpose-first prelude | `36-purpose-first-prelude-0.6-simulator.png` | `6c3453931eb44b241fdf6afc2402abad94c5ffa34207fd08e48be9b734ae4f44` |
| Case review phase | `34-case-review-phase-0.6-simulator.png` | `ab50b0a97fa2b02d037c50c03d13ed98869d0d7bfe010dadb3dc4dad77cd937e` |
| Blood-flow lesson | `35-blood-flow-lesson-0.6-simulator.png` | `0d551fb7eb532afc8806b90f69a02c3783da8074780c2d4990310dbd63517eb1` |
| Angled case archive | `45-case-library-archive-simulator.png` | `86629c4cd58fe9ba4091e4727d94aebc39bf2b399761b86bf80802f6bfa4e510` |
| Case constellation | `46-case-review-constellation-simulator.png` | `de36aa9b063c57f0de61201df9400c24ed843fbad9d8e9e280830b11211ce587` |
| Upper-field Vessel Story | `47-vessel-story-upper-field-simulator.png` | `ab81e3b35b67dc23b14e92aaa6b27cb540b6b03d08f452803788bbcdddec4c98` |
| Model-frame front | `48-model-front-points-simulator.png` | `ad58469d8f72aa21b984d1b2c574266fb6ad04c037631dcdf53af464f17a335c` |
| Model-frame side A | `49-model-side-a-points-simulator.png` | `08301effcb261b85812b73cc348ca673c63531eb4046f3ddd567d041176dad8b` |
| Model-frame top | `50-model-top-points-simulator.png` | `eec6a2a0ca9ce8c81812a31c46ce2336e5084e180a887b89f88adbbc23c8db89` |

These artifacts prove Simulator-visible UI, model presence, deterministic
teaching states, and the configured visual hierarchy. They do not prove anatomy
validity, physical comfort, clinical value, or perception of spatial audio.

The three model-frame captures show the complete registered assembly changing
pose without visible child-layer detachment. They do not establish anatomical
laterality; Side A/Side B remain neutral labels pending specialist review.

The latest frames demonstrate the 0.6 Simulator composition: a purpose-first
threshold, one face-angled archive, case review without anatomy, and a separate
central blood-flow lesson with the lesson rail in the upper visual field. They
do not establish foveal comfort, peripheral legibility, marker-registration
accuracy, hand-control reliability, audio perception, or comprehension for a
wearer.

## XCAT state

At 16:08 SGT on 2026-08-09, XCAT was `available (paired)` with identifier
`613CC48C-A6AD-5170-A238-D518B6012491`. The guarded deployment completed for
Stroke Care `0.6 (7)`, bundle `com.arnav.StrokeTime`:

- generic physical visionOS build: PASS
- designated-requirement and deep signature verification: PASS
- installation and installed-app query: PASS
- deterministic `--hackathon-demo` foreground launch: PASS
- running-process query: PASS (`StrokeTime`, PID 656 before the deterministic
  placement route)
- deterministic `--proof-view-anterior` physical-device launch: PASS
- tracked `WorldTrackingProvider.queryDeviceAnchor` placement path: PASS on
  sample attempt 3
- stage mode and intended forward distance: `sample-once-room-fixed`, `1.16 m`

The authoritative local machine receipt is
`Proof/xcat/20260809-160742/RECEIPT.md`; its JSON and command logs remain beside
it. The separate placement-path receipt is
`Proof/xcat/20260809-160823-stage-placement/RECEIPT.md`, with JSON SHA-256
`05a5bc6c093c670b97ef490c3f2de89770727bbaef5e6fdc8cc7cc0863ff7fec`.
It stores no raw room transform, gaze, hands, or patient information.

This proves that the current signed binary was installed, activated, found
running on XCAT, and executed its tracked-device-anchor placement path. It does
**not** prove what appeared in the wearer’s field of view, comfortable
placement, gaze or pinch behavior, audio perception, comprehension, or clinical
validity. The static source verifier therefore still prints
`physical_device=NOT_PROVEN`; human device judgment must come from the separate
wearer receipt.

At 16:36 SGT, build `0.6 (8)` also completed a signed arm64 physical-visionOS
build and passed deep code-sign and designated-requirement verification. Its
first install did not complete: XCAT disconnected immediately after the
CoreDevice tunnel opened. At 16:43 SGT, a guarded retry installed build 8, and a
fresh installed-app query confirmed `Stroke Care 0.6 (8)`. Foreground launch
still timed out while the lock-state query reported `passcodeRequired: true`,
and the process query was empty. The machine receipts are
`Proof/xcat/20260809-163625/BLOCKED.md` and
`Proof/xcat/20260809-164319/INSTALL_ONLY.md`. Build 8 is therefore installed but
is **not** claimed foregrounded, running, or visible.

At 17:00 SGT, build `0.6 (9)` completed the guarded physical-device lane:

- generic physical visionOS build and deep code-sign verification: PASS
- installation and installed-app query: PASS (`Stroke Care 0.6 (9)`)
- deterministic `--hackathon-demo` launch and process query: PASS
- normal no-argument main-app launch at 17:04 SGT: PASS
- post-launch process query: PASS (`StrokeTime`, PID 761)

The guarded receipt is `Proof/xcat/20260809-165957/RECEIPT.md`; the separate
normal-route receipt is
`Proof/xcat/20260809-170430-main-route/RECEIPT.md`. These machine receipts prove
that the signed build installed, foreground-launched, and existed as a running
process. They do not establish the wearer-visible scene, lesson-point hover or
pinch quality, annotation behavior, comfort, comprehension, spatial audio, or
clinical validity.

Build `0.6 (10)` adds one centered world-space chapter line for
`Orient → Pressure → Make space`. Each node is a gaze-and-pinch target and
reuses the existing consent-aware `present(step:)` path. A single left
peripheral surface shows one family question or exactly three presenter keys;
the prior duplicate presenter Act menus are removed. The static contract and
generic physical visionOS build pass. The first guarded deployment attempt at
17:19 SGT stopped before building because XCAT changed to `unavailable`; that
gate is recorded in `Proof/xcat/20260809-171918/BLOCKED.md`. No build-10 device
install or wearer result is claimed yet.

Build `0.6 (11)` is a feature-branch teaching-imaging scaffold derived from the
team's Page 2 Figma screenshots. It adds an explicit right-peripheral toggle
and two small spatial plates, `Stroke effect` and `Making-room purpose`, while
retaining the same affected-region marker and explicitly stating that the
artwork is not CT/MRI, patient imaging, or recovery evidence. The static
contract, generic physical visionOS build, visionOS Simulator build, install,
and deterministic `--proof-teaching-imaging` launch pass. The layout capture is
`Proof/52-teaching-imaging-drawer-simulator.png`.

This is Simulator layout proof only. The user has rejected the procedural
schematics as the final visual direction; the branch is not merged to `main`.
It does not prove Figma parity, realistic imaging, XCAT depth or legibility,
wearer interaction, patient specificity, recovery, or clinical validity.

At 20:20 SGT, the normal `--proof-pressure` Simulator route reproduced the
reported near-black frame even though the process stayed alive and RealityKit
resources loaded without a crash. The shared cause was the physical-device
room-placement path relocating the whole authored stage when run under the
Simulator. `StrokeStagePlacement.start()` now keeps Simulator proofs in the
authored frame while preserving the single tracked-device-anchor sample on
physical XCAT. The static contract and visionOS Simulator build pass. After a
fresh install, the same route launched as PID 89225 and rendered the brain,
three-act timeline, atlas rail, and attachments in
`Proof/54-simulator-authored-frame-pressure.png`.

This proves only that the authored Simulator scene renders after the bounded
placement correction. It does not establish final art direction, point
selection, brightness, stereo placement, XCAT behavior, wearer comfort,
family-display mirroring, comprehension, or clinical validity. The brighter
six-frame image in `Docs/Images/` remains explicitly labelled as visual
direction rather than runtime evidence.

At 20:49 SGT, the gated `--proof-scholar-skull` route rendered the existing
semantic-v2 skull in bright Surroundings while preserving its authored outer
frame. The state is restricted to clinician + Scholar + the exact catalog ID;
it hides brain, arteries, clot, dura, lesson points, and the hand toolkit, and
exposes only viewpoint, environment, evidence, reset, and exit. Moving to a
different top-timeline act exits the skull inspection and restores the normal
registered assembly. The visible copy now says `SKULL · REGISTRATION REVIEW`
and identifies the object as a generic cross-source teaching skull.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`; the
OS 26.5 visionOS Simulator build ended `** BUILD SUCCEEDED **`; a fresh install
launched PID 18592; and the 3840×2160 layout capture is
`Proof/55-scholar-skull-registration-review-simulator.png` with SHA-256
`641190c1add4f0a6200062f5da37a58222cbf2419d72c914906fd60b3a9759c2`.
This does not prove cross-source anatomical registration, XCAT visibility,
wearer comfort, interaction quality, or clinical validity.

At 21:25 SGT, the main Pressure composition was rebuilt around the normal
registered-v2 anatomy rather than the isolated Scholar-skull inspection. The
overview now begins with four quiet anatomy-attached region points, a
clot-surface-derived focus beacon, and the revisitable top timeline. Selecting
one point reveals exactly one local label, one concise explanation, and one
registered affected-vessel reference; switching act, layer family, or assembly
clears that disclosure. The duplicated `Images` controls are removed.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`; the
OS 26.5 visionOS Simulator build ended `** BUILD SUCCEEDED **`; fresh installs
launched overview PID 68034 and selected-point PID 68202. The 3840×2160 runtime
captures are `Proof/56-main-dots-first-overview-simulator.png` with SHA-256
`14cbc4e5ff367ec683b2e3d47dbec83527bd96ebd3e9e912e53eda6573b47d42`
and `Proof/57-main-selected-point-reference-simulator.png` with SHA-256
`04587770c4131bd3c84f5f75ecfd5b6f5fd5d7b59f67e59aec15685862152dc9`.

The guarded physical lane ran first at 21:04 SGT and stopped because CoreDevice
reported paired XCAT `unavailable`; the local machine receipt is
`Proof/xcat/20260809-210457/BLOCKED.md`. No XCAT build, install, launch, wearer,
or clinical result is claimed from this pass.

At 22:01 SGT, a showcase-readiness slice made the four anatomy-attached region
points visibly luminous without adding labels, widened the revisitable top
timeline so all three act names remain readable, and corrected the world-locked
teaching-reference lookup so it continues updating after reparenting. The
clinician tool wheel is now a 150-degree, five-target hand-adjacent arc with
84-point controls, a presenter fallback, and the selected generic forceps shown
at the opposite hand. The doctor-worn family lens keeps three suggested
questions and an explicit, presenter-recorded comfort check together at the
left; it does not infer anxiety or require a second headset.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`;
`git diff --check` passed; the OS 26.5 visionOS Simulator build ended
`** BUILD SUCCEEDED **`. Fresh launches returned PIDs 98600, 98741, and 3425.
Runtime captures are `Proof/59-main-point-cloud-readable-timeline-simulator.png`
with SHA-256 `b3a8fba31359f31758f497c180051f8159ff941906f858673e13a23328f1d4a3`,
`Proof/58-clinician-hand-tool-arc-simulator.png` with SHA-256
`4231215e33c92e645d920fbab420ca845cfaf2375fa0a716f8687af7925fa800`,
and `Proof/60-doctor-mirrored-family-cues-simulator.png` with SHA-256
`d22c07cfa1d91ccd9a5732f5ca7b29255bb7598ef960f8635d826d269603baf7`.

These receipts prove Simulator layout and state only. XCAT reach, hand-relative
placement, gaze-and-pinch reliability, AirPlay mirroring, stereo legibility,
comfort, family comprehension, and clinical validity remain unproven. The hero
brain has substantial geometry, but its source USDZ carries only one cortex
albedo map; the arteries carry no texture maps, so a reviewed normal/roughness
material pass remains real art debt rather than a missing-feature claim.

## 2026-08-09 22:58 SGT — two-path entry and thirteen-asset anatomy slice

The launch threshold now exposes exactly two plain-language paths. **Patient /
family** bypasses the fictional record room and opens the calm generic anatomy
exhibit directly. **Doctor presenter** retains the fictional case library,
history review, and case-led explanation. The normal explanation keeps the
three-act top timeline, four quiet region points, one selected-point disclosure,
and a taller left presentation checklist derived from the Page 2 Figma direction.

The bounded runtime bundle now contains exactly thirteen USDZ files. The added
registered-v2 deep structures, ventricles, and authored cerebral-flow asset all
passed `usdchecker --arkit --strict`. Deep structures and ventricles are visible
only in the clinician's explicit Study-apart region view. The baked blood-flow
tracks are recursively discovered, play only after selecting a clinician
procedure point, and pause for the app pause state or Reduce Motion. They remain
generic qualitative teaching motion—not CFD, perfusion, velocity, or patient
measurement.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`;
`git diff --check` passed; and the OS 26.5 visionOS Simulator build ended
`** BUILD SUCCEEDED **`. The built `.app` contains exactly thirteen `.usdz`
filenames. Runtime evidence is:

- `Proof/67-patient-doctor-role-threshold-simulator.png`, SHA-256
  `2460b34999dc38e8d9f18e3398367de44c70b5bb20f3e000bb4382f823a5d753`;
- `Proof/65-layer-study-internal-anatomy-simulator.png`, SHA-256
  `3a1b2c7e23c3648d59319dc076212587f3b1caa36a2288329df1f9b5d8e1e0e6`;
- `Proof/66-authored-bloodflow-point-simulator.png`, SHA-256
  `1c2b80bb0fda075ff9865a38826a9769ef58b8f5614236432e70b31d9e19a886`;
- `Proof/66b-authored-bloodflow-motion-simulator.mp4`, 3840×2160, 4.8 seconds,
  SHA-256 `3f2af50497933eee16a21934857026436e04d7822051d608532f5cae23ae55ef`;
- `Proof/68-doctor-presentation-checklist-simulator.png`, SHA-256
  `9333850dd57a960bc108ec92d849fcc19a7d524a7a19dce88efb03009ad04ee6`.

The recording shows visible authored-flow state change between separated frames,
but does not validate physiology. Figma MCP was rate-limited on the Starter plan,
so the palette and checklist are screenshot-derived, not claimed as one-to-one
MCP inspection. The earlier black capture was rejected after Simulator logs
showed another immersive app restoring and invalidating Stroke Care's scene.
These receipts do not prove XCAT performance, eye/gaze selection, hand-relative
placement, wearer comfort, AirPlay mirroring, comprehension, or clinical validity.

## Clinical and procedural gates

- `Docs/ISCHEMIC_STROKE_CLINICAL_REVIEW.md` is a versioned review packet, not a
  completed review. Reviewer identity, wording decisions, and sign-off remain
  empty.
- Houdini/hython is unavailable to this runtime. The procedural graph and
  builder are ready, but no Houdini cook, `.hip`, VDB, or Houdini USD is
  claimed.
- Physical wearer interaction, comfort, legibility, spatial-audio perception,
  hand-gesture reliability, and clinician acceptance are not yet run on the
  refreshed build.
- GitHub PR #2 asset intake is documented separately in
  `Docs/GITHUB_ASSET_INTAKE_PR2.md`; eight exact files are locally bundled,
  while distribution rights and clinical/device gates remain unresolved.

These gates remain active without marking the continuous product goal blocked.

## 2026-08-09 23:32 SGT — spatial case-history unfold

The legacy `--proof-case-unfold` flag now opens the current immersive doctor
intake rather than retired window state. A selected fictional dossier lifts to
the centre, dissolves into a neutral case anchor, and reveals one selected
history branch before the explicit **Enter case** threshold. The archive and
case review use passthrough surroundings so a presenter can remain oriented to
the family and room. Endpoint nodes are directly selectable, patient/family
state cannot enter the case-library transitions, and Reduce Motion skips the
travel/stagger choreography.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`;
`git diff --check` passed; and the OS 26.5 visionOS Simulator build ended
`** BUILD SUCCEEDED **`. The deterministic composition capture is
`Proof/69-case-history-unfold-simulator.png`, SHA-256
`9d14e686839ab5198fcbcd64f95e9a4a14de441aa59e03873b27b5f0325f7b0d`.

The procedural case anchor proves choreography only; it is not a MetaHuman,
patient likeness, or scan-derived avatar. The capture does not prove physical
gaze/pinch reliability, room comfort, AirPlay legibility, or clinical meaning.

## 2026-08-09 23:49 SGT — family narration and doctor-language boundary

The shared explanation now enforces two different communication roles. Family
mode exposes three finite question prompts, an explicit Again/Unsure/Clear
clarity check, and optional `gpt-realtime-2.1` narration. Selecting a question
pauses the lesson. Doctor presenter mode revokes and stops narration; its
left-peripheral checklist can reveal one authored plain-language line beneath
the selected technical cue. It does not generate a medical answer.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`;
`git diff --check` passed; and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-role-voice` ended `** BUILD SUCCEEDED **`. Deterministic
runtime captures are:

- `Proof/70-family-clarity-questions-simulator.png`, SHA-256
  `d9fe66cc2c6e4b0115cf721adef49d13f92f7039b814b1f04f12b4a2829647b5`;
- `Proof/71-presenter-authored-plain-language-simulator.png`, SHA-256
  `7e8c38d5c6a1a1075b146bdd3288a9bbe241b1bcb7b04cf6d06ea3c0f858f91f`.

This slice did not call the proxy or OpenAI API and therefore does not prove
Realtime transport, audible output, voice quality, or latency. Simulator still
does not prove XCAT peripheral legibility, gaze-and-pinch reliability, AirPlay
composition, family comprehension, clinician acceptance, or clinical validity.

## 2026-08-10 00:13 SGT — phase-aware static-room cadence

The case library and case review no longer drive the 60 Hz animation timeline,
and the hidden registered/procedural anatomy tree is not mutated during those
phases. The dossier unfold remains driven by explicit published reveal state;
the explanation phase retains its display-rate environmental and anatomy cues.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`;
`git diff --check` passed; and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-idle-phase-gate` ended `** BUILD SUCCEEDED **`.

Using the same Simulator, `--proof-spatial-intake` route, eight-second settle,
and five two-second `ps` samples, median Stroke Care CPU fell from 27.7% to
7.3%. The exact samples and boundaries are in `Proof/IDLE_CPU_RECEIPT.md`.
RSS was not improved. The `--proof-case-unfold` route still reached its final
state after the cadence change. These are Simulator process and render-state
receipts only; XCAT performance, thermals, battery, wearer targeting, AirPlay,
comfort, comprehension, and clinical validity remain unproven.

## 2026-08-10 01:22 SGT — clinician layered-anatomy hierarchy

This bounded slice adds a registered-v2 venous reference to the clinician
Regions lesson and exposes direct `Front`, `Side A`, and `Top` views plus
`Calm`, `Guided`, and `Scholar` reference depth. Scholar mode shows a peripheral
reference rail: Anatomy is available; Imaging becomes available only after a
deliberate point selection; unsupported clinical lanes remain visibly locked.
The three-act `Orient → Pressure → Make space` timeline and four quiet regional
points remain visible around the dominant central anatomy.

The generated application contains exactly fourteen top-level USDZ resources
and `THIRD_PARTY_NOTICES.txt`. The venous asset is displayed only for a
clinician, during explanation, in Guided or Scholar detail, with the Regions
family selected. Its visible label says `GENERIC VENOUS ATLAS · COLOUR
CONVENTION · REVIEW PENDING`. The app is 50 MB; its version is `0.6 (12)`; and
the Simulator executable SHA-256 is
`aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-layer-hierarchy-14-final` ended `** BUILD SUCCEEDED **`.
The clean deterministic `--proof-clinician-layer-hierarchy` launch ran with
only `com.arnav.StrokeTime` present. The resulting
`Proof/72-clinician-guided-venous-layer-simulator.png` is 3840×2160 with
SHA-256
`5d0c3f443ebb305cc8087fab49f88f658489c02642d6e381309ce38f98c651dd`.

This is Simulator render/composition proof only. XCAT remained `unavailable`.
The separated skull reference deliberately avoids implying approved
cross-source registration. The screenshot does not prove gaze/pinch accuracy,
depth, performance, AirPlay legibility, haptics, family comprehension,
specialist registration, or clinical validity. The 134-item repository catalog
is source inventory, not 134 loaded or approved runtime assets.

## 2026-08-10 01:57 SGT — role-aware six-beat presenter timeline

Build `0.6 (13)` preserves the three-act patient/family story while giving the
doctor presenter six directly revisitable checkpoints: Confirm context, Discuss
access, Protective covering, Explain purpose, Team checks, and Explain closure.
The third through sixth checkpoints reuse the existing explicit permission gate;
the final checkpoint returns the teaching layers to their assembled state. The
left presenter prompts change with each checkpoint and remain authored cues, not
a clinical script or generated recommendation.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-six-beat-build13` ended `** BUILD SUCCEEDED **`. A clean launch
of `--proof-clinician-six-beat-timeline` produced
`Proof/73-clinician-six-beat-timeline-simulator.png` at 3840×2160 with SHA-256
`32995ff96325f5ec61bfe002ddc829d6f1f0ed48520bcae552f390a6984e667e`.
The built Simulator executable SHA-256 is
`aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`.

The implementation follows the supplied Figma Page 2 screenshots. Structured
Figma context and 1:1 validation were not available because the authenticated
Starter plan had reached its MCP call limit. XCAT was paired but `unavailable`;
the dated reachability receipt is
`Proof/xcat/20260810-015706/BLOCKED.md`. No device build, install, launch, wearer,
AirPlay, interaction, comprehension, specialist, or clinical proof occurred.

## 2026-08-10 02:11 SGT — direct complete model-frame viewpoints

Build `0.6 (14)` adds direct `Side B` and `Bottom` choices to the existing
clinician `Front`, `Side A`, and `Top` lens. The five presets use a compact
two-row grid with 44-point minimum targets. Each preset rotates the complete
registered anatomy root; no organ, vessel, skull layer, or lesson marker is
repositioned independently. `Side A/B` and `Top/Bottom · model frame` avoid
claiming reviewed laterality or radiological orientation.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, XcodeGen regenerated the project, and the OS 26.5
visionOS Simulator Debug build at `/tmp/strokecare-viewpoints-build14` ended
`** BUILD SUCCEEDED **`. The built app contains exactly 14 unique USDZ files
plus `THIRD_PARTY_NOTICES.txt`; its executable SHA-256 is
`d0c40408a0185cbe2b4d8596a7d9fe6e80a6d0ad21b6f167cbcac7cedaf36405`.

The deterministic `--proof-view-inferior` route produced
`Proof/74-clinician-inferior-viewpoint-simulator.png` at 3840×2160 with
SHA-256
`38b6abfc025dedea5b742bf73a0848df67f8ba611072c14466ed2044ea6ba9b2`.
The receipt proves Simulator render state and visible control selection only.
XCAT remained `unavailable`; wearer targetability, depth comfort, AirPlay
legibility, anatomical orientation, specialist review, and clinical validity
remain unproven.

## 2026-08-10 02:40 SGT — registered qualitative arterial-flow overlay

Build `0.6 (15)` adds `circle_of_willis_flow_overlay_v2.usdz` to the bounded
runtime slice. The file is 475,177 bytes, contains 10,392 triangles, has SHA-256
`7aa5442f0d8eb6a1fb14b8b8f046c39040501c7df41589f554f1d8d90f845e7a`,
and passed `/usr/bin/usdchecker --arkit --strict`. Its authored frame matches
the existing registered-v2 head assembly. It is enabled only after a deliberate
Blood-flow procedure-point selection, and the visible teaching boundary says
`DIRECTION CUE · QUALITATIVE · NOT CFD`. The detached generated arrow root
remains disabled.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, XcodeGen regenerated the project, and the OS 26.5
visionOS Simulator Debug build at `/tmp/strokecare-flow-overlay-build` exited
successfully. The built `0.6 (15)` app is 51 MB and contains exactly 15 unique
top-level USDZ files plus `THIRD_PARTY_NOTICES.txt`; its executable SHA-256 is
`ed8ee93daff5870e92f324cdc64638f6e6d076419d6bdc4229a7c2b50d58dbee`.

After rebooting the Simulator to remove a stale competing immersive scene, the
deterministic `--proof-procedure-field` route produced
`Proof/75-registered-flow-overlay-simulator.png` at 3840×2160 with SHA-256
`86887fccc6df7f760c306783e535dd6b2a364f6a18104016e2020bce2f6841d8`.
This is Simulator composition proof only. It does not establish animation
quality, XCAT visibility, gaze-and-pinch reliability, stereo depth, AirPlay
legibility, wearer comfort, arterial/venous meaning, specialist review, or
clinical validity. The 134-item repository catalog remains an inventory, not
134 bundled, registered, visible, or approved runtime assets.

## 2026-08-10 03:06 SGT — complete-or-visible anatomy load gate

Build `0.6 (16)` makes the registered-v2 brain, cerebral arteries, ischemic
teaching clot, and conceptual dura one required core set. A complete load keeps
the detailed registered assembly. Any missing required layer now records the
exact asset name through the `AnatomyLoading` OSLog category and switches to the
complete procedural teaching model with the wearer-visible boundary
`SIMPLIFIED TEACHING VIEW · Detailed anatomy unavailable`. Optional skull,
venous, deep-structure, ventricular, and flow references do not invalidate the
family core.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, XcodeGen regenerated the project, and the OS 26.5
visionOS Simulator Debug build at `/tmp/strokecare-asset-fallback-build16`
ended `** BUILD SUCCEEDED **`. The built app is `0.6 (16)`, contains exactly
15 unique USDZ files, and its `StrokeTime.debug.dylib` SHA-256 is
`e988faf9222cca109a26b6b624c88b73aab174460dc562bfdce5178cb72ee534`.

The deterministic Simulator matrix launched the complete, brain-only,
missing-artery, missing-clot, and missing-dura states. Every launch remained
running. The four degraded cases logged exactly the omitted required assets;
the complete case logged no anatomy failure. The missing-artery route produced
`Proof/76-visible-anatomy-fallback-simulator.png` with SHA-256
`1f1a44305cd82aa5de29a098c28a72d96bedd17930d671f024e8636eaa62dd34`.

This is deterministic Simulator failure-injection and visible-render proof. It
does not establish physical-device loading, wearer legibility, gaze-and-pinch
quality, AirPlay composition, comfort, comprehension, specialist registration,
or clinical validity. XCAT remained `unavailable`; the dated reachability
receipt is `Proof/xcat/20260810-030404/BLOCKED.md`.

## 2026-08-10 03:23 SGT — current nonblank room-scale route gate

The P0 stage regression is now exercised through a single repeatable command,
not accepted from an old screenshot. `Scripts/capture_simulator_route_proof.zsh`
installs the exact build-16 app, terminates known competing immersive apps,
launches the requested route, checks the returned process before and after the
capture, and invokes a dependency-free PNG verifier. The verifier rejects
undersized, low-variance, empty-centre, and colourless-centre images. A
synthetic 1920×1080 black PNG was rejected for all four expected reasons.

The fresh `--proof-spatial-intake` capture is
`Proof/77-current-spatial-intake-simulator.png`, 3840×2160, SHA-256
`ceba58483cc9ed318599783046737eba393e8478776f908dbcd9ebe37da4cdc4`.
The current dossier archive and selected fictional file are visible in the
authored Simulator frame; StrokeTime PID 6218 remained alive through capture.

The fresh `--proof-pressure` capture is
`Proof/78-current-pressure-stage-simulator.png`, 3840×2160, SHA-256
`1a2ce6f684f4f07695545673cf6f5a86b64cb4cc4648f10dedfdc990779595e2`.
The central registered anatomy, attached lesson points, family cue surface, and
top three-act timeline are visible; StrokeTime PID 7065 remained alive through
capture. Both runs installed the build whose executable SHA-256 is
`e988faf9222cca109a26b6b624c88b73aab174460dc562bfdce5178cb72ee534`.

`python3 Tests/verify_contract.py` and `git diff --check` passed. This is
Simulator render/process evidence only. It does not prove physical XCAT
placement, wearer visibility, gestures, comfort, AirPlay composition,
comprehension, specialist registration, or clinical validity. XCAT remained
`unavailable`; the current reachability receipt is
`Proof/xcat/20260810-031333/BLOCKED.md` (ignored local machine evidence).

## 2026-08-10 03:48 SGT — registered Pressure story cues

Build `0.6 (17)` adds a registered-frame visual distinction for the Pressure
story. The exact registered clot-derived target retains a compact coral pulse;
a filled amber disc on the loaded cortical bounds represents affected tissue;
and a wider 14-segment mint boundary represents constrained swelling. The two
tissue cues use the loaded registered-v2 brain and clot bounds. They are
qualitative teaching geometry—not a patient segmentation, edema measurement,
diagnosis, prognosis, treatment recommendation, or success state. Prototype-v1
edema, bone-flap, and dural-patch meshes remain disabled.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, XcodeGen regenerated the project, and the OS 26.5
visionOS Simulator Debug build at `/tmp/strokecare-pressure-story-derived`
exited successfully. The built app contains exactly 15 unique USDZ files. Its
executable SHA-256 is
`3d7b90ce9d439fdb9a26ad95ace44014ec2f213b20d2a7a1d9170e9921250b4c`.

The committed source is
`fdab9dd168392e6540a227041bcdcedd4763a3bd`. The deterministic
`--proof-family-pressure-story` route produced
`Proof/79-family-pressure-story-simulator.png`, 3840×2160, SHA-256
`2935c0540a64a365e71eb7b20cf5e20d1003d0a9c70f23d676e78537ba6f07e3`.
The `--proof-clinician-pressure-story` route produced
`Proof/80-clinician-pressure-story-simulator.png`, 3840×2160, SHA-256
`872a180ad555a32e267ad9f173e60f98d1e51e1064c3618fc2a1d5014424bf9b`.
Both images passed the nonblank/centre/colour proof verifier and were visually
inspected for the central anatomy, point field, role-specific timeline, and
three distinct Pressure cues.

This is Simulator render/process evidence only. XCAT was still `unavailable`;
the exact reachability receipt is
`Proof/xcat/20260810-035247/BLOCKED.md` (ignored local machine evidence).
Wearer targetability, stereo depth, AirPlay legibility, comfort, comprehension,
specialist registration review, and clinical validity remain unproven.

## 2026-08-10 04:23 SGT — family Make-space purpose cue

Build `0.6 (18)` adds one registered-frame, permission-controlled purpose cue
to the normal family Make-space path. A high-contrast amber dashed aperture
marks a generic reversible opening concept; a translucent protective cover
moves outward with the existing layer-reveal progress; and a wider mint dashed
boundary expands to communicate additional room. It does not cut anatomy,
choose an access site, rank treatment, show an outcome, or imply repaired
tissue. The mismatched prototype-v1 bone flap and dural patch remain disabled.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-family-purpose-derived` succeeded. The built app contains
exactly 15 unique USDZ files. Its executable SHA-256 is
`8aebad7361809b750d70ec111df1fb7b7e21698828456855df9f4aeec3567ad7`.

The committed source is
`2293265b1fe12e99d34432f0f8e2c4b2085e5326`. The deterministic
`--proof-family-make-space-purpose` route produced
`Proof/81-family-make-space-purpose-simulator.png`, 3840×2160, SHA-256
`96c77c71b9bb0aacd266865371b00e601f8df0352e181fdc4528c587bf31b51e`.
The proof image passed the nonblank/centre/colour verifier and was visually
inspected for the central registered anatomy, attached point field, family
question surface, top three-act timeline, and distinct amber/mint purpose cue.

This is Simulator render/process evidence only. XCAT remained `unavailable`;
the exact reachability receipt is
`Proof/xcat/20260810-042337/BLOCKED.md` (ignored local machine evidence).
Wearer targetability, stereo depth, AirPlay legibility, motion quality,
comprehension, specialist registration review, and clinical validity remain
unproven.

## 2026-08-10 04:37 SGT — audio lifecycle isolation

Build `0.6 (19)` moves the ambient prelude and family-only GPT-Realtime-2.1
player lifecycle to `StrokeAudioPlayback`, an isolated actor. Player creation,
`prepareToPlay`, playback, and teardown no longer execute on the main actor.
Doctor-presenter mode remains silent; no system-speech fallback was added.
The reviewed source change is commit `ffd49c1`.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-audio-actor-19` succeeded. A clean default launch ran as PID
71948 and remained alive after the eight-second observation window. The built
executable SHA-256 is
`aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`, and
the installed review app contains 15 USDZ resources. A focused 45-second
`log show` query covering launch and audio preparation returned
`HANG_MATCHES=0`. Simulator audio-service diagnostics are not evidence of
device playback quality.

XCAT remained `unavailable`; the reachability receipt is
`Proof/xcat/20260810-043035/BLOCKED.md` (ignored local machine evidence).
Realtime proxy playback, interruption handling, hardware continuity, wearer
perception, AirPlay audio, and clinical validity remain unproven.

## 2026-08-10 05:08 SGT — progressive skull-reference depth

Build `0.6 (20)` keeps the cross-source skull comparison out of Calm detail.
The normal Calm selected-point state retains the central registered brain,
arteries, attached region markers, six-beat presenter timeline, direct
viewpoint controls, and point-sourced affected-vessel teaching reference. The
separated skull and generic venous atlas appear only after an explicit Guided
or Scholar depth choice, with their existing specialist-review and colour-
convention boundaries. No asset transform, registration, lesson wording, or
clinical claim changed.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-progressive-skull-20b` succeeded. The built app contains
exactly 15 USDZ resources. Its executable SHA-256 is
`aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`.

After terminating a concurrently running RBC Journey immersive app, two clean
deterministic captures were visually inspected:

- `Proof/84-calm-point-reference-build20-simulator.png`, 3840×2160, SHA-256
  `b2555f6cc2e98b78201961aa61a389a1936be12a95173b3b18ab60ad52cddd98`:
  Calm keeps one central anatomy assembly and the selected-point vessel
  reference; the separated skull and its caption are absent.
- `Proof/85-scholar-layer-hierarchy-build20-simulator.png`, 3840×2160,
  SHA-256
  `da8f8046d19b1c0dfdb4ec3d4fd244ffc580d0eab83f94727018d7bdf906b0b5`:
  Scholar deliberately adds the separated skull, purple venous atlas,
  peripheral Scholar reference rail, and visible review boundary.

Two earlier build-20 screenshots were rejected because the concurrent RBC
Journey process owned the Simulator immersive scene; they were moved out of
the repository and are not evidence. XCAT remained exactly `unavailable` in
CoreDevice. These captures prove Simulator composition only—not wearer
legibility, depth comfort, targeting, AirPlay quality, registration accuracy,
specialist approval, or clinical validity.

## 2026-08-10 05:21 SGT — build 20 idle-performance check

The phase-aware animation timeline in build `0.6 (20)` was measured on the
visionOS 26.5 Simulator using six one-second `ps` samples after an eight-second
settle. The case archive averaged 8.08% CPU, the unfolded case review averaged
0.33%, and the active clinician Pressure lesson averaged 28.17%. Two active-
lesson screenshots eight seconds apart had different hashes, so the idle gate
did not freeze visible lesson motion.

A five-second intake `sample` pass found the main thread waiting in `mach_msg`
for 3,462 of 3,742 samples and no Stroke Care function in the collapsed hot-
stack list. The full method, raw values, limitations, and verdict are in
`Proof/performance/20260810-build20-simulator-idle.md`.

This materially improves on issue #30's historical 67.3–78.4% Simulator idle
samples, but the historical command was not preserved and XCAT remains
`unavailable`; this is therefore partial Simulator evidence, not a controlled
hardware benchmark or release-performance proof.

## 2026-08-10 05:36 SGT — app-facing venous-atlas provenance

Build `0.6 (20)` now surfaces the optional clinician Guided/Scholar venous
reference's provenance beside the existing generic-atlas, colour-convention,
and specialist-review boundary. The compact second line names Z-Anatomy and
BodyParts3D and states CC BY-SA; the complete source URLs, versions,
attribution text, modification note, and ShareAlike terms remain bundled in
`THIRD_PARTY_NOTICES.txt`. No patient-facing surface, anatomy transform,
registration claim, clinical wording, or asset count changed.

`python3 Tests/verify_contract.py` returned `STROKE_CARE_CONTRACT=PASS`,
`git diff --check` passed, and the OS 26.5 visionOS Simulator Debug build at
`/tmp/strokecare-build20-attribution` succeeded. The built app contains exactly
15 USDZ resources and the 1,515-byte third-party notice. Its executable
SHA-256 remains
`aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`.

`Proof/86-scholar-attribution-build20-simulator.png`, 3840×2160, SHA-256
`0fc43e4288b0962a675d7ee5ba1f01044e25b87b6eea66a82ab9278f8c976298`,
was captured after terminating the competing RBC Journey immersive process.
It visibly retains the central registered teaching anatomy, six-beat timeline,
attached region points, direct viewpoint/detail controls, separated skull,
venous reference, and the new atlas attribution. This is Simulator composition
evidence only. It does not prove headset legibility, legal sufficiency,
registration accuracy, specialist approval, or clinical validity; XCAT remains
unavailable.
