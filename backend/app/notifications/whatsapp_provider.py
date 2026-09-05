from app.notifications.base import NotificationProvider

class WhatsAppProvider(NotificationProvider):
    """WhatsApp notification provider (ready for WhatsApp Business API)"""
    
    def __init__(self, api_key: str):
        self.api_key = api_key
    
    async def send_sms(self, phone: str, message: str) -> dict:
        """Not applicable for WhatsApp provider"""
        raise NotImplementedError("Use SMSProvider for SMS messages")
    
    async def send_whatsapp(self, phone: str, message: str) -> dict:
        """Send message via WhatsApp Business API"""
        # TODO: Implement actual WhatsApp API call
        return {"status": "pending", "provider": "whatsapp", "phone": phone}
    
    async def send_email(self, email: str, subject: str, body: str) -> dict:
        """Not applicable for WhatsApp provider"""
        raise NotImplementedError("Use EmailProvider for emails")
