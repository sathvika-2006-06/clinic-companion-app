from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db

router = APIRouter()

@router.get("/")
async def get_locations(db: Session = Depends(get_db)):
    """Get all locations"""
    return {"message": "Locations list"}

@router.post("/")
async def create_location(db: Session = Depends(get_db)):
    """Create new location"""
    return {"message": "Location created"}

@router.get("/blocks")
async def get_blocks(db: Session = Depends(get_db)):
    """Get all blocks"""
    return {"message": "Blocks list"}
