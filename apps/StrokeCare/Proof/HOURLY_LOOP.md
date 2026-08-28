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

## 2026-08-11 21:35 SGT — verify the current imaging window in Simulator

- Target: replace the blocked imaging-window visual observation with a clean current-build capture.
- Bounded action: restarted the visionOS Simulator, discovered that the first reinstall used stale Stroke Care 0.4 (build 4) from a second DerivedData product, then uninstalled it and installed the verified 0.6 (build 29) product before relaunching `--proof-imaging-window`.
- Evidence: current built `Info.plist` reports build `29`; `xcrun simctl launch` returned PID `28104`; fresh `/tmp/strokecare-imaging-window-current.png` visibly shows the `2D TEACHING REFERENCE` vessel-map window, its Scan-plane control, generic/non-patient boundary, and Close control with no stale handoff alert.
- Verdict: `IMPROVED` — the moveable generic imaging reference is now visually proven in the current Simulator build.
- Blocker: this proves Simulator rendering only; it does not prove a clinician can pinch the selected-point handoff, reposition the window comfortably, or interpret the schematic correctly on physical XCAT.
- Next safe action: on an unlocked XCAT, select a clinician anatomy point, open Imaging, move the 2D reference, and record the interaction separately from clinical review.

## 2026-08-11 21:39 SGT — bind imaging proof to a selected anatomy point

- Target: make the deterministic 2D imaging proof prove the same authored-point provenance used by the clinician experience.
- Bounded action: made `--proof-imaging-window` prepare the existing selected-point teaching state before rendering the 2D reference.
- Evidence: `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build completed; the fresh current-build capture `/tmp/strokecare-imaging-selected-point.png` visibly reads `Linked from: Example affected area` alongside the vessel-map and generic/non-patient boundary.
- Verdict: `IMPROVED` — the proof now establishes point-to-reference provenance rather than showing an unlinked standalone card.
- Blocker: this remains a deterministic Simulator state; it does not prove physical gaze-and-pinch selection, room placement, or clinical adequacy.
- Next safe action: validate the live clinician point -> Imaging action on unlocked XCAT, then capture it as a separate physical interaction receipt.

## 2026-08-11 21:46 SGT — distinguish stroke-imaging teaching references

- Target: make the movable 2D imaging companion use the image language relevant to a stroke explanation without misrepresenting a generic diagram as an X-ray or patient result.
- Bounded action: expanded the reference picker from Vessel map / Scan plane to Vessel map / CT guide / MRI guide, with distinct generic CT-style and MRI-style schematics and an explicit non-patient/non-diagnostic boundary.
- Evidence: `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build completed; fresh `/tmp/strokecare-ct-mri-reference.png` visibly shows the selected-point-linked window and its Vessel map, CT guide, and MRI guide controls.
- Verdict: `IMPROVED` — the 2D reference now better matches the imaging concepts a clinician may explain in an acute stroke conversation while remaining movable and clearly illustrative.
- Blocker: the generic diagrams do not substitute for actual imaging, and this Simulator capture does not prove physical placement, interpretation, or clinical review.
- Next safe action: define a separate, opt-in Brain Health education lane for sleep and cognitive-health topics instead of mixing them into the acute stroke/craniotomy story.

## 2026-08-12 01:55 SGT — stop access dots leaking through presenter checkpoints

- Target: stop the single generic craniotomy invitation from appearing at every later presenter checkpoint as an unrelated skull marker.
- Bounded action: made presenter point visibility checkpoint-owned: Context shows the regional discovery family, Access shows the single generic access invitation, and Protective covering / Purpose / Checks / Closure hide point cues until reviewed point families exist for those discussions.
- Evidence: `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build completed. A fresh `--proof-clinician-six-beat-timeline` screenshot reached only the room and did not open the immersive scene, so it is not visual evidence for this change.
- Verdict: `IMPROVED` — later clinician checkpoints no longer intentionally inherit the same access point in runtime state.
- Blocker: a fresh Simulator immersive-route receipt is still required; additional point families need authored, reviewed anchors rather than reusing a skull location.
- Next safe action: repair the six-beat deterministic immersive proof route, then inspect Context, Access, and Checks as separate visual states.

## 2026-08-12 02:06 SGT — verify delayed six-beat immersive composition

- Target: determine whether the current six-beat presenter route is actually empty in Simulator before using its screenshot as product evidence.
- Bounded action: restarted the verified `0.6 (29)` Simulator app with `--proof-clinician-six-beat-timeline`, then compared an 8-second screenshot with a later settled capture.
- Evidence: the 8-second capture showed only the room; the fresh 53-second capture at `/tmp/strokecare-six-beat-53s.png` visibly shows the registered brain and arteries, presenter checklist, timeline, and peripheral controls. The running process remained `StrokeTime` PID `83246`.
- Verdict: `IMPROVED` — the scene is present after its large asset load; the prior empty room was an early-capture artefact, not proof that the six-beat state renders no anatomy.
- Blocker: this exposes an unacceptable proof/loading latency and remains Simulator composition evidence only, not physical-device responsiveness, targetability, or clinical review.
- Next safe action: add an explicit scene-readiness receipt/visual loading boundary before treating any timed immersive screenshot as a valid regression proof.

## 2026-08-12 02:44 SGT — add a spatial Family Brain Atlas

- Target: give the patient/family route a larger, self-paced neuroanatomy guide without turning the central brain into a permanent label cloud or presenting generic anatomy as a patient scan.
- Bounded action: added an opt-in room-anchored ten-chapter Brain Atlas with pinch-drag navigation; each chapter changes only the closest reviewed discovery-point family on the existing 3D brain and explicitly routes deep concepts to the separate inside-brain handoff after magnification.
- Evidence: `python3 Tests/verify_contract.py` passed; `xcodegen generate` plus the narrow visionOS Simulator Debug build succeeded; fresh deterministic `--proof-family-brain-atlas` capture at `/tmp/strokecare-family-brain-atlas.png` visibly shows the large left Atlas (Arterial routes, 6/10), central 3D brain/arteries, quiet flow points, and family controls.
- Verdict: `IMPROVED` — family learning now has a progressive, spatially placed anatomy guide rather than only static questions or a flat vessel reference.
- Blocker: the ten chapters are orientation content; only the current reviewed whole-brain and blood-flow layers are locally shown. Exact deep-structure landmark anchoring, patient comprehension, and physical-device pinch-drag comfort need separate review.
- Next safe action: validate the Family Atlas interaction and its inside-brain handoff on a physical Vision Pro before adding another anatomy subsystem.

## 2026-08-12 03:00 SGT — stage the immersive anatomy before heavy assets

- Target: prevent a blank-looking immersive room while the detailed brain assets decode.
- Bounded action: presented the compact local anatomy immediately, then swapped it for the complete imported anatomy root after it finished loading.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-024606/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` captures at `/tmp/strokecare-readiness-split-4s.png` and `/tmp/strokecare-readiness-split-50s.png` show immediate fallback anatomy followed by the detailed brain-and-artery assembly.
- Verdict: `IMPROVED` — the experience no longer begins as an empty immersive room during the large-asset handoff.
- Blocker: XCAT was unavailable, and Simulator captures do not prove physical-device load timing, wearer comfort, or gesture quality.
- Next safe action: validate the staged anatomy handoff on an unlocked physical Vision Pro before changing another interaction.

## 2026-08-12 03:10 SGT — make the Family Brain Atlas progressively explorable

- Target: let a patient/family member move through each general brain concept at a comfortable pace instead of receiving a single dense text block.
- Bounded action: expanded each Atlas chapter into three pinch-through beats — spatial location, plain-language purpose, and a clinician-conversation prompt — while keeping pinch-drag for moving between the ten concepts and retaining the generic-teaching/not-a-patient-scan boundary.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-031011/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded; fresh deterministic `--proof-family-brain-atlas` capture at `/tmp/strokecare-family-atlas-three-beat.png` visibly shows `Arterial routes`, `WHAT IT HELPS WITH · 2 / 3`, the enlarged left card, and the central 3D brain/artery assembly.
- Verdict: `IMPROVED` — the family route now supports a spatial, user-paced three-beat explanation without adding a permanent label cloud to the anatomy.
- Blocker: this is Simulator rendering only; XCAT is unavailable, and physical pinch-drag legibility plus clinical review remain unproven.
- Next safe action: validate one complete Atlas chapter on an unlocked physical Vision Pro before adding further anatomy content.

## 2026-08-12 03:22 SGT — verify the Family point-to-spatial-reference path

- Target: ensure that the patient/family route—not only the clinician route—can reveal one selected anatomy point with a spatial teaching reference and clear question controls.
- Bounded action: added a deterministic Family selected-point route that selects one generic affected-area cue during the existing Pressure act and exposes the existing world-locked vessel teaching object.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-032143/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-selected-point` capture at `/tmp/strokecare-family-selected-point.png` visibly shows one selected local cue, the left Family question/clarity surface, and the right `BLOCKED VESSEL · TEACHING VIEW` object with its generic-anatomy boundary.
- Verdict: `IMPROVED` — the Family explainer now has a repeatable, screenshot-inspected receipt for the intended one-point → one-spatial-reference interaction.
- Blocker: Simulator composition does not prove physical gaze-and-pinch targetability, room-scale legibility, or clinical adequacy; XCAT remains unavailable.
- Next safe action: validate the Family selected-point interaction on an unlocked physical Vision Pro before increasing the reference catalogue.

## 2026-08-12 04:05 SGT — make the inside-brain handoff discoverable at room scale

- Target: make the separate guided blood-vessel journey discoverable once a Family wearer has magnified the generic brain model to the explicit interior threshold.
- Bounded action: replaced the tiny generic hand-control bubble with a clearly labelled orange `ENTER THE BRAIN · Guided vessel journey` control that appears only at room-scale magnification and keeps the separate-app handoff explicit.
- Evidence: `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded; fresh deterministic `--proof-interior-handoff` capture at `/tmp/strokecare-interior-handoff-prominent.png` visibly shows the enlarged orange hand-adjacent entry control alongside the room-scale brain. `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-040523/BLOCKED.md`.
- Verdict: `IMPROVED` — the next experience is now visually discoverable rather than buried as an unlabeled small control.
- Blocker: the paired internal journey must be installed and launched on physical hardware; this Simulator capture does not prove cross-app launch, wearer targeting, comfort, or comprehension.
- Next safe action: install the paired interior app on an unlocked Vision Pro and record a user-selected handoff receipt.

## 2026-08-12 04:22 SGT — enlarge the Family Brain Atlas without flattening the anatomy story

- Target: make the Family learning surface legible in the spatial room while retaining the 3D brain and vessels as the primary teaching object.
- Bounded action: widened the ten-chapter, pinch-drag Brain Atlas by about 20%, increased its chapter target size, and replaced the faint material card with a black-translucent high-contrast surface; corrected its room placement after the first wider capture clipped at the display edge.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-041010/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` capture at `/tmp/strokecare-family-brain-atlas-contrast-final.png` visibly shows a complete, readable left Atlas (`Arterial routes`, `2 / 3`) alongside the unoccluded 3D brain and arteries.
- Verdict: `IMPROVED` — the family member can now read and pinch through the ten-part Atlas without a flat full-screen vessel map or a permanent annotation cloud around the anatomy.
- Blocker: this is generic educational anatomy only. Clinical review is needed before adding more specific physiology claims, and XCAT remains unavailable for real-world legibility and pinch-drag verification.
- Next safe action: validate the corrected Family Atlas on an unlocked Vision Pro before adding another family teaching subsystem.

## 2026-08-12 04:48 SGT — connect the arterial Atlas chapter to one 3D flow reference

- Target: keep the Family arterial lesson spatial instead of leaving its vessel cue as a text-led point-family switch.
- Bounded action: changed the Arterial routes Atlas action to `SHOW BRANCHING FLOW IN 3D`; one deliberate pinch now selects the generic branching-flow point, moves the registered teaching assembly into its existing close-up state, and reveals exactly one local qualitative vessel reference.
- Evidence: `Scripts/deploy_xcat.zsh` had already recorded XCAT unavailable in `Proof/xcat/20260812-041010/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a fresh isolated-DerivedData Simulator bundle launched `--proof-family-arterial-atlas-flow` as process `44214`; inspected capture `/tmp/strokecare-family-arterial-atlas-flow.png` visibly shows the `Arterial routes` Atlas, `SHOW BRANCHING FLOW IN 3D`, one `ARTERIES BRANCH` local cue, and the `VESSEL STORY` reference alongside the 3D brain and arteries.
- Verdict: `IMPROVED` — the vessel chapter now has an explicit user-selected spatial flow reveal rather than a flat map or permanent label cloud.
- Blocker: this is qualitative, generic teaching anatomy only; Simulator proof does not establish physical gaze-and-pinch targeting, motion legibility, or clinical adequacy, and XCAT remains unavailable.
- Next safe action: validate the selected Family arterial-flow interaction on an unlocked Vision Pro before adding more physiology references.

## 2026-08-12 05:31 SGT — separate the 3D vessel reference from the hero anatomy

- Target: make the selected arterial teaching reference read as a second spatial object rather than a flattened overlay competing with the central brain.
- Bounded action: moved the world-locked registered vessel miniature into the right secondary field and shifted/enlarged its associated readable disclosure without changing the generic-teaching, one-selected-point contract.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-045046/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a fresh isolated-DerivedData Simulator bundle launched `--proof-family-arterial-atlas-flow` as process `68477`; inspected capture `/tmp/strokecare-secondary-reference-balanced.png` visibly shows the complete right-side 3D vessel object and its readable reference capsule, separate from the dominant centre brain.
- Verdict: `IMPROVED` — the Family arterial lesson now uses primary/secondary spatial depth instead of visually stacking its reference on the anatomy.
- Blocker: Simulator framing does not prove headset depth perception, peripheral legibility, room placement, or physical gaze-and-pinch; XCAT remains unavailable.
- Next safe action: validate this primary/secondary composition on an unlocked Vision Pro before adding another teaching reference.

## 2026-08-12 10:45 SGT — enlarge the presenter timeline targets

- Target: make all six clinician checkpoints—including the former hard-to-acquire middle steps—easy to revisit in the lower spatial field.
- Bounded action: increased each six-step timeline target from 76 to 92 points, enlarged the visible numbered markers, and strengthened the active cool-to-warm story band while retaining hover/focus wording above the timeline.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-095628/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded; fresh deterministic `--proof-clinician-six-beat-timeline` capture at `/tmp/strokecare-timeline-after.png` visibly shows the enlarged six-node lower timeline, with step 5 active and the centre anatomy unobscured.
- Verdict: `IMPROVED` — the six checkpoints now have materially larger direct gaze-and-pinch affordances without turning the explanation into a text-heavy panel.
- Blocker: Simulator capture does not prove physical gaze-and-pinch acquisition, wearer legibility, or clinical adequacy; XCAT remains unavailable.
- Next safe action: validate all six timeline targets on an unlocked Vision Pro before introducing additional clinician controls.

## 2026-08-12 16:53 SGT — connect Family Atlas chapters to visible 3D cues

- Target: ensure the ten-part Family Brain Atlas teaches through the central spatial anatomy rather than behaving like a flat vessel map or a generic point-family switch.
- Bounded action: mapped each reviewed outer-brain Atlas chapter to one deliberate lifted regional cue, kept Arterial routes on its qualitative 3D flow cue, and made deep chapters surface the explicit magnify-to-inside-brain handoff instead of implying unreviewed internal landmark registration.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-104942/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow isolated-DerivedData visionOS Simulator build produced `StrokeTime.app`; fresh deterministic `--proof-family-atlas-surface-cue` capture at `/tmp/strokecare-family-atlas-surface-cue.png` was inspected and visibly shows the `Frontal lobe` Atlas chapter, one tethered `FRONTAL LOBE · GENERIC ATLAS CUE`, the central 3D brain and arteries, and no permanent label cloud.
- Verdict: `IMPROVED` — a Family chapter now produces a clear 3D anatomy-attached reveal, while the inside-brain transition remains an honest separate-experience handoff.
- Blocker: Simulator composition does not prove physical gaze-and-pinch acquisition, room-scale depth, the paired-app launch, or clinical adequacy; XCAT was unavailable.
- Next safe action: validate one Family Atlas surface cue and one magnify-to-inside-brain handoff on an unlocked Vision Pro before adding another anatomy subsystem.

## 2026-08-12 17:05 SGT — keep Family Atlas surface cues spatially coherent

- Target: prevent a selected outer-brain Atlas chapter from reading as a detached HUD label or opening an unrelated vessel reference.
- Bounded action: parented the selected-point explanation to its actual anatomy point field and made surface chapters suppress the secondary vessel miniature, reserving that object for the arterial-flow chapter.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-165447/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow isolated-DerivedData visionOS Simulator build produced `StrokeTime.app`; fresh deterministic `--proof-family-atlas-surface-cue` capture at `/private/tmp/strokecare-family-atlas-surface-final.png` was inspected and visibly shows the `Frontal lobe` Atlas, central 3D brain/arteries, one local `FRONTAL LOBE · GENERIC ATLAS CUE`, and no right-side vessel reference.
- Verdict: `IMPROVED` — outer-brain chapters now have one deliberate spatial reveal instead of a competing 2D-like reference surface.
- Blocker: Simulator rendering does not prove physical gaze-and-pinch targetability, stereo depth, or family comprehension; XCAT was unavailable.
- Next safe action: validate the one-cue Family Atlas behavior on an unlocked Vision Pro before adding more reviewed teaching references.

## 2026-08-12 17:22 SGT — add a non-sticky evidence-workspace recovery path

- Target: prevent a stale Clinical evidence workspace from trapping the wearer away from the Patient or Doctor role threshold.
- Bounded action: added an explicit `Restart at roles` control that resets teaching state, closes the immersive/evidence spaces, and restores the launch window; system dismissal now also clears the temporary source-bound draft state.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-170613/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a fresh visionOS Simulator app bundle installed and launched `--proof-evidence-window` as process `73756`; inspected capture `/tmp/strokecare-evidence-recovery-20260812-1721.png` visibly shows both `Return to anatomy` and `Restart at roles` recovery controls in the evidence workspace.
- Verdict: `IMPROVED` — the evidence space now has a visible, state-resetting escape route rather than relying solely on the normal anatomy return.
- Blocker: the Simulator screenshot proves rendering and process launch only; it does not prove physical pinch acquisition or XCAT recovery behavior while the device is unavailable.
- Next safe action: tap `Restart at roles` on an unlocked Vision Pro and record the resulting role-threshold recovery receipt.

## 2026-08-12 17:31 SGT — make the Family Brain Atlas explanation rhythm explicit

- Target: help a family member understand that each of the ten generic brain chapters is a short, spatially connected learning sequence rather than a dense static card.
- Bounded action: added a compact, visible `1 POSITION → 2 MEANING → 3 ASK` progression to the existing pinch-controlled Atlas card; the active beat follows the current three explanatory states while the central 3D brain and one optional model cue remain primary.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-172435/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` capture at `/tmp/strokecare-family-atlas-beats.png` was inspected and visibly shows the ten-chapter `Arterial routes` Atlas, highlighted `2 MEANING` beat, the central 3D brain/arteries, and qualitative flow points.
- Verdict: `IMPROVED` — the Family Atlas now clearly communicates its controlled three-beat learning rhythm without converting the model into a 2D vessel map or adding diagnostic detail.
- Blocker: Simulator proof does not establish pinch-drag reach, headset legibility, family comprehension, or clinical accuracy; XCAT remains unavailable.
- Next safe action: run one family member through one full Atlas chapter on an unlocked Vision Pro and record whether the three beats and 3D cue are understandable.

## 2026-08-12 17:36 SGT — enlarge the Family Atlas reading surface

- Target: make the one-chapter-at-a-time family explanation readable as a peripheral spatial surface without letting it overtake the 3D anatomy.
- Bounded action: increased the Atlas attachment scale from `0.90` to `1.02`, shifted it inward to avoid left-edge clipping, and simplified the active-beat caption to `2 OF 3 · WHAT IT HELPS WITH`.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-173254/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` capture at `/tmp/strokecare-family-atlas-legibility.png` was inspected and visibly shows the widened Atlas, the `POSITION → MEANING → ASK` rhythm, and active `2 OF 3` explanation beside the spatial teaching model.
- Verdict: `IMPROVED` — the family explanation is more legible and self-guiding without becoming a full-screen 2D vessel map.
- Blocker: Simulator evidence cannot establish headset legibility, physical pinch-drag reach, or family comprehension; XCAT remains unavailable.
- Next safe action: validate this enlarged Atlas on an unlocked Vision Pro with one non-clinician wearer before increasing its content density.

## 2026-08-12 17:46 SGT — make the Family Atlas 3D handoff explicit

- Target: make it clear that an Atlas chapter can reveal one real, anatomy-attached teaching cue rather than only changing text in a peripheral card.
- Bounded action: changed the Atlas action from a passive cue label to an explicit `REVEAL IN 3D` control; after a deliberate reveal it changes to `3D CUE ACTIVE · LOOK FOR ONE LIT MARKER`, with a distinct confirmation colour and no permanent label cloud.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-174042/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; fresh deterministic `--proof-family-arterial-atlas-flow` capture at `/tmp/strokecare-family-atlas-cue-active-20260812-1745.png` was inspected and visibly shows the active 3D cue confirmation, one anatomy-attached `ARTERIES BRANCH` explanation, and one contextual teaching reference.
- Verdict: `IMPROVED` — the Atlas now makes its spatial reveal and current selection legible without presenting a patient-specific vessel map or overwhelming the central model.
- Blocker: Simulator evidence does not establish physical gaze-and-pinch reach, stereo depth, or comprehension; XCAT remains unavailable.
- Next safe action: validate one Atlas reveal-to-marker interaction with a non-clinician wearer on an unlocked Vision Pro before adding any new chapters or references.

## 2026-08-12 17:54 SGT — bind each Family Atlas cue to its own chapter

- Target: stop a previously revealed 3D marker from appearing to belong to the next brain-structure chapter after a family member swipes through the Atlas.
- Bounded action: added explicit cue-to-chapter state; a chapter transition now clears the Atlas cue confirmation, presents the new chapter's quiet markers, and invites a fresh deliberate reveal. Added a deterministic next-chapter proof route.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-174042/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-atlas-next-chapter` capture at `/tmp/strokecare-family-atlas-next-chapter-20260812-1753.png` was inspected and visibly shows `Corpus callosum`, `REVEAL IN 3D · OPEN INSIDE-BRAIN JOURNEY`, and a central brain with quiet new markers, not the old active artery cue.
- Verdict: `IMPROVED` — the Atlas now preserves a one-chapter, one-deliberate-cue spatial learning model rather than leaving stale spatial context across chapters.
- Blocker: Simulator does not establish physical gaze-and-pinch targeting, depth, or family comprehension; XCAT remains unavailable.
- Next safe action: run the chapter-swipe then cue-reveal sequence with a non-clinician wearer on an unlocked Vision Pro before expanding the Atlas beyond its reviewed ten structures.

## 2026-08-12 19:43 SGT — make the deep-structure room-scale handoff discoverable

- Target: help a family member who has chosen a deep Atlas structure understand what to do after the existing room-scale magnification threshold is reached.
- Bounded action: added a deep-chapter-only `ROOM SCALE READY · USE ENTER THE BRAIN BELOW` confirmation inside the Atlas and a deterministic proof route for the Corpus callosum handoff; the existing `ENTER THE BRAIN` control still opens the separately installed guided vessel journey.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-182723/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded. The first immediate screenshot was black and was rejected as insufficient; a fresh settled capture at `/tmp/strokecare-family-atlas-interior-ready-retry-20260812-1834.png` was inspected and visibly shows room-scale generic brain anatomy, the `Corpus callosum` Atlas, `ROOM SCALE READY`, and the orange `ENTER THE BRAIN` family control.
- Verdict: `IMPROVED` — deep Atlas chapters now state the room-scale transition explicitly instead of requiring the wearer to discover the separate journey control unaided.
- Blocker: Simulator does not prove cross-app handoff success, physical control reach, stereo depth, or wearer comprehension; XCAT remains unavailable and the paired guided journey must be installed separately.
- Next safe action: install both experiences on an unlocked Vision Pro and verify one deliberate `Enter the Brain` handoff end-to-end before describing the journey as device-ready.

## 2026-08-12 20:01 SGT — inspect a recoverable inside-brain handoff cue

- Target: make the `ENTER THE BRAIN` companion-app handoff recoverable if the separate journey is not installed.
- Bounded action: tested a small visible fallback cue after the handoff request, then rejected and reverted it when it did not render in the room-scale Simulator proof.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-194550/BLOCKED.md`; `python3 Tests/verify_contract.py` passed and a narrow visionOS Simulator Debug build succeeded during the attempted change; fresh `--proof-interior-handoff --proof-interior-handoff-notice` capture at `/tmp/strokecare-interior-handoff-clean-20260812-2001.png` was inspected and shows no readable fallback cue.
- Verdict: `NEUTRAL` — no unverified recovery UI was shipped; the existing separately installed journey control is unchanged.
- Blocker: the current room-scale composition can leave the control/cue outside the captured field, and Simulator cannot establish companion-app launch or wearer legibility; XCAT remains unavailable.
- Next safe action: redesign the handoff as an anatomy-attached, in-field cue and test it on an unlocked Vision Pro with both applications installed.

## 2026-08-12 21:56 SGT — strengthen Family Atlas room contrast

- Target: keep the family Brain Atlas readable over a real room without turning the explainer into a large flat vessel map or competing with the central 3D anatomy.
- Bounded action: raised only the existing Atlas backing opacity from `0.56` to `0.72`; its one-chapter swipe rhythm, single selected 3D cue, and peripheral attachment placement are unchanged.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-214831/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` capture at `/tmp/strokecare-atlas-contrast-20260812-2156.png` was inspected and visibly shows a clearer `Arterial routes` three-beat Atlas beside the central 3D brain, arteries, and qualitative flow cues.
- Verdict: `IMPROVED` — the family explanation has better environmental contrast while the live 3D model remains dominant.
- Blocker: Simulator does not prove headset legibility, physical pinch-drag reach, room lighting performance, or family comprehension; XCAT remains unavailable.
- Next safe action: test the Atlas in a bright physical room with a non-clinician wearer on an unlocked Vision Pro before changing its content density or adding unreviewed topics.

## 2026-08-12 22:04 SGT — make the Family Atlas explanation target explicit

- Target: make the family Atlas’s three short explanations easy to discover and pinch without adding a new panel or reducing the central 3D model to a diagram.
- Bounded action: turned the existing central chapter card into a bordered `150`-point minimum pinch target with a visible `PINCH FOR THE NEXT SHORT EXPLANATION` affordance; chapter arrows, pinch-drag chapter navigation, and the separate `REVEAL IN 3D` action remain distinct.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-220014/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` capture at `/tmp/strokecare-atlas-pinch-target-20260812-2204.png` was inspected and visibly shows the enlarged central pinch target, one-chapter Atlas, central brain/arteries, and qualitative flow cues.
- Verdict: `IMPROVED` — the wearer now has one unambiguous target for progressing the explanation while spatial discovery remains a deliberate separate action.
- Blocker: Simulator does not establish physical gaze-and-pinch reliability, reach, stereo legibility, or family comprehension; XCAT remains unavailable.
- Next safe action: validate the card’s target size and swipe-versus-pinch distinction with a non-clinician wearer on an unlocked Vision Pro before adding further Atlas interactions.

## 2026-08-12 22:20 SGT — enlarge fixed clinician timeline targets

- Target: make all six presenter checkpoints easier to gaze-and-pinch at room scale without shifting their locations when a step becomes active.
- Bounded action: enlarged each fixed target field from `92` to `108` points and its visible disc from `56` to `64` points; contextual wording still appears only initially or on hover and then fades.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-220727/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-clinician-six-beat-timeline` capture at `/tmp/strokecare-presenter-timeline-target-20260812-2220.png` was inspected and visibly shows six spaced fixed targets with the active step marked.
- Verdict: `IMPROVED` — the six-step teaching timeline is more legible and has larger stable acquisition fields without becoming a permanent label wall.
- Blocker: Simulator cannot establish physical gaze-and-pinch reliability, reach, stereo legibility, or clinician workflow fit; XCAT is unavailable.
- Next safe action: validate all six targets on an unlocked Vision Pro with a clinician presenter before changing timeline content or adding more controls.

## 2026-08-12 22:30 SGT — enlarge the browsable Family Brain Atlas

- Target: make the family-side, ten-chapter brain-structure explanation more readable while retaining the central 3D anatomy as the spatial hero.
- Bounded action: widened the optional Atlas attachment from `640` to `720` points and raised its attached reading scale from `1.02` to `1.10`; its existing one-chapter pinch/drag navigation, three short Position → Meaning → Ask beats, and one-at-a-time 3D cue remain unchanged.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-221932/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-brain-atlas` capture at `/tmp/strokecare-atlas-enlarged-20260812-2230.png` was inspected and visibly shows the wider Arterial routes explanation beside the central 3D brain, arteries, and discrete flow cues.
- Verdict: `IMPROVED` — the browsing explanation is more legible without replacing the anatomy with a flat vessel map.
- Blocker: Simulator cannot establish headset text legibility, physical pinch-drag reliability, reach, family comprehension, or clinical correctness; XCAT is unavailable.
- Next safe action: validate the widened Atlas with a non-clinician wearer on an unlocked Vision Pro before adding any new medical topics or disclosures.

## 2026-08-12 22:40 SGT — separate the selected-point callout from anatomy detail

- Target: preserve a selected point’s local spatial explanation without allowing its wording to overlap the central 3D brain.
- Bounded action: moved the point-owned callout outward from `[0.034, 0.026, 0.016]` to `[0.064, 0.052, 0.032]` relative to its selected point and added a compact dark callout backing; the explanation remains parented to the selected point field and the registered vessel reference remains world-locked in the secondary right field.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-222921/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-selected-point` capture at `/tmp/strokecare-family-selected-point-callout-20260812-2240.png` was inspected and visibly shows the `EXAMPLE AFFECTED AREA` callout clearing the brain silhouette, with its generic/non-measured boundary and one separate vessel teaching reference.
- Verdict: `IMPROVED` — selected-point content is now a readable spatial callout rather than text competing with the anatomy surface.
- Blocker: Simulator cannot establish physical gaze-and-pinch targetability, stereo depth, wearer legibility, or clinical correctness; XCAT is unavailable.
- Next safe action: test the point-to-callout and point-to-reference relationship on an unlocked Vision Pro before adding more reference types.

## 2026-08-12 22:50 SGT — bring the selected vessel reference into the right reading field

- Target: make the selected-point vessel teaching object feel like a legible second 3D object rather than a small model lost in room furniture.
- Bounded action: moved the world-locked registered vessel miniature from `[0.50, 1.62, -0.86]` to `[0.40, 1.60, -0.80]` and increased its scale from `0.90` to `1.04`; it remains separate from the hero anatomy and is still not presented as patient imaging.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-223846/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-selected-point` capture at `/tmp/strokecare-family-reference-field-20260812-2250.png` was inspected and visibly shows the enlarged world-locked vessel reference inside the right reading field with the point provenance/generic-teaching caption.
- Verdict: `IMPROVED` — the reference reads as a deliberate secondary spatial object while the central brain remains dominant.
- Blocker: Simulator does not prove headset depth, physical reach, point targeting, wearer legibility, or clinical correctness; XCAT is unavailable.
- Next safe action: validate relative hero/reference depth and reach on an unlocked Vision Pro before adding further objects to the secondary field.

## 2026-08-12 22:51 SGT — enlarge shared Family clarification cues

- Target: make the authored Questions to Ask and explicit self-reported clarity cue readable during a shared family conversation without creating a patient-monitoring surface.
- Bounded action: widened the Family clarification attachment from `360` to `430` points and raised its attached scale from `0.72` to `0.86`; the central 3D brain, finite authored questions, and explicit self-reported wording remain unchanged.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-224337/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-clarity` capture at `/tmp/strokecare-family-clarity-enlarged-20260812-2310.png` was inspected and visibly shows the larger questions and clarity surface beside the central brain and anatomy-attached points.
- Verdict: `IMPROVED` — shared family prompts are more legible while the spatial anatomy remains the hero and clarity stays explicitly self-reported.
- Blocker: Simulator does not establish headset legibility, physical reach, pinch reliability, family comprehension, or clinical correctness; XCAT remains unavailable.
- Next safe action: validate the enlarged family clarification surface with a non-clinician wearer on an unlocked Vision Pro before changing its content.

## 2026-08-12 22:56 SGT — remove the detached pressure ring from the Family explainer

- Target: stop the peripheral radial pressure-boundary graphic from competing with family-facing brain anatomy and being mistaken for a data visualisation.
- Bounded action: restricted the fixed-space boundary ring to clinician lessons; the Family explainer retains its central brain, arteries, quiet anatomy-attached discovery points, and one local explanation path.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-225313/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-clarity` capture at `/tmp/strokecare-family-clarity-no-boundary-20260812-2256.png` was inspected and visibly shows the radial ring absent while the family questions and 3D anatomy remain.
- Verdict: `IMPROVED` — the family scene now reads as a calm spatial anatomy explanation rather than a graph around the brain.
- Blocker: Simulator cannot establish wearer legibility, physical targetability, room placement, or family comprehension; XCAT remains unavailable.
- Next safe action: validate the cleaner Family composition with a non-clinician wearer on an unlocked Vision Pro before adjusting any remaining clinician-only cues.

## 2026-08-13 00:28 SGT — keep the technical Pressure boundary out of Family mode

- Target: remove the second detached radial graphic around the Family Pressure teaching view while preserving the direct clot-derived target.
- Bounded action: restricted the registered Pressure story’s affected-area disc and dashed swelling boundary to clinician mode; the Family explainer continues to show the direct clot target, brain, arteries, quiet point prompts, and one selected local explanation.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260812-235933/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded; fresh `--proof-family-clarity` capture at `/tmp/strokecare-family-pressure-direct-target-20260813-0003.png` was inspected and visibly shows the radial cue absent with the point-owned targets retained.
- Verdict: `IMPROVED` — Family Pressure now reads as an anchored anatomy lesson rather than an unexplained data graphic.
- Blocker: Simulator cannot prove headset legibility, physical pinch reliability, depth judgement, family comprehension, or clinical correctness; XCAT remains unavailable.
- Next safe action: validate the Family Pressure composition with a non-clinician wearer on an unlocked Vision Pro before revising any additional Family teaching cues.

## 2026-08-13 00:33 SGT — strengthen the central Family anatomy hero

- Target: use the primary spatial field more intentionally so the 3D brain and arterial anatomy read as the shared explanation’s hero rather than a small object in an otherwise empty room.
- Bounded action: raised the explanation scale from `2.12` to `2.34` and the Orient scale from `1.98` to `2.18`, preserving the world-locked secondary reference, left family conversation surface, and lower controls.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-003000/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the default DerivedData build was blocked by an existing build database lock, then the same narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-primary-scale`; fresh `--proof-family-clarity` capture at `/tmp/strokecare-family-hero-scale-20260813-0033.png` was inspected and visibly shows the enlarged central anatomy clear of the Family questions and controls.
- Verdict: `IMPROVED` — the shared anatomy has stronger room-scale presence while peripheral surfaces remain secondary.
- Blocker: Simulator cannot prove actual headset scale comfort, reach, physical pinch reliability, room placement, family comprehension, or clinical correctness; XCAT remains unavailable.
- Next safe action: validate the enlarged hero scale with a non-clinician wearer on an unlocked Vision Pro before further resizing or adding new Family content.

## 2026-08-13 08:59 SGT — inspect Family point-to-reference composition

- Target: ensure a selected anatomy point yields one intelligible local explanation and a genuinely secondary teaching reference, rather than a room decoration or a competing second hero.
- Bounded action: inspected the deterministic `--proof-family-selected-point` route after the preceding Family hero changes; tested a compact secondary-reference/caption placement, then reverted it when the inspected render made the relationship less legible.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-010924/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; a narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-reference-caption`; inspected captures `/tmp/strokecare-family-selected-point-20260813-0110.png`, `/tmp/strokecare-family-selected-point-clear-reference-20260813-0130.png`, and `/tmp/strokecare-family-secondary-reference-20260813-0140.png` showed that the experimental compact placement reduced reference legibility, so no speculative layout change was retained.
- Verdict: `NEUTRAL` — the existing selected-point composition is still the clearer of the tested variants; the inspection narrowed the next annotation redesign.
- Blocker: Simulator cannot prove headset legibility, physical pinch reliability, depth judgement, family comprehension, or clinical correctness; XCAT remains unavailable.
- Next safe action: prototype a point-owned three-part annotation (title, one plain-language sentence, optional "show me" action) and evaluate it as a complete spatial disclosure rather than by repositioning the current caption alone.

## 2026-08-13 09:13 SGT — make Family point references progressive

- Target: replace automatic second-object disclosure with a calmer point-owned explanation that lets a Family wearer choose whether to see the related 3D reference.
- Bounded action: added explicit Family selection state and a `Show reference` / `Hide reference` action to the local point annotation. Selecting a point now shows its short generic meaning first; the related registered teaching object remains hidden until the wearer requests it. Clinician selection retains its existing direct teaching-reference behavior.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-090410/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-point-disclosure`; inspected fresh `--proof-family-selected-point` capture at `/tmp/strokecare-family-progressive-disclosure-20260813-0920.png` visibly shows the one local annotation and its explicit reference action, with no competing secondary anatomy object.
- Verdict: `IMPROVED` — Family discovery now has a legible first explanation and a deliberate second spatial layer instead of an automatic reference reveal.
- Blocker: Simulator cannot prove headset legibility, physical pinch reliability, depth judgement, family comprehension, or clinical correctness; XCAT remains unavailable.
- Next safe action: test the two-step disclosure with a Family wearer on an unlocked Vision Pro and record whether the action label, reach, and reference relationship are clear.

## 2026-08-13 10:01 SGT — map each Family point to its full 3D teaching structure

