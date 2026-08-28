#!/bin/zsh

set -euo pipefail

if (( $# != 4 )); then
    print -u2 -- "usage: $0 <simulator-udid> <StrokeTime.app> <proof-route> <output.png>"
    exit 64
fi

readonly SIMULATOR_ID="$1"
readonly APP_PATH="$2"
readonly PROOF_ROUTE="$3"
readonly OUTPUT_PATH="$4"
readonly BUNDLE_ID="com.arnav.StrokeTime"
readonly SCRIPT_DIR="${0:A:h}"
readonly APP_ROOT="${SCRIPT_DIR:h}"
readonly REQUESTED_SETTLE_SECONDS="${PROOF_SETTLE_SECONDS:-8}"
readonly LAUNCH_TIMEOUT_SECONDS="${PROOF_LAUNCH_TIMEOUT_SECONDS:-45}"
SETTLE_SECONDS="${REQUESTED_SETTLE_SECONDS}"

case "${PROOF_ROUTE}" in
    --proof-imaging-gallery-placed|--proof-imaging-gallery-placed-local|--proof-imaging-gallery-placement-return) ;;
    --proof-imaging-gallery|--proof-imaging-gallery-nine|--proof-imaging-gallery-sixteen|--proof-imaging-gallery-detail|--proof-imaging-gallery-return) ;;
    --proof-imaging-import-lifecycle|--proof-imaging-import-return) ;;
    --proof-reference-medications|--proof-reference-guides|--proof-reference-return|--proof-imaging-room) ;;
    --proof-access-layer-open|--proof-access-layer-closed) ;;
    --proof-role-choice|--proof-spatial-prelude|--proof-spatial-prelude-hero|--proof-print-request|--proof-realtime-narration|--proof-family-read-more|--proof-spatial-intake|--proof-selected-case-handoff|--proof-pressure|--proof-family-pressure-story|--proof-family-entry-hint|--proof-clinician-pressure-story|--proof-presenter-controls|--proof-presentation-settings|--proof-clinician-toolkit|--proof-clinician-toolkit-full|--proof-clinician-toolkit-motion|--proof-clinician-craniotomy|--proof-teaching-imaging|--proof-imaging-window|--proof-imaging-window-term-note|--proof-imaging-modality-reference|--proof-imaging-pet-term-note|--proof-imaging-study-deck|--proof-imaging-return-to-anatomy|--proof-imaging-return-reopen|--proof-imaging-term-return-reopen|--proof-imaging-local-import|--proof-spatial-annotation|--proof-spatial-ink|--proof-family-make-space-purpose|--proof-family-affected-reference|--proof-family-surface-reference|--proof-family-neuron-reference|--proof-family-neuron-plain-words|--proof-family-nearby-reference|--proof-family-explore-nearby|--proof-family-opposite-reference|--proof-family-arterial-reference|--proof-family-arterial-supply-reference|--proof-family-arterial-branch-reference|--proof-family-arterial-beyond-reference|--proof-family-explore-beyond|--proof-family-arterial-territory-reference|--proof-family-vessel-route-trace|--proof-family-blockage-interior|--proof-family-blockage-return|--proof-family-layer-reference|--proof-family-atlas-surface-cue|--proof-family-atlas-direct-surface-pick|--proof-family-atlas-temporal-cue|--proof-family-atlas-internal-reference|--proof-family-atlas-internal-plain-words|--proof-family-atlas-cerebellum-journey|--proof-anatomy-internal|--proof-integrated-interior|--proof-integrated-ventricles|--proof-integrated-cortex|--proof-integrated-cortex-flow|--proof-integrated-neural-gradient|--proof-integrated-neural|--proof-integrated-loading) ;;
    *)
        print -u2 -- "SIMULATOR_PROOF=FAIL unsupported route ${PROOF_ROUTE}"
        exit 64
        ;;
esac

# The launch hero now loads a substantial bundled USDZ rather than only the
# conceptual placeholder. Hold the deterministic proof long enough to inspect
# the loaded model rather than accidentally validating its fallback frame.
if [[ "${PROOF_ROUTE}" == --proof-spatial-prelude-hero ]] &&
    (( ${SETTLE_SECONDS} < 20 )); then
    SETTLE_SECONDS=20
fi

