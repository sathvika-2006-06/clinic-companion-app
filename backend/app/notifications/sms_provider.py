from app.notifications.base import NotificationProvider

class SMSProvider(NotificationProvider):
    """SMS notification provider (ready for real SMS API integration)"""
    
    def __init__(self, api_key: str):
        self.api_key = api_key
    
    async def send_sms(self, phone: str, message: str) -> dict:
        """Send SMS via SMS API"""
        # TODO: Implement actual SMS API call
        return {"status": "pending", "provider": "sms", "phone": phone}
    
    async def send_whatsapp(self, phone: str, message: str) -> dict:
        """Not applicable for SMS provider"""
        raise NotImplementedError("Use WhatsAppProvider for WhatsApp messages")
    
    async def send_email(self, email: str, subject: str, body: str) -> dict:
        """Not applicable for SMS provider"""
        raise NotImplementedError("Use EmailProvider for emails")
