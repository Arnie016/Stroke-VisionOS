# Reference workspace hierarchy

Updated: 26 August 2026. Local prototype, clinician review pending.

## One destination at a time

The main explanation keeps the brain, topic-led left panel, timeline and
vertical right reference tabs. Imaging, Medications, Guides and Settings each
take the central reading field. Back restores the explanation instead of
creating another window. The bottom Evidence shortcut is replaced by Tools;
Guides is the single normal entry for published evidence.

| Destination | Visible work | Return |
| --- | --- | --- |
| Imaging | Large image, CT/MRI switch, study deck, import, comparison and image-surface annotation | Back to the brain and timeline |
| Imaging gallery | 2×2, 3×3 or 4×4 comparison, modality filters, pages, multiple local images and per-image marks | Gallery from detail, or Place beside brain with the selected image |
| Medications | Four selectable 3D teaching props, rotation, delivery context, cautions and named NHS references | Back to the same explanation |
| Guides | One source list and one selected source, with support and limitation | Back to the same explanation |
| Settings | Visual detail, background, sound and explanation-panel size | Back to the same explanation |

The focused destinations hide the anatomy attachments and peripheral controls.
Opening a destination dismisses legacy imaging/evidence windows belonging to
this app. Study changes retain imaging focus. Leaving imaging for a different
destination clears its focus flag so the anatomy cannot remain invisibly hidden.
The family companion, presenter guide, clinical evidence, detached teaching
image and teaching-model brief use one stable presentation value each.
Reopening one raises the existing workspace instead of leaving another floating
copy in the room, without increasing the visionOS 2 deployment requirement.
These navigation checks do not establish headset pinch reliability.
Reference tabs remain available at every visual-detail level. Choosing
Simplified cannot remove the route back to Settings.

## Conversation guide

The left panel is larger and resizable in Settings. Anatomy, Flow and Access
select the corresponding lesson family. Each offers four short, color-marked
terms. Pinching a term reveals one authored plain-language explanation. Access
also changes for the final team-checks beat. The text is not generated clinical
advice, and the app does not infer anxiety or record gaze.

## Content and asset boundaries

CT and MRI use the existing licensed research-template rasters described in
`IMAGING_REFERENCE_PROVENANCE.md`. CTA, MRA, PET and the legacy vessel map are
conceptual teaching references, not newly acquired radiographs or patient scans.
The existing importer accepts bounded local raster images, with the modality
declared by the presenter. Nothing is uploaded or interpreted.

Medication topics are general education only. They contain no dosing,
eligibility rule, individualized prescription, treatment ranking or outcome
claim. The medication exhibits are authored low-poly RealityKit geometry,
not exact branded products or a validated pharmacy training simulator. They
show a tablet blister, a generic delivery-form grouping, an IV bag and a
medicine bottle. Pinch selects the matching topic; pinch-drag turns the
selected object. Turn and Reset provide button fallbacks. Hospital stock,
local formularies, procurement and actual product appearance are not connected.
No new scan assets were added in the gallery pass.

Primary references checked on 26 August 2026:

