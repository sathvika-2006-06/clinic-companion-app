from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/referrals")
async def get_referral_analytics(db: Session = Depends(get_db)):
    """Get referral analytics"""
    return {
        "total_referrals": 42,
        "by_priority": {"EMERGENCY": 3, "HIGH": 11, "ROUTINE": 28},
        "by_status": {"PENDING": 7, "COMPLETED": 30, "REJECTED": 5},
    }

@router.get("/students")
async def get_student_analytics(db: Session = Depends(get_db)):
    """Get student analytics"""
    return {"message": "Student analytics"}

@router.get("/patients")
async def get_patient_analytics(db: Session = Depends(get_db)):
    """Get patient analytics"""
    return {"message": "Patient analytics"}
