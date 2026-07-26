#!/usr/bin/env bash
set -Eeuo pipefail

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
DOWNLOAD_MODELS="${DOWNLOAD_MODELS:-true}"

mkdir -p "${COMFYUI_DIR}/user/default/workflows"

# Keep the bundled workflow available even when /workspace is a mounted volume.
if [[ -f /opt/unlimitedlabs/workflow/UnlimitedLabs_motion_2.2v.json ]]; then
  cp -f /opt/unlimitedlabs/workflow/UnlimitedLabs_motion_2.2v.json \
    "${COMFYUI_DIR}/user/default/workflows/UnlimitedLabs_motion_2.2v.json"
fi

if [[ "${DOWNLOAD_MODELS,,}" == "true" ]]; then
  /opt/unlimitedlabs/download_models.sh
fi

cd "${COMFYUI_DIR}"
exec python3 main.py --listen 0.0.0.0 --port 8188 "$@"
