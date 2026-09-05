from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/")
async def get_faculty(db: Session = Depends(get_db)):
    """Get all faculty"""
    return {"message": "Faculty list"}

@router.get("/{faculty_id}")
async def get_faculty_member(faculty_id: str, db: Session = Depends(get_db)):
    """Get faculty member by ID"""
    return {"message": f"Faculty {faculty_id}"}

@router.get("/dashboard/{faculty_id}")
async def get_faculty_dashboard(faculty_id: str, db: Session = Depends(get_db)):
    """Get faculty dashboard with referrals and analytics"""
    return {"message": f"Dashboard for faculty {faculty_id}"}
