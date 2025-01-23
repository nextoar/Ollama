# Base image for Ollama with GPU support
FROM nvidia/cuda:11.8.0-base-ubuntu20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-pip \
    unzip
    # software-properties-common 
    # && rm -rf /var/lib/apt/lists/*
    
# Install NVIDIA Container Toolkit CLI utilities for GPU support
# RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
#     curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
#     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
#     tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
#     apt-get update && apt-get install -y nvidia-container-toolkit && \
#     nvidia-ctk runtime configure --runtime=docker && \
#     systemctl restart docker

RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
    apt-get update && \
    apt-get install -y nvidia-container-toolkit && \
    nvidia-ctk runtime configure --runtime=docker && \
    echo "Docker configuration updated. Please ensure Docker is restarted on the host machine if needed."


# Install Ollama CLI
RUN curl -fsSL https://ollama.ai/install.sh | bash

# Install Python dependencies for FastAPI
RUN pip3 install fastapi uvicorn

# Install dependencies fir FastAPI
COPY requirements.txt /opt/ollama/requirements.txt
RUN pip3 install -r /opt/ollama/requirements.txt

# Create a directory for models
RUN mkdir -p /opt/ollama/models
WORKDIR /opt/ollama

# Add the FastAPI app and entrypoint script
COPY app.py /opt/ollama/app.py
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the ports for Ollama serving (11434) and FastAPI (8080)
EXPOSE 11434 8080

# Default command to run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]