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

## 2026-08-10 03:23 SGT — current Simulator stage regression

- Target: prevent a blank or stale room-scale screenshot from being accepted as
  proof that the patient-file intake and Pressure anatomy are visible.
- Bounded action: added one fresh-install route runner for intake/Pressure and a
  dependency-free PNG verifier; captured both routes from the exact build-16
  app after terminating competing immersive apps.
- Evidence: XCAT deployment stopped at the exact `unavailable` gate in
  `Proof/xcat/20260810-031333/BLOCKED.md`; contract and diff checks passed; a
  synthetic black image failed the verifier; proofs 77 and 78 are 3840×2160,
  show the intended current scenes, retained live PIDs through capture, and have
  SHA-256 values `ceba5848…da4cdc4` and `1a2ce6f6…779595e2`.
- Verdict: `IMPROVED` — the two P0 demo routes are visibly present in the
  deterministic Simulator frame and now have a repeatable blank/stale-proof
  rejection path.
- Blocker: XCAT is unavailable, so room-locked device placement, targetability,
  stereo depth, wearer comfort, AirPlay readability, and clinical validity are
  not proven.
- Next safe action: on an awake and unlocked XCAT, run build 16 once and verify
  that the patient-file archive and Pressure anatomy remain in the primary
  visual field after the sample-once room placement path.

## 2026-08-10 03:48 SGT — distinct Pressure story in registered frame

- Target: GitHub issue #25; make blockage, affected tissue, and constrained
  swelling visibly distinct for both family and doctor-presenter roles without
  loading unregistered prototype-v1 meshes.
- Bounded action: derived one cortical cue anchor from the loaded registered-v2
  brain/clot bounds; added a compact clot pulse, filled amber affected-tissue
  cue, wider dashed mint swelling boundary, two deterministic proof routes, and
  raised the app to `0.6 (17)`.
- Evidence: contract and diff checks passed; XcodeGen and the OS 26.5 visionOS
  Simulator build succeeded; the built app contains 15 unique USDZ files;
  proofs 79 and 80 are 3840×2160, passed the image verifier, and have SHA-256
  values `2935c054…6f07e3` and `872a180a…4bf9b`.
- Verdict: `IMPROVED` — the two roles now share one registered Pressure visual
  grammar while retaining their different timelines and guidance surfaces.
- Blocker: XCAT is `unavailable`; wearer targetability, depth, AirPlay
  readability, comfort, comprehension, specialist review, and clinical
  validity are not proven.
- Next safe action: when XCAT is awake and unlocked, launch build 17, select one
  Pressure point, and verify that clot pulse, amber tissue cue, and mint swelling
  boundary remain attached and distinguishable from front and side views.

## 2026-08-10 04:23 SGT — family Make-space purpose cue

- Target: GitHub issue #28; make the normal family Make-space path visibly
  explain opening and additional room without importing the unregistered
  prototype-v1 flap/patch or simulating surgery.
- Bounded action: added a registered-frame amber aperture, translucent lifted
  protective cover, wider mint room boundary, deterministic proof route, and
  raised the review candidate to `0.6 (18)` / `SC-AIS-001.7`.
- Evidence: contract and diff checks passed; the OS 26.5 Simulator build
  succeeded; the built app contains 15 unique USDZ files; proof 81 is
  3840×2160, passed the image verifier, and has SHA-256
  `96c77c71…1b51e`; source commit is `2293265b…5e5326`.
- Verdict: `IMPROVED` — Make-space now has a visible, reversible mechanical
  purpose cue while the central anatomy, attached points, family questions,
  and top three-act timeline remain present.
- Blocker: XCAT is `unavailable`; wearer targetability, stereo depth, AirPlay
  readability, motion quality, comprehension, specialist review, and clinical
  validity are not proven.
- Next safe action: on an awake and unlocked XCAT, run build 18 and confirm the
  amber aperture, moving protective cover, and mint room boundary remain
  co-located and legible from the default family viewpoint.

