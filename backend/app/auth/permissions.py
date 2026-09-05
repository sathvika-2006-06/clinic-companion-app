from enum import Enum

class RolePermission(Enum):
    """Role-based permissions"""
    STUDENT = "STUDENT"
    FACULTY = "FACULTY"
    PATIENT = "PATIENT"
    ADMIN = "ADMIN"

def check_permission(user_role: str, required_role: str) -> bool:
    """Check if user has required role"""
    role_hierarchy = {
        "ADMIN": ["ADMIN", "FACULTY", "STUDENT", "PATIENT"],
        "FACULTY": ["FACULTY", "STUDENT", "PATIENT"],
        "STUDENT": ["STUDENT"],
        "PATIENT": ["PATIENT"],
    }
    return user_role in role_hierarchy.get(required_role, [])
