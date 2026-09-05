from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import Referral, Patient, Department, Student, User
from app.database import get_db
from datetime import date, timedelta

router = APIRouter()

@router.get("/referrals")
async def get_referral_analytics(db: Session = Depends(get_db)):
    """Get referral statistics"""
    all_referrals = db.query(Referral).all()
    
    stats = {
        "total_referrals": len(all_referrals),
        "by_priority": {
            "EMERGENCY": len([r for r in all_referrals if r.priority == "EMERGENCY"]),
            "HIGH": len([r for r in all_referrals if r.priority == "HIGH"]),
            "ROUTINE": len([r for r in all_referrals if r.priority == "ROUTINE"])
        },
        "by_status": {
            "PENDING": len([r for r in all_referrals if r.current_status == "PENDING"]),
            "ACCEPTED": len([r for r in all_referrals if r.current_status == "ACCEPTED"]),
            "LOCATION_ASSIGNED": len([r for r in all_referrals if r.current_status == "LOCATION_ASSIGNED"]),
            "PATIENT_NOTIFIED": len([r for r in all_referrals if r.current_status == "PATIENT_NOTIFIED"]),
            "PATIENT_ARRIVED": len([r for r in all_referrals if r.current_status == "PATIENT_ARRIVED"]),
            "COMPLETED": len([r for r in all_referrals if r.current_status == "COMPLETED"]),
            "REJECTED": len([r for r in all_referrals if r.current_status == "REJECTED"])
        }
    }
    
    return stats

@router.get("/students")
async def get_student_analytics(db: Session = Depends(get_db)):
    """Get student activity analytics"""
    from app.models import ClinicalCase
    
    students = db.query(Student).all()
    result = []
    
    for student in students:
        cases_count = db.query(ClinicalCase).filter(ClinicalCase.student_id == student.id).count()
        referrals_count = db.query(Referral).filter(Referral.referring_student_id == student.id).count()
        
        result.append({
            "student_id": student.student_id,
            "name": f"{student.user.first_name} {student.user.last_name}",
            "cases_logged": cases_count,
            "referrals_created": referrals_count
        })
    
    return {"students": result, "count": len(result)}

@router.get("/departments")
async def get_department_analytics(db: Session = Depends(get_db)):
    """Get department-wise referral statistics"""
    departments = db.query(Department).filter(Department.is_active == True).all()
    result = []
    
    for dept in departments:
        referrals = db.query(Referral).filter(Referral.receiving_department_id == dept.id).all()
        
        result.append({
            "department": dept.name,
            "total_referrals": len(referrals),
            "pending": len([r for r in referrals if r.current_status == "PENDING"]),
            "accepted": len([r for r in referrals if r.current_status == "ACCEPTED"]),
            "completed": len([r for r in referrals if r.current_status == "COMPLETED"])
        })
    
    return {"departments": result}
