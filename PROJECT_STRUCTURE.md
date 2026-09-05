# Clinic Companion App - Project Structure

## Overview
Complete mobile-based Inter-Department Referral, Priority Tagging & Patient Navigation System for Dental Colleges.

## Architecture

```
clinic-companion-app/
├── backend/                    # FastAPI Backend
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py            # Application entry point
│   │   ├── config.py          # Configuration management
│   │   ├── database.py        # Database setup
│   │   ├── middleware.py      # Request/response middleware
│   │   ├── auth/              # Authentication & Authorization
│   │   │   ├── __init__.py
│   │   │   ├── jwt_handler.py
│   │   │   ├── permissions.py
│   │   │   └── schemas.py
│   │   ├── models/            # SQLAlchemy ORM Models
│   │   │   ├── __init__.py
│   │   │   ├── user.py
│   │   │   ├── student.py
│   │   │   ├── faculty.py
│   │   │   ├── patient.py
│   │   │   ├── department.py
│   │   │   ├── location.py
│   │   │   ├── clinical_case.py
│   │   │   ├── referral.py
│   │   │   ├── notification.py
│   │   │   └── audit_log.py
│   │   ├── schemas/           # Pydantic Schemas for validation
│   │   │   ├── __init__.py
│   │   │   ├── auth_schemas.py
│   │   │   ├── student_schemas.py
│   │   │   ├── faculty_schemas.py
│   │   │   ├── patient_schemas.py
│   │   │   ├── case_schemas.py
│   │   │   ├── referral_schemas.py
│   │   │   └── notification_schemas.py
│   │   ├── routers/           # API Route Handlers
│   │   │   ├── __init__.py
│   │   │   ├── auth.py
│   │   │   ├── students.py
│   │   │   ├── faculty.py
│   │   │   ├── patients.py
│   │   │   ├── cases.py
│   │   │   ├── referrals.py
│   │   │   ├── departments.py
│   │   │   ├── locations.py
│   │   │   ├── notifications.py
│   │   │   ├── analytics.py
│   │   │   └── admin.py
│   │   ├── services/          # Business Logic
│   │   │   ├── __init__.py
│   │   │   ├── user_service.py
│   │   │   ├── student_service.py
│   │   │   ├── referral_service.py
│   │   │   ├── notification_service.py
│   │   │   ├── analytics_service.py
│   │   │   ├── location_service.py
│   │   │   └── audit_service.py
│   │   ├── notifications/     # Notification Providers
│   │   │   ├── __init__.py
│   │   │   ├── base.py
│   │   │   ├── sms_provider.py
│   │   │   ├── whatsapp_provider.py
│   │   │   └── mock_provider.py
│   │   └── utils/             # Utility functions
│   │       ├── __init__.py
│   │       ├── constants.py
│   │       ├── validators.py
│   │       ├── errors.py
│   │       └── helpers.py
│   ├── requirements.txt
│   ├── .env.example
│   └── README.md
│
├── frontend/                  # Flutter Mobile App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   │   ├── routes.dart
│   │   │   ├── theme.dart
│   │   │   └── constants.dart
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── student_model.dart
│   │   │   ├── patient_model.dart
│   │   │   ├── case_model.dart
│   │   │   ├── referral_model.dart
│   │   │   └── notification_model.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── storage_service.dart
│   │   │   └── notification_service.dart
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── student_provider.dart
│   │   │   ├── patient_provider.dart
│   │   │   ├── referral_provider.dart
│   │   │   └── notification_provider.dart
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   ├── student/
│   │   │   ├── faculty/
│   │   │   ├── patient/
│   │   │   └── admin/
│   │   ├── widgets/
│   │   │   ├── common/
│   │   │   ├── cards/
│   │   │   └── forms/
│   │   └── utils/
│   │       ├── app_colors.dart
│   │       ├── app_text_styles.dart
│   │       ├── validators.dart
│   │       └── helpers.dart
│   ├── pubspec.yaml
│   ├── .env.example
│   └── README.md
│
├── database/
│   ├── schema.sql          # Complete database schema
│   ├── seed_data.sql       # Demo data for testing
│   └── migrations/         # Database migration scripts
│       └── README.md
│
├── docs/
│   ├── API_DOCUMENTATION.md
│   ├── DATABASE_DESIGN.md
│   ├── ARCHITECTURE.md
│   ├── SETUP_INSTRUCTIONS.md
│   ├── WORKFLOW_GUIDE.md
│   └── DEPLOYMENT.md
│
├── .gitignore
├── README.md
└── LICENSE
```

## Key Features by Module

### Backend (FastAPI)
- RESTful API with proper HTTP methods
- JWT-based authentication
- Role-based access control (RBAC)
- SQLAlchemy ORM models
- Pydantic schema validation
- Exception handling and error responses
- Audit logging for all operations
- Notification service abstraction
- Analytics aggregation
- Database transaction management

### Frontend (Flutter)
- Clean, modern Material Design 3 UI
- State management with Provider/Riverpod
- Local secure storage for tokens
- Offline capability
- Real-time notifications
- Bottom navigation for each role
- Priority visual indicators (color + text)
- Form validation
- Error handling and user feedback

### Database (PostgreSQL)
- Relational schema with proper constraints
- Indexes for performance
- Foreign key relationships
- Audit trail tables
- Status tracking with history
- Timestamp tracking (created_at, updated_at)

## Development Workflow

1. Database setup and schema initialization
2. Backend API implementation
3. Frontend screen and widget implementation
4. Integration testing
5. Demo data population
6. Complete end-to-end workflow testing

## Next Steps

1. Review backend architecture and API design
2. Review database schema
3. Implement backend services
4. Implement frontend screens
5. Integration and testing
6. Deployment preparation
