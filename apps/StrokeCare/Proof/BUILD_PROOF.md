# Stroke Care proof receipt — 2026-08-08 19:18 SGT

## Current source

- Product: `Stroke Care`
- Bundle: `com.arnav.StrokeTime`
- Version/build: `0.4 (4)` in current source and Simulator; XCAT still has the
  separately evidenced `0.3 (3)` install.
- Workflow: `Orient → Pressure → Make space` (exactly three internal acts)
- Patient data: none; `CASE-078` is fictional.
- Clinical content version: `SC-AIS-001.0`; clinician review pending.
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

The current source built for the visionOS Simulator on 2026-08-08:

```text
xcodebuild ... -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  CODE_SIGNING_ALLOWED=NO build
** BUILD SUCCEEDED **
```

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

These artifacts prove Simulator-visible UI, model presence, deterministic
teaching states, and the configured visual hierarchy. They do not prove anatomy
validity, physical comfort, clinical value, or perception of spatial audio.

## XCAT state

`xcrun devicectl list devices` currently reports XCAT as
`available (paired)` with identifier
`613CC48C-A6AD-5170-A238-D518B6012491`.

Current user-built apps reported on XCAT:

| App | Bundle | Version/build | Evidence |
| --- | --- | --- | --- |
| Ashfall Vision | `com.arnav.AshfallVision` | `0.1 (1)` | Installed listing |
| Stroke Care | `com.arnav.StrokeTime` | `0.3 (3)` | Current signed build installed; foreground launch pending |

The earlier presenter-mode source was signed, built for the physical visionOS
destination, and installed over `com.arnav.StrokeTime`. A fresh device query at
17:33 SGT reports Stroke Care `0.3 (3)` installed while XCAT is
`available (paired)`.

The PR2-backed `0.4 (4)` build has passed the Simulator contract/build and
visual checks above. It has not yet been signed, installed, or launched on XCAT.

Two bounded foreground-launch attempts did not return a launch receipt; the
second ended with the explicit 20-second command timeout, and a subsequent
process listing contained no StrokeTime process. Therefore current-version
launch is **not proven**. The earlier `0.2 (2)` launch receipt does not prove the
new binary. XCAT reports a passcode is configured and that it has been unlocked
since boot, but the command line cannot establish that the headset is currently
worn and ready for foreground activation.

The static verifier deliberately prints `physical_device=NOT_PROVEN` because a
source scan cannot establish a device result. This dated receipt supplies
separate signed-build and installation evidence; launch and wearer judgment
remain unrun for `0.3 (3)`.

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
