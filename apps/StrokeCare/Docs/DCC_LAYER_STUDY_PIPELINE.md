# Reversible anatomy layer-study pipeline

This pipeline supports Stroke Care's calm educational layer study. It does not
simulate an operation, diagnose a patient, or claim physiological accuracy.
RealityKit remains the runtime source of truth for transforms, input,
accessibility, and role-specific presentation.

## Canonical USD hierarchy

All DCC experiments must preserve these semantic roots:

```text
/StrokeLayerStudy
  /Cortex
  /Arteries
  /Blockage
  /Dura
  /RegionAnchors
```

The app maps these roots to four sibling RealityKit entities. It changes
opacity and small reversible offsets on the wrappers; it does not rewrite the
authored transforms inside the imported USDZ files.

## Executed Blender receipt

Blender 5.2 LTS was run locally through
`Scripts/build_blender_layer_study.py`. The script:

1. imports the registered-v2 cortex, cerebral arteries, teaching clot, and
   conceptual dura USDZ files;
2. creates semantic layer collections and a shared registered root;
3. derives ten region anchors from the cortex bounds;
4. saves an editable `.blend` and exports a composed `.usdc` stage;
5. writes `TechnicalArt/Generated/StrokeLayerStudy.manifest.json`.

The generated `.blend`, backup, and `.usdc` are intentionally ignored because
they are reproducible binary working files. The small manifest is versioned as
the execution receipt. `usdchecker` reported final validation success; its
local tool registration also emitted non-fatal duplicate UsdShade behavior
warnings.

## Blender responsibilities

- registration and geometry inspection;
- semantic naming and hierarchy;
- cortex-bound anchor derivation;
- mesh cleanup and authored material review;
- visual QA of transparent overlap.

Blender modifiers may be used to build non-destructive authoring variants, but
the shipped patient path must use opacity and reversible layer offsets. It must
not show a Boolean cut, tearing surface, blood, or a zipper-like incision.

## Houdini route — designed, not executed

Houdini is not installed on this machine, so no Houdini scene or simulation is
claimed. A future Houdini pass should use Solaris as a hub-and-spoke USD
workflow:

1. reference the registered stage rather than round-tripping every mesh;
2. use SOP Import LOP for separately authored procedural geometry;
3. write animation or visualization into its own USD layer;
4. compose that layer over the registered anatomy;
5. package USDZ only at the delivery boundary.

For Stroke Care, flow is a qualitative, clinician-reviewed teaching cue—not
CFD, perfusion, collateral-flow estimation, or a patient measurement. Vellum or
FLIP liquid work belongs in the separate water-park experiment, not in the
medical explanation unless a specialist validates the representation. Avoid
volume-based delivery assumptions: the runtime contract is mesh/material USDZ.

Primary references:

- [SideFX SOP Import LOP](https://www.sidefx.com/docs/houdini/solaris/sop_import.html)
- [SideFX Solaris and USD](https://www.sidefx.com/docs/houdini/solaris/usd.html)
- [SideFX USD output](https://www.sidefx.com/docs/houdini/solaris/output.html)
- [SideFX Vellum fluid setups](https://www.sidefx.com/docs/houdini/vellum/fluidsetups.html)

## Unreal route — designed, not executed

Unreal Editor is not installed on this machine. Unreal is therefore an
optional cinematic/look-development QA spoke, not a runtime dependency or a
claimed visionOS deployment route. A future workstation can enable the USD
Importer plugin, open the same stage in USD Stage Editor, and inspect lighting,
camera language, and transparent-layer readability. Epic labels this workflow
Beta; exported changes must return as a separate USD layer and cannot become
the authority for RealityKit input or accessibility.

Primary references:

- [Epic USD Stage Editor quick start](https://dev.epicgames.com/documentation/unreal-engine/usd-stage-editor-quick-start-in-unreal-engine)
- [Epic working with USD stage prims](https://dev.epicgames.com/documentation/unreal-engine/working-with-usd-stage-prims-in-unreal-engine)

## Tool proof matrix

| Tool | Current result | Authority |
| --- | --- | --- |
| Blender 5.2 LTS | Executed; manifest and USD validation receipt exist | Registration, semantic authoring, anchors |
| Houdini | NOT RUN — executable not installed | Future procedural USD layer only |
| Unreal Engine | NOT RUN — editor not installed | Future cinematic/lookdev QA only |
| RealityKit | Simulator build and interaction implementation | Runtime behavior; XCAT still required |

## Stop gates

- Do not ship a DCC layer whose registration differs from registered-v2.
- Do not let a selected point detach from its anatomy parent.
- Do not present authored flow as measured physiology.
- Do not expose procedure detail in the family lens.
- Do not call Simulator or USD validation physical-device proof.
- Require XCAT wearer review and specialist review before clinical-facing use.
