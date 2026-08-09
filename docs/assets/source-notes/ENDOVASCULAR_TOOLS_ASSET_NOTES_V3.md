# Generic endovascular tools — v3

This module adds the external support tools that were missing between the
existing v2 thrombectomy-device close-ups and a coherent patient-education
narrative. It contains **10 independent tool packages** and **2 review-only
assemblies**.

All models are project-authored, generic, and non-branded. They are explanatory
categories, not depictions of cleared or marketed devices. Dimensions,
connections, colors, controls, and layouts are visually plausible presentation
choices—not specifications or instructions.

## Clinical boundary

These assets are for a generic patient-education prototype only. They are not
patient-specific, manufacturer-specific, or validated for device selection,
compatibility decisions, sizing, navigation, procedural training, sterile-field
setup, medication or contrast preparation, treatment planning, or outcome
prediction.

The module belongs exclusively to an **endovascular intervention branch**. Do
not activate it as part of a craniotomy, open cranial surgery, or
post-craniotomy head-dressing scene.

Femoral, radial, or another access route remains conditional. So do anesthesia
or sedation, aspiration versus retrieval strategy, contrast/flush protocol,
suite controls, and access-site hemostasis. The relationship fields in the
manifest describe a possible patient-education narrative; they do not prescribe
a procedure or mandatory order.

## Asset catalog

### 1. `vascular_access_needle_educational_v3`

- **Stage association:** conditional vascular access.
- **Contains:** generic metallic cannula, visible tip opening, molded connector
  hub, collar, and finger wings.
- **Narrative role:** introduces the idea that a blood vessel may first be
  accessed through the skin before a wire or sheath can be introduced.
- **Not encoded:** puncture site, access route, needle type, angle, depth,
  ultrasound guidance, motion, vessel contact, or insertion technique.
- **Possible narrative association:** may precede the access-wire model.

### 2. `vascular_access_wire_educational_v3`

- **Stage association:** conditional vascular access.
- **Contains:** abbreviated metallic wire, curved distal concept, loading
  straightener, and dispensing-loop context.
- **Narrative role:** explains the high-level transition from needle access to a
  conduit for later catheters.
- **Not encoded:** wire profile, coating, diameter, length, visibility,
  compatibility, navigation, or vessel interaction.
- **Possible narrative association:** may follow the access needle and precede
  the sheath/dilator set.

### 3. `introducer_sheath_dilator_set_educational_v3`

- **Stage association:** conditional vascular access.
- **Contains:** parallel display of a generic introducer sheath with valve hub
  and sidearm, plus a separate tapered dilator.
- **Narrative role:** shows a category of temporary access conduit used in some
  endovascular approaches.
- **Not encoded:** French size, length, taper, valve mechanics, insertion depth,
  flushing, compatibility, or insertion/removal sequence.
- **Route rule:** femoral, radial, and other route configurations must remain
  selectable clinical variants, not assumptions baked into the asset.

### 4. `guide_catheter_hemostatic_valve_educational_v3`

- **Stage association:** conditional guide support, navigation, and device
  delivery.
- **Contains:** curved, abbreviated guide-catheter display segment; proximal
  hub; rotating hemostatic-valve concept; capped sidearm; distal marker accent.
- **Narrative role:** explains a proximal support pathway and closed working
  port at a high level.
- **Not encoded:** catheter shape family, support, placement, route, sidearm
  connections, valve setting, compatibility, or navigation technique.

### 5. `aspiration_pump_canister_tubing_educational_v3`

- **Stage association:** conditional aspiration or aspiration-assisted
  thrombectomy.
- **Contains:** compact generic pump chassis, abstract non-functional display and
  controls, canister, illustrative contents, tubing, ports, and capped distal
  connector.
- **Narrative role:** shows that an external suction pathway may connect to an
  aspiration catheter when aspiration is part of the selected strategy.
- **Not encoded:** vacuum, pressure, duration, alarms, flow, connection order,
  aspirate volume, catheter compatibility, or an operating procedure.
- **Visual-fluid rule:** the canister contents are static color geometry. They do
  not predict blood loss, clot retrieval, or aspirate volume.

### 6. `contrast_manifold_syringe_flush_educational_v3`

- **Stage association:** conditional angiographic contrast and flush context.
- **Contains:** generic three-port manifold, abstract stopcock handles, larger
  illustrative syringe, smaller flush syringe, and disconnected tubing.
- **Narrative role:** explains that imaging may involve external fluid-routing
  equipment.
- **Not encoded:** fluid identity, dose, preparation, pressure, route,
  stopcock position, injection rate, allergy/renal decisions, or institutional
  protocol.
- **Color rule:** amber and blue contents are visual differentiation only, not a
  medication label or standardized coding scheme.

### 7. `torque_device_y_connector_accessories_educational_v3`

- **Stage association:** conditional wire/catheter manipulation and device
  delivery.
- **Contains:** generic torque-clamp concept, Y-connector, rotating seal,
  branch, short wire context, and capped connector accessories.
- **Narrative role:** explains accessory categories used around a working port.
- **Not encoded:** torque magnitude, wire motion, seal adjustment, connection
  order, compatibility, or manipulation technique.

### 8. `puncture_site_hemostasis_options_educational_v3`

- **Stage association:** conditional post-intervention access-site hemostasis.
- **Contains:** manual-compression gauze and pad, an external compression-band
  concept, an adhesive dressing, and an abstract closure-applicator concept.
- **Narrative role:** explains that the access site must be closed, compressed,
  dressed, and monitored after catheter removal.
