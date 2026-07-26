#!/usr/bin/env bash
set -Eeuo pipefail

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
CUSTOM_NODES="${COMFYUI_DIR}/custom_nodes"

mkdir -p "${CUSTOM_NODES}"

install_node() {
  local repo="$1"
  local folder="$2"

  if [[ ! -d "${CUSTOM_NODES}/${folder}/.git" ]]; then
    git clone --depth 1 "${repo}" "${CUSTOM_NODES}/${folder}"
  fi

  if [[ -f "${CUSTOM_NODES}/${folder}/requirements.txt" ]]; then
    python3 -m pip install --no-cache-dir -r "${CUSTOM_NODES}/${folder}/requirements.txt"
  fi

  if [[ -f "${CUSTOM_NODES}/${folder}/pyproject.toml" ]]; then
    python3 -m pip install --no-cache-dir "${CUSTOM_NODES}/${folder}"
  fi
}

install_node "https://github.com/kijai/ComfyUI-WanVideoWrapper.git" "ComfyUI-WanVideoWrapper"
install_node "https://github.com/kijai/ComfyUI-KJNodes.git" "ComfyUI-KJNodes"
install_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git" "ComfyUI-VideoHelperSuite"
install_node "https://github.com/kijai/ComfyUI-WanAnimatePreprocess.git" "ComfyUI-WanAnimatePreprocess"
install_node "https://github.com/rgthree/rgthree-comfy.git" "rgthree-comfy"
install_node "https://github.com/teskor-hub/comfyui-teskors-utils.git" "comfyui-teskors-utils"

echo "Custom-node installation completed."
