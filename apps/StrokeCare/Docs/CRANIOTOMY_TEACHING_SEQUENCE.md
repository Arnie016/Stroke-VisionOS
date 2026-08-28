# Craniotomy teaching sequence

Status: **PENDING CLINICIAN AND NEUROANATOMY REVIEW**
Content version: `SC-AIS-001.13`
Audience: clinician-led discussion with a patient or family; generic teaching
anatomy only.

This sequence translates the six Page 2 Figma frames into one non-graphic,
reversible spatial explanation. It is not a procedural simulator, treatment
recommendation, consent flow, patient scan, or surgical-training SOP.

## Interactive layer study, 26 August 2026

Doctor presenter → Access → the access point opens an explicitly separate,
non-operative model study. The existing permission prompt still precedes the
first reveal. The source-derived bone flap and conceptual dural flap join the
registered brain directly; the parietal aperture remains only as a faint
orientation boundary. The face, teeth, skull base, full dural shell, pressure
decorations, and detached point note stay hidden. If either movable asset is
unavailable, the compact point note and disabled fallback action remain instead.

The app equips the generic forceps prop and holds the brain's view still.
Selecting **Bone** or **Dura**, then pinching its mint handle, lifts or returns
that authored mesh. Pinch-and-drag allows intermediate positions along the
authored closed-to-separated pose. A large Lift/Return control provides the
same action without a spatial drag. This does not detect tool-tip contact or
simulate force, cutting, bleeding, drilling, or tissue deformation.

The model prevents the inner cover moving through the outer one and explains
how to return them in reverse order. **Reset** restores both model poses;
**Back** restores the preceding view and tool selection. Reset is not a
portrayal of clinical closure or treatment success. In particular, this is
not an immediate bone-replacement step for decompressive craniectomy.

The anatomical distinction is supported by [Johns Hopkins Medicine's
craniotomy overview](https://www.hopkinsmedicine.org/health/treatment-tests-and-therapies/craniotomy)
(checked 26 August 2026): craniotomy and craniectomy differ in whether/when the
bone flap is replaced. That source is context, not validation of this app's
geometry, tool behavior, or timing. The complete interaction remains pending
specialist and physical-headset review.

`--proof-access-layer-open` and `--proof-access-layer-closed` launch only after
both actual movable assets load. They exercise the same state actions as the
controls. The pure state verifier is `Tests/verify_access_layer_study.swift`.

## Implemented role contract

- **Patient / family** retains the original three calm acts: `Orient`,
  `Pressure`, and `Make space`.
- **Doctor presenter** sees six compact, directly revisitable checkpoints
  below the anatomy. `Next` and `Back` traverse those checkpoints,
  while a direct pinch returns to any earlier checkpoint.
- Checkpoints 3–6 reuse the existing explicit permission prompt before any
  layer separation. Refusal pauses the explanation without advancing.
- The left presenter cues change with the active checkpoint. They remain
  concise prompts, not a script or generated clinical recommendation.
- Checkpoint 6 returns the teaching layers to their assembled state. It does
  not show suturing, fixation, a wound, or a success animation.

This implementation is derived from the user-supplied Page 2 screenshots.
Figma MCP structured context was unavailable because the authenticated Starter
plan had reached its tool-call limit, so 1:1 Figma validation remains pending.

Build `0.6 (24)` keeps the six rows below as actual scene states and adds a
Scholar-only illustrative exterior cutaway for orientation. Build `0.6 (23)`
first made the six rows below actual scene states rather than six
labels over the same three-act composition. Access separates the generic skull
reference, Covering offsets the conceptual dura after permission, Purpose alone
reveals the reversible aperture, and Closure returns the references to an
assembled teaching view. These remain explanation states, not operative steps.

| Beat | Spatial teaching state | Presenter language boundary |
| --- | --- | --- |
| 1. Confirm context | Registered-v2 brain, arteries, illustrative clot, optional skull context, and quiet anatomy points. | Explain what the generic model can show. Do not claim an exact patient position or imaging finding. |
| 2. Explain possible access | A clinician-only semantic skull reference and an illustrative access-area cue. | Explain where a skull opening may be discussed. Do not drill, cut, score, size, or recommend an access site. |
| 3. Explain the covering | After explicit layer-separation permission, the conceptual dura changes opacity/offset. | Describe the dura as a protective covering. Do not portray graphic opening or operative technique. |
| 4. Explain the purpose | Layers separate reversibly to show additional room within a fixed boundary. | Say “making room,” never “repairing” or reversing established injury. |
| 5. What the team checks | A static authored checklist names pressure, bleeding, imaging, and monitoring as discussion topics. | Do not show pass/fail, automated escalation, outcome prediction, or a “controlled” animation. |
| 6. Explain closure | The same teaching layers return to the assembled state. | Explain the concept of returning layers; do not animate suturing, fixation, wound closure, or success. |

The `Orient → Pressure → Make space` timeline remains the patient/family
story. In doctor-presenter mode it becomes the six nested checkpoints above,
not six additional permanent tabs. A selected anatomy point may reveal one
depth-linked teaching reference; all other labels remain quiet.

## Post-explanation handoff

The closing companion shows a **Shared discussion** summary with three authored
sections: what the model showed, what it cannot answer, and questions for the
clinical team. It does not generate or rank a care plan. Any recommendation or
decision must come from the treating team using the person's examination,
imaging, timing, history, preferences, local protocol, and full situation.

## Release gates

1. Static contract, strict USD validation, and a clean Simulator build.
2. Simulator composition proof for the clinician Guided layer hierarchy.
3. Physical XCAT review of point targeting, direct views, depth, legibility,
   performance, AirPlay composition, sound, and any supported feedback.
4. Clinician/neuroanatomy approval of the full sequence, registration, copy,
   timing, permission/refusal path, and closing summary.

Simulator or build evidence does not establish wearer comfort, gesture quality,
family comprehension, clinical validity, or procedural correctness.
