from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/")
async def get_patients(db: Session = Depends(get_db)):
    """Get all patients"""
    return {"message": "Patients list"}

@router.get("/{patient_id}")
async def get_patient(patient_id: str, db: Session = Depends(get_db)):
    """Get patient by ID"""
    return {"message": f"Patient {patient_id}"}

@router.post("/")
async def create_patient(db: Session = Depends(get_db)):
    """Create new patient"""
    return {"message": "Patient created"}
