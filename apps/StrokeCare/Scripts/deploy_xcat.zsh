#!/bin/zsh

set -euo pipefail

readonly DEVICE_ID="613CC48C-A6AD-5170-A238-D518B6012491"
readonly DEVICE_NAME="XCAT"
readonly BUNDLE_ID="com.arnav.StrokeTime"
readonly PROOF_ROUTE="--hackathon-demo"
readonly SCRIPT_DIR="${0:A:h}"
readonly APP_ROOT="${SCRIPT_DIR:h}"
readonly PROJECT_PATH="${APP_ROOT}/StrokeTime.xcodeproj"
readonly DERIVED_DATA_DIR="/tmp/stroke-care-xcat-derived-data"
readonly APP_PATH="${DERIVED_DATA_DIR}/Build/Products/Debug-xros/StrokeTime.app"
readonly RUN_ID="$(date '+%Y%m%d-%H%M%S')"
readonly RECEIPT_DIR="${APP_ROOT}/Proof/xcat/${RUN_ID}"
readonly DEVICE_JSON="${RECEIPT_DIR}/device-list.json"

mkdir -p "${RECEIPT_DIR}"
xcrun devicectl list devices --json-output "${DEVICE_JSON}" >/dev/null

device_line="$(xcrun devicectl list devices | awk '$1 == "XCAT" { print; exit }')"
print -r -- "${device_line}"
print -r -- "${device_line}" > "${RECEIPT_DIR}/device-state.txt"

tunnel_state="$(jq -r --arg id "${DEVICE_ID}" '.result.devices[] | select(.identifier == $id) | .connectionProperties.tunnelState // "unknown"' "${DEVICE_JSON}")"
pairing_state="$(jq -r --arg id "${DEVICE_ID}" '.result.devices[] | select(.identifier == $id) | .connectionProperties.pairingState // "unknown"' "${DEVICE_JSON}")"
ddi_services="$(jq -r --arg id "${DEVICE_ID}" '.result.devices[] | select(.identifier == $id) | .deviceProperties.ddiServicesAvailable // false' "${DEVICE_JSON}")"

tunnel_state="${tunnel_state:-unknown}"
pairing_state="${pairing_state:-unknown}"
ddi_services="${ddi_services:-false}"

if [[ -z "${device_line}" || "${device_line}" == *"unavailable"* ]]; then
    cat > "${RECEIPT_DIR}/BLOCKED.md" <<EOF
# XCAT deployment blocked

- Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')
- Device: ${DEVICE_NAME} / ${DEVICE_ID}
- State: unavailable
- Tunnel state: ${tunnel_state}
- Pairing state: ${pairing_state}
- DDI services available: ${ddi_services}
- Build attempted: NO
- Install attempted: NO
- Foreground launch attempted: NO
- Wearer and clinical evidence: NOT RUN

This is a reachability receipt only. It is not a build, install, launch,
wearer, or clinical-validation receipt.
EOF
    print -u2 -- "XCAT_DEPLOY=BLOCKED receipt=${RECEIPT_DIR}/BLOCKED.md"
    print -u2 -- "Power on, wear, unlock, and keep XCAT near this Mac, then rerun."
    exit 2
fi

cd "${APP_ROOT}"

xcodebuild \
    -project "${PROJECT_PATH}" \
    -scheme StrokeTime \
    -destination 'generic/platform=visionOS' \
    -derivedDataPath "${DERIVED_DATA_DIR}" \
    -allowProvisioningUpdates \
    build | tee "${RECEIPT_DIR}/build.log"

if [[ ! -d "${APP_PATH}" ]]; then
    print -u2 -- "XCAT_DEPLOY=FAILED expected app bundle is missing: ${APP_PATH}"
    exit 3
fi

codesign --verify --deep --strict --verbose=2 "${APP_PATH}" \
    2>&1 | tee "${RECEIPT_DIR}/codesign.log"

codesign --display --verbose=4 "${APP_PATH}" \
    2>&1 | tee "${RECEIPT_DIR}/signing-details.log"

version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "${APP_PATH}/Info.plist")"
build="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "${APP_PATH}/Info.plist")"

xcrun devicectl device install app \
    --device "${DEVICE_ID}" \
    --timeout 90 \
    --json-output "${RECEIPT_DIR}/install.json" \
    --log-output "${RECEIPT_DIR}/install.log" \
    "${APP_PATH}"

xcrun devicectl device info apps \
    --device "${DEVICE_ID}" \
    --bundle-id "${BUNDLE_ID}" \
    --timeout 30 \
    --json-output "${RECEIPT_DIR}/installed-app.json" \
    --log-output "${RECEIPT_DIR}/installed-app.log" \
    | tee "${RECEIPT_DIR}/installed-app.txt"

xcrun devicectl device process launch \
    --device "${DEVICE_ID}" \
    --terminate-existing \
    --activate \
    --timeout 30 \
    --json-output "${RECEIPT_DIR}/launch.json" \
    --log-output "${RECEIPT_DIR}/launch.log" \
    "${BUNDLE_ID}" -- "${PROOF_ROUTE}" | tee "${RECEIPT_DIR}/launch.txt"

xcrun devicectl device info processes \
    --device "${DEVICE_ID}" \
    --filter "Name == 'StrokeTime'" \
    --timeout 30 \
    --json-output "${RECEIPT_DIR}/process.json" \
    --log-output "${RECEIPT_DIR}/process.log" \
    | tee "${RECEIPT_DIR}/process.txt"

if ! rg -q "StrokeTime" "${RECEIPT_DIR}/process.txt"; then
    print -u2 -- "XCAT_DEPLOY=FAILED no running StrokeTime process receipt"
    exit 3
fi

cat > "${RECEIPT_DIR}/RECEIPT.md" <<EOF
# XCAT deployment receipt

- Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')
- Device: ${DEVICE_NAME} / ${DEVICE_ID}
- Bundle: ${BUNDLE_ID}
- Version/build: ${version} (${build})
- Deterministic launch route: ${PROOF_ROUTE}
- Signed build: PASS
- Install command: PASS
- Installed-app query: PASS
- Foreground launch command: PASS
- Running-process query: PASS
- Wearer comfort and clinical judgment: NOT TESTED BY THIS SCRIPT

The JSON and command logs beside this file are the authoritative machine
receipts. They do not prove what the wearer saw or understood.
EOF

cat > "${RECEIPT_DIR}/WEARER_RESULT.md" <<EOF
# XCAT wearer result — NOT RUN

- Device: ${DEVICE_NAME} / ${DEVICE_ID}
- App version/build: ${version} (${build})
- Deterministic launch route: ${PROOF_ROUTE}
- Headset screenshot: NOT CAPTURED
- LEGIBILITY: NOT RUN
- GESTURE: NOT RUN
- COMFORT: NOT RUN
- COMPREHENSION: NOT RUN

Complete this file only after wearing XCAT and following
Proof/XCAT_ACCEPTANCE.md. A running process is not wearer evidence.
EOF

print -- "XCAT_DEPLOY=PASS receipt=${RECEIPT_DIR}/RECEIPT.md"
