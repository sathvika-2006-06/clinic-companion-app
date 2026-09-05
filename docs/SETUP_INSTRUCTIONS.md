# Clinic Companion App - Complete Implementation Guide

## Project Overview

Clinic Companion is a production-ready mobile application designed for Indian dental colleges, providing:

1. **Daily Clinical Preparation Module** - Structured preparation for clinical postings
2. **Digital Inter-Department Referral System** - Replaces manual referrals
3. **Priority Tagging System** - EMERGENCY, HIGH, ROUTINE classification
4. **Patient Navigation System** - SMS/WhatsApp notifications with clear directions
5. **Faculty Monitoring Dashboard** - Real-time referral and student activity tracking
6. **Complete Audit Trail** - All actions logged for compliance

---

## Technology Stack

### Backend
- **Framework**: FastAPI (Python 3.9+)
- **ORM**: SQLAlchemy 2.0
- **Database**: PostgreSQL 13+
- **Authentication**: JWT with bcrypt
- **Validation**: Pydantic v2

### Frontend  
- **Framework**: Flutter 3.0+
- **State Management**: Riverpod/Provider
- **Storage**: Secure local storage for tokens
- **Design**: Material Design 3

### Database
- **PostgreSQL** with UUID primary keys
- Comprehensive relational schema
- Audit logging tables
- Analytics views

---

## Quick Start - Backend

### Prerequisites
```bash
python --version  # 3.9 or higher
postgresql --version  # 13 or higher
```

### Setup

1. **Create database**
   ```bash
   psql -U postgres
   CREATE DATABASE clinic_companion;
   \q
   ```

2. **Initialize schema**
   ```bash
   psql -U postgres -d clinic_companion < database/schema.sql
   ```

3. **Install dependencies**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

4. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. **Run backend**
   ```bash
   python -m uvicorn app.main:app --reload
   ```
   
   Backend runs at: http://localhost:8000
   API Docs: http://localhost:8000/docs

---

## Project Structure

### Backend (`/backend`)

```
backend/
├── app/
│   ├── main.py              # FastAPI app initialization
│   ├── config.py            # Configuration & settings
│   ├── database.py          # Database connection
│   ├── middleware.py        # Request/response middleware
│   ├── auth/                # Authentication & JWT
│   ├── models/              # SQLAlchemy ORM models
│   ├── schemas/             # Pydantic validation schemas
│   ├── routers/             # API route handlers
│   ├── services/            # Business logic
│   ├── notifications/       # Notification providers
│   └── utils/               # Utilities & constants
├── requirements.txt
├── .env.example
└── README.md
```

### Database (`/database`)

```
database/
├── schema.sql              # Complete PostgreSQL schema
├── seed_data.sql          # Demo data
└── migrations/            # Migration scripts
```

### Documentation (`/docs`)

```
docs/
├── API_DOCUMENTATION.md       # REST API reference
├── DATABASE_DESIGN.md         # Database schema details
├── ARCHITECTURE.md            # System architecture
├── SETUP_INSTRUCTIONS.md      # Detailed setup guide
├── WORKFLOW_GUIDE.md          # End-to-end workflows
└── DEPLOYMENT.md              # Production deployment
```

---

## API Endpoints

### Authentication
```
POST   /api/v1/auth/login          - User login
POST   /api/v1/auth/logout         - User logout
GET    /api/v1/auth/me             - Get current user
```

### Students
```
GET    /api/v1/students/           - Get all students
GET    /api/v1/students/{id}       - Get student by ID
GET    /api/v1/students/{id}/activity - Get student activity
```

### Referrals
```
POST   /api/v1/referrals/          - Create referral
GET    /api/v1/referrals/          - Get referrals (with filters)
GET    /api/v1/referrals/{id}      - Get referral details
PUT    /api/v1/referrals/{id}      - Update referral
POST   /api/v1/referrals/{id}/accept - Accept referral
POST   /api/v1/referrals/{id}/reject - Reject referral
POST   /api/v1/referrals/{id}/location - Assign location
POST   /api/v1/referrals/{id}/status - Update status
```

### Departments
```
GET    /api/v1/departments/        - Get all departments
POST   /api/v1/departments/        - Create department
GET    /api/v1/departments/{id}    - Get department details
```

### Cases
```
POST   /api/v1/cases/              - Create clinical case
GET    /api/v1/cases/              - Get all cases
GET    /api/v1/cases/{id}          - Get case details
PUT    /api/v1/cases/{id}          - Update case
```

### Locations
```
GET    /api/v1/locations/          - Get all locations
POST   /api/v1/locations/          - Create location
GET    /api/v1/locations/blocks    - Get all blocks
```

