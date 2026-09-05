# Complete PostgreSQL Database Schema for Clinic Companion App

```sql
CREATE DATABASE clinic_companion;
\c clinic_companion

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USER AND AUTHENTICATION TABLES
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('STUDENT', 'FACULTY', 'PATIENT', 'ADMIN')),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ============================================================================
-- ORGANIZATIONAL STRUCTURE
-- ============================================================================

CREATE TABLE blocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE floors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    block_id UUID NOT NULL REFERENCES blocks(id),
    floor_number INT NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    head_faculty_id UUID REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    floor_id UUID NOT NULL REFERENCES floors(id),
    department_id UUID NOT NULL REFERENCES departments(id),
    room_number VARCHAR(50) NOT NULL,
    room_name VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES rooms(id),
    unit_number INT NOT NULL,
    unit_name VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- STUDENT AND FACULTY
-- ============================================================================

CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    student_id VARCHAR(50) NOT NULL UNIQUE,
    department_id UUID REFERENCES departments(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE faculty (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    faculty_id VARCHAR(50) NOT NULL UNIQUE,
    department_id UUID REFERENCES departments(id),
    designation VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- PATIENT
-- ============================================================================

CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20),
    age INT,
    gender VARCHAR(10),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- CLINICAL DATA
-- ============================================================================

CREATE TABLE clinical_postings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    date DATE NOT NULL,
    department_id UUID NOT NULL REFERENCES departments(id),
    student_id UUID NOT NULL REFERENCES students(id),
    supervisor_id UUID REFERENCES faculty(id),
    unit_id UUID REFERENCES units(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE preparation_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    department_id UUID REFERENCES departments(id),
    created_by_id UUID NOT NULL REFERENCES faculty(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE preparation_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id),
    material_id UUID NOT NULL REFERENCES preparation_materials(id),
    posting_id UUID REFERENCES clinical_postings(id),
    status VARCHAR(50) DEFAULT 'NOT_STARTED' CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED')),
    progress_percentage INT DEFAULT 0,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, material_id, posting_id)
);

CREATE TABLE clinical_cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id VARCHAR(50) NOT NULL UNIQUE,
    patient_id UUID NOT NULL REFERENCES patients(id),
    student_id UUID NOT NULL REFERENCES students(id),
    department_id UUID NOT NULL REFERENCES departments(id),
    supervisor_id UUID REFERENCES faculty(id),
    chief_complaint TEXT,
    clinical_findings TEXT,
    provisional_diagnosis TEXT,
    treatment_planned TEXT,
    case_status VARCHAR(50) DEFAULT 'ACTIVE' CHECK (case_status IN ('ACTIVE', 'COMPLETED', 'ARCHIVED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- REFERRAL WORKFLOW
-- ============================================================================

CREATE TABLE referrals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referral_id VARCHAR(50) NOT NULL UNIQUE,
    clinical_case_id UUID NOT NULL REFERENCES clinical_cases(id),
    patient_id UUID NOT NULL REFERENCES patients(id),
    referring_department_id UUID NOT NULL REFERENCES departments(id),
    referring_student_id UUID NOT NULL REFERENCES students(id),
    referring_faculty_id UUID REFERENCES faculty(id),
    receiving_department_id UUID NOT NULL REFERENCES departments(id),
    reason_for_referral TEXT NOT NULL,
    clinical_summary TEXT,
    provisional_diagnosis TEXT,
    priority VARCHAR(50) NOT NULL CHECK (priority IN ('EMERGENCY', 'HIGH', 'ROUTINE')),
    current_status VARCHAR(50) DEFAULT 'PENDING' CHECK (current_status IN (
        'PENDING', 'ACCEPTED', 'REJECTED', 'AWAITING_CLARIFICATION',
        'LOCATION_ASSIGNED', 'PATIENT_NOTIFIED', 'PATIENT_ARRIVED',
        'UNDER_CONSULTATION', 'COMPLETED', 'CANCELLED'
    )),
    referral_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acceptance_date TIMESTAMP,
    completion_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_referrals_patient_id ON referrals(patient_id);
CREATE INDEX idx_referrals_priority ON referrals(priority);
CREATE INDEX idx_referrals_current_status ON referrals(current_status);
CREATE INDEX idx_referrals_receiving_department_id ON referrals(receiving_department_id);

CREATE TABLE referral_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referral_id UUID NOT NULL REFERENCES referrals(id),
    previous_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by_id UUID REFERENCES users(id),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE referral_locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referral_id UUID NOT NULL UNIQUE REFERENCES referrals(id),
    department_id UUID NOT NULL REFERENCES departments(id),
    room_id UUID REFERENCES rooms(id),
    unit_id UUID REFERENCES units(id),
    floor_id UUID REFERENCES floors(id),
    block_id UUID REFERENCES blocks(id),
    reporting_date DATE NOT NULL,
    reporting_time_start TIME NOT NULL,
    reporting_time_end TIME NOT NULL,
    assigned_by_id UUID NOT NULL REFERENCES faculty(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_id UUID REFERENCES users(id),
    recipient_phone VARCHAR(20),
    notification_type VARCHAR(100) NOT NULL,
    title VARCHAR(255),
    message TEXT NOT NULL,
    related_referral_id UUID REFERENCES referrals(id),
    is_read BOOLEAN DEFAULT false,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notification_delivery_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    notification_id UUID NOT NULL REFERENCES notifications(id),
    delivery_channel VARCHAR(50) NOT NULL CHECK (delivery_channel IN ('SMS', 'WHATSAPP', 'IN_APP', 'EMAIL')),
    delivery_status VARCHAR(50) NOT NULL CHECK (delivery_status IN ('PENDING', 'SENT', 'FAILED', 'DELIVERED')),
    provider_response TEXT,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- AUDIT TRAIL
-- ============================================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
```
