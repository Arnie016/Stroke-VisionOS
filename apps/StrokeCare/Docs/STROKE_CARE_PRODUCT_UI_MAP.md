# Stroke Care product and spatial UI map

## Product promise

Stroke Care turns one fictional stroke case into a shared spatial explanation.
The family and clinician handle the same case object, look at the same anatomy,
and move through one visual change at a time. The product is not a notes app, a
patient record, a scan viewer, or a treatment decision aid.

## Core spatial choreography

```mermaid
flowchart LR
    A["Two-beat calm prelude"] --> A2["Choose Doctor to family or Clinician teaching"]
    A2 --> B["Look left: patient-file exhibit"]
    B --> C["Pinch and carry File 78"]
    C --> D["Drop at central case dock"]
    D --> E["Case review unfolds around a generic figure"]
    E --> E2["Explicitly enter this case"]
    E2 --> F["Library disappears; brain enters primary focus"]
    F --> G["Region point field"]
    F --> H["Blood-flow lesson field"]
    F --> I["Transparent layer study"]
    H --> J["Clinical evidence above presenter"]
    E --> K["Return file to the library"]
```

The interaction borrows the useful spatial principle of a visionOS DJ deck:
the library is left, the working object is centre, the precision controls are
right, and finished material returns to its origin. The user turns their head
and carries an object; they do not navigate a stack of desktop pages.

## Room map

| Zone | Object | Why it occupies that space | Current interaction |
| --- | --- | --- | --- |
| Left peripheral, intake only | Case-file exhibit and archived files | Browsable library; present but not demanding | Gaze + pinch File 78 |
| Centre near-field | Empty circular case dock | Makes the user's next action self-evident | Carry and drop file |
| Centre foveal | Brain, arteries, blockage marker, affected territory | The shared explanatory object | Gaze, select, orbit, magnify |
| Around selected case, review only | Case facts and open questions | The clinician connects signals before entering anatomy | Progressive reveal |
| Around anatomy, explanation only | Selected lesson point or annotation | Context stays close to what it explains | Point selection |
| Top spatial spine | Head → brain → artery → clot / pressure space | Orientation without another bottom strip | Changes with the current act |
| Right secondary | Compact presenter rail | Precision controls without covering the shared model | Act, layer, field, evidence, pause |
| Left hand, clinician only | Collapsed radial tool cuff | Instruments follow the clinician instead of occupying a room window | Open, gaze, pinch tool |
| Right hand, clinician only | Selected teaching prop | Makes selection physically legible at useful scale | Held display; no cutting or anatomy mutation |
| Upper evidence plane | Clinical evidence | Sources sit above, outside the family explanation | Search, pin, open, compose draft |

## State-by-state UI map

### 0. Doorway

The only conventional window is a small system-required threshold. Two short,
non-statistical sentences establish urgency and calm; the wearer then chooses
**Doctor → family** or **Clinician teaching**. A quiet local audio bed is
optional. It carries no patient cards, notes, dashboard, or anatomy controls.

### 1. Spatial patient exhibit

![Spatial patient exhibit](../Proof/27-spatial-case-intake.png)

- The archive is a floating RealityKit exhibit at the user's left—not an imitation office cabinet.
- The gold folder is a direct/indirect input target with collision and hover.
- The centre dock is deliberately empty.
- The anatomy remains hidden after docking; docking opens a distinct case-review phase.
- Dragging away and releasing returns the file to the cabinet.

Current limitation: this is a functional geometric prototype, not the final
high-resolution archive. Folder labels, materials, file fan-out, relationship
threads, and return animation still need a technical-art pass and XCAT hand
testing.

### 2. Docked case review

![Docked spatial case](../Proof/30-spatial-docked-case.png)

- Dropping the file reveals a generic, non-likeness case figure and four concise facts.
- Speech, arm, time, and open-question facts become separate spatial artifacts,
  not tiny tabs inside a notes window.
- The file can still be returned before entering the explanation.
- **Begin family view** or **Begin presenter view** is the explicit threshold.
- Once entered, the complete intake room is disabled; no cabinet, file, or case furniture persists beside the brain.

Current limitation: the fact artifacts need stronger relationship lines,
larger typographic treatment, and a better orbit around the case. They are
implemented, but this visual pass is not the final design.

### 3. Lesson family: brain regions

![Region point field](../Proof/28-spatial-region-explanation.png)

- Mint points are derived from the registered cortex bounds.
- A point remains parented to the cortex and follows orbit/magnification.
- Gaze + pinch selects a point; dragging from it rotates the entire anatomy.
- The point cannot be detached, preventing loss of anatomical meaning.
- Only the selected point receives a text label.

### 4. Lesson family: blood flow

![Procedure point field](../Proof/29-spatial-procedure-explanation.png)

- Five amber points form a sparse cause-and-effect reference field: approach,
  branching, example blockage, changed downstream flow, and affected territory.
- Six low-motion chevrons share the droplet/vessel centreline and show direction.
- Switching field changes the meaning of the points; it does not add a second
  simultaneous layer of labels.
- Only the selected point expands. The field explains why the story changes;
  it is not a catheter plan or patient-specific trajectory.
