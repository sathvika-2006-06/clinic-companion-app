from fastapi import APIRouter, Depends, HTTPException, status, File, UploadFile
from sqlalchemy.orm import Session
from app.models import ClinicalCase, Patient, User, Student, Department
from app.database import get_db
from pydantic import BaseModel
from datetime import datetime
import uuid

router = APIRouter()

class CreateCaseRequest(BaseModel):
    patient_id: str
    chief_complaint: str
    clinical_findings: str
    provisional_diagnosis: str
    treatment_planned: str

class CaseResponse(BaseModel):
    case_id: str
    patient_id: str
    chief_complaint: str
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True

@router.post("/")
async def create_case(case_data: CreateCaseRequest, db: Session = Depends(get_db)):
    """Create new clinical case"""
    # Check if patient exists
    patient = db.query(Patient).filter(Patient.patient_id == case_data.patient_id).first()
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    # For now, use dummy student ID - in real app this comes from authenticated user
    student = db.query(Student).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    
    case_id = f"CASE-{datetime.now().strftime('%Y%m%d%H%M%S')}-{str(uuid.uuid4())[:8].upper()}"
    
    clinical_case = ClinicalCase(
        case_id=case_id,
        patient_id=patient.id,
        student_id=student.id,
        department_id=student.department_id,
        chief_complaint=case_data.chief_complaint,
        clinical_findings=case_data.clinical_findings,
        provisional_diagnosis=case_data.provisional_diagnosis,
        treatment_planned=case_data.treatment_planned,
        case_status="ACTIVE"
    )
    
    db.add(clinical_case)
    db.commit()
    db.refresh(clinical_case)
    
    return {
        "case_id": clinical_case.case_id,
        "status": clinical_case.case_status,
        "created_at": clinical_case.created_at
    }

@router.get("/")
async def get_cases(db: Session = Depends(get_db)):
    """Get all cases"""
    cases = db.query(ClinicalCase).order_by(ClinicalCase.created_at.desc()).all()
    
    result = []
    for case in cases:
        patient = db.query(Patient).filter(Patient.id == case.patient_id).first()
        result.append({
            "case_id": case.case_id,
            "patient_id": patient.patient_id if patient else None,
            "chief_complaint": case.chief_complaint,
            "status": case.case_status,
            "created_at": case.created_at
        })
    
    return {"cases": result, "count": len(result)}

@router.get("/{case_id}")
async def get_case(case_id: str, db: Session = Depends(get_db)):
    """Get case details"""
    case = db.query(ClinicalCase).filter(ClinicalCase.case_id == case_id).first()
    
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    
    patient = db.query(Patient).filter(Patient.id == case.patient_id).first()
    student = db.query(Student).filter(Student.id == case.student_id).first()
    dept = db.query(Department).filter(Department.id == case.department_id).first()
    
    return {
        "case_id": case.case_id,
        "patient_id": patient.patient_id if patient else None,
        "patient_name": patient.patient_name if patient else None,
        "student": f"{student.user.first_name} {student.user.last_name}" if student else None,
        "department": dept.name if dept else None,
        "chief_complaint": case.chief_complaint,
        "clinical_findings": case.clinical_findings,
        "provisional_diagnosis": case.provisional_diagnosis,
        "treatment_planned": case.treatment_planned,
        "status": case.case_status,
        "created_at": case.created_at
    }
