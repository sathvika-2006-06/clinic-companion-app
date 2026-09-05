from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.post("/")
async def create_case(db: Session = Depends(get_db)):
    """Create clinical case"""
    return {"message": "Case created"}

@router.get("/")
async def get_cases(db: Session = Depends(get_db)):
    """Get all cases"""
    return {"message": "Cases list"}

@router.get("/{case_id}")
async def get_case(case_id: str, db: Session = Depends(get_db)):
    """Get case by ID"""
    return {"message": f"Case {case_id}"}

@router.put("/{case_id}")
async def update_case(case_id: str, db: Session = Depends(get_db)):
    """Update clinical case"""
    return {"message": f"Case {case_id} updated"}
