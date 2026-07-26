#!/usr/bin/env bash
set -Eeuo pipefail

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
CUSTOM_NODES="${COMFYUI_DIR}/custom_nodes"

mkdir -p "${CUSTOM_NODES}"

install_node() {
    local repo="$1"
    local folder="$2"
    local path="${CUSTOM_NODES}/${folder}"

    echo "========================================"
    echo "Installing: ${folder}"
    echo "Repository: ${repo}"
    echo "========================================"

    if [[ ! -d "${path}/.git" ]]; then
        git clone --depth 1 "${repo}" "${path}"
    else
        echo "${folder} already exists."
    fi

    if [[ -f "${path}/requirements.txt" ]]; then
        echo "Installing requirements for ${folder}..."
        python3 -m pip install \
            --no-cache-dir \
            -r "${path}/requirements.txt"
    else
        echo "No requirements.txt for ${folder}."
    fi

    echo "Finished: ${folder}"
}

install_node \
    "https://github.com/kijai/ComfyUI-WanVideoWrapper.git" \
    "ComfyUI-WanVideoWrapper"

install_node \
    "https://github.com/kijai/ComfyUI-KJNodes.git" \
    "ComfyUI-KJNodes"

install_node \
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git" \
    "ComfyUI-VideoHelperSuite"

install_node \
    "https://github.com/kijai/ComfyUI-WanAnimatePreprocess.git" \
    "ComfyUI-WanAnimatePreprocess"

install_node \
    "https://github.com/rgthree/rgthree-comfy.git" \
    "rgthree-comfy"

echo "All custom nodes installed successfully."
echo "Installing CUDA 12 compatible ONNX Runtime..."

python3 -m pip uninstall -y \
    onnxruntime \
    onnxruntime-gpu || true

python3 -m pip install --no-cache-dir \
    "onnxruntime-gpu==1.26.0"

python3 - <<'PY'
import onnxruntime as ort

print("ONNX Runtime version:", ort.__version__)
print("Available providers:", ort.get_available_providers())
PY
