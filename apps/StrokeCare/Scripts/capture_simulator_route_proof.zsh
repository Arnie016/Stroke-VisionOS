#!/bin/zsh

set -euo pipefail

if (( $# != 4 )); then
    print -u2 -- "usage: $0 <simulator-udid> <StrokeTime.app> <proof-route> <output.png>"
    exit 64
fi

readonly simulator_id="$1"
readonly app_path="$2"
readonly proof_route="$3"
readonly output_path="$4"
readonly bundle_id="com.arnav.StrokeTime"
readonly script_dir="${0:A:h}"
readonly app_root="${script_dir:h}"
readonly settle_seconds="${PROOF_SETTLE_SECONDS:-8}"

case "${proof_route}" in
    --proof-case-unfold|--proof-spatial-intake|--proof-spatial-docked-case|\
    --proof-pressure|--proof-clinician-pressure|--proof-family-question|\
    --proof-procedure-field|--proof-layer-study|--proof-flow-layer-study|--proof-flow-exit|--proof-view-anterior|\
    --proof-view-lateral-a|--proof-view-lateral-b|--proof-view-superior|\
    --proof-evidence-window|--proof-evidence|--proof-clinician-toolkit|\
    --proof-care-purpose|--proof-exit-reset) ;;
    *)
        print -u2 -- "SIMULATOR_PROOF=FAIL unsupported-route=${proof_route}"
        exit 64
        ;;
esac

if [[ ! -d "${app_path}" ]]; then
    print -u2 -- "SIMULATOR_PROOF=FAIL app-bundle-missing=${app_path}"
    exit 66
fi

mkdir -p "${output_path:h}"
xcrun simctl bootstatus "${simulator_id}" -b
xcrun simctl terminate "${simulator_id}" "${bundle_id}" >/dev/null 2>&1 || true
xcrun simctl install "${simulator_id}" "${app_path}"

launch_output="$(xcrun simctl launch --terminate-running-process "${simulator_id}" "${bundle_id}" "${proof_route}")"
print -r -- "${launch_output}"
pid="${launch_output##*: }"
if [[ ! "${pid}" =~ '^[0-9]+$' ]]; then
    print -u2 -- "SIMULATOR_PROOF=FAIL launch-pid-missing"
    exit 70
fi

sleep "${settle_seconds}"
if ! kill -0 "${pid}" 2>/dev/null; then
    print -u2 -- "SIMULATOR_PROOF=FAIL exited-before-capture pid=${pid}"
    exit 70
fi

xcrun simctl io "${simulator_id}" screenshot "${output_path}"
xcrun --sdk macosx swift "${app_root}/Tests/verify_proof_route_image.swift" "${output_path}" "${proof_route}"

if ! kill -0 "${pid}" 2>/dev/null; then
    print -u2 -- "SIMULATOR_PROOF=FAIL exited-after-capture pid=${pid}"
    exit 70
fi

image_hash="$(shasum -a 256 "${output_path}" | awk '{print $1}')"
print -- "SIMULATOR_PROOF=PASS route=${proof_route} pid=${pid} image_sha256=${image_hash}"
print -- "SIMULATOR_PROOF_BOUNDARY=render-and-route-text-only;not-action-dispatch-wearer-device-or-clinical-proof"
