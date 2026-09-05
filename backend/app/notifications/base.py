from abc import ABC, abstractmethod
from typing import Optional

class NotificationProvider(ABC):
    """Abstract base class for notification providers"""
    
    @abstractmethod
    async def send_sms(self, phone: str, message: str) -> dict:
        """Send SMS notification"""
        pass
    
    @abstractmethod
    async def send_whatsapp(self, phone: str, message: str) -> dict:
        """Send WhatsApp notification"""
        pass
    
    @abstractmethod
    async def send_email(self, email: str, subject: str, body: str) -> dict:
        """Send email notification"""
        pass
