#!/usr/bin/env bash
set -Eeuo pipefail

COMFYUI_DIR="${COMFYUI_DIR:-/workspace/ComfyUI}"
HF_TOKEN="${HF_TOKEN:-}"

mkdir -p \
  "${COMFYUI_DIR}/models/diffusion_models" \
  "${COMFYUI_DIR}/models/vae" \
  "${COMFYUI_DIR}/models/text_encoders" \
  "${COMFYUI_DIR}/models/clip_vision" \
  "${COMFYUI_DIR}/models/loras" \
  "${COMFYUI_DIR}/models/detection"

download() {
  local url="$1"
  local output="$2"

  if [[ -z "${url}" ]]; then
    echo "Skipping ${output}: no URL configured."
    return 0
  fi

  if [[ -s "${output}" ]]; then
    echo "Already present: ${output}"
    return 0
  fi

  mkdir -p "$(dirname "${output}")"
  local headers=()
  if [[ -n "${HF_TOKEN}" ]]; then
    headers+=(--header="Authorization: Bearer ${HF_TOKEN}")
  fi

  echo "Downloading $(basename "${output}")..."
  aria2c \
    --continue=true \
    --max-connection-per-server=8 \
    --split=8 \
    --min-split-size=10M \
    --allow-overwrite=true \
    "${headers[@]}" \
    --dir="$(dirname "${output}")" \
    --out="$(basename "${output}")" \
    "${url}"
}

# Required model names are taken directly from the unchanged workflow.
# Override any URL as a RunPod environment variable if you use another source.

download "${WAN_MODEL_URL:-https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Animate/Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/diffusion_models/Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors"

download "${WAN_VAE_URL:-https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/vae/wan_2.1_vae.safetensors"

download "${TEXT_ENCODER_URL:-https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

download "${CLIP_VISION_URL:-https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/clip_vision/clip_vision_h.safetensors"

download "${YOLO_URL:-https://huggingface.co/Wan-AI/Wan2.2-Animate-14B/resolve/main/process_checkpoint/det/yolov10m.onnx?download=true}" \
  "${COMFYUI_DIR}/models/detection/yolov10m.onnx"

download "${VITPOSE_MODEL_URL:-https://huggingface.co/Kijai/vitpose_comfy/resolve/main/onnx/vitpose_h_wholebody_model.onnx?download=true}" \
  "${COMFYUI_DIR}/models/detection/vitpose_h_wholebody_model.onnx"

download "${VITPOSE_DATA_URL:-https://huggingface.co/Kijai/vitpose_comfy/resolve/main/onnx/vitpose_h_wholebody_data.bin?download=true}" \
  "${COMFYUI_DIR}/models/detection/vitpose_h_wholebody_data.bin"

download "${LORA_LIGHTX2V_URL:-https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors"

download "${LORA_WAN22_HIGH_URL:-https://huggingface.co/aialpha444/wan2.2_i2v/resolve/main/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"

download "${LORA_PUSA_URL:-https://huggingface.co/SkylinkLabs/Wan21_Loras/resolve/main/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors?download=true}" \
  "${COMFYUI_DIR}/models/loras/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors"

# This workflow also names this optional LoRA. Its public source may vary, so
# provide LORA_HPS_URL in RunPod when you want it downloaded automatically.
download "${LORA_HPS_URL:-}" \
  "${COMFYUI_DIR}/models/loras/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors"

echo "Model setup completed."