- **Critical option rule:** these are alternatives or adjuncts—not a simultaneous
  mandatory setup. Do not present all representations as consecutive required
  steps.
- **Not encoded:** closure mechanism, implant, pressure, timing, deployment,
  route/site suitability, anticoagulation decision, monitoring, or aftercare.

### 9. `sterile_endovascular_instrument_tray_educational_v3`

- **Stage association:** conditional pre-intervention sterile setup.
- **Contains:** generic metal tray and drape, bowls, forceps, clamp silhouette,
  syringe, gauze, coiled tubing, and preparation context.
- **Narrative role:** provides a visual anchor for sterile preparation.
- **Not encoded:** a complete inventory, counts, packaging, medication
  preparation, sharps procedure, sterility assurance, or institutional
  checklist.
- **Scope rule:** the tray is illustrative and must never substitute for a local
  procedural checklist.

### 10. `angiography_suite_controls_educational_v3`

- **Stage association:** conditional angiography-suite equipment outside the
  sterile patient field.
- **Contains:** generic dual-pedal foot-control silhouette, cable, and abstract
  three-button hand control.
- **Narrative role:** shows that imaging equipment can be controlled from
  external hardware.
- **Not encoded:** button mapping, radiation exposure, injector control, table
  motion, emergency functions, operator responsibility, or training workflow.
- **Suite rule:** hardware and control mapping are system- and
  institution-specific.

### 11. `vascular_access_setup_review_assembly_v3`

- **Kind:** review-only aggregate.
- **Contains duplicates of:** access needle, access wire, sheath/dilator, and
  access-site hemostasis-options packages.
- **Purpose:** one-view orientation from access concept to closure concept.
- **Not:** a sterile layout, a registered configuration, or a required
  chronological sequence.
- **Transitive exclusion:** never co-load this assembly with any of its four
  contained independent packages.

### 12. `endovascular_tools_workflow_review_assembly_v3`

- **Kind:** review-only aggregate.
- **Contains duplicates of:** all ten independent packages.
- **Purpose:** broad stage/category orientation in a single gallery view.
- **Not:** a procedure-room setup, required equipment list, sterile field,
  registered configuration, or patient-specific plan.
- **Transitive exclusion:** never co-load this assembly with the access assembly
  or any independent package.

## Relationship and loading contract

Use independent packages in the runtime experience. Load only the categories
relevant to the current explanatory state, and unload the prior state unless a
clinically reviewed comparison specifically needs both.

The two aggregates contain duplicate geometry rather than references to
externally loaded component packages. Therefore:

- loading `vascular_access_setup_review_assembly_v3` excludes its four
  contained independent packages;
- loading `endovascular_tools_workflow_review_assembly_v3` excludes all ten
  independent packages and `vascular_access_setup_review_assembly_v3`;
- independent packages that appear in the access assembly exclude both
  aggregates;
- every other independent package excludes the full workflow aggregate.

The exact machine-readable groups are in
`asset_manifest_endovascular_tools_v3.json` under
`aggregate_exclusion_groups`, `prohibited_co_load_asset_ids`, and
`transitive_excludes`.

## Physics and animation contract

- Treat every object as static presentation geometry by default.
- Optional application transforms may be kinematic—for example, moving a
  disconnected tool into a comparison position—but must not be described as
  simulated clinical behavior.
- Do not add unsupervised puncture, insertion, wire navigation, catheter
  navigation, valve operation, injection, aspiration, closure, or radiation
  interactions.
- No fluid, pressure, pump, tubing, clot, vessel, device-vessel, tissue,
  puncture, deployment, radiation, or sterile-field physics are encoded.
- Canister and syringe contents are static visual volumes.
- Any future motion, state machine, or Houdini/RealityKit behavior needs a
  separate clinical specification and verification gate.

## visionOS presentation

- Authoring/export units are metres with Y-up USD stages.
- Start with 1:1 macroscopic presentation. If the application magnifies a small
  connector or needle, show a persistent `Magnified educational view` label and
  a scale indicator.
- Keep generic color accents and do not add manufacturer logos, trade dress,
  proprietary markings, exact product dimensions, dose labels, control labels,
  or compatibility claims.
- Keep endovascular equipment outside any open-cranial branch.
- Keep foot/hand controls spatially outside the sterile-field presentation.
- Keep tubing endpoints capped or visibly disconnected unless a clinically
  reviewed narrative explicitly defines a non-instructional relationship.
- Present hemostasis representations as selectable alternatives/adjuncts.

## Deliverables

- Manifest: `asset_manifest_endovascular_tools_v3.json`
- Editable source: `blender/endovascular_tools_educational_v3.blend`
- Reproducible generator: `source/build_endovascular_tools_v3.py`
- Runtime packages: `exports/usdz/<asset-id>.usdz`
- Layered authoring files: `exports/usdc/<asset-id>.usdc`
- Visual previews: `previews/endovascular_tools_v3/`
- Provenance: `research/ENDOVASCULAR_TOOLS_PROVENANCE_V3.md`
- Validation: `validation/ENDOVASCULAR_TOOLS_VALIDATION_V3.md`

Rebuild with Blender 5.2 LTS:

```bash
/Applications/Blender.app/Contents/MacOS/Blender \
  --background --factory-startup \
  --python source/build_endovascular_tools_v3.py
```

Technical validation does not establish clinical validity, completeness,
training suitability, regulatory readiness, or patient safety. Specialist and
institutional review remain mandatory before patient-facing use.
