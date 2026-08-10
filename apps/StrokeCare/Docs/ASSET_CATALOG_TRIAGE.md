# Stroke asset catalog runtime triage

Updated after `git fetch --all --prune` on 8 August 2026.

## Repository comparison

- The expanded catalog is already in the shared history through merge commit
  `b46d133` (`Merge 65-asset visionOS stroke education catalog (#2)`).
- It contains **65 manifest-backed USDZ packages**: 36 higher-detail v2 assets
  and 29 prototype-v1 assets.
- No newer asset delta exists between this feature branch and `origin/main` at
  the time of the fetch. The current main-only delta concerns XCAT acceptance
  files, not anatomy or tool assets.
- Stroke Care deliberately bundles **ten story assets plus two clinician-only
  concept tools** today. The story count includes the same-frame static and
  animated qualitative flow cues. The drill and forceps remain generic,
  presenter-only concepts pending specialist review. A catalog file existing
  in Git is not proof that it is registered, clinically suitable, performant,
  or visible in the app.

## Runtime candidates

| Candidate | Size | Best role | Decision |
|---|---:|---|---|
| `brain_deep_structures_v2` | 2.2 MB | Clinician Regions field | Next, after opacity/occlusion visual QA. |
| `brain_ventricles_v2` | 0.8 MB | Clinician Regions field | Next, after specialist label review. |
| `cerebral_bloodflow_animation_v2` | 0.19 MB | Calm qualitative flow layer | High-value next experiment; play imported animation explicitly and retain non-CFD label. |
| `artery_cutaway_complete_v2` | 6.5 MB | Magnified vessel close-up | Separate on-demand volume, never permanent centre clutter. |
| `thrombectomy_device_set_educational_v2` | 2.47 MB | Presenter-only Plan B tool tray | Use only when thrombectomy is the chosen discussion; label magnification and generic-device status. |
| Individual v2 guidewire/catheters/stent | 0.24–1.05 MB each | Grabbable clinician inventory | Prefer lazy individual loading over the combined set. |
| `external_head_scalp_cutaway_v2` | 7.97 MB | Non-graphic layer reveal | Requires registration and clinical wording review before replacing the current schematic reveal. |

## Hold from patient runtime

- Registered hero/assembly files duplicate component geometry and can add
  29–32 MB each; use them for review, not default loading.
- Prototype-v1 drill, forceps, incision, flap, and closure tools are stylised
  and are not registered to the v2 anatomy. Keep them out of the patient view.
- Device assets are generic and technically validated by `usdchecker --arkit`,
  but every manifest still says `REQUIRES_SPECIALIST_REVIEW`.
- Cerebral flow animation is baked illustrative motion, not fluid simulation,
  perfusion, collateral flow, velocity, or a patient measurement.

## Recommended next asset slice

Load `cerebral_bloodflow_animation_v2` lazily in presenter Procedure mode and
compare it against the existing procedural droplets on Simulator and XCAT. If
the imported animation stays registered, legible, and calm, replace—not stack—
the fallback flow. Then test one individual generic device in a private tool
tray. This preserves depth over breadth and avoids turning the central brain
into an asset gallery.
