# Stroke Care proof receipt — 2026-08-09 01:49 SGT

## Current source

- Product: `Stroke Care`
- Bundle: `com.arnav.StrokeTime`
- Version/build: `0.6 (11)` on the current feature branch; signed XCAT deployment and
  placement-path receipts are recorded below.
- Workflow: `Orient → Pressure → Make space` (exactly three internal acts)
- Patient data: none; `CASE-078` is fictional.
- Clinical content version: `SC-AIS-001.4`; clinician review pending.
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
