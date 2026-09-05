from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/")
async def get_departments(db: Session = Depends(get_db)):
    """Get all departments"""
    return {"message": "Departments list"}

@router.post("/")
async def create_department(db: Session = Depends(get_db)):
    """Create new department"""
    return {"message": "Department created"}

@router.get("/{dept_id}")
async def get_department(dept_id: str, db: Session = Depends(get_db)):
    """Get department by ID"""
    return {"message": f"Department {dept_id}"}
