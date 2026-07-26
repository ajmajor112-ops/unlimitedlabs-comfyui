FROM runpod/comfyui:latest

WORKDIR /workspace/ComfyUI

# Copy workflows (optional)
COPY workflows/ /workspace/ComfyUI/user/default/workflows/

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
