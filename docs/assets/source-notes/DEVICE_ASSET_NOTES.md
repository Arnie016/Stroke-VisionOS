# Generic thrombectomy device concepts — v2

These procedural assets provide a higher-quality visual layer for the stroke patient-education prototype. They are deliberately generic and non-branded. No commercial device mesh, trademarked design, or third-party geometry is incorporated.

## Deliverables

| Asset | Visual intent | Approximate display geometry | Runtime triangles |
|---|---|---:|---:|
| Guidewire | Metallic wire with an atraumatic curved distal tip and radiopaque distal segment | 0.36 mm OD; abbreviated 200 mm segment | 5,440 |
| Microcatheter | Hollow polymer shaft, curved distal segment, proximal transition, distal marker | 0.86 mm OD / 0.58 mm ID; abbreviated 160 mm segment | 8,800 |
| Aspiration catheter | Hollow large-bore shaft, crossed reinforcement, two distal markers | 2.1 mm OD / 1.56 mm ID; abbreviated 175 mm segment | 18,024 |
| Stent retriever concept | Deployed crossed-wire lattice, pusher wire, end crowns, radiopaque markers | Conceptual 4 mm diameter × 20 mm lattice | 22,272 |
| Combined presentation | All four assets arranged for comparison | 198 × 110 × 4.4 mm | 54,536 |

The dimensions above are visual plausibility targets, not product specifications. Catheter and wire lengths are intentionally abbreviated to keep patient-facing spatial scenes legible.

## visionOS use

- Load the individual USDZ files lazily and keep the four device collections independently toggleable.
- Present them at 1:1 scale by default. If a close-up or magnified view is used, show an explicit scale indicator and a `Magnified educational view` label.
- Use the combined set as an explanatory tray/comparison view, not as a registered procedural configuration.
- Use a dedicated close-up state for the stent lattice; its wires are near the limit of comfortable visibility at normal viewing distance.
- Keep material overrides optional so the radiopaque markers and hollow lumens remain visually distinguishable under different room lighting.

## Required clinical review

Before any patient-facing deployment, an interventional neuroradiologist or neurointerventional surgeon should review:

- whether the selected instruments match the intended high-level thrombectomy narrative;
- whether relative diameter and scale are understandable without implying device selection guidance;
- guidewire and catheter tip shapes;
- aspiration-catheter lumen and marker placement;
- stent-lattice deployment state, vessel interaction, and retrieval sequence;
- on-screen terminology, laterality, safety language, and any magnification labels;
- whether the scene could be mistaken for a promise of patient-specific anatomy, technique, or outcome.

## Safety boundary

These assets are generic patient-education prototypes only. They are not patient-specific and are not representations of cleared or marketed devices. Do not use them for device selection, device sizing, deployment simulation, procedural training, diagnosis, treatment planning, navigation, or outcome prediction.

The editable source is `blender/thrombectomy_devices_educational_v2.blend`. Rebuild with Blender 5.2 LTS using:

```bash
/Applications/Blender.app/Contents/MacOS/Blender \
  --background --factory-startup \
  --python source/build_thrombectomy_devices_v2.py
```

Machine-readable metadata and warnings are in `asset_manifest_devices_v2.json`.