- Target: make the selected point disclose the structure it actually reveals, so a vessel point can open the complete arterial tree while a surface/context point opens a complete brain-surface object.
- Bounded action: kept the explicit point-first Family flow and added a third registered teaching lens, `brainSurface`, cloned from the already-loaded generic registered-v2 brain. Point actions now say `Show arterial tree`, `Show brain surface`, or `Show layer view`; flow/affected points map to the arterial tree, surface/context points map to the brain surface, and the permission-gated care act retains its layer view.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-091316/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-point-owned-structures`; fresh `--proof-family-surface-reference` capture at `/tmp/strokecare-family-surface-reference-20260813-1000.png` passed route OCR (2/2) and was inspected, showing the selected Brain surface annotation, matching hide action, caption provenance, and distinct full brain-surface object in the right field.
- Verdict: `IMPROVED` — anatomy points now lead to legible, structure-specific 3D teaching objects rather than a generic reference label.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer comprehension, source registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: test an arterial-tree point and a brain-surface point with a Family wearer on an unlocked Vision Pro, then record whether the two reference choices are easy to distinguish.

## 2026-08-13 10:07 SGT — verify the complete arterial-tree teaching reference

- Target: ensure every current vascular point maps explicitly to the complete arterial teaching structure, not merely a text annotation or an ambiguous generic reference.
- Bounded action: made the point-to-lens map exhaustive for all current region, blood-flow, and access labels; added a deterministic arterial-tree route and proof gate. The `Example blockage` point now discloses the world-locked complete arterial tree with the point provenance caption, while brain-surface/context labels retain their distinct brain-surface object.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-100243/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-arterial-reference`; fresh `--proof-family-arterial-reference` capture at `/tmp/strokecare-family-arterial-reference-20260813-1005.png` passed route OCR (2/2) and was inspected, showing `Hide arterial tree`, the full arterial object in the secondary field, and `FROM POINT · EXAMPLE BLOCKAGE` provenance.
- Verdict: `IMPROVED` — the complete arterial-tree path is now explicit, structure-specific, and separately evidenced from the surface-reference path.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer comprehension, source registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: test the arterial-tree and brain-surface disclosure paths with a Family wearer on an unlocked Vision Pro, and record which relationship is clearer.

## 2026-08-13 10:18 SGT — clarify the full-structure teaching payoff

- Target: make it immediately clear that selecting a point can reveal a complete related 3D structure, while keeping the local annotation subordinate to the anatomy.
- Bounded action: renamed the Family actions and secondary captions to `full arterial tree` and `whole brain surface`; added lens-specific generic-atlas boundaries; reduced the selected-point annotation scale from `0.78` to `0.48` so the full 3D reference remains visually dominant.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-100916/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-reference-copy-final`; fresh `--proof-family-arterial-reference` capture at `/tmp/strokecare-family-arterial-reference-final-20260813-1018.png` passed route OCR (2/2) and was inspected, visibly showing `Hide full arterial tree`, the full arterial object in the secondary field, and the more compact local cue.
- Verdict: `IMPROVED` — selected points now make the complete structure they reveal explicit, with a quieter point-owned explanation.
- Blocker: Simulator cannot establish headset legibility, physical gaze-and-pinch reach, stereo depth, source registration accuracy, family comprehension, or clinical correctness; XCAT is unavailable.
- Next safe action: have a Family wearer compare the arterial-tree and whole-brain-surface paths on an unlocked Vision Pro before expanding the reference catalog.

## 2026-08-13 10:31 SGT — reject a point-to-reference bridge that fails at room scale

- Target: make the selected point’s relationship to its full 3D teaching structure more spatially explicit without adding a second text surface.
- Bounded action: prototyped five non-interactive dotted 3D bridge segments between the selected point and the world-locked teaching object, then inspected the deterministic arterial-reference route.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-102212/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-reference-bridge-final`; the fresh `--proof-family-arterial-reference` capture at `/tmp/strokecare-family-arterial-reference-bridge-final-20260813-1031.png` failed its route check and inspection showed the bridge transformed into oversized room-scale geometry. The experiment was fully reverted; no bridge code is retained.
- Verdict: `REGRESSED` — the test would have obscured the anatomy and falsely implied a clean spatial connection, so the established point provenance caption remains preferable.
- Blocker: Simulator cannot establish headset legibility, physical gaze-and-pinch reach, stereo depth, source registration accuracy, family comprehension, or clinical correctness; XCAT is unavailable.
- Next safe action: validate the existing point-provenance caption and full-structure reference with a Family wearer on an unlocked Vision Pro before introducing another relationship cue.

## 2026-08-13 10:55 SGT — prove the Family craniotomy layer reference

- Target: give the access-story point the same complete-structure payoff as vessel and surface points, without turning the explainer into an operative simulation.
- Bounded action: added a deterministic Family route that enters the existing permission-granted generic craniotomy teaching story, selects its authored access point, and opens the complete making-room layer relationship in the secondary field.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-104951/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-layer-reference`; fresh `--proof-family-layer-reference` capture at `/tmp/strokecare-family-layer-reference-20260813-1055.png` passed route OCR (2/2) and was inspected, showing the selected generic craniotomy point, `Hide layer view`, and the matching `MAKING-ROOM PURPOSE · TEACHING VIEW` reference.
- Verdict: `IMPROVED` — all three current teaching-reference families now have a verified point-owned disclosure: full arterial tree, whole brain surface, and generic layer relationship.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer comprehension, registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: conduct one physical Vision Pro walkthrough with a clinician and a family tester, comparing the three references before adding more content.

## 2026-08-13 11:03 SGT — contextualize the complete arterial teaching reference

- Target: let a selected vessel point reveal the arterial network as part of the whole brain, rather than as a disconnected red object.
- Bounded action: added a low-opacity clone of the already-loaded registered-v2 brain behind the existing complete arterial tree and unchanged generic clot. It is context only; it neither adds a patient-specific claim nor changes the point-first disclosure.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-110141/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-arterial-brain-context`; fresh `--proof-family-arterial-reference` capture at `/tmp/strokecare-family-arterial-brain-context-20260813-1103.png` passed route OCR (2/2) and was inspected, showing the full arterial tree in a quiet whole-brain context beside the selected blockage explanation.
- Verdict: `IMPROVED` — vessel teaching references now preserve the brain-wide spatial relationship requested by the point, while the hero anatomy and local explanation remain distinct.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer comprehension, registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: have a clinician and family tester compare the contextual arterial reference with the surface and layer references on Vision Pro before adding additional point families.

## 2026-08-13 11:09 SGT — complete the generic access-layer teaching reference

- Target: ensure the craniotomy access point reveals the entire generic skull–dura–brain relationship, not only an isolated covering and target cue.
- Bounded action: added low-opacity skull and brain context clones behind the existing conceptual dura layer and unchanged target cue. The view remains a static, non-graphic explanatory assembly behind the existing Family permission boundary; it does not depict cutting, a patient-specific site, or an operative plan.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-110644/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-purpose-whole-context`; fresh `--proof-family-layer-reference` capture at `/tmp/strokecare-family-purpose-whole-context-20260813-1109.png` passed route OCR (2/2) and was inspected, showing the generic access point and complete translucent layer relationship in the right secondary field.
- Verdict: `IMPROVED` — each current point family now reveals a complete related teaching structure: arterial route in brain, brain surface, or generic skull–dura–brain layer relationship.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer comprehension, registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: run one supervised Vision Pro walkthrough comparing all three full-structure disclosures before adding new point families.

## 2026-08-13 12:31 SGT — clarify the exterior exhibit and retain a bounded interior handoff

- Target: prevent the main whole-brain explainer from being mistaken for an inside-the-brain simulation, while retaining the existing separate vessel-journey handoff.
- Bounded action: added an always-visible peripheral exterior-orientation cue and moved the detailed teaching miniature into the world stage before its first visibility mutation, preventing it from inheriting the hero brain's room-scale transform when a point is preselected.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-122259/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded; the current source retains the explicit `rbcjourney://enter` handoff at room scale. A fresh `--proof-family-arterial-reference` capture was inspected at `/tmp/strokecare-family-arterial-reference-exterior-clarity-20260813-1231.png`, but it was blocked by the Simulator system confirmation `Open in “Inside the Flow”?`, so it is not accepted as an exterior visual proof.
- Verdict: `IMPROVED` — the product now states that the current view is generic outside-the-brain anatomy and avoids the known first-frame inherited-scale reference failure; the interior journey remains an explicit separate handoff.
- Blocker: the lingering Simulator cross-app confirmation prevents a clean deterministic exterior capture. Simulator and an unavailable XCAT cannot establish wearer comprehension, physical targeting, spatial comfort, or clinical validity.
- Next safe action: clear the system confirmation on-device or in a freshly reset Simulator, then capture the exterior arterial-reference route before adding further point-specific highlights.

## 2026-08-13 12:41 SGT — explain each point's relationship to its complete 3D reference

- Target: remove the ambiguity between a selected anatomy point and the complete teaching structure that appears in the right secondary field.
- Bounded action: added a point-specific relationship map for all ten current invitations; the selected-point caption now states `POINT → FULL 3D STRUCTURE` and identifies tissue context, surface, opposite-side comparison, arterial route, branch, blockage, downstream flow, affected territory, or the generic skull–dura–brain layer relationship. Enlarged the secondary 3D object and its caption while preserving its subordinate right-field placement.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-123345/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-point-relationship-v2`; after restarting the Simulator to clear a stale cross-app confirmation, the fresh `--proof-family-arterial-reference` capture at `/tmp/strokecare-family-arterial-point-relationship-v2-20260813-1241.png` passed route OCR (2/2) and was inspected, showing `Example blockage`, the complete enlarged arterial tree, `POINT → FULL 3D STRUCTURE`, and `BLOCKAGE · GENERIC FLOW INTERRUPTION`.
- Verdict: `IMPROVED` — the wearer can now distinguish the selected local invitation, the whole related 3D structure, and the exact generic relationship being taught.
- Blocker: Simulator cannot establish physical gaze-and-pinch accuracy, stereo depth, wearer comprehension, registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: validate the ten point-to-structure relationships with one clinician and one family wearer on an unlocked Vision Pro before adding new point families.

## 2026-08-13 12:53 SGT — localize the selected point inside its full 3D reference

- Target: make the connection between each selected invitation and the complete right-side teaching structure spatially visible, rather than relying on copy alone.
- Bounded action: added one quiet, non-interactive beacon for every authored point inside the existing arterial, brain-surface, or skull–dura–brain reference; only the currently selected point's beacon is enabled. The generic access beacon identifies the assembled layer relationship and is explicitly not a patient-specific site.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-124307/BLOCKED.md`; `python3 Tests/verify_contract.py` passed; the narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-point-highlight`; fresh captures for `--proof-family-arterial-reference`, `--proof-family-surface-reference`, and `--proof-family-layer-reference` passed route OCR (2/2 each) and were visually inspected at `/tmp/strokecare-family-point-highlight-20260813-1247.png`, `/tmp/strokecare-family-surface-highlight-20260813-1248.png`, and `/tmp/strokecare-family-layer-highlight-fixed-20260813-1252.png`. The first layer placement was rejected as too detached and recaptured after moving the beacon onto the assembled cutaway.
- Verdict: `IMPROVED` — a selected local point now has an explicit counterpart inside its complete 3D teaching reference across all three current families.
- Blocker: Simulator cannot establish physical gaze-and-pinch accuracy, stereo depth, wearer comprehension, registration accuracy, or clinical correctness; XCAT is unavailable.
- Next safe action: compare all ten point-to-reference beacons with a clinician and family wearer on Vision Pro before authoring additional reference families.

## 2026-08-13 13:02 SGT — make the first role choice self-explanatory

- Target: let a first-time wearer understand the Family and Doctor journeys before committing to either immersive route.
- Bounded action: replaced the two terse launch buttons with larger role cards. Family now promises a calm guided anatomy exhibit with questions, narration, and plain-language explanations; Doctor now promises a fictional case-led story with the presenter timeline, teaching references, and evidence. Added a deterministic `--proof-role-choice` route and OCR contract.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-125404/BLOCKED.md`; `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; narrow visionOS Simulator Debug build succeeded with `-derivedDataPath /tmp/strokecare-role-choice`; fresh capture `/tmp/strokecare-role-choice-20260813-1301.png` passed route OCR (2/2) and was visually inspected.
- Verdict: `IMPROVED` — the initial choice now communicates audience, interaction style, and available support instead of asking the wearer to infer those differences from role names.
- Blocker: Simulator cannot establish physical gaze/pinch targeting, wearer comprehension, comfort, or clinical validity; XCAT remains unavailable.
- Next safe action: run a physical cold-start test and ask one unfamiliar wearer to explain the two choices before selecting either card.

## 2026-08-13 13:30 SGT — establish the post-hackathon product threshold

- Target: replace the rushed hackathon entry with a coherent Curious Learner threshold, explicit point-local voice consent, and a safe physical-model request foundation.
- Bounded action: added a four-beat, skippable conceptual spatial prelude (whole brain and vessels, cortical columns, neuron network, invitation); reframed Family as `Curious learner`; added a selected-point `Yes / Not now` Realtime invitation that remains silent when the proxy is unavailable; added a clinician `Teaching model` reference lane and local review-only request for three already-catalogued generic model configurations.
- Evidence: `python3 Tests/verify_contract.py` passed; `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-v2-build`; fresh captures passed route OCR for `--proof-spatial-prelude` (`/tmp/strokecare-spatial-prelude-20260813.png`), `--proof-role-choice` (`/tmp/strokecare-role-choice-v2.png`), `--proof-realtime-narration` (`/tmp/strokecare-family-voice-invitation-v2.png`), and `--proof-print-request` (`/tmp/strokecare-print-request-v2.png`). All four were visually inspected.
- Verdict: `IMPROVED` — the product now tells a spatial story before the role choice, makes learner voice assistance explicit and reversible, and turns the 3D-print idea into an honest review artifact rather than a false live-order claim.
- Blocker: the voice lane still requires the separately configured Realtime proxy; the print lane has no vendor, upload, pricing, order, manufacturability, or licensing integration; Simulator does not establish wearer comfort, physical targeting, clinical correctness, or device readiness.
- Next safe action: validate the four-beat prelude and selected-point voice invitation with one Curious Learner, then refine timing and language from that observed walkthrough before expanding content families.

## 2026-08-13 13:44 SGT — give surface Atlas chapters complete localized 3D references

- Target: make each surface chapter teach through the complete brain rather than reusing a generic point or opening an unrelated vessel reference.
- Bounded action: mapped the cortex and four lobe chapters to the existing complete generic brain-surface teaching object, added one chapter-specific non-interactive focus beacon inside that object, and kept the selected chapter's plain-language sequence in the left Atlas.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-atlas-focus-build`; fresh `--proof-family-atlas-surface-cue` capture `/tmp/strokecare-family-atlas-full-reference-20260813.png` passed route OCR (2/2), image metrics, process checks, and was visually inspected. It shows `Frontal lobe` in the Atlas, the dominant hero anatomy, and a separate `WHOLE BRAIN SURFACE · TEACHING VIEW` with a localized cyan focus.
- Verdict: `IMPROVED` — surface Atlas chapters now answer both “which structure?” and “where is it in the whole brain?” without presenting a patient scan or a precise functional boundary.
- Blocker: Simulator cannot establish physical gaze-and-pinch targeting, stereo depth, wearer comprehension, anatomical registration accuracy, or clinical correctness.
- Next safe action: extend this same named full-structure grammar to one reviewed deep-structure chapter after a clinician approves its source registration and wording.

## 2026-08-13 13:52 SGT — restore a clear Atlas–anatomy–reference hierarchy

- Target: remove the duplicate selected-point card that obscured the hero brain after an Atlas chapter revealed its complete 3D reference.
- Bounded action: made the left Family Atlas own the chapter explanation, optional voice decision, and reversible Show/Hide reference action; suppressed the duplicate center annotation only while that Atlas chapter owns the active selection. Ordinary anatomy points retain their existing local explanation card.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-134612/BLOCKED.md`; `python3 Tests/verify_contract.py` and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-atlas-hierarchy-build`; fresh `--proof-family-atlas-surface-cue` capture `/tmp/strokecare-family-atlas-clean-hierarchy-20260813.png` passed route OCR (2/2), image metrics, and process checks and was visually inspected against the prior capture. The left Atlas contains `Frontal lobe`, `HIDE · WHOLE BRAIN SURFACE`, and the optional voice choice; the center contains unobstructed hero anatomy; the right contains the localized complete-brain reference.
- Verdict: `IMPROVED` — each spatial surface now has one job, and revealing an Atlas chapter no longer creates a second explanation window over the anatomy.
- Blocker: Simulator cannot establish physical gaze-and-pinch targeting, stereo depth, wearer comprehension, or clinical correctness; XCAT is currently unavailable.
- Next safe action: test the Atlas reveal and Show/Hide cycle with one unfamiliar wearer on an unlocked Vision Pro before further increasing chapter density.

## 2026-08-13 14:01 SGT — give every surface chapter its own spatial invitation

- Target: stop Brain Atlas chapters from reusing or misplacing generic lesson dots, especially the cortex and temporal-lobe chapters that previously shared one anchor.
- Bounded action: added a dedicated five-point Atlas field registered to the generic whole-brain envelope. Cortex, frontal, parietal, temporal, and occipital chapters now each select one distinct lifted invitation with a tether; the ordinary four-region point cloud is hidden while the Atlas owns the lesson.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-135318/BLOCKED.md`; `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-atlas-distinct-build`; fresh frontal and temporal captures passed route OCR (2/2), image metrics, and process checks at `/tmp/strokecare-atlas-frontal-distinct-20260813.png` and `/tmp/strokecare-atlas-temporal-distinct-20260813.png`. Visual comparison confirms the frontal invitation is high/anterior while the temporal invitation moves lower/lateral, and the right full-brain reference beacon moves with the selected chapter.
- Verdict: `IMPROVED` — each surface chapter now has one coherent hero-brain invitation and one matching localized full-structure reference instead of borrowing a repeated generic dot.
- Blocker: these are generic teaching anchors, not sulcal boundaries or patient-specific landmarks; Simulator cannot establish physical gaze-and-pinch accuracy, stereo depth, wearer comprehension, registration accuracy, or clinical correctness, and XCAT remains unavailable.
- Next safe action: have a neuroanatomist review all five generic Atlas marker locations together on an unlocked Vision Pro before adding deeper structure chapters.

## 2026-08-13 14:57 SGT — reveal bundled internal anatomy without inventing segmentation

- Target: give the four deeper Brain Atlas chapters a real in-app 3D teaching reference instead of sending every chapter directly to the separate inside-brain journey.
- Bounded action: added one mutually exclusive right-field reference composed from the bundled registered-v2 combined deep-structures mesh, ventricular system, and a quiet whole-brain envelope; updated the Atlas, narration, caption grammar, deterministic route, and clinical-review packet so Thalamus and the other deep chapters are explicitly presented as chapter-to-combined-context relationships, never separately segmented landmarks or patient anatomy.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-140410/BLOCKED.md`; `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-atlas-internal-build`; fresh `--proof-family-atlas-internal-reference` capture `/tmp/strokecare-atlas-internal-reference-final-20260813.png` passed route OCR (2/2), image metrics, and process checks and was visually inspected. It shows the Thalamus chapter, dominant exterior anatomy, and a distinct right-side `INTERNAL STRUCTURES + VENTRICLES` 3D reference labelled `CHAPTER → COMBINED 3D CONTEXT`.
- Verdict: `IMPROVED` — deeper Atlas chapters now reveal actual bundled internal geometry while stating the source's segmentation limit instead of implying a precise thalamic, hippocampal, or callosal highlight.
- Blocker: the source USDZ exposes one combined deep-structures mesh and one ventricular mesh, not separately named deep structures. Its labels and registration remain pending neuroanatomist review; Simulator does not establish wearer comprehension, stereo placement, comfort, or clinical correctness.
- Next safe action: obtain a licensed stable-ID structure manifest plus one sample segmented mesh, then prove one named deep structure end-to-end before expanding the four chapter references.

## 2026-08-13 15:18 SGT — make qualitative arterial motion visible and provable

- Target: make the complete arterial teaching reference communicate route direction instead of appearing as another static vessel model.
- Bounded action: added seven sparse amber markers that travel toward the selected example blockage and only two dim markers beyond it; Pause and Reduce Motion hold a fixed readable composition. Fixed an epoch-to-`Float` precision bug that the new two-frame proof exposed, then added a reusable ROI motion-pair verifier.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-145953/BLOCKED.md`; `python3 Tests/verify_contract.py`, Python compilation, `git diff --check`, and the narrow generic visionOS Simulator build at `/tmp/strokecare-flow-reference-build` passed. Fresh `--proof-family-arterial-reference` capture `/tmp/strokecare-flow-reference-fixed-a-20260813.png` passed route OCR (2/2) and was visually inspected. A second frame two seconds later at `/tmp/strokecare-flow-reference-fixed-b-20260813.png` passed the right-reference ROI motion proof with a 0.006545 changed-pixel ratio, versus exactly 0 before the precision fix.
- Verdict: `IMPROVED` — the full 3D arterial reference now visibly distinguishes approach to the generic blockage from the sparse downstream continuation, and future captures have an automated check that rejects a frozen reference.
- Blocker: marker density and direction remain app-authored qualitative teaching cues pending specialist review. Simulator cannot establish wearer targeting, stereo depth, comfort, comprehension, clinical correctness, or physical-device motion quality; XCAT is unavailable.
- Next safe action: have a stroke clinician review the route direction, marker density, and `not CFD` wording together on an unlocked Vision Pro before adding collateral-flow or perfusion concepts.

## 2026-08-13 16:16 SGT — keep one selected-point explanation clear of the anatomy

- Target: stop an ordinary selected lesson point from creating two competing disclosures across the magnified hero anatomy.
- Bounded action: consolidated the former `VESSEL STORY` capsule and intention card into one stage-space callout containing the selected point title, bounded meaning, explicit optional-voice choice, reversible full-reference action, and close control. The callout resolves from the anatomy point into stage coordinates, clears the brain silhouette, and no longer inherits hero scale. The arterial proof now waits at least 15 seconds and requires `Hear more` in addition to its point and structure tokens so a partially loaded frame cannot pass.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-151846/BLOCKED.md`; `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-single-callout-build`; an initial black compositor frame and an anatomy-overlapping recovery frame were rejected. The final fresh `--proof-family-arterial-reference` capture `/tmp/strokecare-family-single-callout-final-20260813.png` passed image metrics and route OCR (3/3) and was visually inspected, showing one readable callout beside the hero brain and a separate complete arterial reference.
- Verdict: `IMPROVED` — point selection now yields one coherent spatial explanation without obscuring the anatomy or duplicating controls.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer reading comfort, comprehension, or clinical correctness; XCAT is unavailable.
- Next safe action: test point selection, `Hear more`, Show/Hide reference, and close as one loop with an unfamiliar Curious Learner on an unlocked Vision Pro.

## 2026-08-13 17:24 SGT — connect a selected point to its spatial explanation

- Target: make the relationship between the selected anatomy invitation and its explanation immediately legible without adding another panel or permanent label cloud.
- Bounded action: added a quiet, two-segment stage-space leader from the selected point's live transformed position to the existing explanation card. The leader is non-interactive, leaves the anatomy before turning toward the card, follows zoom/orbit updates, and disappears whenever the point-owned callout is not visible.
- Evidence: `Scripts/deploy_xcat.zsh` recorded XCAT unavailable in `Proof/xcat/20260813-171527/BLOCKED.md`; `python3 Tests/verify_contract.py` and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-point-connector-build`; fresh `--proof-family-arterial-reference` capture `/tmp/strokecare-point-callout-connector-20260813.png` passed route OCR (3/3), image metrics, and process checks and was visually inspected against `/tmp/strokecare-family-single-callout-final-20260813.png`. The amber leader visibly begins at the selected white orb, clears the lower cortex, and terminates at the callout's leading edge.
- Verdict: `IMPROVED` — the selected point, its explanation, and the separate full 3D arterial reference now read as one authored sequence rather than three nearby objects whose relationship must be inferred.
- Blocker: Simulator cannot establish physical gaze-and-pinch reach, stereo depth, wearer comprehension, clinical correctness, or whether the leader remains comfortable from every room viewpoint; XCAT is unavailable.
- Next safe action: validate the point-to-callout leader from two physical viewing angles with one unfamiliar Curious Learner before tuning thickness, depth, or colour.

## 2026-08-13 17:49 SGT — localise every vessel point inside the complete arterial reference

- Target: stop the five blood-flow invitations from appearing to reveal the same undifferentiated arterial miniature with different text.
- Bounded action: retained the complete registered-v2 arterial tree and added a mutually exclusive amber route trace for Supply, Branch, Blockage, Beyond, and Territory. Supply now illuminates the proximal approach, Branch the division and both continuations, Blockage the interrupted segment, Beyond one distal continuation, and Territory a separate terminal dependency cue. These are explicitly generic teaching samples—not segmented centre-lines, patient landmarks, perfusion measurements, or a navigation plan.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded at `/tmp/strokecare-point-route-reference-build`. Fresh `--proof-family-arterial-supply-reference` and `--proof-family-arterial-beyond-reference` captures passed image metrics, route OCR (2/2 each), and process checks at `/tmp/strokecare-arterial-supply-reference-20260813.png` and `/tmp/strokecare-arterial-beyond-reference-20260813.png`. Both were visually inspected: the former shows a low/proximal amber trace while the latter moves the trace to the distal branch; cropped right-field receipts have distinct SHA-256 hashes.
- Verdict: `IMPROVED` — each vessel invitation now visibly answers “which part of the complete vessel map am I looking at?” instead of relying on caption changes alone.
- Blocker: these route samples remain app-authored and pending stroke-clinician/anatomy review. Simulator cannot establish physical pinch targeting, stereo depth, wearer comprehension, registration accuracy, or clinical correctness.
- Next safe action: review all five route traces together with a stroke clinician, then adjust or reject each generic sample before introducing named arterial segments.
## 2026-08-13 19:59 SGT — Integrated internal systems lens

- Target: make the existing inside-brain journey a coherent, explorable part of Stroke Care.
- Action: integrated the internal world in-process; added Cortex, Vessels, Deep structures, Ventricles, and optional schematic Neural activity controls; surfaced the controls and Return to Stroke Care in one persistent HUD; documented the educational and clinical boundary.
- Evidence: `STROKE_CARE_CONTRACT=PASS`; generic visionOS Simulator build `BUILD SUCCEEDED`; `--proof-integrated-interior` image passed 2/2 route OCR and visual metrics at `/tmp/strokecare-integrated-interior-systems-late.png` (SHA-256 `1005c96b02795592633142f34d263f405d0b2f08392aedcfca19985c218e5ec9`).
- Verdict: IMPROVED.
- Blocker: headset comfort, hand targeting, comprehension, anatomical registration, and clinical validity remain human/device review gates.
- Next safe action: author and clinically review one region-specific cortical-column lesson before adding another disease scenario.

## 2026-08-13 20:33 SGT — Focused internal-system lessons and ventricular continuity

- Target: make the inside-brain layer switches lead to distinct spatial lessons rather than behaving as passive visibility toggles.
- Action: added focus, show/hide, isolate, and Explore semantics for Cortex, Vessels, Deep structures, Ventricles, and schematic Neural activity. Added a dedicated room-scale ventricular lesson using the bundled geometry, four softly pulsing connected-space guides, concise explanatory copy, and a persistent Return to Stroke Care action. The guides are explicitly continuity cues, not simulated cerebrospinal-fluid flow or pressure.
- Evidence: `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the narrow generic visionOS Simulator build at `/tmp/strokecare-internal-learning-final` succeeded. Fresh `--proof-integrated-ventricles` capture `/tmp/strokecare-integrated-ventricles-proof.png` passed image metrics and route OCR 2/2 (SHA-256 `888902b3abbd84707c0c2e3019629013dcb73f015cbde3c407257cec1829aa05`) and was visually inspected.
- Verdict: `IMPROVED` — the internal experience now distinguishes learning about a system from merely turning its geometry on, and the ventricular system has a legible animated spatial lesson.
- Blocker: Cortex, vessels, and deep structures reuse their existing authored exhibits; only Ventricles received a new system-specific animation in this pass. Simulator does not prove headset comfort, hand targeting, comprehension, anatomical registration, or clinical validity.
- Next safe action: give the Cortex system the same explicit entry treatment by joining the existing six-layer cortical-column exhibit to one reviewed region-selection route.

## 2026-08-13 21:09 SGT — Cortex becomes a room-scale layered lesson

- Target: make Cortex Explore open a legible, animated internal lesson rather than merely focusing an overview layer.
- Action: kept the authored six-layer cortical room and added distinct Locate, Layers, and Flow explanations; preserved laminar bands and radial guides during Flow; kept the five-system lens visible inside the room; allowed the optional Neural activity schematic to be enabled there; relabelled the route-local `X-ray` control as `Layers`; and added a deterministic integrated Cortex route.
- Evidence: `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-cortex-final` succeeded. Fresh `--proof-integrated-cortex` frame `/tmp/strokecare-integrated-cortex-proof-a.png` passed image metrics and route OCR 2/2 (SHA-256 `3098bcf6c5112e58c62af1b4e9711ac1aed67117886e89712e1efadf4563ef92`) and was visually inspected. A second frame two seconds later passed the downsampled scene ROI motion check with changed-pixel ratio `0.428175`, confirming visible runtime change rather than a still.
- Verdict: `IMPROVED` — the learner can now stand inside a magnified cortical patch, compare boundary/layers/vascular readings, and control related systems without leaving the lesson.
- Blocker: the 93 markers are illustrative, not identified cell types; the arrows are qualitative, not measured flow; and there is no synaptic, ionic, membrane-voltage, cognition, injury, or disease simulation. Simulator does not prove headset comfort, hand targeting, comprehension, anatomical correctness, or clinical validity.
- Next safe action: clinically review this Cortex lesson and its three explanations, then add one sourced schematic neural-signalling micro-lesson without implying biophysical simulation.

## 2026-08-13 21:38 SGT — Internal transition gets a spatial loading state and escape

