import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# Database
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost:5432/clinic_companion")

# JWT
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1440

# App
APP_NAME = "Clinic Companion"
DEBUG = os.getenv("DEBUG", "True").lower() == "true"
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")

# CORS
CORS_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:8080",
    "http://localhost:5000",
    "*"
]

# Notification
NOTIFICATION_PROVIDER = os.getenv("NOTIFICATION_PROVIDER", "mock")
SMS_API_KEY = os.getenv("SMS_API_KEY", "")
WHATSAPP_API_KEY = os.getenv("WHATSAPP_API_KEY", "")

# Logging
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
