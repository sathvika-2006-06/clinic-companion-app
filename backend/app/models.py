from sqlalchemy import create_engine, Column, String, DateTime, Boolean, Integer, ForeignKey, Text, Time, Date, JSONB
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
from sqlalchemy.dialects.postgresql import UUID
import uuid
from datetime import datetime
from app.config import DATABASE_URL

engine = create_engine(
    DATABASE_URL,
    pool_size=20,
    max_overflow=10,
    echo=False
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ============================================================================
# USER MODELS
# ============================================================================

class User(Base):
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(50), nullable=False, index=True)  # STUDENT, FACULTY, ADMIN
    first_name = Column(String(255))
    last_name = Column(String(255))
    phone = Column(String(20))
    is_active = Column(Boolean, default=True)
    last_login = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Student(Base):
    __tablename__ = "students"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), unique=True, nullable=False, index=True)
    student_id = Column(String(50), unique=True, nullable=False, index=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"))
    semester = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)

class Faculty(Base):
    __tablename__ = "faculty"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), unique=True, nullable=False, index=True)
    faculty_id = Column(String(50), unique=True, nullable=False, index=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"))
    designation = Column(String(100))
    created_at = Column(DateTime, default=datetime.utcnow)

# ============================================================================
# DEPARTMENT & LOCATION MODELS
# ============================================================================

class Department(Base):
    __tablename__ = "departments"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), unique=True, nullable=False)
    code = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

class Block(Base):
    __tablename__ = "blocks"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)  # Block A, Block B, etc.
    location = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)

class Floor(Base):
    __tablename__ = "floors"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    block_id = Column(UUID(as_uuid=True), ForeignKey("blocks.id"), nullable=False)
    floor_number = Column(Integer, nullable=False)  # 1, 2, 3, etc.
    name = Column(String(255))  # 1st Floor, 2nd Floor, etc.
    created_at = Column(DateTime, default=datetime.utcnow)

class Room(Base):
    __tablename__ = "rooms"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    floor_id = Column(UUID(as_uuid=True), ForeignKey("floors.id"), nullable=False)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    room_number = Column(String(50), nullable=False)  # 201, 202, etc.
    room_name = Column(String(255))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

class Unit(Base):
    __tablename__ = "units"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    room_id = Column(UUID(as_uuid=True), ForeignKey("rooms.id"), nullable=False)
    unit_number = Column(Integer, nullable=False)  # 1, 2, 3, etc. (Chair numbers)
    unit_name = Column(String(255))  # Chair 1, Chair 2, etc.
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

# ============================================================================
# PATIENT MODEL (No login - only identifier)
# ============================================================================

class Patient(Base):
    __tablename__ = "patients"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    patient_id = Column(String(50), unique=True, nullable=False, index=True)  # P001, P002, etc.
    phone = Column(String(20), nullable=False, index=True)  # Phone for SMS
    patient_name = Column(String(255))
    age = Column(Integer)
    gender = Column(String(10))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

# ============================================================================
# CLINICAL MODELS
# ============================================================================

class ClinicalPosting(Base):
    __tablename__ = "clinical_postings"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    date = Column(Date, nullable=False, index=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.id"), nullable=False, index=True)
    supervisor_id = Column(UUID(as_uuid=True), ForeignKey("faculty.id"))
    unit_id = Column(UUID(as_uuid=True), ForeignKey("units.id"))
    created_at = Column(DateTime, default=datetime.utcnow)

class ClinicalCase(Base):
    __tablename__ = "clinical_cases"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    case_id = Column(String(50), unique=True, nullable=False, index=True)
    patient_id = Column(UUID(as_uuid=True), ForeignKey("patients.id"), nullable=False, index=True)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.id"), nullable=False, index=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    chief_complaint = Column(Text)
    clinical_findings = Column(Text)
    provisional_diagnosis = Column(Text)
    treatment_planned = Column(Text)
    case_status = Column(String(50), default="ACTIVE")  # ACTIVE, COMPLETED, ARCHIVED
    created_at = Column(DateTime, default=datetime.utcnow)

# ============================================================================
# REFERRAL MODELS
# ============================================================================

class Referral(Base):
    __tablename__ = "referrals"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(String(50), unique=True, nullable=False, index=True)
    case_id = Column(UUID(as_uuid=True), ForeignKey("clinical_cases.id"), nullable=False)
    patient_id = Column(UUID(as_uuid=True), ForeignKey("patients.id"), nullable=False, index=True)
    referring_department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    referring_student_id = Column(UUID(as_uuid=True), ForeignKey("students.id"), nullable=False)
    receiving_department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False, index=True)
    reason_for_referral = Column(Text, nullable=False)
    clinical_summary = Column(Text)
    priority = Column(String(50), nullable=False, index=True)  # EMERGENCY, HIGH, ROUTINE
    current_status = Column(String(50), default="PENDING", index=True)
    referral_date = Column(DateTime, default=datetime.utcnow)
    acceptance_date = Column(DateTime)
    completion_date = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)

class ReferralLocation(Base):
    __tablename__ = "referral_locations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(UUID(as_uuid=True), ForeignKey("referrals.id"), unique=True, nullable=False)
    block_id = Column(UUID(as_uuid=True), ForeignKey("blocks.id"), nullable=False)
    floor_id = Column(UUID(as_uuid=True), ForeignKey("floors.id"), nullable=False)
    room_id = Column(UUID(as_uuid=True), ForeignKey("rooms.id"), nullable=False)
    unit_id = Column(UUID(as_uuid=True), ForeignKey("units.id"), nullable=False)
    reporting_date = Column(Date, nullable=False)
    reporting_time_start = Column(Time, nullable=False)
    reporting_time_end = Column(Time, nullable=False)
    assigned_by_id = Column(UUID(as_uuid=True), ForeignKey("faculty.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

class ReferralStatusHistory(Base):
    __tablename__ = "referral_status_history"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(UUID(as_uuid=True), ForeignKey("referrals.id"), nullable=False)
    previous_status = Column(String(50))
    new_status = Column(String(50), nullable=False)
    changed_by_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    changed_at = Column(DateTime, default=datetime.utcnow)

# ============================================================================
# NOTIFICATION MODELS
# ============================================================================

class Notification(Base):
    __tablename__ = "notifications"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(UUID(as_uuid=True), ForeignKey("referrals.id"), nullable=False)
    patient_phone = Column(String(20), nullable=False)  # Phone for SMS
    notification_type = Column(String(100), nullable=False)  # REFERRAL_CREATED, LOCATION_ASSIGNED, etc.
    message = Column(Text, nullable=False)  # Full SMS message
    delivery_status = Column(String(50), default="PENDING")  # PENDING, SENT, FAILED, DELIVERED
    sent_at = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)

# ============================================================================
# AUDIT LOG MODEL
# ============================================================================

class AuditLog(Base):
    __tablename__ = "audit_logs"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    action_type = Column(String(100), nullable=False)  # CREATE, UPDATE, DELETE, etc.
    entity_type = Column(String(100))
    entity_id = Column(UUID(as_uuid=True))
    old_values = Column(JSONB)
    new_values = Column(JSONB)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)