- Target: prevent the in-process `Enter the brain` handoff from presenting an unexplained black compositor while the linked cortex, vessel, deep-structure, and ventricular scene assembles.
- Action: replaced the ineffective flat SwiftUI overlay with a wearer-facing RealityKit attachment added before the heavy scene build. The attachment names the systems being prepared, preserves the generic/not-a-patient-scan boundary, and exposes `Return to Stroke Care` so a failed or slow transition cannot become an interaction trap. It disables itself when `isSceneReady` becomes true; a deterministic loading route keeps it visible only for inspection.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-loading-final` succeeded. Fresh `--proof-integrated-loading` capture `/tmp/strokecare-integrated-loading-final-20260813.png` passed image metrics and route OCR 2/2 (SHA-256 `d61b98b4127174dba856ee41a46bf9d68525fb73e02724ec3dd45a54c353bf2e`) and was visually inspected with a large readable loading card and Return action. A separate fresh `--proof-integrated-cortex` capture `/tmp/strokecare-integrated-cortex-after-loading-20260813.png` passed 2/2 (SHA-256 `6961372192b09cbb0e6da14a3a48ae777665f9442674b283623f2d1c9f0f68bd`) and was visually inspected with the veil absent and the six-layer Flow lesson visible.
- Verdict: `IMPROVED` — internal entry now has an authored, reversible transition state while the ready scene remains unobstructed.
- Blocker: the deterministic proof establishes both render states, but not the exact duration of a cold hardware load, wearer comfort, spatial reach, comprehension, or anatomical/clinical validity.
- Next safe action: record one cold-launch Simulator clip and verify that the loading attachment appears before the first heavy anatomy frame, then tune its dwell only if the measured transition warrants it.

## 2026-08-13 22:01 SGT — Neural activity becomes a distinct internal lesson

- Target: stop Neural activity from opening the Cortex room and make it a spatially explorable, medically bounded lesson of its own.
- Action: added a separate room-scale Neural signalling destination with nine schematic cells, eleven separated connections, fifteen travelling signal fronts, eleven synaptic-handoff cues, and four quiet vessel paths that provide blood-supply context without being presented as neural pathways. Added distinct Locate, Connections, and Signal readings, kept the systems lens and Return to Stroke Care available, and limited the copy to qualitative electrical/synaptic signalling rather than membrane voltage, spike timing, neurotransmitter, ion, functional-connectivity, disease, or patient simulation.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed; the narrow generic visionOS Simulator build succeeded. Fresh `--proof-integrated-neural` capture `/tmp/strokecare-integrated-neural-20260813.png` passed image metrics and route OCR 2/2 (SHA-256 `999d3b4b14664b060e0550c224cfbb0cd6b465b80958465f7b4312e5a638de59`) and was visually inspected. A second frame `/tmp/strokecare-integrated-neural-20260813-frame-b.png` also passed route OCR 2/2, and the broad scene ROI motion check passed with changed-pixel ratio `0.012235`, confirming visible runtime change rather than a still.
- Verdict: `IMPROVED` — Neural Explore now opens a surrounding circuit where the learner can distinguish cells, connections, qualitative signals, synaptic gaps, and a separate blood-supply relationship.
- Blocker: the forms are schematic and do not represent named cell classes, measured connectivity, electrophysiology, neurotransmitter dynamics, cognition, injury, disease, or a patient. Simulator does not prove headset scale, reach, comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: have a neuroanatomist review the Signal reading and blood-supply relationship, then add one sourced cell-class lesson only if the review supports the current abstraction.

## 2026-08-13 22:18 SGT — Curious Learner voice invitation is explicit and provable

- Target: verify that optional GPT-Realtime guidance begins from a selected anatomy point and an explicit learner choice, rather than behaving like an ambient or automatic narrator.
- Action: unified the selected-point prompt to `Want to hear one layer deeper?`, retained the separate `Yes` and `Not now` actions, and kept `Yes` disabled with the visible `Voice setup needed · nothing is recording` disclosure when the Realtime proxy is unavailable. The deterministic route selects the generic Brain surface point and stops at this invitation; it never auto-accepts or starts audio.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed; the narrow visionOS Simulator build succeeded at `/tmp/strokecare-curious-voice`. Fresh `--proof-realtime-narration` capture `/tmp/strokecare-curious-learner-voice-20260813.png` passed image metrics and route OCR 2/2 (SHA-256 `fbb3f8fe2a080f02849b3d70d2657323d5971e4f3930eaedd36ea8a795095d11`) and was visually inspected: the invitation, silent setup boundary, `Not now`, selected Brain surface explanation, point leader, and full 3D surface reference are visible together.
- Verdict: `IMPROVED` — the Curious Learner route now makes the voice boundary understandable at the exact point where narration could add value, while remaining silent and reversible without setup.
- Blocker: this receipt does not prove a successful Realtime proxy request, audible playback, interruption handling on hardware, wearer comfort, comprehension, or clinical validity.
- Next safe action: configure the local Realtime proxy in a private test environment and record one explicit `Yes` → one authored sentence → `Stop voice` interaction without enabling microphone recording or doctor-mode narration.

## 2026-08-13 22:47 SGT — regional points localise the complete brain reference

- Target: make surface/context points answer `what part am I looking at?` without replacing the complete registered brain with another text card or detached dot.
- Action: replaced the surface-reference beacons with quiet tangential 3D patches that sit just outside the complete generic brain. Nearby tissue and Opposite-side context now illuminate different regions while preserving the full brain, point-to-callout leader, selected-point explanation, optional voice invitation, and explicit not-a-patient-scan boundary. Added deterministic comparison routes and hardened Vision OCR with overlapping crops so peripheral spatial text is verified rather than ignored.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow visionOS Simulator build succeeded at `/tmp/strokecare-regional-references`. Fresh captures `/tmp/strokecare-nearby-reference-final-20260813.png` (SHA-256 `37a48d4f571db1e549c44f9d4dcb3624847d003b11f952d26267febb1e956a83`) and `/tmp/strokecare-opposite-reference-final-20260813.png` (SHA-256 `a952fee998a5cf83bed90518bbe5ea1ef61f540403676d4b6a7d816e73d2d761`) each passed image metrics, exact route OCR 2/2, launch/process checks, and visual inspection. The patches occupy visibly different areas of the same right-side brain reference. The prior Realtime invitation receipt still passes 2/2 after OCR hardening. Guarded XCAT deployment stopped at exact device state `unavailable` and wrote `Proof/xcat/20260813-224715/BLOCKED.md`; no device build/install/launch occurred.
- Verdict: `IMPROVED` — selecting a regional point now changes both the explanation and the spatial location being taught, while the complete brain remains available for context.
- Blocker: the patches are app-authored orientation cues, not segmented anatomical boundaries, measured regions, patient findings, or specialist-approved landmarks. Simulator does not prove physical gaze-and-pinch reach, stereo depth, comfort, comprehension, or clinical validity; XCAT is unavailable.
- Next safe action: review all four regional patches together with a neuroanatomist, then adjust or reject their generic locations before introducing named functional areas.

## 2026-08-14 00:03 SGT — Cortex Layers and Flow become separate internal readings

- Target: make the internal Cortex destination teach an actual spatial relationship instead of presenting the same room with a changed opacity.
- Action: gave the existing six-band cortical room a dedicated `Layers` reading with 93 sparse illustrative cell markers and gentle, pausable layer-local motion; retained the five radial guides; and separated it from a `Flow` reading where the nine pial/penetrating/branch paths and thirteen travelling direction arrows become dominant. Added deterministic integrated routes for both states and kept the system lens plus `Return to Stroke Care` available. Copy explicitly says the room is generic, magnified, not to scale, not histology, and not a patient scan.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, both worktree diff checks, and the narrow generic visionOS Simulator build passed. Fresh Layers capture `/tmp/strokecare-integrated-cortex-layers-final-20260813.png` passed image metrics and route OCR 2/2 (SHA-256 `744dec85c9e50eec1498e7fd0eb9366dd2a0afa5d5e5aa53df338efbb786fa7b`) and was visually inspected. Fresh Flow capture `/tmp/strokecare-integrated-cortex-flow-final-20260813.png` passed image metrics and route OCR 2/2 (SHA-256 `dab6933cdc36537c5e4dcf910b5b2b97ebbe29d440deb054f0d2723864c5be7b`) and was visually inspected. Two time-separated, downsampled Simulator frames passed the scene-motion gate: Layers changed-pixel ratio `0.393729`; Flow changed-pixel ratio `0.482779`.
- Verdict: `IMPROVED` — entering Cortex now provides two genuinely different room-scale lessons: superficial-to-deep organization and the qualitative route from a surface vessel toward deeper branches.
- Blocker: the cells are illustrative dots, not identified cell classes; the bands are not measured histology; and the arrows do not simulate speed, pressure, oxygen, perfusion, injury, cognition, diagnosis, or treatment. Simulator does not prove headset comfort, targeting, comprehension, anatomical correctness, or clinical validity.
- Next safe action: have a neuroanatomist review the six-band ordering, marker density, and surface-to-penetrating vessel relationship before adding one sourced cell-class lesson.

## 2026-08-14 09:27 SGT — blood-flow points receive distinct motion stories

- Target: stop the five exterior blood-flow invitations from appearing to teach the same arterial event after selection.
- Action: retained the complete generic arterial-tree reference and its existing point-specific static traces, then made its moving qualitative markers follow the selected invitation. Supply now approaches the branch, Branch divides toward two routes, Blockage gathers at the example obstruction, Beyond uses a sparse downstream route, and Territory uses a separate sparse destination route. Markers irrelevant to the selected sentence are hidden. The source boundary states that these are teaching samples—not vessel centre-lines, speed, perfusion, or patient flow.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, and `git diff --check` passed; the narrow visionOS Simulator build at `/tmp/strokecare-point-specific-flow` succeeded. After isolating the Simulator boot loop to its own `RealitySimulation.BootChime` RPC timeout and recovering a clean shell, fresh Supply (`/tmp/strokecare-point-specific-supply-proof-final.png`, SHA-256 `24a6caa9b304efb7ae000ef5f8db252fdb5e57b42e0187981602eba051c80ba5`), Blockage (`/tmp/strokecare-point-specific-blockage-before-layout.png`, SHA-256 `ad283a2a1085209eaa8eaa7aa112780ac649d53d755c8dc43c6c226c9c718fa1`), and Beyond (`/tmp/strokecare-point-specific-beyond-before-layout.png`, SHA-256 `3dffbc536e7a952890508c486059d40babf6f4e26c5861fe206a3111bc302690`) frames each passed image metrics, exact route OCR, and visual inspection. Their right-side full arterial references show visibly different selected traces and marker densities. Two-second, downsampled right-reference motion checks passed for Supply (`0.002193`) and Blockage (`0.002844`).
- Verdict: `IMPROVED` — the same complete arterial model now teaches an inbound supply path, a gathering interruption, and a sparse downstream path as visibly different spatial stories rather than changing only text.
- Blocker: the clean Simulator later shut down during the Beyond two-frame motion attempt, so Beyond motion is supported by source/contract plus a fresh route frame rather than its own motion pair. Simulator still does not prove gaze-and-pinch targeting, headset depth, comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: capture a Beyond two-frame motion pair after the Simulator audio shell remains stable, then test all five point invitations by gaze and pinch on physical Vision Pro before changing their authored positions.

## 2026-08-14 10:22 SGT — sparse Beyond flow motion receipt

- Target: close the remaining Simulator evidence gap for the `Flow beyond the blockage changes` invitation without changing the already-reviewed sparse teaching composition.
- Action: recovered the disposable proof Simulator from its system boot-chime failure, reinstalled the exact previously verified `/tmp/strokecare-point-specific-flow` build, launched `--proof-family-arterial-beyond-reference`, and captured time-separated frames. No app source or interaction behavior changed.
- Evidence: `/tmp/strokecare-beyond-motion-final-a.png` passed visual metrics and exact route OCR 2/2 (SHA-256 `2fdebbcdc7449eba2e78223a99ba41c0dd6bb9a6f547a351a1174d00829544cf`) and was visually inspected with the full exterior brain, complete right-side arterial reference, selected distal trace, sparse downstream cues, and qualitative/not-CFD boundary visible together. The downsampled arterial-reference ROI `0.75,0.44,0.82,0.57` changed across the time-separated frames with ratio `0.001793`, mean delta `0.0264`, and max delta `22`, passing the `0.000500` motion threshold.
- Verdict: `IMPROVED` — Supply, Blockage, and Beyond now each have fresh route-aware composition proof and independent runtime-motion evidence; Beyond remains intentionally much sparser than the other two.
- Blocker: Simulator frames prove render-state change, not physical gaze-and-pinch reachability, stereo depth, comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: test all five exterior blood-flow invitations by gaze and pinch on physical Vision Pro before changing their authored positions or adding further vessel claims.

## 2026-08-14 12:22 SGT — Curious Learner discovery starts from structure, not diagnosis

- Target: remove diagnostic-sounding questions before the learner has selected anatomy, and stop a large connector line from visually tying every point to a detached text card.
- Action: changed the family rail from `QUESTIONS TO ASK` to `EXPLORE NEXT`; its three actions now derive from the currently selected brain, vessel, or generic access-layer point. Added a transient `LOOK, THEN PINCH` cue that dismisses after eight seconds or immediately after the first successful point selection. Removed the selected-point connector geometry entirely; the compact local explanation remains near the point while the complete 3D teaching reference stays in the opposite secondary field. Kept the existing ten authored targets rather than inventing unreviewed landmarks.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed; the narrow visionOS Simulator build at `/tmp/strokecare-family-contextual-v2` succeeded. Fresh `--proof-family-entry-hint` capture `/tmp/strokecare-family-entry-hint-20260814.png` passed image metrics and route OCR 2/2 (SHA-256 `a8c2459b1c61e3284d3dd0bc6ac7dcbba4a531176c671f9b95cfc4744e7e4ecb`) and was visually inspected with the complete brain/arteries, four lifted mint points, left `EXPLORE NEXT` actions, and the small opposite-field first-action cue visible together. A recovered disposable Simulator then produced `/tmp/strokecare-family-reference-no-line-final-20260814.png`; it passed visual metrics and route OCR 2/2 (SHA-256 `847c1096896fba50f919844f4bee009d98d0b15c6c8d607d6dd5f6c920198995`) and was visually inspected with the selected Brain Surface explanation, a complete 3D teaching reference in the right secondary field, an unobscured central brain, and no connector line crossing or wrapping around the anatomy.
- Verdict: `IMPROVED` — the learner is invited to inspect one structure at a time instead of being asked to classify an unknown condition, and the point/reference relationship no longer depends on a long line across the scene.
- Blocker: Simulator does not prove physical gaze-and-pinch targeting, stereo depth, comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: test all ten authored point invitations by gaze and pinch on a physical Vision Pro before changing their positions or adding new reviewed anchors.

## 2026-08-14 12:56 SGT — every authored dot has a deterministic reference entry

- Target: close the evidence gap behind the claim that all ten authored dots lead to structure-specific spatial teaching references rather than recycled text cards.
- Action: audited the complete four-region, five-vessel, one-access point catalog against the existing registered 3D reference factory. Preserved its distinct surface patches, arterial route traces, qualitative motion sentences, and generic access-layer beacon. Added deterministic Affected, Branch, and Territory routes—the three concepts that could not previously be launched directly—and hardened the cold-start Affected route so its caption cannot be accepted before the right-side arterial object resolves.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, `git diff --check`, and the narrow Simulator build at `/tmp/strokecare-all-point-proof` passed. `/tmp/strokecare-point-affected-recheck-20260814.png` passed route OCR 2/2 (SHA-256 `2a8123325120953d1337c2a399a4ba48ee5a975df2138d0be10f234fce434eca`); `/tmp/strokecare-point-branch-20260814.png` passed 2/2 (`862295664a9ab8d95f5447468876f2ef01619a7e47d4257ec274ae3e5b922438`); `/tmp/strokecare-point-territory-20260814.png` passed 2/2 (`a42d36298416c3338911212d534145a0f1f3efb7d2becc24026dd96fc33927d6`). Visual inspection confirmed all three keep the hero brain central and place the complete reference in the right field without a cross-scene leader line. The Branch-versus-Territory right-reference ROI changed by `0.127318`, proving the two states are not caption-only duplicates.
- Verdict: `IMPROVED` — every current point concept now has an explicit state mapping and a deterministic route; the newly evidenced vessel concepts render genuinely different spatial relationships.
- Blocker: Simulator routes prove deterministic state, composition, and render differences—not physical gaze-and-pinch reachability, stereo depth, wearer comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: test all ten authored point invitations by gaze and pinch on a physical Vision Pro before moving existing anchors or authoring any additional anatomy point.

## 2026-08-14 13:12 SGT — Explore Next navigates the spatial model

- Target: stop the Curious Learner rail from behaving like another text-question feed after a point has already been selected.
- Action: converted the authored `Locate`, `Nearby`, `Follow`, `Beyond`, and layer actions into real point-navigation commands. Each action now selects its reviewed anatomy point and opens that point's existing right-side 3D reference; `Enter the brain at room scale` only magnifies to the explicit portal threshold. The remaining `cannot conclude`, `cannot measure`, and generic-access boundaries are the only actions that pause and open text. Replaced passive diagnostic-sounding act prompts with neutral exploration guidance and changed the explicit question marker to `MARKED FOR CLARIFICATION`.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, `git diff --check`, and the narrow visionOS Simulator build at `/tmp/strokecare-explore-navigation` passed. Fresh rail-driven Nearby capture `/tmp/strokecare-family-explore-nearby-20260814.png` passed image metrics and route OCR 2/2 (SHA-256 `75a5dfad13b8d50725637ea3b7df83a48323e58c4d50ccafc28c5e7422e4b2eb`). Fresh rail-driven Beyond capture `/tmp/strokecare-family-explore-beyond-20260814.png` passed image metrics and route OCR 2/2 (SHA-256 `f348ccee72729259362d2eac6c6e366daf46d66dd1f022873553b5bb182ee790`). Visual inspection confirmed the selected rail row, changed central point state, and corresponding complete 3D reference in the right field with no long connector line.
- Verdict: `IMPROVED` — the left rail now advances spatial discovery instead of asking the learner to classify a condition or read a second answer card.
- Blocker: Simulator verifies deterministic navigation and composition, not physical gaze-and-pinch reachability, stereo depth, comfort, comprehension, anatomical correctness, or clinical validity. Literal vessel cutting, rupture creation, drug-response simulation, and treatment selection remain intentionally outside this education prototype.
- Next safe action: test the six rail-driven point transitions by gaze and pinch on a physical Vision Pro, then adjust only targets that are demonstrably hard to acquire.

## 2026-08-14 13:32 SGT — point focus becomes explicit and ambiguity-safe

- Target: make every visible lesson point easier to identify before pinch without using raw eye tracking or letting a broad anatomy-proxy hit silently choose the wrong neighbouring point.
- Action: replaced the default point hover effect with a stronger platform-native highlight blend; made each authored point one named accessible Activate target; and split anatomy-proxy acquisition into a normal 36 mm allowance plus an extended 85 mm allowance that is accepted only when the nearest point has a clear 24 mm lead (or is the single access point). Exact point-target pinches remain unchanged.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow visionOS Simulator build at `/tmp/strokecare-point-focus` succeeded. Fresh `/tmp/strokecare-point-focus-entry-20260814.png` passed image metrics and exact route OCR 2/2 (SHA-256 `277a909a2b58f998066949d656ac2683652fdc5d3510d28246ae4925639cf900`) and was visually inspected with five separated mint invitations, the central complete brain/arteries, no permanent point labels, and no cross-scene teaching-reference line.
- Verdict: `IMPROVED` — the system now provides a clearer pre-pinch focus response and refuses ambiguous fallback selections instead of guessing between adjacent vessel points.
- Blocker: Simulator cannot drive or judge wearer gaze hover, VoiceOver spatial announcement, indirect-pinch acquisition, stereo depth, comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: test all ten authored points with gaze and pinch on a physical Vision Pro and record which exact targets, if any, still fail acquisition.

## 2026-08-14 13:54 SGT — the arterial teaching reference becomes a five-step route trace

- Target: make a selected blood-vessel point support continued spatial exploration instead of ending at one text explanation or implying a diagnostic/treatment question.
- Action: added large Previous/Next pinch targets inside the right-side full arterial reference. They trace the same complete generic structure through Supply → Branch → Blockage → Beyond → Territory, update the selected anatomy point and its qualitative marker story, and show a clear `n OF 5` position. The route stays visual and quiet instead of repeatedly asking the optional voice question. The example blockage remains present through the trace, so the sequence cannot be read as a drug response, procedure success, vessel cutting, or treatment recommendation. Replaced the stretched capsule outline with a compact rounded reference card and kept it in the opposite field with no cross-scene tether.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, and `git diff --check` passed; the narrow visionOS Simulator build at `/tmp/strokecare-route-trace` succeeded. Fresh `--proof-family-vessel-route-trace` capture `/tmp/strokecare-family-vessel-route-trace-compact-20260814.png` passed image metrics and route OCR 3/3 (SHA-256 `e589415ebafe83e7671e0986d08eed8643e18cf65d0327b84b668e5fef2d36bd`) and was visually inspected with the complete exterior brain, selected downstream explanation, full arterial reference in the right field, compact route controls, and `4 OF 5` visible together.
- Verdict: `IMPROVED` — the right teaching reference now survives a second pinch and teaches a coherent vessel relationship rather than behaving like a static label.
- Blocker: Simulator proves deterministic state, layout, and render—not physical gaze-and-pinch acquisition, stereo depth, comfort, comprehension, anatomical correctness, or clinical validity. Literal cutting/rupturing, medication-response animation, treatment choice, and surgical training remain intentionally unsupported.
- Next safe action: test Previous/Next route acquisition and all five resulting reference states on physical Vision Pro before adding any new reviewed point family.

## 2026-08-14 14:13 SGT — selected blockage opens a bounded inside-vessel lesson

- Target: let the exterior blockage point lead to a meaningful spatial investigation without inventing vessel cutting, rupture creation, medication response, or a treatment outcome.
- Action: added `Inspect inside the vessel` to the selected Blockage teaching reference. It magnifies the exterior model to the existing entry threshold, switches into the already-authored internal interruption lesson, holds the moment before the example obstruction, and preserves the visible `Return to Stroke Care` path. The internal scene retains qualitative direction cues and explicitly remains a separate generic teaching scene rather than a patient scan or treatment simulation. Added one deterministic integrated route and paired it with the internal journey's authored blockage proof beat so a cold launch cannot capture an uninitialized black field.
- Evidence: `python3 Tests/verify_contract.py`, Python compilation, shell syntax, `git diff --check`, and the narrow visionOS Simulator build at `/tmp/strokecare-blockage-interior` passed. Fresh `--proof-family-blockage-interior` capture `/tmp/strokecare-family-blockage-interior-proof-20260814.png` passed visual metrics and route OCR 2/2 (SHA-256 `a0113519f427f6ae4c7c691d85bd817e6260229cd50c6d908556207641b21848`). Visual inspection confirmed the magnified arterial route, interruption portal, held flow arrows, authored explanation, systems lens, and `Return to Stroke Care` control render together.
- Verdict: `IMPROVED` — the blockage point now survives another explicit action and opens a distinct internal spatial lesson instead of ending at a reference card or performing an unsafe simulated intervention.
- Blocker: Simulator proves the deterministic transition and rendered state, not physical gaze-and-pinch acquisition, stereo depth, comfort, comprehension, anatomical correctness, clinical validity, or treatment efficacy.
- Next safe action: test Blockage → Inspect inside the vessel → Return to Stroke Care end to end by gaze and pinch on physical Vision Pro before adding any interactive procedural claim.

## 2026-08-14 14:42 SGT — cortical Layers gains direct I–VI exploration

- Target: turn the internal cortical Layers reading into a direct spatial-learning interaction instead of one fixed six-band composition.
- Action: grouped each of the six authored laminar bands with its own illustrative cells and relative-depth label; added six 44-point I–VI controls inside the existing region HUD; and made the chosen band, cells, and label resolve while the other five recede. The deterministic Layers route selects Layer IV. Copy remains bounded to pial-to-deep relative orientation and explicitly avoids measured thickness, histology, function, diagnosis, or patient-anatomy claims. Added an explicit rendering-boundary route reset so a preserved SwiftUI model cannot silently retain an older internal lesson.
- Evidence: both `python3 Tests/verify_contract.py` suites and both worktree `git diff --check` checks passed. The integrated Stroke Care generic visionOS Simulator build at `/tmp/strokecare-cortical-layer-focus` and standalone internal build at `/tmp/rbcjourney-cortical-layer-focus` both succeeded. Visual proof is not accepted: the first two integrated captures repeated the older blockage frame byte-for-byte (SHA-256 `a0113519f427f6ae4c7c691d85bd817e6260229cd50c6d908556207641b21848`); after reboot, two clean Stroke Care Simulators reported a SurfBoard crash at launch; and the standalone internal app retained a live PID but returned an empty black framebuffer (SHA-256 `87af5bc9fb21b734bee8f15eb89ed59326a4c8b8b482364ca2d40df090c0d23f`).
- Verdict: `IMPROVED` — the authored cortex lesson now has a compiled, contract-checked direct I–VI focus grammar, but this run does not claim a visually proven integrated route.
- Blocker: the visionOS Simulator shell/render path is unhealthy. Build and contract receipts do not prove visible layer recomposition, gaze-and-pinch acquisition, stereo depth, comfort, comprehension, anatomical correctness, or clinical validity.
- Next safe action: recover one healthy visionOS Simulator runtime and capture `--proof-integrated-cortex` with `LAYER IV · 4 OF 6` visible before expanding the cortical lesson further.

## 2026-08-14 14:59 SGT — unhealthy Simulator launches now fail explicitly

- Target: recover a trustworthy visual receipt for the direct I–VI cortex lesson without accepting a stale or black immersive frame.
- Action: shut down the other visionOS Simulators, erased only the disposable `StrokeCare Proof Clean` device, booted it as the sole runtime, and tested both the integrated Stroke Care bundle and the smaller standalone internal bundle. Both independently triggered the same SurfBoard launch failure, isolating the blocker to the Simulator host/runtime rather than Stroke Care scene selection or asset size. Hardened `capture_simulator_route_proof.zsh` with a configurable launch deadline, captured stderr, and an explicit unhealthy-shell verdict so a stalled `simctl launch` cannot hang indefinitely or proceed to an old framebuffer.
- Evidence: the erased proof Simulator rendered its clean home frame, but both custom app launches failed with `FBSOpenApplicationServiceErrorDomain code=5` and `The system shell (SurfBoard) probably crashed`. `zsh -n`, `python3 Tests/verify_contract.py`, and `git diff --check` passed. A live harness run with `PROOF_LAUNCH_TIMEOUT_SECONDS=5` terminated in 7.7 seconds with `SIMULATOR_PROOF=FAIL launch exceeded 5s; Simulator shell may be unhealthy`, proving the new failure path.
- Verdict: `IMPROVED` — the visual gate remains closed, but deterministic proof runs now reject and explain this runtime failure instead of hanging or recycling an unrelated scene.
- Blocker: xrOS 26.5 Simulator SurfBoard still crashes when launching either custom visionOS app. No new cortex image, wearer interaction, comfort, anatomical, or clinical claim is accepted.
- Next safe action: restart the Simulator/CoreSimulator host after the xrOS runtime recovers, then rerun `--proof-integrated-cortex` and require `LAYER IV · 4 OF 6` in the fresh frame.

## 2026-08-14 15:18 SGT — selected dots and references occupy opposite fields

- Target: make the point-to-reference relationship read spatially without connector lines, wrapping labels, or a detached reference competing with the selected dot.
- Action: preserved the ten authored, structure-specific point targets and removed the remaining short source tethers from the region, flow, Atlas, and access invitations. A selected point now keeps its compact explanation on the same side, while both the complete 3D reference and its control card resolve to the opposite side of the hero brain. The six presenter checkpoints retain their existing ownership rule: region points at Orient, one access invitation at Access, and no repeated skull point through Covering, Make room, Checks, or Whole again.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-point-reference-opposite` succeeded. The contract now rejects any lesson/access tether token and requires the selected-point/opposite-reference placement rule.
- Verdict: `IMPROVED` — dots remain small, independently clickable targets outside the dense anatomy, while the teaching object reads as a separate structure on the other side instead of a line-labelled callout.
- Blocker: the xrOS 26.5 Simulator SurfBoard runtime remains unhealthy, so this run does not claim a fresh visual receipt, physical gaze-and-pinch reachability, stereo depth, comprehension, anatomical correctness, or clinical validity.
- Next safe action: after the Simulator runtime recovers, capture one left-side and one right-side selected point and verify the complete 3D reference swaps to the opposite field in both frames.

## 2026-08-14 15:31 SGT — the inside-vessel interruption becomes directly comparable

- Target: make the selected blockage lesson support purposeful investigation rather than stopping at a held model or inviting an unreviewed procedure simulation.
- Action: exposed the existing reversible route states as explicit `Compare open route` and `Return to interruption` actions, renamed the forward actions around the actual teaching sequence, and split lesson navigation from Explain/Save utilities so the controls remain legible. Added a persistent boundary stating that the comparison does not simulate cutting, treatment, efficacy, or patient flow.
- Evidence: both `python3 Tests/verify_contract.py` suites passed (`STROKE_CARE_CONTRACT=PASS`, `RBC_JOURNEY_CONTRACT=PASS`); both worktree `git diff --check` checks passed; the integrated generic visionOS Simulator build at `/tmp/strokecare-reversible-flow-comparison` succeeded. Fresh `--proof-family-blockage-interior` capture `/tmp/strokecare-reversible-flow-comparison-polished-20260814.png` passed visual metrics and route OCR 2/2 (SHA-256 `d88213b4deac677edb42061b085f8a2b538a6285a93efadadd1b9e49e9ed9c5d`). Visual inspection confirmed the interruption portal, qualitative route arrows, comparison action, downstream action, utilities, and return control render together without an added point-to-reference connector.
- Verdict: `IMPROVED` — the internal lesson now makes the open-route versus example-interruption comparison an obvious, reversible learner action.
- Blocker: Simulator proves deterministic state, layout, and rendering—not physical gaze-and-pinch acquisition, stereo depth, comfort, comprehension, anatomical correctness, clinical validity, treatment efficacy, or surgical skill transfer. Literal vessel cutting, rupture creation, medication-response animation, and outcome scoring remain outside this reviewed education slice.
- Next safe action: validate the three internal lesson transitions by gaze and pinch on a physical Vision Pro before authoring any clinically reviewed intervention animation.

## 2026-08-14 16:51 SGT — internal systems become a five-beat story

- Target: remove the crowded internal-brain control wall and make Cortex, Vessels, Deep structures, Ventricles, and Neural signalling understandable without repeatedly guessing what `Explore` means.
- Action: replaced the all-systems-first presentation with a five-beat `Story` that isolates one system, reveals three short lines progressively, and provides stable Previous/Next controls plus five chapter indicators. Added an optional `Compare` mode capped at three explicitly selected systems, with numbered ordering controls while preserving registered anatomical alignment. The destination action is now system-specific (`Enter Cortex`, `Enter Vessels`, and so on), orientation is stated as Anterior/Posterior, Superior/Inferior, and Left/Right, and the neural region copy was reduced without removing its schematic/not-a-patient-scan boundary.
- Evidence: both `python3 Tests/verify_contract.py` suites passed (`STROKE_CARE_CONTRACT=PASS`, `RBC_JOURNEY_CONTRACT=PASS`); the standalone internal app and integrated Stroke Care generic visionOS Simulator builds succeeded. Fresh `--proof-integrated-neural` capture `/tmp/strokecare-internal-neural-story-final-20260814.png` passed visual metrics and route OCR 2/2 (SHA-256 `5cd53dc2e6e408a25ca2041e8886aee5c33e192147b8bb56050c7b59237f02c4`). Visual inspection confirmed the neural circuit occupies the room, `BRAIN STORY · 05 / 05` is visible, the system-specific entry is legible, and the prior overlapping anatomy/control pileup is absent.
- Verdict: `IMPROVED` — the internal experience now has one dominant learning action, a clear five-part sequence, and an optional bounded comparison instead of showing every system and every control at once.
- Blocker: Simulator proves route state and rendering only. Freehand spatial rearrangement was intentionally not added because moving registered structures independently can corrupt their anatomical relationship; physical-device hand reach, gaze/pinch reliability, stereo depth, comfort, comprehension, anatomical correctness, and clinical validity remain unproven.
- Next safe action: validate Story navigation and the three-system Compare controls by gaze and pinch on a physical Vision Pro before adding any drag-based spatial rearrangement.

## 2026-08-22 21:19 SGT — local imaging becomes a spatial annotation plate

- Target: let a clinician bring a de-identified 2D reference image into the existing Imaging workspace, position it beside the brain, and annotate it without implying diagnosis, registration, or cloud handling.
- Action: added an explicitly confirmed Files picker and a direct drop zone for PNG, JPEG, and HEIC images up to 24 MB. The selected raster remains in memory only, reuses the existing plate move/scale/ink/undo/clear controls, and is cleared when the plate closes, the user leaves clinician mode or Imaging, the case returns, or the experience resets. The plate visibly states `LOCAL IMAGE · MEMORY ONLY` and `NOT UPLOADED · NOT INTERPRETED`.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-local-imaging` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-imaging-local-import-20260822.png` passed visual metrics and route OCR 3/3 at 3840×2160 (image SHA-256 `cef8cabccaab4adcb4079e6a36e1880dcd5cb740e82ba57822a245bf6e2f4748`) and was visually inspected with the local CT reference, privacy labels, central brain, and clinician Imaging rail visible together.
- Verdict: `IMPROVED :)` — the Imaging lane now supports a real local-raster workflow instead of only bundled atlas plates, while keeping the data and interpretation boundary explicit.
- Blocker: the deterministic proof uses bundled de-identified CT bytes through the same in-memory path. Simulator rendering does not prove the native Files/drop gesture, patient-data governance, physical placement comfort, clinical interpretation, or device interaction; XCAT was unavailable at 21:03 SGT. DICOM is not supported by this raster slice.
- Next safe action: on a reachable physical Vision Pro, import one de-identified PNG and verify choose/drop, grab, resize, annotate, clear, and the visible privacy label end to end.
- Layman equivalent: a doctor can now bring a safe local picture into the room, move it beside the teaching brain, and draw on it; the app neither uploads nor reads the picture for them.

## 2026-08-22 21:43 SGT — two local images share one spatial comparison board

- Target: advance the clinician Imaging lane from one imported raster to a genuine side-by-side spatial comparison without adding detached windows or implying that the app aligned two scans.
- Action: added an independent Local A and Local B import/drop path. Each PNG, JPEG, or HEIC is decoded under the existing 24 MB limit, held in memory only, and shown on the same movable, resizable, annotatable plate. The pair is visibly labelled `SIDE BY SIDE · NOT REGISTERED`; removing Local A clears both, removing Local B returns to the single-image state, and every existing role/category/case reset clears both payloads. Atlas selectors retire while local images are active so the board presents one coherent task.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-dual-local-imaging` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-dual-local-imaging-clean-20260822.png` passed visual metrics and route OCR 3/3 at 3840×2160 (image SHA-256 `94ad69bc0825b99d21eb4e5aa25899bc270dfd2c44223f82cd56fde7607b3b60`; app SHA-256 `be02f1c2158138388a52f1628105cb60e693dbf5613cacc16e62a081db2f5971`) and was visually inspected with Local A, Local B, the unregistered boundary, the central brain, and the clinician Imaging rail visible together.
- Verdict: `IMPROVED :)` — a clinician can now compare and mark two chosen reference images in the room while the app remains explicit that proximity is not registration or interpretation.
- Blocker: deterministic proof uses the bundled de-identified CT/MRI atlas images through the same two payload paths. Simulator does not prove Files/drop gestures, wearer reach, physical depth, patient-data governance, clinical interpretation, or XCAT comfort; DICOM remains unsupported.
- Next safe action: on physical Vision Pro, choose two de-identified raster images and verify Local A import, Local B import, grab, resize, mark, remove B, and close/reset end to end.
- Layman equivalent: two safe pictures can now sit together beside the teaching brain, but the app never claims that the pictures line up medically or tells the doctor what they mean.

## 2026-08-22 21:56 SGT — Local B becomes an independent spatial plate

- Target: let a clinician move two imported teaching images independently around the central brain instead of treating the comparison as one flat board.
- Action: added an explicit `SEPARATE INTO SPACE` / `REJOIN SIDE BY SIDE` transition. In the separated state, Local B has its own bounded position and scale, direct drag and magnify gestures, annotation layer, undo and clear controls, and visible `INDEPENDENT PLATE`, `MEMORY ONLY`, and `NOT REGISTERED` boundaries. Local A retains the complete import and privacy controls; the original attachment frame was corrected from 560×430 to its actual 620×650 view size so its controls no longer clip.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-detached-local-imaging` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-detached-local-imaging-clean-20260822.png` passed visual metrics and route OCR 3/3 at 3840×2160 (image SHA-256 `879be8d5754cae3653a163e6c8075f6561eb0759f6c40fd2fb07cfac8cbaaf87`; app SHA-256 `219656856cc6956f78154e40199c3f82e415b28a1c5add8ed4c5b4d247e3ca95`) and was visually inspected with Local B left, the generic brain central, and Local A right.
- Verdict: `IMPROVED :)` — imaging references can now become independently arranged spatial objects while retaining a reversible one-board comparison and explicit non-registration semantics.
- Blocker: the deterministic route proves separated state, composition, and rendering with bundled de-identified teaching images. Simulator does not prove native Files/drop behavior, two-hand reach, physical depth, annotation precision, patient-data governance, clinical interpretation, or wearer comfort; DICOM remains unsupported.
- Next safe action: on physical Vision Pro, import two de-identified rasters and verify Separate, independently drag/resize/mark A and B, Rejoin, remove B, and reset without losing control focus.
- Layman equivalent: the doctor can now pull the second picture off the comparison board, place it elsewhere in the room, draw on it, and snap it back beside the first picture; the app still never claims the two pictures medically align.

## 2026-08-22 22:04 SGT — selected anatomy points become bounded image discussion prompts

- Target: make the imported images useful in the live explanation without generating free-form findings or drawing misleading registration lines between a scan and the teaching brain.
- Action: added a manual `Attach selected point` action for Local A and Local B. It snapshots the selected point's existing authored title and bounded explanation into a compact plate-local card labelled `DISCUSSION PROMPT`, `FROM SELECTED POINT`, and `NOT AN IMAGE FINDING`. Each card can be removed independently, survives the source point being dismissed, and clears with its image or the teaching-view reset. No pixel correspondence, image analysis, or new clinical claim is created.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; the generic visionOS Simulator build at `/tmp/strokecare-point-linked-imaging` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-point-linked-imaging-clean-20260822.png` passed visual metrics and route OCR 4/4 at 3840×2160 (image SHA-256 `535ebf98edc1af0f32c5c8b72de786585e9bfa7755a0d24ecf58c10d895fe9a5`; app SHA-256 `a362baa8dde9206ce125da86d9ae2b336183e1e35558ebf79e5b4017f9b8823f`) and was visually inspected with one prompt on each separated local image and no redundant source explanation over the brain.
- Verdict: `IMPROVED :)` — a clinician can now carry one reviewed anatomy talking point onto either spatial image while the UI explicitly distinguishes conversation context from an image finding.
- Blocker: the proof uses bundled de-identified teaching images and an authored generic point. Simulator does not prove gaze/pinch acquisition, annotation legibility at wearer distance, patient-data governance, clinical interpretation, or that the discussion prompt is appropriate for a real case; DICOM and image registration remain unsupported.
- Next safe action: on physical Vision Pro, select a generic anatomy point, attach it separately to two de-identified images, move both plates, remove one prompt, rejoin, and confirm the labels remain readable without implying correspondence.
- Layman equivalent: a doctor can choose one safe explanation from the teaching brain and pin that explanation onto either picture, but the app clearly says it is a discussion note rather than something discovered in the scan.

## 2026-08-22 22:17 SGT — discussion prompts gain manual image markers

- Target: let a clinician indicate which part of Local A or Local B they are discussing without drawing a registration tether or implying that the app found anatomy in the pixels.
- Action: every attached point prompt now creates one compact A/B marker with a 52-point direct pinch target and a 27-point visible dot. Each marker can be dragged independently over its image, is stored in normalized image coordinates, remains in the correct half while A and B are joined, and follows B when it is separated. The prompt visibly says `MANUAL MARKER · FROM SELECTED POINT · NOT AN IMAGE FINDING`; removing the prompt or image also removes the marker.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the generic visionOS Simulator build at `/tmp/strokecare-imaging-manual-marker` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-imaging-manual-marker-20260822.png` passed visual metrics and route OCR 4/4 at 3840×2160 (image SHA-256 `6cb6d7b916283440c89cccf4ad50e521cccbef03274f55c01940281eaa9321a3`; app SHA-256 `94a0b05f052f7426ada16d5d9c593d3a15ecd4faafcd579087a70414cb753b57`) and was visually inspected with a small B marker over the left MRI, a small A marker over the right CT, no connector lines, and the teaching brain remaining central.
- Verdict: `IMPROVED :)` — a presenter can now point at a chosen area on either image and keep the corresponding authored talking point nearby, while manual intent and non-registration remain unmistakable.
- Blocker: Simulator proves deterministic state, layout, and rendering only. It does not prove physical marker acquisition, drag precision, depth comfort, real patient-data governance, image interpretation, anatomical correspondence, or clinical appropriateness; DICOM remains unsupported.
- Next safe action: on a physical Vision Pro, attach prompts to two de-identified rasters and verify that each A/B marker can be acquired, dragged to all four image quadrants, separated, rejoined, and removed without moving the plate or implying registration.
- Layman equivalent: the doctor can place a small movable pointer on either picture to show what they are talking about; the app never pretends that it detected anything in the picture.

## 2026-08-22 22:27 SGT — local teaching images declare their modality

- Target: stop presenting every imported brain image as a generic “X-ray” and make the two-image spatial workflow medically legible without attempting pixel classification.
- Action: added an explicit presenter-selected modality for Local A and Local B: CT, MRI, X-ray, Other, or Unspecified. Each compact control cycles directly by pinch, each spatial plate carries its chosen modality in the title and caption, and replacing, removing, or resetting an image returns its modality to Unspecified. The rail states `PRESENTER SELECTED · NOT INFERRED`; no filename or pixel analysis chooses the label.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-imaging-modality` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-imaging-modality-20260822.png` passed visual metrics and route OCR 4/4 at 3840×2160 (image SHA-256 `dd8338cfbcfa1702341560e5197e42df343f622784533775cc82f125de99f9ca`; app SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`) and was visually inspected with Local A labelled CT, Local B labelled MRI, independent plates, prompts, and manual markers.
- Verdict: `IMPROVED :)` — a clinician can now name what kind of teaching image they placed in the room, while the app remains explicit that the name is human-declared and the image is neither interpreted nor registered.
- Blocker: Simulator proves state, rendering, and deterministic labels only. It does not prove Files/drop, physical pinch reach, modality selection comprehension, real patient-data governance, clinical appropriateness, or image interpretation; DICOM remains unsupported.
- Next safe action: on physical Vision Pro, import two de-identified rasters, cycle each modality independently, separate and rejoin the plates, then remove/reset them and confirm both labels return to Unspecified.
- Layman equivalent: the doctor can say “this picture is a CT” and “this one is an MRI,” but the app never guesses from the picture or claims to read the scan.

## 2026-08-22 22:51 SGT — placed imaging gains a reversible in-room focus pose

- Target: make the placed CT/MRI image easy to inspect without the misleading `Open large view` action opening a separate generic 2D window.
- Action: replaced that action with `Focus image in room`. It snapshots the actual plate's current position and scale, moves that same local image into a stable central reading pose, keeps its modality, annotation, manual marker, and bounded prompt intact, and exposes `Return beside brain` to restore the exact prior transform. New imports, removal, reset, role changes, and closing the plate clear focus state safely.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-imaging-focus` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-imaging-focus-final2-20260822.png` passed visual metrics and route OCR 5/5 at 3840×2160 (image SHA-256 `c5b8459953232845639829254ca1d85a8e8e6b41d8fe8f8223775f68008311ee`; capture-reported app SHA-256 `5d046fb0db0ae76f896983685c7eaafab7676d12072f8295fd8eb0155331572b`) and was visually inspected with the complete focused CT plate central, independent MRI left, brain context behind, and the return control visible.
- Verdict: `IMPROVED :)` — the action now enlarges the image the presenter actually chose, in the spatial scene where they can mark it, and has an explicit escape that restores their layout.
- Blocker: Simulator proves deterministic state, layout, and rendering only. It does not prove physical reading distance, gaze/pinch reach, hand annotation precision, depth comfort, Files/drop, clinical interpretation, or patient-data governance; DICOM remains unsupported.
- Next safe action: on physical Vision Pro, import one de-identified raster, move and resize it, Focus it, annotate all four quadrants, Return it, and confirm its exact prior transform and controls remain reachable.
- Layman equivalent: instead of opening the wrong picture in another window, the doctor can pull the real chosen scan forward, write on it, and put it back exactly where it was.

## 2026-08-22 23:03 SGT — family entry starts with one spatial invitation

