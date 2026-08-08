# Clinical Review Checklist

Do not use this prototype with patients until every applicable item has an owner and approval record.

## Identify the story

- [ ] Name the exact stroke type and procedure being explained.
- [ ] Confirm that thrombectomy, open cranial treatment, and hemorrhage-care assets are not mixed into a false workflow.
- [ ] Confirm whether the explanation is generic or based on clinician-approved patient data.
- [ ] If patient data is introduced later, document consent, de-identification, provenance, segmentation review, registration accuracy, and update control.

## Clinical accuracy

- [ ] Stroke neurologist approves pathology, plain-language labels, urgency language, benefits, risks, alternatives, and uncertainty.
- [ ] Interventional neuroradiologist approves access route, catheter/device depiction, angiography sequence, and thrombectomy mechanics when applicable.
- [ ] Neurosurgeon approves incision, cranial opening, dura/brain depiction, device choice, closure, and bone-flap status when applicable.
- [ ] Neurocritical-care clinician approves optional EVD, monitoring, postoperative care, and recovery language when applicable.
- [ ] Clinicians confirm that optional steps are not presented as routine or guaranteed.
- [ ] Clinicians confirm that timing, success, recovery, and outcome are not portrayed as predictable for an individual patient.

## Patient experience

- [ ] A health-literacy reviewer checks reading level and terminology.
- [ ] A patient or patient representative reviews emotional impact and comprehension.
- [ ] The user can pause, replay, skip graphic detail, and exit immediately.
- [ ] Spoken narration has captions; important meaning is not conveyed by color alone.
- [ ] The experience distinguishes “what may happen” from “what will happen to you.”
- [ ] The experience supports clinician discussion and does not act as standalone consent.

## Spatial-computing QA

- [ ] Real anatomical scale is verified after Reality Composer Pro import.
- [ ] Enlarged views are visibly labelled as enlarged.
- [ ] Step order, visibility rules, labels, and interactions are checked on a physical Vision Pro.
- [ ] No required information is outside a comfortable field of view or behind the patient.
- [ ] Motion, flashing, depth, and transition speed are reviewed for comfort and accessibility.
- [ ] The final assembled scene meets its frame budget under RealityKit Trace.

## Release control

- [ ] Every asset and script version used in the build is recorded.
- [ ] Clinical approval is tied to a specific app build and content revision.
- [ ] Changes to anatomy, device behavior, narration, or procedure flow trigger re-review.
- [ ] Feedback, incidents, and corrections have a documented escalation path.
