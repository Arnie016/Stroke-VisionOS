# PR 46 Layered App-Icon Repair Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the two blank `Inside the Flow` visionOS AppIcon overlay PNGs with intentional transparent educational artwork and make pixel-level validation permanent.

**Architecture:** Keep the approved RGB backplate byte-identical. Add one standalone Swift ImageIO/CoreGraphics verifier that resolves the real asset-catalog JSON, decodes all three PNGs into RGBA bytes, and enforces background and overlay invariants; invoke it from the existing Python contract. Accept only image-generated, transparent middle and foreground overlays, then validate the source catalog, universal compiled app, and exact compiled asset catalog.

**Tech Stack:** Swift 6, Foundation, ImageIO, CoreGraphics, Python 3 contract runner, Xcode 27 asset compiler, visionOS Simulator SDK.

## Global Constraints

- Base commit is exactly `5e1b5ec53dbe4b287c0b14c4a36c727dd2426af6`.
- Modify only the RBC Journey AppIcon overlays, their verifier/contract, and design/plan documentation.
- Keep `Back.solidimagestacklayer/Content.imageset/icon.png` byte-identical with SHA-256 `47147dbb2bbd46b649f541b014db4f8125847159e345670e1cd0cce5ccbb82e9`.
- Middle and Front remain 1024 by 1024 RGBA PNGs with meaningful transparency and realistic, non-diagnostic educational content.
- Add no text, clinical symbols, patient implication, measured-flow implication, or StrokeCare runtime dependency.
- Do not edit the parallel `apps/StrokeCare` asset catalog.
- Do not write to GitHub or use the shared Simulator without explicit coordination.

---

### Task 1: Pixel-decoding AppIcon verifier

**Files:**
- Create: `Experiments/RBCJourneyVision/Tests/verify_app_icon_layers.swift`
- Modify: `Experiments/RBCJourneyVision/Tests/verify_contract.py`

**Interfaces:**
- Consumes: one optional asset-stack directory argument; default is `Resources/Assets.xcassets/AppIcon.solidimagestack` relative to the RBC project.
- Produces: one `APP_ICON_LAYER|...` receipt per layer and either `RBC_APP_ICON_LAYERS=PASS|layers=3` with exit 0 or `RBC_APP_ICON_LAYERS=FAIL|...` with exit 1.

- [ ] **Step 1: Write the pixel verifier and contract invocation before changing any PNG**

  Parse `Contents.json` with `JSONSerialization`, resolve each layer's `Content.imageset/Contents.json`, decode its referenced PNG with `CGImageSourceCreateWithURL`, render into an eight-bit RGBA `CGContext`, and compute literal statistics: dimensions, source alpha capability, transparent pixels, visible pixels, colored visible pixels, effectively black pixels, and quantized unique RGBA values.

  Enforce these independent requirements:

  ```swift
  width == 1024 && height == 1024
  uniqueRGBA >= 64
  // Middle and Front only:
  sourceHasAlpha
  transparentFraction >= 0.10
  visibleFraction >= 0.01 && visibleFraction <= 0.85
  coloredVisibleFraction >= 0.005
  blackVisibleFraction < 0.90
  ```

  Add the verifier file to `required_files` and invoke it from `verify_contract.py` with `xcrun --sdk macosx swift`, failing the contract when its exit status is nonzero.

- [ ] **Step 2: Run the untouched exact-head contract and verify RED**

  Run:

  ```bash
  python3 Experiments/RBCJourneyVision/Tests/verify_contract.py
  ```

  Expected: exit 1 with `RBC_APP_ICON_LAYERS=FAIL`; Middle and Front must report missing alpha, uniform/insufficient variation, opaque black, and insufficient transparent/colored content. A syntax or path error does not count as RED.

- [ ] **Step 3: Typecheck the verifier independently**

  Run:

  ```bash
  xcrun --sdk macosx swiftc -typecheck Experiments/RBCJourneyVision/Tests/verify_app_icon_layers.swift
  ```

  Expected: exit 0.

---

### Task 2: Replace only invalid overlay artwork

**Files:**
- Modify: `Experiments/RBCJourneyVision/Resources/Assets.xcassets/AppIcon.solidimagestack/Middle.solidimagestacklayer/Content.imageset/icon.png`
- Modify: `Experiments/RBCJourneyVision/Resources/Assets.xcassets/AppIcon.solidimagestack/Front.solidimagestacklayer/Content.imageset/icon.png`

**Interfaces:**
- Consumes: two inspected 1024-pixel transparent PNGs generated from the approved brain/vessel backplate and authored RBC visual references.
- Produces: one subtle vascular-flow middle overlay and one realistic biconcave-cell/focus foreground overlay; both preserve the backplate beneath them.

