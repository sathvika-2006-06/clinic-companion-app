# Clinic Companion App

## Inter-Department Referral, Priority Tagging & Patient Navigation System for Dental Colleges

### Overview

Clinic Companion is a comprehensive, production-ready mobile application designed specifically for Indian dental colleges. It streamlines:

- **Daily Clinical Preparation**: Students access structured daily preparation material and chairside learning points
- **Digital Inter-Department Referrals**: Replaces manual/paper-based referrals with structured digital workflow
- **Smart Priority Tagging**: EMERGENCY, HIGH, and ROUTINE priority classification
- **Patient Navigation**: Automatic location assignment and SMS/WhatsApp notifications
- **Faculty Oversight**: Real-time monitoring of referrals, student activity, and clinical analytics
- **Complete Audit Trail**: All clinical workflow actions are tracked and logged

### Key Features

✅ **Student Module**
- Daily clinical posting display
- Preparation checklist with completion tracking
- Digital clinical case logging
- Create structured digital referrals
- Track referral status in real-time
- Receive notifications on referral updates

✅ **Faculty Module**
- Monitor all referrals in real-time
- Accept/reject referrals with authority
- Assign patient locations (room, floor, unit, time)
- View student clinical activity
- Track patient movement
- View comprehensive analytics dashboard

✅ **Patient Module**
- Simple, non-technical referral information display
- Clear location and reporting time instructions
- Patient navigation guidance
- SMS/WhatsApp notification integration
- No app installation required for basic functionality

✅ **Admin Module**
- User management (students, faculty, patients)
- Department configuration
- Location/room management
- Clinical posting schedule
- Preparation content management
- System settings and configuration

### Technology Stack

**Backend**: FastAPI (Python)
- RESTful API architecture
- JWT-based authentication
- Role-based access control
- PostgreSQL database

**Frontend**: Flutter
- Cross-platform mobile application
- Clean, modern UI/UX
- Offline-capable local storage
- Real-time notifications

**Database**: PostgreSQL
- Comprehensive relational schema
- Audit logging
- Full transaction support

**Notifications**: Abstracted provider architecture
- SMS integration-ready
- WhatsApp Business API integration-ready
- Mock provider for local development

### Quick Start

#### Prerequisites
- Python 3.9+
- Flutter 3.0+
- PostgreSQL 13+
- Git

#### Backend Setup

```bash
cd backend
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your configuration
python -m uvicorn app.main:app --reload
```

#### Frontend Setup

```bash
cd frontend
flutter pub get
cp .env.example .env
# Edit .env with API endpoint
flutter run
```

#### Database Setup

```bash
psql -U postgres -d clinic_companion < database/schema.sql
psql -U postgres -d clinic_companion < database/seed_data.sql
```

### Project Structure

See `PROJECT_STRUCTURE.md` for complete directory layout.

### Documentation

- **[API Documentation](docs/API_DOCUMENTATION.md)** - Complete REST API reference
- **[Database Design](docs/DATABASE_DESIGN.md)** - Schema, relationships, and indexes
- **[Architecture](docs/ARCHITECTURE.md)** - System design and data flow
- **[Setup Instructions](docs/SETUP_INSTRUCTIONS.md)** - Detailed setup guide
- **[Workflow Guide](docs/WORKFLOW_GUIDE.md)** - Complete end-to-end workflow
- **[Deployment](docs/DEPLOYMENT.md)** - Production deployment guide

### Core Workflows

#### Referral Workflow

1. **Student Login** → Views daily clinical posting
2. **Patient Examination** → Creates/updates clinical case
3. **Create Referral** → Selects receiving department and priority
4. **Submit Referral** → Referral sent to receiving department queue
5. **Faculty Review** → Receiving department reviews referral
6. **Accept & Assign** → Faculty accepts and assigns location/time
7. **Patient Notification** → SMS/WhatsApp sent to patient
8. **Patient Navigation** → Patient receives clear directions
9. **Track Status** → All parties can track referral status
10. **Complete** → Mark referral complete after consultation

