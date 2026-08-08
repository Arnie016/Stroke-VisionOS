# RealityKit deck → Stroke Care

Source reviewed: [intro_swift_realitykit](https://www.icloud.com/keynote/0dcal_U2Jp3m9nKLr6zmlaP1A#intro%5Fswift%5Frealitykit), shared by the team on 8 August 2026.

## What the deck establishes

- SwiftUI state and binding should own visible application state.
- `RealityView` should own interactive 3D entities.
- Windows, volumes, and immersive spaces form an increasing hierarchy of depth.
- USD/USDZ is the native interchange path for authored spatial assets.
- RealityKit interaction is assembled from focused components: transform,
  collision, input target, hover, manipulation, opacity, physics, anchoring,
  lighting, and spatial audio.

## Stroke Care mapping

| Deck principle | Stroke Care decision |
|---|---|
| State and binding | `StrokeExperienceState` owns act, role, point field, question position, pinned evidence, and view transform. |
| Entity/component architecture | Brain, vessel, clot, question target, flow, point fields, and audio emitters are RealityKit entities with narrow components. |
| Increasing immersion | Case cabinet is a window; the living brain is the mixed immersive centre; citations open in a clinician-only upper window. |
| USD/USDZ workflow | Registered anatomy stays in the canonical USDZ catalog; schematic geometry remains an explicit fallback. |
| Hover + input target + collision | Selectability is system-indicated; the app consumes the confirmed 3D hit and never receives raw gaze coordinates. |
| Spatial audio | Calm, entity-anchored audio explains location but never claims to measure physiology or infer emotion. |

## Hierarchy contract

1. **Patient foveal centre:** one living brain, one visual change, one short sentence.
2. **Clinician peripheral rail:** pace, point-field flavor, wording boundary, and explicit family questions.
3. **Clinician upper evidence plane:** selected citation, immutable context, pinned sources, and a source-bound draft.

The evidence plane never appears in family mode. “Compose” may only assemble
approved source extracts and scene references. It must not infer candidacy,
invent medical claims, detach numbers from denominators, or turn draft research
into patient-specific advice.

## Next component-native experiments

- Replace the ellipsoid question collider with a reviewed low-poly cortex
  collision mesh from Blender/Houdini.
- Make regional and procedure points individually selectable with a short,
  clinician-approved narration lookup.
- Add local audio/video references as evidence kinds only after provenance,
  license, privacy, and clinical-review metadata are present.
- Evaluate `ManipulationComponent` for clinician tools while retaining explicit
  reset, consent, and accessibility fallbacks.
