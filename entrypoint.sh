#!/bin/bash

# Directory for Ollama's persistent data
MODEL_DIR="/root/.ollama"

# Ensure the model directory exists
mkdir -p "$MODEL_DIR"

# Default model to serve if not provided
DEFAULT_MODEL="llama3:latest"
MODEL=${1:-$DEFAULT_MODEL}

# Start the Ollama server in the background
echo "Starting Ollama server..."
ollama serve --dir "$MODEL_DIR" --device gpu &

# Wait for the Ollama server to start
sleep 5

echo "Starting FastAPI management API..."
# Start the FastAPI app to allow dynamic model management
uvicorn app:app --host 0.0.0.0 --port 8080