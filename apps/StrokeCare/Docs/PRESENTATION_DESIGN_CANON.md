# Stroke Care presentation and spatial-design canon

This is the shared design source for the hackathon presentation and future
implementation. It records the team's intention, not proof that every item is
already implemented. Simulator, XCAT wearer, and clinical evidence remain
separate gates.

## One-sentence promise

Stroke Care gives a doctor and a family one calm spatial object to point at,
explore, and discuss when a complex stroke explanation is hard to follow.

## What the judges should feel

1. **Beautifully simple:** one case, one brain, one change at a time.
2. **Empathetic:** the family controls pace and questions; the doctor gets
   private precision without making the patient watch procedural detail.
3. **Intention based:** every annotation answers a question or changes the
   explanation. Nothing exists only as decoration.
4. **Depth over breadth:** demonstrate one reviewed stroke-and-swelling story
   deeply before adding more conditions.
5. **Control and agency:** gaze targets, pinch, orbit, magnification, pause,
   role choice, and return-to-drawer all have visible, reversible outcomes.
6. **Clinical humility:** the scene teaches; it does not diagnose, rank care,
   calculate candidacy, or claim to be a patient scan.

## Spatial hierarchy

| Layer | Placement | Purpose |
| --- | --- | --- |
| Primary | Foveal center | The brain, vessel flow, clot focus, and the current act |
| Secondary | Near-side rail | Doctor-only controls, reference field, and safe-language cue |
| Peripheral | Quiet side edge | Patient drawer and relationship threads; available, not demanding |
| Upper evidence plane | Above the presenter | Searchable citations, pinned sources, and source-bound draft |
| Near-body actions | Bottom/comfortable reach | Pause, back, permission, question, and return |

Each window has one unmistakable title. The current clinician references are
named **Brain regions** and **Procedure path**. The source window is named
**Clinical evidence** and contains search; citations never float as anonymous
cards around the brain.

## Case cabinet: museum discovery, not a dashboard

The cabinet appears only after **Patient files** is selected. It is left
slightly open, like a museum drawer that quietly invites discovery. The user
pulls one physical file from a row rather than choosing from a grid of generic
buttons.

Pulling a file outward progressively reveals:

1. a privacy-safe teaching bust or head silhouette;
2. the reason for this conversation;
3. reviewed case facts and unanswered questions;
4. thin relationship threads to family context, history, imaging, medication,
   and care-team notes;
5. small attention markers below the bust.

The threads express provenance and relationship, not detective drama. Their
endpoints must remain legible and the board must never resemble a chaotic
crime-board collage.

A whole-file pinch and drag returns the case to its drawer. The information
folds back in the reverse order, making the interaction safe and reversible.

## 3D case representation

An Epic MetaHuman or another high-quality bust may be evaluated as an optional
asset source, subject to engine/export compatibility and license review. The
product contract is broader: use a neutral, non-identifying 3D teaching bust,
not a real patient's likeness and not an avatar that claims to reveal disease.

The bust can organize clinician-approved facts such as known diabetes or a
medication issue. It must not infer a condition from appearance, voice, gaze,
facial expression, or behavior.

Marker color reports **information state**, not health status:

- Cyan: reviewed fact connected to the current explanation.
- Amber: needs clinician attention or confirmation.
- Neutral white: contextual information.
- Red: reserved for an explicitly entered emergency state; never generated
  from an unvalidated score.

An exclamation marker means “review this item,” not “this person is unhealthy.”

## Brain and point-field behavior

- Region points are derived from the loaded cortex bounds and parented to the
  registered anatomy, so they orbit and magnify with the brain.
- Points sit just inside the translucent cortex and remain small. Occluded
  points should disappear naturally and become visible as the brain rotates.
- **Brain regions** supports self-directed anatomy exploration.
- **Procedure path** shows an ordered, clinician-reviewed teaching sequence.
- Selecting a point may progressively focus the space, but the wearer keeps
  control through pause, back, reset, and the Digital Crown.
