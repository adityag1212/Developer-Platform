from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(
    title="Developer Platform Demo Service",
    version="1.0.1",
)


@app.get("/")
def root():
    return {
        "service": "demo-service",
        "version": "1.0.0",
        "status": "running",
    }


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.get("/ready")
def ready():
    return {"status": "ready"}


Instrumentator().instrument(app).expose(app)