# Case Cabinet Material V1

This is a project-authored procedural warm-fiber material for the fictional
case library. It contains no patient media, external texture, or generated
person likeness.

## Runtime and authoring files

- `case_cabinet_material_source_v1.psd`: flattened authoring source. PSD is not
  bundled by the visionOS target.
- `case_cabinet_basecolor_v1.png`: warm source colour study.
- `case_cabinet_fiber_height_v1.png`: grayscale procedural fiber field.
- `case_cabinet_roughness_v1.png`: derived roughness study for later
  RealityKit cabinet work.
- `../../Resources/Assets.xcassets/CaseCabinetGrain.imageset/`: the only
  runtime image; SwiftUI uses it as a subtle tiled overlay beneath native
  visionOS glass.

The selected-case card deliberately uses native `.regularMaterial`; a bitmap
must not imitate refraction or substitute for system glass. The height and
roughness studies are not yet wired to the room-scale RealityKit cabinet and
are not presented as a finished PBR material.

## Provenance and reproduction

Generated locally with ImageMagick 7 from deterministic procedural noise
(`seed 7805`). No third-party image input was used. The source can be
regenerated without network access or paid credits.

| File | SHA-256 |
| --- | --- |
| Runtime grain PNG | `83d3e6964584896a013e956b723c84c4ad611c8e231f25a72d6adeb6b2b98cb4` |
| Base colour PNG | `3ac1ea7786e7b95a408bd8562338d4d4c58216e338909f2035044869fe8f6588` |
| Fiber height PNG | `dbdcb18601336d3216ba1786b3b13f21feaf0c588aeb02f7d715192579af830f` |
| Roughness PNG | `dc0560c98f572875ee6211b2951812b66dade789618d713c5d505362f1457adf` |
| PSD source | `db4adba09772249621578656fb5c256181995ec517e9a843049353a64f8d5983` |

## Boundaries

- The abstract portraits are SwiftUI geometry, not real people.
- CASE-077 and CASE-079 are visible design previews, not implemented medical
  scenarios. Only CASE-078 exposes `Enter case`.
- This material and the Simulator build are not physical-device, wearer,
  clinical, or likeness-diversity proof.
