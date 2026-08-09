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
  `0`; deterministic Front, Side A, and Top captures are recorded as
  `Proof/48-model-front-points-simulator.png`,
  `Proof/49-model-side-a-points-simulator.png`, and
  `Proof/50-model-top-points-simulator.png`; the signed physical build,
  code-sign verification, install, installed-app query, `--hackathon-demo`
  foreground launch, and running-process query all passed in
  `Proof/xcat/20260809-155324/RECEIPT.md` (PID 592).
- Verdict: `IMPROVED` — the current `0.6 (6)` binary is installed and running on
  XCAT, while anatomy, case intake, annotations, and controls now share one
  initial placement frame.
- Blocker: wearer-visible placement, viewpoint comfort, marker contact in both
  eyes, gestures, audio perception, comprehension, and clinical laterality are
  not established by the machine receipt.
- Next safe action: complete one wearer pass from `Proof/XCAT_ACCEPTANCE.md` and
  record the four observations in the generated `WEARER_RESULT.md`.

## 2026-08-09 16:08 SGT — physical stage-placement path receipt

- Target: distinguish “the app process is running” from “the physical XCAT
  placement code actually sampled a tracked device anchor.”
- Bounded action: added a local privacy-bounded placement receipt and a guarded
  collector. The app records only source, sample attempt, intended distance,
  app build, and explicit machine/wearer/clinical proof states; it omits raw
  room coordinates, gaze, hands, and patient data. The binary was advanced to
  `0.6 (7)` so this receipt cannot be confused with build 6.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; the generic physical visionOS build exited `0`;
  signed build, code-sign verification, install, installed-app query,
  foreground launch, and process query passed in
  `Proof/xcat/20260809-160742/RECEIPT.md`. Launching
  `--proof-view-anterior` on XCAT produced
  `Proof/xcat/20260809-160823-stage-placement/RECEIPT.md`: build 7, tracked
  anchor `true`, sample attempt 3, sample-once room-fixed mode, intended
  distance `1.16 m`, wearer and clinical evidence `NOT_RUN`.
- Verdict: `IMPROVED` — physical execution now proves the actual placement path
  rather than only installation and process existence.
- Blocker: XCAT framebuffer capture is unsupported through `devicectl`, the Mac
  remains locked for Xcode UI inspection, and no wearer or clinician result has
  been recorded.
- Next safe action: unlock the Mac, capture the XCAT frame through the supported
  Xcode/device interface if available, and record the four wearer observations.

## 2026-08-09 16:39 SGT — registered Vessel Story anchors and build 8 gate

- Target: keep Vessel Story dots attached to the current registered-v2 anatomy
  instead of projecting them onto a detached front-facing plane.
- Bounded action: removed the shared `frontZ` projection, made the clot-bound
  marker the default procedure focus, and placed the remaining four cues on
  exact registered-v2 arterial-mesh technical samples. These samples remain
  unapproved teaching anchors pending authored `FLOW_ANCHOR` exports and
  specialist review.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; the generic visionOS build passed; build `0.6 (8)`
  passed Apple Development signing plus deep and designated-requirement checks.
  Installation stopped before completion when XCAT disconnected with
  CoreDevice error `4000`; the next lock-state query reported
  `passcodeRequired: true`. The gate is recorded in
  `Proof/xcat/20260809-163625/BLOCKED.md`.
- Verdict: `IMPROVED` — the source and signed binary now preserve registered
  marker contact, without claiming that build 8 reached the headset.
- Blocker: XCAT is paired but presently locked, and still has Stroke Care
  `0.6 (7)` installed.
- Next safe action: wear and unlock XCAT, then install and foreground-launch the
  already signed build 8 and query its running process once.

## 2026-08-09 16:45 SGT — XCAT build 8 installation

- Target: move the merged main Stroke Care build from a signed Mac artifact to
  the physical XCAT device without overstating launch or wearer evidence.
