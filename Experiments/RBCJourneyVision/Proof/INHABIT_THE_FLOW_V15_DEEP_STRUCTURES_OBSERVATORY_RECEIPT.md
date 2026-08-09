# V15 deep-structures observatory receipt

Status: **PASS — bounded visionOS Simulator build and composition proof**

Date: 2026-08-10 (Asia/Singapore)

## Bounded experiment

Replace the deep-structures destination's generic floating hero with one
inhabited lesson about central nuclei, the internal-capsule corridor, and small
perforator approaches. Preserve the existing Locate → X-ray → Flow grammar,
one information surface, direct user choice, Pause, and Reduce Motion. Do not
add an external brain model, forced locomotion, a second dashboard, an app
camera, paid narration, or a patient-specific claim.

## Implemented scene

- One registered combined deep-structures source expanded as dim environmental
  context. Its source mesh has no semantic subparts and is not presented as a
  segmentation.
- Six relational caudate, thalamus, and lentiform guide contours plus 192
  sparse nucleus points. These orient the wearer; they are not measured
  boundaries.
- Ten depth-weaving internal-capsule guide fibers between the relational
  nuclei.
- Eighteen qualitative arterial paths: bilateral M1 parent approaches, twelve
  M1 lenticulostriate branches, bilateral anterior-choroidal approaches, and
  bilateral posterior thalamic perforator approaches.
- Twenty tangent-aligned moving fronts. Fronts are visible only in Flow and
  hold their exact pose under Pause or Reduce Motion.
- Locate, X-ray, and Flow reuse the existing HUD and direct discovery targets.
- The optional family companion uses the exact visible title and explanation;
  no provider call was made in this V15 run.

## Medical and representation boundary

Copy was constrained by:

- NCBI Bookshelf, *Neuroanatomy, Basal Ganglia*:
  https://www.ncbi.nlm.nih.gov/books/NBK537141/
- NCBI Bookshelf, *Neuroanatomy, Cerebral Blood Supply*:
  https://www.ncbi.nlm.nih.gov/books/NBK532297/
- NCBI Bookshelf, *Neuroanatomy, Internal Capsule*:
  https://www.ncbi.nlm.nih.gov/books/NBK542181/

The scene does **not** prove or represent semantic segmentation, tractography,
fixed arterial territories, a complete vascular map, patient anatomy,
measured calibre, physiological timing, pressure, perfusion, CFD, tissue
outcome, diagnosis, or clinical guidance. Specialist medical review was not
run.

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (62/62).
- Generic visionOS Simulator build: `** BUILD SUCCEEDED **`.
- SDK: `xrsimulator26.5`; deployment target remains visionOS 2.0.
- Product: 55 MiB app bundle with a universal Simulator executable, arm64 +
  x86_64.
- Installed and launched on the booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`.
- No `PerspectiveCameraComponent` exists in the verified source contract.

## Visual review

Proof 160 was rejected as an empty launch-race capture. Proof 161 was rejected
because the nucleus guides read as flat ovals, the capsule as bright
parentheses, and the perforators as a cable forest. Flow proofs 164–165 were
also rejected for that cable-forest reading. Proofs 162–163 and 166–167 were
intermediate iterations and are superseded, not promoted.

Accepted bounded Simulator captures are 3840 × 2160:

| Proof | Reading | SHA-256 |
|---|---|---|
| `168-deep-observatory-locate-accepted.png` | Registered internal context, relational nucleus constellations, and restrained corridor guides | `ff828bcbb74214a951d355a32c89c9988ec7ae9edf3b2f190e97c0b5450c03b3` |
| `169-deep-observatory-xray-accepted.png` | Ten-fiber internal-capsule corridor isolated between the relational nuclei | `289ef37376d59365efe3e66ab05f5222e80ed7962f7bdd034fe827a61e16b754` |
| `170-deep-observatory-flow-a-accepted.png` | First 20-front pose across thin, curved perforator approaches | `9436ca3dfca5c7c5f65571a638fa3b3842733e0e2c3a4e2a8294e12c7cc1b624` |
| `171-deep-observatory-flow-b-accepted.png` | Distinct Flow pose two seconds later | `c203a7e7e6475869a2cf1a443cf509a14db05e911e2caa119f2c2e17f8777997` |

The two Flow hashes and visible front positions differ. This proves the
deterministic Simulator scene advances; it does not prove blood-cell motion or
physiological flow.

## Source hashes at acceptance

| File | SHA-256 |
|---|---|
| `Sources/RBCJourneyScene.swift` | `d661b6f29b089744edadeb02024733e36671d644fd13097c06f648808d58729e` |
| `Sources/RBCJourneyModel.swift` | `f7b122d46cc7d78867b966676c47367d8c89dda9b3c06d6d880be79f08399b03` |
| `Sources/RBCJourneyHUD.swift` | `aa293fcd3c63fb4f11b57ed224a0e4ce506b3d3122540d3a506a9a420933d671` |
| `Docs/medical-content-canon.md` | `0af06444bd985ebc9812a94f4a060ed572d69a4f71766b000727935b2f404a2c` |
| `README.md` | `0172ef3edb9e80db630ae04cf9c5fe43649b7c4af138eb71dcfe7eee8d60760b` |
| `AGENTS.md` | `4088bd17f2cbd2e74d4b638865e343fd90650fc1bf5b5aab616ec7640c1cb60b` |
| `Tests/verify_contract.py` | `25402c5e10a9073b6c299f5db04379852a64946c6761057a249797868f2fea6a` |

## Unproven gates

- Physical Vision Pro `XCAT` install, launch, hand interaction, comfort, and
  wearer judgment: **NOT RUN**.
- Medical specialist review, teaching validation, accessibility audit with a
  human, and clinical validation: **NOT RUN**.
- Provider narration for this deep-structures copy: **NOT CALLED**.
- Performance profiling on physical hardware: **NOT RUN**.

Nearest honest limitation: the destination now surrounds the wearer with a
legible central-corridor lesson and visibly directional perforator routes, but
its nucleus, capsule, and vessel overlays remain authored orientation
abstractions rather than a segmented, photoreal, patient-derived, or
physiological reconstruction.
