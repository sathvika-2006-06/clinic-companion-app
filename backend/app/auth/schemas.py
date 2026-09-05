from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    role: str
    email: str
    first_name: str
    last_name: str

class TokenPayload(BaseModel):
    sub: str
    exp: datetime
    role: str

class ChangePasswordRequest(BaseModel):
    old_password: str
    new_password: str
    confirm_password: str
