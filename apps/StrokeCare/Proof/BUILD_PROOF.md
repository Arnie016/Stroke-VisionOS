# Stroke Care proof receipt — 2026-08-09 01:49 SGT

## Current source

- Product: `Stroke Care`
- Bundle: `com.arnav.StrokeTime`
- Version/build: `0.6 (6)` in current source and Simulator; XCAT still has the
  separately evidenced `0.3 (3)` install.
- Workflow: `Orient → Pressure → Make space` (exactly three internal acts)
- Patient data: none; `CASE-078` is fictional.
- Clinical content version: `SC-AIS-001.1`; clinician review pending.
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
phases: floating case exhibit, case review, and explanation. Docking a file does
not reveal anatomy; the wearer must deliberately enter the selected case. The
entire intake room then disappears. The brain space adds two sparse lesson
families, registered blood-flow direction chevrons, optional versioned system
narration, a quiet audio bed, a non-black horizon hypothesis, and a closing
reflection. None of these proves physical comfort or clinical value.

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

These artifacts prove Simulator-visible UI, model presence, deterministic
teaching states, and the configured visual hierarchy. They do not prove anatomy
validity, physical comfort, clinical value, or perception of spatial audio.

The latest frames demonstrate the 0.6 Simulator composition: a purpose-first
threshold, case review without anatomy, and a separate central blood-flow
lesson with five registered points and direction chevrons. They do not
establish foveal comfort, peripheral legibility, hand-control reliability,
audio perception, or comprehension for a wearer.

## XCAT state

`xcrun devicectl list devices` at 01:45 SGT on 2026-08-09 reports XCAT as
`unavailable` with identifier
`613CC48C-A6AD-5170-A238-D518B6012491`.

The last reachable device inventory reported these historical installations:

| App | Bundle | Version/build | Evidence |
| --- | --- | --- | --- |
| Ashfall Vision | `com.arnav.AshfallVision` | `0.1 (1)` | Installed listing |
| Stroke Care | `com.arnav.StrokeTime` | `0.3 (3)` | Older signed build installed; foreground launch pending |

The earlier presenter-mode source was signed, built for the physical visionOS
destination, and installed over `com.arnav.StrokeTime`. A fresh device query at
17:33 SGT reports Stroke Care `0.3 (3)` installed while XCAT is
`available (paired)`.

Current `0.6 (6)` has passed the static contract, Simulator build, generic
physical-device build, signature verification, and XCAT provisioning-profile
membership check. No 0.6 install or launch has been attempted because the
device is unavailable. A valid signed bundle is not device execution proof.

Two bounded foreground-launch attempts did not return a launch receipt; the
second ended with the explicit 20-second command timeout, and a subsequent
process listing contained no StrokeTime process. Therefore current-version
launch is **not proven**. The earlier `0.2 (2)` launch receipt does not prove the
new binary. XCAT reports a passcode is configured and that it has been unlocked
since boot, but the command line cannot establish that the headset is currently
worn and ready for foreground activation.

The static verifier deliberately prints `physical_device=NOT_PROVEN` because a
source scan cannot establish a device result. The historical section above
proves only the older `0.3 (3)` installation. Install, launch, and wearer
judgment remain unrun for the current `0.6 (6)` binary.

At 01:45 SGT on 2026-08-09, `devicectl` reported XCAT as paired with Developer
Mode enabled but `unavailable`, `ddiServicesAvailable=false`, and
`tunnelState=unavailable`. The device reports visionOS 27.0 beta. Therefore no
0.6 installation attempt was started;
the exact next deployment action is to retry once the headset is powered on,
awake, unlocked, and reachable.

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
