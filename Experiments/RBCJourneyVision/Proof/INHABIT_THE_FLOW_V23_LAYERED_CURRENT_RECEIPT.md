# Inhabit the Flow V23 — layered current receipt

Date: 2026-08-10 (Asia/Singapore)

Verdict: `PASS_SIMULATOR_LAYERED_DIRECTION_AND_MOTION_GATE`

This receipt proves a local visionOS Simulator composition and motion slice. It
does not prove XCAT visibility, binocular depth, physical comfort, hand input,
medical-specialist review, teaching efficacy, patient anatomy, clinical safety,
or quantitative hemodynamics.

## Bounded outcome

- The arterial ride now uses eight low-opacity offset round flow strands rather
  than one hairline route or a flat ribbon card.
- Fourteen compact tangent-aligned fronts each carry an arrowhead, tail, and
  fading wake.
- Twenty-eight clones of the provenance-tracked authored biconcave cell move,
  mildly deform, and divide between the two routes.
- The near edge of animated flow moved from `z=-0.72 m` to `z=-1.18 m` to remove
  near-field cell clutter.
- The neighboring intravascular direction cue changed from teal to warm amber.
  Teal remains only as destination navigation and does not encode venous or
  deoxygenated blood.
- `--proof-flow-phase-18` and `--proof-flow-phase-68` hold two exact phases of a
  canonical twelve-second cycle. Live flow remains driven by
  `RealityKit.SceneEvents.Update` and Pause/Reduce Motion still hold that clock.

## Honest rejection history

1. The first candidate was rejected because near-field cells and head-on cone
   fronts read as large glossy balls.
2. The second candidate fixed scale but was rejected because crossed custom
   ribbon planes produced a translucent triangular card at the fork.
3. The promoted candidate uses round offset tube meshes; the card artifact is
   absent in the reviewed early and late stills.

The rejected images were moved outside the worktree to
`/tmp/rbc-v23-rejected/` and are not part of this promotion.

## Medical boundary

NCBI's hemodynamics overview supports using layers to explain downstream flow,
while Secomb's microvessel review describes blood as a concentrated suspension
of flexible biconcave cells and treats realistic multi-cell simulation as a
separate computational challenge:

- https://www.ncbi.nlm.nih.gov/books/NBK470310/
- https://pmc.ncbi.nlm.nih.gov/articles/PMC3115406/

The strand widths, wake spacing, cell count, deformation, and small lane-speed
differences are therefore qualitative choreography only. They are not plasma,
a velocity or wall-shear profile, hematocrit, cell-collision dynamics,
non-Newtonian rheology, pressure, perfusion, turbulence, or CFD.

## Verification

Contract:

```text
70 checks passed
RBC_JOURNEY_CONTRACT=PASS
```

Generic visionOS Simulator build:

```text
Xcode 26.6 (17F113)
SDK XRSimulator 26.5
CODE_SIGNING_ALLOWED=NO
** BUILD SUCCEEDED **
app bundle: 57,560 KiB
```

Simulator:

```text
Apple Vision Pro
UDID F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777
state: Booted
```

Motion encode:

```text
codec: H.264
resolution: 3840x2160
rate: 60 fps
frames: 462
duration: 7.690 s
bytes: 22,381,732
```

Two extracted live-video frames had different SHA-256 hashes, and the eight
sampled one-second frames in the contact sheet visibly change cell/front
positions while the observation origin and interface remain stable.

## Promoted evidence

- `226-layered-current-phase-18-volumetric.png` — deterministic early phase
- `227-layered-current-phase-68-volumetric.png` — deterministic late phase
- `228-layered-current-live-motion.mp4` — live unpaused Simulator motion
- `229-layered-current-motion-contact-sheet.png` — eight one-second samples

SHA-256:

```text
1064f6c97a067092c091b1c228b9646740577f8afebc8fdc8b3bef6e13176e7a  226-layered-current-phase-18-volumetric.png
eb111fd7ab4a40fe55bc3e9cce300ea84464207cb252d12dee0869c396bbc7c1  227-layered-current-phase-68-volumetric.png
a0dca61b4d4bc542967aefb5f553a5aff29fbcd12fe94407d9459a69d43fd09e  228-layered-current-live-motion.mp4
22aaa5254830d66a497335361d4ea69e539e57b750cd6eb8a38f4534c43033f8  229-layered-current-motion-contact-sheet.png
ec0757f32c3944e918d9ef06c05c41f9095b5d646bcfa914d03a94ad38d76d72  Sources/RBCJourneyScene.swift
1d871788c9a49749872d5ef8cacc9e2dc2acd62da9c7a23315e3a0cd067b2629  Sources/RBCJourneyModel.swift
35bc469959870175282614409d9a7cfb2b646e5f3598e161e67a651fd1c83ac7  Sources/RBCJourneyImmersiveView.swift
d646d5640aafca8e976e2ee71456d1f93e4ed7b1d278976f015086fcb9391e48  Tests/verify_contract.py
```

## Proof ladder

| Rung | Status |
|---|---|
| Contract | PASS — 70/70 |
| Generic Simulator build | PASS |
| Booted Simulator install and launch | PASS |
| Deterministic early/late composition | PASS |
| Live Simulator motion recording | PASS |
| XCAT install/launch | NOT RUN — `XCAT` is currently unavailable |
| Wearer motion/comfort judgment | NOT RUN |
| Medical-specialist review | NOT RUN |
| Clinical validation | NOT RUN |

## Next scientific fidelity gate

Do not add more decorative particles. The next meaningful rung is a bounded,
validated asset experiment that compares a cell-resolved or continuum blood
simulation against this qualitative RealityKit choreography, with explicit
geometry scale, boundary conditions, solver assumptions, frame/storage budget,
USD export fidelity, and specialist review. It must remain offline evidence
until runtime and scientific gates both pass.
