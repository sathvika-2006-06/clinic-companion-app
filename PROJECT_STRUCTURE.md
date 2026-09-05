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
│   │   │   │   ├── splash_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── role_selection_screen.dart
│   │   │   │   └── forgot_password_screen.dart
│   │   │   ├── student/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   ├── preparation_screen.dart
│   │   │   │   ├── preparation_detail_screen.dart
│   │   │   │   ├── case_list_screen.dart
│   │   │   │   ├── add_case_screen.dart
│   │   │   │   ├── case_detail_screen.dart
│   │   │   │   ├── create_referral_screen.dart
│   │   │   │   ├── referral_confirmation_screen.dart
│   │   │   │   ├── my_referrals_screen.dart
│   │   │   │   ├── referral_detail_screen.dart
│   │   │   │   ├── notifications_screen.dart
│   │   │   │   └── profile_screen.dart
│   │   │   ├── faculty/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   ├── referral_queue_screen.dart
│   │   │   │   ├── referral_detail_screen.dart
│   │   │   │   ├── assign_location_screen.dart
│   │   │   │   ├── student_activity_screen.dart
│   │   │   │   ├── patient_tracking_screen.dart
│   │   │   │   ├── analytics_screen.dart
│   │   │   │   └── profile_screen.dart
│   │   │   ├── patient/
│   │   │   │   ├── referral_home_screen.dart
│   │   │   │   ├── referral_detail_screen.dart
│   │   │   │   ├── navigation_screen.dart
│   │   │   │   ├── reporting_time_screen.dart
│   │   │   │   └── notifications_screen.dart
│   │   │   └── admin/
│   │   │       ├── dashboard_screen.dart
│   │   │       ├── user_management_screen.dart
│   │   │       ├── department_management_screen.dart
│   │   │       ├── location_management_screen.dart
│   │   │       ├── posting_management_screen.dart
│   │   │       ├── preparation_management_screen.dart
│   │   │       └── settings_screen.dart
│   │   ├── widgets/
│   │   │   ├── common/
│   │   │   │   ├── app_bar.dart
│   │   │   │   ├── bottom_nav.dart
│   │   │   │   ├── loading_indicator.dart
│   │   │   │   ├── error_dialog.dart
│   │   │   │   └── empty_state.dart
│   │   │   ├── cards/
│   │   │   │   ├── referral_card.dart
│   │   │   │   ├── case_card.dart
│   │   │   │   ├── notification_card.dart
│   │   │   │   └── stat_card.dart
│   │   │   └── forms/
│   │   │       ├── input_field.dart
│   │   │       ├── priority_selector.dart
│   │   │       ├── department_selector.dart
│   │   │       └── date_time_picker.dart
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