## 2026-08-10 04:37 SGT — nonblocking audio preparation

- Target: GitHub issue #31; remove synchronous `AVAudioPlayer` construction and
  preparation from the main actor before the three-minute judged demo.
- Bounded action: introduced one isolated `StrokeAudioPlayback` actor shared by
  the ambient prelude and family-only GPT-Realtime-2.1 narration; moved player
  construction, `prepareToPlay`, play, and stop onto that actor; raised the
  review candidate to `0.6 (19)` in source commit `ffd49c1`.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded; build `0.6 (19)` installed with 15 USDZ resources and
  remained alive as PID 71948 after an eight-second observation window; its
  executable SHA-256 is
  `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`;
  the focused 45-second process query returned `HANG_MATCHES=0` while audio
  preparation ran on a non-main executor. The exact XCAT gate is
  `Proof/xcat/20260810-043035/BLOCKED.md`.
- Verdict: `IMPROVED` — the known blocking preparation path no longer executes
  on the main actor, while the authored prelude and GPT-only narration boundary
  remain unchanged.
- Blocker: the Realtime proxy was not configured for this Simulator pass, XCAT
  is unavailable, and interruption/replay quality on hardware is not proven.
- Next safe action: on an awake XCAT with the existing Realtime proxy configured,
  run one family narration play → pause → resume → exit cycle and retain the
  device log plus wearer-observed continuity result.

## 2026-08-10 05:08 SGT — progressive anatomy comparison

- Target: simplify the doctor-presenter composition while preserving the
  optional high-detail skull and venous references requested for anatomy study.
- Bounded action: gated the separated cross-source skull geometry, status copy,
  and review caption behind Guided/Scholar detail; raised the candidate to
  `0.6 (20)` without changing authored transforms or clinical content.
- Evidence: contract and diff checks passed; the OS 26.5 Simulator Debug build
  succeeded with 15 USDZ resources; clean 3840×2160 Calm and Scholar captures
  are Proof 84 (`b2555f6c…d98`) and Proof 85 (`da8f8046…b0b5`). Two contaminated
  captures were explicitly rejected after a concurrent RBC Journey process was
  detected and terminated. XCAT is exactly `unavailable` in CoreDevice.
- Verdict: `IMPROVED` — Calm now presents one dominant anatomy story, while
  Scholar deliberately reveals the skull/venous comparison and review limits.
- Blocker: Simulator captures do not prove wearer legibility, stereo separation,
  targetability, AirPlay quality, anatomical registration, or clinical validity.
- Next safe action: on an awake and unlocked XCAT, compare Calm and Scholar from
  the default presenter position and record whether the added skull remains a
  clearly optional reference rather than competing with the brain.

## 2026-08-10 05:21 SGT — idle timeline verification

- Target: GitHub issue #30; verify that the case archive/review no longer run
  the display-rate teaching animation loop while preserving active lessons.
- Bounded action: measured six one-second process samples on the archive,
  unfolded review, and active Pressure routes; ran a five-second stack sample;
  compared two active-lesson screenshots eight seconds apart.
- Evidence: archive averaged 8.08% CPU, unfolded review 0.33%, active Pressure
  28.17%; active screenshot hashes differed; the intake main thread waited in
  `mach_msg` for 3,462/3,742 sampled stacks. Full receipt:
  `Proof/performance/20260810-build20-simulator-idle.md`.
- Verdict: `IMPROVED` — the historical 67.3–78.4% idle behavior is not
  reproduced and the active lesson remains animated.
- Blocker: the original benchmark command is absent, XCAT is unavailable, and
  hardware frame pacing, thermals, battery impact, and residual intake cost are
  not proven.
- Next safe action: repeat the archive, review, and Pressure routes with
  Instruments on an awake and unlocked XCAT before closing issue #30.

## 2026-08-10 05:36 SGT — visible venous-atlas attribution

- Target: make the optional clinician venous reference traceable without adding
  another modal, tab, or family-facing burden.
