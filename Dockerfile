FROM runpod/comfyui:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    COMFYUI_DIR=/workspace/ComfyUI \
    WORKSPACE=/workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
      aria2 \
      ffmpeg \
      git \
      git-lfs \
      libgl1 \
      libglib2.0-0 \
      wget \
    && rm -rf /var/lib/apt/lists/*

# Make sure ComfyUI itself exists before custom nodes are installed
RUN if [ ! -f /workspace/ComfyUI/main.py ]; then \
      rm -rf /workspace/ComfyUI && \
      git clone --depth 1 https://github.com/Comfy-Org/ComfyUI.git /workspace/ComfyUI && \
      python3 -m pip install --no-cache-dir \
        -r /workspace/ComfyUI/requirements.txt; \
    fi

COPY scripts/install_nodes.sh /opt/unlimitedlabs/install_nodes.sh
RUN chmod +x /opt/unlimitedlabs/install_nodes.sh \
    && /opt/unlimitedlabs/install_nodes.sh

COPY workflows/UnlimitedLabs_motion_2.2v.json \
     /workspace/ComfyUI/user/default/workflows/UnlimitedLabs_motion_2.2v.json

COPY workflows/UnlimitedLabs_motion_2.2v.json \
     /opt/unlimitedlabs/workflow/UnlimitedLabs_motion_2.2v.json

COPY scripts/download_models.sh /opt/unlimitedlabs/download_models.sh
COPY scripts/start.sh /opt/unlimitedlabs/start.sh

RUN chmod +x \
    /opt/unlimitedlabs/download_models.sh \
    /opt/unlimitedlabs/start.sh

EXPOSE 8188

ENTRYPOINT ["/opt/unlimitedlabs/start.sh"]
