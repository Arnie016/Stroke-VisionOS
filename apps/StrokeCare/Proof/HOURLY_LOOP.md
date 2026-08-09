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

## 2026-08-09 21:25 SGT — integrated dots-first main explanation

- Target: restore the normal brain, vessels, clot target, point cloud, timeline,
  and selected teaching reference after the isolated Scholar-skull proof.
- Bounded action: made region points quietly visible and surface-readable,
  derived a visible focus beacon from the loaded clot bounds, removed automatic
  point selection and duplicate image controls, enlarged the top timeline, and
  made one act-matched registered reference appear only after point selection.
- Evidence: guarded XCAT receipt
  `Proof/xcat/20260809-210457/BLOCKED.md` recorded `unavailable` before any
  physical build; `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the OS 26.5 Simulator
  build ended `** BUILD SUCCEEDED **`; fresh launches returned PIDs 68034 and
  68202; runtime captures are `Proof/56-main-dots-first-overview-simulator.png`
  and `Proof/57-main-selected-point-reference-simulator.png`.
- Verdict: `IMPROVED` — the main scene is visible, dots-first, and causally
  discloses one teaching reference instead of showing only a skull or a label
  cloud.
- Blocker: XCAT remained unavailable, so gaze-and-pinch selection, stereo depth,
  wearer legibility, comfort, comprehension, and clinical validity are unproven.
- Next safe action: on an awake and unlocked XCAT, pinch each of the four region
  points once and record whether its local label and single right reference stay
  registered while orbiting the anatomy.

## 2026-08-09 22:01 SGT — showcase control-agency pass

- Target: make the doctor-worn, mirrored family explanation readable and
  operable for the three-minute table demo.
- Bounded action: increased the unlabeled region-marker visibility, widened the
  three-act timeline, fixed the reparented teaching-reference update path,
  replaced the palm disk with a gaze-sized semicircle and fallback, and kept
  family questions plus a presenter-recorded comfort check in one left field.
- Evidence: guarded receipt `Proof/xcat/20260809-213124/BLOCKED.md` recorded
  paired XCAT as `unavailable`; `python3 Tests/verify_contract.py` returned
  `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the OS 26.5 Simulator
  build ended `** BUILD SUCCEEDED **`; launches returned PIDs 98600, 98741, and
  3425; runtime captures are Proof 58, 59, and 60 with hashes recorded in
  `Proof/BUILD_PROOF.md`.
- Verdict: `IMPROVED` — the main point field and timeline now read immediately,
  clinician tools form an intentional hand arc, and the single-headset family
  conversation has explicit pacing without inferred anxiety.
- Blocker: XCAT remained unavailable, and Simulator cannot prove hand-relative
  reach, AirPlay mirroring, gaze-and-pinch reliability, wearer comfort,
  comprehension, or clinical validity.
- Next safe action: run one awake/unlocked XCAT-to-AirPlay dress rehearsal of
  the three-minute route and record the launch, four point selections, one
  timeline jump, one comfort response, and clean exit.

## 2026-08-09 22:58 SGT — role split, detailed layers, and presenter checklist

- Target: make the entry purpose unambiguous and replace the basic anatomy proof
  with a readable, evidence-backed layered view.
- Bounded action: split launch into **Patient / family** direct anatomy and
  **Doctor presenter** case-led explanation; staged deep structures, ventricles,
  and selected-point authored flow inside the existing registered frame; mapped
  the Page 2 cool-to-warm act colors; and reshaped the left doctor field into a
  vertical presentation checklist.
- Evidence: all three added USDZs passed strict ARKit USD validation; the built
  Simulator app contains exactly thirteen USDZ files; contract and diff checks
  passed; the visionOS Simulator build succeeded; Proof 65–68 and the 4.8-second
  Proof 66b motion receipt have hashes recorded in `Proof/BUILD_PROOF.md`.
- Verdict: `IMPROVED` — the first choice now matches the actual audience model,
  the clinician can inspect named internal layers, the selected vessel story no
  longer summons an unrelated giant skull, and the left cues read as a spatial
  checklist rather than a notes card.
- Blocker: the wider 134-asset catalog is not a license/registration/performance
  clearance, and Simulator cannot establish XCAT interaction or clinical truth.
- Next safe action: on an awake XCAT, run the doctor-presenter route once and
  record four point pinches, one timeline jump, checklist legibility, and Pause
  freezing the authored-flow lesson.

## 2026-08-09 23:32 SGT — case dossier becomes a spatial history web

- Target: replace the retired case-unfold window with one doctor-only spatial
  transition from fictional dossier to case context.
- Bounded action: connected `--proof-case-unfold` to the active immersive case
  review; added a roughly one-second card-to-case reveal, one selected filament
  branch, directly selectable history endpoints, a Reduce Motion final state,
  and an explicit Enter-case threshold; kept patient/family out of the archive.
