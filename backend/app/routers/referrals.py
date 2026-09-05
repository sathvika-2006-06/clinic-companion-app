from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.models import Referral, ReferralLocation, ReferralStatusHistory, Notification, Patient, User, Room, Floor, Block, Department, Faculty, ClinicalCase, Student
from app.database import get_db
from pydantic import BaseModel
from datetime import datetime, date, time
from typing import Optional
import uuid

router = APIRouter()

class AssignLocationRequest(BaseModel):
    room_id: str
    unit_id: str
    reporting_date: date
    reporting_time_start: time
    reporting_time_end: time

class ReferralDetailResponse(BaseModel):
    referral_id: str
    patient_phone: str
    priority: str
    status: str
    location: Optional[dict]
    block: Optional[str]
    floor: Optional[str]
    room: Optional[str]
    unit: Optional[str]
    reporting_time: Optional[str]
    
    class Config:
        from_attributes = True

@router.get("/")
async def get_referrals(priority: Optional[str] = None, status: Optional[str] = None, db: Session = Depends(get_db)):
    """Get all referrals with optional filters"""
    query = db.query(Referral)
    
    if priority:
        query = query.filter(Referral.priority == priority)
    if status:
        query = query.filter(Referral.current_status == status)
    
    referrals = query.order_by(Referral.referral_date.desc()).all()
    
    result = []
    for ref in referrals:
        location = db.query(ReferralLocation).filter(ReferralLocation.referral_id == ref.id).first()
        result.append({
            "referral_id": ref.referral_id,
            "patient_id": ref.patient_id,
            "priority": ref.priority,
            "status": ref.current_status,
            "receiving_department": db.query(Department).filter(Department.id == ref.receiving_department_id).first().name if ref.receiving_department_id else None,
            "location_assigned": location is not None,
            "created_at": ref.referral_date
        })
    
    return {"referrals": result, "count": len(result)}

@router.get("/{referral_id}")
async def get_referral_details(referral_id: str, db: Session = Depends(get_db)):
    """Get referral and location details"""
    referral = db.query(Referral).filter(Referral.referral_id == referral_id).first()
    
    if not referral:
        raise HTTPException(status_code=404, detail="Referral not found")
    
    location = db.query(ReferralLocation).filter(ReferralLocation.referral_id == referral.id).first()
    
    result = {
        "referral_id": referral.referral_id,
        "priority": referral.priority,
        "status": referral.current_status,
        "reason": referral.reason_for_referral,
        "clinical_summary": referral.clinical_summary
    }
    
    if location:
        block = db.query(Block).filter(Block.id == location.block_id).first()
        floor = db.query(Floor).filter(Floor.id == location.floor_id).first()
        room = db.query(Room).filter(Room.id == location.room_id).first()
        
        result["location"] = {
            "block": block.name if block else None,
            "floor": floor.name if floor else None,
            "room": room.room_number if room else None,
            "reporting_date": str(location.reporting_date),
            "reporting_time": f"{location.reporting_time_start} - {location.reporting_time_end}"
        }
    
    return result

@router.post("/{referral_id}/accept")
async def accept_referral(referral_id: str, db: Session = Depends(get_db)):
    """Faculty accepts referral"""
    referral = db.query(Referral).filter(Referral.referral_id == referral_id).first()
    
    if not referral:
        raise HTTPException(status_code=404, detail="Referral not found")
    
    referral.current_status = "ACCEPTED"
    referral.acceptance_date = datetime.utcnow()
    
    # Log status change
    history = ReferralStatusHistory(
        referral_id=referral.id,
        previous_status="PENDING",
        new_status="ACCEPTED",
        changed_at=datetime.utcnow()
    )
    
    db.add(history)
    db.commit()
    db.refresh(referral)
    
    return {"referral_id": referral.referral_id, "status": referral.current_status}

@router.post("/{referral_id}/reject")
async def reject_referral(referral_id: str, db: Session = Depends(get_db)):
    """Faculty rejects referral"""
    referral = db.query(Referral).filter(Referral.referral_id == referral_id).first()
    
    if not referral:
        raise HTTPException(status_code=404, detail="Referral not found")
    
    old_status = referral.current_status
    referral.current_status = "REJECTED"
    
    history = ReferralStatusHistory(
        referral_id=referral.id,
        previous_status=old_status,
        new_status="REJECTED",
        changed_at=datetime.utcnow()
    )
    
    db.add(history)
    db.commit()
    
    return {"referral_id": referral.referral_id, "status": referral.current_status}

@router.post("/{referral_id}/location")
async def assign_location(referral_id: str, location_data: AssignLocationRequest, db: Session = Depends(get_db)):
    """Assign location to referral and send patient SMS"""
    referral = db.query(Referral).filter(Referral.referral_id == referral_id).first()
    
    if not referral:
        raise HTTPException(status_code=404, detail="Referral not found")
    
    # Get location details
    room = db.query(Room).filter(Room.id == uuid.UUID(location_data.room_id)).first()
    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    
    floor = db.query(Floor).filter(Floor.id == room.floor_id).first()
    block = db.query(Block).filter(Block.id == floor.block_id).first()
    
    # Create referral location record
    ref_location = ReferralLocation(
        referral_id=referral.id,
        block_id=block.id,
        floor_id=floor.id,
        room_id=room.id,
        unit_id=uuid.UUID(location_data.unit_id),
        reporting_date=location_data.reporting_date,
        reporting_time_start=location_data.reporting_time_start,
        reporting_time_end=location_data.reporting_time_end,
        assigned_by_id=uuid.UUID("550e8400-e29b-41d4-a716-446655440000")  # Faculty ID
    )
    
    referral.current_status = "LOCATION_ASSIGNED"
    
    # Get patient phone
    patient = db.query(Patient).filter(Patient.id == referral.patient_id).first()
    student = db.query(Student).filter(Student.id == referral.referring_student_id).first()
    receiving_dept = db.query(Department).filter(Department.id == referral.receiving_department_id).first()
    
    # Create SMS message with location details
    sms_message = f"""CLINIC REFERRAL
    
Dear Patient,

You are referred to: {receiving_dept.name}

Location Details:
Block: {block.name}
Floor: {floor.name}
Room: {room.room_number}

Reporting Time: {location_data.reporting_time_start.strftime('%I:%M %p')} - {location_data.reporting_time_end.strftime('%I:%M %p')}
Date: {location_data.reporting_date}

Priority: {referral.priority}
Student Doctor: {student.user.first_name} {student.user.last_name}

Please report on time.

Thank you!"""
    
    # Create notification
    notification = Notification(
        referral_id=referral.id,
        patient_phone=patient.phone,
        notification_type="LOCATION_ASSIGNED",
        message=sms_message,
        delivery_status="PENDING",
        sent_at=datetime.utcnow()
    )
    
    # Log status change
    history = ReferralStatusHistory(
        referral_id=referral.id,
        previous_status="ACCEPTED",
        new_status="LOCATION_ASSIGNED",
        changed_at=datetime.utcnow()
    )
    
    referral.current_status = "PATIENT_NOTIFIED"
    
    db.add(ref_location)
    db.add(notification)
    db.add(history)
    db.commit()
    
    return {
        "referral_id": referral.referral_id,
        "status": referral.current_status,
        "message": "Location assigned and patient SMS notification queued",
        "sms_preview": sms_message
    }

from fastapi.security import HTTPBearer
from app.auth.jwt_handler import decode_token

security = HTTPBearer()
