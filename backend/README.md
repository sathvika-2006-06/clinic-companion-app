# Backend - Clinic Companion App

FastAPI-based backend for the Clinic Companion application.

## Setup

```bash
cd backend
pip install -r requirements.txt
cp .env.example .env
python -m uvicorn app.main:app --reload
```

## API Documentation

Once running, visit: http://localhost:8000/docs

## Features

- JWT-based authentication
- Role-based access control
- SQLAlchemy ORM
- Pydantic validation
- Audit logging
- Referral workflow management
- Notification service abstraction
- Analytics endpoints
