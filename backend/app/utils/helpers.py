"""Helper functions"""

import uuid
from datetime import datetime
from typing import Optional

def generate_id() -> str:
    """Generate a UUID"""
    return str(uuid.uuid4())

def generate_case_id() -> str:
    """Generate a clinical case ID"""
    return f"CASE-{datetime.now().strftime('%Y%m%d%H%M%S')}-{uuid.uuid4().hex[:6].upper()}"

def generate_referral_id() -> str:
    """Generate a referral ID"""
    return f"REF-{datetime.now().strftime('%Y%m%d%H%M%S')}-{uuid.uuid4().hex[:6].upper()}"

def generate_patient_id() -> str:
    """Generate a patient ID"""
    return f"P-{datetime.now().strftime('%Y%m%d')}-{uuid.uuid4().hex[:6].upper()}"

def get_priority_color(priority: str) -> str:
    """Get color code for priority level"""
    priority_colors = {
        'EMERGENCY': '#FF0000',  # Red
        'HIGH': '#FFA500',       # Orange
        'ROUTINE': '#00AA00',    # Green
    }
    return priority_colors.get(priority, '#000000')

def format_datetime(dt: datetime) -> str:
    """Format datetime for display"""
    if not dt:
        return ""
    return dt.strftime('%Y-%m-%d %H:%M:%S')

def format_time_window(start_time, end_time) -> str:
    """Format time window for display"""
    if not start_time or not end_time:
        return ""
    return f"{start_time.strftime('%H:%M')} - {end_time.strftime('%H:%M')}"
