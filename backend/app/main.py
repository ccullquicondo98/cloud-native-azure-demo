from fastapi import FastAPI
import os

app = FastAPI(title="Cloud Native Backend API")

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/")
def root():
    return {
        "message": "Cloud Native Backend running on Azure AKS",
        "environment": os.getenv("ENVIRONMENT", "local")
    }