- [ ] **Step 1: Inspect generated source overlays before installation**

  Use the local image viewer at original detail. Reject opaque backgrounds, text, symbols, anatomy-like decorative particles, near-field cables, giant arrows, unreadable darkness, altered brain anatomy, or a design that covers material backplate detail.

- [ ] **Step 2: Install the two approved PNGs without touching the Back layer**

  Copy only the inspected generated Middle and Front sources to the exact asset-catalog destinations. Record source and destination SHA-256 values and re-check the Back SHA-256 literal from Global Constraints.

- [ ] **Step 3: Run the verifier and full contract to verify GREEN**

  Run:

  ```bash
  xcrun --sdk macosx swift Experiments/RBCJourneyVision/Tests/verify_app_icon_layers.swift
  python3 Experiments/RBCJourneyVision/Tests/verify_contract.py
  ```

  Expected: `RBC_APP_ICON_LAYERS=PASS|layers=3` and `RBC_CONTRACT=PASS`.

- [ ] **Step 4: Mutation-check both repaired layers**

  Run the verifier against a temporary copy of the AppIcon stack after replacing either Middle or Front with the original all-black fixture. Expected: exit 1 naming that layer. Restore the real stack and rerun for exit 0.

---

### Task 3: Exact catalog, build, and bundle verification

**Files:**
- Verify: `Experiments/RBCJourneyVision/Resources/Assets.xcassets/AppIcon.solidimagestack/**/Contents.json`
- Verify: generated `RBCJourneyVision.app/Assets.car`

**Interfaces:**
- Consumes: the green source AppIcon stack.
- Produces: a universal arm64/x86_64 app bundle with exact identity/resources and compiled Back/Middle/Front AppIcon records.

- [ ] **Step 1: Validate catalog references**

  Use `plutil -lint` for the stack and all layer/image-set `Contents.json` files. Resolve every declared filename and require exactly `Front`, `Middle`, and `Back` in that order.

- [ ] **Step 2: Build both Simulator architectures**

  Run:

  ```bash
  xcodebuild -project Experiments/RBCJourneyVision/RBCJourneyVision.xcodeproj \
    -scheme RBCJourneyVision \
    -sdk xrsimulator \
    -destination 'generic/platform=visionOS Simulator' \
    ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO CODE_SIGNING_ALLOWED=NO \
    -derivedDataPath /private/tmp/pr46-icon-fix-derived build
  ```

  Expected: `** BUILD SUCCEEDED **`; the Swift payload reports `arm64 x86_64`.

- [ ] **Step 3: Verify the exact bundle and compiled catalog**

  Run `Tests/verify_built_bundle.py` against the exact generated app. Require identifier `com.arnav.RBCJourneyVision`, display name `Inside the Flow`, version `0.1.0 (1)`, exact ten packaged USDZ models, source-byte equality, audio/manifest presence, and `Assets.car`.

  Run `assetutil --info` on `Assets.car`; require AppIcon records for Back, Middle, Front, and the flattened rendition, with nonzero and non-identical payload sizes/hashes where extractable.

- [ ] **Step 4: Validate packaged USDZ resources**

  Run `/usr/bin/usdchecker --arkit --strict` on every packaged USDZ file and require exactly ten `Success` results.

- [ ] **Step 5: Visually inspect source and compiled results**

  View Back, Middle, and Front separately at original resolution. Extract or render the compiled flattened AppIcon from `Assets.car` and verify that the realistic brain remains legible, the overlays create restrained depth, and no black slab, text, or clinical claim is present.

---

### Task 4: Final verification and clean handoff

**Files:**
- Review all files changed from exact base.

**Interfaces:**
- Consumes: verified implementation and evidence.
- Produces: one clean local commit and an exact publication handoff; no remote mutation.

- [ ] **Step 1: Run fresh completion gates**

  Run `git diff --check`, the full contract, independent Swift verifier typecheck/run, universal build, exact bundle verifier, compiled catalog inspection, Back checksum assertion, and ten strict USDZ validations. Read every exit status before claiming success.

- [ ] **Step 2: Inspect the exact diff**

  Confirm only the two RBC overlay PNGs, pixel verifier, contract invocation, design note, and implementation plan changed. Confirm the StrokeCare catalog and RBC Back image are byte-identical to base.

- [ ] **Step 3: Commit locally**

  Commit the repair on `fix/pr46-icon-layers` with a concise message such as `fix(rbc): restore layered app icon`, then report exact base/head, worktree, changed files, image statistics/hashes, build/catalog/resource evidence, visual inspection, and device/clinical-proof boundaries.
