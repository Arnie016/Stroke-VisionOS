# Stroke Care clinical review packet

- Content version: `SC-AIS-001.1`
- App version: `0.5 (5)` / PR #3 review candidate
- Scenario: `CASE-078` (fictional; no patient data)
- Status: **PENDING CLINICIAN REVIEW**
- Last reviewed: **NOT REVIEWED**
- Intended audience: patient or family member with a clinician present
- Intended use: education and preparation for a care conversation

## Product boundary

Stroke Care is a communication aid. It does not diagnose stroke, read imaging,
determine eligibility, recommend treatment, predict outcome, capture consent,
or become part of a medical record. The 3D anatomy and flow are authored
schematics, not patient-specific anatomy or computed fluid dynamics.

No treatment ranking is shown. “Plan A” and “Plan B” are discussion cards, not
an ordered protocol. A real stroke team must interpret symptoms, timing,
imaging, contraindications, vessel location, local protocol, and the person's
full situation.

## Claim and annotation review matrix

| App surface | Draft wording or visual intent | Source basis | Reviewer decision |
| --- | --- | --- | --- |
| Case file | Speech change, arm weakness, and reported last-known-well are clues the team asks about. | AHA patient messages identify speech difficulty, arm weakness, and symptom timing as important. | Pending |
| 3D model | A clot can block blood flow in an ischemic stroke. Amber marks a qualitative “tissue at risk” teaching region. | AHA describes ischemic stroke as sudden vessel blockage, usually by a clot. The amber region is an app-authored metaphor and needs clinical review. | Pending |
| Plan A | The team may review clot-dissolving medicine; timing, imaging, bleeding risk, medicines, and history matter. | AHA/ASA guidance describes thrombolytic treatment for selected eligible patients and emphasizes timely evaluation. | Pending |
| Plan B | For some larger blocked vessels, specialists may review mechanical thrombectomy; imaging, vessel location, timing, and the person's situation matter. | AHA/ASA patient materials describe thrombectomy for eligible patients with large-vessel occlusion. | Pending |
| Conversation summary | “What did imaging show? Which options are being considered? What happens next?” | These are app-authored prompts intended to reduce information overload. | Pending |

## Exact three-act review

The reviewer should judge the words and the animation together on XCAT. A text
approval alone is not sufficient.

| Act | Family wording | Spatial claim | Presenter boundary | Decision |
| --- | --- | --- | --- | --- |
| 1 — Orient | “The skull is fixed. Vessels feed the brain.” | A generic cortex and arterial map sit inside a fixed-space boundary. | Generic anatomy—not this patient's scan. | Pending |
| 2 — Pressure | “Here, a clot blocks flow. Swelling crowds fixed space.” | A teaching clot interrupts qualitative vessel motion; affected tissue and swelling remain distinct cues. | No pressure value, prognosis, or eligibility claim. | Pending |
| 3 — Make space | “Making room can reduce pressure—not repair injury.” | After permission, skull, dura, and brain separate with a non-graphic zip-like motion; the injury cue remains visible. | Not a recommendation or outcome promise. | Pending |

### Required reviewer questions

1. Does Act 2 incorrectly suggest that every ischemic stroke causes dangerous
   swelling, or is the fictional large-territory scenario sufficiently clear?
2. Does the clot marker look like a confirmed patient finding rather than a
   generic teaching focus?
3. Does the Act 3 animation correctly communicate the limited mechanical
   purpose of decompression without implying tissue recovery?
4. Are “room,” “pressure,” “injury,” and “swelling” understandable and distinct
   when heard once in the headset?
5. Should the app explicitly name decompressive craniectomy, or is that term
   better reserved for the clinician's spoken explanation?
6. Is any visual likely to be experienced as graphic, frightening, or falsely
   reassuring?

### Acceptance rule

Every row above must be marked `Approve`, `Revise`, or `Reject`, with the
reviewer's wording changes recorded below. Approval applies only to supervised
education for this fictional scenario and this content version. Any copy,
anatomy, timing, or animation change increments the content version and returns
the affected row to `Pending`.

## Annotation intention checklist

- Every label answers one patient question; no decorative medical labels.
- “Occlusion” points to the blockage, not an inferred diagnosis from user data.
- Amber never means confirmed salvageable tissue, prognosis, or eligibility.
- The catheter cue explains a concept; it is not procedural training.
- Pause is an explicit user choice. No gaze, voice, behavior, or biometric
  anxiety inference is used.
- Family wording should be understandable without removing uncertainty.
- Clinician wording should surface verification prompts without acting as a
  decision-support system.

## Primary sources checked 2026-08-08

1. American Heart Association/American Stroke Association, “2026 Guideline for
   the Early Management of Patients With Acute Ischemic Stroke.” Updated
   2026-01-26.
   https://professional.heart.org/en/science-news/2026-guideline-for-the-early-management-of-patients-with-acute-ischemic-stroke
2. American Heart Association, “Key Patient Messages: The 2026 Acute Ischemic
   Stroke Guideline.”
   https://professional.heart.org/-/media/PHD-Files-2/Science-News/k/Key-Patient-Messages-The-2026-Acute-Ischemic-Stroke-Guideline.pdf?sc_lang=en
3. American Stroke Association, “Ischemic Stroke (Clots).” Accessed 2026-08-08.
   https://www.stroke.org/en/about-stroke/types-of-stroke/ischemic-stroke-clots
4. American Heart Association/American Stroke Association, “Recommendations
   for the Management of Cerebral and Cerebellar Infarction with Swelling.”
   Updated 2014-01-30. This supports review of swelling and decompression as a
   selected-complication pathway; it does not establish eligibility for this
   fictional case.
   https://professional.heart.org/en/science-news/recommendations-for-the-management-of-cerebral-and-cerebellar-infarction-with-swelling/top-things-to-know
5. American Heart Association/American Stroke Association, 2019 AIS guideline
   slide set, section 5.1.3. This is retained specifically for the historical
   surgical-management wording and must be checked by the reviewer against the
   2026 full guideline before sign-off.
   https://professional.heart.org/en/-/media/PHD-Files-2/Science-News/2/2019/2019-Guidelines-for-the-Early-Management-of-Patients-with-Acute-Ischemic-Stroke-Slide-Set.pdf

## Reviewer sign-off

- Reviewer name and credentials:
- Clinical role and institution:
- Date:
- Required wording changes:
- Anatomy/animation changes:
- Three-act matrix decisions:
- Reviewed on XCAT app version/build:
- Approved content version:
- Approved for supervised education demo: Yes / No

Until those fields are completed, the app must continue to display
“Clinician review pending” and must not be presented as clinically validated.
