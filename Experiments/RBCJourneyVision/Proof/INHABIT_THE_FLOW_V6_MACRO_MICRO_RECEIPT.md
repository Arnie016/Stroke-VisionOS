# Inhabit the Flow V6 — frontal macro-to-micro destination receipt

Date: 2026-08-10 (Asia/Singapore)

Status: **PASS — bounded native macro-to-micro destination, 53 contract checks,
generic visionOS Simulator build, deterministic route/family states, and local
A/B plus motion review. LIMITED — not to scale; no XCAT/wearer, specialist,
patient, histology, CFD, perfusion, tissue-outcome, or clinical proof.**

## What changed

- The frontal route no longer ends at coral dots. It enters a continuous
  penetrating arteriole, divides into three precapillary feeders, and resolves
  into a 34-node organic capillary web.
- Each node connects to its three or four nearest neighbors through curved,
  depth-varied paths. Twelve elongated gold fronts travel across different
  links; they show direction only and are not velocity vectors.
- An undulating translucent cortical exchange sheet provides tissue context
  behind the vessels. The existing irregular frontal outline remains the broad
  orientation boundary.
- Route copy and the family guide's arrival beat now explain artery → arteriole
  → capillary bed while explicitly stating that scale is expanded and flow is
  not measured.
- Pause holds red cells, route light, and microvascular fronts through the same
  local RealityKit clock. No camera, new portal, dashboard, network request, or
  patient data was added.

## Authoring decision

The bundled `microcirculation_arterial_venous_v2.usdz` was inspected first. It
is a valid 367 KiB, 22,072-vertex conceptual teaching asset with separable
arteriole, capillary, red-cell, direction-marker, and venule entities and
embedded specialist-review limits. Its layout is a flat vignette, so it remains
the Exchange portal reference rather than being promoted as a card-like frontal
destination. The runtime destination is deterministic native RealityKit
geometry.

## Medical boundary

The wording is constrained by NCBI Bookshelf, *Anatomy and Ultrastructure — The
Cerebral Circulation*: cerebral arteries divide into smaller arteries and
arterioles; surface arteries give rise to vessels that penetrate cortical
tissue; cerebral capillary beds are dense exchange networks.

Source: https://www.ncbi.nlm.nih.gov/books/NBK53086/

The animation does not encode diameter, pressure, velocity, perfusion,
collateral capacity, oxygen delivery, tissue viability, or an individual's
vascular topology.

## Verification

- `python3 Tests/verify_contract.py`: `RBC_JOURNEY_CONTRACT=PASS` (53 checks).
- Xcode 26.6 (17F113), XRSimulator 26.5.
- Unsigned generic visionOS Simulator Debug build: `** BUILD SUCCEEDED **`.
- Product:
  `/tmp/rbc-macro-micro-derived/Build/Products/Debug-xrsimulator/RBCJourneyVision.app`
- Physical Apple Vision Pro `XCAT`: not run for this pass.

## Accepted local proof

- `131-frontal-macro-micro-dense-accepted.png`: 3840 × 2160; SHA-256
  `72a16304e9ace91bff8df59bae9b537fe85a0a94c4fbaae31c4723dd4575aa21`.
- `133-frontal-macro-micro-motion-contact-sheet.png`: 3840 × 1080; two times
  from one frontal-route launch, showing changed red-cell and gold-front
  positions; SHA-256
  `1f63611e19f3f08b3796f22910433cf4c043e768de475d2f86a64a4565e9fc79`.
- `134-frontal-macro-micro-family-arrival-accepted.png`: 3840 × 2160; locked
  family-guide beat `03 / 03`; SHA-256
  `237a0847d9bc6f6b9ea59f11dc0e9fbda1368164c197498f56b4c941d6386456`.

Candidates 128–130 were rejected locally: first as a rectangular graph, then as
an organic but insufficiently dense network. The second full-resolution motion
sample and A/B sheet remain local QA inputs rather than additional repository
assets. They are not promotion evidence.

Codex visual verdict: **PROMOTE locally.** The route now has a legible spatial
destination and an anatomy-backed change of scale; the connected web and moving
fronts materially outperform the previous dots. It remains an authored teaching
metaphor rather than a naturalistic microvascular reconstruction.

## Source receipt

- `Sources/RBCJourneyScene.swift` SHA-256:
  `02067d32908d4e7cc5676044ed7aef35813917141eaa59edffeef165c9071d10`
- `Sources/RBCJourneyModel.swift` SHA-256:
  `7b1b106dbf7cd1654bd8539fba0cbcd653d9f7025bea22da0d6af86a69ceed7b`
- `Docs/medical-content-canon.md` SHA-256:
  `3eb4475f0feba3d4783a4d8ae84a8f76ea5969e1ba69ca3cf7bf8a918bba9dd5`

## Next honest gate

On XCAT, inspect the frontal transfer from a stationary stance. Confirm that the
capillary web reads as depth rather than a plane, gold fronts remain distinct
from red cells, the expanded-scale sentence is readable, and Pause freezes the
whole scene without discomfort. Only then promote beyond Simulator proof.