### Notifications
```
GET    /api/v1/notifications/      - Get user notifications
POST   /api/v1/notifications/send  - Send notification
POST   /api/v1/notifications/{id}/mark-read - Mark as read
```

### Analytics
```
GET    /api/v1/analytics/referrals - Referral analytics
GET    /api/v1/analytics/students  - Student analytics
GET    /api/v1/analytics/patients  - Patient analytics
```

### Admin
```
GET    /api/v1/admin/              - Admin dashboard
GET    /api/v1/admin/users         - Manage users
POST   /api/v1/admin/users         - Create user
GET    /api/v1/admin/settings      - System settings
```

---

## Demo Credentials

Default demo users (after database initialization):

### Student
- **Email**: student@clinic.demo
- **Password**: Demo@123
- **ID**: STU001
- **Department**: Periodontics

### Faculty
- **Email**: faculty@clinic.demo
- **Password**: Demo@123
- **ID**: FAC001
- **Department**: Oral Medicine

### Admin
- **Email**: admin@clinic.demo
- **Password**: Demo@123
- **ID**: ADM001

### Patient
- **Patient ID**: P001
- **Phone**: +91-9999999999
- **Age**: 35
- **Gender**: M

---

## Complete Referral Workflow

### Step-by-Step Flow

```
1. STUDENT LOGIN
   ↓
   Endpoint: POST /api/v1/auth/login
   Request: {"email": "student@clinic.demo", "password": "Demo@123"}
   Response: {"access_token": "...", "user_id": "...", "role": "STUDENT"}

2. VIEW DAILY PREPARATION
   ↓
   Endpoint: GET /api/v1/students/{id}/preparations
   Shows: Daily clinical posting, preparation checklist

3. CREATE CLINICAL CASE
   ↓
   Endpoint: POST /api/v1/cases/
   Request:
   {
     "patient_id": "P001",
     "chief_complaint": "Tooth pain",
     "clinical_findings": "Deep caries on tooth 16",
     "provisional_diagnosis": "Deep caries",
     "treatment_planned": "Consultation from Oral Medicine"
   }
   Response: {"case_id": "CASE-20240905...", "status": "ACTIVE"}

4. CREATE REFERRAL
   ↓
   Endpoint: POST /api/v1/referrals/
   Request:
   {
     "case_id": "CASE-20240905...",
     "receiving_department_id": "DEPT-ORAL-MED",
     "reason_for_referral": "Clinical evaluation required",
     "clinical_summary": "Patient with deep caries",
     "priority": "HIGH"
   }
   Response: {"referral_id": "REF-20240905...", "current_status": "PENDING"}

5. FACULTY REVIEWS (Receiving Department)
   ↓
   Endpoint: GET /api/v1/referrals/?receiving_dept=...&priority=HIGH
   Shows: High-priority referral at top of queue

6. FACULTY ACCEPTS REFERRAL
   ↓
   Endpoint: POST /api/v1/referrals/{id}/accept
   Response: {"status": "ACCEPTED"}

7. ASSIGN LOCATION
   ↓
   Endpoint: POST /api/v1/referrals/{id}/location
   Request:
   {
     "room_id": "ROOM-204",
     "unit_id": "UNIT-3",
     "floor_id": "FLOOR-2",
     "reporting_date": "2024-09-06",
     "reporting_time_start": "11:30:00",
     "reporting_time_end": "12:00:00"
   }
   Response: {"current_status": "LOCATION_ASSIGNED"}

8. PATIENT NOTIFICATION GENERATED
   ↓
   Endpoint: POST /api/v1/notifications/send
   Sends SMS/WhatsApp:
   "GO TO: Oral Medicine Department, Room 204, 2nd Floor, Chair 3
    Report: 11:30 AM - 12:00 PM
    Priority: HIGH"

9. PATIENT NAVIGATION
   ↓
   Shows clear directions and reporting time

10. UPDATE STATUS TO COMPLETED
    ↓
    Endpoint: POST /api/v1/referrals/{id}/status
    Request: {"new_status": "COMPLETED"}
    Response: {"status": "COMPLETED", "completion_date": "2024-09-06T12:15:00"}

11. ANALYTICS UPDATED
    ↓
    Endpoint: GET /api/v1/analytics/referrals
    Shows updated referral counts and completion rates
```

---

## Priority System

### Visual Indicators

```
🔴 EMERGENCY  - Red badge, appears at top of queue
🟠 HIGH       - Orange badge, appears in priority section
🟢 ROUTINE    - Green badge, appears in standard queue
```

### Status Flow

