# XCAT acceptance protocol

## Machine gate

Run from `apps/StrokeCare`:

```bash
Scripts/deploy_xcat.zsh
```

The command stops before building or installing unless XCAT is reachable. A
successful run creates a dated folder under `Proof/xcat/` containing the signed
build log, install receipt, installed-app query, foreground-launch receipt, and
running-process query. It launches the deterministic `--proof-family-question`
scene and creates `WEARER_RESULT.md` with every human field set to `NOT RUN`.

## Wearer gate

The wearer completes one 90-second pass after the machine receipt succeeds:

1. Confirm the proof scene opens with the brain in the centre, family controls
   on the left, FILE 78 on the opposite edge, and **QUESTION HERE** on anatomy.
   This verifies only the intended starting composition.
2. Exit to the files surface. Confirm it says **Pull one case into view**.
3. Pinch FILE 78 and pull it right. Confirm speech, arm, time, and open questions
   appear progressively rather than all at once.
4. Enter **Family questions**. Confirm the brain owns the centre, the case drawer
   and family panel remain at opposite side edges rather than below it.
5. Tap **Point on brain**, then tap the clot area. Confirm a visible question
   marker appears and the story pauses.
6. Exit and re-enter as **Presenter rail**. Confirm patient-facing narration and
   presenter-only wording never occupy the same panel.
7. Advance through Orient, Pressure, and Make space. Do not approve the layer
   reveal unless the consent question is visible.

Then run one separate clinician-only layer-study pass with the
`--proof-layer-study` launch argument:

8. Switch **Layers → See through → Study apart → Layers**. Confirm the cortex,
   arteries, blockage, and dura return without visible transform drift.
9. Adjust **Brain transparency**. Confirm the vessel remains legible and the
   view still reads as one anatomical relationship in both eyes.
10. Gaze at a cyan region point and pinch once. Confirm its title appears.
    Dragging from that point must orient the whole brain; the point must not
    detach from its anatomical layer. Two-hand magnification must still work.
11. Confirm no zipper seam, tearing, cutting sound, or exposed blood appears in
    the imported-brain patient path. The persistent boundary remains a teaching
    model, not a patient scan.

## Record exactly four observations

- `LEGIBILITY`: pass/fail — can every required label be read without leaning?
- `GESTURE`: pass/fail — did file drag, clot tap, orbit, and reset work once each?
- `COMFORT`: pass/fail — any eye strain, neck strain, nausea, or startling audio?
- `COMPREHENSION`: one sentence — what does “make room, not repair” mean?

Save one headset screenshot of the central brain with either the family marker
or presenter rail visible. A Mac Simulator screenshot cannot substitute for it.
Record the screenshot filename and all four observations in the generated
`WEARER_RESULT.md`; do not convert an unobserved field from `NOT RUN` to `PASS`.

## Clinical gate

After the wearer pass, a clinician reviews the exact 0.5 three-act candidate in
`Docs/ISCHEMIC_STROKE_CLINICAL_REVIEW.md`. Machine, wearer, and clinician gates
remain separate; none implies either of the others.
