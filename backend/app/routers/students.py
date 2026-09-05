from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.models import Student, User, Department, ClinicalPosting
from app.database import get_db
from pydantic import BaseModel
from typing import List

router = APIRouter()

class StudentResponse(BaseModel):
    student_id: str
    first_name: str
    last_name: str
    department: str
    semester: int
    
    class Config:
        from_attributes = True

@router.get("/dashboard")
async def get_student_dashboard(current_user: dict = Depends(get_current_user), db: Session = Depends(get_db)):
    """Get student dashboard with today's posting and stats"""
    from datetime import date
    from app.routers.auth import get_current_user
    
    student = db.query(Student).filter(Student.user_id == current_user["id"]).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    
    # Get today's posting
    today_posting = db.query(ClinicalPosting).filter(
        ClinicalPosting.student_id == student.id,
        ClinicalPosting.date == date.today()
    ).first()
    
    return {
        "student_id": student.student_id,
        "name": f"{student.user.first_name} {student.user.last_name}",
        "today_posting": {
            "date": today_posting.date if today_posting else None,
            "department": today_posting.department.name if today_posting else None,
            "posting_id": str(today_posting.id) if today_posting else None
        },
        "semester": student.semester
    }

def get_current_user(credentials = Depends(security)) -> dict:
    """Helper to get current user from token"""
    from app.auth.jwt_handler import decode_token
    from fastapi.security import HTTPBearer
    security = HTTPBearer()
    token = credentials.credentials
    payload = decode_token(token)
    
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
    
    return {
        "id": payload.get("sub"),
        "role": payload.get("role"),
        "email": payload.get("email")
    }