- Bounded action: added one compact app-facing Z-Anatomy + BodyParts3D CC BY-SA
  line and an equivalent accessibility label beneath the existing generic-atlas,
  colour-convention, and review-pending boundary; preserved the bundled full
  third-party notice.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded; its app contains 15 USDZs plus the 1,515-byte notice;
  clean Proof 86 is 3840×2160 with SHA-256 `0fc43e42…6298` and visibly shows the
  attribution in the Scholar anatomy composition.
- Verdict: `IMPROVED` — provenance is now visible at the point of presentation
  and complete in the app bundle, while Calm and family views remain unchanged.
- Blocker: Simulator does not prove wearer legibility, legal sufficiency,
  anatomical registration, specialist approval, or clinical validity; XCAT is
  unavailable.
- Next safe action: on an awake and unlocked XCAT, verify the attribution and
  review boundary remain legible beside the venous reference and record the
  wearer observation separately from the machine receipt.

## 2026-08-10 06:00 SGT — clinician anatomy-focus hierarchy

- Target: make skull/brain/vessel/internal anatomy deliberately selectable
  without bulk-loading the 134-item mixed-frame catalog or adding another
  dashboard.
- Bounded action: added clinician-only Whole, Vessels, and Scholar-only
  Internal focus controls; wired them to the existing registered brain,
  arterial, venous, deep-structure, and ventricular layers; preserved the
  family Whole view, region points, direct viewpoints, detail depth, and
  six-beat timeline.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded as build 21 with exactly 15 USDZs; clean Proof 87 is
  3840×2160 with SHA-256 `10d63ea5…99b5` and visibly shows the red/purple
  vessel focus, four attached points, top timeline, and focus hierarchy. One
  black back-to-back capture was rejected as Simulator scene invalidation.
- Verdict: `IMPROVED` — the presenter can now reveal a coherent subsystem
  rather than stacking every asset or seeing only a skull.
- Blocker: XCAT is unavailable, and Simulator does not prove targeting,
  stereo placement, AirPlay legibility, registration accuracy, specialist
  approval, or clinical validity.
- Next safe action: on an awake and unlocked XCAT, validate gaze-and-pinch
  selection of Whole, Vessels, and Internal while confirming the anatomy points
  remain targetable from the default presenter position.

## 2026-08-10 06:17 SGT — optional anatomy availability fallback

- Target: prevent an optional USDZ load failure from appearing as a selected
  but empty Vessels or Internal anatomy focus.
- Bounded action: connected RealityKit's loaded entity hierarchy to the
  presenter state; queued focus requests until the report arrives; restored
  Whole with an explicit message when either required optional pair is absent;
  added deterministic venous/internal failure routes.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded as `0.6 (22)` with exactly 15 USDZs; Proof 88 is
  3840×2160 with SHA-256 `b6be1411…9935` and visibly shows Whole restored,
  Vessels dimmed, the failure boundary, attached points, and the top timeline.
- Verdict: `IMPROVED` — optional anatomy failure is now explicit and reversible
  instead of producing a misleading empty subsystem.
- Blocker: XCAT is unavailable, and Simulator fault injection does not prove
  physical targeting, stereo placement, wearer legibility, real device load
  behavior, specialist approval, or clinical validity.
- Next safe action: on an awake and unlocked XCAT, select Whole, Vessels, and
  Internal once each and record both the loaded layer and presenter-visible
  boundary before any further anatomy expansion.

## 2026-08-10 06:39 SGT — presenter checkpoints become scene states

- Target: make the six doctor-presenter checkpoints visually distinct instead
  of relabelling the same three-act anatomy composition.
- Bounded action: mapped Access to the separated generic skull reference,
  Protective covering to a permission-gated conceptual-dura offset, Purpose to
  the reversible room-making aperture, Checks to a no-result discussion state,
  and Closure to reassembled teaching layers; added concise beat-specific copy
  and a deterministic Protective-covering proof route.