- Target: stop the Curious Learner route from presenting multiple prompts and a self-report control before the wearer has opened their first teaching point.
- Action: reduced the initial left-side rail to one direct action, `Start with one glowing point`, under a `BEGIN HERE` heading. The transient anatomy-attached cue now says `Look at one mint point, then pinch it`; follow-up exploration choices and the optional self-reported clarity control appear only after a real point selection. This remains authored navigation, not a diagnostic question, inferred anxiety score, or raw gaze model.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-family-entry` succeeded. Fresh `--proof-family-entry-hint` capture `/tmp/strokecare-family-entry-hint-final-20260822.png` passed visual metrics and route OCR 2/2 at 3840×2160 (image SHA-256 `c85319401332260f9dd065c97acbf4a1af01a227c542ac5303a2035350f75608`; capture-reported app SHA-256 `9020b071e4af77dd112fb4e87ac767d51ce9c8e0780efc7d57aa26fb77069722`) and was visually inspected with the single entry action, four quiet mint targets, and the brain central in the room.
- Verdict: `IMPROVED :)` — a newcomer can now see what to do first without decoding a stack of questions, sliders, or clinician controls.
- Blocker: Simulator proves deterministic state, layout, and rendering only. It does not prove physical gaze/pinch acquisition, readability at wearer distance, comfort, comprehension, clinical appropriateness, or device interaction.
- Next safe action: on a physical Vision Pro, start the Curious Learner route from cold launch and confirm one gaze-and-pinch on each mint point reliably opens the corresponding single teaching reference.
- Layman equivalent: when someone enters the app, it now tells them one simple thing: look at a glowing point and pinch it. The extra choices wait until they have something to react to.

## 2026-08-22 23:17 SGT — selected-point reference stays inside the readable field

- Target: keep the one full 3D teaching reference visually related to its selected point without an edge-clipped card, a connector line through the brain, or a second primary object competing with the anatomy.
- Action: inset the world-locked miniature and its companion explanation card toward the comfortable secondary field, then moved both slightly deeper while preserving the opposite-side rule. The selected dot still owns the left/right choice; the reference remains a separate full 3D object, not a 2D overlay or a patient-specific image.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-family-reference-position` succeeded. Fresh `--proof-family-affected-reference` capture `/tmp/strokecare-family-affected-reference-position-20260822.png` passed visual metrics and route OCR 2/2 at 3840×2160 (image SHA-256 `70ddb040d14fcf8e4451e9e5505ebd9ce4174b1d48ad654b456e601771de233b`) and was visually inspected with the brain central, the small local point card left, and the entire arterial reference plus `WHAT THIS OPENS` card visible on the right.
- Verdict: `IMPROVED :)` — a pinched point now opens one complete related object beside the brain instead of pushing that reference into the far edge of the room.
- Blocker: Simulator proves deterministic state, layout, and rendering only. It does not prove physical gaze/pinch acquisition on both brain sides, depth comfort, readable angular size, clinical interpretation, or anatomical registration on a Vision Pro.
- Next safe action: on a physical Vision Pro, select one left-side and one right-side point and verify that each full 3D reference remains entirely visible, reachable, and visually secondary to the brain.
- Layman equivalent: choose a glowing dot and the detailed teaching model appears fully on the other side of the brain, without a confusing line drawn across it.

## 2026-08-22 23:29 SGT — family point explanations stop asking a question

- Target: remove the intrusive `Want to read more? / Yes / Not now` decision from a selected teaching point while preserving a deliberate, safe narration boundary.
- Action: replaced the question framing with one direct optional action. A configured local guide offers `Play audio`; otherwise the same authored material offers `Read one layer deeper`. The card now explains that this is optional and silent when no proxy is configured. There is no auto-audio, microphone, recording, or change to the selected anatomy.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-family-direct-explanation` succeeded. Fresh `--proof-family-affected-reference` capture `/tmp/strokecare-family-direct-explanation-20260822.png` passed visual metrics and route OCR 2/2 at 3840×2160 (image SHA-256 `3d580113fbd93e73be08bae01686f8d8991f5f7d9493e3e0d1d45c81eb592247`; app SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`) and was visually inspected with `Optional written explanation` and one `Read one layer deeper` control only.
- Verdict: `IMPROVED :)` — a family learner can continue if interested, without being interrupted by a question or an unnecessary decline button.
- Blocker: Simulator proves deterministic state, copy, layout, and rendering only. It does not prove physical pinch reach, voice audibility, comprehension, preference for the reduced choice count, clinical appropriateness, or real Realtime proxy availability.
- Next safe action: on a physical Vision Pro, select a family point with and without the local guide configured and verify the single direct action remains easy to acquire, cancel after playback, and never starts itself.
- Layman equivalent: the app no longer asks the learner to decide something before showing the next idea. It simply offers one optional button if they want to go deeper.

## 2026-08-22 23:46 SGT — focused imaging becomes a quiet reading state

- Target: remove the surrounding checklist, reference rail, timeline, hand tools, and general presenter toolbar when a clinician intentionally brings a local teaching image forward.
- Action: focused imaging now suppresses unrelated explanation attachments, point callouts, free spatial notes, the generic ink plane, Scholar references, and clinician tools. The selected image, its optional independently placed comparison, plate-local manual markers and prompts, image-surface annotation, Close, and `Return beside brain` remain. Source selection, import, modality, and comparison-arrangement controls stay beside the brain and retire while the image is in its reading pose.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-imaging-focus-quiet` succeeded. Fresh `--proof-imaging-local-import` capture `/tmp/strokecare-imaging-focus-quiet-20260822.png` passed visual metrics and route OCR 4/4 at 3840×2160 (image SHA-256 `3972e63ac148cae28aa819068e3f3e7f5d26ad846a64971cd5f863c6ef5451a6`; app SHA-256 `c3291a2badf3243b8fb77784cdb4bcf46877bec8c81ceb677a6921de3a1aeeb5`) and was visually inspected with the CT plate central, the optional MRI plate left, no checklist/rail/timeline/control cluster, and a visible return action.
- Verdict: `IMPROVED :)` — bringing an image forward now changes the surrounding composition rather than stacking another interface on top of the explanation.
- Blocker: Simulator proves deterministic state, rendering, and process launch only. It does not prove physical reading distance, gaze/pinch reach, annotation precision, depth comfort, patient-data governance, image interpretation, or clinical appropriateness; DICOM remains unsupported.
- Next safe action: on a physical Vision Pro, place a de-identified raster and a comparison, Focus the primary image, annotate it, Return beside brain, and verify the clear visual state and the recovery action remain easy to acquire.
- Layman equivalent: when the doctor brings a scan closer, the other menus step out of the way so the scan is the thing everyone can look at.

## 2026-08-22 23:58 SGT — clinician references become a lower-right tab dock

- Target: replace the full-height Scholar reference rail with a compact secondary control surface that keeps the brain and a selected image visually primary.
- Action: converted Anatomy, Imaging, Access, Meds, Guides, and Model into six direct gaze-sized tabs in a two-row, three-column dock. The dock moved into the lower-right field and retains the existing real actions, selected state, and subfields. No category was made clickable merely for appearance, and focused imaging still suppresses the dock completely.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-scholar-dock` succeeded. Fresh `--proof-clinician-craniotomy` capture `/tmp/strokecare-scholar-dock-20260822.png` passed visual metrics and route OCR 2/2 at 3840×2160 (image SHA-256 `6005216a7ea2bec6ad69ffc27fed4f709f04dc38dd174158e5c6cc26359f82e6`; app SHA-256 `a5b57e7579776cb783277d1731848a988b7667b5edb85aa0301c831bb3c6dcb2`) and was visually inspected with six compact tabs in the lower-right visual field.
- Verdict: `IMPROVED :)` — the reference choices now read as a small spatial dock rather than a tall desktop sidebar, while retaining all already-authored routes.
- Blocker: Simulator proves state, rendering, and route OCR only. It does not prove physical gaze/pinch reach, tab discoverability, peripheral legibility, comfort, clinical appropriateness, or that any image/medication reference should be used for a real patient.
- Next safe action: on a physical Vision Pro, use each of the six tabs from the lower-right dock and verify all targets are reachable without drawing attention away from the central anatomy.
- Layman equivalent: the big list down the side became six clear buttons near the lower-right of the brain, like a small tool palette instead of a vertical menu.

## 2026-08-23 11:50 SGT — normal access story stops presenting a face-shaped shell

- Target: remove the giant face/skull silhouette that obscured the central generic brain during the normal clinician craniotomy teaching route.
- Action: the scalp and cranial-bone access meshes are now excluded from the normal teaching checkpoints at every visual-detail level. The route retains the generic brain, vessels, selected access invitation, and non-graphic protective-layer relationship; an isolated skull remains limited to the existing explicit Scholar registration-review state.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-craniotomy-clean-hero` succeeded. Fresh `--proof-clinician-craniotomy` capture `/tmp/strokecare-craniotomy-clean-hero-no-face-20260823.png` was visually inspected (3840x2160; SHA-256 `3bf66b63f4b92b7e5f3324e969967f923e013742599a8326ae442d022cd18787`) and shows no face-shaped scalp or skull shell in the default composition.
- Verdict: `IMPROVED :)` — the access explanation now reads as a brain-and-layer teaching story rather than an unrelated human-head model.
- Blocker: Simulator proves the deterministic composition only. It does not prove physical-device depth, legibility, skull-review discoverability, clinical validity, or suitability for patient-facing use.
- Next safe action: on a physical Vision Pro, compare the default access story with the deliberate Scholar skull registration-review state and confirm the former remains brain-led while the latter is clearly isolated and recoverable.
- Layman equivalent: the normal lesson now shows the brain, not a large person-shaped skull.

## 2026-08-23 11:50 SGT — right references return to one vertical tab rail

- Target: replace the repetitive two-by-three reference grid with the requested single right-side tab rail.
- Action: Anatomy, Imaging, Access, Meds, Guides, and Model now render as six tall, gaze-sized vertical tabs with one selected state and an understated arc. The active tab can reveal only its own compact subfields beneath it; all existing actions and the focused-imaging suppression rule remain unchanged.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the narrow generic visionOS Simulator build at `/tmp/strokecare-vertical-reference-rail` succeeded. Fresh `--proof-clinician-craniotomy` capture `/tmp/strokecare-vertical-reference-rail-20260823.png` was visually inspected (3840x2160; SHA-256 `25d49d9103d4e4652e520524a0cdf807237d42e9fc26eb758e66fb13a9a547bb`) and shows one slim vertical right-side rail with six readable tabs, one selected Anatomy tab, and no repeated grid.
- Verdict: `IMPROVED :)` — reference navigation again reads as a single right-side control surface rather than a duplicated-looking cluster.
- Blocker: Simulator proves rendering and deterministic state only. It does not prove physical gaze/pinch reach, peripheral readability, comfort, or clinician workflow usefulness.
- Next safe action: on a physical Vision Pro, open each of the six vertical tabs once, verify that the selected subfield is reachable and that focused imaging still suppresses the rail completely.
- Layman equivalent: the reference buttons are back in one neat vertical list on the right, with one active tab at a time.

## 2026-08-23 12:13 SGT — presentation fidelity becomes a secondary Settings choice

- Target: remove the vague visual-detail slider from the clinician explanation checklist so the left surface can stay focused on what a presenter should say.
- Action: removed the clinician visual-detail slider and its `CLINICIAN LENS` block. The existing right-side Settings reference now reveals three direct supporting-anatomy choices: Simplified, Standard, and Full. The rail explicitly says that this changes supporting geometry and motion, not the explanation or a patient claim. The teaching-model brief remains a deliberate secondary action inside Settings.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-presentation-settings` succeeded. Fresh `--proof-presentation-settings` capture `/tmp/strokecare-presentation-settings-20260823.png` passed route OCR 2/2 at 3840x2160 (image SHA-256 `c42419c0e892f1d0ce91c468d28e1d3e3337fdeea867f5b72205fa6f0a7337ca`; app SHA-256 `a9ba24e2208b20086160d8dd0b5f59520dc3556c21b44f378f45740df85c8394`) and was visually inspected with the language-only checklist on the left and Settings kept peripheral on the right.
- Verdict: `IMPROVED :)` — wording and visual fidelity now have different homes, so a clinician does not have to read a display-density control as part of the conversation.
- Blocker: Simulator proves deterministic route, rendered composition, and process launch only. It does not prove physical gaze/pinch reach, peripheral legibility, wearer comfort, patient comprehension, clinical appropriateness, or any inference about a patient.
- Next safe action: make one fictional atlas point select a concise 3D teaching object, such as an isolated neuron and its local connections, instead of opening a longer text explanation.
- Layman equivalent: the left panel now helps the doctor find clear words. The small settings tab on the right controls how much supporting anatomy is shown.

## 2026-08-23 13:20 SGT — one point opens a schematic neuron, not more copy

- Target: make a fictional brain-atlas reference spatial and inspectable rather than another text-only annotation, while keeping the brain central and the reference clearly generic.
- Action: added a fifth, point-led `Neuron` reference. Selecting it opens one simple 3D soma, dendrites, axon, terminals, and a qualitative signal cue in the opposite secondary field. Its short accompanying explanation now states that it is a generic schematic, not patient tissue, a recording, or a measurement. The deterministic capture route waits for mixed-space startup before taking the frame.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-neuron-reference` succeeded. Fresh `--proof-family-neuron-reference` screenshot `/tmp/strokecare-neuron-reference-20260823.png` passed route OCR 2/2 at 3840x2160 (image SHA-256 `adfc3952af7cd1ccb07505e5905e7c964e5304054b81aca00e7103d228f71319`) and was visually inspected with the brain central, the selected point card left, and a branching turquoise-blue-purple neuron reference in the right secondary field.
- Verdict: `IMPROVED :)` — choosing the neuron point now reveals a real, calm teaching object alongside the anatomy instead of asking the learner to read a longer label.
- Blocker: Simulator proves route state, layout, and rendering only. It does not prove physical gaze/pinch reach, peripheral legibility, depth comfort, biological accuracy beyond the stated generic schematic boundary, clinical appropriateness, or patient comprehension.
- Next safe action: on a physical Vision Pro, pinch the neuron point from both sides of the anatomy and verify that the secondary reference remains comfortably reachable, entirely visible, and clearly subordinate to the brain.
- Layman equivalent: pick the neuron dot and a simple, color-coded neuron appears beside the brain so you can see its branches rather than just reading about them.

## 2026-08-23 13:29 SGT — the neuron reference becomes object-first

- Target: remove the redundant secondary text card from the neuron teaching reference, leaving one local explanation and one inspectable 3D object.
- Action: marked the neuron as a self-contained spatial reference. Its selected-point card retains the short explanation and Hide action, while the duplicate `WHAT THIS OPENS` drawer is suppressed only for that schematic. Other references retain their existing drawer because they still need a compact relationship summary.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-neuron-object-only` succeeded. Fresh full `--proof-family-neuron-reference` receipt `/tmp/strokecare-neuron-object-only-final-20260823.png` passed at 3840x2160, route OCR 2/2, app build `29`, app SHA-256 `12001f481bfa630572641d86a3146f04e7ef5b287622055a9a826ae39a68448c`, and image SHA-256 `bdcac954e8534ffc67b3f0471782fb435dd93de86e52f85cc744af89c416d49d`. Visual inspection confirms the selected card on the left, the brain central, the schematic neuron right, and no duplicate right-side drawer.
- Verdict: `IMPROVED :)` — the neuron now reads as a thing to inspect in space, not a second floating article to read.
- Blocker: Simulator proves deterministic route state, process launch, and rendering only. It does not prove physical gaze/pinch reach, legibility, depth comfort, learning benefit, biological accuracy beyond the stated generic schematic boundary, clinical appropriateness, or patient comprehension.
- Next safe action: apply the same object-first rule to one other self-contained teaching object only after reviewing its current point card and deciding that removing its relationship drawer would not remove essential context.
- Layman equivalent: the neuron has one small label where you selected it and then the actual 3D neuron to look at. The extra popup beside it is gone.

## 2026-08-23 13:42 SGT — the neuron can now be explained in plain words

- Target: make the selected family neuron reference clearer without turning `Clarify` into a second, confusing explanation control.
- Action: kept `Clarify` as the explicit pause-and-question marker. The local selected-point fallback now says `Plain words`, and the single-neuron reference opens one concise authored explanation: its branches receive messages, one long fiber passes a signal on, and the colors are a teaching path rather than a recording. The same shorter fallback language is used in the family atlas, replacing the older “one layer deeper” labels.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-neuron-plain-words` produced the installable app. Fresh guarded `--proof-family-neuron-plain-words` receipt `/tmp/strokecare-neuron-plain-words-final-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `878d5d7bdedf682baf1f070e2e0619383a2c3dc90a4393b3e3fd74a0e20f5413`, and image SHA-256 `2821ceb64fd64c15612a522aac6cac510b2623021f872a28b117a3afd370dafd`. Visual inspection confirms the left card says `PLAIN WORDS`, the concise fallback is visible, the brain remains central, and the single 3D neuron remains right of the brain without a duplicate drawer.
- Verdict: `IMPROVED :)` — family learners can reveal a noticeably plainer, shorter explanation at the exact point they selected, while a separate Clarify control still has one unambiguous job.
- Blocker: Simulator proves deterministic route state, rendering, install, launch, running process, and screenshot OCR only. It does not prove physical gaze or pinch reach, readability at wearer distance, comfort, comprehension, biological accuracy beyond the stated generic schematic boundary, clinical appropriateness, or a live narration service.
- Next safe action: on a physical Vision Pro, compare the compact label and its Plain words fallback with a family learner, then decide whether the same local pattern improves one vascular reference without creating another text-heavy overlay.
- Layman equivalent: the neuron dot now has a small “Plain words” button. It explains the idea simply, while the separate “Clarify” button still just lets someone pause and ask a question.

## 2026-08-23 14:02 SGT — the expanded neuron card has one clear reading path

- Target: remove the last duplicated and awkwardly wrapped text from the selected neuron card after opening its concise family explanation.
- Action: the neuron card now hides its earlier technical summary only while the learner has opened `IN SIMPLE WORDS`. The expanded state contains one short explanation, one single-line `GENERIC TEACHING MODEL · NOT A PATIENT SCAN` boundary, a visible `Hide` affordance with the full accessibility label `Hide plain-language explanation`, and the existing separate `Hide single neuron` object action. Other point types retain their technical summary because their 3D references still need that local relationship context.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-neuron-simple-copy` completed successfully. Fresh guarded `--proof-family-neuron-plain-words` receipt `/tmp/strokecare-neuron-simple-copy-final-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `cd3558ea33ba21fdd047417f8c70e09ce70751f04407c16b3f440fa0ba148591`, and image SHA-256 `922876610087003422d5b1e37d87946a1b61f39e29f106be3b64d594c96a22f3`. Visual inspection confirms `IN SIMPLE WORDS`, a single explanation, a one-line safety boundary, a visible `Hide` control, the brain central, and the neuron in the right secondary field.
- Verdict: `IMPROVED :)` — the learner now sees one explanation at a time instead of a technical summary plus a second summary plus a meta label.
- Blocker: Simulator proves deterministic route state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze or pinch reach, wearer-distance readability, comfort, comprehension, biological accuracy beyond the generic schematic boundary, clinical appropriateness, or live narration behavior.
- Next safe action: compare this compact pattern with exactly one vascular reference on a physical Vision Pro before applying it more broadly; preserve the relationship summary wherever the 3D object would otherwise be ambiguous.
- Layman equivalent: after you ask for the simple explanation, the card no longer repeats the same idea in technical words. It shows one short explanation, one note that it is only a teaching model, and a clear Hide button.

## 2026-08-23 16:03 SGT — arterial reference becomes a compact spatial atlas cue

- Target: keep the full 3D arterial tree as the teaching object while removing the duplicate, text-heavy family drawer around a selected vessel point.
- Action: the family arterial reference now identifies itself as a `3D ATLAS`, gives one short instruction to follow the orange qualitative-flow cue into smaller branches, keeps the generic-teaching-model boundary visible, and reduces the route control to `ROUTE` plus its five-step progress. The full registered arterial tree, quiet whole-brain context, and selected-point card remain separate spatial objects; no connector line, patient claim, flow measurement, or treatment inference was added.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-arterial-compact` succeeded (with an existing unused-local warning in `StrokeSceneFactory.swift`). Fresh guarded `--proof-family-arterial-supply-reference` capture `/tmp/strokecare-arterial-compact-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `3d9ea717d594c16b7ca97648e0e1bae2638fbc0c640dc0e70f90ee01e5686295`, and image SHA-256 `f1beaaa749e705f4787a1676653cb7305c5368defabe788175284787e64b1a2c`. Visual inspection confirms the brain remains central, the selected point stays local on the left, and the full arterial tree with qualitative amber cues remains in the right secondary field beside the compact atlas card.
- Verdict: `IMPROVED :)` — the vascular lesson now asks the learner to inspect the 3D route rather than read the same relationship twice in separate cards.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, peripheral readability, depth comfort, comprehension, registered anatomy accuracy, clinical appropriateness, or patient-specific relevance.
- Next safe action: test the compact arterial cue with a human wearer on a physical Vision Pro and decide whether the full object, route controls, and selected-point card remain readable without competing for attention.
- Layman equivalent: choose a blood-vessel dot and the big 3D vessel map does the explaining. The small card just tells you to follow the orange path and lets you move through the five beats.

## 2026-08-23 16:28 SGT — visual detail becomes a compact Setting and the neuron stays object-first

- Target: keep the explanation surfaces about clarity of conversation, not display density, while making the fictional neuron atlas reference feel like an inspectable spatial object rather than a text panel.
- Action: retained the family `Again / Unsure / Clear` clarification control and moved visual-detail adjustment fully into the clinician `Settings` reference lane. The setting now uses two direct, gaze-sized previous/next controls around the current detail level and explicitly limits its effect to optional geometry and motion. The selected neuron point now says `ONE NEURON`, carries a shorter generic-model boundary, uses an object-specific hide action, and places/scales the isolated 3D neuron fully inside the right secondary field.
- Evidence: `git diff --check`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-settings-neuron` succeeded with one pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh `--proof-presentation-settings` capture `/tmp/strokecare-settings-20260823.png` passed route OCR 2/2 at 3840x2160 (app SHA-256 `89243cd3e30880d1e06535d53c4fc87ac248fafaf06e1a50cb8b51380d0ef2fe`; image SHA-256 `2431d01d078208f7c339325e86d1e90cd6b9a1b49ee34d57ad79a4f1d722d6dc`) and was visually inspected. Fresh `--proof-family-neuron-reference` capture `/tmp/strokecare-neuron-object-20260823.png` also passed route OCR 2/2 at 3840x2160 (image SHA-256 `57de6f057d530c2c100b97c452e92d87322d134116dd924575fed34f2d746dd8`) and was visually inspected with the brain central, the compact selected-point card left, and the 3D neuron fully in the right secondary field.
- Verdict: `IMPROVED :)` — the left-side conversation controls no longer compete with a visual-detail preference, and a teaching reference now reads first as something to inspect in space.
- Blocker: Simulator proves deterministic state, rendering, installation, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, peripheral readability, depth comfort, learning benefit, biological accuracy beyond the stated generic schematic boundary, clinical appropriateness, or patient comprehension.
- Next safe action: perform one physical-Vision-Pro usability pass that compares reach and legibility of the two Settings step controls with the selected neuron point, without expanding the teaching copy.
- Layman equivalent: the main panels now help someone explain clearly. The small Settings tab controls visual richness, and picking the neuron point gives you a real 3D neuron to look at instead of another long popup.

## 2026-08-23 16:39 SGT — plain-language follow-up becomes one shared spatial affordance

- Target: remove the remaining interface-writing around family explanations so an atlas point leads directly to a clear action and a concise explanation.
- Action: replaced repeated `A short, authored version...` descriptions in both the selected-point card and the family atlas cue with one consistent prompt: `PLAIN WORDS` and `Explain simply`. When narration is configured, the same location instead says `OPTIONAL AUDIO` and keeps playback explicitly opt-in. The content, generic-teaching boundary, timeline, anatomy, and 3D neuron behavior are unchanged.
- Evidence: `git diff --check`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-plain-words` succeeded with the same pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-neuron-plain-words` capture `/tmp/strokecare-neuron-plain-words-verified-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `1acc46027c9d19f7d60d6344b100e1317cbec4bb1e285fa7bd78d0dfa475ffb2`, and image SHA-256 `a1fa8fd43285475d9bdde76db90598631f373658ba20a4328c8df454c61d6638`. Visual inspection confirms the selected card says `ONE NEURON`, then `PLAIN WORDS`, then the explanation, with the 3D neuron in the right secondary field.
- Verdict: `IMPROVED :)` — the app now uses one simple phrase for the same choice everywhere instead of explaining the explanation before the learner can open it.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, wearer-distance readability, comfort, comprehension, narration usefulness, biological accuracy beyond the stated generic schematic boundary, clinical appropriateness, or patient comprehension.
- Next safe action: run one physical-Vision-Pro test of the `PLAIN WORDS` affordance with a family learner and retain it only if the person recognizes the action without extra instruction.
- Layman equivalent: instead of a paragraph that says an explanation exists, the app now simply says `PLAIN WORDS` and lets you open it.

## 2026-08-23 16:49 SGT — plain words now visibly traces the neuron’s qualitative route

- Target: make the neuron teaching reference explain one relationship in space, rather than asking the learner to infer the moving colours from the accompanying text.
- Action: opening the existing family `PLAIN WORDS` explanation now activates a thin amber guide and larger travelling amber cues over the neuron’s purple long-fiber path. The full branching schematic remains visible for context. This derives solely from the learner’s explicit request for the existing written explanation and turns off automatically after the point is changed or closed. It remains a generic qualitative teaching cue, not membrane voltage, a neuronal recording, patient tissue, a diagnosis, or a measurement.
- Evidence: `git diff --check`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-neuron-signal` succeeded with the same pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-neuron-plain-words` capture `/tmp/strokecare-neuron-signal-trace-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `03797271f88a9d731e8c6ad96d738a2f3ddbdd017c82f1cd5443d299157fc5cd`, and image SHA-256 `f0be345909d823d35086580e43f91e94762ffea5b9216c422ea02f1fdca288f4`. Visual inspection confirms amber route segments and travelling cues appear along the purple fiber only in the expanded `PLAIN WORDS` neuron state.
- Verdict: `IMPROVED :)` — the plain-language action now changes the anatomy reference in a quiet, meaningful way instead of only adding text.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, peripheral readability, depth comfort, comprehension, biological accuracy beyond the stated generic schematic boundary, clinical appropriateness, or patient comprehension.
- Next safe action: compare the ordinary neuron view and the `PLAIN WORDS` trace on a physical Vision Pro with one learner, keeping the trace only if the visual change is noticed without extra prompting.
- Layman equivalent: when someone asks for the simple explanation, a small amber route lights up on the long purple branch so they can see what the words are referring to.

## 2026-08-23 17:21 SGT — a surface explanation now reinforces the existing 3D patch

- Target: let a family learner’s explicit `PLAIN WORDS` request make the selected fictional brain-surface reference more legible in space, without adding another window, label cloud, or visual-detail control.
- Action: added one surface-only state boundary and a restrained pulse on the already-authored local surface patch. It activates only while the Family explanation is expanded for a selected surface point, stays local to that chosen patch, and stops with the existing point/lesson change. The full generic brain remains the context object in the right field. The cue explicitly does not segment tissue, identify a functional boundary, or imply a patient finding. The guarded capture route now gives this separately loaded full-surface teaching assembly an 18-second cold-start floor, preventing a premature room-only screenshot from being mistaken for a rendered lesson.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-surface-plain-words` completed for the edited app. A fresh guarded `--proof-family-read-more` capture with the resolved assembly passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `921f1e0dd85ba635609d5318265b686186be9b2948d820ca0c4a631be21fa113`, and image SHA-256 `a5fe3184a7b577b70f6c5b0aea8c1f63ff72dbacf1a074160d540aa70c7f57d1`. The default guarded capture then produced `/tmp/strokecare-surface-plain-words-receipt-20260823.png`; direct proof verification passed route OCR 2/2 with image SHA-256 `67415f10f7ada0143098d5e6fc211e357dfaab14cf1755a5e221fc9665be19b9`. Visual inspection confirms the selected outer-surface patch is visible on the secondary generic brain beside one concise `PLAIN WORDS` explanation.
- Verdict: `IMPROVED :)` — asking for simpler wording now causes the selected spatial reference itself to answer quietly, rather than merely adding more copy.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, wearer-distance readability, whether the subtle pulse is noticed, comfort, comprehension, biological accuracy beyond the stated generic teaching boundary, clinical appropriateness, or patient-specific relevance.
- Next safe action: compare the ordinary and `PLAIN WORDS` surface states with one physical-Vision-Pro learner and retain the pulse only if it improves recognition of the selected area without drawing attention away from the full brain.
- Layman equivalent: when someone asks for the simple version, the small teal patch on the teaching brain gently breathes so they can tell exactly what the words refer to.

## 2026-08-23 17:39 SGT — the internal atlas now anchors plain words in a real 3D system

- Target: make the Family Brain Atlas's combined internal reference more than a text card while preserving the source and clinical boundary that it does not separately segment a thalamus, hippocampus, or other chapter-named deep structure.
- Action: added a dedicated `PLAIN WORDS` state for combined internal Atlas chapters. It subtly enlarges and brightens the existing named `internal-ventricular-system` object while further quieting the already-present whole-brain context. The state is available only after an explicit Family request, returns to its normal material state when that explanation is dismissed or the selection changes, and never models cerebrospinal-fluid motion, ventricular pressure, disease, a functional map, or patient anatomy. Added one deterministic route and the matching cold-start readiness floor for this separate registered teaching assembly.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-internal-plain-words` succeeded. Fresh guarded `--proof-family-atlas-internal-plain-words` capture `/tmp/strokecare-internal-atlas-plain-words-20260823.png` passed route OCR 2/2 at 3840x2160, image SHA-256 `69ca8fcea19785867e72771ff0fbc912b3b5efdf6e7459da42a2ca6ac4cd5f2a`, and the launched process remained alive as PID `16852`. Visual inspection confirms the complete generic brain remains central, the selected combined internal reference sits in the secondary right field, and the Family Atlas card presents one concise plain-language explanation.
- Verdict: `IMPROVED :)` — the internal Atlas now lets the learner inspect a real part of the available 3D teaching assembly when asking for simpler wording, rather than relying on text to stand in for the object.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, whether the ventricular emphasis is noticed, depth comfort, learning benefit, anatomy registration, specialist approval, clinical appropriateness, or patient-specific relevance.
- Next safe action: have one physical-Vision-Pro learner compare the ordinary combined-internal reference with the `PLAIN WORDS` state and keep the emphasis only if they can identify its visual anchor without mistaking it for a labelled thalamus.
- Layman equivalent: the app does not pretend it can point to a precise thalamus. Instead, when you ask for simpler words, the real ventricular shape already inside the teaching model becomes a little clearer to look at.

## 2026-08-23 17:55 SGT — expanded internal plain words now recedes to the 3D reference

- Target: remove the repeated Atlas navigation and detail copy that still competed with the combined internal teaching object after a Family learner explicitly asked for plain words.
- Action: added one `isPlainWordsExpanded` composition state to the Family Brain Atlas. In that explicit state, the three-beat navigation chrome and secondary mini-lesson collapse into a short `ATLAS CONTEXT` line; the chapter arrows and drag gesture remain available, and the existing selected-object cue, concise explanation, and visible `GENERIC TEACHING MODEL · NOT A PATIENT SCAN` boundary remain. The visual-detail setting, anatomy claims, and interaction scope are unchanged.
- Evidence: `git diff --check`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-atlas-plain-words-compact` produced the complete `StrokeTime.app` bundle including its executable. Fresh guarded `--proof-family-atlas-internal-plain-words` capture `/tmp/strokecare-internal-atlas-plain-words-compact-20260823.png` passed route OCR 2/2 at 3840x2160 (image SHA-256 `1b8ceb35d8568b339f3a545edc33197f025c7e46832f4efb68510136298dccff`); the launched Simulator process remained alive as PID `51208`. Visual inspection confirms the full generic brain stays central, the selected internal reference remains in the right secondary field, and the left card contains visibly less repeated navigation copy.
- Verdict: `IMPROVED :)` — after choosing a simpler explanation, attention returns to the object and the one short explanation instead of a second on-card lesson.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and screenshot OCR only. It does not prove physical gaze/pinch reach, peripheral legibility, depth comfort, whether the reduced copy improves comprehension, anatomy registration, clinical appropriateness, or patient-specific relevance.
- Next safe action: run one physical-Vision-Pro comprehension pass comparing the compact `PLAIN WORDS` Atlas state with the ordinary Atlas state, without adding more controls.
- Layman equivalent: once someone asks for the simple version, the extra instructions get out of the way. They can still change chapters, but the model and the short explanation are what they see first.

## 2026-08-23 18:15 SGT — the generic brain surface is now a Family Atlas entry point

- Target: let a family learner select a broad, meaningful generic brain context by pinching the brain itself, while retaining the existing quiet dots and avoiding raw-eye-tracking, patient-specific labels, or fake precise lobe segmentation.
- Action: added a five-context `surfaceChapter` mapping for the pre-authored cortex, frontal, parietal, temporal, and occipital Atlas contexts. A confirmed standard focus-and-pinch on the generic brain surface in Family regions mode now resolves to the nearest of those same reviewed surface anchors, opens the optional Brain Atlas if needed, and reuses the existing selected point, local surface patch, and whole-brain teaching reference. Dots remain direct targets; procedure and vascular modes retain their existing interactions. Deep chapters such as hippocampus, thalamus, cerebellum, and brainstem are intentionally not fabricated as surface pick targets because the reviewed asset is a combined internal model.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-direct-surface-pick-20260823` produced a complete executable. Fresh guarded `--proof-family-atlas-direct-surface-pick` capture `/tmp/strokecare-family-atlas-direct-surface-pick-final-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `d3cd5900178c9c762da66fd9bdb51b30fe106818a2ae86c5a25bbbbb5bc0e700`, and image SHA-256 `333f388b7626a0594dba897829c9d63a6f51020c6818973f3d5fb0ef53559caf`. Visual inspection confirms a temporal surface selection, central generic brain, and a separate right-field whole-brain reference with a visible local teal patch. The launched Simulator process was PID `2463`.
- Verdict: `IMPROVED :)` — the brain is now an intentional spatial control surface for the same generic teaching contexts, instead of making learners rely only on floating dots or an Atlas panel.
- Blocker: Simulator proves the resolved state, rendering, install, launch, process survival, and route OCR. It does not prove that visionOS focus previews each region clearly on a physical headset, that a wearer can reliably pinch the intended broad context, that the generic patch is anatomically accurate, or that the interaction improves comprehension.
- Next safe action: conduct one physical-Vision-Pro pass that asks a family learner to select the temporal and frontal context directly from the brain without prior instruction.
- Layman equivalent: you can now look at the brain, pinch a broad area such as the side, and the app opens the matching teaching view. The little dots still work too.

## 2026-08-23 18:28 SGT — deep topics now name the model and the lesson separately

- Target: prevent a richly rendered but combined internal teaching mesh from looking like a precise, separately outlined thalamus, hippocampus, cerebellum, or brainstem.
- Action: added an explicit `usesCombinedInternalReference` boundary to the four deep Atlas chapters. Their card now leads with `Deep systems`, keeps the requested chapter as a smaller `TOPIC` label, and states `COMBINED INTERNAL MODEL · NOT A SEPARATE OUTLINE`. Surface chapters keep their existing direct, named region framing. No new anatomy, clinical claim, diagnostic behavior, or patient-specific labelling was added.
- Evidence: `git diff --check`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-deep-context-20260823` completed with the existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-atlas-internal-plain-words` capture `/tmp/strokecare-internal-atlas-deep-context-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `54eabd65f158322079cb489b180dce009f4dccf23500fbeda97458eed663fecf`, and image SHA-256 `63df73bc7cd8aaae627362b94a58f73f24e5611ae5155c75491c17d6b820015e`. Visual inspection confirms the new `Deep systems`, `TOPIC · THALAMUS`, and combined-model boundary are readable beside the central generic brain and the secondary internal reference.
- Verdict: `IMPROVED :)` — richer imagery now gives a more honest visual lesson: it tells the learner both what subject is being discussed and what 3D object is actually in view.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, and route OCR only. It does not prove physical gaze/pinch reach, headset legibility, depth comfort, learner understanding, separate-mesh anatomical accuracy, asset provenance, specialist approval, or clinical validity.
- Next safe action: source-review one separately segmented, high-detail deep-anatomy asset with clear rights and neuroanatomy review before introducing an isolated deep-structure visual in a clinician or research lane.
- Layman equivalent: if the app is teaching you about the thalamus, it now says that clearly, but it also tells you the picture is a larger internal-brain model and not a perfect thalamus-shaped cutout.

## 2026-08-23 18:51 SGT — the cerebellum Atlas chapter now reaches its dedicated 3D observatory

- Target: make the existing `Brainstem + cerebellum` Family Atlas topic lead to a richer spatial study state rather than leaving the learner with only a combined internal reference and text.
- Action: added one explicit `EXPLORE CEREBELLUM IN 3D` action after the learner reveals the chapter's combined internal reference. It opens the already-linked cerebellum observatory on its fold-and-arbor view, with optional Locate and Flow readings still available in that scene. The exterior card remains honest that the outer object is a combined internal model; the new room-scale scene is generic, not patient anatomy, histology, diagnostic segmentation, or measured flow.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-cerebellum-atlas-20260823` succeeded. Fresh guarded `--proof-family-atlas-cerebellum-journey` capture `/tmp/strokecare-family-atlas-cerebellum-journey-xray-20260823.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `2e5c9979e4bbda5af3804dae99a1bd96122d4a753ce5980dc4a4a76561736232`, and image SHA-256 `5c49f86d6dcf2fbe1fd2d41914054ec1dd020ee96c1eedfa4cf58f65764bdcef`. Visual inspection confirms the route arrives at `INSIDE · CEREBELLUM`, shows the distinct folds-and-arbor lesson, keeps Locate/X-ray/Flow as direct choices, and retains `Return to Stroke Care`.
- Verdict: `IMPROVED :)` — a deep Atlas topic now opens a dedicated, visually richer 3D learning scene through an explicit spatial action instead of relying on an unlabeled generic handoff.
- Blocker: Simulator proves deterministic state, rendering, install, launch, process survival, screenshot OCR, and the visible authored geometry only. It does not prove physical gaze/pinch reach, wearer comfort, peripheral readability, comprehension, biological realism, source-asset anatomical accuracy, specialist approval, or clinical validity. The linked internal-scene source is already dirty outside this checkout, so its rendering materials were not changed in this pass.
- Next safe action: inventory and rights-review one separately segmented, high-detail cerebellar source asset before increasing anatomical realism beyond this generic orientation observatory.
- Layman equivalent: after choosing the brainstem-and-cerebellum lesson, you can now press one clear button to step inside a dedicated 3D cerebellum scene, look at its folds and branching guide, try a flow view, then come straight back to Stroke Care.

## 2026-08-23 19:31 SGT — Internal anatomy now waits for its real USDZ hierarchy

- Target: make the clinician-only Internal focus show the bundled, higher-detail deep-structure and ventricular geometry instead of bouncing back to the compact exterior fallback while its assets decode.
- Action: preserved a requested anatomy focus through the compact-to-detailed scene swap, made the Internal reference a deliberately enlarged black-focus proof composition, reduced the exterior orientation shell, and aimed the existing key light forward so the authored PBR folds remain visible. The guarded Simulator proof route now waits for the entire registered asset sequence to finish, rather than taking a frame during the fallback handoff.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-internal-detail-focus-20260823` completed. Fresh guarded `--proof-anatomy-internal` capture `/tmp/strokecare-internal-detail-focus-20260823.png` passed route OCR 2/2 at 3840x2160 (`centre_nonblack=0.1100`, SHA-256 `b5fdbabcfec0c0905c990407701d402a11a92ca87a9f6c896df1aadb249d582c`); visual inspection confirms Internal is selected and the actual bundled deep anatomy is visible in the central study field. The Simulator process remained alive as PID `48294`.
- Verdict: `IMPROVED :)` — the high-detail clinician reference no longer presents a loading fallback as though it were the requested internal study, and its material form is more legible on the black focus field.
- Blocker: Simulator proves deterministic rendering, install, launch, process survival, and a screenshot only. It does not prove physical headset depth, comfort, gaze or pinch reach, anatomical registration, asset licensing, specialist approval, clinical appropriateness, or patient-specific realism. The high-detail reference remains generic and clinician-only; no graphic surgery, blood, or outcome simulation was added.
- Next safe action: source-review one rights-cleared, separately segmented deep-anatomy asset with a neuroanatomy specialist before adding more realism or individual internal labels.
- Layman equivalent: when a doctor asks to see inside, the app now waits for the real 3D inside model to finish loading, then shows it clearly under a studio-like light instead of showing a simpler placeholder and pretending it is the same thing.

