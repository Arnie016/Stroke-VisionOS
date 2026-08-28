# Multipolar neuron teaching reference v3

`multipolar_neuron_detailed_conceptual_v3.usdz` is an original asset generated
for Stroke Care by `apps/StrokeCare/TechnicalArt/build_neuron_teaching_reference.py`.
It contains no downloaded mesh, real-person data, patient data, scan, histology,
microscopy, or vendor geometry.

## Runtime contract

- metres, magnified room-scale exhibit
- nine PBR mesh leaves and eight materials
- independently named soma, nucleus, dendrites, spines, axon, myelin, nodes,
  and terminal arbor
- 10,808 vertices and 11,804 polygons after semantic consolidation
- Apple `usdchecker --arkit`: success on both USDC source and packaged USDZ
- procedural RealityKit fallback remains required if the bundle load fails

## Meaning boundary

The asset is a generic morphology for explaining cell parts. It is not to
biological scale and does not represent a particular neuron class, patient,
recording, membrane voltage, ion flow, synaptic timing, neurotransmitter
chemistry, disease state, or treatment response. Neuroanatomy and clinical
specialist review is required before patient-facing use.

## License

Original project asset. Copyright remains with the Stroke Care project authors.
No third-party source asset is incorporated.