- Evidence: contract and diff checks passed; the generic OS 26.5 visionOS
  Simulator Debug build succeeded as `0.6 (23)` with exactly 15 USDZs; the
  installed route remained listed after capture; Proof 89 is 3840×2160 with
  SHA-256 `b83cd123…ee7e1` and visibly shows the six-stop timeline, direct
  viewpoints, Guided depth, four attached points, and offset covering state.
- Verdict: `IMPROVED` — the presenter sequence now communicates change through
  anatomy composition rather than copy alone while retaining the family-safe
  three-act boundary.
- Blocker: XCAT is unavailable, Figma MCP is Starter-plan rate-limited, and
  Simulator evidence does not establish targeting, depth, comfort, AirPlay
  legibility, specialist approval, or clinical validity.
- Next safe action: on an awake and unlocked XCAT, traverse all six checkpoints
  once and record whether skull, covering, purpose, and reassembly remain
  spatially distinct and legible in the mirrored three-minute demo.

## 2026-08-10 07:26 SGT — point selection owns its teaching reference

- Target: prevent the Scholar reference lane from becoming a parallel image
  browser that can open without an anatomy point.
- Bounded action: required a selected authored point in both state-level
  teaching-reference entry points, retained the filtered high-priority point
  gesture, and captured the deterministic selected-point composition.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded as `0.6 (25)` with 17 USDZs; the installed process
  remained listed; Proof 91 is 3840×2160 with SHA-256 `b98fb7ab…b6b41f0` and
  visibly shows the six-step timeline, multiple points, one selected disclosure,
  and one right-side registered teaching reference.
- Verdict: `IMPROVED` — the secondary reference is now causally owned by a
  deliberate point choice instead of an independent rail action.
- Blocker: Simulator cannot establish physical gaze-and-pinch reliability,
  stereo depth, wearer comfort, AirPlay legibility, anatomical registration,
  specialist approval, or clinical validity.
- Next safe action: on an awake and unlocked XCAT, pinch one unselected point,
  confirm exactly one reference appears, then change the timeline step and
  confirm the reference clears before the next point choice.

## 2026-08-10 07:37 SGT — one selected point, one teaching lane

- Target: remove the visual competition between a selected point's local
  teaching reference and the checkpoint-level access-skull context.
- Bounded action: made the large access reference conditional on there being no
  selected point, leaving the central anatomy, point state, and checkpoint
  timeline unchanged; captured the same deterministic route again.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded as `0.6 (26)` with 17 USDZs; the installed process
  remained listed; Proof 92 is 3840×2160 with SHA-256
  `c9eac95d…3bf8c3f` and visibly shows one selected disclosure and one right
  affected-vessel reference without the competing separated skull.
- Verdict: `IMPROVED` — point selection now produces one dominant explanatory
  relationship instead of two simultaneous secondary anatomy stories.
- Blocker: XCAT is unavailable, and Simulator cannot establish physical
  gaze-and-pinch reliability, stereo depth, comfort, AirPlay legibility,
  anatomical registration, specialist approval, or clinical validity.
- Next safe action: on an awake and unlocked XCAT, select and clear the same
  point once; verify that one local reference appears on selection and that the
  broader access context returns only after clearing it.

## 2026-08-10 07:58 SGT — selected blockage owns the flow explanation

- Target: make the selected blood-flow point and its annotation tell the same
  story while preserving the always-visible presenter timeline.
- Bounded action: added authored point-specific annotation meanings, corrected
  `Example blockage` to describe an interrupted qualitative route, and recorded
  a short Simulator motion receipt.
- Evidence: contract and diff checks passed; the OS 26.5 visionOS Simulator
  Debug build succeeded as `0.6 (27)` with 17 USDZs; Proof 94 is 3840×2160
  with SHA-256 `299698cf…b6e45a45`; Proof 95 is a six-second 1920×1080 H.264
  clip with SHA-256 `b9c18dff…7419244e`; StrokeTime remained listed.
- Verdict: `IMPROVED` — a selected flow point now produces one concise,
  anatomically relevant explanation and an explicit not-CFD boundary.
