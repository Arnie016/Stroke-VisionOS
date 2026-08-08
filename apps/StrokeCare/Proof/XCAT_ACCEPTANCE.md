# XCAT acceptance protocol

## Machine gate

Run from `apps/StrokeCare`:

```bash
Scripts/deploy_xcat.zsh
```

The command stops before building or installing unless XCAT is reachable. A
successful run creates a dated folder under `Proof/xcat/` containing the signed
build log, install receipt, installed-app query, foreground-launch receipt, and
running-process query.

## Wearer gate

The wearer completes one 90-second pass after the machine receipt succeeds:

1. Confirm the visible app name is **Stroke Care** and the first surface says
   **Pull one case into view**.
2. Pinch FILE 78 and pull it right. Confirm speech, arm, time, and open questions
   appear progressively rather than all at once.
3. Enter **Family questions**. Confirm the brain owns the centre, the case drawer
   stays to its left, and the family panel stays at the side rather than below.
4. Tap **Point on brain**, then tap the clot area. Confirm a visible question
   marker appears and the story pauses.
5. Exit and re-enter as **Presenter rail**. Confirm patient-facing narration and
   presenter-only wording never occupy the same panel.
6. Advance through Orient, Pressure, and Make space. Do not approve the layer
   reveal unless the consent question is visible.

## Record exactly four observations

- `LEGIBILITY`: pass/fail — can every required label be read without leaning?
- `GESTURE`: pass/fail — did file drag, clot tap, orbit, and reset work once each?
- `COMFORT`: pass/fail — any eye strain, neck strain, nausea, or startling audio?
- `COMPREHENSION`: one sentence — what does “make room, not repair” mean?

Save one headset screenshot of the central brain with either the family marker
or presenter rail visible. A Mac Simulator screenshot cannot substitute for it.

## Clinical gate

After the wearer pass, a clinician reviews the exact 0.5 three-act candidate in
`Docs/ISCHEMIC_STROKE_CLINICAL_REVIEW.md`. Machine, wearer, and clinician gates
remain separate; none implies either of the others.