- Evidence: `STROKE_CARE_CONTRACT=PASS`, clean diff check, successful OS 26.5
  visionOS Simulator build, and `Proof/69-case-history-unfold-simulator.png`
  with SHA-256 recorded in `Proof/BUILD_PROOF.md`.
- Verdict: `IMPROVED` — the dossier now has a spatial handoff and the patient
  history reveals by relationship rather than appearing as four simultaneous
  cards.
- Blocker: the neutral procedural anchor is not a licensed diverse patient
  representation, and Simulator does not prove wearer targeting or comfort.
- Next safe action: enforce the role-specific voice contract: no synthesized
  doctor voice, family-only opt-in Realtime narration, and honest tappable
  question/check-in semantics.

## 2026-08-09 23:49 SGT — role-specific voice and language contract

- Target: prevent synthetic narration from competing with the doctor while
  preserving optional, bounded access support for a patient or family.
- Bounded action: restricted narration to family + enabled + not paused;
  replaced the doctor Voice control with Ambient; made three family questions
  finite tappable pause markers; replaced the comfort proxy with an explicit
  Again/Unsure/Clear clarity check; and made each doctor cue reveal one authored
  plain-language line.
- Evidence: `STROKE_CARE_CONTRACT=PASS`, clean diff check, successful OS 26.5
  visionOS Simulator Debug build, and Proof 70/71 with SHA-256 hashes recorded
  in `Proof/BUILD_PROOF.md`.
- Verdict: `IMPROVED` — the app now distinguishes patient/family narration from
  doctor-led explanation without implying listening, inferred anxiety, or
  generated medical advice.
- Blocker: no live Realtime request was made in this slice, and Simulator does
  not prove audibility, XCAT legibility, AirPlay composition, comprehension, or
  clinical validity.
- Next safe action: on an awake XCAT, verify that switching from Family to
  Doctor immediately stops narration and that one family question plus one
  doctor plain-language expansion remain readable in the mirrored view.

## 2026-08-10 00:13 SGT — pause hidden 60 Hz anatomy work

- Target: stop the static doctor intake and case review from continuously
  updating a hidden high-density anatomy scene.
- Bounded action: paused the display-rate `TimelineView` outside the explanation
  phase and guarded the anatomy update behind the same visible-phase boundary;
  retained the state-driven dossier unfold and active explanation motion.
- Evidence: `STROKE_CARE_CONTRACT=PASS`; clean diff check; OS 26.5 visionOS
  Simulator build ended `** BUILD SUCCEEDED **`; the fixed five-sample intake
  median fell from 27.7% to 7.3% CPU, recorded in
  `Proof/IDLE_CPU_RECEIPT.md`; the case-unfold route still reached its authored
  final state.
- Verdict: `IMPROVED` — the accepted Simulator sample reduced static intake CPU
  by 73.6% without removing the case reveal or the active anatomy cadence.
- Blocker: XCAT is unavailable, RSS did not improve, and Simulator cannot prove
  device thermals, battery, wearer interaction, AirPlay, or clinical validity.
- Next safe action: when XCAT is awake and unlocked, run one doctor intake →
  case unfold → explanation transition while recording launch, pinch response,
  and device frame/thermal evidence.

## 2026-08-10 01:22 SGT — registered clinician anatomy hierarchy

- Target: make the doctor explanation visibly richer without bulk-loading the
  mixed-frame 134-asset catalog or adding another modal dashboard.
- Bounded action: added the same-frame venous atlas to the clinician Regions
  lesson, direct Front/Side/Top and Calm/Guided/Scholar controls, a point-gated
  Scholar reference rail, shipped atlas attribution, and a visible review
  boundary.
- Evidence: `STROKE_CARE_CONTRACT=PASS`; clean diff check; OS 26.5 visionOS
  Simulator build ended `** BUILD SUCCEEDED **`; built app contains exactly 14
  USDZs plus `THIRD_PARTY_NOTICES.txt`; clean proof 72 SHA-256 is
  `5d0c3f443ebb305cc8087fab49f88f658489c02642d6e381309ce38f98c651dd`.
- Verdict: `IMPROVED` — arteries, veins, brain, regional points, direct views,
  top timeline, and the bounded reference hierarchy now read together in one
  spatial composition.
- Blocker: XCAT is unavailable; specialist registration, wearer interaction,
  AirPlay legibility, performance, haptics, comprehension, and clinical
  validity are not proven.
- Next safe action: on an awake XCAT, pinch each of the four region points once
  and verify that exactly one point-local reference appears without the skull
  or Scholar rail stealing focus.

## 2026-08-10 01:57 SGT — role-aware presenter timeline

- Target: turn the supplied six-frame doctor story into revisitable spatial
  checkpoints without complicating the patient/family three-act path.
- Bounded action: added six doctor-presenter checkpoints with direct selection,
  Next/Back traversal, existing consent continuity for beats 3–6, beat-specific
  left cues, and assembled-layer closure; increased the build to `0.6 (13)`.
