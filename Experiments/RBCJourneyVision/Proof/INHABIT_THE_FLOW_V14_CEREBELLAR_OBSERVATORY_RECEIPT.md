# V14 cerebellar observatory receipt

Status: **PASS — bounded visionOS Simulator build and composition proof**

Date: 2026-08-10 (Asia/Singapore)

## Bounded experiment

Replace the cerebellum destination's generic floating hero with one stable,
surrounding folds-to-flow lesson. Preserve the existing Locate → X-ray → Flow
grammar, one information surface, direct user choice, and Reduce Motion. Do not
add an app camera, forced locomotion, a second dashboard, paid narration, or a
patient-specific claim.

## Implemented scene

- One registered cerebellum source expanded as dim environmental context.
- One asymmetric hemisphere-and-vermis constellation plus peripheral depth
  ribs; this is an orientation outline, not segmentation.
- 47 curved, depth-staggered folial guide bands.
- 13 branching arbor-vitae guide paths.
- 15 qualitative vertebral, basilar, SCA, AICA, PICA, and distal folial paths.
- 22 tangent-aligned moving fronts. Fronts are visible only in Flow and hold
  their exact pose under Pause or Reduce Motion.
- Locate, X-ray, and Flow reuse the existing HUD and direct discovery target.
- The optional family companion reads the exact visible title and explanation;
  no provider call was made in this V14 run.

## Medical and representation boundary

Copy was constrained by:

- NCBI Bookshelf, *Neuroanatomy, Cerebellum*:
  https://www.ncbi.nlm.nih.gov/books/NBK538167/
- Bonasia et al., *The Arterial Anatomy of the Cerebellum—A Comprehensive
  Review*:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC11352334/

The scene does **not** prove or represent histology, territory segmentation, a
complete vascular map, patient anatomy, vessel dominance, measured calibre,
physiological timing, pressure, perfusion, CFD, tissue outcome, or clinical
guidance. Specialist medical review was not run.

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (61/61).
- Generic visionOS Simulator build: `** BUILD SUCCEEDED **`.
- SDK: `xrsimulator26.5`; deployment target remains visionOS 2.0.
- Product: universal Simulator executable, arm64 + x86_64.
- Installed and launched on the booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- No `PerspectiveCameraComponent` exists in the verified source contract.

## Visual review

The first pass, proofs 152–155, was rejected: its folia read like ruled lines,
its arbor guide was too classroom-diagrammatic, and its contour dominated the
scene. Those candidates remain unpromoted and are not part of this receipt.

Accepted bounded Simulator captures are 3840 × 2160:

| Proof | Reading | SHA-256 |
|---|---|---|
| `156-cerebellar-observatory-locate-v2.png` | Asymmetric surrounding fold field and restrained constellation | `02c0fdcf173b6e22151a8637882366450baba51ecb726b9719e7dae974e3ac58` |
| `157-cerebellar-observatory-xray-v2.png` | Folia plus 13-path arbor-vitae orientation guide | `dc3555659dc60a59f92c853966dcbc6a74d5c98a12130940ce559e6994a1dcae` |
| `158-cerebellar-observatory-flow-a-v2.png` | First 22-front Flow pose | `0f9ad7192841e9d18098ac72b18eb145dd46e7f5643a5ab41d991a9673a0f274` |
| `159-cerebellar-observatory-flow-b-v2.png` | Distinct Flow pose two seconds later | `458cd063e9235442bc2979b64a01ebfd92b4959b55598ea6cd4f6fb8b3dc0cb3` |

The two Flow hashes and visible front positions differ. This proves the
deterministic Simulator scene advances; it does not prove physiological motion.

## Source hashes at acceptance

| File | SHA-256 |
|---|---|
| `Sources/RBCJourneyScene.swift` | `c44fbb96880a093d802e32ea1130f2ac51a681a20d37862e218490fd1a8d3c31` |
| `Sources/RBCJourneyModel.swift` | `c3cfda0893e84745bffd83eb8ff645445dfb96d6dc171d90b734966c236c2d7c` |
| `Sources/RBCJourneyHUD.swift` | `6e836afece35679ef81cd811152e9d88bfe063eb626ef2320d2edd1d762ca850` |
| `Docs/medical-content-canon.md` | `896496251e76ce1c7a5fcdb7381ca46f3410731f974d57759c404490adb02487` |
| `AGENTS.md` | `2efb8c9b58eafcf93fd64fbd45b2bae4965ca5ee1dda4a1c20fee9ab74e312ac` |
| `Tests/verify_contract.py` | `fca5245ec905cdc0dd33bdb8626ee49e5d3c7d34d17a99ffe96d3e69282e1b86` |

`README.md` was subsequently line-wrapped without semantic change, so its final
hash is recorded by the commit rather than the pre-wrap table.

## Unproven gates

- Physical Vision Pro `XCAT` install, launch, hand interaction, comfort, and
  wearer judgment: **NOT RUN**.
- Medical specialist review, teaching validation, accessibility audit with a
  human, and clinical validation: **NOT RUN**.
- Provider narration for this cerebellar copy: **NOT CALLED**.
- Performance profiling on physical hardware: **NOT RUN**.

Nearest honest limitation: the Simulator view now reads as a more organic
spatial observatory, but the folial and arterial geometry remains an authored
teaching abstraction rather than a photoreal or patient-derived reconstruction.
