from fastapi import FastAPI
from .routers import ingest, evaluate

app = FastAPI(title="Compliance Engine API", version="0.1.0")

@app.get("/health")
def health():
    return {"ok": True}

app.include_router(ingest.router, prefix="/ingest", tags=["ingest"])
app.include_router(evaluate.router, prefix="/evaluate", tags=["evaluate"])