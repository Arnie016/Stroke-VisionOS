# Stroke asset catalog runtime triage

Updated after `git fetch --all --prune` on 10 August 2026.

## Repository comparison

- The expanded catalog is already in the shared history through merge commit
  `b46d133` (`Merge 65-asset visionOS stroke education catalog (#2)`).
- The merged catalog contains **65 manifest-backed USDZ packages**: 36
  higher-detail v2 assets and 29 prototype-v1 assets.
- Draft PR #8 at audited head `12728df2e856897a44df2bbfbe01236f8b142303`
  adds 69 v3 packages, bringing the repository candidate catalog to **134 unique USDZ assets**.
  Those draft files are metadata candidates, not current
  app runtime dependencies.
- Stroke Care deliberately declares a fourteen-asset runtime slice today. A
  catalog file existing in Git is not proof that it is registered, clinically
  suitable, performant, or visible in the app.

## Runtime candidates

| Candidate | Size | Best role | Decision |
|---|---:|---|---|
| `brain_deep_structures_v2` | 2.2 MB | Clinician Study-apart field | Bundled and runtime-gated; Simulator opacity/occlusion proof still required. |
| `brain_ventricles_v2` | 0.8 MB | Clinician Study-apart field | Bundled and runtime-gated; specialist label review still required. |
| `cerebral_bloodflow_animation_v2` | 0.19 MB | Calm qualitative flow layer | Bundled and explicitly looped only in clinician Blood-flow mode; non-CFD and motion proof remain required. |
| `dural_sinuses_jugulars_realistic_v2` | 4.22 MB | Clinician Guided/Scholar venous reference | Bundled in the registered-v2 frame; generic atlas only. Z-Anatomy/BodyParts3D ShareAlike attribution and specialist review are mandatory. Blue/purple is a UI convention, not venous blood colour or flow. |
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

Verify the new deep-structures and ventricles layers in the existing
`--proof-layer-study` route, then verify the baked flow loop in
`--proof-procedure-field`. The imported animation replaces the hidden
procedural registered-flow attempt rather than stacking another centreline.
After Simulator verification, repeat on XCAT and profile frame time before
considering one individual generic device in the private tool tray. This
preserves depth over breadth and avoids turning the central brain into an asset
gallery.
