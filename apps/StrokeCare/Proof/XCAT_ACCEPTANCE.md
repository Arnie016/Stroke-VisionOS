# XCAT acceptance protocol

## Machine gate

Run from `apps/StrokeCare`:

```bash
Scripts/deploy_xcat.zsh
```

The command stops before building or installing unless XCAT is reachable. A
successful run creates a dated folder under `Proof/xcat/` containing the signed
build log, install receipt, installed-app query, foreground-launch receipt, and
running-process query. It launches the deterministic `--hackathon-demo` route
so the wearer starts at the prelude and follows the complete 0.6 flow. It also
creates `WEARER_RESULT.md` with every human field set to `NOT RUN`.

## Wearer gate

The wearer completes one 90-second pass after the machine receipt succeeds:

1. Confirm the prelude reveals two short calm lines before **Doctor → family**
   and **Clinician teaching** appear. Confirm the local audio bed can be muted.
2. Choose **Doctor → family**. Confirm the floating case exhibit is left of a
   deliberately empty centre; no brain or office furniture is visible.
3. Pinch FILE 78 and carry it to the centre. Confirm the generic case figure,
   speech, arm, time, and open-question artifacts appear while anatomy remains
   hidden.
4. Select **Begin family view**. Confirm the complete intake exhibit disappears
   before the brain owns the centre; no files or cabinet remain beside it.
5. Change **Brain regions → Blood flow**. Confirm five small points stay attached
   to the anatomy and the direction chevrons follow the visible vessel route.
6. Use **Point**, then select the affected area. Confirm a visible question
   marker appears at brain depth. Orbit and two-hand magnification must move the
   complete registered model without detaching the point.
7. Exit and re-enter as **Clinician teaching**. Confirm presenter controls stay
   in the right peripheral field and the left-palm tool selector does not appear
   to the family.
8. Advance through Orient, Pressure, and Make space. Do not approve the layer
   reveal unless the consent question is visible. Confirm **Not now** pauses it.
9. Advance once more. Confirm the closing reflection appears and **Cases**
   returns to the exhibit without a success animation or treatment claim.

Then run one separate clinician-only layer-study pass with the
`--proof-layer-study` launch argument:

10. Switch **Layers → See through → Study apart → Layers**. Confirm the cortex,
   arteries, blockage, and dura return without visible transform drift.
11. Adjust **Brain transparency**. Confirm the vessel remains legible and the
   view still reads as one anatomical relationship in both eyes.
12. Gaze at a mint region point and pinch once. Confirm its title appears.
    Dragging from that point must orient the whole brain; the point must not
    detach from its anatomical layer. Two-hand magnification must still work.
13. Confirm no zipper seam, tearing, cutting sound, or exposed blood appears in
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

After the wearer pass, a clinician reviews the exact 0.6 three-act candidate in
`Docs/ISCHEMIC_STROKE_CLINICAL_REVIEW.md`. Machine, wearer, and clinician gates
remain separate; none implies either of the others.
