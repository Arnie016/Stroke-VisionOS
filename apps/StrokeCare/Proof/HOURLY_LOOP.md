# Stroke Care hourly improvement ledger

## 2026-08-08 19:18 SGT — automation setup

- Target: keep the stroke-only visionOS prototype improving after the Codex app
  is closed.
- Bounded action: created the active hourly heartbeat
  `hourly-stroke-care-prototype-loop` on this task.
- Evidence: the Codex automation service returned the automation identifier and
  accepted an hourly schedule.
- Verdict: `IMPROVED` — future runs have a narrow one-change contract and an
  explicit proof boundary.
- Blocker: no autonomous run receipt exists until the first scheduled wakeup.
- Next safe action: transcribe the new team recording and convert one verified
  design observation into the next bounded product change.

## 2026-08-09 01:57 SGT — scenario-specific Pressure wording

- Target: keep Act 2 concise while making clear that dangerous swelling belongs
  to this fictional severe-stroke scenario, not every ischemic stroke.
- Bounded action: changed the family/narrator sentence to “In this severe
  stroke, swelling builds inside the fixed skull,” incremented the pending
  clinical-content packet to `SC-AIS-001.3`, and updated the contract assertion.
- Evidence: `Scripts/deploy_xcat.zsh` stopped with XCAT `unavailable`;
  `tunnelState=unavailable`, `pairingState=paired`, and
  `ddiServicesAvailable=false`. `python3 Tests/verify_contract.py` passed and
  the narrow visionOS Simulator build exited `0`.
- Verdict: `IMPROVED` — Act 2 is now explicitly scenario-bound without adding
  text, a new feature, or a clinical claim.
- Blocker: XCAT 0.6 install, foreground launch, wearer observations, and the
  `SC-AIS-001.3` clinician decision remain unproven.
- Next safe action: when XCAT is powered on, worn, unlocked, and reachable,
  rerun `Scripts/deploy_xcat.zsh` once.

## 2026-08-09 12:04 SGT — GPT-Realtime-2.1-only narration transport

- Target: remove the default Mac voice and make the requested Realtime model an
  executable, key-safe narration path.
- Bounded action: added a loopback-only narration proxy that locks
  `gpt-realtime-2.1`, loads the permanent key through `apikey`, receives
  Base64 PCM deltas, returns app-playable WAV, and rejects every other model.
  The visionOS client remains silent when the proxy is absent; it has no system
  speech fallback.
- Evidence: the guarded XCAT pass created
  `Proof/xcat/20260809-115427/BLOCKED.md` because the paired device remains
  unavailable. A generic, non-patient caption then returned HTTP `200` as a
  24 kHz mono PCM WAV (147,080 bytes; SHA-256
  `870eb70237acb28b0519087f451c78b08f6391221ce02f19e7f90a6933345d18`).
  The deterministic Simulator route launched as process `87231`; its visionOS
  client triggered a second successful Realtime request (220,152 audio bytes),
  and `Proof/41-gpt-realtime-narration-simulator.png` shows the active
  `Voice off` state. The contract and narrow Simulator build both passed.
  `Proof/REALTIME_NARRATION_PROOF.md` records the exact machine boundary.
- Verdict: `IMPROVED` — narration is now Realtime-only and executable without
  embedding a permanent API key in visionOS.
- Blocker: wearer-audible quality, spatial placement, comfort, comprehension,
  XCAT playback, and the clinical content packet remain unproven.
- Next safe action: have one human listen to the Simulator output and record a
  concise cadence/clarity verdict before changing the locked Realtime voice.

## 2026-08-09 11:32 SGT — role-aware anatomical magnifier

- Target: replace modal-heavy explanation chrome with one calm, spatially
  anchored anatomy-focus interaction for Brief 6.
- Bounded action: converted the top act annotation into free-standing spatial
  typography, replaced the presenter panel with gaze-sized control bubbles,
  added act-driven horizon modulation, and made the single affected-region
  aperture read as `LOOK WITHIN` for families and `MAGNIFY` for clinicians.
  Pinch focus is reversible, fades context through the existing transparency
  engine, and switches to the qualitative blood-flow point field.
- Evidence: `python3 Tests/verify_contract.py` passed; the narrow visionOS
  Simulator build exited `0`; Simulator process `47220` launched after stale
  `CathSenseVision` and `SpatialPropertiesLab` scenes were terminated; visual
  receipt: `Proof/39-clinician-magnify-portal-simulator.png`.
- Verdict: `IMPROVED` — the anatomy is again primary, the magnifier is
  role-aware, and essential safety/evidence actions remain legible without a
  surrounding modal panel.
- Blocker: Simulator imagery does not prove gaze comfort, pinch precision,
  wearer perception, liquid-flow comprehension, XCAT visibility, or clinical
  validity.
- Next safe action: run the same magnifier path on XCAT when it is awake,
  unlocked, paired, and reachable.

## 2026-08-09 10:38 SGT — durable unavailable-device receipt

- Target: preserve an authoritative machine record when XCAT is unreachable
  without mistaking that record for physical app execution.
- Bounded action: updated `Scripts/deploy_xcat.zsh` so every run writes the
  exact device JSON, one-line state, and a dated `BLOCKED.md` before exiting on
  an unavailable tunnel. Local receipt contents are ignored by Git.
- Evidence: test run created
  `Proof/xcat/20260809-103545/BLOCKED.md` with `tunnelState=unavailable`,
  `pairingState=paired`, `ddiServicesAvailable=false`, and explicit `NO` values
  for build, install, and foreground launch. The contract and narrow visionOS
  Simulator build passed.
- Verdict: `IMPROVED` — a failed reachability attempt now has durable evidence
  while the device, wearer, and clinical proof boundaries remain intact.