# The full arterial route loads the hero brain, registered arterial tree, and
# its selected-point SwiftUI attachment. An early frame can contain enough of
# the right caption to satisfy generic route OCR while the hero and callout are
# still resolving. Give this asset-heavy proof a deterministic cold-start floor.
if [[ "${PROOF_ROUTE}" == --proof-family-arterial-* ||
    "${PROOF_ROUTE}" == --proof-family-vessel-route-trace ]] &&
    (( ${SETTLE_SECONDS} < 15 )); then
    SETTLE_SECONDS=15
fi
if [[ "${PROOF_ROUTE}" == --proof-family-blockage-interior ||
      "${PROOF_ROUTE}" == --proof-family-blockage-return ]] &&
    (( ${SETTLE_SECONDS} < 20 )); then
    SETTLE_SECONDS=20
fi
# Affected is selected at launch before the shared registered arterial
# reference has had a normal user-paced prelude to resolve. Give this cold-start
# route the same honest readiness margin rather than accepting its caption
# while the right-side 3D object is still absent.
if [[ "${PROOF_ROUTE}" == --proof-family-affected-reference ]] &&
    (( ${SETTLE_SECONDS} < 20 )); then
    SETTLE_SECONDS=20
fi
# The point-led neuron object is created after the mixed ImmersiveSpace has
# opened. A shorter capture can correctly launch the app yet only photograph
# the room before the reference is attached.
if [[ "${PROOF_ROUTE}" == --proof-family-neuron-reference ||
      "${PROOF_ROUTE}" == --proof-family-neuron-plain-words ]] &&
    (( ${SETTLE_SECONDS} < 15 )); then
    SETTLE_SECONDS=15
fi
# The full surface teaching model is a separate registered assembly, not a
# caption-only state. On a cold Simulator launch it can resolve after the
# initial hero root, so an eight-second screenshot can photograph the room
# before the actual surface reference is present. Keep the proof honest by
# waiting for the same completed composition the learner receives.
if [[ "${PROOF_ROUTE}" == --proof-family-surface-reference ||
      "${PROOF_ROUTE}" == --proof-family-read-more ]] &&
    (( ${SETTLE_SECONDS} < 18 )); then
    SETTLE_SECONDS=18
fi
if [[ "${PROOF_ROUTE}" == --proof-family-atlas-internal-reference ||
      "${PROOF_ROUTE}" == --proof-family-atlas-internal-plain-words ||
      "${PROOF_ROUTE}" == --proof-family-atlas-cerebellum-journey ]] &&
    (( ${SETTLE_SECONDS} < 18 )); then
    SETTLE_SECONDS=18
fi
if [[ "${PROOF_ROUTE}" == --proof-anatomy-internal ]] &&
    (( ${SETTLE_SECONDS} < 28 )); then
    # This composition is valid only after the detailed root has resolved its
    # deep-structure and ventricular USDZ references. The complete registered
    # assembly also loads its optional reference layers serially, so an
    # 18-second snapshot can still catch the compact fallback one frame before
    # the complete root swaps in on a cold Simulator launch.
    SETTLE_SECONDS=28
fi
if [[ "${PROOF_ROUTE}" == --proof-integrated-interior
    || "${PROOF_ROUTE}" == --proof-integrated-ventricles
    || "${PROOF_ROUTE}" == --proof-integrated-cortex
    || "${PROOF_ROUTE}" == --proof-integrated-cortex-flow
    || "${PROOF_ROUTE}" == --proof-integrated-neural-gradient
    || "${PROOF_ROUTE}" == --proof-integrated-neural
    || "${PROOF_ROUTE}" == --proof-integrated-loading ]] &&
    (( ${SETTLE_SECONDS} < 20 )); then
    SETTLE_SECONDS=20
fi
readonly SETTLE_SECONDS

if [[ ! -d "${APP_PATH}" ]]; then
    print -u2 -- "SIMULATOR_PROOF=FAIL app bundle is missing: ${APP_PATH}"
    exit 66
fi

mkdir -p "${OUTPUT_PATH:h}"
xcrun simctl bootstatus "${SIMULATOR_ID}" -b

# Only one immersive app may own the Simulator scene. End known local
# competitors before installing and launching this exact build candidate.
for competing_bundle in \
    com.arnav.RBCJourneyVision \
    com.arnav.WaterfallPortalVision \
    com.arnav.SpatialPropertiesLab
do
    xcrun simctl terminate "${SIMULATOR_ID}" "${competing_bundle}" >/dev/null 2>&1 || true