- Blocker: XCAT is unavailable, and Simulator motion does not establish
  physical point acquisition, stereo placement, wearer comfort, AirPlay
  legibility, anatomical registration, specialist approval, or clinical
  validity.
- Next safe action: after reviewing Prakash's `a9b64b8` five-asset surgical
  state pack, promote only an applicable clinician-gated registered state and
  bind it to one of the existing six checkpoints; do not bulk-enable the pack
  in the ischemic family path.

## 2026-08-10 10:21 SGT — restore a testable XCAT overview and point acquisition

- Target: replace the stale black launch state with the complete main anatomy
  overview and make anatomy-attached lesson points more reliably selectable on
  the physical headset.
- Bounded action: changed the guarded device route to
  `--proof-main-overview`, enlarged point visuals and non-overlapping collision
  proxies slightly, and added a nearest-visible-point fallback when the larger
  transparent brain proxy receives the pinch first.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed;
  signed visionOS device build `0.6 (29)` succeeded, installed on XCAT,
  foreground-launched, and remained listed as PID 801. Machine receipt:
  `Proof/xcat/20260810-102108/RECEIPT.md`.
- Verdict: `IMPROVED` — XCAT now starts from the bright, complete overview and
  the input path no longer depends solely on the small point collider winning
  ray selection.
- Blocker: the machine receipt cannot prove wearer visibility, gaze-and-pinch
  acquisition, stereo placement, comfort, comprehension, anatomical accuracy,
  or clinical validity.
- Next safe action: while wearing XCAT, gaze at one mint point and pinch once;
  confirm that it enlarges and reveals exactly one right-side teaching
  reference.

## 2026-08-10 11:49 SGT — adaptive craniotomy reference on XCAT

- Target: keep the reversible craniotomy teaching reference legible when the
  presenter changes the explicit visual-detail level.
- Bounded action: retained one registered access assembly across Simplified,
  Standard, and Full, with progressively stronger scalp, bone, and dura
  opacity; kept the optional edema cue restricted to Full clinician detail.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed;
  the generic visionOS Simulator Debug build succeeded; signed XCAT build
  `0.6 (29)` codesign-verified, installed, foreground-launched, and remained
  listed as PID 986. Machine receipt:
  `Proof/xcat/20260810-114913/RECEIPT.md`.
- Verdict: `IMPROVED` — changing explicit visual detail no longer makes the
  access reference disappear, while higher-detail secondary anatomy remains
  gated.
- Blocker: the machine receipt cannot prove wearer visibility, point
  acquisition, stereo registration, comfort, comprehension, or clinical
  correctness.
- Next safe action: on XCAT, enter `Access`, pinch the orange tethered marker,
  then move Visual Detail through Simplified, Standard, and Full and confirm
  that one reversible access reference remains visible throughout.

## 2026-08-10 12:52 SGT — restore the full showcase entry and brain handoff

- Target: stop launching directly into a proof-only brain state and preserve
  the complete role → fictional case → explanation flow for the showcase.
- Bounded action: changed the guarded device route to `--hackathon-demo`,
  removed the procedural case bust while retaining the case-history
  constellation, exposed the existing scale-gated `Enter brain` handoff, and
  kept the revised six-checkpoint timeline, off-surface points, right reference
  rail, and reversible craniotomy composition in the same build.
- Evidence: `python3 Tests/verify_contract.py`, `zsh -n
  Scripts/deploy_xcat.zsh`, `git diff --check`, and the narrow visionOS
  Simulator Debug build passed. Signed Stroke Care `0.6 (29)` codesign-verified
  and installed on paired XCAT; the installed-app query confirmed build 29.
  Foreground activation timed out while waiting for the CoreDevice reply, but a
  subsequent filtered process query confirmed StrokeTime running as PID 1097.
  Machine receipt: `Proof/xcat/20260810-124735/RECEIPT.md`.
