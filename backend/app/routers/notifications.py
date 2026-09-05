from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/")
async def get_notifications(db: Session = Depends(get_db)):
    """Get user notifications"""
    return {"message": "Notifications list"}

@router.post("/send")
async def send_notification(db: Session = Depends(get_db)):
    """Send notification"""
    return {"message": "Notification sent"}

@router.post("/{notification_id}/mark-read")
async def mark_notification_read(notification_id: str, db: Session = Depends(get_db)):
    """Mark notification as read"""
    return {"message": f"Notification {notification_id} marked as read"}