### Priority System

```
🔴 EMERGENCY   - Immediate attention required
🟠 HIGH        - Prompt attention required
🟢 ROUTINE      - Normal, non-urgent referral
```

### User Roles

| Role | Permissions |
|------|-------------|
| **Student** | View prep, log cases, create referrals, track status |
| **Faculty** | Review referrals, assign locations, monitor students, view analytics |
| **Patient** | View referral info, navigation, notifications |
| **Admin** | Manage all system configuration |

### Demo Credentials

```
Student:
- Email: student@clinic.demo
- Password: Demo@123
- ID: STU001

Faculty:
- Email: faculty@clinic.demo
- Password: Demo@123
- ID: FAC001

Admin:
- Email: admin@clinic.demo
- Password: Demo@123
- ID: ADM001

Patient:
- Patient ID: P001
- Phone: +91-9999999999
```

### Sample Scenario

**Student**: Dental Student A (Periodontics)
**Patient**: P001
**Referral**: Consultation from Oral Medicine

1. Student examines patient and determines oral medicine consultation required
2. Student creates referral in app
3. Selects: Department: Oral Medicine, Priority: HIGH
4. Referral immediately appears in Oral Medicine's queue
5. Faculty accepts referral
6. Assigns: Room 204, 2nd Floor, Chair 3, Time: 11:30-12:00 PM
7. Patient receives SMS/WhatsApp:
   ```
   GO TO:
   Oral Medicine Department
   Room 204, 2nd Floor, Chair 3
   Report: 11:30 AM - 12:00 PM
   Priority: HIGH
   ```
8. Patient navigates to assigned location
9. Faculty marks patient arrived
10. Consultation begins
11. Referral marked complete
12. Analytics updated

### Key Design Principles

1. **Patient Safety First** - Clinical workflow integrity is paramount
2. **Simplicity** - Minimal friction, maximum clarity
3. **Low-Tech Patient Experience** - No app installation required for patients
4. **Complete Visibility** - Faculty can monitor all urgent cases
5. **Scalability** - Designed for growth from single college to multiple institutions
6. **Reliability** - Redundant notifications, offline capability
7. **Privacy** - Role-based access, minimal data exposure, audit logging

### Quality Assurance

All major features have been implemented and tested:
- ✅ User authentication with JWT
- ✅ Role-based access control
- ✅ Complete referral workflow
- ✅ Priority tagging and filtering
- ✅ Patient notification system
- ✅ Location assignment workflow
- ✅ Faculty monitoring dashboard
- ✅ Student activity tracking
- ✅ Comprehensive analytics
- ✅ Audit trail logging
- ✅ Error handling and validation
- ✅ Mock notification provider for local development

### File Organization

- **backend/** - FastAPI application with complete API
- **frontend/** - Flutter mobile application
- **database/** - PostgreSQL schema and seed data
- **docs/** - Complete documentation

### Running the Complete Demo

```bash
# Terminal 1: Start backend
cd backend
python -m uvicorn app.main:app --reload
# Backend running at http://localhost:8000

# Terminal 2: Start frontend
cd frontend
flutter run
# App opens on emulator/device

# Demo Flow:
# 1. Login as Student (student@clinic.demo / Demo@123)
# 2. View daily preparation
# 3. Create a clinical case
# 4. Create a referral to Oral Medicine with HIGH priority
# 5. Switch to Faculty view
# 6. Accept the referral
# 7. Assign location (Room 204, 2nd Floor, etc.)
# 8. Patient notification is generated
# 9. View patient navigation screen
# 10. Update status to completed
# 11. View analytics
```

### Support

For detailed information on setup, configuration, and troubleshooting, see the `docs/` directory.

### License

MIT License - See LICENSE file for details

---

**Built for Indian Dental Colleges | Improving Clinical Workflows | Reducing Patient Confusion | Enhancing Faculty Supervision**
