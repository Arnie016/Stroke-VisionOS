#!/bin/zsh

set -euo pipefail

readonly DEVICE_ID="613CC48C-A6AD-5170-A238-D518B6012491"
readonly DEVICE_NAME="XCAT"
readonly BUNDLE_ID="com.arnav.StrokeTime"
readonly SCRIPT_DIR="${0:A:h}"
readonly APP_ROOT="${SCRIPT_DIR:h}"
readonly PROJECT_PATH="${APP_ROOT}/StrokeTime.xcodeproj"
readonly APP_PATH="/Users/arnav/Library/Developer/Xcode/DerivedData/StrokeTime-equmrcwwnrxlypgajmnhksgdufei/Build/Products/Debug-xros/StrokeTime.app"
readonly RUN_ID="$(date '+%Y%m%d-%H%M%S')"
readonly RECEIPT_DIR="${APP_ROOT}/Proof/xcat/${RUN_ID}"

device_line="$(xcrun devicectl list devices | awk '$1 == "XCAT" { print; exit }')"
print -r -- "${device_line}"

if [[ -z "${device_line}" || "${device_line}" == *"unavailable"* ]]; then
    print -u2 -- "XCAT_DEPLOY=BLOCKED device is not reachable"
    print -u2 -- "Power on, wear, unlock, and keep XCAT near this Mac, then rerun."
    exit 2
fi

mkdir -p "${RECEIPT_DIR}"
print -r -- "${device_line}" > "${RECEIPT_DIR}/device-state.txt"

cd "${APP_ROOT}"

xcodebuild \
    -project "${PROJECT_PATH}" \
    -scheme StrokeTime \
    -destination 'generic/platform=visionOS' \
    build | tee "${RECEIPT_DIR}/build.log"

codesign --verify --deep --strict --verbose=2 "${APP_PATH}" \
    2>&1 | tee "${RECEIPT_DIR}/codesign.log"

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
    "${BUNDLE_ID}" | tee "${RECEIPT_DIR}/launch.txt"

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
- Signed build: PASS
- Install command: PASS
- Installed-app query: PASS
- Foreground launch command: PASS
- Running-process query: PASS
- Wearer comfort and clinical judgment: NOT TESTED BY THIS SCRIPT

The JSON and command logs beside this file are the authoritative machine
receipts. They do not prove what the wearer saw or understood.
EOF

print -- "XCAT_DEPLOY=PASS receipt=${RECEIPT_DIR}/RECEIPT.md"
