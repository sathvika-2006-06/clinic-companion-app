from sqlalchemy import Column, String, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime
from app.database import Base

class Referral(Base):
    __tablename__ = "referrals"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(String(50), unique=True, nullable=False, index=True)
    clinical_case_id = Column(UUID(as_uuid=True), ForeignKey("clinical_cases.id"), nullable=False)
    patient_id = Column(UUID(as_uuid=True), ForeignKey("patients.id"), nullable=False, index=True)
    referring_department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    referring_student_id = Column(UUID(as_uuid=True), ForeignKey("students.id"), nullable=False)
    referring_faculty_id = Column(UUID(as_uuid=True), ForeignKey("faculty.id"))
    receiving_department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False, index=True)
    reason_for_referral = Column(Text, nullable=False)
    clinical_summary = Column(Text)
    provisional_diagnosis = Column(Text)
    priority = Column(String(50), nullable=False, index=True)  # EMERGENCY, HIGH, ROUTINE
    current_status = Column(String(50), default="PENDING", index=True)  # PENDING, ACCEPTED, REJECTED, etc.
    referral_date = Column(DateTime, default=datetime.utcnow)
    acceptance_date = Column(DateTime)
    completion_date = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    clinical_case = relationship("ClinicalCase")
    patient = relationship("Patient")
    referring_department = relationship("Department", foreign_keys=[referring_department_id])
    receiving_department = relationship("Department", foreign_keys=[receiving_department_id])
    
    def __repr__(self):
        return f"<Referral(referral_id={self.referral_id}, priority={self.priority}, status={self.current_status})>"

class ReferralStatusHistory(Base):
    __tablename__ = "referral_status_history"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(UUID(as_uuid=True), ForeignKey("referrals.id"), nullable=False)
    previous_status = Column(String(50))
    new_status = Column(String(50), nullable=False)
    changed_by_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    changed_at = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)