## 2026-08-23 19:45 SGT — Internal Study now exposes its actual deep geometry

- Target: make the clinician-only `Internal` focus read as a high-detail study of the bundled deep-structure and ventricular assets, rather than an exterior brain made faint enough to suggest an inside view.
- Action: changed the explicit Scholar `Internal` state so it hides the registered exterior cortical shell while retaining the normal authored brain unchanged in Whole, Vessels, and Surface states. The bundled deep-structure and ventricular layers are now the visible central lesson object. This remains a generic teaching reference, not a patient scan, segmentation, diagnosis, treatment simulation, or a family-facing graphic procedure.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-internal-isolation-20260823` completed (with the pre-existing unused-local warning in `StrokeSceneFactory.swift`). Fresh guarded `--proof-anatomy-internal` capture `/tmp/strokecare-internal-isolation-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `4d4d66da23e121124efa03b89059e14c2251612fe078c91b6b3325d0a66710e0`, and image SHA-256 `67a47211be88d47a11533e241046e8de24b587d0f67515321d7fa42a5792b2a9`. Visual inspection confirms the central field now contains the separate high-detail internal geometry with the exterior cortex absent; the right rail shows `Internal` selected. The launched Simulator process was PID `78474`.
- Verdict: `IMPROVED :)` — the selected Internal view now visually means “look at the inside model,” not “look through a dimmed outside model.”
- Blocker: Simulator proves deterministic rendering, install, launch, process survival, and a screenshot only. It does not prove physical-headset scale, gaze/pinch reach, visual comfort, learning benefit, anatomy registration, asset rights, specialist review, or clinical validity.
- Next safe action: have a neuroanatomy reviewer assess whether the bundled deep-structure and ventricular meshes are suitable to describe as a generic internal teaching reference before adding more precise internal labels.
- Layman equivalent: choosing Internal now removes the outer shell so you can actually see the inside teaching model, like lifting the cover off a museum display.

## 2026-08-23 19:55 SGT — Internal selection now opens at a readable live scale

- Target: make the actual clinician interaction, not just a deterministic screenshot route, start the higher-detail Internal study at a scale where its bundled geometry is readable.
- Action: moved the Internal study's 1.70× minimum from `prepareAnatomyInternalFocusProof()` into `selectAnatomyFocus(_:)`. Choosing Internal now preserves any larger wearer-selected zoom instead of shrinking it. Whole, Vessels, and Surface retain their 1.28× minimum. The selection remains clinician-only, Scholar-gated, generic, and separate from the family explainer.
- Evidence: `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-live-internal-scale-20260823` completed with the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-anatomy-internal` capture `/tmp/strokecare-live-internal-scale-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `988d0099a37ef5b154276e7ed658ad6b9dc4130130fa07d17489273cdd7f9182`, and image SHA-256 `56586dffef433955fa4f29760fd16c65ecd3625c44f60aeeeb84c5e48377e38c`. The route now reaches its frame through the same selector a clinician uses; visual inspection confirms the separated deep/ventricular teaching geometry and selected Internal rail.
- Verdict: `IMPROVED :)` — the high-detail Internal presentation is now a real interaction affordance rather than a proof-only camera setting.
- Blocker: Simulator proves deterministic rendering, install, launch, process survival, and screenshot composition only. It does not prove physical-headset scale, comfort, gaze/pinch reach, wearer control discoverability, learning benefit, anatomy registration, asset rights, specialist approval, or clinical validity.
- Next safe action: run one physical-Vision-Pro interaction pass in which a clinician selects Internal after manually enlarging the brain, confirming that the app preserves their chosen scale and the controls remain reachable.
- Layman equivalent: when a doctor chooses the inside view, it now opens big enough to inspect and never shrinks a brain they already enlarged.

## 2026-08-23 20:22 SGT — the opening story now starts with the real 3D teaching brain

- Target: replace the flat opening-brain illustration with the existing high-detail, licensed generic teaching anatomy so the first spatial impression better matches the depth of the main Stroke Care experience.
- Action: used RealityKit `Model3D` to load the bundled `brain_anatomy_realistic_v2` USDZ at the first story beat, with the prior conceptual brain-and-vessel illustration retained only as the loading or missing-resource fallback. Reworked the opening composition into a readable left fact field and a separate right-side 3D brain, so the mesh no longer crosses the explanatory text. The model remains explicitly generic teaching anatomy and not a patient scan.
- Evidence: Apple’s current `Model3D` documentation supports async USD/Reality loading with a custom placeholder, which is the compatibility pattern used here. `git diff --check`, `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-prelude-real-hero-20260823` completed. Fresh guarded `--proof-spatial-prelude-hero` capture `/tmp/strokecare-prelude-real-hero-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `d98d75876dcaa6eab787b4c588f577de8b0665cc14fa0dea6f299922553a0b45`, and image SHA-256 `83a866c7c673ced6f522d7a4d325d7659d875a262c14e3e31264af232a8da32b`. Visual inspection confirms the actual folded 3D brain resolves beside, rather than over, the first readable story fact. The launched Simulator process was PID `58126`.
- Verdict: `IMPROVED :)` — the first encounter now visibly loads a real, inspectable high-detail anatomy asset rather than asking users to imagine the eventual 3D quality from a flat silhouette.
- Blocker: Simulator proves deterministic resource loading, rendering, install, launch, process survival, and screenshot composition only. It does not prove physical-headset scale, depth comfort, the quality of a wearer’s first impression, anatomical registration, asset licensing beyond the recorded notices, specialist approval, clinical appropriateness, or patient-specific realism.
- Next safe action: conduct one physical-Vision-Pro first-impression pass to assess whether the 3D hero’s scale and side-by-side reading composition are immediately legible without instruction.
- Layman equivalent: the app no longer opens with a cartoon brain. It opens with the same detailed 3D teaching brain used later in the experience, while keeping the words easy to read beside it.

## 2026-08-23 20:48 SGT — the immersive room now opens on the registered-v2 anatomy hero

- Target: prevent the main spatial explanation from initially reading as a low-detail procedural brain while the complete teaching assembly loads.
- Action: changed the compact immersive scene to load the same registered-v2 cortex, arterial tree, and illustrative clot as a temporary visual hero. The procedural root is hidden only when that real asset trio loads; the complete registered assembly still replaces it once ready and remains the only source of point fields, interaction targets, optional clinician layers, and review-bounded anatomy states.
- Evidence: Apple’s current RealityKit documentation confirms that `Entity(contentsOf:)` asynchronously loads USD and USDZ entities, which is the existing loading path retained here. `git diff --check`, Python compilation of `Tests/verify_contract.py`, and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-fast-real-hero-20260823` produced the app executable. Fresh guarded `--proof-family-entry-hint` capture `Proof/103-family-registered-v2-opening-simulator.png` passed route OCR 2/2 at 3840x2160, build `29`, app SHA-256 `311a7f744d2d39f75c0b504c015a3957f4bfed1343e2428c4163d4fb29031fa4`, and image SHA-256 `6afd7877f03e384362ef643ad07388c7d5da4d6f7d01ac73a4dc530786aafe13`. Visual inspection confirms the real folded cortex and arterial tree are present at the first family discovery cue.
- Verdict: `IMPROVED :)` — the early immersive view now has the same materially rich, registered-v2 anatomy language as the later explanation instead of visibly dropping to a simpler stand-in.
- Blocker: Simulator proves source-path selection, rendering, install, launch, process survival, and screenshot composition only. It does not prove headset frame time, physical scale, depth comfort, wearer perception, anatomical accuracy, asset rights beyond the recorded notices, specialist review, clinical validity, or patient-specific realism. Family mode remains intentionally non-graphic.
- Next safe action: run one physical-Vision-Pro cold-start pass to compare the real hero’s first-frame legibility against the former procedural placeholder before increasing material complexity or visual density.
- Layman equivalent: when the room first opens, you now see the real detailed brain and blood-vessel model straight away, not a simpler placeholder while the rest finishes loading.

## 2026-08-23 21:26 SGT — the selected vessel point now opens the authored arterial-lumen study

- Target: make the deliberate family-selected vessel action reach the app's bundled, high-detail artery cutaway instead of a dark generic blockage chapter.
- Action: changed `startContextualBlockageLesson()` so both the visible `Open vessel detail` action and the deterministic selected-blockage route call the linked internal journey's `startFlowRide()`. That route opens the authored arterial fork with layered vessel-wall geometry and red-cell teaching geometry. It remains generic, qualitative anatomy, and it is explicitly entered only after selecting the blockage point; it is not a patient scan, treatment simulation, or graphic procedure.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed; and the narrow visionOS Simulator build at `/tmp/strokecare-vessel-detail-20260823` succeeded. Fresh guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-family-vessel-detail-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `95003`, app SHA-256 `1c9c3b0ea91ea6d185bec092c017846e89fd788368fc0ae080d16cf274370bba`, and image SHA-256 `1e9fc6da755e84936cbf8408ea929142b8ba0b4cdce49466829c50f199ca2e27`. Visual inspection confirms the state reads `ARTERIAL FORK` and `You are inside a cerebral artery`, with the authored lumen/cell composition visibly present.
- Verdict: `IMPROVED :)` — the anatomy point now opens a materially richer vessel study through one clear, intentional action rather than implying high detail while showing a generic chapter.
- Blocker: Simulator proves route selection, bundled-asset rendering, install, launch, process survival, screenshot composition, and OCR only. It does not prove headset scale, comfort, gaze or pinch reliability, anatomical accuracy, biological flow realism, specialist review, asset rights beyond existing notices, or clinical validity.
- Next safe action: conduct one physical-Vision-Pro pass to assess whether the arterial-lumen scene is readable and comfortable at its intended scale before increasing realism or density further.
- Layman equivalent: choose the vessel point, then open vessel detail, and you now step into a much richer artery view with its wall and cell-like teaching geometry rather than a dark generic screen.

## 2026-08-23 21:43 SGT — the artery wall now leads the internal visual study

- Target: make the dedicated arterial-lumen teaching scene visibly more material and less foggy without adding graphic procedure content or claiming patient realism.
- Action: reduced the surrounding cortical-scaffold opacity from 0.58 to 0.20, lowered its animated variation, and increased the authored artery-wall material opacity from 0.18 to 0.36. The room-scale context remains available for orientation, but the existing artery-wall texture and cell-like flow geometry now lead the scene.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and both worktree `git diff --check` checks passed. The narrow visionOS Simulator build at `/tmp/strokecare-vessel-contrast-20260823` succeeded. Fresh guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-family-vessel-contrast-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `17412`, app SHA-256 `43224a6690e33f7560188760ba5ecdfda671b4bb18c02a0f4ae4a75c1a1f5ecc`, and image SHA-256 `346f2a522811ad0b343975c7f6ebfe2ff420cc2ec37b7292337e7830c145fa85`. Compared with the prior capture, visual inspection shows the foreground cortical fold overlay is no longer veiling the central artery wall, fork, and cell-like geometry.
- Verdict: `IMPROVED :)` — the current authored asset reads with stronger contrast and material definition while preserving its generic, calm teaching framing.
- Blocker: Simulator proves route selection, source integration, rendering, install, launch, process survival, and screenshot composition only. It does not prove physical-headset comfort, depth perception, wearer judgement of realism, anatomical accuracy, biological flow realism, specialist approval, asset rights beyond existing notices, or clinical validity.
- Next safe action: run one physical-Vision-Pro visual review of this single arterial study before adding any further material density or higher-resolution assets.
- Layman equivalent: the important artery is now the first thing you see; the surrounding brain context is still there, but it no longer looks like a grey curtain over the detail.

## 2026-08-23 21:55 SGT — the selected artery now renders as a solid PBR teaching surface

- Target: make the highest-detail bundled arterial-lumen asset read as a materially present 3D surface instead of a transparent conceptual shell.
- Action: retained the authored albedo, normal, and roughness maps for the inward-facing artery wall, but changed only that wall from transparent 0.36 blending with disabled depth writes to opaque blending with depth writes enabled. The surrounding cortex remains quiet, and the interior red-cell teaching geometry remains present. No graphic intervention, patient-specific anatomy, or physiological outcome claim was added.
- Evidence: Apple’s RealityKit material documentation states that `PhysicallyBasedMaterial.Blending.opaque` creates an opaque entity, and that depth writes control occlusion. `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and both worktree `git diff --check` checks passed. The narrow visionOS Simulator build at `/tmp/strokecare-vessel-opaque-20260823` succeeded, including the integrated external `RBCJourneyScene.swift` source. Fresh guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-family-vessel-opaque-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `36791`, app SHA-256 `3a694318444bc6c2f577792f270bb372934ad851ad61a41dc29e07433a4963e4`, and image SHA-256 `6a60c61d0efa7408dd5cfe3c7717e844d3b3ca06f08a458b7c8c80e37028994b`. Visual inspection shows stronger tissue-like texture and depth separation around the lumen than the prior transparent-wall capture.
- Verdict: `IMPROVED :)` — the source maps now produce a more materially defined artery wall while keeping the educational scene calm and navigable.
- Blocker: Simulator proves route selection, source integration, rendering, install, launch, process survival, and screenshot composition only. It does not prove physical-headset comfort, depth perception, wearer judgement of realism, anatomical accuracy, biological flow realism, specialist approval, asset rights beyond existing notices, or clinical validity.
- Next safe action: review one high-resolution, rights-cleared arterial asset candidate against this scene on a physical Vision Pro before replacing or increasing the geometry budget.
- Layman equivalent: the artery wall is now a solid textured surface you look through, rather than a transparent red filter over the scene.

## 2026-08-23 22:07 SGT — the whole-brain hero now keeps its material relief in the family room

- Target: make the shared registered-v2 brain read as a materially defined 3D object in the first family explanation, rather than looking flat whenever the experience uses Surroundings mode.
- Action: added a low-intensity neutral directional reveal light that is active only in Surroundings mode. It complements the existing Focus and warm-horizon key light, bringing out the authored cortex folds and arterial relief without changing the reviewed USDZ anatomy, adding a patient scan, or making the calm family route graphic.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `git diff --check` passed. The narrow visionOS Simulator build at `/tmp/strokecare-surroundings-reveal-20260823` succeeded (with the pre-existing unused-local warning in `StrokeSceneFactory.swift`). Fresh guarded `--proof-family-entry-hint` capture `/tmp/strokecare-family-surroundings-reveal-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `50523`, app SHA-256 `f72e95f6d72d85c9657f6fc8936599aef716777fcfc30aab01053653eba46396`, and image SHA-256 `b627031c101e9e45cf927e7ce2ae0cdc691e772d81327cfe97872bf61cfddfd8`. Visual inspection confirms stronger sulcal shadowing and vessel separation in the opening family-room composition.
- Verdict: `IMPROVED :)` — the same reviewed hero asset now has a more dimensional, higher-fidelity material read at the actual family-entry route, not only on a black focus field.
- Blocker: Simulator proves deterministic rendering, install, launch, process survival, OCR, and screenshot composition only. It does not prove physical-headset depth, comfort, wearer perception of realism, anatomy accuracy, asset licensing, specialist approval, or clinical validity. The current asset is generic teaching anatomy, not a patient scan.
- Next safe action: source-review one rights-cleared, high-resolution cerebral-surface asset candidate before replacing the generic hero mesh or increasing visual detail further.
- Layman equivalent: the brain is now lit like a real museum object in the room, so its folds and blood vessels are easier to see instead of reading like a flat pink shape.

## 2026-08-23 22:23 SGT — the registered cortex now keeps its authored texture without a waxy sheen

- Target: make the best available generic whole-brain asset read as a more materially grounded 3D teaching object without pretending that a vascular-only assembly is a more realistic brain.
- Action: audited the bundled USDZ candidates, retained `brain_anatomy_realistic_v2` as the only suitable whole-brain hero, and applied one PBR calibration recursively to that asset in both the compact opening hero and the complete assembly. The calibration keeps the authored geometry and albedo, makes the material non-metallic, raises roughness from the authored glossy baseline to `0.66`, and uses opaque depth-aware rendering. It does not add a patient scan, new anatomy, tissue cutting, or a claim of clinical realism.
- Evidence: the active brain USDZ contains an 11.9 MB USDC plus a 1254 x 1254 cortex albedo, with authored roughness `0.5`; it does not include a cortex normal or roughness texture. The adjacent `cranial_vascular_registered_assembly_v2` is a venous and neck-access reference, not a cortex replacement, so it was deliberately not substituted. `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `zsh -n Scripts/capture_simulator_route_proof.zsh`, Python compilation, and `git diff --check` passed. The narrow visionOS Simulator build at `/tmp/strokecare-brain-material-calibration-20260823` succeeded with the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-entry-hint` capture `/tmp/strokecare-family-brain-material-calibration-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `72980`, app SHA-256 `c9f4e1bbaa7bf5c82601db88cd74afed3a6bc04eabf1751b006564fc5f6098dd`, and image SHA-256 `56c81c574bcdc75ffa0ae10b54a9ba4692c46d7c66369572957a0bf94f95becc`. Visual inspection confirms the high-geometry folds retain more restrained, surface-defined lighting in the family-room route.
- Verdict: `IMPROVED :)` — the existing high-density brain now presents less like glossy clay and more like a deliberately lit generic anatomy exhibit, while retaining the correct hero asset and its authored texture.
- Blocker: this is a material pass, not a hyper-realistic anatomy upgrade. The current whole-brain source has no higher-frequency normal or roughness map, and its recorded third-party notice and specialist review gates remain unresolved. Simulator evidence does not prove physical-headset realism, comfort, anatomy accuracy, rights clearance, specialist approval, or clinical validity.
- Next safe action: source-review one rights-cleared, specialist-approved high-resolution generic cerebral-surface asset with explicit normal and roughness maps before replacing the current hero mesh.
- Layman equivalent: instead of swapping the brain for the wrong blood-vessel model, the app keeps the good brain and changes how light lands on it, so its folds look less shiny and more like a solid exhibit.

## 2026-08-23 22:56 SGT — the registered vessel tree now reads less like plastic tubing

- Target: improve the material read of the visible generic arterial and venous models, where the existing authored clearcoat was much sharper than the surrounding brain surface.
- Action: retained the existing registered-v2 vessel geometry and authored colours, then applied a recursive PBR calibration to the compact hero and complete anatomy assembly. It keeps the vessels non-metallic and depth-aware, raises surface roughness to `0.48`, and uses a restrained `0.06` clearcoat with `0.52` clearcoat roughness. No vessel geometry, lesion, blood-flow measurement, procedure, patient-specific anatomy, or clinical claim was added.
- Evidence: direct USD inspection found the authored generic artery material at roughness `0.42` with clearcoat roughness `0.03`, which explains its especially hard glossy finish. `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `zsh -n Scripts/capture_simulator_route_proof.zsh`, Python compilation, and `git diff --check` passed. The narrow visionOS Simulator build at `/tmp/strokecare-vessel-material-calibration-retry-20260823` succeeded. Fresh guarded `--proof-family-arterial-reference` capture `/tmp/strokecare-family-arterial-material-calibration-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `4739`, app SHA-256 `84c8368f7d6db0450e01fde72d39c5705346328bb4c2f1c833756ccc2c1fe931`, and image SHA-256 `1b47221ffad4f44a0fbd2bbf5609e135a7666a7922e0dbdb678125e15a96c8b7`. Visual inspection confirms the full generic arterial tree remains visible in the family reference route with a less glassy surface response.
- Verdict: `IMPROVED :)` — the visible vessel path now has a more restrained, light-responsive generic-tissue finish without faking higher-resolution anatomy or adding visual clutter.
- Blocker: this is a PBR material improvement, not a hyper-realistic vascular asset replacement. The current asset has no documented high-frequency texture package in the checked bundle, and the source, asset-rights, specialist-review, physical-headset, and clinical-validity gates remain separate and unresolved. Simulator proof does not establish wearer judgement of realism, depth comfort, anatomy accuracy, or biological flow realism.
- Next safe action: source-review one rights-cleared, specialist-approved cerebral-vessel asset with documented texture provenance before increasing vessel geometry or texture density.
- Layman equivalent: the blood vessels keep the same shape, but light now lands on them more like a carefully made anatomy model and less like shiny red plastic.

## 2026-08-23 23:31 SGT — the generic brain now holds its shape in the black focus field

- Target: make the highest-quality available generic brain asset read with more depth and surface separation in the app's default black presentation, without claiming a patient-specific or hyper-realistic clinical rendering.
- Action: kept the authored cortex texture and geometry, reduced its PBR roughness from `0.66` to a still restrained `0.52`, and added one low-intensity cool rim light that runs only in Black focus beside the existing warm key. The direct temporal-surface proof now uses the same default focus field a fresh learner sees. No skull, face, new anatomy, patient scan, tissue cutting, or blood-flow claim was added.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `zsh -n Scripts/capture_simulator_route_proof.zsh`, `python3 -m py_compile Tests/verify_contract.py Tests/verify_proof_image.py`, and `git diff --check` passed. The narrow visionOS Simulator build at `/tmp/strokecare-focus-material-rim-retry-20260823` succeeded with `BUILD_SUCCEEDED`. Fresh guarded `--proof-family-atlas-direct-surface-pick` capture `/tmp/strokecare-family-atlas-focus-material-rim-20260823-proof.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `36391`, app SHA-256 `9bd0d7ba924a0221c72fd5b3c8db42b3396283d0d4760895f37fc001407358bb`, and image SHA-256 `c7bf258e7c7a90137ddb7b25ec834b76322adba2f9d1d307bad353cb9eb2b8f6`. Visual inspection confirms the central cortex, arterial tree, and small secondary brain remain legible against black with clearer fold edges and silhouette separation.
- Verdict: `IMPROVED :)` — the real registered teaching model now has a more premium, high-contrast material read using RealityKit lighting instead of a falsely detailed substitute.
- Blocker: the bundled cortex still has no documented normal or roughness texture map, so this is not a hyper-realistic tissue upgrade. Simulator proof does not establish physical-headset depth, comfort, wearer judgement of realism, anatomical accuracy, asset-rights clearance, specialist approval, or clinical validity.
- Next safe action: source-review one rights-cleared, specialist-approved cerebral-surface asset with documented PBR maps before increasing texture or geometry density.
- Layman equivalent: the app has not pretended to get a new medical scan; it has made the existing brain model catch light more convincingly so the folds, vessels, and outline are easier to see.

## 2026-08-23 23:57 SGT — one cortical layer now takes the visual lead

- Target: make the internal cortical teaching view read as a high-quality spatial close study instead of a simultaneous overlay of layer bands, radial guides, vessel routes, and interaction targets.
- Action: kept the existing generic teaching geometry and the fuller Locate and Flow lenses, but made the layer-reading lens deliberately selective. It now sends the selected lamina slightly forward, reduces every unselected band to `0.055` opacity, and hides the outline scaffold, radial guides, vascular tree, and discovery target while that reading lens is active. The richer vessel routes and movement remain available in Flow, rather than competing with the layer lesson. This remains illustrative generic anatomy, not measured histology, a patient scan, or a claim of microscopic realism.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-cortical-reading-focus-v3-20260823` completed successfully. Fresh deterministic `--proof-integrated-cortex` capture `/tmp/strokecare-integrated-cortex-reading-focus-v3-20260823.png` was visually inspected at 3840x2160: the prior red vascular tree, green radial scaffold, and floating target are absent from the Layers view, leaving the selected curved layer as the visual subject. `Tests/verify_proof_image.py` still reports `wrong-route-content` because its OCR expects the title strings `Cortical microarchitecture` and `Six layers, many variations`, while the current attachment places those headings above the captured readable area; it is an automated proof-caption gate, not a build or rendering failure.
- Verdict: `IMPROVED :)` — the inside-brain layer lesson now has clearer spatial hierarchy and less synthetic visual noise, while preserving the richer anatomy context in the mode where it is meaningful.
- Blocker: Simulator proves the deterministic route, source integration, build, install, launch, rendered screenshot, and this screen composition only. It does not prove physical-headset depth, comfort, wearer judgement of realism, anatomical accuracy, specialist approval, asset rights, or clinical validity. The screenshot OCR title-position gate remains unresolved.
- Next safe action: move the existing cortical title into the deterministic readable frame, without enlarging its panel, so the route’s automated visual-proof check can verify the correct lesson state.
- Layman equivalent: when you choose a cortical layer, the app now quiets everything else so that one band is clearly in front of you; the busy blood-vessel map is still there when you switch to the blood-flow lesson.

## 2026-08-24 00:06 SGT — the cortical lesson now names itself inside the readable field

- Target: restore the missing context in the internal cortical reading route, where the selected layer was visible but the lesson heading began above the initial readable field.
- Action: gave only the `corticalMicroarchitecture` Layers lens its own attachment target at `[0, 1.68, -1.04]`. The existing heading, `Six layers, many variations.`, now enters the field with the existing region label and layer selector. No new panel, anatomy, patient data, clinical assertion, or interaction was added.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; both Stroke Care and linked internal-scene `git diff --check` checks passed. The narrow visionOS Simulator build at `/tmp/strokecare-cortical-title-placement-20260824` succeeded with the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-integrated-cortex` capture `/tmp/strokecare-integrated-cortex-title-placement-20260824.png` passed `Tests/verify_proof_image.py` route OCR 2/2 at 3840x2160, image SHA-256 `2ef684f5e83fd9f4c4d429cd6e2dc5569e4a80344721ba408d6312204f16ab02`. Visual inspection confirms `INSIDE · CORTICAL MICROARCHITECTURE`, the lesson title, selected Layer IV, and the quiet selected-layer composition are visible together.
- Verdict: `IMPROVED :)` — the learner can now tell what they are looking at before choosing a layer, and the deterministic visual proof confirms the intended internal-brain state.
- Blocker: Simulator evidence proves the route, rendering, build, and screenshot composition only. It does not prove physical-headset comfort, depth, gaze or pinch reachability, anatomy accuracy, specialist approval, asset-rights clearance, or clinical validity. The current cortical model remains a generic teaching composition, not high-resolution histology or a patient scan.
- Next safe action: source-review one rights-cleared, specialist-reviewed high-resolution generic cortical asset with documented geometry and PBR maps before increasing internal-scene realism.
- Layman equivalent: the app now clearly says “this is the cortex and these are its layers” before you start exploring, so you are not dropped into a beautiful but unexplained visual.

## 2026-08-25 01:33 SGT — the high-detail arterial route now opens with a visible assembly state

- Target: remove the blank black compositor seen while the bundled high-detail arterial-lumen scene assembles, without replacing its authored PBR geometry with a lower-fidelity stand-in.
- Action: added the existing truthful `journeyLoading` attachment and stable scene root before awaiting the linked internal scene build. The expensive USDZ assembly, optional prelude configuration, and spatial-audio setup now run in a task after `RealityView` returns; the veil stays visible until `isSceneReady` is set. The main contract now statically checks that loading veil precedes scene root, and scene root precedes the awaited build.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the linked internal `python3 Tests/verify_contract.py` passed with `RBC_JOURNEY_CONTRACT=PASS`; both worktree `git diff --check` checks passed. The narrow visionOS Simulator build at `/tmp/strokecare-loading-veil-20260825` succeeded (only the pre-existing unused-local warning in `StrokeSceneFactory.swift`). Fresh initial screenshot `/tmp/strokecare-family-blockage-loading-veil-20260825.png` visibly shows the loading message, `BUILDING THE BRAIN AROUND YOU`, over the textured arterial-wall source instead of a blank black compositor. A subsequent screenshot `/tmp/strokecare-family-blockage-loading-veil-settled-20260825.png` shows that the route progresses into the completed arterial/capillary teaching scene. The automatic first screenshot verifier reported `wrong-route-content` with route tokens `1/2`, because the long Simulator launch advanced the timed journey beyond its initial title before capture; this is not a full automated route receipt.
- Verdict: `IMPROVED :)` — first entry now communicates that high-detail anatomy is assembling rather than looking broken, and it resolves into the source-based teaching view.
- Blocker: the settled Simulator composition still needs a separate hierarchy pass before it can be called a premium high-realism view, and route OCR timing must be made deterministic. Simulator evidence does not prove physical-headset comfort, depth perception, wearer judgement of realism, anatomy accuracy, asset-rights clearance, specialist approval, or clinical validity. The scene remains generic teaching anatomy, not a patient scan or graphic procedure.
- Next safe action: freeze one intentional arterial-lumen stage before capture, then tune only its initial source-material composition so high-resolution wall detail is readable without the completed-journey overlay.
- Layman equivalent: instead of showing a black screen while the detailed artery is loading, the app now tells you it is building the brain around you and then continues into the lesson.

## 2026-08-26 01:53 SGT — guided arterial controls are clearer, but the corridor silhouette still needs isolation

- Target: make the internal arterial teaching route easier to follow without increasing text density or replacing the source-based PBR material.
- Action: reduced the guided lesson to one active takeaway, added a compact six-stop progress rail, and made the direct actions `Next stop` and `Pause` or `Resume`. Suppressed duplicate room-scale location lettering and retained the imported full cutaway only as a detached source of PBR maps and editable cell geometry. The surrounding cortical context was also reduced to a quiet 0.045 opacity.
- Evidence: the linked internal `python3 Tests/verify_contract.py` passed with `RBC_JOURNEY_CONTRACT=PASS`; main `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; both worktree `git diff --check` checks passed. The narrow visionOS Simulator build at `/tmp/strokecare-guided-flow-declutter-20260826` succeeded. Fresh guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-guided-flow-detached-20260826.png` visually shows the single `GUIDED JOURNEY 02/06` hierarchy and the new `Next stop` plus `Pause` controls. The automated image proof remained incomplete at route OCR 1/2 because the timed guide had advanced beyond its initial phrase, `You are inside a cerebral artery`, before capture.
- Verdict: `NEUTRAL :\\` — control hierarchy and duplicated lettering improved, but visual inspection still shows an oversized translucent native corridor silhouette around the artery. It remains more visually dominant than the intended artery-and-cell teaching subject, so this is not yet the clean internal composition requested.
- Blocker: the current screenshot proves a Simulator render and control state only; it does not prove physical-headset comfort, gaze or pinch reachability, perceived sound or haptics, anatomy accuracy, specialist review, asset rights, or clinical validity. The timed guide also prevents a full deterministic OCR receipt at the initial state.
- Next safe action: isolate the remaining native corridor ring in a dedicated deterministic internal-scene route, inspect one capture, and adjust only that geometry's visibility or scale.
- Layman equivalent: the buttons now clearly tell you what to do next and repeated labels are gone, but a large transparent ring is still crowding the view and needs its own focused cleanup.

## 2026-08-26 02:17 SGT — ambience begins only by choice, with semantic control confirmation where supported

- Target: add a calm, non-intrusive sound layer and tactile-style interaction confirmation without making sound mandatory or overloading a family-facing teaching experience.
- Action: changed the bundled ambience to start muted, added clear `Sound on` / `Sound off` controls at the doorway and in the spatial control rail, and only starts or stops the prelude bed after that explicit choice. Meaningful spatial bubble actions now register a 0.22-second-rate-limited semantic feedback request. The request uses system-managed `SensoryFeedback` only on visionOS 26 or later; the visionOS 2 baseline retains the visible selected state as the full interaction contract. Added an audio-provenance gate so the existing local WAV files are not represented as cleared for redistribution or App Store packaging.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build at `/tmp/strokecare-audio-optin-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-presenter-controls` capture `/tmp/strokecare-audio-optin-presenter-controls-20260826.png` passed route OCR 2/2; app SHA-256 `5d08a64eef789095735e3700756bba8e56c9312e9093c4a3fb2b08d121b2e763`, image SHA-256 `6aff501647b654a9093f5a37e4adb8046551128f69e4ef03d62841e844e3650c`. Visual inspection shows the `Sound off` control in the rendered presenter control field.
- Verdict: `IMPROVED :)` — a wearer now chooses whether the calm ambience begins, and primary controls have a native semantic-feedback path on supported systems without relying on sound or haptics as the only cue.
- Blocker: the two existing local WAV beds have no recorded authorship or redistribution terms; no third-party audio was added this pass. Simulator evidence proves source, build, route, and visible control state only, not playback level, spatial-audio perception, physical haptics, wearer comfort, anatomy accuracy, specialist review, asset-rights clearance, or clinical validity.
- Next safe action: replace or document the two local ambience beds using a rights-cleared source with an explicit licence and provenance record before any TestFlight or App Store package.
- Layman equivalent: the app now opens silently; pressing Sound on begins the calm background bed, and a control can give system feedback where the headset supports it, while the labels still make sense if no sound or tactile response is available.

## 2026-08-26 02:37 SGT — the presenter reference rail opens cleanly, then discloses only the chosen detail

- Target: remove the repeated tab-plus-subgrid hierarchy in the clinician's right secondary field while keeping anatomy focus, settings, imaging, and evidence actions reachable.
- Action: made the selected Anatomy and Settings tabs behave as explicit disclosures. The rail now opens as one slim vertical index; a selected inline category shows a disclosure chevron and reveals its compact controls only after an intentional tab action. CT/MRI choices remain on the one full imaging surface instead of being duplicated inside the rail. The deterministic settings proof initializes its selected disclosure deliberately, so it tests the expanded state without making the normal rail noisy.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build at `/tmp/strokecare-reference-rail-disclosure-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-presenter-controls` capture `/tmp/strokecare-reference-rail-collapsed-final-20260826.png` passed route OCR 2/2, image SHA-256 `20a3f9a2e37f69c31b1573fcfe9ea1bdb415ef1ff12ae6cda051ac64b9b416c4`. Fresh guarded `--proof-presentation-settings` capture `/tmp/strokecare-reference-rail-settings-expanded-20260826.png` passed route OCR 2/2, image SHA-256 `652c6afb192e99b3fe0744a528decd806e9f119265ceff48610ce3db66179a23`. Visual inspection confirms the default rail is a clean vertical list and Settings expands only on the selected tab.
- Verdict: `IMPROVED :)` — the reference rail is now a single readable index rather than a vertical rail with a permanently repeated second control group beneath it.
- Blocker: Simulator evidence proves build, deterministic route, rendered hierarchy, and process state only. It does not prove physical-headset reachability, gaze-and-pinch comfort, readability at a user's chosen room scale, real sound/haptics perception, specialist review, asset rights, or clinical validity.
- Next safe action: inspect one real-device clinician pass of the collapsed rail and one selected disclosure, then adjust only target spacing or type scale if either is hard to reach or read.
- Layman equivalent: the right side now starts as a neat menu. It only opens the extra Anatomy or Settings choices after you deliberately ask for them, so you do not see the same controls twice.

## 2026-08-26 03:23 SGT — the arterial-corridor cleanup is isolated, but not yet improved

- Target: identify and remove the oversized translucent oval that still dominates the first inside-artery lesson, while preserving the visible artery, route, cells, and paced family controls.
- Action: tested the two likely wrapper layers separately: the quiet surrounding cortical clone and the exterior cortical vault. Neither changed the captured oval. Then tested whether projecting the imported cutaway’s PBR maps onto the generated tube was the cause; the same primary silhouette remained. Reverted all three non-improving experiments so the scene behavior and its verified source-material contract remain unchanged. No new clinical content, patient data, procedural claim, or asset was added.
- Evidence: both linked internal and main `python3 Tests/verify_contract.py` checks pass, as do both `git diff --check` checks after the reversions. The narrow visionOS Simulator build at `/tmp/strokecare-arterial-hierarchy-v2-20260826` succeeded and guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-guided-flow-hierarchy-v2-20260826.png` passed route OCR 2/2 with image SHA-256 `33ca747ac0315abefc95f9a35368b78dee5719fab9ed03ecb8e6390e3e4634c3`; visual inspection still shows the oval. The subsequent build at `/tmp/strokecare-arterial-hierarchy-v3b-20260826` also succeeded, but its capture `/tmp/strokecare-guided-flow-hierarchy-v3-20260826.png` stopped at route OCR 1/2 because the timed guide had advanced to `Two paths share one source`; it still showed the same native tunnel silhouette. One temporary diagnostic build failed on an unterminated Swift string and was corrected and removed before the final passing checks. Final reverted-source build `/tmp/strokecare-arterial-revert-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`.
- Verdict: `NEUTRAL :\\` — the visual proof ruled out the cortical clone, exterior vault, and PBR projection as the dominant source. Keeping an unvalidated visual change would have made the product less trustworthy, so those edits were not retained.
- Blocker: the remaining shape is generated by the near-field `addInwardFacingTube` corridor itself. Simulator proof establishes code, build, process, and rendered pixels only; it does not establish wearer comfort, perceived scale, gaze or pinch reachability, sound/haptic perception, anatomical accuracy, clinical review, rights clearance, or clinical validity.
- Next safe action: add one deterministic, pause-held arterial-route proof state with only the native corridor’s near-field intima and media layers individually togglable, then inspect one screenshot to identify the exact layer before changing its radius or opacity.
- Layman equivalent: we checked three reasonable suspects for the giant ring. None was the actual cause, so we put those experiments back instead of shipping guesswork; the next test will inspect the tube walls themselves one at a time.

## 2026-08-26 04:09 SGT — imaging now distinguishes studies without trapping the presenter

- Target: let the clinician choose a compact teaching imaging reference beyond a generic X-ray image, open a plain-language term note with a named source, and always retain an obvious way back to the anatomy.
- Action: expanded the in-context teaching studies to CT, CTA, MRI, MRA, PET, and a generic vessel map. Replaced the system pop-up with a pinch-open in-place study deck, so the active image stays beside the brain. Pinching the displayed technical term opens one concise source note; the same target hides it again. Existing Close and Return beside brain actions remain available. CTA and MRA are authored generic vascular schematics, and PET is a functional-imaging overview; none is a patient scan, result, interpretation, or study-selection rule.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-imaging-modalities-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-modality-reference-20260826.png` passed route OCR 4/4 at 3840x2160, build `29`, process PID `17963`, app SHA-256 `4600e7ed349cbfdbdfddbd66b9585ecaa2bd04edf62f34bb3752ca6230591cef`, and image SHA-256 `9873c84c148024fd077226b791af9d68f6a8ffb1d29766c7b6e6da2be9604d03`. Visual inspection confirms the selected CTA plate, compact study control, term note, cited ACR source, vertical reference rail, and Close plus Focus image in room actions render together.
- Verdict: `IMPROVED :)` — imaging is now a compact teaching chooser rather than an X-ray-only surface or a second crowded row of tabs.
- Blocker: Simulator proof establishes source, build, route, process, and rendered pixels only. It does not prove Vision Pro gaze-and-pinch reachability, legibility at room scale, source-link interaction, clinical imaging choice, anatomy accuracy, specialist approval, asset rights, or clinical validity. Optical or infrared imaging and proton CT remain outside the core selector until they have reviewed teaching assets and a clear scope.
- Next safe action: perform one controlled Simulator interaction pass that opens and closes the study deck and its term note, then adjust only the relevant target spacing if any return action is unclear.
- Layman equivalent: instead of pretending there is one magic brain scan, the app now lets the presenter choose a clear teaching picture, explains the medical name in normal language, shows where that explanation comes from, and leaves a visible way to close or return.

