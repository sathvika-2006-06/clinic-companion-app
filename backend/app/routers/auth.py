from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import timedelta
from app.auth.jwt_handler import create_access_token, verify_password, get_password_hash
from app.auth.schemas import LoginRequest, LoginResponse
from app.database import get_db
from app.models.user import User

router = APIRouter()

@router.post("/login", response_model=LoginResponse)
async def login(request: LoginRequest, db: Session = Depends(get_db)):
    """User login endpoint"""
    user = db.query(User).filter(User.email == request.email).first()
    
    if not user or not verify_password(request.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials"
        )
    
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive"
        )
    
    access_token = create_access_token(
        data={"sub": str(user.id), "role": user.role, "email": user.email}
    )
    
    return LoginResponse(
        access_token=access_token,
        user_id=str(user.id),
        role=user.role,
        email=user.email,
        first_name=user.first_name or "",
        last_name=user.last_name or ""
    )

@router.post("/logout")
async def logout():
    """User logout endpoint"""
    return {"message": "Logged out successfully"}

@router.get("/me")
async def get_current_user(db: Session = Depends(get_db)):
    """Get current user profile"""
    return {"message": "Current user endpoint"}
