# Open cranial surgery after stroke: evidence and communication library

**Evidence search current to:** 8 August 2026
**Status:** research foundation for specialist review; not approved clinical content
**Audience:** clinicians, designers, engineers, medical reviewers, and patient/family advisers building the Stroke VisionOS educational prototype

> [!CAUTION]
> This library is not a clinical guideline, consent form, prognosis calculator, or treatment recommendation. It cannot determine whether an operation is appropriate for an individual. Decisions require the treating stroke, neurocritical-care, neurosurgical, and neurointerventional teams using the current examination, imaging, time course, the patient's known wishes, local capabilities, and applicable law. The linked professional guidelines remain authoritative.

## Why this library exists

Emergency cranial surgery conversations are unusually difficult. Families may have minutes or hours to understand that an operation can relieve pressure, stop or prevent rebleeding, or create space for swollen brain—yet may not restore brain already injured by the stroke. Survival and functional recovery are different outcomes. A technically successful operation can still be followed by aphasia, paralysis, dependence, prolonged critical care, further procedures, or death.

The product should therefore help a clinician explain:

1. what happened and what is causing danger now;
2. what the proposed operation physically does and does not do;
3. why a decision may be time-sensitive;
4. reasonable alternatives, including active medical treatment without surgery;
5. the best, most likely, and worst plausible trajectories;
6. uncertainty, including limits of population evidence for this patient;
7. how each option fits the patient's values and previously expressed wishes.

## Coverage

This review maps six stroke-related pathways in which the skull may be opened:

| Pathway | Principal operation(s) | Evidence in one line |
|---|---|---|
| Malignant hemispheric ischemic infarction | Large decompressive hemicraniectomy with duraplasty | Strong mortality benefit when selected patients aged 60 or younger are treated within 48 hours; older adults also gain survival, commonly with substantial disability. |
| Space-occupying cerebellar infarction | Suboccipital decompressive craniectomy, sometimes infarcted-tissue evacuation and/or external ventricular drain | Guideline-supported rescue for deterioration, brainstem compression, or obstructive hydrocephalus; comparative evidence is observational and selection criteria remain uncertain. |
| Spontaneous intracerebral hemorrhage | Open craniotomy and clot evacuation; decompressive craniectomy; posterior-fossa evacuation | Routine open surgery has not shown an overall functional benefit for most supratentorial hemorrhages, but may be lifesaving in selected deterioration; urgent cerebellar evacuation has a distinct guideline indication. |
| Aneurysmal subarachnoid hemorrhage | Microsurgical clip ligation, sometimes with hematoma evacuation and/or decompression | Coiling is preferred when both approaches are equally suitable in many patients; clipping remains essential for anatomy unsuitable for coiling and for some space-occupying hematomas requiring immediate evacuation. |
| Cerebral venous thrombosis with impending herniation | Decompressive craniectomy, with or without hematoma evacuation | Recommended as lifesaving rescue despite very low-certainty evidence; meaningful recovery is possible even after severe presentation. |
| Hemorrhage from a ruptured brain arteriovenous malformation | Hematoma evacuation, decompression, and/or microsurgical AVM resection in selected cases | Highly individualized by anatomy, rupture pattern, physiological stability, and team expertise; timing and definitive treatment remain debated. |

The library also covers external ventricular drainage and minimally invasive hemorrhage evacuation as decision comparators, plus cranioplasty after decompression. It excludes traumatic brain injury, tumor surgery, carotid endarterectomy, and stand-alone endovascular thrombectomy except where a comparator is necessary to explain a cranial operation.

## Library map

- [Scope and methods](SCOPE_AND_METHODS.md) — reproducible search strategy, inclusion rules, evidence labels, and limitations.
- [Evidence map](EVIDENCE_MAP.md) — condition-by-condition clinical synthesis and communication implications.
- [Procedure explainer](PROCEDURE_EXPLAINER.md) — plain-language anatomy, operative concepts, risks, and postoperative course.
- [Source summaries](SOURCE_SUMMARIES.md) — annotated guideline, trial, review, cohort, communication, and consent records.
- [Urgent family communication guide](COMMUNICATION_GUIDE.md) — a structured conversation workflow, language guidance, risk communication, and documentation checklist.
- [Synthetic conversation demos](DEMO_CONVERSATIONS.md) — clinician-review examples, explicitly not scripts for real cases.
- [Product and governance requirements](PRODUCT_REQUIREMENTS.md) — guardrails for a grounded VisionOS communication tool.
- [Glossary and outcome measures](GLOSSARY.md) — craniotomy versus craniectomy, modified Rankin Scale, and other terms.
- [Machine-readable reference index](references.csv) — source metadata for future content management and update checks.

## High-confidence design conclusions

1. **Do not present surgery as “fixing the stroke.”** Decompression creates space; evacuation removes blood; clipping excludes an aneurysm. None necessarily reverses established injury.
2. **Never equate survival with independence.** Show mortality and disability outcomes separately, using the same time horizon and denominator.
3. **No patient-specific percentage should be generated.** Trial populations are selected and often differ from the person in front of the team. A clinician may choose a closely matched, cited population statistic and must label its limits.
4. **“No operation” is not “no care.”** It can include full neurocritical care, ventilation, osmotherapy, blood-pressure management, reversal of anticoagulation, seizure treatment, drainage, rehabilitation planning, and/or comfort-focused treatment according to goals.
5. **The tool supports—but cannot conduct—informed consent.** A responsible clinician must individualize the indication, alternatives, material risks, uncertainty, recommendation, and opportunity for questions.
6. **Values belong inside the decision.** The relevant question is not only whether the patient might survive, but what outcomes the patient would consider acceptable and what burdens they would accept for that chance.
7. **The default experience should be clinician-controlled.** Visuals, evidence cards, and phrases are aids used during a human conversation, not an autonomous patient/family application.

## Mandatory review gates before clinical use

- named vascular neurosurgeon and stroke-neurologist review;
- neurocritical-care and neurointerventional review where relevant;
- local consent, capacity, substitute-decision-maker, and emergency-treatment legal review;
- professional medical interpreter and health-literacy review;
- patient and bereaved-family advisory review;
- accessibility, visual-overload, motion-sickness, and distress testing;
- citation verification and scheduled evidence surveillance;
- institutional clinical-safety, privacy, cybersecurity, and regulatory assessment.

Until those gates are completed and documented, every interface derived from this library must be labelled **“research prototype—not for patient-specific clinical decisions or consent.”**