- Evidence: `STROKE_CARE_CONTRACT=PASS`; clean diff check; OS 26.5 visionOS
  Simulator build ended `** BUILD SUCCEEDED **`; clean proof 73 SHA-256 is
  `32995ff96325f5ec61bfe002ddc829d6f1f0ed48520bcae552f390a6984e667e`.
- Verdict: `IMPROVED` — the doctor can now revisit one of six concise teaching
  checkpoints while the patient/family path keeps the simpler three-act story.
- Blocker: XCAT remained paired but `unavailable`; Figma structured context was
  Starter-plan rate-limited; wearer interaction, AirPlay, comprehension,
  specialist review, and clinical validity are not proven.
- Next safe action: on an awake XCAT, pinch checkpoints 1, 3, 5, and 6 and verify
  direct targeting, the permission/refusal path, assembled closure, and mirrored
  legibility without opening a second control surface.

## 2026-08-10 02:11 SGT — complete direct viewpoint grid

- Target: expose the missing side and underside perspectives without detaching
  any registered anatomy or adding another panel.
- Bounded action: added direct Side B and Bottom model-frame presets, converted
  the existing clinician viewpoint row into a compact two-row grid, added a
  deterministic inferior-view proof route, and increased the build to
  `0.6 (14)`.
- Evidence: XCAT deploy stopped with the dated `unavailable` receipt at
  `Proof/xcat/20260810-020448/BLOCKED.md`; contract and diff checks passed;
  XcodeGen and the OS 26.5 Simulator build succeeded; proof 74 is 3840×2160
  with SHA-256 `38b6abfc025dedea5b742bf73a0848df67f8ba611072c14466ed2044ea6ba9b2`.
- Verdict: `IMPROVED` — all five requested fixed model-frame perspectives are
  now one-pinch choices while the whole authored assembly remains registered.
- Blocker: XCAT is unavailable, and Simulator cannot validate target reach,
  stereo depth, wearer comfort, AirPlay legibility, anatomical orientation, or
  clinical validity.
- Next safe action: when XCAT is awake and unlocked, pinch Side B and Bottom
  once each and verify that brain, vessels, skull reference, and lesson points
  remain attached throughout the transition.

## 2026-08-10 02:40 SGT — selected-point registered flow direction

- Target: make flow direction visible on the detailed registered arterial model
  without loading the mixed-frame 134-asset catalog or presenting CFD.
- Bounded action: added the same-frame Circle-of-Willis flow overlay, kept it
  behind a deliberate Blood-flow point selection, added a visible qualitative /
  not-CFD boundary, regenerated the project, and increased the build to
  `0.6 (15)`.
- Evidence: strict ARKit USD validation passed; contract and diff checks passed;
  the OS 26.5 Simulator build succeeded; the built app contains exactly 15 USDZ
  files; clean proof 75 is 3840×2160 with SHA-256
  `86887fccc6df7f760c306783e535dd6b2a364f6a18104016e2020bce2f6841d8`.
- Verdict: `IMPROVED` — the selected Blood-flow lesson now reveals authored
  same-frame route lines and direction chevrons on the registered artery model.
- Blocker: XCAT is unavailable; Simulator cannot prove motion quality, point
  targeting, stereo depth, AirPlay readability, specialist meaning, or clinical
  validity.
- Next safe action: on an awake XCAT, select the Blood-flow blockage point once
  and verify that the directional overlay remains registered, readable, and
  subordinate to the central anatomy during orbit and viewpoint changes.

## 2026-08-10 03:06 SGT — complete-or-visible anatomy loading

- Target: prevent an incomplete registered head from appearing as a complete
  teaching model when one required USDZ fails to load.
- Bounded action: defined brain, arteries, clot, and dura as the required
  registered-v2 core; added exact OSLog diagnostics, a deterministic five-case
  failure-injection matrix, a complete procedural fallback, and a visible
  simplified-view boundary; increased the build to `0.6 (16)`.
- Evidence: XCAT deploy stopped at the dated `unavailable` receipt
  `Proof/xcat/20260810-030404/BLOCKED.md`; contract and diff checks passed;
  XcodeGen and the OS 26.5 Simulator build succeeded; complete, brain-only,
  missing-artery, missing-clot, and missing-dura launches all remained running;
  each degraded route logged the exact omitted asset; proof 76 SHA-256 is
  `1f1a44305cd82aa5de29a098c28a72d96bedd17930d671f024e8636eaa62dd34`.
- Verdict: `IMPROVED` — a required anatomy failure is now complete and visible,
  never a silently partial registered head.
- Blocker: XCAT is unavailable, so device loading, wearer legibility,
  interaction, AirPlay, specialist registration, and clinical validity remain
  unproven.
- Next safe action: on an awake and unlocked XCAT, launch the normal build-16
  path once and confirm the detailed registered brain, arteries, clot, and dura
  all appear without the simplified-view boundary.
