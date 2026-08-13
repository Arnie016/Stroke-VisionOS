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
readonly SETTLE_SECONDS="${PROOF_SETTLE_SECONDS:-8}"

case "${PROOF_ROUTE}" in
    --proof-spatial-intake|--proof-pressure|--proof-family-pressure-story|--proof-clinician-pressure-story|--proof-clinician-craniotomy|--proof-family-make-space-purpose|--proof-family-surface-reference|--proof-family-arterial-reference|--proof-family-layer-reference) ;;
    *)
        print -u2 -- "SIMULATOR_PROOF=FAIL unsupported route ${PROOF_ROUTE}"
        exit 64
        ;;
esac

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
xcrun simctl install "${SIMULATOR_ID}" "${APP_PATH}"

launch_output="$(xcrun simctl launch --terminate-running-process "${SIMULATOR_ID}" "${BUNDLE_ID}" "${PROOF_ROUTE}")"
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
