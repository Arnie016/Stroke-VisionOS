#!/bin/zsh
set -euo pipefail

script_dir="${0:A:h}"

if ! command -v apikey >/dev/null 2>&1; then
  print -u2 "RBC_REALTIME_PROXY=BLOCKED reason=apikey_cli_unavailable"
  exit 1
fi

if ! apikey get OPENAI_API_KEY >/dev/null 2>&1; then
  print -u2 "RBC_REALTIME_PROXY=BLOCKED reason=openai_api_key_unavailable"
  exit 1
fi

OPENAI_API_KEY="$(apikey get OPENAI_API_KEY)" exec node "${script_dir}/rbc_realtime_narration_proxy.mjs"
