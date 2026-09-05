"""Validation utilities"""

from typing import Optional
import re

def validate_email(email: str) -> bool:
    """Validate email format"""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None

def validate_phone(phone: str) -> bool:
    """Validate phone number format"""
    # Remove common formatting characters
    clean_phone = re.sub(r'[\s\-\(\)\+]', '', phone)
    # Check if it contains only digits and is between 10-15 digits
    return bool(re.match(r'^\d{10,15}$', clean_phone))

def validate_priority(priority: str) -> bool:
    """Validate priority level"""
    valid_priorities = ['EMERGENCY', 'HIGH', 'ROUTINE']
    return priority in valid_priorities

def validate_referral_status(status: str) -> bool:
    """Validate referral status"""
    valid_statuses = [
        'PENDING', 'ACCEPTED', 'REJECTED', 'AWAITING_CLARIFICATION',
        'LOCATION_ASSIGNED', 'PATIENT_NOTIFIED', 'PATIENT_ARRIVED',
        'UNDER_CONSULTATION', 'COMPLETED', 'CANCELLED'
    ]
    return status in valid_statuses
