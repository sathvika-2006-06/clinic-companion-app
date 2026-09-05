# Database Design - Clinic Companion

## Database Overview

**Database**: PostgreSQL 13+
**Schema**: clinic_companion
**Connection String**: `postgresql://user:password@localhost/clinic_companion`

---

## Entity Relationship Diagram

```
users (id, email, role)
  |
  +-- students (user_id, student_id, department_id)
  |    |
  |    +-- clinical_postings (student_id, department_id)
  |    |
  |    +-- clinical_cases (student_id, patient_id)
  |         |
  |         +-- referrals (case_id, patient_id)
  |              |
  |              +-- referral_locations (referral_id)
  |              |
  |              +-- referral_status_history (referral_id)
  |
  +-- faculty (user_id, faculty_id, department_id)
  |
  +-- patients (id, patient_id, phone)

departments (id, name, code)
  |
  +-- blocks (id, name)
       |
       +-- floors (block_id, floor_number)
            |
            +-- rooms (floor_id, room_number)
                 |
                 +-- units (room_id, unit_number)

preparation_materials (id, department_id, created_by_id)
  |
  +-- preparation_progress (material_id, student_id)

notifications (id, recipient_id, related_referral_id)
  |
  +-- notification_delivery_logs (notification_id)

audit_logs (id, user_id, entity_id)
```

---

## Table Definitions

### users
Store user authentication and profile information.

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,  -- STUDENT, FACULTY, PATIENT, ADMIN
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    last_login TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Indexes:**
- Primary: `id`
- Unique: `email`
- Regular: `role`, `is_active`

---

### students
Link users to student records.

