# Environment direction and scan-AI gates

## Chosen environment: quiet clinical horizon

The brain is suspended over a warm, low-contrast ground plane with a distant
matte veil and six slow ribbons. It is not a replica office, bedroom, library,
forest, or hospital. The intended feeling is an open museum gallery at dawn:
grounded, spacious, still, and subordinate to the anatomy.

Why this direction:

- Apple recommends grounding immersive environments, minimizing high-contrast
  distraction, keeping peripheral animation subtle, and tying sound to the
  objects it explains.
- Apple's 2026 environment workflow begins with intent, primary viewpoint,
  layered composition, motion, and spatial audio—not an arbitrary backdrop.
- Reviews of virtual natural environments suggest possible short-term anxiety
  and stress benefits, but populations, interventions, and results vary. Those
  results do **not** validate this app for stroke families or make the horizon a
  therapeutic intervention.

Sources:

- [Apple HIG: Immersive experiences](https://developer.apple.com/design/human-interface-guidelines/immersive-experiences)
- [Apple: Design immersive environments for visionOS apps and the spatial web](https://developer.apple.com/videos/play/wwdc2026/234/)
- [Virtual natural environments and affective responses: systematic review](https://pubmed.ncbi.nlm.nih.gov/36201684/)

## Audio contract

- Prelude: the local `FlowBed.wav` starts quietly before role selection.
- Anatomy: flow and pressure beds remain entity-anchored and manually mutable.
- Narration: system speech reads only the exact reviewed caption for the current
  act. It does not improvise, diagnose, infer anxiety, or answer medical questions.
- Ending: the background remains quiet while an original, unattributed closing
  line returns control to the wearer.

## Imaging and computer-vision gate

No brain-scan inference model is connected in the current build. A Hugging Face
endpoint, public checkpoint, or demo segmentation model is not enough to claim
patient-region detection. Before any scan workflow enters the app, the team must
define and approve:

1. intended clinical or educational use and the exact output;
2. modality and input contract (CT, CTA, MRI, DICOM series, orientation);
3. dataset license, consent, de-identification, retention, and jurisdiction;
4. registration from voxel coordinates into the RealityKit anatomy frame;
5. external validation, subgroup/error analysis, confidence display, and failure state;
6. clinician-in-the-loop review and a non-diagnostic fallback;
7. network/privacy threat model and on-device versus hosted inference decision;
8. regulatory and institutional review.

Until those gates pass, the app accepts only fictional teaching annotations and
reviewed external resources. A future annotation payload may reference a paper,
approved video, image, or scan slice, but it must keep provenance, role, anchor,
and review status beside the content.