## 2026-08-26 04:16 SGT — the open imaging note now names its way back

- Target: make the exit from a technical-term note understandable at a glance, without adding a duplicate close control or a new window.
- Action: renamed the open-state action from `Hide term note` to `Back to study` and changed its icon to a back chevron in both the anatomy-adjacent plate and the moveable teaching-imaging view. The exact same reversible state transition remains in place; the label now describes the destination rather than the implementation detail.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The narrow visionOS Simulator build at `/tmp/strokecare-imaging-return-back-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-return-back-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `26386`, app SHA-256 `f21633d0770cb1b8c14cf59a2e1ccf01f5282f9078ead7256d1747da91164ca2`, and image SHA-256 `8f97ea2cb5dd4cfc811ad63adb4835fe5bd656b9f32dc3c61cf27adfe2eb157d`. Visual inspection confirms the open CTA term note and its orange `Back to study` action appear together.
- Verdict: `IMPROVED :)` — a presenter can now see where the control leads before pinching it, which is clearer than a generic hide action.
- Blocker: Simulator proof establishes source, build, route, process, and rendered pixels only. It does not prove a physical Vision Pro wearer can comfortably gaze-and-pinch the target, that the external source link opens, or that any imaging content is clinically valid or patient-specific.
- Next safe action: run one real headset interaction pass over the study selector, term note, and return action, then adjust only the target that is hard to reach or read.
- Layman equivalent: the button no longer says “hide this.” It now plainly says “go back to the picture you were looking at.”

## 2026-08-26 04:38 SGT — arterial source-texture noise is gone, but the oversized corridor still needs geometry work

- Target: remove the bright broken oval from the first inside-artery lesson while retaining a calm arterial enclosure, qualitative flow, moving cells, and the paced family guide.
- Action: traced the large oval through the linked native arterial scene. The imported cutaway PBR texture had been projected onto a generated inward-facing tube with unrelated UVs, so that projection is now explicitly quarantined; its source remains available to the registered atlas. Reduced the generated intima and media shell opacity so the route, cells, and selected branch are not additionally veiled.
- Evidence: linked internal `python3 Tests/verify_contract.py` passed with `RBC_JOURNEY_CONTRACT=PASS`; main `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; both relevant `git diff --check` checks passed. The narrow visionOS Simulator build at `/tmp/strokecare-flow-corridor-quiet-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Baseline `/tmp/strokecare-flow-corridor-baseline-20260826.png` and fresh comparison `/tmp/strokecare-flow-corridor-quiet-20260826.png` show that the unrelated bright texture projection is gone, but the near-field generated tube still reads as a large translucent oval. Both guarded `--proof-family-blockage-interior` captures stopped at route OCR 1/2 because the timed guide had progressed to `Two paths share one source`; these are rendered visual comparisons, not full automated route receipts.
- Verdict: `NEUTRAL :\\` — the cleanup removes the geometry-incompatible texture noise, but it does not yet deliver the clear, premium arterial composition requested because the dominant silhouette belongs to the generated shell itself.
- Blocker: the current Simulator evidence proves source, builds, rendered pixels, and process state only. It does not prove headset-scale comfort, gaze or pinch reachability, audio or haptic perception, anatomical accuracy, asset rights, specialist review, or clinical validity. The timed guide also prevents a full deterministic OCR receipt for its initial message.
- Next safe action: create one pause-held internal proof that renders the intima and media shell layers independently, inspect one screenshot, then reauthor only the identified geometry as an open peripheral arterial enclosure.
- Layman equivalent: we removed a texture that was being stretched onto the wrong shape, but the remaining big ring is the shape itself. The next test will show one wall at a time so we can change the actual culprit instead of guessing.

## 2026-08-26 04:48 SGT — open-canopy corridor experiment was reverted after a visual regression

- Target: replace the full near-field arterial ring with a clearer peripheral enclosure while retaining the artery, moving cells, branch choice, and family guide.
- Action: made the generated main and branch shells render only their upper and side half, then captured the actual family blockage-interior route. The change exposed a black lower void and retained a visually dominant upper arc, so the geometry and related static assertions were reverted rather than kept.
- Evidence: candidate screenshot `/tmp/strokecare-flow-corridor-canopy-20260826.png` shows the black lower field and remaining oversized arc. After reversion, linked internal `python3 Tests/verify_contract.py` passed with `RBC_JOURNEY_CONTRACT=PASS`; main `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; both `git diff --check` checks passed. The candidate Simulator build at `/tmp/strokecare-flow-corridor-canopy-20260826` produced the rendered comparison; it is not retained product behavior.
- Verdict: `REGRESSED` — turning the existing tube into a half-shell removed some geometry but did not create a coherent arterial space, so it was deliberately removed.
- Blocker: the closed near-field tube has no suitable background once its lower geometry is removed. Simulator evidence proves source, build, and pixels only; it does not establish physical-headset comfort, depth perception, anatomy accuracy, rights clearance, clinical review, or clinical validity.
- Next safe action: prototype one new peripheral artery assembly with a deliberate backdrop and a detached forward branch, rather than deriving the learning space from a full tube around the wearer.
- Layman equivalent: we tried cutting the big ring in half. It left a black hole underneath and still looked distracting, so that version was not kept. The next version needs to be designed as an open scene from the start, not a sliced-up tunnel.

## 2026-08-26 05:07 SGT — arterial flow is now staged as an off-axis branching teaching object

- Target: replace the distracting full near-field arterial tube in the normal family lesson with a readable, non-enclosing artery-and-branch composition.
- Action: preserved the source tube only as a disabled fallback, staged a small transparent main artery with two detached branches against a quiet field, then moved and reduced the whole overview so it stays at arm's length instead of filling the viewer's forward field. The existing qualitative flow, selected route, moving cells, and guided controls remain in the scene; no clinical, patient-specific, or procedural claim was added.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; linked internal `python3 Tests/verify_contract.py` passed with `RBC_JOURNEY_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build `/tmp/strokecare-flow-peripheral-oblique-v3-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-flow-peripheral-oblique-v3-20260826.png` visually shows a compact branching artery instead of the old surrounding ring. Automated image proof was incomplete at route OCR 1/2 because the timed guide had progressed to `Two paths share one source` before capture.
- Verdict: `IMPROVED :)` — the visual composition now exposes the branch, route, and teaching guide without the former huge oval/tunnel surrounding the viewer.
- Blocker: the screenshot is Simulator visual evidence, not proof of headset-scale comfort, gaze or pinch reachability, sound/haptic perception, anatomy accuracy, rights clearance, specialist review, or clinical validity. The timed guide still prevents a full initial-state route-token receipt.
- Next safe action: run one deterministic Simulator interaction pass that opens and returns from the imaging study deck and technical-term note, then tighten only any unclear return target.
- Layman equivalent: the artery is now a smaller object in front of you that splits into branches, rather than a giant transparent tunnel wrapped around your view. The next check will make sure the image and explanation cards always have an obvious way back.

## 2026-08-26 05:15 SGT — imaging has an explicit state-clearing way back to anatomy

- Target: ensure the clinician can leave an imaging study, its technical-term source note, or a focused image without being trapped in a hidden annotation, comparison, local-image, or reading state.
- Action: introduced `returnToAnatomyFromSpatialImaging()` as the single outer recovery transition. The in-space plate and optional teaching-image workspace now say `Back` rather than an ambiguous `Close`. The visible navigation stack is now technical note → `Back to study`, focused plate → `Return beside brain`, placed image → `Back` to anatomy. The outer transition clears focus, comparison, temporary markup, and in-memory local imagery before restoring the anatomy reference category.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed after a test-only variable-name correction. Narrow visionOS Simulator build `/tmp/strokecare-imaging-back-recovery-v2-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-back-recovery-v2-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `91221`, app SHA-256 `48b43b9a0dc6dedcd38e3c03fc578a79eeb5e5a109b14d3313e6c637fc92a906`, and image SHA-256 `0a19db959e281d3e7de117cde5fb88f2ac3c62e5e763f9997472ff8cecbf92b8`. Visual inspection shows the selected CTA study, named source note, orange `Back to study`, and gray `Back` control together.
- Verdict: `IMPROVED :)` — every level of the imaging explanation now names where it will return, and the outer exit cannot leave behind a hidden focused or annotation state.
- Blocker: Simulator evidence proves source, build, route, process, and rendered controls only. It does not prove a wearer can comfortably gaze-and-pinch every target, that an external research link opens, or that any imaging reference is clinically valid, patient-specific, or a clinical imaging choice.
- Next safe action: add a deterministic post-return proof state that renders the anatomy explanation after the same recovery transition, then inspect one screenshot for stale-image or stale-annotation remnants.
- Layman equivalent: instead of guessing whether Close hides the picture or sends you somewhere else, you can now see the route back at every level, and the app forgets any temporary drawing or comparison when you return to the brain.

## 2026-08-26 05:23 SGT — the imaging Back route now has a clean-return receipt

- Target: prove that the same recovery transition used by the visible Back control removes a focused, annotated teaching study before returning to the anatomy explanation.
- Action: added a deterministic `--proof-imaging-return-to-anatomy` route. It opens the CTA teaching study, enables temporary annotation, enters the focused reading state, and then calls the shared `returnToAnatomyFromSpatialImaging()` transition. The proof route deliberately does not reset fields directly, so it exercises the wearer-facing recovery behavior.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build `/tmp/strokecare-imaging-return-recovery-20260826` succeeded with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-return-to-anatomy` capture `/tmp/strokecare-imaging-return-recovery-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `99695`, app SHA-256 `2826399561c5d779bb7e31fdf0e4892ac0a3cf03139d1175a42a90cfd2b2ece9`, and image SHA-256 `61f67d496cce94c32fa11d08e94eaa47f203e86bdcdaab48957e719089221d17`. Visual inspection confirms the returned anatomy scene retains its one selected discussion cue while no teaching-image plate, focus overlay, comparison plate, or temporary ink remains.
- Verdict: `IMPROVED :)` — the previously asserted recovery path now has a deterministic rendered receipt that catches stale imaging state in the anatomy scene.
- Blocker: Simulator evidence proves source, build, route, process, and rendered pixels only. It does not prove headset-scale gaze-and-pinch reachability, readability, physical-device persistence behavior, external source-link interaction, asset rights, specialist review, or clinical validity.
- Next safe action: perform one bounded Simulator interaction pass from the in-space Back control itself, then inspect only whether its target is legible and whether the returned point cue remains at a useful distance.
- Layman equivalent: the app now proves it can open a picture, zoom it, mark it, and then come back to the brain without leaving that picture or its markings stuck in the room.

## 2026-08-26 05:33 SGT — the optional imaging window now uses the same safe Back route

- Target: keep the optional 2D teaching-reference window from behaving as a separate exit path that can leave imaging state behind.
- Action: changed the workspace `Back` action to call `returnToAnatomyFromSpatialImaging()` before dismissing its window. The in-space plate and the moveable 2D companion now share the same cleanup behavior: close the study, clear focused/comparison/annotation/local-image state, then return to anatomy.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. The first capture install correctly failed because the temporary app bundle did not yet contain its executable; no launch was claimed. A completed narrow rebuild at `/tmp/strokecare-imaging-workspace-back-20260826` then reported `** BUILD SUCCEEDED **` and `BUNDLE_EXECUTABLE=PASS`. Fresh guarded `--proof-imaging-window` capture `/tmp/strokecare-imaging-workspace-back-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `10663`, app SHA-256 `6342a148ac9a9803144e57bc942f789186e2fcc25f2198f56e531dddcd7a52ba`, and image SHA-256 `1ebf5c9bae0151f2b3875c32bd0b84db6740c71f80bc6d7b4a72ee652dcf09bc`. Visual inspection confirms the compact 2D teaching-reference workspace presents one visible `Back` action beside the selected vessel-map study.
- Verdict: `IMPROVED :)` — the workspace no longer claims to return to anatomy while merely dismissing itself; both imaging surfaces now use one recovery contract.
- Blocker: Simulator evidence proves source, build, process, and rendered controls only. It does not prove a physical Vision Pro wearer can comfortably reach the Back target, actual gesture interaction, external-link behavior, asset rights, specialist review, or clinical validity.
- Next safe action: run one manual Vision Pro interaction pass that opens the 2D reference from the in-space plate and presses Back, then adjust only the target size or placement if it is hard to reach.
- Layman equivalent: even if the doctor opens the separate picture window, its Back button now cleans up the same way as the picture beside the brain, so there is no hidden image state left running.

## 2026-08-26 05:41 SGT — the optional source note expands without hiding either way back

- Target: make the optional teaching-image workspace support a concise technical-term explanation and named research reference without crowding the study image or trapping the presenter in the note.
- Action: added a deterministic CTA source-note route that opens the existing `CT angiography` term note on launch. The companion window grows only while that note is open, keeping the outer `Back` to anatomy and the local `Back to study` action visible at the same time. The CTA visual remains an authored generic vascular teaching reference; its ACR citation is a source for discussion, not a patient scan, interpretation, or care recommendation.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build `/tmp/strokecare-imaging-window-term-note-20260826` produced `BUNDLE_EXECUTABLE=PASS`. Fresh guarded `--proof-imaging-window-term-note` capture `/tmp/strokecare-imaging-window-term-note-20260826.png` passed route OCR 4/4 at 3840x2160, build `29`, process PID `18656`, app SHA-256 `a09236add6498ddccde01d503894cd6adae0812f58460782fe6f2b855234eb94`, and image SHA-256 `58a5dad3e9f119ca7a88a0a186a44e2e8b8c90012fdf95394efc33e5ee61fe6e`. Visual inspection confirms the open term note, ACR source label, CTA study graphic, `Back to study`, and outer `Back` are visible without clipping.
- Verdict: `IMPROVED :)` — a presenter can now move from a technical imaging term to a plain-language source note and see both available routes back, rather than having to infer how to leave the explanation.
- Blocker: Simulator evidence proves source, build, route, process, and rendered pixels only. It does not prove physical-headset gaze-and-pinch reachability, external-source-link interaction, reading comfort at room scale, asset rights, specialist review, or clinical validity.
- Next safe action: run one bounded interaction test that opens the CTA term note by its visible control, returns to the study, then presses the outer Back and verifies the anatomy scene is restored.
- Layman equivalent: the little “what does this medical word mean?” card now has enough room to explain itself, cite its source, and still makes both exits obvious.

## 2026-08-26 05:53 SGT — active image annotation now has a compact, explicit exit

- Target: prevent temporary markup from feeling like a stuck mode when a clinician finishes drawing on a generic teaching image.
- Action: replaced the active-state labels `Drawing on scan` and `Drawing on B` with one-line, checkmarked `Done` and `Done B` actions. The persistent nearby instruction now says that Done restores image movement. Added matching accessibility labels and hints, while preserving the existing temporary, non-measurement markup behavior and both Undo/Clear actions.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build `/tmp/strokecare-annotation-exit-v2-20260826` produced `BUNDLE_EXECUTABLE=PASS` with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-teaching-imaging` capture `/tmp/strokecare-annotation-exit-v2-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `32028`, app SHA-256 `fe911127e23047dc7ddf3d5e014832690f230947e60189e40f4c48cb0acb0b07`, and image SHA-256 `12e574125bb49475ba0ede4ec376bf4c0ddea6acc78acd64e89280e967970404`. Visual inspection confirms the orange checkmarked Done action remains one line beside Undo and Clear while active markup is visible on the generic CT/MRI teaching templates.
- Verdict: `IMPROVED :)` — the marking state now visibly tells the presenter how to leave it, rather than only describing that drawing is happening.
- Blocker: Simulator evidence proves source, build, route, process, and rendered controls only. It does not prove physical-headset gaze-and-pinch reachability, comfort, actual ink-drawing gestures, sound/haptics perception, asset rights, specialist review, or clinical validity.
- Next safe action: run one real-device clinician pass that enters annotation, creates one non-identifying mark, taps Done, and confirms the image can be moved again.
- Layman equivalent: while you are drawing, the orange button now says “Done” with a checkmark, so it is obvious how to finish and grab the picture again.

## 2026-08-26 06:04 SGT — active image marking now quiets the surrounding presentation

- Target: make focused teaching-image markup feel like a deliberate, reversible working mode rather than one more layer of controls competing with the brain and image.
- Action: treated both focused imaging and active annotation as one `imageWorkingMode`. While it is active, the timeline, role cue, viewpoint control, scholar rail, pinned annotations, ink-surface attachment, presenter controls, and clinician hand toolkit recede. The brain, selected teaching image or comparison, temporary markup controls, orange `Done` or `Done B`, and visible `Back` remain. Image movement controls are intentionally disabled only while marking, and Done restores the study-arrangement controls.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. The narrow visionOS Simulator `xcodebuild` command returned successfully and `BUNDLE_EXECUTABLE=PASS` for `/tmp/strokecare-annotation-focus-20260826`. Fresh guarded `--proof-teaching-imaging` capture `/tmp/strokecare-annotation-focus-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `44326`, app SHA-256 `cdee7420086e21ac9a2eebfc9e9c887d1bb273d3f870c596d310344b9f5a03b1`, and image SHA-256 `ee5d02166e7cd2e0739264f9f992a2906cf55fa19dab55656581d422f8bc323f`. Visual inspection shows the brain, one generic CT/MRI teaching-image pair, image-markup controls, Done, and Back without the right reference rail, presenter controls, timeline, or hand-tool controls.
- Verdict: `IMPROVED :)` — markup no longer competes with a second dashboard; the visible controls now serve one task and retain a clear exit.
- Blocker: Simulator evidence proves source, build, route, process, and rendered pixels only. It does not prove physical-headset gaze-and-pinch reachability, comfort, actual ink-drawing gesture behavior, haptic/audio perception, external source-link behavior, asset rights, specialist review, or clinical validity.
- Next safe action: run one physical Vision Pro clinician interaction pass that enters markup, adds one non-identifying mark, taps Done, moves the image, and presses Back.
- Layman equivalent: when someone marks a teaching scan, the rest of the room gets out of the way. They keep only the picture, the brain for context, a clear Done button, and Back.

## 2026-08-26 06:27 SGT — the imaging study deck now exposes modality choice without a competing dashboard

- Target: make it clear that imaging includes several generic teaching references, not only an X-ray-like image, while retaining a visible return to the brain explanation.
- Action: turned the vertical modality chooser into a temporary study-deck state. It now groups one selected route and six concise choices across structure, vessels, and function: vessel map, CT, CTA, MRI, MRA, and PET. Selecting one closes the deck and exposes only that study's existing technical-term note, named source, annotation, comparison, and local-image tools. While the deck is open, the plate hides those secondary controls and the surrounding presentation recedes; the outer `Back` stays visible.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. The narrow visionOS Simulator build at `/tmp/strokecare-imaging-study-deck-final-20260826` produced `BUNDLE_EXECUTABLE=PASS`. Fresh guarded `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-study-deck-final-20260826.png` passed route OCR 4/4 at 3840x2160, build `29`, process PID `71066`, app SHA-256 `1389496b511dbae813c133a85e6e4859ce98f4f69342677f4d4a113a25262818`, and image SHA-256 `897648c9fdee42b5169c4543171cf3387fbe3ca65226cc39a42dd09beefcab9a`. Visual inspection confirms the full vertical deck, selected CTA row, `STRUCTURE · VESSELS · FUNCTION` cue, and visible `Back` control fit together without the prior competing right rail or timeline.
- Verdict: `IMPROVED :)` — the imaging control is now a legible, reversible choice of teaching-reference type rather than an X-ray-first picker with duplicated controls.
- Blocker: Simulator evidence proves source, build artifact, route, process, and rendered pixels only. It does not prove physical-headset gaze-and-pinch reachability, readability at wearer scale, external-source-link interaction, actual patient imaging compatibility, asset rights, specialist review, or clinical validity.
- Next safe action: run one physical Vision Pro presenter pass that opens the study deck, selects MRI, opens its technical-term note, returns to the study, and then presses the outer Back.
- Layman equivalent: the app now first asks “which kind of picture are we learning from?” and gives six clear options. Once one is chosen, only the useful tools appear, and the Back button is always there to return to the brain.

## 2026-08-26 06:35 SGT — a technical imaging term now opens as a quiet, returnable source note

- Target: let a presenter pinch a technical imaging term, read its plain-language explanation and named source, and leave without competing image-arrangement controls or an ambiguous exit.
- Action: made `referenceDetailsVisible` a dedicated in-space reading state. The source note now owns its local orange `Back to study` action; while it is open, the study picker, local-image import, annotation, comparison, focus, and image graphic are withheld. The plate header retains the independent gray `Back` to anatomy transition. The optional 2D workspace preserves its existing local return path.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. The narrow visionOS Simulator build at `/tmp/strokecare-imaging-term-reading-20260826` produced `BUNDLE_EXECUTABLE=PASS`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-term-reading-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `80757`, app SHA-256 `1aaad894489a9554aba196d2df15f0132c00062424f01cdc937233e1cd83a295`, and image SHA-256 `59b0c89605befc1893d5521c1451f880bc796965b7fdff03c1519f96807bc404`. Visual inspection confirms the CTA term, plain-language note, ACR citation label, local `Back to study`, and outer `Back` without the earlier import, comparison, markup, or focus controls.
- Verdict: `IMPROVED :)` — a technical term now reads as a concise sourced teaching pause with two clearly named destinations rather than a dense imaging workbench.
- Blocker: Simulator evidence proves source, build artifact, route, process, and rendered pixels only. It does not prove physical-headset gaze-and-pinch reachability, external-link opening, readability at wearer scale, source suitability for clinical use, asset rights, specialist review, or clinical validity.
- Next safe action: perform one physical Vision Pro presenter pass that opens the CTA term note, presses Back to study, then presses the outer Back and checks the anatomy explanation has no remaining plate.
- Layman equivalent: when someone asks what a medical imaging term means, the app now pauses the other controls and shows one clean explanation card. It has one button to return to the study and one to go back to the brain.

## 2026-08-26 06:53 SGT — the family opening now begins with one reachable invitation

- Target: make the first family-facing spatial view match its promise to start with one calm, accessible anatomy invitation rather than a cloud of points and a full presenter control rack.
- Action: made the initial family discovery state expose only the selected field's default lesson point, give that point a clear emphasis, and keep the rest of the point field unavailable until the first selection dismisses the cue. Replaced the full family control rack during that held cue with a compact `One point at a time` acknowledgement and retained `Exit`; normal family controls return after the first point is selected.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build `/tmp/strokecare-family-first-point-rebuild-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-entry-hint` capture `/tmp/strokecare-family-first-point-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `98637`, app SHA-256 `bec8ab8022b4cb0c3605629b0aa9f0ba1df61fde1b4523a6403c140d397a3d83`, and image SHA-256 `17b19ae0f9071bbed00205a638d64b312988046ef89fd6b600961dd869840ae7`. Visual inspection confirms one bright point above the generic brain, the `BEGIN HERE` cue, and the compact family acknowledgement/Exit controls without the former Regions, Points, Atlas, Next, Pause, Clarify, or Point rack.
- Verdict: `IMPROVED :)` — the first family screen now directs attention to one clear spatial action instead of asking people to decode a full control system before learning starts.
- Blocker: Simulator evidence proves source, build artifact, route, process, and rendered pixels only. It does not prove physical-headset gaze-and-pinch reachability, point hit-target comfort, automatic-cue timing, audio/haptic perception, specialist review, asset rights, or clinical validity.
- Next safe action: run one physical Vision Pro family pass that selects the first point and confirms the remaining lesson points and normal family controls appear afterward.
- Layman equivalent: the app now starts by saying “look at this one bright dot first.” Once it is chosen, the rest of the lesson opens up instead of arriving all at once.

## 2026-08-26 07:00 SGT — the open imaging deck now names its local way back

- Target: remove the ambiguous chevron-only collapse affordance from the imaging study deck so nested navigation cannot feel like a stuck or duplicated state.
- Action: replaced the open deck's generic study toggle with an explicit `Close study deck` action. Its accessibility hint now says that it keeps the current teaching reference and returns to its image tools. The deck itself states the two-level hierarchy: closing the deck keeps the selected study, while the independent outer Back returns to anatomy.
- Evidence: `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; `git diff --check` passed. Narrow visionOS Simulator build `/tmp/strokecare-imaging-explicit-deck-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-explicit-deck-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `11445`, app SHA-256 `4664aeab248a3da72c479b925984200e9f858313036940caab6a064c39c01822`, and image SHA-256 `f55315cd6ae632cfb6a2b7c47718338be9b3e2bb44b543220bbcbdaa22947279`. Visual inspection confirms the cyan `Close study deck` action remains directly above the CT, CTA, MRI, MRA, PET, and vessel-map options while the separate gray `Back` remains visible on the plate edge.
- Verdict: `IMPROVED :)` — the two exits now say what they do, so closing a modality list cannot be mistaken for abandoning the anatomy conversation.
- Blocker: Simulator evidence proves source, build artifact, route, process, and rendered pixels only. It does not prove physical-headset gaze-and-pinch reachability, wearer-scale readability, source-link behavior, actual patient-imaging compatibility, asset rights, specialist review, or clinical validity.
- Next safe action: run one physical Vision Pro presenter pass that opens the deck, presses Close study deck, reopens it, selects MRI, and then uses the outer Back to confirm both destinations are distinct.
- Layman equivalent: the app now clearly says “close this list” instead of making someone guess what a tiny arrow does. The other Back still takes them all the way back to the brain.

## 2026-08-26 07:09 SGT — imaging study deck gets a quiet anatomy context

- Target: make a selected generic teaching image readable as a right-side working surface instead of competing with a dense, full-opacity anatomy scene.
- Action: established one stable right-secondary-field default for the imaging plate and softened the generic cortex, arterial, and venous teaching layers whenever an image study is open. The selected generic target remains visible only as orientation context; it is not presented as a patient finding.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-quiet-context-20260826` produced `BUNDLE_EXECUTABLE=PASS`; it retained only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-quiet-context-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `18472`, app SHA-256 `78709c0076777e54f6a56b90fe76f78300e3d1dced47b01384af20dd44fb104d`, and image SHA-256 `a8f63944a81c9902f1f12ecc463ff8f271114115e85bbb4e74230008c3491ae6`. Visual inspection confirms the vertical vessel-map, CT (X-ray), CT angiography, MRI, MR angiography, and PET deck owns the right field while the atlas recedes into a soft orientation silhouette.
- Verdict: `IMPROVED :)` — image learning now has one clear place to happen, with enough anatomy left to preserve context and no dense vessel web crossing the study deck.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch behavior, source-link behavior, compatibility with real patient imaging, asset rights, specialist review, or clinical validity.
- Next safe action: conduct one physical Vision Pro presenter pass that opens CT, MRI, and PET in turn, verifies the right-side plate remains readable, then uses the independent outer Back to return to the anatomy discussion.
- Layman equivalent: when someone opens an image, the brain quietly fades into the background instead of crowding the picture. They can still tell where the image belongs, but the image is now the focus.

## 2026-08-26 07:19 SGT — compact study deck removes repeated navigation copy

- Target: make the right-side generic imaging selector easier to scan without repeating the same instructions above and below the modality list.
- Action: removed the second explanatory card that appeared beneath the open study deck. The vertical deck now has one compact hierarchy: its structural, vascular, and functional scope; the current generic study; `Close: image tools`; and `Back: brain explanation`. It contracts to its own vertical index height while retaining vessel map, CT (X-ray), CT angiography, MRI, MR angiography, and PET.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-compact-deck-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-compact-deck-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `33104`, app SHA-256 `59e38796751d45abc73c4169cd5e684256884b33afeda6a5f5e6d4bcea39449f`, and image SHA-256 `e8d11913a918c0d109d475072a122b0280170e153de12375e524d11fc00eaf8f`. Visual inspection confirms the duplicate explanatory block is absent and the shorter deck keeps its six vertically ordered generic references, one selected state, explicit close control, and independent outer Back in view.
- Verdict: `IMPROVED :)` — the deck now communicates scope and recovery paths once, rather than asking the presenter to read two overlapping explanations of the same UI state.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch behavior, source-link behavior, compatibility with real patient imaging, asset rights, specialist review, or clinical validity.
- Next safe action: on physical Vision Pro, have a presenter open the deck, identify the current study, select MRI and PET, use `Close: image tools`, then use `Back: brain explanation` to check that the two exits remain distinguishable at wearer scale.
- Layman equivalent: instead of two signs explaining the same menu, there is now one short menu that says what image is selected and exactly where each way back goes.

## 2026-08-26 07:28 SGT — the first-use story names each next spatial scale

- Target: prevent the first-use anatomy story from advancing through a generic `Next` action that gives a learner no sense of what will appear next.
- Action: replaced the prelude's generic action with stage-specific, accessible labels: `See cortical columns`, `See signalling networks`, `See another scale`, and finally `Choose a path`. Each label has an accessibility hint that names the conceptual transition; the prelude remains floating text and anatomy rather than adding another opaque control window.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-prelude-named-next-20260826` produced `BUNDLE_EXECUTABLE=PASS`. Fresh guarded `--proof-spatial-prelude-hero` capture `/tmp/strokecare-prelude-named-next-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `44337`, app SHA-256 `9b6e51301bbfc793e84c12c102cdd4c8802338a3555fcb2635457b09bd98a25b`, and image SHA-256 `2817e4aec4cabd332cd2c8f0f90720e5ad3758f5e2d5882ebe0e753510f95dc6`. Visual inspection confirms the first beat presents floating anatomy and text in the room with `See cortical columns`, not an opaque panel or an unexplained `Next` button.
- Verdict: `IMPROVED :)` — the learner can now tell what a pinch will reveal before committing to the next story beat.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch behavior, audio/haptic perception, specialist review, asset rights, or clinical validity.
- Next safe action: run one physical Vision Pro first-use pass through all four named actions and confirm that the destination wording remains readable and matches each revealed scene.
- Layman equivalent: the story now tells you where it is taking you before you press the button: first the brain’s outer columns, then its networks, then a new scale, then your chosen path.

## 2026-08-26 07:37 SGT — technical imaging terms now declare their source role before leaving the app

- Target: make a pinch-open technical term note visibly distinguish a research atlas, guideline context, or public-science overview instead of presenting a bare citation that could be mistaken for a result or instruction.
- Action: added concise provenance types to every generic teaching reference. External source actions now read `Read open research atlas`, `Read guideline context`, or `Read science overview`, followed by the named source. Authored vessel maps stay honestly marked as authored teaching diagrams. The term note still keeps its local orange `Back to study` and the independent gray outer `Back` to anatomy.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-source-action-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-source-action-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `59716`, app SHA-256 `a66c88c3d937d71d3cb654f583415b47ef647889fc45b4c93eb19a317fe3480a`, and image SHA-256 `8ccc88294ea6295bbe78e9b17bb8b40bdf6fd0a7b02f45b49bdba33e746037fc`. Visual inspection confirms the CTA term note shows `GUIDELINE CONTEXT`, `Read guideline context`, the named ACR source, `Back to study`, and the outer Back without reintroducing the study controls.
- Verdict: `IMPROVED :)` — technical vocabulary now opens into an explicit, safely framed reference path rather than a passive citation line.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, external-source opening behavior, gaze-and-pinch quality, asset rights, specialist review, or clinical validity.
- Next safe action: perform one physical Vision Pro presenter pass that opens the CTA term note, reads the source role, presses `Back to study`, and then uses the outer Back to return to anatomy.
- Layman equivalent: when someone asks about CTA, the app now says that the source is guidance context, gives a clear link to read it, and leaves two clearly named ways home.

## 2026-08-26 07:49 SGT — a term note now brings the actual teaching plate forward, then returns it cleanly

- Target: make a pinch-open term note readable at room scale without creating a second dashboard, leaving the working image stranded in the centre, or retaining a stale note after outer Back.
- Action: opening a technical term now uses the existing reversible plate-focus transform to bring the same generic teaching image forward. The source-reading header explicitly says `FOCUSED TERM NOTE` and `Reading position · source note`; image drag and resize are withheld while reading. `Back to study` restores the prior beside-brain placement when the note introduced the focus. Outer Back also clears local source-note state, preventing it from reappearing when another study opens.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-term-focus-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-term-focus-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `77559`, app SHA-256 `5d43284f591af7219185d58606ab43720e7dfa3c67a508c550f5bc93385178f3`, and image SHA-256 `12f541dbd7c00bbfaca2c9b7f8bfcda8610cb8a3d7eed77598c0c2605619cd56`. Visual inspection confirms a central `FOCUSED TERM NOTE` CTA composition with `GUIDELINE CONTEXT`, `Read guideline context`, orange `Back to study`, and a separate gray outer Back while the study deck and image-arrangement controls are absent.
- Verdict: `IMPROVED :)` — a term now becomes a calm, legible reading moment over the same spatial reference, then has an explicit route back to the original explanation layout.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, external-source opening behavior, gaze-and-pinch quality, source suitability for clinical use, asset rights, specialist review, or clinical validity.
- Next safe action: run one physical Vision Pro presenter pass that opens a CTA term, confirms the plate comes forward, uses `Back to study`, reopens the plate, then uses outer Back and verifies no stale source note returns.
- Layman equivalent: tap a hard medical word and the same picture moves closer so you can read it. Press Back to study and it goes back to where it was; leave the image entirely and the note does not get stuck for next time.

## 2026-08-26 08:04 SGT — the default inside-brain lesson is now a floating cue, not a dashboard

- Target: let a learner remain visually inside the generic anatomy environment while understanding the current story beat, its next action, and the one reliable way back.
- Action: removed the default journey's opaque glass container and its always-on systems selector. The first interior beat now uses a floating heading, one supporting sentence, a small cue to choose a region below, one detail toggle, one stage-specific next action, and `Return to Stroke Care`. The fuller systems lens remains available only after a learner intentionally enters a related region; the region reel no longer has a second glass panel behind it. Removed the confusing default `Save` action from this story state.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-internal-floating-cue-dd` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-integrated-interior` capture `/tmp/strokecare-integrated-interior-floating-cue-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `325`, app SHA-256 `ec11ed8ed682c63cab51c2922ac804bb9c36b36f4cbd1de43513f3c27a15fc18`, and image SHA-256 `cd2c3ee8bc549337906c32c3acf9b0d4d0ed10ee81f2b9c31cd0a77236c0c692`. Visual inspection confirms the supply-network lesson floats directly over the internal teaching scene with `Show example interruption`, `One detail`, and `Return to Stroke Care`, without the former large opaque HUD.
- Verdict: `IMPROVED :)` — the default inside-brain state now reads as an authored scene with one next step instead of a full control window placed in front of the anatomy.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch behavior, source suitability for clinical use, asset rights, specialist review, anatomical accuracy, or clinical validity.
- Next safe action: capture the explicit cortical regional lesson and inspect whether its opt-in systems controls still read as one intentional learning surface.
- Layman equivalent: instead of placing a big menu in front of the brain, the app now gives you a short sentence, one button for what happens next, and one button to leave. The detailed controls appear only after you choose to explore a region.

## 2026-08-26 08:17 SGT — the optional imaging source note now has one clear way back