```sql
CREATE TABLE students (
    id UUID PRIMARY KEY,
    user_id UUID UNIQUE NOT NULL REFERENCES users(id),
    student_id VARCHAR(50) UNIQUE NOT NULL,
    department_id UUID REFERENCES departments(id),
    admission_year INT,
    semester INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

---

### faculty
Link users to faculty records.

```sql
CREATE TABLE faculty (
    id UUID PRIMARY KEY,
    user_id UUID UNIQUE NOT NULL REFERENCES users(id),
    faculty_id VARCHAR(50) UNIQUE NOT NULL,
    department_id UUID REFERENCES departments(id),
    designation VARCHAR(100),
    specialization VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

---

### patients
Store patient information.

```sql
CREATE TABLE patients (
    id UUID PRIMARY KEY,
    patient_id VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(20),
    age INT,
    gender VARCHAR(10),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

---

### departments
Store department information.

```sql
CREATE TABLE departments (
    id UUID PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    head_faculty_id UUID REFERENCES faculty(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Indexes:**
- Primary: `id`
- Unique: `name`, `code`
- Regular: `head_faculty_id`, `is_active`

---

### blocks, floors, rooms, units
Location hierarchy for the dental college.

```
Block (e.g., "Block A")
  |
  +-- Floor (e.g., "1st Floor")
       |
       +-- Room (e.g., "Room 101")
            |
            +-- Unit (e.g., "Chair 1")
```

---

### clinical_cases
Store patient clinical case information.

```sql
CREATE TABLE clinical_cases (
    id UUID PRIMARY KEY,
    case_id VARCHAR(50) UNIQUE NOT NULL,
    patient_id UUID NOT NULL REFERENCES patients(id),
    student_id UUID NOT NULL REFERENCES students(id),
    department_id UUID NOT NULL REFERENCES departments(id),
    supervisor_id UUID REFERENCES faculty(id),
    chief_complaint TEXT,
    clinical_findings TEXT,
    provisional_diagnosis TEXT,
    treatment_planned TEXT,
    case_status VARCHAR(50) DEFAULT 'ACTIVE',
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Indexes:**
- Primary: `id`
- Unique: `case_id`
- Regular: `patient_id`, `student_id`, `department_id`, `case_status`

---

### referrals
Core referral records.

```sql
CREATE TABLE referrals (
    id UUID PRIMARY KEY,
    referral_id VARCHAR(50) UNIQUE NOT NULL,
    clinical_case_id UUID NOT NULL REFERENCES clinical_cases(id),
    patient_id UUID NOT NULL REFERENCES patients(id),
    referring_department_id UUID NOT NULL REFERENCES departments(id),
    referring_student_id UUID NOT NULL REFERENCES students(id),
    receiving_department_id UUID NOT NULL REFERENCES departments(id),
    reason_for_referral TEXT NOT NULL,
    clinical_summary TEXT,
    provisional_diagnosis TEXT,
    priority VARCHAR(50) NOT NULL,  -- EMERGENCY, HIGH, ROUTINE
    current_status VARCHAR(50) DEFAULT 'PENDING',
    referral_date TIMESTAMP,
    acceptance_date TIMESTAMP,
    completion_date TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Indexes:**
- Primary: `id`
- Unique: `referral_id`
- Regular: `patient_id`, `priority`, `current_status`, `receiving_department_id`, `referral_date`

**Priority Values:**
- EMERGENCY (1) - Highest priority
- HIGH (2) - Medium priority
- ROUTINE (3) - Normal priority

**Status Values:**
- PENDING
- ACCEPTED
- REJECTED
- AWAITING_CLARIFICATION
- LOCATION_ASSIGNED
- PATIENT_NOTIFIED
- PATIENT_ARRIVED
- UNDER_CONSULTATION
- COMPLETED
- CANCELLED

---

### referral_locations
Location assignment for referrals.

```sql
CREATE TABLE referral_locations (
    id UUID PRIMARY KEY,
    referral_id UUID UNIQUE NOT NULL REFERENCES referrals(id),
    department_id UUID NOT NULL REFERENCES departments(id),
    room_id UUID REFERENCES rooms(id),
    unit_id UUID REFERENCES units(id),
    floor_id UUID REFERENCES floors(id),
    block_id UUID REFERENCES blocks(id),
    reporting_date DATE NOT NULL,
    reporting_time_start TIME NOT NULL,
    reporting_time_end TIME NOT NULL,
    assigned_by_id UUID NOT NULL REFERENCES faculty(id),
    assignment_notes TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

---

### referral_status_history
Track all status changes.

```sql
CREATE TABLE referral_status_history (
    id UUID PRIMARY KEY,
    referral_id UUID NOT NULL REFERENCES referrals(id),
    previous_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by_id UUID REFERENCES users(id),
    changed_at TIMESTAMP
);
```

---

### notifications
Store notifications.

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY,
    recipient_id UUID REFERENCES users(id),
    recipient_phone VARCHAR(20),
    notification_type VARCHAR(100) NOT NULL,
    title VARCHAR(255),
    message TEXT NOT NULL,
    related_referral_id UUID REFERENCES referrals(id),
    is_read BOOLEAN DEFAULT false,
    sent_at TIMESTAMP,
    created_at TIMESTAMP
);
```

---

### notification_delivery_logs
Track notification delivery attempts.

```sql
CREATE TABLE notification_delivery_logs (
    id UUID PRIMARY KEY,
    notification_id UUID NOT NULL REFERENCES notifications(id),
    delivery_channel VARCHAR(50),  -- SMS, WHATSAPP, IN_APP, EMAIL
    delivery_status VARCHAR(50),   -- PENDING, SENT, FAILED, DELIVERED
    provider_response TEXT,
    attempted_at TIMESTAMP
);
```

---

### audit_logs
Complete audit trail.

```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    action_type VARCHAR(100) NOT NULL,  -- CREATE, UPDATE, DELETE, etc.
    entity_type VARCHAR(100),
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    created_at TIMESTAMP
);
```

---

## Analytics Views

### referral_statistics_by_priority
```sql
CREATE VIEW referral_statistics_by_priority AS
SELECT 
    DATE(referral_date) as date,
    priority,
    COUNT(*) as count,
    SUM(CASE WHEN current_status = 'COMPLETED' THEN 1 ELSE 0 END) as completed
FROM referrals
GROUP BY DATE(referral_date), priority;
```

### referral_statistics_by_department
```sql
CREATE VIEW referral_statistics_by_department AS
SELECT 
    rd.name as department,
    COUNT(*) as total_referrals,
    SUM(CASE WHEN r.current_status = 'COMPLETED' THEN 1 ELSE 0 END) as completed
FROM referrals r
JOIN departments rd ON r.receiving_department_id = rd.id
GROUP BY rd.name;
```

---

## Performance Optimization

### Indexes Created
- Composite index on `(referral_id, current_status)` for queue queries
- Composite index on `(department_id, referral_date)` for analytics
- Full-text search index on `clinical_summary` for case search

### Query Optimization Tips
1. Always filter by date range for historical queries
2. Use LIMIT for pagination to avoid large result sets
3. Cache department and location data (rarely changes)
4. Archive completed referrals after 90 days

---

## Backup Strategy

**Daily Backups:**
```bash
pg_dump clinic_companion > clinic_companion_$(date +%Y%m%d).sql
```

**Restore:**
```bash
psql clinic_companion < clinic_companion_20240905.sql
```

---

## Migration Example

Adding a new column:
```sql
ALTER TABLE referrals ADD COLUMN priority_reason TEXT;
```

---

For complete schema file, see `database/schema.sql`
