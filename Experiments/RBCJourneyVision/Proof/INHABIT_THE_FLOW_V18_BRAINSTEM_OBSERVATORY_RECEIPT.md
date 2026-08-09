# Inhabit the Flow V18 — Brainstem Observatory Receipt

Date: 2026-08-10

Branch: `feature/inside-brain-rbc-journey`

Verdict: **PASS — local Simulator composition and motion proof only**

## Outcome

The Region Portal Reel now has a tenth destination: **Brainstem**. It places
the observation origin inside one upright midbrain–pons–medulla teaching
corridor. Locate, X-ray, and Flow are three readings of the same stable world;
the app never moves an authored camera.

The accepted composition contains:

- three anatomical orientation levels and nine asymmetric broken outline arcs;
- four folded environment-wall sheets and 16 peripheral depth ribs;
- nine longitudinal and nine transverse pontine pathway guides;
- 72 sparse tegmental orientation points;
- 17 continuous vertebral, basilar, cerebellar, posterior-cerebral, and small
  pontine approach paths; and
- 23 tangent-aligned moving fronts with a head, tail, and afterglow.

The combined deep-structure USDZ remains dim relational context and is not
called segmented brainstem anatomy. Two exact named vertebral source nodes are
preserved for registration provenance but disabled visually because their
catalogue-space transform produced two out-of-scale dark loops. The native
continuous paths are the visible lesson.

## Rejected pass

Proofs `183`–`185` were rejected because the Locate view read as three nearly
closed rings and the source vertebral pair read as a dark decorative loop.
Proofs `186`–`189` were an intermediate wall/curve pass. They are retained as
untracked comparison evidence and are not acceptance artifacts.

## Accepted visual review

The following 3840 × 2160 Simulator screenshots were opened at original detail
and reviewed:

| Proof | Reading | SHA-256 | Review |
|---|---|---|---|
| `190-brainstem-observatory-locate-accepted.png` | Locate | `2d89c4ba23430a50af05572ef040abbedb9236cdeff7a4a46ad0d8bf68c47ae7` | Folded side walls establish a corridor; broken asymmetric arcs no longer read as three closed rings. |
| `191-brainstem-observatory-xray-accepted.png` | X-ray | `317f8237e0a60f62ee38fa9988d36f82eb888106ca932f7e801400064d6dcbf3` | Longitudinal, transverse, central-channel, and sparse point layers remain separable. |
| `192-brainstem-observatory-flow-a-accepted.png` | Flow A | `68ac3b1626409d18fe82f69553d3d9a821aee807e5d03b7f7e896cd4a7c25878` | Curved red continuous paths dominate while anatomy guides recede. |
| `193-brainstem-observatory-flow-b-accepted.png` | Flow B | `92daa41a9961af2c92c9356a152daac16e410229e4d1a60a674c297330162572` | Different hash and visibly changed front positions prove motion without camera movement. |

## Verification

```text
python3 Tests/verify_contract.py
65 checks passed
RBC_JOURNEY_CONTRACT=PASS

xcodebuild -project RBCJourneyVision.xcodeproj \
  -scheme RBCJourneyVision \
  -sdk xrsimulator \
  -destination 'generic/platform=visionOS Simulator' \
  -derivedDataPath /tmp/rbc-journey-v18-derived \
  CODE_SIGNING_ALLOWED=NO build
** BUILD SUCCEEDED **
```

The generated app executable is a universal x86_64 + arm64 Mach-O. The local
Debug Simulator app bundle is approximately 55 MiB. `git diff --check` passes.

Deterministic routes:

```text
--proof-region-9
--proof-region-9 --proof-region-mode-xray
--proof-region-9 --proof-region-mode-flow
```

## Medical and evidence boundary

Source wording is constrained by the NCBI Bookshelf brainstem,
vertebrobasilar-system, cerebral/spinal blood-supply, and basilar-artery
references recorded in `Docs/medical-content-canon.md`.

This proof demonstrates local code, contract behavior, a generic visionOS
Simulator build, a reviewed Simulator composition, and changing rendered flow
fronts. It does **not** demonstrate patient anatomy, segmentation, histology,
nuclei mapping, tractography, measured velocity, pressure, perfusion, CFD,
diagnosis, treatment guidance, physical XCAT interaction, wearer comfort,
clinical accuracy, or specialist review.

## Source hashes

```text
d398a36003e9f3d5ee885af90abd773774ed4f306fbb65110fd208da1b122abf  Sources/RBCJourneyModel.swift
6e11d524172cba55495c91d5f32eb8cb56407fc8ea7ab01205468375bd3e0ee5  Sources/RBCJourneyHUD.swift
a78638d03f59415ed4a4038ad6785564bd328690d79f5dda2db4f0ff37748fcd  Sources/RBCJourneyScene.swift
21ede3fea08dc74b773fd69dcd05ddc9d1aa21a75b117b8039ba192b95583017  README.md
81f1229489a0b80961231b8e8f3aa1e1e24163e830cf995536c5a89d341783c6  AGENTS.md
1f90e303941017794c93db3c2fda1b428d9acdd19c9eee85b0da8d74870104d7  Docs/medical-content-canon.md
78baaa97e211bbf71a624f3ca77fed9e968a4a7f52c1dfb660b5a01a4926374d  Tests/verify_contract.py
```
