# Neurovascular-unit teaching reference v3

`neurovascular_unit_detailed_conceptual_v3.usdz` is an original asset generated
for Stroke Care by
`apps/StrokeCare/TechnicalArt/build_neurovascular_unit_teaching_reference.py`.
It contains no downloaded mesh, patient data, scan, histology, microscopy,
real-person data, or vendor geometry.

## Runtime contract

- metres, magnified room-scale cutaway exhibit
- nine PBR mesh leaves and nine materials
- independently named endothelial wall, endothelial cell bodies and nuclei,
  tight-junction cues, basement membrane, pericyte, astrocyte endfeet, nearby
  neuron process, and red-blood-cell set
- 7,272 vertices and 8,030 polygons after semantic consolidation
- Apple `usdchecker --arkit`: success on both USDC source and packaged USDZ
- procedural RealityKit fallback remains required if the bundle load fails

## Meaning boundary

The asset explains a generic cellular neighbourhood around a capillary. It is
magnified and not to biological scale. It is not patient tissue, histology,
microscopy, a patient scan, or a measured blood-brain-barrier model. It does not
measure or simulate permeability, oxygen delivery, pressure, velocity,
perfusion, disease, or treatment response. Neuroanatomy and clinical specialist
review is required before patient-facing use.

## License

Original project asset. Copyright remains with the Stroke Care project authors.
No third-party source asset is incorporated.
