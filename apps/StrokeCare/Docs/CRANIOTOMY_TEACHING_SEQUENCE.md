# Craniotomy teaching sequence

Status: **PENDING CLINICIAN AND NEUROANATOMY REVIEW**
Content version: `SC-AIS-001.5`
Audience: clinician-led discussion with a patient or family; generic teaching
anatomy only.

This sequence translates the six Page 2 Figma frames into one non-graphic,
reversible spatial explanation. It is not a procedural simulator, treatment
recommendation, consent flow, patient scan, or surgical-training SOP.

## Implemented role contract

- **Patient / family** retains the original three calm acts: `Orient`,
  `Pressure`, and `Make space`.
- **Doctor presenter** sees six compact, directly revisitable checkpoints at
  the top of the spatial scene. `Next` and `Back` traverse those checkpoints,
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

| Beat | Spatial teaching state | Presenter language boundary |
| --- | --- | --- |
| 1. Confirm context | Registered-v2 brain, arteries, illustrative clot, optional skull context, and quiet anatomy points. | Explain what the generic model can show. Do not claim an exact patient position or imaging finding. |
| 2. Explain possible access | A clinician-only semantic skull reference and an illustrative access-area cue. | Explain where a skull opening may be discussed. Do not drill, cut, score, size, or recommend an access site. |
| 3. Explain the covering | After explicit layer-separation permission, the conceptual dura changes opacity/offset. | Describe the dura as a protective covering. Do not portray graphic opening or operative technique. |
| 4. Explain the purpose | Layers separate reversibly to show additional room within a fixed boundary. | Say “making room,” never “repairing” or reversing established injury. |
| 5. What the team checks | A static authored checklist names pressure, bleeding, imaging, and monitoring as discussion topics. | Do not show pass/fail, automated escalation, outcome prediction, or a “controlled” animation. |
| 6. Explain closure | The same teaching layers return to the assembled state. | Explain the concept of returning layers; do not animate suturing, fixation, wound closure, or success. |

The top `Orient → Pressure → Make space` timeline remains the patient/family
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