```
PENDING
  ↓
  → REJECTED (if not suitable)
  → AWAITING_CLARIFICATION (if needs more info)
  → ACCEPTED
       ↓
       LOCATION_ASSIGNED
       ↓
       PATIENT_NOTIFIED
       ↓
       PATIENT_ARRIVED
       ↓
       UNDER_CONSULTATION
       ↓
       COMPLETED
  → CANCELLED (anytime)
```

---

## Notification System

### Providers

- **Mock Provider** (default for development)
  - Prints notifications to console
  - No external API calls
  - Perfect for local development

- **SMS Provider** (ready for real SMS API)
  - Configured for Twilio, AWS SNS, etc.
  - Set `NOTIFICATION_PROVIDER=sms` in .env

- **WhatsApp Provider** (ready for WhatsApp Business API)
  - Configured for WhatsApp Business API
  - Set `NOTIFICATION_PROVIDER=whatsapp` in .env

### Notification Messages

#### For Students
- Referral accepted/rejected
- Clarification requested
- Location assigned
- Referral completed

#### For Faculty
- Emergency referral created
- High-priority referral pending
- Patient did not arrive
- Referral status changes

#### For Patients
- Referral confirmed
- Location and reporting time assigned
- Reporting time reminder
- Navigation instructions

---

## Database Schema Overview

### Key Tables

1. **users** - Authentication and user profiles
2. **students** - Student records linked to users
3. **faculty** - Faculty records linked to users
4. **patients** - Patient information
5. **departments** - Clinical departments
6. **blocks**, **floors**, **rooms**, **units** - Location hierarchy
7. **clinical_postings** - Daily student assignments
8. **preparation_materials** - Daily preparation content
9. **preparation_progress** - Student preparation tracking
10. **clinical_cases** - Patient cases
11. **referrals** - Referral records
12. **referral_locations** - Location assignments
13. **referral_status_history** - Status change tracking
14. **notifications** - In-app and sent notifications
15. **audit_logs** - Complete audit trail

---

## Security Features

✅ **JWT Authentication**
- Token-based stateless authentication
- Automatic token expiration
- Refresh token support

✅ **Role-Based Access Control (RBAC)**
- STUDENT, FACULTY, PATIENT, ADMIN roles
- Endpoint-level permission checks
- Data isolation by role

✅ **Password Security**
- Bcrypt hashing
- Secure password requirements
- Forgot password flow

✅ **Audit Logging**
- All actions logged
- User tracking
- Change history

✅ **Data Validation**
- Pydantic schema validation
- Input sanitization
- SQL injection prevention (ORM)

---

## Error Handling

All API responses follow consistent error format:

```json
{
  "detail": "Descriptive error message",
  "error_code": "SPECIFIC_ERROR",
  "timestamp": "2024-09-05T10:30:00Z",
  "path": "/api/v1/referrals/"
}
```

### Common HTTP Status Codes

- **200 OK** - Successful request
- **201 Created** - Resource created
- **400 Bad Request** - Invalid input
- **401 Unauthorized** - Missing/invalid authentication
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Resource not found
- **422 Unprocessable Entity** - Validation failed
- **500 Internal Server Error** - Server error

---

## Logging and Debugging

Backend logs are configured in `app/config.py`:

```python
LOG_LEVEL = "INFO"  # Can be DEBUG, INFO, WARNING, ERROR, CRITICAL
```

Logs appear in console and can be redirected to files.

---

## Testing the Backend

### Using FastAPI Docs (Swagger UI)

1. Start the backend: `python -m uvicorn app.main:app --reload`
2. Open: http://localhost:8000/docs
3. Try endpoints directly in the browser

### Using cURL

```bash
# Login
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"student@clinic.demo","password":"Demo@123"}'

# Get referrals
curl -X GET "http://localhost:8000/api/v1/referrals/" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Using Postman

1. Import API collection
2. Configure environment with base URL
3. Add Authorization header with token
4. Test endpoints

---

## Production Deployment

See `docs/DEPLOYMENT.md` for production setup instructions including:
- Docker containerization
- Environment configuration
- Database backups
- Load balancing
- SSL/TLS setup
- Monitoring and logging

---

## Next Steps

1. Review database schema in `database/schema.sql`
2. Familiarize with models in `backend/app/models/`
3. Explore API routes in `backend/app/routers/`
4. Test backend with demo data
5. Implement frontend screens
6. Integrate frontend with backend APIs

---

## Support and Troubleshooting

### Common Issues

**PostgreSQL Connection Error**
```
Solution: Check DATABASE_URL in .env, ensure PostgreSQL is running
```

**Module Not Found**
```
Solution: Ensure virtual environment is activated and dependencies installed
```

**Port Already in Use**
```
Solution: Change port with: uvicorn app.main:app --port 8001
```

**JWT Token Expired**
```
Solution: Login again to get new token
```

---

For detailed documentation, see the `docs/` directory.
