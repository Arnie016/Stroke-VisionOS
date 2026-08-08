# Geometry and import provenance

Blender 5.2.0 LTS imported the source GLB successfully with all four embedded 2K
images packed.

- Mesh objects: 17, plus 19 empties
- Geometry: 40,881 vertices and 53,745 triangles
- Materials: `Eye`, `PBR`, `Skull`, `Teeth`
- Embedded images: 2048×2048 eye base color/normal and skull base color/normal
- Imported world bounds: 25.790966 × 17.275879 × 28.036026 m
- Imported world-bounds center: (7.201065, 3.196021, -8.980497) m
- Mesh names: `Ethmoid bone`, `Eyes.001`, `Eyes_Surface`, `Frontal bone`,
  `Lacrimal bone`, `Lower teeth`, `Mandible`, `Maxilla`, `Nasal bone`,
  `Occipital bone`, `Palatine bone`, `Pareital bone` (source spelling),
  `Sphenoid bone`, `Temporal bone`, `Upper teeth`, `Vomer`, `Zygomatic bone`

The source numbers behave like centimetres even though glTF nominally uses
metres. Normalize the complete parent hierarchy uniformly by **0.01**, then
translate to the normalized world-bounds center. The resulting approximate
dimensions are 0.2579 × 0.1728 × 0.2804 m. Scale a wrapper/root object rather
than scaling each child around its own origin, or the bones will separate.

This is the preferred interactive skull asset: it is much lighter than the
single-mesh high-resolution skull, contains semantic bone/teeth/eye objects, and
already has PBR textures. A medium LOD around 35k–50k triangles should preserve
its teaching value.

The source GLB uses `KHR_materials_clearcoat` and `KHR_materials_ior`. Blender
5.2 imports both cleanly; validate the translated eye clearcoat/IOR appearance
after USDZ export because RealityKit and Blender may not map every glTF material
parameter identically.
