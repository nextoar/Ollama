from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess

app = FastAPI()

# Define the schema for the request body
class ModelRequest(BaseModel):
    model: str

class RunRequest(BaseModel):
    prompt: str
    model: str = "llama3:latest"

@app.get("/")
def read_root():
    return {"message": "Welcome to the Ollama API. Use /run to query models or /switch to switch models."}

@app.post("/api/v1/run")
def run_model(request: RunRequest):
    """
    Run a model with the provided prompt.
    """
    try:
        result = subprocess.run(
            ["ollama", "run", request.model],
            input=request.prompt,
            text=True,
            capture_output=True,
        )
        if result.returncode != 0:
            raise HTTPException(status_code=500, detail=f"Model error: {result.stderr.strip()}")
        return {"model": request.model, "response": result.stdout.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/v1/switch")
def switch_model(request: ModelRequest):
    """
    Switch to a different model.
    """
    try:
        # Pull the model if not already downloaded
        subprocess.run(["ollama", "pull", request.model], check=True)
        return {"message": f"Model {request.model} is now available for use."}
    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"Failed to pull model: {e.stderr.strip()}")