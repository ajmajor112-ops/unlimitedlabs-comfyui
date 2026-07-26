# Unlimited Labs ComfyUI — WAN 2.2 Animate

RunPod-ready ComfyUI Docker image for the included motion-control workflow.

## Important

`workflows/UnlimitedLabs_motion_1.0v.json` is copied byte-for-byte from the supplied file. It has not been reformatted or edited.

The large WAN and LoRA model files are intentionally **not baked into the Docker image**. They download into `/workspace/ComfyUI/models` when the Pod first starts, so they can live on the RunPod persistent volume instead of making Docker builds enormous.

## GitHub → Docker Hub setup

Create these GitHub repository secrets under:

`Settings → Secrets and variables → Actions → New repository secret`

- `DOCKERHUB_USERNAME`: your Docker Hub username
- `DOCKERHUB_TOKEN`: a Docker Hub personal access token

Push to `main`, then open the GitHub **Actions** tab. When the build succeeds, the image is:

```text
unlimitedlabsai/unlimitedlabs.comfyui:latest
```

## RunPod template settings

- Container image: `unlimitedlabsai/unlimitedlabs.comfyui:latest`
- HTTP port: `8188`
- TCP port: `22` only when SSH is configured/needed
- Volume mount path: `/workspace`
- Recommended persistent volume: at least 80–120 GB because the workflow's models and LoRAs are large
- On RTX 5090/B200, change the Dockerfile base to `runpod/comfyui:cuda12.8` if required by the current RunPod image guidance

Suggested environment variable:

```text
DOWNLOAD_MODELS=true
```

Optional:

```text
HF_TOKEN=your_huggingface_token
```

The first launch can take a long time because the main model alone is very large.

## Included custom nodes

- kijai/ComfyUI-WanVideoWrapper
- kijai/ComfyUI-KJNodes
- Kosinkadink/ComfyUI-VideoHelperSuite
- kijai/ComfyUI-WanAnimatePreprocess
- rgthree/rgthree-comfy
- teskor-hub/comfyui-teskors-utils

## Workflow model filenames

The included workflow expects:

- `Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors`
- `wan_2.1_vae.safetensors`
- `umt5_xxl_fp8_e4m3fn_scaled.safetensors`
- `clip_vision_h.safetensors`
- `vitpose_h_wholebody_model.onnx`
- `vitpose_h_wholebody_data.bin`
- `yolov10m.onnx`
- `lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors`
- `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors`
- `Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors`
- `Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors`

The last LoRA has no default URL in `download_models.sh`. Set the RunPod environment variable `LORA_HPS_URL` to its direct download URL, or upload it manually to:

```text
/workspace/ComfyUI/models/loras/
```

## Input placeholders

The workflow references `Ref_Video.mp4` and `Ref_Image.png`. Upload/select your own files in ComfyUI when using the workflow.

## Local validation

```bash
docker build -t unlimitedlabs-comfyui:test .
docker run --rm --gpus all -p 8188:8188 \
  -e DOWNLOAD_MODELS=false \
  unlimitedlabs-comfyui:test
```

Set `DOWNLOAD_MODELS=true` only when sufficient disk space is available.
