from sqlalchemy import Column, String, DateTime, ForeignKey, Integer, Time, Date
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime
from app.database import Base

class Location(Base):
    __tablename__ = "referral_locations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    referral_id = Column(UUID(as_uuid=True), ForeignKey("referrals.id"), unique=True)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    room_id = Column(UUID(as_uuid=True), ForeignKey("rooms.id"))
    unit_id = Column(UUID(as_uuid=True), ForeignKey("units.id"))
    floor_id = Column(UUID(as_uuid=True), ForeignKey("floors.id"))
    block_id = Column(UUID(as_uuid=True), ForeignKey("blocks.id"))
    reporting_date = Column(Date, nullable=False)
    reporting_time_start = Column(Time, nullable=False)
    reporting_time_end = Column(Time, nullable=False)
    assigned_by_id = Column(UUID(as_uuid=True), ForeignKey("faculty.id"), nullable=False)
    assignment_notes = Column(String(500))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Block(Base):
    __tablename__ = "blocks"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)
    description = Column(String(500))
    created_at = Column(DateTime, default=datetime.utcnow)

class Floor(Base):
    __tablename__ = "floors"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    block_id = Column(UUID(as_uuid=True), ForeignKey("blocks.id"), nullable=False)
    floor_number = Column(Integer, nullable=False)
    name = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)

class Room(Base):
    __tablename__ = "rooms"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    floor_id = Column(UUID(as_uuid=True), ForeignKey("floors.id"), nullable=False)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=False)
    room_number = Column(String(50), nullable=False)
    room_name = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)

class Unit(Base):
    __tablename__ = "units"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    room_id = Column(UUID(as_uuid=True), ForeignKey("rooms.id"), nullable=False)
    unit_number = Column(Integer, nullable=False)
    unit_name = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
