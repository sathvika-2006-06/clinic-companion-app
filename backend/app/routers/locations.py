from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import Block, Floor, Room, Unit
from app.database import get_db
import uuid

router = APIRouter()

@router.get("/blocks")
async def get_blocks(db: Session = Depends(get_db)):
    """Get all blocks"""
    blocks = db.query(Block).all()
    
    return {
        "blocks": [{"id": str(b.id), "name": b.name, "location": b.location} for b in blocks],
        "count": len(blocks)
    }

@router.get("/floors/{block_id}")
async def get_floors(block_id: str, db: Session = Depends(get_db)):
    """Get all floors in a block"""
    floors = db.query(Floor).filter(Floor.block_id == uuid.UUID(block_id)).all()
    
    return {
        "floors": [{"id": str(f.id), "floor_number": f.floor_number, "name": f.name} for f in floors],
        "count": len(floors)
    }

@router.get("/rooms/{floor_id}")
async def get_rooms(floor_id: str, db: Session = Depends(get_db)):
    """Get all rooms on a floor"""
    rooms = db.query(Room).filter(Room.floor_id == uuid.UUID(floor_id)).all()
    
    return {
        "rooms": [{"id": str(r.id), "room_number": r.room_number, "room_name": r.room_name} for r in rooms],
        "count": len(rooms)
    }

@router.get("/units/{room_id}")
async def get_units(room_id: str, db: Session = Depends(get_db)):
    """Get all units in a room"""
    units = db.query(Unit).filter(Unit.room_id == uuid.UUID(room_id)).all()
    
    return {
        "units": [{"id": str(u.id), "unit_number": u.unit_number, "unit_name": u.unit_name} for u in units],
        "count": len(units)
    }
