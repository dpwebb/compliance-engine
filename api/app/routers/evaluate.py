from fastapi import APIRouter
from pydantic import BaseModel
from ..services import opa

router = APIRouter()

class Facts(BaseModel):
    jurisdiction: dict | None = None
    tradeline: dict | None = None
    flags: dict | None = None
    evidence: dict | None = None

@router.post("/actions")
def evaluate_actions(facts: Facts):
    res = opa.eval_actions(facts.model_dump())
    return res