- Verdict: `IMPROVED` — the verified binary now contains the complete showcase
  route instead of a brain-only proof route, with a deterministic handoff at
  3.2× scale.
- Blocker: the XCAT machine receipt does not prove wearer visibility, pinch
  acquisition, spatial audio, comfort, cross-app handoff, anatomical accuracy,
  or clinical validity; RBCJourneyVision also lacks a device provisioning
  profile in this checkout.
- Next safe action: with XCAT awake and worn, open Stroke Care manually and
  verify role → case → Access point → timeline → 3.2× `Enter brain` once.

## 2026-08-10 13:41 SGT — stabilize points, vessel close-up, and hand tools

- Target: make every visible teaching point independently selectable and keep
  the clinician cuff/tools correctly oriented during the live demo.
- Bounded action: separated animated lesson orbs from fixed non-overlapping
  collision parents, widened the anatomy-proxy nearest-point fallback, added a
  registered-assembly vessel/clot close-up on selection, bill-boarded the hand
  cuff, and corrected the held-tool forward axis.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed;
  commit `c651201` was pushed to PR #22; signed XCAT build `0.6 (29)` built,
  codesign-verified, installed, and was subsequently listed as PID 1161.
  Machine receipt: `Proof/xcat/20260810-134012/RECEIPT.md`.
- Verdict: `IMPROVED` — point hit geometry no longer pulses into neighbouring
  targets, selecting Flow/Blockage moves the complete registered assembly into
  a close-up, and the hand-attached interface has an explicit wearer-facing
  orientation.
- Blocker: machine evidence cannot prove actual gaze-and-pinch acquisition,
  tool direction, visual clarity, audio perception, comfort, registration, or
  clinical validity on the wearer.
- Next safe action: while wearing XCAT, pinch each visible point once, then open
  Tools and confirm one held instrument points toward the central anatomy.

## 2026-08-10 13:53 SGT — isolate Realtime playback capture

- Target: keep family GPT-Realtime narration compile-clean and isolated after
  the XCAT tunnel gate.
- Bounded action: captured `StrokeAudioPlayback` directly in the narration task
  instead of retaining an unused weak reference to the main-actor narration
  engine.
- Evidence: `python3 Tests/verify_contract.py`, `git diff --check`, and the
  narrow visionOS Simulator Debug build passed. The guarded XCAT pass built and
  codesign-verified Stroke Care `0.6 (29)`, but failed before install with
  CoreDevice error 4, RemotePairing error 4, and Network `NWError 60` (`Operation
  timed out`). No install, launch, or running-process receipt was produced by
  this pass.
- Verdict: `IMPROVED` — the Swift 6 capture warnings are removed while audio
  preparation and playback remain behind the existing actor boundary.
- Blocker: the XCAT tunnel timed out before install; Simulator compilation does
  not prove narration playback, latency, spatial-audio perception, or wearer
  comfort.
- Next safe action: when XCAT is awake, unlocked, and its developer tunnel is
  available, rerun `Scripts/deploy_xcat.zsh` once.

## 2026-08-10 17:55 SGT — separate Simulator and device placement paths

- Target: keep deterministic Simulator launches free of unreachable physical
  tracking work while preserving the authored fallback composition.
- Bounded action: made the stage-placement compile-time branch mutually
  exclusive, so Simulator builds set the authored transform only and physical
  builds retain the one-shot tracked-device placement path.
- Evidence: `python3 Tests/verify_contract.py`, `git diff --check`, and the
  narrow visionOS Simulator Debug build passed without the prior unreachable
  placement-code warning. The guarded XCAT pass stopped at the exact
  `unavailable` device gate and saved
  `Proof/xcat/20260810-175317/BLOCKED.md`.
- Verdict: `IMPROVED` — Simulator and physical placement behavior now compile
  as explicit, non-overlapping paths.
- Blocker: XCAT was unavailable, so this pass produced no install, launch,
  wearer, spatial-audio, registration, or clinical evidence.
- Next safe action: when XCAT is awake and unlocked, rerun
  `Scripts/deploy_xcat.zsh` once.

