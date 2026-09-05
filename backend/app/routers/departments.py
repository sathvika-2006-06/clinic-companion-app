from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import Department
from app.database import get_db

router = APIRouter()

@router.get("/")
async def get_departments(db: Session = Depends(get_db)):
    """Get all active departments"""
    departments = db.query(Department).filter(Department.is_active == True).all()
    
    return {
        "departments": [
            {"id": str(d.id), "name": d.name, "code": d.code, "description": d.description}
            for d in departments
        ],
        "count": len(departments)
    }

@router.get("/{dept_id}")
async def get_department(dept_id: str, db: Session = Depends(get_db)):
    """Get department details"""
    import uuid
    department = db.query(Department).filter(Department.id == uuid.UUID(dept_id)).first()
    
    if not department:
        raise HTTPException(status_code=404, detail="Department not found")
    
    return {
        "id": str(department.id),
        "name": department.name,
        "code": department.code,
        "description": department.description
    }

from fastapi import HTTPException
