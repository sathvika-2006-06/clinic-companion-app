# API Documentation - Clinic Companion

## Base URL
```
http://localhost:8000/api/v1
```

## Authentication

All authenticated endpoints require an `Authorization` header:
```
Authorization: Bearer {access_token}
```

---

## Authentication Endpoints

### POST /auth/login
User login endpoint.

**Request Body:**
```json
{
  "email": "student@clinic.demo",
  "password": "Demo@123"
}
```

**Response (200):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "role": "STUDENT",
  "email": "student@clinic.demo",
  "first_name": "Dental",
  "last_name": "Student"
}
```

---

## Referral Endpoints

### POST /referrals
Create a new referral.

**Request Body:**
```json
{
  "case_id": "CASE-20240905123456-ABC123",
  "patient_id": "P-20240905-ABC123",
  "receiving_department_id": "550e8400-e29b-41d4-a716-446655440000",
  "reason_for_referral": "Clinical evaluation required",
  "clinical_summary": "Patient requires consultation",
  "provisional_diagnosis": "Deep caries",
  "priority": "HIGH"
}
```

**Response (201):**
```json
{
  "referral_id": "REF-20240905123456-DEF456",
  "patient_id": "P-20240905-ABC123",
  "receiving_department_id": "550e8400-e29b-41d4-a716-446655440000",
  "priority": "HIGH",
  "current_status": "PENDING",
  "referral_date": "2024-09-05T10:30:00Z"
}
```

### GET /referrals
Get all referrals with optional filters.

**Query Parameters:**
- `priority` (optional): EMERGENCY, HIGH, ROUTINE
- `status` (optional): PENDING, ACCEPTED, COMPLETED, etc.
- `receiving_dept` (optional): Department ID
- `skip` (optional): Pagination skip (default: 0)
- `limit` (optional): Pagination limit (default: 10)

**Response (200):**
```json
{
  "referrals": [
    {
      "referral_id": "REF-20240905123456-DEF456",
      "patient_id": "P-20240905-ABC123",
      "priority": "HIGH",
      "current_status": "PENDING",
      "referral_date": "2024-09-05T10:30:00Z"
    }
  ],
  "count": 1,
  "total": 42
}
```

### GET /referrals/{referral_id}
Get referral details.

**Response (200):**
```json
{
  "referral_id": "REF-20240905123456-DEF456",
  "patient_id": "P-20240905-ABC123",
  "receiving_department_id": "550e8400-e29b-41d4-a716-446655440000",
  "priority": "HIGH",
  "current_status": "PENDING",
  "reason_for_referral": "Clinical evaluation required",
  "clinical_summary": "Patient requires consultation",
  "referral_date": "2024-09-05T10:30:00Z"
}
```

### POST /referrals/{referral_id}/accept
Accept a referral.

**Response (200):**
```json
{
  "referral_id": "REF-20240905123456-DEF456",
  "current_status": "ACCEPTED",
  "acceptance_date": "2024-09-05T10:35:00Z"
}
```

### POST /referrals/{referral_id}/reject
Reject a referral.

**Request Body:**
```json
{
  "reason": "Not applicable for our department"
}
```

**Response (200):**
```json
{
  "referral_id": "REF-20240905123456-DEF456",
  "current_status": "REJECTED"
}
```

### POST /referrals/{referral_id}/location
Assign location to a referral.

**Request Body:**
```json
{
  "room_id": "550e8400-e29b-41d4-a716-446655440001",
  "unit_id": "550e8400-e29b-41d4-a716-446655440002",
  "floor_id": "550e8400-e29b-41d4-a716-446655440003",
  "reporting_date": "2024-09-06",
  "reporting_time_start": "11:30:00",
  "reporting_time_end": "12:00:00",
  "assignment_notes": "Chair 3"
}
```

**Response (200):**
```json
{
  "referral_id": "REF-20240905123456-DEF456",
  "current_status": "LOCATION_ASSIGNED",
  "location": {
    "department": "Oral Medicine",
    "room": "204",
    "floor": "2nd Floor",
    "unit": "Chair 3",
    "reporting_time": "11:30 AM - 12:00 PM"
  }
}
```

### POST /referrals/{referral_id}/status
Update referral status.

**Request Body:**
```json
{
  "new_status": "PATIENT_ARRIVED"
}
```

**Response (200):**
```json
{
  "referral_id": "REF-20240905123456-DEF456",
  "current_status": "PATIENT_ARRIVED",
  "status_changed_at": "2024-09-06T11:30:00Z"
}
```

---

## Cases Endpoints

### POST /cases
Create a clinical case.

**Request Body:**
```json
{
  "patient_id": "P-20240905-ABC123",
  "chief_complaint": "Tooth pain",
  "clinical_findings": "Deep caries on tooth 16",
  "provisional_diagnosis": "Deep caries",
  "treatment_planned": "RCT or Extraction"
}
```

**Response (201):**
```json
{
  "case_id": "CASE-20240905123456-ABC123",
  "patient_id": "P-20240905-ABC123",
  "case_status": "ACTIVE",
  "created_at": "2024-09-05T10:30:00Z"
}
```

### GET /cases
Get all cases.

**Response (200):**
```json
{
  "cases": [
    {
      "case_id": "CASE-20240905123456-ABC123",
      "patient_id": "P-20240905-ABC123",
      "chief_complaint": "Tooth pain",
      "case_status": "ACTIVE"
    }
  ],
  "count": 1
}
```

---

## Students Endpoints

### GET /students
Get all students.

**Response (200):**
```json
{
  "students": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "student_id": "STU001",
      "first_name": "Dental",
      "last_name": "Student",
      "department": "Periodontics"
    }
  ],
  "count": 1
}
```

### GET /students/{student_id}
Get student details.

**Response (200):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "student_id": "STU001",
  "first_name": "Dental",
  "last_name": "Student",
  "email": "student@clinic.demo",
  "department": "Periodontics",
  "semester": 5
}
```