- A point is not meaningful until it has a title, an intended question, an
  approved visual response, and a source or explicit review status.
- A point is an anatomy-anchored handle, not a detachable object. Gaze and pinch
  select it; dragging or magnifying from that point orients the whole registered
  anatomy while the point remains attached to its region.

## Reversible layer study

The presenter has three mutually exclusive views:

1. **Layers** keeps the registered anatomy assembled.
2. **See through** changes cortex transparency while vessels and blockage remain
   spatially registered.
3. **Study apart** adds only small, reversible offsets between semantic layer
   wrappers so their relationship can be inspected.

The sequence is a visual reveal, never literal peeling. Fade one protective
layer at a time; keep the brain intact; keep vessels and the teaching clot
distinct. The family-facing permission cue is “May I make the protective
layers transparent?” Never use zipper, tearing, cutting, drilling, or blood
language. Returning to **Layers** must restore the assembled view without
drift.

## Patient and clinician lenses

### Patient or family

The spatial world is intentionally incomplete. A few softly presented points
invite questions such as “What changed?” or “Why does the brain need room?”
The family can point at the actual depth of the teaching anatomy, ask for
clarification, replay, pause, and exit. No instrument tray, eligibility score,
or graphic procedure is visible.

### Clinician presenter

The clinician sees the three acts, layer state, careful-language boundary,
reference-field toggle, source button, and family question marker. Private
evidence stays on a separate plane so it cannot eclipse the shared model.

### Future senior-clinician rehearsal

Detailed tools or operative sequencing require a separate, authenticated
training mode and specialist sign-off. Prototype surgical tools remain
quarantined from the patient path until registration, fidelity, licensing, and
clinical review all pass.

## Three-act story

1. **Orient — The brain needs space.** Start with the whole picture.
2. **Pressure — The artery closes. The brain begins to swell.** Keep injury,
   swelling, and pressure distinct.
3. **Make space — The operation gives swelling somewhere safe to go.** Explain
   purpose and uncertainty without promising recovery.

## Evidence space

The clinician opens **Clinical evidence**, searches the reviewed source
catalog, pins relevant items, and composes a source-bound teaching draft. A
source always shows its complete citation, stable link, what it supports, and
its limit. Generated language stays a draft until clinical review.

The first catalog uses the AHA/ASA acute ischemic stroke guideline and NICE
stroke/decompressive-hemicraniectomy guidance. These sources support teaching
and conversation; they do not determine treatment for the wearer.

## 90-second presentation script

**0–15 seconds — The gap**

“In a stroke emergency, a family may hear accurate words but still lack a
shared picture. Stroke Care gives the doctor and family one calm spatial object
to point at together.”

**15–35 seconds — Discover the case**

Open Patient files. Pull one file from the slightly open cabinet. Let the bust,
review markers, and relationship threads unfold. Say: “The case appears only
when invited, and every thread shows why a fact is here.”

**35–65 seconds — Share the brain**

Enter the family lens, rotate the brain, and select a cortex-attached point.
Move through Orient, Pressure, and Make space. Say: “The family controls pace;
the point remains at the anatomy's depth; the doctor explains one change at a
time.”

**65–82 seconds — Private precision**

Show the clinician rail, switch Brain regions to Procedure path, then open
Clinical evidence and search a source. Say: “Clinical precision is available
without placing a wall of text between doctor and patient.”

**82–90 seconds — Boundary**

“This is a fictional teaching scenario, not a scan or decision aid. Our next
gates are clinician review and an XCAT wearer session.”

## Acceptance ladder

1. Static contract passes.
2. visionOS Simulator build succeeds.
3. Clean Simulator screenshots prove layout only.
4. Signed install and launch on XCAT are recorded separately.
5. A wearer judges comfort, gaze targeting, depth, and legibility.
6. Stroke neurology, neurosurgery, and neurocritical-care reviewers approve
   medical copy, anatomy, timing, uncertainty, and procedural representations.

No lower rung implies a higher one.