done
xcrun simctl terminate "${SIMULATOR_ID}" "${BUNDLE_ID}" >/dev/null 2>&1 || true
# visionOS can restore an ImmersiveSpace even after the process exits. A proof
# route must start at the app's route-owning launch view, not inherit a prior
# scene's controls or state. This affects only the named Simulator app and its
# fictional teaching data; it never targets a physical device.
xcrun simctl uninstall "${SIMULATOR_ID}" "${BUNDLE_ID}" >/dev/null 2>&1 || true
xcrun simctl install "${SIMULATOR_ID}" "${APP_PATH}"

launch_arguments=("${PROOF_ROUTE}")
# The Stroke shell owns this route name, while the linked internal journey
# owns the authored arterial-lumen composition. Pass both so the rendered
# proof exercises the same high-detail teaching state as the in-app button.
if [[ "${PROOF_ROUTE}" == --proof-family-blockage-interior ||
      "${PROOF_ROUTE}" == --proof-family-blockage-return ]]; then
    launch_arguments+=(--proof-exhibit-1)
fi
launch_stdout="$(mktemp -t strokecare-proof-launch-stdout)"
launch_stderr="$(mktemp -t strokecare-proof-launch-stderr)"
cleanup_launch_files() {
    rm -f "${launch_stdout}" "${launch_stderr}"
}
trap cleanup_launch_files EXIT

xcrun simctl launch --terminate-running-process \
    "${SIMULATOR_ID}" \
    "${BUNDLE_ID}" \
    "${launch_arguments[@]}" \
    >"${launch_stdout}" \
    2>"${launch_stderr}" &
launch_command_pid=$!

for (( second = 0; second < LAUNCH_TIMEOUT_SECONDS; second += 1 )); do
    if ! kill -0 "${launch_command_pid}" 2>/dev/null; then
        break
    fi
    sleep 1
done

if kill -0 "${launch_command_pid}" 2>/dev/null; then
    kill "${launch_command_pid}" 2>/dev/null || true
    wait "${launch_command_pid}" 2>/dev/null || true
    cat "${launch_stderr}" >&2
    print -u2 -- "SIMULATOR_PROOF=FAIL launch exceeded ${LAUNCH_TIMEOUT_SECONDS}s; Simulator shell may be unhealthy"
    exit 70
fi

if ! wait "${launch_command_pid}"; then
    cat "${launch_stderr}" >&2
    print -u2 -- "SIMULATOR_PROOF=FAIL simctl launch command failed"
    exit 70
fi

launch_output="$(<"${launch_stdout}")"
print -r -- "${launch_output}"
pid="${launch_output##*: }"
if [[ ! "${pid}" =~ '^[0-9]+$' ]]; then
    print -u2 -- "SIMULATOR_PROOF=FAIL launch did not return a PID"
    exit 70
fi

sleep "${SETTLE_SECONDS}"
if ! kill -0 "${pid}" 2>/dev/null; then
    print -u2 -- "SIMULATOR_PROOF=FAIL StrokeTime exited before capture pid=${pid}"
    exit 70
fi

xcrun simctl io "${SIMULATOR_ID}" screenshot "${OUTPUT_PATH}"
python3 "${APP_ROOT}/Tests/verify_proof_image.py" \
    "${OUTPUT_PATH}" \
    --route="${PROOF_ROUTE}"

if ! kill -0 "${pid}" 2>/dev/null; then
    print -u2 -- "SIMULATOR_PROOF=FAIL StrokeTime exited after capture pid=${pid}"
    exit 70
fi

version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "${APP_PATH}/Info.plist")"
build="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "${APP_PATH}/Info.plist")"
git_head="$(git -C "${APP_ROOT}" rev-parse HEAD)"
app_hash="$(find "${APP_PATH}" -type f -name 'StrokeTime*' -perm +111 -maxdepth 2 -print -quit | xargs shasum -a 256 | awk '{print $1}')"
image_hash="$(shasum -a 256 "${OUTPUT_PATH}" | awk '{print $1}')"

print -- "SIMULATOR_PROOF=PASS route=${PROOF_ROUTE} version=${version} build=${build} pid=${pid}"
print -- "SIMULATOR_PROOF_GIT_HEAD=${git_head}"
print -- "SIMULATOR_PROOF_APP_SHA256=${app_hash}"
print -- "SIMULATOR_PROOF_IMAGE_SHA256=${image_hash}"
print -- "SIMULATOR_PROOF_BOUNDARY=render-and-process-only;not-wearer-or-clinical-proof"