- [NHS: clopidogrel](https://www.nhs.uk/medicines/clopidogrel/about-clopidogrel/)
- [NHS: anticoagulants](https://www.nhs.uk/medicines/anticoagulants/)
- [NHS: stroke treatment](https://www.nhs.uk/conditions/stroke/treatment/)
- [NHS: thrombolysis information](https://www.wsh.nhs.uk/CMS-Documents/Patient-leaflets/StrokeUnit/6484-1-Thrombolysis-for-stroke.pdf)
- [Johns Hopkins: craniotomy](https://www.hopkinsmedicine.org/health/treatment-tests-and-therapies/craniotomy)

## Verification routes

`--proof-presentation-settings`, `--proof-reference-medications`,
`--proof-reference-guides`, `--proof-imaging-room` and
`--proof-reference-return` render deterministic destinations. The return route
exercises the same state methods as the interface and asserts that the original
timeline, orbit and scale survive. It is not a simulated physical pinch.
The return route also switches Settings to Simplified before returning, to
guard against hiding the reference index at lower visual detail.

The separate non-graphic bone/dura layer study uses
`--proof-access-layer-open` and `--proof-access-layer-closed`. It is a reversible
model manipulation, not validated surgical practice, cutting or force feedback.

## Import, markup and Back

Each local file choice has a single-use request with its destination slot
captured before the read starts. Back, switching studies, changing role,
opening another reference workspace or choosing a newer import invalidates
the old request. Its late completion cannot reopen Imaging or replace the
new choice. A failed read leaves the current image and markup unchanged.
Removing a local image, or replacing it with an atlas study, clears its marks
so they cannot be mistaken for annotations on a different image.

**Place beside brain** retains the image and markup while it is arranged in
space. **Back** closes the teaching view and releases its temporary image and
markup. This remains memory-only work, with no save, upload or image analysis.

`Tests/verify_imaging_import_session.swift` runs the Foundation-only request
lifecycle checks. `--proof-imaging-import-lifecycle` runs the actual app state
handlers with a bundled atlas raster, draws a teaching mark, and renders it.
`--proof-imaging-import-return` additionally rejects a late import after Back
and renders the restored anatomy. These are state/render receipts, not a
Files-picker, drag-and-drop or wearer-pinch test.

## Comparison gallery

Enter **Imaging → Gallery**. The two bundled images are a CT research atlas
and an MRI research atlas, not two scans of the selected fictional patient.
Missing grid cells remain empty. CTA, MRA, PET and schematic vessel diagrams
are intentionally not mixed into a gallery of real raster scans.

**Add scans** accepts multiple local PNG/JPEG/HEIC images after the presenter
has removed identifiers. Modality is explicitly user-labelled, never inferred
from pixels or filenames. Images are downsampled to at most 1536 pixels for
teaching display, not diagnostic viewing; there is no DICOM/PACS integration.
Each input must be at most 24 MiB. The gallery holds at most 40 images and
64 MiB of encoded image payloads in memory. Invalid/over-limit files are skipped
with a visible count. Pending results cannot reopen a departed gallery.

Selecting a tile opens its own large reader. Drawing coordinates are normalized
to that image's fitted surface. Marks belong to that image and survive browsing
within the gallery; Undo removes only its last stroke. Back to the brain releases
local gallery images and marks. No save, export, upload, registration, finding,
measurement or prescription is implied.

`Tests/verify_imaging_gallery.swift` verifies layout capacities, pagination,
single-use imports, per-image markup, removal and memory limits. The routes
`--proof-imaging-gallery`, `--proof-imaging-gallery-nine`,
`--proof-imaging-gallery-sixteen`, `--proof-imaging-gallery-detail` and
`--proof-imaging-gallery-return` cover rendered layouts and return state.
The 16-slot capture is not evidence of 16 acquired scans.

## Gallery to spatial explanation

From an enlarged gallery image, **Place beside brain** transfers that image,
its presenter-declared modality and its marks to the existing movable imaging
plate. It does not create another window. The source credit remains visible for
bundled research rasters; local images remain local and memory-only.

Gallery and placed-image drawing share the same fitted raster bounds. Marks
follow the image rather than its surrounding letterbox, including when the
plate is focused or resized. Annotation uses the same unsmoothed path on both
surfaces. The normal plate's Annotate, Undo, Focus and Back remain available.

Only the selected image travels. Other temporary gallery imports and their
marks are released when the gallery closes. Back from the plate releases the
placed image and its marks. Choosing another study or a comparison resets the
old markup so it cannot appear attached to a different image.

Placement validates the selected raster before changing navigation. Invalid
payloads remain in the gallery with a visible error. Leaving the gallery cancels
its pending import so a delayed result cannot replace the placed image.

`--proof-imaging-gallery-placed`, `--proof-imaging-gallery-placed-local` and
`--proof-imaging-gallery-placement-return` exercise the same state handlers.
The local route uses an explicitly named copy of the bundled MRI research
atlas, not a newly acquired patient scan. These routes do not test Files-picker
interaction, eye targeting or physical pinch. See the dated proof log for the
actual build and render results.

Both the primary and detached comparison plates now mount their resolved
attachment entity during scene updates, not only during one-time setup. This
recovers an attachment that was unavailable initially or later replaced, while
the parent-identity check avoids needless reparenting. This follows
[Apple's RealityView attachment lifecycle](https://developer.apple.com/documentation/realitykit/realityview/init%28make%3Aupdate%3Aattachments%3A%29).

Verification status, 2026-08-26 22:40 SGT: the Simulator is available again.
Fresh bundled-image, local-image-fixture and return-to-anatomy captures all
pass their unchanged image checks and were visually inspected. The carried
mark stays on the raster and the selected source remains labelled. The
default placed-image pose is now forward-right rather than near-peripheral,
so the whole plate, Back and Focus fit in the initial view. Its four concise
study destinations no longer wrap; import and comparison remain in Study tools.

The 30 gallery checks, 13 import lifecycle checks, source contract and narrow
Simulator build pass. These deterministic routes verify state transitions
and rendering, not input delivery. Desktop Focus clicks did not establish a
visible transition; the subsequent Back click encountered a transient
computer-use `noWindowsAvailable` error. Actual Focus/Back activation,
Files-picker interaction, annotation gestures and wearer comfort remain
unverified. No clinical or device acceptance is implied.

### Image navigation ownership, 2026-08-26 23:06 SGT

The plate's title and image surface own movement and scaling. Back, Study
tools and Reset no longer sit under a header-wide drag/magnify recognizer.
Back and Focus have stable accessibility identifiers for interaction tests.
This preserves the quiet, image-first clinician layout without adding controls.

Both new source regressions failed before the change and pass afterward.
The narrow Simulator build, 30 gallery checks and 13 import checks pass.
The fresh placed-image capture passes its unchanged image gate and was
inspected: `/tmp/strokecare-gallery-navigation-20260826-v1.png`.

Live input remains unresolved. Simulator Home responded, but coordinate
actions intermittently returned `-10005: noWindowsAvailable`, including on
the system home screen. After rebuilding, two Focus clicks produced a hover
highlight without a visible focus transition. The gesture separation is
preventive hardening, not a confirmed root-cause fix or pinch acceptance.

### Imaging input trace, 2026-08-26 23:31 SGT

An opt-in Simulator Debug trace now separates button activation, state
transition and scene application. Launch with `SIMCTL_CHILD_STROKE_TRACE_IMAGING=1`
and inspect the `com.arnav.StrokeTime` / `ImagingInteraction` log category.
Events are fixed enum names only. No images, filenames, gaze, hand positions or
patient information are recorded. Release and device builds emit no events.

For a real Focus activation, expect `BUTTON_FOCUS`, `STATE_FOCUSED`, then
`SCENE_FOCUSED`. Back should emit `BUTTON_BACK`, `STATE_RETURNED`, and hide the
plate. Deterministic proof setup calls state handlers directly, so its state
events alone never prove button delivery.

The placed-image route emitted `SCENE_PLACED` and `READY`. Attempted Focus
clicks emitted no button event; the controller again reported
`-10005: noWindowsAvailable`. A direct focused-imaging route then emitted
`STATE_FOCUSED` and `SCENE_FOCUSED`, and a fresh screenshot shows the complete
enlarged scan with Back and Place beside brain. This verifies the focus
state/render path, not its live input path.

The focused-room OCR check initially required import/comparison controls that
the previous toolbar simplification moved into Study tools. Updated those
specific expected labels to the seven visible destinations/actions. All image
quality thresholds remain unchanged; the same fresh capture passes 7/7.
Source contract, narrow Simulator build, 30 gallery checks and 13 import
lifecycle checks pass. Focus/Back input, Files selection and physical pinch
remain unverified.

Interaction gate, 2026-08-26 23:37 SGT: the next pass again failed to deliver
Place beside brain or Back, including after native window recovery. Neither
attempt emitted a button event. The controller gate has persisted for at least
three consecutive resumed goal passes, so the goal is blocked pending a
working input path or a manual Place beside brain / Focus / Back check. No app
code was changed in that pass, and the requested product scope is unchanged.
