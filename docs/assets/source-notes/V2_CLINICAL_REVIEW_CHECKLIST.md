# Clinical review gate for a patient-facing pilot

This checklist must be completed by the appropriate local clinical, regulatory,
accessibility, and engineering owners. A checked item records review; it is not
a claim that the model is suitable for treatment planning.

## Intended-use boundary

- [ ] The experience is labelled **generic patient education**, not a simulation
      of this patient's anatomy or predicted procedure.
- [ ] It never presents the model as diagnostic imaging, a navigation system,
      device-sizing guidance, a risk calculator, or an outcome prediction.
- [ ] The treating clinician remains responsible for the informed-consent
      conversation and can pause, skip, or correct the visualization.
- [ ] Patient-facing language distinguishes mechanical thrombectomy from open
      cranial surgery and avoids implying that every stroke follows this pathway.

## Neuroanatomy and procedure sequence

- [ ] An interventional neuroradiologist has reviewed left/right orientation,
      Circle of Willis branching, ICA-to-MCA path, and the conceptual right-M1
      occlusion position.
- [ ] A stroke neurologist has reviewed the stroke explanation, urgency, likely
      care pathway, alternatives, material risks, uncertainty, and recovery
      messaging.
- [ ] Device geometry and motion are clearly generic; deployment, aspiration,
      clot engagement, withdrawal, and reperfusion are not shown with misleading
      precision.
- [ ] Open-cranial assets are excluded from the thrombectomy flow unless a
      separate neurosurgical procedure is explicitly being explained.
- [ ] The clot is never used as a lesion measurement or a substitute for CTA,
      MRA, DSA, CT-perfusion, or clinician interpretation.
- [ ] Flow arrows, particles, streamline paths, and animation timing are labelled
      illustrative; they are never described as CFD, perfusion, pressure,
      velocity, collateral grading, or a prediction of reperfusion.
- [ ] Magnified artery-wall layers, capillaries, and red-blood-cell views are
      explicitly explained as scale-separated teaching vignettes rather than a
      single correctly scaled scene.
- [ ] The blue/purple venous palette is explained as an interface convention;
      no narration or label implies that venous blood is literally blue.

## Visual and interaction safety

- [ ] Skin/skull/dura/brain reveals use cutaways or toggles rather than stacked
      transparent shells that obscure spatial relationships.
- [ ] Falx, tentorium, dural sinuses, and head/neck vessels have been reviewed
      in their registered context; no simplified shell or flow cue is allowed to
      imply a patient-specific variant or operative corridor.
- [ ] Blood, incisions, and instruments use the least graphic presentation that
      still communicates the clinical point; the patient can opt out or stop.
- [ ] Labels, colors, and highlights are understandable without relying on red
      versus green alone; captions and spoken content have accessible equivalents.
- [ ] Controls work when seated or reclined and do not require rapid head/hand
      movement; comfort has been tested on actual Vision Pro hardware.
- [ ] The experience avoids guaranteed outcomes, false reassurance, and
      unnecessary fear-inducing detail.

## Technical release gate

- [ ] Every deployment USDZ passes `usdchecker --arkit` and contains the expected
      nonzero mesh/material hierarchy in a RealityKit load test.
- [ ] Dimensions, pivots, Y-up orientation, material appearance, culling, and
      reveal state are verified in Reality Composer Pro and on device.
- [ ] The assembled experience meets its on-device frame deadline under
      RealityKit Trace; only required layers are loaded at each step.
- [ ] Source attribution, ShareAlike obligations, third-party notices, and asset
      modification records are present in the distributed product.
- [ ] Privacy/security review is complete before any patient-derived imaging,
      identifiers, analytics, recordings, or cloud processing are introduced.

## Sign-off record

| Role | Name | Version reviewed | Date | Decision / notes |
| --- | --- | --- | --- | --- |
| Interventional neuroradiology |  |  |  |  |
| Stroke neurology |  |  |  |  |
| Neurosurgery, if applicable |  |  |  |  |
| Patient education / consent |  |  |  |  |
| Accessibility / human factors |  |  |  |  |
| Regulatory / legal / privacy |  |  |  |  |
| visionOS engineering / QA |  |  |  |  |
