# Clinician hand toolkit

## Product intent

The toolkit turns the clinician's non-dominant hand into a private instrument
library. It is not a surgical simulator and never appears in the family lens.
The shared brain stays central; the clinician glances at the left hand, opens a
small cuff, selects with gaze plus pinch, and sees the selected teaching prop
at the right palm.

## Implemented choreography

1. The collapsed **KIT** cuff is anchored beside the left palm.
2. Pinching the cuff opens a five-item radial wheel: **Focus**, **Lens**,
   **Layers**, **Forceps**, and **Drill**.
3. Gaze plus pinch selects an item. The app receives a targeted control action,
   not raw eye coordinates.
4. **Focus**, **Lens**, and **Layers** operate the presentation state. The layer
   action still passes through the family-permission gate.
5. **Forceps** and **Drill** appear at the right palm as generic teaching
   concepts. Drill remains display-only. In the separate **Move the layers**
   study, selecting Forceps enables a deliberate pinch/drag of the bone or dura
   model handle. The actual authored flap changes pose, with Lift/Return as a
   visible fallback. This is not physical tool-contact detection, cutting,
   drilling, tissue mechanics, or an operative technique.
6. Closing the wheel hides the held tool. Switching to the family lens removes
   both hand anchors.

RealityKit's public hand anchors are the implementation seam:

- left palette: `AnchoringComponent.Target.hand(.left, location: .palm)`
- right held tool: `AnchoringComponent.Target.hand(.right, location: .palm)`
- tracking: `.predicted`

This avoids a raw `HandTrackingProvider` session for the first slice. A future
wrist-roll selector would require explicit authorization, hysteresis, dwell and
accidental-selection testing; it is not implemented or claimed.

## Lens transformation

| Clinician selection | Clinician sees | Family sees |
| --- | --- | --- |
| Focus | A teaching pointer | Only the highlighted anatomy |
| Lens | Reversible transparent cortex | The same calm transparency, if the clinician chooses to share it |
| Layers | Precise layer control and boundary text | A permission-gated, non-graphic fade; no cutting animation |
| Forceps | Generic held concept; explicit access-layer model manipulation | Nothing |
| Drill | Generic held concept asset | Nothing |

The family presentation is a semantic translation, not a second simulated
operation. Uncertainty is addressed with one short purpose statement and an
explicit question marker—not with a falsely reassuring zipper or a graphic
incision.

## Asset-quality gate

| Asset | Current source | Geometry status | Runtime decision |
| --- | --- | --- | --- |
| Suction and forceps | `vision_pro_stroke_kit` | 284 triangles; generic concept | Bundled clinician-only; display only |
| Cranial drill | `vision_pro_stroke_kit` | 400 triangles; stylised concept | Bundled clinician-only; display only |
| Scalp flap | `vision_pro_stroke_kit` | 584 triangles; non-graphic reveal | Not used as a held tool |
| Guidewire/microcatheter/aspiration catheter v2 | `vision_pro_stroke_kit_v2` | 5.4k–18k triangles; higher-detail educational devices | Excluded because this app slice explains decompression, not thrombectomy |

The repository does **not** yet contain high-resolution, specialist-reviewed
open-cranial instruments. The current forceps and drill must not be advertised
as realistic surgical replicas. A final asset pass needs PBR materials, correct
scale and grip, separated moving parts, provenance, license, specialist review,
and XCAT stereo/occlusion testing.

## Figma and proof boundary

The supplied Figma screenshots remain the visual reference for the transparent
head, anchored regions, and doctor/family split. The authenticated Figma MCP
connection reached its Starter-plan call limit on 9 August 2026, so no live
node payload or new Figma asset was claimed in this pass.

`--proof-clinician-toolkit` places the hand anchors at deterministic world
positions for a Simulator screenshot. That route proves layout and state only;
it does not prove palm tracking. Palm tracking, selection comfort, tool scale,
stereo readability and hand occlusion require XCAT.

The current selector is a 150-degree arc placed beside and slightly in front of
the left palm. Its five 84-point controls render at a 0.78 attachment scale, so
their effective target size remains above 60 points. A presenter-side `Tools`
bubble provides a non-hand fallback. The app does not infer a cup pose or use
palm roll; standard visionOS gaze plus pinch remains the only selection gesture,
and system Home/Control Center gestures remain reserved.

The showcase architecture is one headset: the doctor wears XCAT and the family
watches the mirrored view. The hand arc is therefore a presenter control, not a
patient interaction. A family comfort response is recorded only after the
presenter asks aloud; it is session-local and never inferred from gaze, voice,
face, physiology, diagnosis, or patient data.
