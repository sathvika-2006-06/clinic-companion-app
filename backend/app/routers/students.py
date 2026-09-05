from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.student import Student
from app.models.user import User

router = APIRouter()

@router.get("/")
async def get_students(db: Session = Depends(get_db)):
    """Get all students"""
    students = db.query(Student).all()
    return {"students": students, "count": len(students)}

@router.get("/{student_id}")
async def get_student(student_id: str, db: Session = Depends(get_db)):
    """Get student by ID"""
    student = db.query(Student).filter(Student.student_id == student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    return student

@router.get("/{student_id}/activity")
async def get_student_activity(student_id: str, db: Session = Depends(get_db)):
    """Get student clinical activity"""
    return {"message": f"Activity for student {student_id}"}
