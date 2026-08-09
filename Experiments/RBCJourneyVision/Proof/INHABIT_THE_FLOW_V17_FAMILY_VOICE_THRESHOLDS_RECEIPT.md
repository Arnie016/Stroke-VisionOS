# Inhabit the Flow V17 — family voice thresholds

Date: 2026-08-10 (Asia/Singapore)

Verdict: **PASS — bounded native implementation, 64/64 contract checks,
transcript-integrity self-test, generic visionOS Simulator build, and one
Simulator composition proof. LIMITED — no provider narration, paid inference,
XCAT/wearer evaluation, loudness/latency judgment, or comprehension study.**

## Interaction hypothesis

An optional family guide is more useful when it explains the spatial crossing
the wearer has actually chosen, rather than behaving like a detached audio
tour. If the family companion is already on, selecting a region now produces
this sequence:

1. The existing portal threshold shows and speaks the same short reviewed copy:
   `Entering <region>. The room moves. You stay.`
2. The transition holds only while that line is loading or playing, after its
   normal visual minimum, with a hard seven-second additional wait.
3. Arrival changes the visible copy to the selected region's reviewed title and
   paragraph; the same exact-caption pipeline then reads that destination.
4. The cerebral-flow ambience ducks to at most -42 dB while narration is
   loading or speaking, then returns to its authored level.

The feature remains off by default. It is a patient/family orientation mode,
not a clinician default, diagnostic assistant, conversational medical agent, or
replacement for the visible lesson. No microphone permission was added.

## Failure and accessibility behavior

- The caption and region transition work with sound off or no local proxy.
- A provider/network failure cannot trap the wearer between regions.
- Returned audio is still rejected unless model, exact-copy SHA-256, and
  punctuation-insensitive transcript SHA-256 match the reviewed request.
- There is still no system-voice fallback that could silently bypass the
  transcript gate.
- Reduce Motion retains the existing shorter visual transition; the optional
  narration wait remains bounded.

## Verification

- `python3 Tests/verify_contract.py`: **PASS, 64/64**.
- `node --check Scripts/rbc_realtime_narration_proxy.mjs`: **PASS**.
- `node Scripts/rbc_realtime_narration_proxy.mjs --integrity-self-test`:
  `RBC_NARRATION_INTEGRITY_SELF_TEST=PASS cases=2`.
- `zsh -n Scripts/run_rbc_realtime_proxy.zsh`: **PASS**.
- Silent Keychain presence check: `OPENAI_API_KEY=AVAILABLE_IN_KEYCHAIN`.
  The value was not printed, exported, or used.
- Generic build:

  ```text
  xcodebuild -project RBCJourneyVision.xcodeproj \
    -scheme RBCJourneyVision \
    -sdk xrsimulator \
    -destination 'generic/platform=visionOS Simulator' \
    -derivedDataPath /tmp/rbc-journey-v17-derived \
    CODE_SIGNING_ALLOWED=NO build
  ** BUILD SUCCEEDED **
  ```

- SDK: `xrsimulator26.5`; deployment target: visionOS 2.0.
- Product: universal arm64 + x86_64 Simulator app; 56,460 KiB.
- Installed/launched on booted Apple Vision Pro Simulator
  `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777` with:
  `--proof-region-transition-8 --proof-region-family-companion
  --proof-region-transition-progress-55`.

## Visual proof

- `182-family-voice-region-threshold-accepted.png`
  - 3840 × 2160
  - SHA-256:
    `d5051939eafe177471857b64a2657b13f33671f6014b230956f27fbe002a54e4`
  - Shows the wearer-stable visual-cortex threshold and the exact two-line copy
    shared with narration. It does not prove that speech played.

## Source receipts

- `RBCFamilyNarrationEngine.swift`:
  `f57f8a3cbf401d9c226e922c77c8e5e1808e89c4c995b386626c3124def05c02`
- `RBCJourneyModel.swift`:
  `48c19c2fb4fe463c70f8304af243e87a39031eb7f6c0feb90bc753d7ba61fef2`
- `RBCJourneyImmersiveView.swift`:
  `3effa396605346ef84ff6a1583b78f428db0560ea6ec48ded7ead28da1d4e85a`
- `RBCJourneyScene.swift`:
  `26ab798bcbd72a2d6fbfd4af124c115f87ecfcdcf10e0879de4a9fd447172880`
- `RBCJourneyHUD.swift`:
  `7193e6fff89b86f4f7a90c3142e1d7df443048a407ebf831f6a6e9e37ebb2812`
- `verify_contract.py`:
  `4dee1b7296cbb5d67e9379d132369c87e37bba4af54cc79c87c468f100e79938`

## Current provider canon

The user-spoken name is interpreted as OpenAI's model ID
`gpt-realtime-2.1`. OpenAI's current model page lists audio input/output,
improved interruption behavior, and the `/v1/realtime` endpoint. The current
prototype deliberately uses output-only exact-caption narration through the
existing developer-controlled loopback proxy.

- <https://developers.openai.com/api/docs/models/gpt-realtime-2.1>
- <https://developers.openai.com/api/docs/guides/realtime-websocket>
- <https://developers.openai.com/api/docs/guides/realtime-conversations>

## Remaining human gate

With explicit permission to spend a small amount of API credit, start the
loopback proxy, test one reviewed threshold and one destination on XCAT, and
judge intelligibility, interruption, ambience ducking, latency, comfort, and
whether voice adds understanding beyond the visible caption. Until then this is
secure routing and Simulator proof, not live voice proof.
