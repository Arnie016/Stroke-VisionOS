# Stroke Care clinical review packet

- Content version: `SC-AIS-001.2`
- App version: `0.6 (6)` review candidate
- Scenario: `CASE-078` (fictional; no patient data)
- Scenario frame: severe large-territory ischemic stroke with swelling; a
  decompressive hemicraniectomy explanation, not a treatment-selection flow
- Status: **PENDING CLINICIAN REVIEW**
- Last reviewed: **NOT REVIEWED**
- Intended audience: patient or family member with a clinician present
- Intended use: education and preparation for a care conversation

## Product boundary

Stroke Care is a communication aid. It does not diagnose stroke, read imaging,
determine eligibility, recommend treatment, predict outcome, capture consent,
or become part of a medical record. The 3D anatomy and flow are authored
schematics, not patient-specific anatomy or computed fluid dynamics.

The shipped spatial path explains one mechanical purpose: why a stroke team may
discuss making room when a severe large-territory infarction causes dangerous
swelling. It does not show treatment ranking or determine whether surgery is
appropriate. A real stroke team must interpret examination, imaging, timing,
pre-stroke function, wishes and preferences, local protocol, and the person's
full situation.

## Claim and annotation review matrix

| App surface | Draft wording or visual intent | Source basis | Reviewer decision |
| --- | --- | --- | --- |
| Case file | Speech change, arm weakness, and reported last-known-well are case-context clues. The severe-stroke-with-swelling frame is explicitly fictional and is not inferred from those clues. | AHA patient messages identify speech difficulty, arm weakness, and symptom timing as important. | Pending |
| 3D model | A blockage, affected tissue, swelling, and the fixed skull are separate schematic cues. | AHA describes ischemic stroke as blocked blood supply. NICE describes severe-stroke swelling and pressure inside the skull. All geometry is app-authored and needs clinical review. | Pending |
| Procedure purpose | Decompressive hemicraniectomy removes part of the skull to make room and ease pressure; it cannot undo stroke injury. | NICE NG128 recommendations 1.9.5–1.9.6 and the patient decision aid describe purpose, selection, uncertainty, and shared discussion. | Pending |
| Conversation boundary | The app does not recommend surgery, estimate survival or disability, or replace a risk/benefit and preferences conversation. | NICE states that the choice is preference-sensitive and should consider pre-stroke function, wishes, benefits, harms, and uncertainty. | Pending |

## Exact three-act review

The reviewer should judge the words and the animation together on XCAT. A text
approval alone is not sufficient.

| Act | Family wording | Spatial claim | Presenter boundary | Decision |
| --- | --- | --- | --- | --- |
| 1 — Orient | “This model shows one severe stroke affecting one side of the brain.” | Generic cortex and arterial anatomy appear inside a fixed-space boundary. | Generic anatomy; the scenario is not inferred from reported signs and is not this person's scan. | Pending |
| 2 — Pressure | “Here, a large stroke causes swelling inside the fixed skull.” | Blocked flow, affected tissue, swelling, and fixed skull remain distinct cues. | This is the selected fictional scenario; it is not a claim that every ischemic stroke causes dangerous swelling. | Pending |
| 3 — Make space | “Surgery makes room for swelling. It cannot undo the stroke injury.” | After permission, one protective layer fades and a small reversible offset shows the mechanical purpose without cutting, peeling, or exposed blood. | Making room may ease pressure; this is not a recommendation, consent discussion, or outcome promise. | Pending |

### Required reviewer questions

1. Is the severe large-territory scenario clear enough that Act 2 cannot be
   mistaken for a claim about every ischemic stroke?
2. Does the clot marker look like a confirmed patient finding rather than a
   generic teaching focus?
3. Does Act 3 correctly communicate the limited mechanical purpose of
   decompressive hemicraniectomy without implying tissue recovery or a
   guaranteed outcome?
4. Are “room,” “pressure,” “injury,” and “swelling” understandable and distinct
   when heard once in the headset?
5. Should the app explicitly name decompressive craniectomy, or is that term
   better reserved for the clinician's spoken explanation?
6. Is any visual or the phrase “makes room” likely to be graphic, frightening,
   overly simplistic, or falsely reassuring?

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

## Primary sources checked 2026-08-09

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
6. National Institute for Health and Care Excellence, NG128 recommendations
   1.9.5–1.9.7, “Decompressive hemicraniectomy.” Last reviewed 2026-03-27.
   https://www.nice.org.uk/guidance/ng128/chapter/recommendations
7. National Institute for Health and Care Excellence, “Stroke: decompressive
   hemicraniectomy surgery in people over 60,” patient decision aid. This is a
   conversation aid, not a substitute for clinician review or local consent.
   https://www.nice.org.uk/guidance/ng128/resources/patient-decision-aid-on-decompressive-hemicraniectomy-surgery-in-people-over-60-pdf-6775901390

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