- Bounded action: reran the guarded deployment from `main`; after one transient
  disconnect, confirmed the signed app installed as `Stroke Care 0.6 (8)`.
- Evidence: the physical visionOS build and deep code-sign checks passed; the
  install command reported `App installed`; a separate installed-app query
  returned version `0.6`, bundle version `8`. The normal launch produced no
  running process, and the deterministic launch timed out after 15 seconds
  while XCAT reported `passcodeRequired: true`. Receipt:
  `Proof/xcat/20260809-164319/INSTALL_ONLY.md`.
- Verdict: `IMPROVED` — the current main build is on XCAT, one evidence rung
  beyond the previous signed-only gate.
- Blocker: foreground activation and process existence remain unproved until
  the wearer unlocks XCAT; wearer and clinical observations remain separate.
- Next safe action: wear and unlock XCAT, then foreground-launch build 8 once
  and query the running `StrokeTime` process.

## 2026-08-09 17:04 SGT — isolate lesson-point gaze and pinch

- Target: make Vessel Story lesson points receive gaze-and-pinch selection
  without the larger invisible anatomy interaction proxies intercepting them.
- Bounded action: added and registered a dedicated RealityKit component for
  lesson-point targets, attached it to every sparse cue, and routed a filtered
  high-priority spatial tap into the existing shared selection state. Kept the
  precise 6 mm collision radius so adjacent registered flow cues do not gain
  overlapping hit volumes; disabled lesson selection while question placement
  is armed so annotation retains its distinct intent.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic physical
  visionOS build succeeded; the signed build, deep code-sign verification,
  install, installed-app query, deterministic launch, and process query passed
  for `0.6 (9)` in `Proof/xcat/20260809-165957/RECEIPT.md`. A separate normal
  no-argument launch and process query passed at 17:04 SGT with PID 761, recorded
  in `Proof/xcat/20260809-170430-main-route/RECEIPT.md`.
- Verdict: `IMPROVED` — the source now gives lesson points their own registered
  query family and build 9 is foregrounded on XCAT through the actual main-app
  route.
- Blocker: a machine process receipt cannot prove point hover, pinch selection,
  question-marker separation, comfort, comprehension, or clinical meaning.
- Next safe action: record one XCAT wearer pass confirming point hover, point
  selection, and annotation-mode question placement on build 9.

## 2026-08-09 17:22 SGT — spatial three-act timeline

- Target: let the family or presenter understand and revisit the three calm
  acts without another tab panel, while keeping anatomy dominant at center.
- Bounded action: added a centered world-space `Orient → Pressure → Make space`
  timeline with gaze-and-pinch chapter targets and active-node expansion;
  added one left-peripheral family question or exactly three presenter keys;
  removed the duplicate presenter Act menus. Direct chapter selection reuses
  the existing permission-aware `present(step:)` path.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic physical
  visionOS build for `0.6 (10)` ended `** BUILD SUCCEEDED **`. The first guarded
  device deployment stopped before build/install because `devicectl` reported
  XCAT `unavailable`; receipt:
  `Proof/xcat/20260809-171918/BLOCKED.md`.
- Verdict: `IMPROVED` — the timeline and role cues compile as one spatial layer,
  without adding medical breadth or another window.
- Blocker: XCAT is presently unavailable, and no wearer-view or gaze/pinch
  result exists for build 10.
- Next safe action: wear and unlock XCAT, then rerun the guarded build-10
  deploy/install/foreground-launch lane once.

## 2026-08-09 17:52 SGT — Page 2 teaching-imaging scaffold

- Target: expose the Figma Page 2 stroke-effect and making-room comparison as
  an on-demand spatial reference without adding another persistent modal.
- Bounded action: added two separate, slightly fanned teaching plates at the
  right-secondary field; both retain the affected-region cue, while only the
  second adds a making-room displacement cue. Added explicit fictional,
  non-scan, no-recovery, and clinical-review labels plus a deterministic proof
  route. Kept the drawer closed outside the explanation phase.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; generic physical and
  visionOS Simulator builds for `0.6 (11)` ended `** BUILD SUCCEEDED **`;
  Simulator install and `--proof-teaching-imaging` launch returned PID 96960;
  `Proof/52-teaching-imaging-drawer-simulator.png` records layout only.