- Target: prevent the optional imaging window from leaving a source note open, duplicating return controls, or trapping a presenter in a nested reading state.
- Action: while a term note is open, the teaching-study picker and term button are withheld and replaced by a small `SOURCE NOTE` state label. The note owns its orange `Back to study` action; the persistent gray outer `Back` first clears local note state, then returns to anatomy and dismisses the optional window.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-window-local-back-r2-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-window-term-note` capture `/tmp/strokecare-imaging-window-local-back-r2-20260826.png` passed route OCR 4/4 at 3840x2160, build `29`, process PID `20408`, app SHA-256 `b80b455535c6ea43abf49c05454983ecb5a93ab55b894ab844f36af1fb7193f9`, and image SHA-256 `eafe2feda88a043ea051d3608be3eb26b5a6f42e51ce204b44a1ffcb0e716b1b`. Visual inspection confirms CTA, `SOURCE NOTE`, one orange `Back to study`, and the separate outer Back are simultaneously legible without the study controls being duplicated.
- Verdict: `IMPROVED :)` — opening a technical term now produces one predictable reading state with an explicit local return and a clean global exit.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch quality, external-source opening behavior, source suitability for clinical use, asset rights, specialist review, or clinical validity.
- Next safe action: capture a reopened ordinary teaching study after `Back to study` to prove the selected reference restores without residual source-note state.
- Layman equivalent: open a medical word and the image controls pause while you read. The note gives you one button to go back to that image, and the main Back always takes you out cleanly.

## 2026-08-26 08:27 SGT — the in-space imaging source note is now one surface, not two

- Target: remove the repeated source-note shell and repeated navigation sentence from the primary clinician imaging plate while preserving a local return to the selected image and a global exit to the brain explanation.
- Action: retained the focused-reading state and the term card's named source, plain-language annotation, deliberate external-source link, and orange `Back to study`. Removed the surrounding dark card, duplicate `SOURCE-AWARE TERM NOTE` title, and repeated outer-Back sentence. The persistent top-bar Back remains the global exit and has an accessibility hint that distinguishes both returns.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-single-note-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-modality-reference` capture `/tmp/strokecare-imaging-single-note-20260826.png` passed route OCR 5/5 at 3840x2160, build `29`, process PID `32529`, app SHA-256 `f006bb68eac40b0badd682b8c4ed3a36f06290565e32373bf49deea47a1dbcc4`, and image SHA-256 `9685968f6e8f9c8690418bcb636d029f69f72ff89b1b5f12acfd790e22a120cb`. Visual inspection confirms one CTA note card with guideline context, the named source action, `Back to study`, and the distinct gray outer Back; the former second dark shell and duplicated navigation instruction are absent.
- Verdict: `IMPROVED :)` — source reading now feels like a calm annotation on the actual spatial image, rather than a nested dashboard.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch quality, external-source opening behavior, source suitability for clinical use, asset rights, specialist review, or clinical validity.
- Next safe action: capture the term-note-to-study return with an interactive physical Vision Pro presenter pass before claiming the two exits are reachable by a wearer.
- Layman equivalent: when you open a hard term, you now see one small explanation card instead of a card inside another card. One button returns to the picture, and the regular Back returns to the brain.

## 2026-08-26 08:35 SGT — the family arterial reference now leaves the artery as the lesson

- Target: reduce duplicate wording in the family point-to-reference composition without removing the full arterial model, the reversible five-step route, the generic-teaching boundary, or the opt-in vessel-detail lesson.
- Action: removed the redundant `FULL ARTERIAL TREE` title from the family reference, retained one short instruction to follow the orange route and one `GENERIC TEACHING MODEL · NOT A PATIENT SCAN` boundary, shortened the family route heading to `ROUTE ONLY · NOT A MEASUREMENT`, and withheld the clinician-only separate-scene caveat from the family surface. The full wording remains in the clinician lane.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-family-arterial-compact-20260826` produced `BUNDLE_EXECUTABLE=PASS`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-arterial-reference` capture `/tmp/strokecare-family-arterial-compact-20260826.png` passed route OCR 2/2 at 3840x2160, build `29`, process PID `42880`, app SHA-256 `5455ef7b0cb1082c2209eae578ad23d6042a4ff7a3dc6c4b4bbe9b8c62270a0b`, and image SHA-256 `eb1c554d6f77ac9c83557a00acffeed5d2a9b23ca2d23442187d1ea3c6608719`. Visual inspection confirms the complete arterial tree, selected blockage cue, family question card, route arrows, and `Open vessel detail` remain; the right reference is visibly shorter and has no duplicate tree title.
- Verdict: `IMPROVED :)` — the family explanation is now more spatial: the vessel object and orange route carry the story, while words give only orientation and a clear boundary.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset legibility, gaze-and-pinch reachability, wearer comprehension, external-source behavior, asset rights, specialist review, or clinical validity.
- Next safe action: inspect one family vessel-detail return route to ensure the high-detail teaching scene visibly returns to the same selected blockage relationship.
- Layman equivalent: the right-side card now tells you only what to follow and what the model is. The coloured blood-vessel map does more of the teaching.

## 2026-08-26 08:48 SGT — the vessel journey keeps telling a learner where they are

- Target: prevent the opt-in inside-vessel teaching scene from becoming disorienting after its guided story advances beyond the opening moment.
- Action: added one persistent, compact location cue, `You are inside a cerebral artery`, whenever the generic arterial flow ride is active. It remains visible alongside the changing guided-stop label, `Pause`, and `Next stop`; it does not slow the authored journey, introduce a patient claim, or turn the scene into another dashboard.
- Evidence: the first 20-second deterministic audit reached `Arterial fork` and failed because the opening location phrase was no longer present. After the change, `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-family-blockage-context-r2-20260826` produced `BUNDLE_EXECUTABLE=PASS`, build `29`, executable SHA-256 `6ba0906b0b5ed25a17058cc6c24a0b0e66ba3e6d150cd16a876e182099b36fcf`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-blockage-interior` capture `/tmp/strokecare-family-blockage-context-r2-20260826.png` passed route OCR 2/2 at 3840x2160, process PID `60198`, image SHA-256 `768d8821caf7714cacc229bd30c61f3a2551929ca6a1f16d103bca8309a940f7`. Visual inspection confirms the stage can advance to `Arterial fork` while the location cue remains visible above the concise arterial teaching scene.
- Verdict: `IMPROVED :)` — the flow story can progress without asking a learner to remember what anatomical space they entered.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, wearer-scale legibility, gaze-and-pinch quality, the actual return interaction, audio/haptic perception, asset rights, specialist review, anatomical accuracy, or clinical validity.
- Next safe action: add one deterministic Simulator return-state capture that proves leaving the vessel lesson restores the selected external blockage context without a stale interior state.
- Layman equivalent: even after the animation moves on to the next blood-vessel branch, the app keeps a small reminder that you are looking from inside an artery.

## 2026-08-26 08:57 SGT — leaving a vessel lesson now restores the selected explanation cleanly

- Target: ensure the opt-in generic vessel lesson has a reliable way home that does not leak an active flow-ride state into a later interior visit or strand a person away from their selected blockage reference.
- Action: consolidated the visible `Return to Stroke Care` action and a new deterministic return receipt behind one `returnFromInternalBrainLesson()` handler. The handler stops a live generic flow ride when needed, clears the interior presentation state, and returns to the existing selected outer reference. The new `--proof-family-blockage-return` route opens the actual lesson, briefly lets it initialize, then invokes that exact handler before capture.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-family-blockage-return-20260826` produced `BUNDLE_EXECUTABLE=PASS`, build `29`, executable SHA-256 `e8e12c102b28fe3e5e935f263d297925c62366397c5650d4fa84a8946abc4781`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-blockage-return` capture `/tmp/strokecare-family-blockage-return-20260826.png` passed route OCR 2/2 at 3840x2160, process PID `74409`, image SHA-256 `d1d25060671f9836d6ea76337c8b5051e8ddc80fd4fc69cdd32de37a4f7d2c24`. Visual inspection confirms the app is back in the exterior family arterial composition with the `EXAMPLE BLOCKAGE` card and `Open vessel detail` available again, rather than an interior-only or black state.
- Verdict: `IMPROVED :)` — the contextual vessel lesson is now a reversible detour, not a state that can linger invisibly after someone returns.
- Blocker: this is deterministic Simulator evidence of the same return handler, not a physical-headset pinch test. It does not establish wearer reachability, gaze-and-pinch behavior, comfort, audio/haptic perception, asset rights, specialist review, anatomical accuracy, or clinical validity.
- Next safe action: run one physical Vision Pro interaction pass that opens `Open vessel detail`, presses `Return to Stroke Care`, and confirms the same selected example-blockage reference is restored.
- Layman equivalent: take the close-up vessel tour, come back, and the app returns you to the same place you left instead of making you hunt for the brain model again.

## 2026-08-26 09:07 SGT — the return now restores the readable exterior scale, not the portal scale

- Target: correct the post-return composition after the vessel-detail lesson, where the interior-entry threshold remained active and rendered the exterior brain too large for its family explanation surfaces.
- Action: introduced a named `selectedBlockageExteriorZoom` and matching orbit for the selected generic blockage reference. The selected point and the shared interior-return handler now use that same exterior reading pose; the dedicated interior threshold remains only for entering the separate lesson. Other interior entries retain their own exterior pose.
- Evidence: the prior `--proof-family-blockage-return` image showed the exterior state at the 3.2 portal threshold, with the brain crowding the room. `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-family-blockage-return-framed-20260826` produced `BUNDLE_EXECUTABLE=PASS`, build `29`, executable SHA-256 `2a3f4d57dfd30b86bc45b292a3c126b1025343fd908931e020490fa09b5dcdf9`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-blockage-return` capture `/tmp/strokecare-family-blockage-return-framed-20260826.png` passed route OCR 2/2 at 3840x2160, process PID `88294`, image SHA-256 `0dcff7e99b8cc228f5d7e81beedc14ca604e2cd63ce96900391da908fcc43407`. Visual comparison confirms the restored reference matches the normal selected-blockage reading composition rather than the oversized portal composition.
- Verdict: `IMPROVED :)` — returning from the close-up now brings the learner back to a readable whole-brain explanation, with the selected point and teaching reference still visible.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset scale comfort, gaze-and-pinch quality, manual world repositioning, audio/haptic perception, asset rights, specialist review, anatomical accuracy, or clinical validity.
- Next safe action: verify one manual Simulator pinch-to-enter and visible `Return to Stroke Care` activation using an interaction-capable accessibility or UI test before treating the automated callback as user-gesture proof.
- Layman equivalent: when you leave the close-up blood-vessel tour, the brain returns to a sensible teaching size instead of staying huge in your room.

## 2026-08-26 09:16 SGT — the secondary field identifies its role instead of repeating the point

- Target: remove the repeated `EXAMPLE BLOCKAGE` framing that made the family arterial scene feel like two competing cards describing the same selected point.
- Action: retained `EXAMPLE BLOCKAGE` in the nearby local lesson, where the learner selected it, and changed the right secondary header to `ARTERIAL PATH · 3D TEACHING MODEL`. The right field now explains its separate role while preserving the orange route, generic-teaching boundary, close action, and `Open vessel detail` action.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-family-arterial-dedup-20260826` produced `BUNDLE_EXECUTABLE=PASS`, build `29`, executable SHA-256 `ce6f0a3b0e5291e057ed61506180866747373130fa0608501c6a76e4076cea2c`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-family-arterial-reference` capture `/tmp/strokecare-family-arterial-dedup-20260826.png` passed route OCR 2/2 at 3840x2160 and image SHA-256 `5ec3d1954eada2e87962facc42947ee86cc966c42c6c4f8f67068c48d42f5aaa`. Visual inspection confirms one local selected-point label on the left and one clearly role-led arterial teaching field on the right.
- Verdict: `IMPROVED :)` — the selected point owns its explanation, while the secondary field owns the supporting anatomy, reducing duplicate visual language without hiding a route home.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, gaze-and-pinch behavior, wearer comprehension, audio/haptic perception, asset rights, specialist review, anatomical accuracy, or clinical validity.
- Next safe action: perform one manual Simulator interaction pass for the right-card close and `Open vessel detail` actions to ensure each has a visible return path.
- Layman equivalent: the left card says what the highlighted problem is; the right card says it is a model that helps show the route around it. They are no longer both trying to say the same thing.

## 2026-08-26 09:37 SGT — imaging is now a short vertical modality deck, not a flat mixed list

- Target: make it obvious that the clinician imaging field contains more than one X-ray-style reference, while retaining a visible recovery route and avoiding a second horizontal control surface.
- Action: grouped the existing generic studies into three compact vertical sections: `STRUCTURE` (CT, MRI), `VESSEL ROUTES` (vessel map, CTA, MRA), and `FUNCTIONAL OVERVIEW` (PET). The deck keeps one persistent outer `Back` above the scrollable study choices, shortens repeated row copy, and continues to expose the technical-term source note only after a deliberate action.
- Evidence: the first fresh grouped-deck capture exposed a real problem: the functional section was below the visible card, and `--proof-imaging-study-deck` correctly failed route OCR 3/5. After expanding the deck only enough to keep the fixed Back visible and removing repeated row subtitles, `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-deck-grouped-20260826` produced `BUILD_SUCCEEDED`, build `29`, with app SHA-256 `1201c9d8dad7b96272237db643c6ff8073b9570115cbd5bb97c2f28c65349730`. Fresh guarded `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-study-deck-grouped-r3-20260826.png` passed route OCR 5/5 at 3840x2160, process PID `30492`, and image SHA-256 `deb328908932c82764c4b21b903bec07932a6e1ea5def9d6258b714487ef1a21`. Visual inspection confirms CT, MRI, vessel map, CTA, MRA, and PET are visibly grouped in a single right-side vertical field with `Back` still exposed.
- Verdict: `IMPROVED :)` — the study picker now reads as a compact set of generic teaching lenses rather than an ambiguous flat worklist.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, gaze-and-pinch behavior, clinical modality appropriateness, source suitability at the point of use, interpretation of an image, clinical review, patient-data handling, or clinical validity.
- Next safe action: manually exercise the study deck, a technical-term note, `Back to study`, and outer `Back` in the Simulator to confirm the visible return wording maps to each real interaction.
- Layman equivalent: instead of one confusing image list, the doctor sees three simple groups: pictures of brain structure, pictures of vessel routes, and one separate functional concept. The way back stays at the top.

## 2026-08-26 09:46 SGT — outer Back now clears every transient imaging surface

- Target: make the imaging exit recoverable even if a clinician leaves while the study deck, source-note reading view, or local-image import flow is open.
- Action: extended the existing outer-Back visibility reset to clear the local study picker, source-note focus, image-import disclosure, file-import presentation, transient import status, and import target whenever the shared imaging plate closes. Reopening imaging therefore starts from its selected generic teaching study rather than inheriting a hidden local modal.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`; the contract now explicitly guards each transient reset. Narrow visionOS Simulator build `/tmp/strokecare-imaging-return-20260826` produced `BUILD_SUCCEEDED`, build `29`, with executable SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`. Fresh guarded `--proof-imaging-return-to-anatomy` capture `/tmp/strokecare-imaging-return-20260826.png` passed route OCR 2/2 at 3840x2160, process PID `43139`, app SHA-256 `a051deb8e4fb47b34997565f00105ebc1e02c6dea5f007848cda8f3e9c804265`, and image SHA-256 `1f9b28b70234d705bc181e10778253dd249e4edc774013f354114eb1b2366f51`. Visual inspection confirms the post-return anatomy explanation is visible with its normal presenter field and no imaging deck, source note, or import sheet left on screen.
- Verdict: `IMPROVED :)` — imaging now has a clean outer escape hatch instead of retaining a later hidden panel that can make the next visit feel stuck.
- Blocker: this is source-contract and rendered Simulator evidence of the reset path. It does not establish a physical-headset pinch, file-picker dismissal behavior, wearer reachability, gaze-and-pinch quality, clinical modality appropriateness, patient-data handling, asset rights, or clinical validity.
- Next safe action: manually open the study deck and a term note in the Simulator, use outer `Back`, then reopen imaging to confirm each visible transient surface is actually gone.
- Layman equivalent: even if someone backs out halfway through reading a scan or choosing an image, the next time they open imaging it starts cleanly instead of trapping them in an old screen.

## 2026-08-26 10:10 SGT — a reopened imaging study now proves both a clean deck and a visible exit

- Target: verify that the visible study deck can close through the same outer Back path and that reopening the generic teaching image does not leave a stale deck or hide the recovery action.
- Action: added the automation-only `--proof-imaging-return-reopen` route. It opens the real in-space study deck, invokes `returnToAnatomyFromSpatialImaging()`, and reopens the same CTA teaching plate through its ordinary placement method. The first capture exposed a usability defect: Back sat after a trailing spacer and was outside the captured central field. Moved Back beside the plate identity so it remains the first stable action while secondary reading controls stay on the right.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. The initial route image `/tmp/strokecare-imaging-return-reopen-20260826.png` correctly showed a cleared deck but failed OCR 2/3 because `Back` was not visible. After the header correction, the narrow visionOS Simulator build `/tmp/strokecare-imaging-return-reopen-20260826` exited `0`, build `29`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-return-reopen` capture `/tmp/strokecare-imaging-return-reopen-r2-20260826.png` passed route OCR 3/3 at 3840x2160, process PID `80224`, app SHA-256 `dd8bf07e358260dacf8a160178521faa6e44f470799a01828df1418666a6cc6e`, executable SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`, and image SHA-256 `3fc31b30d021b9f7c4ef7b758e3b8dc7eea11f9a196ef64aa83591394aafd86a`. Visual inspection confirms `PLACED TEACHING IMAGE`, `STUDY · CT angiography`, and leading `Back` are visible after reopening; the `STUDY DECK` list is absent.
- Verdict: `IMPROVED :)` — the generic imaging flow now demonstrates a clean return and a recoverable reopen, while its exit remains in the wearer’s first reading zone.
- Blocker: this is a command-line automation of the shared state handler plus rendered Simulator proof. It does not establish a physical-headset pinch, file-picker dismissal behavior, real gaze reachability, wearer comfort, clinical modality appropriateness, patient-data handling, asset rights, or clinical validity.
- Next safe action: manually open a technical-term source note in the visionOS Simulator, use outer `Back`, and reopen imaging to confirm the source note cannot return as a stale surface.
- Layman equivalent: open the scan menu, leave it, and open the scan again. You get a normal scan card with a clear Back button, not the old menu stuck on top.

## 2026-08-26 10:18 SGT — the imaging plate now reads as a vertical control stack

- Target: replace the crowded three-across study controls beside a placed teaching image with a clearer, right-side vertical hierarchy without weakening the existing modality deck, technical-term source note, comparison action, or outer recovery route.
- Action: converted the placed-plate `Study`, technical-term, and `CT + MRI` actions from one horizontal strip into three full-width, individually sized vertical rows. The visible outer `Back` remains beside the plate identity, and the image, generic-teaching boundary, and annotation affordance remain untouched.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-vertical-controls-20260826` exited `0`, build `29`. Fresh guarded `--proof-imaging-return-reopen` capture `/tmp/strokecare-imaging-vertical-controls-20260826.png` passed route OCR 3/3 at 3840x2160, process PID `91669`, app SHA-256 `08f38b3836bb46709eeac3a9d6841b95d627fe1744fcd7a2c7c6c2dfdd5a4cec`, and image SHA-256 `daae4da3ad085e34baf90f91dde81f2a4053779385d4a5f2c684bc18ec57ea6b`. Visual inspection confirms the selected CTA teaching image remains placed, `Back` is visibly leading, and the three supporting actions form a readable vertical stack rather than a repeated horizontal toolbar.
- Verdict: `IMPROVED :)` — the right-side imaging field now uses vertical spatial reading order for its core actions, leaving the image as the dominant teaching surface.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, gaze-and-pinch quality, manual image annotation behavior, external-source behavior, modality appropriateness, patient-data handling, asset rights, specialist review, or clinical validity.
- Next safe action: manually open the technical-term source note in the visionOS Simulator, use outer `Back`, and reopen imaging to confirm that source note cannot persist as a stale surface.
- Layman equivalent: the scan card now has three large actions stacked neatly one under another, so a doctor can find the scan choice, the term explanation, and the comparison view without reading a crowded button bar.

## 2026-08-26 10:29 SGT — a source note can now leave cleanly through global Back

- Target: make the technical-term teaching reference recoverable through the same persistent Back action as the rest of imaging, so an open source note cannot remain as stale local UI when the selected teaching image is reopened.
- Action: moved the local imaging cleanup into a named `returnToAnatomyFromPlate()` handler and wired the visible global Back button to it. The handler immediately clears the focused term note, study deck, import disclosure, importer, and transient import status before it delegates to the existing shared anatomy return. Added an automation-only `--proof-imaging-term-return-reopen` receipt that starts at the same focused CTA term note a presenter reaches by pinching a technical term, invokes that exact global-Back handler, then reopens the selected CTA teaching plate.
- Evidence: `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-term-return-20260826` exited `0`, build `29`, executable SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-term-return-reopen` capture `/tmp/strokecare-imaging-term-return-20260826.png` passed route OCR 4/4 at 3840x2160, process PID `4846`, app SHA-256 `65c03f5f622bce4b0a12a25b08ba8232d5fd4930cd13ce77e26afef80d44e89b`, and image SHA-256 `9cb0af826c9319d3bfc42589524a31df6f4d2af9c5b05a8f49d5e78e0f2c5224`. Visual inspection confirms `PLACED TEACHING IMAGE`, `STUDY · CT angiography`, the technical-term row, and leading `Back` are visible after reopen; no focused term-note surface remains.
- Verdict: `IMPROVED :)` — the research-reference pause now has a synchronous global exit as well as its local `Back to study`, reducing the chance that a quick exit leaves the next imaging visit feeling stuck.
- Blocker: this is a command-line automation of the visible global-Back handler plus rendered Simulator proof. It does not establish a physical-headset pinch, external-browser behavior, wearer reachability, gaze-and-pinch quality, manual annotation behavior, modality appropriateness, patient-data handling, asset rights, specialist review, or clinical validity.
- Next safe action: run one manual Simulator interaction pass that pinches a technical term, follows its named source action without opening a real external page, uses global Back, and reopens the selected image.
- Layman equivalent: read the extra explanation for a medical word, press the same Back button used everywhere else, and when you come back to imaging the normal scan card returns instead of the old explanation being stuck on screen.

## 2026-08-26 10:40 SGT — imaging modalities now say what they teach, not only what they are called

- Target: make the right-side generic imaging deck visibly distinguish structural, vessel-route, and functional references without adding a separate panel, turning the list into a care worklist, or hiding the functional reference below the fold.
- Action: added a compact category cue and one-line teaching purpose to every study row: CT and MRI identify structural cross-section or soft-tissue context; vessel map, CTA, and MRA identify route or vessel overviews; PET identifies a functional-imaging concept. The initial two-line version made the deck too tall and pushed `FUNCTIONAL OVERVIEW` below the captured card, so condensed the cue and purpose into a single horizontal row and returned each target to a 42-point minimum height.
- Evidence: the first rendered `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-deck-purpose-20260826.png` correctly failed route OCR 4/5 because `functional` was not visible. After the compact layout correction, `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-deck-purpose-r2-20260826` exited `0`, build `29`, executable SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-study-deck` capture `/tmp/strokecare-imaging-deck-purpose-r2-20260826.png` passed route OCR 5/5 at 3840x2160, process PID `20586`, app SHA-256 `c0db0c8fa1c0272b36bf33ddf759338db844f755a37f0945717b08ce449d4708`, and image SHA-256 `cd534133820e03e86affae395e330bf70e1f5fc4b7c8e9e62a972c15956f263c`. Visual inspection confirms the deck shows `STRUCTURE`, `VESSEL ROUTES`, and `FUNCTIONAL OVERVIEW`, including the PET row, with purpose cues visible and the persistent Back action above it.
- Verdict: `IMPROVED :)` — a presenter can now choose a teaching lens by its purpose rather than guessing from an acronym, while the composition stays a compact, vertical right-side field.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset legibility, gaze-and-pinch reachability, external-source behavior, modality appropriateness for a person, image interpretation, patient-data handling, asset rights, specialist review, or clinical validity.
- Next safe action: inspect the selected PET term note in the visionOS Simulator to ensure the functional-imaging explanation and its science source stay concise and have the same local and global return paths.
- Layman equivalent: the scan menu now tells you, in a few words, whether an option helps show structure, blood-vessel routes, or a separate functional concept. You can see all three choices without having to scroll first.

## 2026-08-26 10:48 SGT — PET now has a concise, source-aware functional-imaging explanation

- Target: make the non-X-ray functional-imaging teaching reference as clear and recoverable as the CT, MRI, CTA, and MRA references, while keeping it explicitly outside patient-specific imaging and stroke-care decision language.
- Action: checked the existing NIH/NIBIB Nuclear Medicine source before changing wording. Replaced the vague PET sentence with: `PET uses radiotracers to create images of functional molecular processes. This is a generic teaching concept, not a patient study or care choice.` Added `--proof-imaging-pet-term-note`, which opens the same focused source note a presenter reaches by pinching the PET technical term. The note retains the named NIH/NIBIB science-overview action, local `Back to study`, and persistent global Back.
- Evidence: [NIH/NIBIB Nuclear Medicine](https://www.nibib.nih.gov/science-education/science-topics/nuclear-medicine) describes PET as using radiopharmaceuticals or radioactive tracers to create images of internal functional molecular processes (reviewed September 2025). `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-pet-term-20260826` exited `0`, build `29`, executable SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`, with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. Fresh guarded `--proof-imaging-pet-term-note` capture `/tmp/strokecare-imaging-pet-term-20260826.png` passed route OCR 5/5 at 3840x2160, process PID `32876`, app SHA-256 `637214bc9f8256b67f0008e57c50a74f619ce72f21cf8270bda9995aa8972025`, and image SHA-256 `9fdd15e260ededdef5f2df0b949630291172467e743b6ee0fd017e8bb4d5cc27`. Visual inspection confirms the PET term, the shortened explanation, `PUBLIC SCIENCE OVERVIEW`, `Read science overview`, the generic-teaching boundary, and both return labels are visible.
- Verdict: `IMPROVED :)` — functional imaging is now a concrete, source-linked teaching path in the same modality system, rather than a vaguely named extra tab.
- Blocker: this is official-source wording plus rendered Simulator evidence. It does not establish a physical-headset pinch, external-browser behavior, clinical modality appropriateness for a person, PET image interpretation, patient-data handling, asset rights, specialist review, or clinical validity.
- Next safe action: inspect the same global-Back recovery path from the PET source note, then reopen the PET teaching reference to confirm no functional-imaging note remains stale.
- Layman equivalent: PET is no longer just an unfamiliar acronym in the menu. The app says it is a way of showing functional processes with tracers, gives a source to read, and still makes it easy to return to the scan or the brain model.

## 2026-08-26 11:14 SGT — a selected point and its teaching image now read as one calm composition

- Target: correct the point-to-annotation-to-imaging workflow so a clinician can keep the explanation for the selected brain point visible while reading a large generic teaching image, without a wall of competing controls.
- Action: retained only the pinned note whose source matches the actively selected point while a teaching image is placed, and positioned that compact note in the field opposite the image. Reworked the default image plate into a content-first reader: the image grows to a 360-point minimum height, the plate widens to 700 points, and only `Annotate scan` and `Focus` remain beside it by default. A single `Study tools` toggle deliberately reveals the modality deck, term note, comparison, local import, point prompt, scale percentage, and reset controls. The fixed `Back` action remains in the header and clears all transient imaging state through the existing recovery handler.
- Evidence: the first `--proof-spatial-annotation` audit correctly failed because it showed the teaching image but hid `PINNED NOTE`. The note-preservation change rendered both surfaces, then the content-first adjustment produced fresh capture `/tmp/strokecare-imaging-content-first-20260826.png`. `git diff --check` and `python3 Tests/verify_contract.py` passed with `STROKE_CARE_CONTRACT=PASS`. Narrow visionOS Simulator build `/tmp/strokecare-imaging-content-first-20260826` exited `0` with only the pre-existing unused-local warning in `StrokeSceneFactory.swift`. The fresh guarded route passed image proof OCR 3/3 at 3840x2160, process PID `77405`, app executable SHA-256 `aafd2aef8320a37d6a7a7f4a68e2608d8bf11605e5826953549b8492c8dbf56b`, and image SHA-256 `26e9f61f563c334697792a2deb36807bc8daa6b4386f1b5dd400a4b29c405f8e`. Visual inspection confirms a compact `PINNED NOTE` for `EXAMPLE BLOCKAGE` on the left, a large CT teaching plate on the right, one `Study tools` entry, visible `Back`, and no repeated study/import/comparison stack.
- Verdict: `IMPROVED :)` — the selected anatomical point, its authored explanation, and its supporting teaching image now remain visible as a three-part spatial relationship, while secondary controls stay out of the first reading state.
- Blocker: this is rendered Simulator evidence only. It does not establish physical-headset reachability, gaze-and-pinch quality, manual annotation quality, wearer's comprehension, audio/haptic perception, image interpretation, clinical modality appropriateness, patient-data handling, asset rights, specialist review, anatomical accuracy, or clinical validity.
- Next safe action: define a separate non-graphic craniotomy teaching rehearsal with reviewed stage names, a visible entry point, and tool actions that reveal generic teaching states rather than simulating clinical cutting or live treatment.
- Layman equivalent: choose one brain point, keep its short note on one side, and put a big matching teaching image on the other. Everything else stays hidden until you ask for it.

## 2026-08-26 12:28 SGT — one reference destination, a larger image, and a useful conversation guide

- Target: address the supplied screenshots showing missing Medications, duplicate evidence windows, low Guides placement, crowded Settings, and a small generic presenter checklist.
- Action: added one exclusive centre-field destination for Medications, Guides and Settings, each with a fixed Back. Opening one dismisses this app's legacy imaging/evidence windows and hides the main attachments. Imaging now opens its actual image plate in the central reading field with CT/MRI, All studies, Add image, Compare, annotation and placement controls. Switching study preserves focus; leaving clears focus. The right index stays vertical, the redundant bottom Evidence shortcut becomes Tools, and the index is separated vertically from the bottom controls. The larger left field now provides Anatomy, Flow and Access topics with four selectable plain-language terms, plus a Settings size control. The right index no longer depends on Full detail, so Simplified cannot hide Settings.
- Content: Medications now has four NHS-linked educational topics, not prescriptions or 3D medicine models. CT/MRI retain existing licensed template rasters; CTA/MRA/PET and the legacy map remain conceptual. No new patient scans, drug assets, uploads, diagnoses, or inferred anxiety. See `Docs/REFERENCE_WORKSPACE_HIERARCHY.md` for the source and navigation boundaries.
- Related implementation in this user-directed pass: added an opt-in reversible bone/dura model study using actual bundled movable assets, with interlocks, intermediate drag poses, Lift/Return fallback, Reset and Back. `Tests/verify_access_layer_study.swift` passed 16 checks. The open and closed v2 routes each passed OCR 4/4 and were visually inspected. This is not contact-aware surgery, bleeding, drilling, clinical closure or validated surgical training. The current source material and anatomy registration still need specialist review.
- Errors and corrections: the first implementation used incorrect CT/MRI enum names and did not compile; corrected to `.ctGuide`/`.mriGuide`. Fresh captures exposed a conflicting 620-point outer frame clipping the 700-point imaging content, low-contrast Settings, and overlap between the right tabs and bottom controls. Removed the conflicting frame, enlarged focused imaging to 900 points, used explicit contrast/selected states, and moved the reference index upward. A later imaging OCR miss on visible `Import` prompted clearer `Add image` wording. Static checks that encoded the former Full-only rail and obsolete copy were updated to guard the new behavior, including an explicit check that visual detail cannot hide Settings. No visual-proof threshold was lowered.
- Evidence: `python3 Tests/verify_contract.py` and `git diff --check` passed. The v4 Simulator build exited 0; app receipt SHA-256 `4349d0db13c2886d87d39a7879fbf411891dcc029559915ea2c66d8aa616732b`, local version 0.6/build 29. All six v4 routes below passed and were visually inspected. These are deterministic state/render receipts, not recorded UI pinches.

| Route | Capture | OCR | Image SHA-256 |
| --- | --- | --- | --- |
| Settings | `/tmp/strokecare-presentation-settings-20260826-v4.png` | 2/2 | `31608df77b3660357ea531fe649601caa9180933e70ba4af3b9b0a83b356adc9` |
| Imaging room | `/tmp/strokecare-imaging-room-20260826-v4.png` | 5/5 | `364d87a43e276bf956c97aac86e32e7754ea327eee42c271e551d664c0c1311b` |
| Return to explanation | `/tmp/strokecare-reference-return-20260826-v4.png` | 3/3 | `45f90a28a3b621012faa53668f647b7da7b17d96fd36acc235468ed27c9de3d1` |
| Medications | `/tmp/strokecare-reference-medications-20260826-v4.png` | 4/4 | `2442fc0ec0a0613075623f78e9336090cbd7dd115a9244b441cc548d2d2c446b` |
| Guides | `/tmp/strokecare-reference-guides-20260826-v4.png` | 4/4 | `91c4229437e3c834098126b82f459eaa4f70140e589ce595cb0a81526866f5c1` |
| Six-study deck | `/tmp/strokecare-imaging-study-deck-20260826-v4.png` | 5/5 | `bf371dd9ac3b1b638bc66641804c1f611805a08a1a6f2bac81220a179f2b594e` |

- Final detail-level recovery check, 12:32 SGT: the subsequent Simulator rebuild exited 0. The same return handler was exercised after changing Settings to Simplified, with assertions preserving the original timeline, orbit and scale. `/tmp/strokecare-reference-return-20260826-v5.png` passed OCR 3/3 and was visually inspected: the right reference index, left topic guide, bottom controls and timeline remain visible. App SHA-256 `e076e785b225207e2cbb04a1e6416162c6225644c54bdb21829a12128f780f55`; image SHA-256 `777860323fbe99a7e63e828ba1bdb86c289d25cb1561caa750d872e4a313aa3f`. Final contract and whitespace checks also passed. The v4 captures above predate only this menu-availability fix and its recovery assertion.
- Verdict: `IMPROVED :)` — the six inspected destinations have a clearer reading hierarchy, working state-return paths, and visible controls; no claim that every interaction is verified.
- Blocker: physical gaze/pinch, manual import/annotation, audio perception, specialist review, clinical suitability and surgical realism remain unverified. Local Simulator only; no XCAT deployment, commit, push, PR merge, TestFlight or App Store publication occurred. Existing dirty worktree edits were preserved.
- Next safe action: manually traverse Imaging → Add image → annotate → Back, then Guides → Back and Settings → Simplified → Back in an interaction-capable Simulator session, checking that the same anatomy context and right index remain reachable.
- Layman equivalent: opening a reference now clears the desk for that one task. Back returns to the brain, the left side offers things to explain rather than three generic rules, and the right-side menu no longer competes with another Evidence button.

## 2026-08-26 19:28 SGT — comparison gallery and spatial medication exhibits

- Target: the user's requested 2×2, 3×3 and 4×4 scan gallery and a medication field using selectable 3D objects, while preserving one focused workspace and a reliable return to the brain.
- Action: added an Imaging → Gallery destination with three grid sizes, modality filters, paging, multiple local raster imports, a large selected-image reader, image-specific drawing and Undo. The gallery contains exactly two existing licensed CT/MRI atlas images; empty cells are not filled with duplicate scans. Local imports are explicitly user-labelled, downsampled to 1536 pixels, limited to 24 MiB per input, 40 images total and 64 MiB of encoded payload. Back cancels outstanding imports and releases local images and marks. This is teaching display, not DICOM/PACS or diagnostic reading.
- Spatial medications: added four independent RealityKit exhibits: tablet blister, generic needleless syringe, IV bag and medicine bottle. Each has a collision/input target, selection, pinch-drag rotation, and Turn/Reset button fallbacks. The selected object changes the educational topic, short caution, delivery context and named NHS source. Props are deliberately identified as generic teaching geometry, not branded packaging, real hospital inventory, a local formulary, prescribing guidance or a validated workflow simulator. The normal brain and peripheral UI are hidden only during the focused workspace.
- Related recovery repair in this pass: the existing two-image plate now captures immutable single-use import destinations before asynchronous decoding. Leaving, replacing a study, or starting another import invalidates the older request, so late results cannot reopen the plate or overwrite the new choice. Failed decoding preserves the current image and marks; replacing an image clears its old marks. The earlier import lifecycle/return captures at `/tmp/strokecare-imaging-import-lifecycle-20260826-v1.png` and `/tmp/strokecare-imaging-import-return-20260826-v1.png` passed OCR and were visually inspected. They are state/render checks, not a manual Files-picker test.
- Errors and corrections: the first Foundation test compared CGPoint arrays, which did not compile on the test host; changed the assertion to explicit coordinate comparisons. A guarded Simulator launch exceeded its 45-second timeout; a fresh app-only launch then worked. The first 3D medication render obscured its heading and placed objects beyond their associated controls, failing OCR 3/4. Reduced the exhibit spacing and scale, corrected the syringe silhouette and shortened delivery text; the corrected render passed 4/4. Final review also found that relabelling the last image on a filtered page could leave the page counter out of range; added a clamp and regression check. No image-proof threshold was lowered.
- Verification: `python3 Tests/verify_contract.py`, `git diff --check`, 23 Foundation gallery checks and 13 import lifecycle checks passed. The final narrow visionOS Simulator build exited 0 at approximately 19:26 SGT. Local version 0.6/build 29; branch `feat/teaching-imaging-drawer`; HEAD `7b4cf9e391202b01db567da38be76e2727f42229`; final app receipt SHA-256 `187a6c205912d2e8900a38b9d6a5021c937b51ecf17e9644a708f80f9e1deb5d`. The platform-destination warning remains; the build did not fail.

| Route | Capture | OCR | Image SHA-256 |
| --- | --- | --- | --- |
| Spatial medications, final build | `/tmp/strokecare-reference-medications-20260826-spatial-v3.png` | 4/4 | `951051248eded81a7c61c09075033fddb697f97f7015ee76581841ad2d34630a` |
| 2×2 gallery, final build | `/tmp/strokecare-imaging-gallery-20260826-spatial-v3.png` | 4/4 | `d3b0dd6faab84f7eb04860d1e41a2bd4143bb515551e5421ece79e3ea5a45047` |
| 3×3 gallery | `/tmp/strokecare-imaging-gallery-nine-20260826-spatial-v2.png` | 4/4 | `77e3b984c27051d5d999e43d834c1fa14cf5019faefd8645ec3fe8b6325d8dd0` |
| 4×4 gallery | `/tmp/strokecare-imaging-gallery-sixteen-20260826-spatial-v2.png` | 4/4 | `de68cc63494094e764cfc56dccd6344012c0e0a5f06cb21e88184c183a2d97e5` |
| Large image with its own mark | `/tmp/strokecare-imaging-gallery-detail-20260826-spatial-v2.png` | 4/4 | `3909df345845c60ea37882c9806de2468c995347de54b66a1d2b86708d454c1d` |
| Back to the brain, final build | `/tmp/strokecare-imaging-gallery-return-20260826-spatial-v3.png` | 3/3 | `fb4dd565a913047a668f8d97191698e8a1fcaa7b7ca73a52aaa6dccf33367794` |

