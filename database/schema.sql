# Complete PostgreSQL Database Schema for Clinic Companion App

-- Create database
CREATE DATABASE clinic_companion;
\c clinic_companion

-- Enable UUID extension
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);

-- ============================================================================
-- ORGANIZATIONAL STRUCTURE TABLES
-- ============================================================================

CREATE TABLE blocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE floors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    block_id UUID NOT NULL REFERENCES blocks(id),
    floor_number INT NOT NULL,
    name VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_floors_block_id ON floors(block_id);

CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    head_faculty_id UUID REFERENCES users(id),
    location_details TEXT,
    contact_phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_departments_is_active ON departments(is_active);
CREATE INDEX idx_departments_head_faculty_id ON departments(head_faculty_id);

CREATE TABLE rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    floor_id UUID NOT NULL REFERENCES floors(id),
    department_id UUID NOT NULL REFERENCES departments(id),
    room_number VARCHAR(50) NOT NULL,
    room_name VARCHAR(255),
    room_type VARCHAR(100),
    capacity INT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_rooms_floor_id ON rooms(floor_id);
CREATE INDEX idx_rooms_department_id ON rooms(department_id);
CREATE INDEX idx_rooms_is_active ON rooms(is_active);

CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES rooms(id),
    unit_number INT NOT NULL,
    unit_name VARCHAR(255),
    unit_type VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_units_room_id ON units(room_id);
CREATE INDEX idx_units_is_active ON units(is_active);

-- ============================================================================
-- STUDENT AND FACULTY TABLES
-- ============================================================================

CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    student_id VARCHAR(50) NOT NULL UNIQUE,
    admission_year INT,
    semester INT,
    department_id UUID REFERENCES departments(id),
    batch VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_students_user_id ON students(user_id);
CREATE INDEX idx_students_student_id ON students(student_id);
CREATE INDEX idx_students_department_id ON students(department_id);

CREATE TABLE faculty (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    faculty_id VARCHAR(50) NOT NULL UNIQUE,
    designation VARCHAR(100),
    department_id UUID REFERENCES departments(id),
    specialization VARCHAR(255),
    office_location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_faculty_user_id ON faculty(user_id);
CREATE INDEX idx_faculty_faculty_id ON faculty(faculty_id);
CREATE INDEX idx_faculty_department_id ON faculty(department_id);

-- ============================================================================
-- PATIENT TABLE
-- ============================================================================

CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20),
    age INT,
    gender VARCHAR(10),
    first_visit TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_patients_patient_id ON patients(patient_id);
CREATE INDEX idx_patients_phone ON patients(phone);
CREATE INDEX idx_patients_is_active ON patients(is_active);

-- ============================================================================
-- CLINICAL POSTING AND PREPARATION TABLES
-- ============================================================================

CREATE TABLE clinical_postings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    date DATE NOT NULL,
    department_id UUID NOT NULL REFERENCES departments(id),
    student_id UUID NOT NULL REFERENCES students(id),
    unit_id UUID REFERENCES units(id),
    supervisor_id UUID REFERENCES faculty(id),
    start_time TIME,
    end_time TIME,
    posting_type VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_clinical_postings_date ON clinical_postings(date);
CREATE INDEX idx_clinical_postings_student_id ON clinical_postings(student_id);
CREATE INDEX idx_clinical_postings_department_id ON clinical_postings(department_id);
CREATE INDEX idx_clinical_postings_supervisor_id ON clinical_postings(supervisor_id);

CREATE TABLE preparation_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    content TEXT NOT NULL,
    department_id UUID REFERENCES departments(id),
    topic VARCHAR(255),
    difficulty_level VARCHAR(50),
    created_by_id UUID NOT NULL REFERENCES faculty(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_preparation_materials_department_id ON preparation_materials(department_id);
CREATE INDEX idx_preparation_materials_created_by_id ON preparation_materials(created_by_id);
CREATE INDEX idx_preparation_materials_is_active ON preparation_materials(is_active);

CREATE TABLE preparation_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id),
    material_id UUID NOT NULL REFERENCES preparation_materials(id),
    clinical_posting_id UUID REFERENCES clinical_postings(id),
    status VARCHAR(50) DEFAULT 'NOT_STARTED' CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED')),
    progress_percentage INT DEFAULT 0,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, material_id, clinical_posting_id)
);