- Verdict: `IMPROVED` — the missing evidence location and safe comparison state
  are now executable, but the procedural schematics are only a scaffold and
  have been rejected as the final visual quality bar.
- Blocker: Figma MCP is rate-limited, XCAT remains unavailable, and no licensed
  patient-figure or patient-imaging asset is currently verified for runtime.
- Next safe action: replace the two procedural plates with registered-v2
  RealityKit anatomy miniatures after the duplicate-surface and performance
  audit passes.

## 2026-08-09 19:31 SGT — XCAT reachability gate

- Target: deploy the current Stroke Care build to the paired XCAT before
  continuing Simulator-only visual work.
- Bounded action: ran the guarded `Scripts/deploy_xcat.zsh` lane once and
  stopped before build, install, or launch when CoreDevice reported the paired
  headset unavailable. Preserved the active dirty feature worktree.
- Evidence: the command returned `XCAT_DEPLOY=BLOCKED`; dated machine receipt:
  `Proof/xcat/20260809-193113/BLOCKED.md`.
- Verdict: `BLOCKED` — no device build, install, launch, wearer, or clinical
  evidence was created in this pass.
- Blocker: CoreDevice reports
  `613CC48C-A6AD-5170-A238-D518B6012491` as `unavailable`.
- Next safe action: wear and unlock XCAT near this Mac, then rerun
  `Scripts/deploy_xcat.zsh` once.

## 2026-08-09 20:20 SGT — restore deterministic Simulator placement

- Target: replace the near-black Simulator capture with an honest, visible
  three-act scene without changing the physical XCAT placement path.
- Bounded action: reproduced the failure on the normal Pressure route, then
  kept Simulator runs in the authored coordinate frame while leaving the
  tracked device-anchor room placement enabled for physical builds.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; the OS 26.5 visionOS Simulator build ended
  `** BUILD SUCCEEDED **`; a fresh install launched PID 89225; and
  `Proof/54-simulator-authored-frame-pressure.png` shows the brain, timeline,
  atlas rail, and attachments instead of an empty black field.
- Verdict: `IMPROVED` — the scene is visible and falsifiable again, though its
  lighting, scale, point behavior, and final composition remain unfinished.
- Blocker: the semantic v2 skull is an approximate cross-source fit and still
  requires specialist registration review before it can overlay the family
  anatomy as if exact.
- Next safe action: build one isolated, clearly labelled skull inspection state
  for registration review before enabling any skull overlay in the family path.

## 2026-08-09 20:49 SGT — gated Scholar skull inspection

- Target: make the next registered-model increment visible without presenting
  an approximate cross-source skull as exact patient anatomy.
- Bounded action: added an exact-ID, clinician-only Scholar inspection that
  isolates the existing v2 skull in bright Surroundings, supplies focused
  registration-review copy, removes competing point/tool/voice/image controls,
  and restores the normal assembly when the presenter moves to another act.
- Evidence: `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the OS 26.5 visionOS
  Simulator build ended `** BUILD SUCCEEDED **`; a fresh install launched PID
  18592; `Proof/55-scholar-skull-registration-review-simulator.png` records the
  visible 3840×2160 layout with SHA-256
  `641190c1add4f0a6200062f5da37a58222cbf2419d72c914906fd60b3a9759c2`.
- Verdict: `IMPROVED` — the skull is now a falsifiable, calm inspection object
  with an honest review boundary instead of a hidden catalog entry or a false
  family overlay.
- Blocker: the skull/brain cross-source fit still lacks specialist registration
  review, and Simulator evidence does not prove XCAT or wearer behavior.
- Next safe action: make the default lesson field truly dots-first by clearing
  auto-selection and revealing exactly one local label only after pinch.
