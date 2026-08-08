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