CREATE INDEX idx_preparation_progress_student_id ON preparation_progress(student_id);
CREATE INDEX idx_preparation_progress_material_id ON preparation_progress(material_id);
CREATE INDEX idx_preparation_progress_status ON preparation_progress(status);

-- ============================================================================
-- CLINICAL CASE TABLES
-- ============================================================================

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
    date_created DATE DEFAULT CURRENT_DATE,
    case_status VARCHAR(50) DEFAULT 'ACTIVE' CHECK (case_status IN ('ACTIVE', 'COMPLETED', 'ARCHIVED')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_clinical_cases_case_id ON clinical_cases(case_id);
CREATE INDEX idx_clinical_cases_patient_id ON clinical_cases(patient_id);
CREATE INDEX idx_clinical_cases_student_id ON clinical_cases(student_id);
CREATE INDEX idx_clinical_cases_department_id ON clinical_cases(department_id);
CREATE INDEX idx_clinical_cases_supervisor_id ON clinical_cases(supervisor_id);
CREATE INDEX idx_clinical_cases_case_status ON clinical_cases(case_status);

CREATE TABLE case_attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinical_case_id UUID NOT NULL REFERENCES clinical_cases(id),
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(100),
    file_size BIGINT,
    uploaded_by_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_case_attachments_clinical_case_id ON case_attachments(clinical_case_id);

-- ============================================================================
-- REFERRAL AND REFERRAL STATUS TABLES
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
    relevant_findings TEXT,
    provisional_diagnosis TEXT,
    required_consultation TEXT,
    priority VARCHAR(50) NOT NULL CHECK (priority IN ('EMERGENCY', 'HIGH', 'ROUTINE')),
    current_status VARCHAR(50) DEFAULT 'PENDING' CHECK (current_status IN (
        'PENDING', 'ACCEPTED', 'REJECTED', 'AWAITING_CLARIFICATION',
        'LOCATION_ASSIGNED', 'PATIENT_NOTIFIED', 'PATIENT_ARRIVED',
        'UNDER_CONSULTATION', 'COMPLETED', 'CANCELLED'
    )),
    referral_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acceptance_date TIMESTAMP,
    completion_date TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_referrals_referral_id ON referrals(referral_id);
CREATE INDEX idx_referrals_patient_id ON referrals(patient_id);
CREATE INDEX idx_referrals_clinical_case_id ON referrals(clinical_case_id);
CREATE INDEX idx_referrals_referring_department_id ON referrals(referring_department_id);
CREATE INDEX idx_referrals_receiving_department_id ON referrals(receiving_department_id);
CREATE INDEX idx_referrals_referring_student_id ON referrals(referring_student_id);
CREATE INDEX idx_referrals_priority ON referrals(priority);
CREATE INDEX idx_referrals_current_status ON referrals(current_status);
CREATE INDEX idx_referrals_referral_date ON referrals(referral_date);

CREATE TABLE referral_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referral_id UUID NOT NULL REFERENCES referrals(id),
    previous_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by_id UUID REFERENCES users(id),
    change_reason TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_referral_status_history_referral_id ON referral_status_history(referral_id);
CREATE INDEX idx_referral_status_history_changed_at ON referral_status_history(changed_at);

CREATE TABLE referral_attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referral_id UUID NOT NULL REFERENCES referrals(id),
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(100),
    file_size BIGINT,
    uploaded_by_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_referral_attachments_referral_id ON referral_attachments(referral_id);

-- ============================================================================
-- REFERRAL LOCATION ASSIGNMENT TABLE
-- ============================================================================

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
    assignment_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_referral_locations_referral_id ON referral_locations(referral_id);
CREATE INDEX idx_referral_locations_department_id ON referral_locations(department_id);
CREATE INDEX idx_referral_locations_reporting_date ON referral_locations(reporting_date);

-- ============================================================================
-- NOTIFICATION TABLES
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
    read_at TIMESTAMP,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_recipient_id ON notifications(recipient_id);
CREATE INDEX idx_notifications_related_referral_id ON notifications(related_referral_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_sent_at ON notifications(sent_at);

CREATE TABLE notification_delivery_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    notification_id UUID NOT NULL REFERENCES notifications(id),
    delivery_channel VARCHAR(50) NOT NULL CHECK (delivery_channel IN ('SMS', 'WHATSAPP', 'IN_APP', 'EMAIL')),
    delivery_status VARCHAR(50) NOT NULL CHECK (delivery_status IN ('PENDING', 'SENT', 'FAILED', 'DELIVERED')),
    provider_response TEXT,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notification_delivery_logs_notification_id ON notification_delivery_logs(notification_id);
CREATE INDEX idx_notification_delivery_logs_delivery_status ON notification_delivery_logs(delivery_status);

-- ============================================================================
-- AUDIT TRAIL TABLE
-- ============================================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(50),
    user_agent TEXT,
    status VARCHAR(50),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action_type ON audit_logs(action_type);
CREATE INDEX idx_audit_logs_entity_type ON audit_logs(entity_type);
CREATE INDEX idx_audit_logs_entity_id ON audit_logs(entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- ============================================================================
-- ANALYTICS AND REPORTING VIEWS
-- ============================================================================

CREATE VIEW referral_statistics_by_priority AS
SELECT 
    DATE(referral_date) as date,
    priority,
    COUNT(*) as count,
    SUM(CASE WHEN current_status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_count
FROM referrals
GROUP BY DATE(referral_date), priority;

CREATE VIEW referral_statistics_by_department AS
SELECT 
    rd.name as receiving_department,
    COUNT(*) as total_referrals,
    SUM(CASE WHEN r.current_status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_referrals,
    SUM(CASE WHEN r.current_status = 'PENDING' THEN 1 ELSE 0 END) as pending_referrals,
    SUM(CASE WHEN r.priority = 'EMERGENCY' THEN 1 ELSE 0 END) as emergency_count,
    SUM(CASE WHEN r.priority = 'HIGH' THEN 1 ELSE 0 END) as high_count
FROM referrals r
JOIN departments rd ON r.receiving_department_id = rd.id
GROUP BY rd.name;

CREATE VIEW student_activity_summary AS
SELECT 
    s.id,
    s.student_id,
    u.first_name,
    u.last_name,
    COUNT(DISTINCT cc.id) as cases_logged,
    COUNT(DISTINCT r.id) as referrals_created,
    SUM(CASE WHEN r.current_status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_referrals
FROM students s
JOIN users u ON s.user_id = u.id
LEFT JOIN clinical_cases cc ON s.id = cc.student_id
LEFT JOIN referrals r ON s.id = r.referring_student_id
GROUP BY s.id, s.student_id, u.first_name, u.last_name;

-- ============================================================================
-- INITIALIZATION - Demo Users
-- ============================================================================

-- Note: In production, use proper password hashing (bcrypt)
-- These are demo credentials - passwords should be hashed
INSERT INTO users (email, password_hash, role, first_name, last_name, phone, is_active, is_verified) VALUES
('student@clinic.demo', '$2b$12$demo.student.hash', 'STUDENT', 'Dental', 'Student', '+91-9999999901', true, true),
('faculty@clinic.demo', '$2b$12$demo.faculty.hash', 'FACULTY', 'Dr.', 'Faculty', '+91-9999999902', true, true),
('admin@clinic.demo', '$2b$12$demo.admin.hash', 'ADMIN', 'System', 'Admin', '+91-9999999903', true, true),
('patient@clinic.demo', '$2b$12$demo.patient.hash', 'PATIENT', 'Patient', 'Test', '+91-9999999904', true, true);