- Both family and presenter can deliberately swap lesson families or hide the points.

### 5. Transparent anatomy

![Transparent anatomy](../Proof/31-spatial-transparent-study.png)

- Cortex opacity changes while arteries and the teaching clot stay registered.
- The result is reversible and non-graphic.
- **Study apart** uses small wrapper offsets; no child asset transform is
  rewritten.
- The language is “fade one layer” and “room, not repair”—never peel, unzip,
  cut, drill, or blood.

### 6. Clinical evidence

![Clinical evidence](../Proof/21-clinical-evidence-search.png)

- Evidence opens above the presenter, not over the patient's central brain.
- A source includes full citation, link, support, and limitation.
- Pinning and source-bound drafting are clinician-only.
- Generated wording remains a draft until clinical review.

### 7. Clinician hand toolkit

- A collapsed cuff follows the left palm; opening it reveals a radial selector.
- **Focus**, **Lens**, and **Layers** control the explanation.
- Generic forceps and drill concepts may be held on the right palm, but remain
  display-only and are hidden from the family lens.
- The current open-cranial tool assets are low-detail prototypes, not the final
  high-resolution instrument set.
- Full interaction, asset, and XCAT gates are in
  [`CLINICIAN_HAND_TOOLKIT.md`](CLINICIAN_HAND_TOOLKIT.md).

## Annotation engineering contract

Every annotation must answer all six fields before it is allowed into the
scene:

| Field | Required answer |
| --- | --- |
| Intent | What question does this help the family or clinician answer? |
| Anatomical anchor | Which entity and local 3D position owns it? |
| Role | Family, clinician, or both? |
| Reveal condition | What deliberate action makes it visible? |
| Visual response | Focus, transparency, flow cue, or layer change? |
| Evidence | Which reviewed source supports it, or what review is pending? |

An annotation is not a permanent label. It starts as a quiet point, expands
only after selection, stays at the object's depth, and collapses when cleared.
Safety, uncertainty, and exit controls are never communicated only in
peripheral vision.

## Control and agency map

| Gesture/action | Result | Reversibility |
| --- | --- | --- |
| Gaze + pinch case file | Acquire physical case object | Release away from dock returns it |
| Carry file to centre | Reveal the case review only | Carry file back left |
| Begin selected case | Remove intake room and reveal anatomy | Finish or exit back to cases |
| Gaze + pinch anatomy point | Select one intended question | Clear selection |
| Drag selected point or brain | Orbit complete registered anatomy | Reset view |
| Two-hand magnify | Scale complete registered anatomy | Reset view |
| Choose Brain regions / Blood flow | Swap lesson-point meaning | Swap back or hide; points remain registered |
| See through | Change cortex opacity | Return to Layers |
| Study apart | Apply small semantic-layer offsets | Return to Layers without drift |
| Pin source | Preserve evidence in clinician space | Unpin |

## Patient and presenter split

**Family** sees the shared brain, one calm sentence, lesson selector, optional
system narration of reviewed copy, pause, clarification, and point-on-brain
actions. It does not see surgical tools, evidence drafting, or procedure
precision controls.

**Presenter** receives the secondary rail only after the case is docked. Its
compact menus change act, layer presentation, and point-field flavor. The rail
is not the product's primary surface; the anatomy remains the centre of action.

## Implementation map

| Product area | Source of truth |
| --- | --- |
| Shared state, file docking, proof states | `Sources/StrokeExperienceState.swift` |
| Cabinet, file, dock, anatomy, point entities | `Sources/StrokeSceneFactory.swift` |
| Room placement, attachments, gestures, role rail | `Sources/StrokeImmersiveView.swift` |
| Minimal entry threshold and deterministic routes | `Sources/StrokeJourneyLaunchView.swift` |
| Evidence source workspace | `Sources/StrokeEvidenceWorkspaceView.swift` |
| Runtime scenes and placement | `Sources/StrokeTimeApp.swift` |
| Blender semantic USD authoring | `Scripts/build_blender_layer_study.py` |
| DCC authority and handoff | `Docs/DCC_LAYER_STUDY_PIPELINE.md` |

## Evidence status

- Static Stroke Care contract: **PASS**.
- visionOS Simulator build: **PASS**.
- Blender 5.2 semantic layer study: **PASS** with a versioned manifest.
- Simulator screenshots: layout/render evidence only.
- Direct hand carry, gaze targeting, binocular depth, comfort, and legibility
  on XCAT: **NOT PROVEN**.
- Clinical correctness and acceptability: **PENDING SPECIALIST REVIEW**.
- Houdini and Unreal execution: **NOT RUN**; neither editor is installed here.

The current improvement is architectural: patient management and anatomy are
now separate spaces, with an explicit threshold between them. The next visual
pass should replace the geometric file exhibit with higher-craft assets, add
elegant provenance threads, and reduce the presenter rail after XCAT hand
testing. The explanation ends in a calm reflection and a return to cases; it
does not generate a recommendation. A scan-analysis model remains out of scope
until dataset licensing, registration, validation, privacy, intended use, and
clinician oversight are defined.
