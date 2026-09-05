from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.referral import Referral
from datetime import datetime

router = APIRouter()

@router.post("/")
async def create_referral(db: Session = Depends(get_db)):
    """Create new referral"""
    return {"message": "Referral created"}

@router.get("/")
async def get_referrals(priority: str = None, status: str = None, db: Session = Depends(get_db)):
    """Get referrals with optional filtering"""
    query = db.query(Referral)
    if priority:
        query = query.filter(Referral.priority == priority)
    if status:
        query = query.filter(Referral.current_status == status)
    referrals = query.all()
    return {"referrals": referrals, "count": len(referrals)}

@router.get("/{referral_id}")
async def get_referral(referral_id: str, db: Session = Depends(get_db)):
    """Get referral by ID"""
    referral = db.query(Referral).filter(Referral.referral_id == referral_id).first()
    if not referral:
        raise HTTPException(status_code=404, detail="Referral not found")
    return referral

@router.put("/{referral_id}")
async def update_referral(referral_id: str, db: Session = Depends(get_db)):
    """Update referral"""
    return {"message": f"Referral {referral_id} updated"}

@router.post("/{referral_id}/accept")
async def accept_referral(referral_id: str, db: Session = Depends(get_db)):
    """Accept referral"""
    return {"message": f"Referral {referral_id} accepted"}

@router.post("/{referral_id}/reject")
async def reject_referral(referral_id: str, db: Session = Depends(get_db)):
    """Reject referral"""
    return {"message": f"Referral {referral_id} rejected"}

@router.post("/{referral_id}/location")
async def assign_location(referral_id: str, db: Session = Depends(get_db)):
    """Assign location to referral"""
    return {"message": f"Location assigned to referral {referral_id}"}

@router.post("/{referral_id}/status")
async def update_status(referral_id: str, db: Session = Depends(get_db)):
    """Update referral status"""
    return {"message": f"Status updated for referral {referral_id}"}
