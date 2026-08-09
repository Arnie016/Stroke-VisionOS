#!/bin/zsh

set -euo pipefail

readonly DEVICE_ID="613CC48C-A6AD-5170-A238-D518B6012491"
readonly BUNDLE_ID="com.arnav.StrokeTime"
readonly RECEIPT_NAME="stroke-stage-placement.json"
readonly SCRIPT_DIR="${0:A:h}"
readonly APP_ROOT="${SCRIPT_DIR:h}"
readonly RUN_ID="$(date '+%Y%m%d-%H%M%S')"
readonly RECEIPT_DIR="${APP_ROOT}/Proof/xcat/${RUN_ID}-stage-placement"

mkdir -p "${RECEIPT_DIR}"

if ! xcrun devicectl device copy from \
    --device "${DEVICE_ID}" \
    --domain-type appDataContainer \
    --domain-identifier "${BUNDLE_ID}" \
    --source "Documents/${RECEIPT_NAME}" \
    --destination "${RECEIPT_DIR}/${RECEIPT_NAME}" \
    --timeout 30 \
    --json-output "${RECEIPT_DIR}/copy.json" \
    --log-output "${RECEIPT_DIR}/copy.log"; then
    cat > "${RECEIPT_DIR}/BLOCKED.md" <<EOF
# XCAT stage-placement receipt unavailable

- Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')
- Bundle: ${BUNDLE_ID}
- Expected device file: Documents/${RECEIPT_NAME}
- Machine placement evidence: NOT PROVEN
- Wearer evidence: NOT RUN
- Clinical evidence: NOT RUN

Enter the immersive anatomy stage once on XCAT, then rerun this collector.
EOF
    print -u2 -- "XCAT_STAGE_PLACEMENT=BLOCKED receipt=${RECEIPT_DIR}/BLOCKED.md"
    exit 2
fi

receipt_path="$(find "${RECEIPT_DIR}" -name "${RECEIPT_NAME}" -type f -print -quit)"
if [[ -z "${receipt_path}" ]]; then
    print -u2 -- "XCAT_STAGE_PLACEMENT=FAILED copied receipt is missing"
    exit 3
fi

jq -e '
    .placementSource == "WorldTrackingProvider.queryDeviceAnchor" and
    .placementMode == "sample-once-room-fixed" and
    .anchorTracked == true and
    .machineEvidence == "PLACEMENT_PATH_RAN" and
    .wearerEvidence == "NOT_RUN" and
    .clinicalEvidence == "NOT_RUN"
' "${receipt_path}" >/dev/null

receipt_sha="$(shasum -a 256 "${receipt_path}" | awk '{ print $1 }')"
cat > "${RECEIPT_DIR}/RECEIPT.md" <<EOF
# XCAT stage-placement machine receipt

- Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')
- Bundle: ${BUNDLE_ID}
- Placement JSON: ${receipt_path}
- SHA-256: ${receipt_sha}
- Tracked anchor path: PASS
- Sample-once room-fixed mode: PASS
- Raw room coordinates, gaze, hands, and patient data: NOT RECORDED
- Wearer placement and comfort: NOT RUN
- Clinical judgment: NOT RUN

This receipt proves only that the physical-device placement code path sampled a
tracked device anchor. It does not prove what the wearer saw or experienced.
EOF

print -- "XCAT_STAGE_PLACEMENT=PASS receipt=${RECEIPT_DIR}/RECEIPT.md"