- Visual review: inspected all six compositions. Medication objects no longer obscure the heading or controls. Gallery layouts show the actual image count, and the large reader keeps its image and drawing dominant. Return restores the brain, left topics, right index and timeline. The v2 captures precede only the filtered-page clamp and its regression test; their app SHA was `5f352a748ce88409b429746dda8ff3aaaea156b7cb514922272b2910f36ae006`. The final v3 medication and 2×2 images are byte-identical to their visually inspected v2 compositions. The final return image was separately inspected.
- Verdict: `IMPROVED :)` — there is now a coherent browse → inspect → annotate → return path and an actual 3D medication teaching layer, not only medication text. The original timebox was exceeded across this continued pass; this entry is not a claim of completion within 40 minutes or of the whole product being finished.
- Blocker: manual Files selection, multi-image import/annotation gestures, 3D pinch/drag quality, comfort and clinical workflow acceptance are not verified. Only two real raster atlas examples are bundled. Clinical review, larger licensed scan sets and higher-fidelity product assets remain separate work. No patient images were uploaded, HeyGen credits consumed, XCAT deployment, commit, push, PR merge, TestFlight or App Store release performed. Existing dirty worktree changes remain preserved and the overall goal remains active.
- Next safe action: in an interaction-capable Simulator session, import a few de-identified images through Add scans, compare all three grid sizes, annotate one image and use Back to verify restoration of the same brain context.
- Layman equivalent: the doctor now opens a scan lightbox, chooses how many images to see, enlarges and marks one, then returns to the brain. The medicine area has objects that can be selected and turned, with a short explanation below. The screenshots prove the layout renders; a person still needs to try the gestures and file picker.

## 2026-08-26 20:20 SGT — gallery image handoff, visual acceptance pending

- Target: carry one enlarged gallery image and its annotations into the spatial explanation without losing its source, explicit modality or a reliable Back path.
- Action: added **Place beside brain** to the gallery reader. Placement validates the raster before changing navigation, retains only the selected source, transfers its image-bound strokes to the existing movable plate, preserves CT/MRI attribution or the local-image label, and invalidates late gallery imports. A shared fitted-image rectangle and straight-line rendering keep marks off letterbox margins and consistent between reader and plate. Existing Focus, Annotate, Undo and Back remain the controls. The UI explicitly warns that other temporary imports clear on leaving; original files are untouched. Back releases the selected temporary image and marks. No new window, upload, interpretation, save/export or patient data was added.
- Files: `Sources/StrokeImagingGalleryModel.swift`, `Sources/StrokeImagingGalleryView.swift`, `Sources/StrokeExperienceState.swift`, `Sources/StrokeImmersiveView.swift`, launch/capture/OCR routes, gallery/contract checks and `Docs/REFERENCE_WORKSPACE_HIERARCHY.md`. Preserved the extensive existing dirty worktree on `feat/teaching-imaging-drawer`, HEAD `7b4cf9e391202b01db567da38be76e2727f42229`.
- Verification: final `python3 Tests/verify_contract.py`, 30 standalone gallery checks, 13 import lifecycle checks and `git diff --check` passed. The narrow visionOS Simulator build exited 0 at approximately 20:12 SGT, local version 0.6/build 29. Final `StrokeTime.debug.dylib` SHA-256: `ef5aa5cdba2b8de6b9fedfa53540a4c81f75c49de0a27fcb11461c5dd6a62239`. The platform-destination warning remained, without a build failure.
- Runtime evidence: a diagnostic launch exercised the production placement/state handlers and printed `IMAGING_GALLERY_PLACEMENT=PASS checks=27 visible=true`, followed by `PROOF_IMMERSIVE_RESULT=opened`. Assertions covered invalid selection, source/marks transfer, focus return, Undo, Back cleanup, rejected corrupt image data and explicit local-MRI labelling. The final build removed temporary stack diagnostics; it did not change those state transitions. Runtime assertions are not rendered-image or gesture acceptance.
- Visual gate: `/tmp/strokecare-gallery-placed-20260826.png` failed the required placement OCR 0/3 and showed only the main brain composition. SHA-256 `b87f22654f01113d1beb03db51a2e1a92a49e720ceb9e88d84ce415b501a3f06`. Repeated inspected frames did not show the new plate even though runtime state remained visible. Stale Simulator presentation is a hypothesis, not a confirmed cause. Restarted only Simulator `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` without erasing its data. The final guarded placement launch still failed with `SIMULATOR_PROOF=FAIL launch exceeded 45s; Simulator shell may be unhealthy`; no v3 capture was produced. Local-image and placement-return captures remain unverified. No OCR requirement was relaxed and no failed frame was called an improvement.
- Errors and corrections: corrected a new source-contract variable name; added the explicit CoreGraphics import and split the image-fit expression so standalone Swift geometry tests compile. The first capture failure triggered a state trace, which showed only the proof's intended Back transitions before the final visible state, not an established later reset. Temporary tracing was removed and rebuilt. The unavailable computer-use controller prevented the manual Files-picker/pinch test; no alternate GUI automation was used. The original 25-minute timebox was exceeded, and retries stopped at this render/launch gate.
- Verdict: `NEUTRAL :\` — the handoff implementation and regression checks are ready for visual verification, but no new visible improvement is claimed from this pass.
- Blocker: current Simulator launch/render state prevents acceptance of the handoff. Manual import, image placement/annotation gestures, wearer comfort and clinical workflow acceptance remain unverified. No XCAT deployment, external upload, provider credits, commit, push, PR merge, TestFlight or App Store publication occurred. The ongoing product goal remains active.
- Next safe action: restore an interaction-capable Simulator session, then run `--proof-imaging-gallery-placed` and inspect the image and its mark before continuing to the local-image and Back routes.
- Layman equivalent: the scan now has a button intended to bring it and the doctor's drawing beside the brain. The software checks agree that the correct image and drawing are carried over, but the Simulator did not display that result and then stopped launching reliably. This pass therefore stops short of calling the new handoff working.

## 2026-08-26 20:30 SGT — late image-attachment recovery

- Target: recover and verify the gallery-to-spatial handoff before adding more interface features. Budget: one targeted recovery pass; timebox 25 minutes; no paid or external actions.
- Action: fixed primary and detached comparison image attachments in `Sources/StrokeImmersiveView.swift`. Previously their scene-update path changed position and visibility but never mounted them if they were missing during initial setup. It now adds each resolved entity to the stage when its parent differs, retaining its identity and existing placement, scale and visibility rules. This is a defensive lifecycle correction, not a confirmed diagnosis of the earlier missing frame. [Apple's attachment documentation](https://developer.apple.com/documentation/realitykit/realityview/init%28make%3Aupdate%3Aattachments%3A%29) confirms that resolved attachment entities must be explicitly added to scene content.
- Regression evidence: added two source-contract checks scoped to `updateSpatialTeachingAttachments`. Both failed before the repair (`late-resolving ... is never mounted in the scene update`) and passed after. `python3 Tests/verify_contract.py`, 30 gallery geometry/state checks, 13 import lifecycle checks and `git diff --check` passed. These checks do not prove rendered visibility.
- Build evidence: the narrow visionOS Simulator build exited 0 at approximately 20:28 SGT, retaining version 0.6/build 29. `StrokeTime.debug.dylib` SHA-256 `27218968209751dc63a4481a91e39526b4973dab957cfec5f879ebae1ced3ac7`. The existing destination-platform warning remains non-fatal.
- Runtime gate: fresh process inspection found the named virtual device's `launchd_sim` but no running Simulator host app. The device still reported Booted. A bounded basic `--proof-role-choice` launch timed out after 20 seconds without starting the app; the final guarded `--proof-imaging-gallery-placed` launch also returned `SIMULATOR_PROOF=FAIL launch exceeded 20s; Simulator shell may be unhealthy`. No `/tmp/strokecare-gallery-placed-20260826-mount-v1.png` was produced. No visual claim was made, and no screenshot acceptance threshold was lowered. The computer-use skill's required controller is unavailable; asked the user to reopen the Simulator rather than substituting unapproved GUI automation. No additional Simulator restart or data erase was performed in this pass; the existing proof script reinstalled only the named fictional-data app.
- Verdict: `NEUTRAL :\` — a test-covered lifecycle weakness is repaired, but visible handoff acceptance remains pending. Branch `feat/teaching-imaging-drawer` and all unrelated dirty changes preserved. No XCAT, commit, push, PR merge, upload or publication. The full product goal remains active; this is the second consecutive pass at this Simulator gate, not a declaration that the product is complete or the overall goal is blocked.
- Next safe action: reopen the Apple Vision Pro Simulator window, then capture `--proof-imaging-gallery-placed` from this exact build and inspect the carried image and marks before checking the local-image and Back routes.
- Layman equivalent: an image panel that arrives a little late is now attached to the scene instead of merely being told where to sit. The checks and build pass, but the Simulator window is closed and app launches time out, so its appearance still needs to be seen.

## 2026-08-26 20:33 SGT — third consecutive Simulator gate

- Target: resume the pending image-placement verification, with a five-minute recovery-check limit.
- Action: inspected the authoritative branch, relevant dirty files, final build hash, available controller tools and current Simulator processes. Retried only the basic role-selection route with a 20-second alarm; did not uninstall, erase, restart or edit product code.
- Evidence: branch remains `feat/teaching-imaging-drawer`; both update-time attachment guards remain present. The debug-library SHA-256 remains `27218968209751dc63a4481a91e39526b4973dab957cfec5f879ebae1ced3ac7`. The virtual device reports Booted but the Simulator host app is absent. `simctl launch --terminate-running-process ... com.arnav.StrokeTime --proof-role-choice` again produced no PID and ended with exit 142 at the 20-second timeout. Controller discovery still found no computer-use or Simulator GUI controller. `git diff --check` passed. No new rendered or gesture proof exists.
- Verdict: `BLOCKED :(` — the same Simulator launch/render gate has now persisted for three consecutive goal turns. Builds and source checks cannot establish the outstanding visual handoff. Further UI additions would compound unverified behavior, so the full goal is marked blocked, not complete, pending the Simulator becoming available.
- Blocker: a responsive Apple Vision Pro Simulator session is needed to render and inspect the current app. All source edits and the successful build are preserved. No XCAT deployment, provider use, commit, push, publication or unrelated mutation occurred.
- Next safe action: reopen the Apple Vision Pro Simulator window and resume this task so the current build can be checked through placement, annotation and Back.
- Layman equivalent: the app code is still here and builds, but the test headset on the Mac is not opening apps. The repeated retry loop has stopped until that test environment is available.

## 2026-08-26 22:40 SGT — complete image placement in the forward field

- Target: resume the pending gallery-to-spatial-image handoff on `feat/teaching-imaging-drawer`; one 20-minute Simulator continuation with no external actions.
- Action: the refreshed tool inventory exposed the computer-use controller. Reopened Simulator through its supported app-state route. The existing late-mount build now rendered the selected image and mark, but the plate was clipped at the right edge. Changed the real default pose from `(0.54, 1.48, -0.62)` to `(0.34, 1.55, -0.96)` in `StrokeExperienceState.swift`. Reduced the default plate toolbar to CT, MRI, Studies and Gallery; import and comparison remain in Study tools. Removed the repeated placement instruction from the default header. The image and Back/Focus now fit in the inspected opening frame.
- Verification: `python3 Tests/verify_contract.py`, 30 gallery checks, 13 import lifecycle checks and `git diff --check` passed. The narrow visionOS Simulator build exited 0 at 22:34 SGT, version 0.6/build 29. Existing destination-platform and unused `showsAccessReference` warnings were not changed. Debug-library SHA-256: `48a8bceb41a8e6c04b0b92fbe35ee571ea019b40b039eeb4cf67aeb185151ef0`.
- Before frame: `/tmp/strokecare-gallery-placed-20260826-resume-v1.png` showed the image but clipped it. OCR was 3/3, yet the unchanged visual gate correctly failed `empty-centre` at 0.0648. SHA-256 `430094f36e611725ac72306d9cf4e3eddc924ba57201a7b8148fc09eee37c811`. This failure was not accepted or hidden by lowering a threshold.
- Fresh render receipts, all visually inspected: `--proof-imaging-gallery-placed`, `/tmp/strokecare-gallery-placed-20260826-forward-v1.png`, OCR 3/3, SHA-256 `9977eb061517de4814cf5f4ff560269897ef12e1ad4f1b7c814f6d47c5111589`; `--proof-imaging-gallery-placed-local`, `/tmp/strokecare-gallery-local-20260826-forward-v1.png`, OCR 3/3, SHA-256 `aa21b0cf272d699cc79c8b209d3c782c2b4cbbeb62c02b4c440f01e56f555594`; `--proof-imaging-gallery-placement-return`, `/tmp/strokecare-gallery-return-20260826-forward-v1.png`, OCR 3/3, SHA-256 `3f44cca350f1d010ab166ee9fc3c9486648a8606ffd3f3bc72e9695e29673145`. The local fixture is an explicitly named bundled MRI atlas copy, not a patient image. The return route restores the anatomy, left explanation, right rail and timeline without the placed image.
- Interaction boundary and errors: initial proof invocation accidentally passed the executable rather than its `.app` directory and safely exited 66; corrected before install. A screenshot-helper variable scope error was corrected in the desktop tool. Two desktop Focus clicks did not establish a visible reading transition. A Back click then returned computer-use error `-10005: noWindowsAvailable`; the next app-state read recovered the window. Do not infer successful control activation from the deterministic return route. Files selection, actual annotation/placement gestures, Focus/Back input, physical gaze/pinch and clinical workflow acceptance still need verification.
- Verdict: `IMPROVED :)` — complete placed scans and carried marks are now visibly verified, with less toolbar wrapping and no right-edge clipping in the tested starting pose. Preserved unrelated dirty files. No XCAT, provider credits, patient upload, commit, push, PR merge, TestFlight or App Store release. The resumed product goal stays active and is not complete.
- Next safe action: reproduce and resolve the placed-image Focus/Back input path in the live Simulator, then verify the gallery-to-image handoff through real control activation.
- Layman equivalent: a scan selected in the gallery now appears next to the brain with its drawing and credit intact, fully on screen. The automatic route returns to the main view cleanly; the live button clicks still need their own check.

## 2026-08-26 23:06 SGT — separate image movement from navigation

- Target: placed-image Focus/Back input on `feat/teaching-imaging-drawer`; one 25-minute interaction-repair pass.
- Action: tested native Simulator controls and the visible imaging controls. Restricted the header's drag and magnify recognizers to its title instead of wrapping Back, Study tools and Reset. Kept image-surface manipulation. Added stable move-handle, Back and Focus accessibility identifiers; no new visible controls or clinical content.
- Design intent: movable teaching images for clinicians using visionOS pinch input; quiet image-first presentation, clear exits and no duplicate control rows.
- Verification: the two new source regression conditions failed before the patch and passed afterward. `python3 Tests/verify_contract.py`, 30 gallery checks, 13 import lifecycle checks and `git diff --check` passed. The narrow visionOS Simulator build exited 0. Debug-library SHA-256: `0276336c5abffcb6b877e9ea031318f0ceffdcdd0eea1e8dc86eb3c0d511a604`.
- Fresh render: `--proof-imaging-gallery-placed`, `/tmp/strokecare-gallery-navigation-20260826-v1.png`, version 0.6/build 29, PID 47752, OCR 3/3, unchanged image gate PASS. SHA-256: `382b8f81f251f6fd529f926b2947d400b703693b83d4eb138c33042fd65345a1`. Visually inspected the full CT plate, carried mark, Back and Focus; no added clipping or toolbar wrapping.
- Interaction evidence: Simulator's native Home action responded after settling. Coordinate actions intermittently returned computer-use error `-10005: noWindowsAvailable`, including at the system home screen. Two final Focus clicks on the rebuilt app produced a hover highlight but no visible transition. No evidence establishes that the header gesture caused the original symptom; do not describe this as a fixed click path. Physical pinch, Files-picker interaction and wearer acceptance remain unverified.
- Verdict: `NEUTRAL :\` for user-visible interaction acceptance. A preventive input-ownership change and regression coverage are verified, but the decisive Focus/Back input gate remains open. Preserved the dirty worktree; no XCAT, provider credits, patient upload, commit, push, release or goal-completion claim.
- Next safe action: trace Focus activation with a debug-only event receipt and a known-working Simulator input path to distinguish lost input from state or scene-update failure.
- Layman equivalent: moving the image no longer shares the same touch area as its Back button. The app still builds and the scan looks correct, but the automated clicks have not yet proved that focusing and returning work in actual use.

## 2026-08-26 23:31 SGT — distinguish image input from focus rendering

- Target: placed-image Focus/Back acceptance on `feat/teaching-imaging-drawer`; one 25-minute trace-and-verification pass, Simulator only.
- Action: added opt-in, Simulator-Debug-only fixed-event diagnostics at the image Focus/Back buttons, focus state mutation, attachment scene update and plate appearance. The trace records no image data, filenames, gaze, hand positions or patient information. Added source coverage for the guard and event boundaries. No new visible controls or speculative root-gesture patch.
- Verification: `python3 Tests/verify_contract.py`, 30 gallery checks, 13 import lifecycle checks and `git diff --check` pass. The narrow visionOS Simulator build exited 0. Existing platform/unused-value warnings are unchanged. Version 0.6/build 29, debug-library SHA-256 `8b54d4c9d298adc2421fac3a737801a5a2bd515882439aeb7fd48c813da1bbfa`.
- Placed render: `/tmp/strokecare-gallery-input-trace-20260826-v1.png`, PID 63853, OCR 3/3, image gate PASS. SHA-256 `382b8f81f251f6fd529f926b2947d400b703693b83d4eb138c33042fd65345a1`. Inspected the current full image plate and its controls. Trace emitted `SCENE_PLACED` and `READY`.
- Input evidence: native AX Home/menu actions work, but coordinate input again failed with `-10005: noWindowsAvailable`, including a Simulator-native Pan control outside the app. Fresh state reads still show a visible Simulator window. The traced Focus attempts emitted no `BUTTON_FOCUS`; therefore the current evidence does not establish an app callback, mutation failure or repaired gesture path. Screenshot dimensions were confirmed before the final attempt. No unsupported GUI automation workaround was used.
- Focused render: direct `--proof-imaging-room` launch, PID 75234, emitted `STATE_FOCUSED`, `SCENE_FOCUSED` and `READY`. `/tmp/strokecare-imaging-focused-trace-20260826-v1.png` was visually inspected: enlarged CT, stable Back, four study destinations and Place beside brain, without the anatomy/control clutter. SHA-256 `97614dc81b1e4485be646d329ae210457dff5e2e87ad98956681df78d75b9ca4`.
- Verifier error and correction: the capture initially exited 1 because old OCR labels expected All studies, Add image and Compare on the default toolbar. These were deliberately replaced/hidden by the prior simplification. Updated only the expected focused-room labels to Imaging, Study tools, Studies, Gallery, Annotate scan, Place beside brain and Back. Rechecking the same fresh capture passes 7/7 with all image-quality thresholds unchanged. Do not call the initial capture-script receipt a success or this direct route a successful click.
- Trace receipt: `/tmp/strokecare-imaging-input-trace-20260826.log`. The bounded log stream was stopped after inspection. Initial setup state events are not button events.
- Verdict: `NEUTRAL :\` for live interaction acceptance. Focus state/render behavior and the diagnostic boundary are verified; actual Focus/Back delivery is not. Preserve all unrelated dirty files. No XCAT, provider credits, patient upload, commit, push, release or clinical/device-acceptance claim. The wider product goal remains active, not complete.
- Blocker: the available desktop coordinate controller cannot currently provide reliable Simulator input. The trace makes the missing proof observable without guessing at a product fix.
- Next safe action: activate Focus and then Back through a working Simulator input path with the debug trace enabled, checking both button events and the visible image/anatomy transitions.
- Layman equivalent: the app can show the scan large and centered, and now we can tell exactly how far a click gets. The automated mouse is failing before the button receives it, so the final hands-on check is still outstanding.

## 2026-08-26 23:37 SGT — stop repeated Simulator input retries

- Target: verify actual placed/focused image navigation on the unchanged `feat/teaching-imaging-drawer` build; 20-minute maximum, stopped early at the repeated external gate.
- Action: refreshed the goal, dirty-worktree status, computer-use instructions, tool inventory and visible Simulator state. Tried Place beside brain from the enlarged image. After its controller error, used the native AX window-zoom action as a window-only recovery and tried Back. Restored the window size afterward. Did not uninstall, reset the simulated device, change app settings or edit product code.
- Evidence: both image-button attempts returned computer-use error `-10005: noWindowsAvailable`. Fresh app-state reads show the same focused CT view with Back and Place beside brain visible. The fixed-event log query for the attempts contains no button/state events. Native AX actions still respond, but the app's in-scene SwiftUI controls have no exposed AX elements in this controller. Tool discovery found no alternative purpose-built Simulator input tool. Debug-library SHA-256 remains `8b54d4c9d298adc2421fac3a737801a5a2bd515882439aeb7fd48c813da1bbfa`; `git diff --check` passes. No new build or gesture success is claimed.
- Verdict: `BLOCKED :(` — the same live-input gate is documented in the 22:40, 23:06, 23:31 and current resumed goal passes. The available controller cannot deliver the acceptance-test actions, and further speculative gesture changes cannot resolve that evidence gap. The full goal is marked blocked, not complete; all existing app work is preserved.
- Blocker: a working Simulator input path or a human-observed interaction result is required to distinguish remaining app navigation behavior from the failed desktop controller. No XCAT, provider use, patient upload, commit, push or release occurred.
- Next safe action: manually run Place beside brain, Focus, then Back in the current Simulator and report the first action that fails, or confirm the image returns to the main brain explanation.
- Layman equivalent: the test app is open and its enlarged scan is visible, but the automated mouse cannot click it. The repeated retry loop has stopped until a real click can establish what the app does.

## 2026-08-28 15:09 SGT — value-key auxiliary workspaces on `latest-arnav-build`

- Target: preserve the current Stroke Care feature set while removing the structural source of stale, repeated Evidence, Imaging, Guide, companion and teaching-model windows. Budget: one release-prep cleanup; no main-branch merge, XCAT action, paid provider use or clinical claim.
- Action: created and retained the local branch `latest-arnav-build`. Converted the five auxiliary `WindowGroup` scenes to data-presenting groups with one stable string value each. Every product call that opens a companion, Evidence or teaching-model window now includes that stable value, so opening it again raises the matching workspace instead of creating another instance. The primary launch window remains a normal restorable group. Added generated DerivedData and Python-cache paths to the repository ignore list. Documented the compatibility and hierarchy boundary.
- Error and correction: the first implementation used SwiftUI `Window`, which would have made each scene unique but failed the visionOS 2.0 build because that API requires visionOS 26. Replaced it with value-keyed `WindowGroup` rather than increasing the deployment target. Apple's `OpenWindowAction` contract states that a matching presented value brings the existing window forward. The corrected visionOS 2.0 build succeeded.
- Verification: `python3 Tests/verify_contract.py` and `git diff --check` pass. The contract now rejects unkeyed auxiliary groups and checks the keyed Evidence/print open paths. Standalone gallery, import-lifecycle and access-layer tests pass 30, 13 and 16 checks respectively. The narrow visionOS Simulator build succeeded against simulator `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`; debug-library SHA-256 `06fe511687526bfce7d6ba0cc39f5a734c292c34436433cbff8a593a412afe57`.
- Visual evidence: `Proof/104-singleton-guides-workspace-simulator.png` passes route OCR 4/4 and was inspected as one centred Guides workspace without the brain, rails or duplicate Evidence panel; SHA-256 `a27b4a1474c4bb213defb551c5fa9cab29893ba7049d33330f2c143c3731611a`. `Proof/105-singleton-return-to-anatomy-simulator.png` passes route OCR 3/3 and was inspected with the dominant brain, enlarged explanation panel, vertical reference tabs and bottom timeline restored; SHA-256 `3f44cca350f1d010ab166ee9fc3c9486648a8606ffd3f3bc72e9695e29673145`.
- Verdict: `IMPROVED :)` — repeated programmatic opens now converge on one compatible auxiliary workspace, while the focused and returned compositions remain intact. This is a bounded cleanup of the accumulated build, not a claim that every requested clinical-training, asset-realism or gesture feature is complete.
- Blocker: deterministic route receipts cannot prove repeated physical gaze-and-pinch use, wearer comfort, headset layout, clinical accuracy or App Store readiness. The branch still requires a human/device acceptance pass and specialist review before release.
- Next safe action: on Apple Vision Pro, repeatedly open and close each auxiliary destination once and record the first workspace that duplicates or fails to return.
- Layman equivalent: reopening Sources, Imaging or another side view should now bring back the same panel instead of leaving copies floating around the room. The Simulator shows the clean panel and a clean return to the brain, but someone still needs to try those repeated opens in the headset.

## 2026-08-28 17:12 SGT — direct brain-region selection without duplicate spatial UI

- Target: make a direct family pinch on the generic brain surface explain one broad region without opening a dense Atlas dashboard, duplicate reference card or detached miniature.
- Action: direct surface selection now opens one compact `SELECTED ON BRAIN` card, keeps the full ten-part Atlas behind the explicit `Explore atlas` action, names the selected region in plain language and emphasizes only that broad region on the main brain. The selected cue moved 30 mm outside the registered teaching surface, received one restrained noninteractive halo and uses the visible-side temporal anchor. The automatic secondary 3D miniature and right reference drawer remain collapsed for this direct path; closing clears the cue and Atlas together.
- Errors and correction: the first two builds exposed missing explicit `return` statements in new two-stage Swift switches; both were corrected without changing deployment targets. The next render removed the right card but revealed its miniature floating across the compact explanation. The state transition was then changed so the miniature is not spawned automatically. No failed render was accepted as an improvement.
- Verification: `python3 Tests/verify_contract.py` and `git diff --check` pass. The narrow visionOS Simulator build exits 0 against `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`; codesign verification passes. `Proof/106-family-direct-surface-selection-simulator.png` passes the unchanged image-quality gate and route OCR 2/2 for `selected on brain` and `temporal lobe`; SHA-256 `811576e1f797a9bce6b0a912fd98e1303fea4c8acd1af50cd762dc4636cc1896`. The inspected frame shows one compact explanation, the dominant brain, one separated cue and no secondary card or miniature.
- Verdict: `IMPROVED :)` — a surface selection now produces one spatial answer and one deliberate path to deeper Atlas exploration instead of several competing objects.
- Blocker: deterministic Simulator proof does not establish physical gaze-and-pinch hit quality, wearer comfort, anatomical-border accuracy, clinical acceptance or device performance. The highlight is explicitly a generic broad atlas context, not a patient scan or measured lobe boundary.
- Next safe action: on Apple Vision Pro, pinch each of the five broad surface contexts once and record the first cue that is hard to acquire or visually detached from its intended region.
- Layman equivalent: touching a broad part of the teaching brain now gives one short answer beside it. The chosen area glows and a single dot sits just off the surface; the larger lesson opens only if the learner asks for it.

## 2026-08-28 17:25 SGT — one readable timeline ribbon for both audiences

- Target: clarify the shared lower teaching timeline without adding another window or reducing family and presenter target reliability. Budget: one substantial interaction pass; Simulator only; no `main` merge, XCAT action, paid provider use or new clinical content.
- Action: replaced the large outer material slab and the presenter's detached progress strip with one continuous, lightly darkened glass ribbon. The cool-to-warm track now runs directly through three family acts or six presenter checkpoints. Visible markers remain restrained, while family buttons use fixed 96-point acquisition fields and presenter buttons retain fixed 108-point fields with 64-point discs. The active or gaze-hovered marker carries the emphasis. The one-line context appears above, fades after 2.6 seconds and returns on gaze without moving any target. Color denotes authored story position only, never severity.
- Verification: `python3 Tests/verify_contract.py` and `git diff --check` pass. The narrow visionOS Simulator build exits 0 against `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`; codesign verification passes. The existing destination-platform notice and unrelated unused `showsAccessReference` warning remain. No deployment target or clinical boundary changed.
- Visual evidence: `Proof/107-family-timeline-ribbon-simulator.png` passes the unchanged image gate and route OCR 2/2 for `selected on brain` and `temporal lobe`; SHA-256 `f8774d11a1b138f5851c33aced4a61b853e88dbbd5f8d773f65999a8f93ac2a7`. It was inspected on the optional black background with one compact three-act ribbon beneath the dominant brain. `Proof/108-clinician-timeline-ribbon-simulator.png` passes route OCR 2/2; SHA-256 `50384bb89525c45dbd7c33a5da14f7eacfc90f4d3431ffdec8f22377dcd1ef20`. It was inspected in the bright-room presenter route with one continuous six-step track and no redundant strip.
- Verdict: `IMPROVED :)` — both audience modes now expose one coherent timeline object with clearer color progression, quieter material and stable spatial targets. This is a rendered hierarchy improvement, not proof that every requested procedure, imaging, medication or internal-brain lesson is complete.
- Blocker: Simulator receipts cannot establish physical gaze acquisition, pinch comfort, depth placement, wearer comprehension, headset performance or clinical acceptance.
- Next safe action: on Apple Vision Pro, acquire family act 3 and presenter checkpoints 3 through 6 once each and record the first target that is difficult to select.
- Layman equivalent: the timeline is now one thin colored path instead of pale dots plus a separate bar. The buttons look smaller and cleaner, but the invisible areas you can look at and pinch are still large.

## 2026-08-28 17:52 SGT — one spatial medication focus instead of four competing props

- Target: replace the flat medication row with one legible spatial teaching object while preserving direct pinch, rotation, explicit clinical boundaries and a reliable return path. Budget: one focused reference-workspace pass on `latest-arnav-build`; Simulator only; no `main` merge, XCAT action, paid provider use or new treatment claim.
- Action: promoted the selected generic medication prop into a central hero and recessed the other three into a shallow carousel. Added Previous and Next controls, four quiet position indicators, a visible `1 OF 4` count and stable 44-point acquisition areas. Direct prop selection and pinch-drag rotation remain available; Turn and Reset remain fallbacks. Removed the first-pass selection rim after it visibly crossed the interface, and moved the IV bag and bottle until all alternatives remained readable without competing with the selected prop.
- Verification: `python3 Tests/verify_contract.py` passes, including new carousel hierarchy and control checks. The narrow visionOS Simulator build exits 0 against `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`, version 0.6/build 29. A fresh local-signing build also exits 0 and passes `codesign --verify --deep --strict`; debug-library SHA-256 `9fe753268f50300ad514a1e276850c6b46d3bab50d02188121ee41235c10e92f`. The unrelated unused `showsAccessReference` and no-AppIntents metadata warnings remain. `git diff --check` passes. Rendered proof app SHA-256: `1b76bda054a8b23c598048b48cfbf9f5e4cfd8b53f00a5c9634d18c5172dc581`.
- Visual evidence: `Proof/109-spatial-medication-carousel-simulator.png` passes the unchanged image-quality gate and route OCR 4/4; SHA-256 `1c9a077e570c57dc450a4a60dd76e33f07a5f927dcde2b95ce6bb58cc93f7036`. The inspected frame shows one large blister teaching prop, three available alternatives in depth, one compact control row and no stray selection bar.
- Accuracy boundary: all four props remain generic educational geometry. The workspace contains no dose, branded-product match, eligibility rule, individualized prescription, treatment ranking, stock claim or outcome promise. The existing NHS links remain the named source layer; this pass did not add or reinterpret clinical content.
- Verdict: `IMPROVED :)` — Medications now uses spatial depth and one clear focus instead of a flat four-item shelf, while the fallback controls and clinical boundary remain visible.
- Blocker: deterministic Simulator receipts do not establish physical gaze-and-pinch target quality, two-hand rotation comfort, headset depth perception, medicine recognition, clinical acceptance or App Store readiness.
- Next safe action: on Apple Vision Pro, select all four medication props and rotate the selected hero once, recording the first prop or control that is difficult to acquire.
- Layman equivalent: the medicine lesson now puts one object in front of you and keeps the other choices quietly behind it. You can move backward or forward without hunting through four equal objects, but someone still needs to try the real headset controls.

## 2026-08-28 18:16 SGT — direct, legible craniotomy layer study on `latest-arnav-build`

- Target: remove detached craniotomy UI and muddy alpha-stacked anatomy while preserving the generic, reversible teaching boundary. Budget: one focused clinician interaction pass; no `main` merge, paid provider use, operative simulation or new medical claim.
- Action: the clinician craniotomy point now opens the existing access-layer study directly instead of spawning another compact text disclosure. The deterministic craniotomy route follows the same product transition after authored assets mount. In the study, the registered parietal aperture remainder is now a faint 14% boundary while the independently movable bone flap and dura retain their authored full PBR appearance. Face, teeth, skull base and full dura remain hidden in this focused state. Back, Reset, explicit permission and forceps/direct-manipulation gates are preserved.
- Verification: `python3 Tests/verify_contract.py` passes. `swiftc -parse-as-library Sources/StrokeAccessLayerStudy.swift Tests/verify_access_layer_study.swift -o /tmp/verify-access-layer-study && /tmp/verify-access-layer-study` passes 16 checks. The narrow visionOS Simulator build succeeds for `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`; local ad-hoc signing and `codesign --verify --deep --strict` pass. Version remains `0.6 (29)`. Debug-library SHA-256: `d9e402923517a5acfe12f91f4f8946eb715c0078740b26f083f3f33e20e5380e`.
- Visual evidence: `Proof/110-direct-craniotomy-layer-study-simulator.png` passes the unchanged image-quality gate and route OCR 3/3 for `craniotomy layers`, `dura model` and `back`; SHA-256 `7653c0c9a1b5a543bc0861741b6c7e0179e434ffceb46de73d3e93abb3534d26`. The inspected frame shows one compact layer-control surface beneath the dominant brain, one faint registered aperture boundary and the two authored removable layers above it, without the detached generic point card, side rails or timeline competing for attention.
- Error and correction: the first standalone Swift verifier command omitted the model source and library parse mode, so it produced compile-entry errors and was not accepted. Re-running it with the source file and `-parse-as-library` passed. The pre-existing unused `showsAccessReference` warning remains unchanged because its contract and unrelated route are outside this pass.
- XCAT gate: `Scripts/deploy_xcat.zsh` stopped safely before build/install because the paired device state and tunnel were unavailable. Receipt: `Proof/xcat/20260828-175759/BLOCKED.md`. No physical-device visibility, reach, comfort, registration or gesture claim is made.
- Accuracy boundary: this is generic teaching anatomy, not a patient scan, site plan, operative instruction, surgical simulator or proof of anatomical registration. Layer fit, scale, interaction and wording remain pending specialist and wearer review.
- Verdict: `IMPROVED :)` — one relevant point now enters one spatially coherent layer study, and discrete layer disclosure replaces the muddy stacked-shell composition. The active product goal remains running; this pass does not claim the broader imaging, medication, internal-brain or release roadmap complete.
- Blocker: XCAT is not currently reachable, and Simulator rendering cannot establish physical interaction or clinical validity.
- Next safe action: have one neurosurgeon wearing Apple Vision Pro review this direct layer study for registration, scale, reach and wording, then record the first concrete correction.
- Layman equivalent: touching the craniotomy lesson now takes the presenter straight to the relevant layers. The thin transparent boundary shows where the opening belongs, while the removable bone and protective covering stay easy to distinguish. The Mac test passed, but a doctor still needs to try it in the headset.

## 2026-08-28 18:31 SGT — quiet, anatomy-attached clinician Pressure story

- Target: remove the two most obvious detached elements from the clinician Pressure scene while preserving the family entry cue and the registered brain, arteries, clot and affected-tissue story. Budget: one focused visual-hierarchy pass on `latest-arnav-build`; Simulator only; no `main` merge, provider use or new clinical claim.
- Action: hid the detached `OUTSIDE THE BRAIN` orientation card in clinician mode and after a family learner has entered a point or Atlas lesson. Replaced the old radial burst of long mint bars with twelve small spherical marks forming a restrained qualitative contour at the existing registered swelling anchor. The amber affected-tissue cue and blockage cue are unchanged. Added source-contract guards so the removed burst cannot return and the family-only orientation rule remains explicit.
- Verification: `python3 Tests/verify_contract.py` and `git diff --check` pass. The narrow visionOS Simulator build succeeds against `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`; ad-hoc signing and `codesign --verify --deep --strict` pass. Version remains `0.6 (29)`. Debug-library SHA-256: `7d88da035ae8a1f5a95dfacc95ed5a4150f40da53b5e6e5d44ab42e214ebca48`.
- Visual evidence: `Proof/111-quiet-clinician-pressure-story-simulator.png` passes the unchanged image-quality gate and route OCR 2/2 for `explain this` and `act 2 of 3`; SHA-256 `5a0ab6b7cad020c1e14633d2d335726954c2167603a16adb13c63280c252ddc5`. The inspected frame keeps the dominant registered brain, left explanation, right vertical reference rail and one timeline, while the high detached orientation card and long mint burst are absent. A separate family regression frame preserved `OUTSIDE THE BRAIN` and `BEGIN HERE`; its verifier passes 2/2 after replacing the stale `Explore next` OCR expectation with the text actually rendered.
- Errors and corrections: the first build wrapper used zsh's read-only `status` variable and exited before reporting the already-run command; the identical build was rerun with `build_exit` and succeeded. The family capture initially failed only the stale `Explore next` OCR token; visual inspection showed the current `BEGIN HERE` cue and correct family-only orientation card, so the verifier was aligned to that visible route without weakening image thresholds.
- Accuracy boundary: the mint contour is a qualitative teaching boundary. It does not encode edema volume, measured pressure, severity, a patient lesion border or diagnosis. Simulator receipts do not prove headset placement, gaze-and-pinch quality, wearer comprehension, registration accuracy or clinical validity.
- Verdict: `IMPROVED :)` — the clinician Pressure composition is quieter and more spatially coherent, while the family learner retains the one initial orientation cue.
- Blocker: physical interaction, stereo depth and specialist review remain unverified; this pass did not retry the XCAT gate recorded at `Proof/xcat/20260828-175759/BLOCKED.md`.
- Next safe action: have one clinician compare blockage, affected tissue and swelling in the headset and identify the first cue whose meaning or placement is unclear.
- Layman equivalent: the doctor's view no longer has a spare floating title or a firework of green bars. The pressure idea is now shown with a small dotted outline beside the affected area, while families still receive the short starting hint when they first enter.