- Blocker: XCAT 0.6 install, foreground launch, wearer observations, and the
  `SC-AIS-001.4` clinician decision remain unproven.
- Next safe action: when XCAT is powered on, worn, unlocked, and reachable,
  rerun `Scripts/deploy_xcat.zsh` once.

## 2026-08-09 10:26 SGT — conditional Make space wording

- Target: preserve the mechanical purpose of Act 3 without implying that an
  operation is guaranteed to create the intended result.
- Bounded action: changed the family/narrator sentence from “Surgery makes
  room” to “Surgery can make room,” incremented the pending clinical-content
  packet to `SC-AIS-001.4`, and updated the exact contract assertion.
- Evidence: `Scripts/deploy_xcat.zsh` stopped with XCAT `unavailable`;
  `tunnelState=unavailable`, `pairingState=paired`, and
  `ddiServicesAvailable=false`. `python3 Tests/verify_contract.py` passed and
  the narrow visionOS Simulator build exited `0`.
- Verdict: `IMPROVED` — the ten-word intervention claim is now conditional
  while the irreversible-injury boundary remains unchanged.
- Blocker: XCAT 0.6 install, foreground launch, wearer observations, and the
  `SC-AIS-001.4` clinician decision remain unproven.
- Next safe action: when XCAT is powered on, worn, unlocked, and reachable,
  rerun `Scripts/deploy_xcat.zsh` once.

## 2026-08-09 12:32 SGT — deliberate environments and transparent lesson family

- Target: let the presenter change environmental depth without coupling mood,
  anatomy, or patient state, and make see-through anatomy reveal the complete
  intended point family.
- Bounded action: added presenter-only Surroundings, Warm horizon, and Focus
  field bubbles mapped to native mixed, progressive, and full immersion. The
  warm field now uses stable unlit paper geometry; the focus field has one
  bounded key light. In see-through mode all five vessel-story markers remain
  visible while one selected point stays dominant. Region markers now live in
  the registered-v2 frame rather than inheriting cortex opacity.
- Evidence: guarded XCAT attempt created
  `Proof/xcat/20260809-121143/BLOCKED.md` with the paired device unavailable;
  no device build/install/launch was attempted. `python3
  Tests/verify_contract.py` passed and the narrow visionOS Simulator build
  exited `0`. Simulator routes produced
  `Proof/42-environment-surroundings-simulator.png`,
  `Proof/43-environment-warm-simulator.png`, and
  `Proof/44-environment-focus-simulator.png` from the same transparent anatomy
  state.
- Verdict: `IMPROVED` — the three environments are visibly distinct and the
  transparent lesson-family contract is rendered rather than implied.
- Blocker: XCAT visibility, gesture precision, comfort, audio perception,
  comprehension, and `SC-AIS-001.4` clinical review remain unproven.
- Next safe action: when XCAT is awake, worn, unlocked, and reachable, run the
  three environment states and select each of the five vessel-story points once.

## 2026-08-09 13:00 SGT — archive-to-case constellation handoff

- Target: make patient selection a spatial threshold rather than persistent
  furniture or another dashboard window.
- Bounded action: replaced the three-shelf cabinet with one face-angled dossier
  bay, a fanned five-file archive, one protruding draggable fictional file, and
  a compact focused-file briefing. Docking now removes the archive and reveals
  a central generic case figure connected to four concise facts by copper
  filaments, with one primary Begin action. The Vessel Story rail moved into
  the upper-left visual field; presenter controls now fold environment,
  evidence, and reset into one More bubble while Pause, Voice, Next, and Exit
  remain below.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build
  exited `0`. The booted Apple Vision Pro Simulator installed and launched the
  deterministic routes that produced
  `Proof/45-case-library-archive-simulator.png`,
  `Proof/46-case-review-constellation-simulator.png`, and
  `Proof/47-vessel-story-upper-field-simulator.png`.
- Verdict: `IMPROVED` — the archive and expanded case are now mutually
  exclusive spatial states, and the anatomy view has fewer always-visible
  controls.
- Blocker: cyclic archive browsing, registered point-placement review, XCAT
  wearer judgment, and `SC-AIS-001.4` clinical review remain unproven.
- Next safe action: run a frame-registration overlay audit for every Vessel
  Story marker before changing any marker position.

## 2026-08-09 15:54 SGT — world-staged anatomy and XCAT 0.6 launch

- Target: put the current main Stroke Care build in front of the XCAT wearer
  with repeatable model-frame viewpoints and no detached blockage marker.
- Bounded action: sampled one device pose to place the complete case/anatomy/UI
  stage in a single room-fixed frame; added Front, Side A, Side B, Top, and
  Three-quarter views to the existing anatomy control; bound the example
  blockage marker to the registered clot surface; quarantined unreviewed flow
  markers from all-point display; and corrected the guarded device process
  query for current `devicectl` output.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; a clean generic visionOS Simulator build exited
  `0`; the signed physical build, code-sign verification, install, installed-app
  query, `--hackathon-demo` foreground launch, and running-process query all
  passed in `Proof/xcat/20260809-155324/RECEIPT.md` (PID 592).
- Verdict: `IMPROVED` — the current `0.6 (6)` binary is installed and running on
  XCAT, while anatomy, case intake, annotations, and controls now share one
  initial placement frame.
- Blocker: wearer-visible placement, viewpoint comfort, marker contact in both
  eyes, gestures, audio perception, comprehension, and clinical laterality are
  not established by the machine receipt.
- Next safe action: complete one wearer pass from `Proof/XCAT_ACCEPTANCE.md` and
  record the four observations in the generated `WEARER_RESULT.md`.