---

## Analytics Endpoints

### GET /analytics/referrals
Get referral analytics.

**Response (200):**
```json
{
  "total_referrals": 42,
  "by_priority": {
    "EMERGENCY": 3,
    "HIGH": 11,
    "ROUTINE": 28
  },
  "by_status": {
    "PENDING": 7,
    "ACCEPTED": 20,
    "COMPLETED": 15,
    "REJECTED": 0
  },
  "completion_rate": 85.7,
  "average_processing_time_minutes": 45
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "detail": "Invalid request parameters",
  "error_code": "INVALID_INPUT"
}
```

### 401 Unauthorized
```json
{
  "detail": "Invalid credentials",
  "error_code": "INVALID_CREDENTIALS"
}
```

### 403 Forbidden
```json
{
  "detail": "Insufficient permissions",
  "error_code": "INSUFFICIENT_PERMISSIONS"
}
```

### 404 Not Found
```json
{
  "detail": "Referral not found",
  "error_code": "RESOURCE_NOT_FOUND"
}
```

### 422 Unprocessable Entity
```json
{
  "detail": "Validation error",
  "errors": [
    {
      "field": "priority",
      "message": "Invalid priority level"
    }
  ]
}
```

### 500 Internal Server Error
```json
{
  "detail": "Internal server error",
  "error_code": "INTERNAL_ERROR",
  "timestamp": "2024-09-05T10:30:00Z"
}
```

---

## Rate Limiting

Current implementation: No rate limiting (development mode)

Production setup should include:
- 100 requests/minute per user
- 1000 requests/minute per IP
- Exponential backoff for failures

---

## Pagination

Endpoints that return lists support pagination:

```
GET /referrals/?skip=0&limit=10
```

**Response:**
```json
{
  "items": [...],
  "total": 42,
  "skip": 0,
  "limit": 10
}
```

---

## Status Codes

| Code | Meaning |
|------|----------|
| 200 | OK - Successful request |
| 201 | Created - Resource created |
| 204 | No Content - Successful but no response body |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing/invalid auth |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 422 | Unprocessable Entity - Validation failed |
| 500 | Internal Server Error - Server error |
| 503 | Service Unavailable - Server down |

---

For interactive API testing, visit: `http://localhost:8000/docs`
