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

COPY scripts/install_nodes.sh /opt/unlimitedlabs/install_nodes.sh
RUN chmod +x /opt/unlimitedlabs/install_nodes.sh \
    && /opt/unlimitedlabs/install_nodes.sh

COPY workflows/UnlimitedLabs_motion_2.2v.json \
     /workspace/ComfyUI/user/default/workflows/UnlimitedLabs_motion_2.2v.json
COPY workflows/UnlimitedLabs_motion_2.2v.json \
     /opt/unlimitedlabs/workflow/UnlimitedLabs_motion_2.2v.json

COPY scripts/download_models.sh /opt/unlimitedlabs/download_models.sh
COPY scripts/start.sh /opt/unlimitedlabs/start.sh
RUN chmod +x /opt/unlimitedlabs/download_models.sh /opt/unlimitedlabs/start.sh

EXPOSE 8188

ENTRYPOINT ["/opt/unlimitedlabs/start.sh"]
