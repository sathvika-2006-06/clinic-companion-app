from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime
from app.database import Base

class Faculty(Base):
    __tablename__ = "faculty"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), unique=True, nullable=False, index=True)
    faculty_id = Column(String(50), unique=True, nullable=False, index=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"))
    designation = Column(String(100))
    specialization = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    user = relationship("User")
    department = relationship("Department")
    
    def __repr__(self):
        return f"<Faculty(faculty_id={self.faculty_id})>"
