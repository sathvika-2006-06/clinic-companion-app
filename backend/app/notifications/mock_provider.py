from app.notifications.base import NotificationProvider

class MockNotificationProvider(NotificationProvider):
    """Mock notification provider for development/testing"""
    
    async def send_sms(self, phone: str, message: str) -> dict:
        """Mock SMS sending"""
        print(f"[MOCK SMS] To: {phone}")
        print(f"[MOCK SMS] Message: {message}")
        return {
            "status": "success",
            "provider": "mock",
            "message_id": "mock-123",
            "phone": phone
        }
    
    async def send_whatsapp(self, phone: str, message: str) -> dict:
        """Mock WhatsApp sending"""
        print(f"[MOCK WHATSAPP] To: {phone}")
        print(f"[MOCK WHATSAPP] Message: {message}")
        return {
            "status": "success",
            "provider": "mock",
            "message_id": "mock-456",
            "phone": phone
        }
    
    async def send_email(self, email: str, subject: str, body: str) -> dict:
        """Mock email sending"""
        print(f"[MOCK EMAIL] To: {email}")
        print(f"[MOCK EMAIL] Subject: {subject}")
        print(f"[MOCK EMAIL] Body: {body}")
        return {
            "status": "success",
            "provider": "mock",
            "message_id": "mock-789",
            "email": email
        }