## 2026-08-11 18:50 SGT — prove the room-scale Inside the Flow handoff

- Target: make the existing `Enter brain` control testable from a large family teaching view without implying entry into a patient's anatomy.
- Bounded action: added `--proof-interior-handoff`, which establishes the family lens, a generic blockage focus, and the existing room-scale threshold before exposing the separate Inside the Flow link.
- Evidence: `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator build completed; `xcrun simctl openurl ... rbcjourney://enter` reached the system confirmation for the installed `Inside the Flow` app.
- Verdict: `IMPROVED` — the cross-experience handoff now has an explicit deterministic source route and the Simulator resolved its registered destination.
- Blocker: the Simulator still retained a prior Clinical evidence window over the requested Stroke Care proof scene, and the confirmation does not prove a wearer pinched `Enter brain` or completed the cross-app launch.
- Next safe action: on an unlocked headset, open the magnified family scene, pinch `Enter brain`, approve the system handoff, and capture the four-beat Inside the Flow entry view.

## 2026-08-11 19:04 SGT — publish a visual README gallery

- Target: make the GitHub repository communicate the complete Stroke Care teaching story at a glance.
- Bounded action: expanded the README gallery with tracked Simulator captures for case intake, point discovery, timeline, flow, internal layers, craniotomy teaching checkpoints, purpose, and the distinct Scholar skull-review state.
- Evidence: `git diff --check` passed and every README `Proof/*.png` gallery reference resolves to a tracked repository file.
- Verdict: `IMPROVED` — the public repository now has a curated visual narrative rather than only an isolated hero image.
- Blocker: these are Simulator and visual-direction images; they do not prove wearer interaction, physical-device legibility, registration accuracy, or clinical validity.
- Next safe action: add one fresh, verified physical-device capture only after a wearer validates the corresponding interaction.

## 2026-08-11 19:19 SGT — guarantee a fresh role-entry surface

- Target: prevent an earlier Clinical evidence window from obscuring a new Family/Doctor journey.
- Bounded action: dismiss the evidence window before both role-threshold entry and the placed-case story entry, with a static contract guard for both paths.
- Evidence: XCAT guarded deploy stopped at `Proof/xcat/20260811-191054/BLOCKED.md` before build/install (`unavailable`, tunnel unavailable, DDI false); `python3 Tests/verify_contract.py` passed and the narrow visionOS Simulator build completed.
- Verdict: `IMPROVED` — a fresh journey no longer intentionally carries the app-owned evidence window forward.
- Blocker: the Simulator currently shows a separate system confirmation left by the prior `Inside the Flow` handoff; it blocks the visual role-threshold capture but is not Stroke Care's Clinical evidence window. XCAT was unavailable, so there is no physical-device validation.
- Next safe action: dismiss the system confirmation, then validate the normal Family/Doctor entry and fresh evidence-return cycle on an unlocked XCAT.

## 2026-08-11 21:11 SGT — add a movable generic 2D imaging reference

- Target: give the clinician a spatially placeable 2D imaging companion without presenting an unreviewed patient scan or calling stroke imaging an X-ray.
- Bounded action: added a clinician-only `Open 2D reference` handoff from the selected-point teaching lens to a standard resizable visionOS window with generic vascular-map and cross-section schematics.
- Evidence: `python3 Tests/verify_contract.py` passed; `xcodegen generate` completed; the narrow visionOS Simulator Debug build completed; the updated app installed and launched with `--proof-imaging-window`.
- Verdict: `IMPROVED` — the existing right-side 3D reference now has a separate movable 2D teaching companion, explicitly labelled generic and not a patient scan.
- Blocker: the Simulator still showed a pending system `Open in Inside the Flow?` confirmation above the proof window, so this pass cannot claim a clean visual capture or wearer placement interaction.
- Next safe action: dismiss that system confirmation, reopen the 2D teaching reference from a selected clinician point, and visually check the card can be placed and read in the room.
