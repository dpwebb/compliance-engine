from fastapi import APIRouter, UploadFile, File, HTTPException
from ..services import storage

router = APIRouter()

@router.post("/bureau-disclosure")
async def bureau_disclosure(file: UploadFile = File(...)):
    data = await file.read()
    if not data:
        raise HTTPException(status_code=400, detail="empty file")
    loc, key = storage.save_upload(file.filename, data)
    return {"stored": loc, "ref": key}