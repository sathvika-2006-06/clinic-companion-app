from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/")
async def admin_dashboard(db: Session = Depends(get_db)):
    """Admin dashboard"""
    return {"message": "Admin dashboard"}

@router.get("/users")
async def manage_users(db: Session = Depends(get_db)):
    """Manage users"""
    return {"message": "Users management"}

@router.post("/users")
async def create_user(db: Session = Depends(get_db)):
    """Create new user"""
    return {"message": "User created"}

@router.get("/settings")
async def get_settings(db: Session = Depends(get_db)):
    """Get system settings"""
    return {"message": "System settings"}
