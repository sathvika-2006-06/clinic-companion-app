from sqlalchemy import Column, String, DateTime, ForeignKey, Text, Integer
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime
from app.database import Base

class ClinicalCase(Base):
    __tablename__ = "clinical_cases"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    case_id = Column(String(50), unique=True, nullable=False, index=True)
    patient_id = Column(UUID(as_uuid=True), ForeignKey("patients.id"), nullable=False, index=True)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.id"), nullable=False, index=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    supervisor_id = Column(UUID(as_uuid=True), ForeignKey("faculty.id"))
    chief_complaint = Column(Text)
    clinical_findings = Column(Text)
    provisional_diagnosis = Column(Text)
    treatment_planned = Column(Text)
    case_status = Column(String(50), default="ACTIVE")  # ACTIVE, COMPLETED, ARCHIVED
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    patient = relationship("Patient")
    student = relationship("Student")
    department = relationship("Department")
    
    def __repr__(self):
        return f"<ClinicalCase(case_id={self.case_id})>"
