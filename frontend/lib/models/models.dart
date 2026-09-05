// Models for data structures

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // STUDENT, FACULTY, ADMIN
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? 'STUDENT',
      phone: json['phone'] ?? '',
    );
  }
}

class ReferralModel {
  final String referralId;
  final String patientId;
  final String priority; // EMERGENCY, HIGH, ROUTINE
  final String status; // PENDING, ACCEPTED, LOCATION_ASSIGNED, etc.
  final String receivingDepartment;
  final String reasonForReferral;
  final String clinicalSummary;
  final DateTime createdAt;
  final ReferralLocation? location;

  ReferralModel({
    required this.referralId,
    required this.patientId,
    required this.priority,
    required this.status,
    required this.receivingDepartment,
    required this.reasonForReferral,
    required this.clinicalSummary,
    required this.createdAt,
    this.location,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      referralId: json['referral_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      priority: json['priority'] ?? 'ROUTINE',
      status: json['status'] ?? json['current_status'] ?? 'PENDING',
      receivingDepartment: json['receiving_department'] ?? json['reason'] ?? '',
      reasonForReferral: json['reason_for_referral'] ?? json['reason'] ?? '',
      clinicalSummary: json['clinical_summary'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class ReferralLocation {
  final String block;
  final String floor;
  final String room;
  final String unit;
  final String reportingTime;
  final String reportingDate;

  ReferralLocation({
    required this.block,
    required this.floor,
    required this.room,
    required this.unit,
    required this.reportingTime,
    required this.reportingDate,
  });

  factory ReferralLocation.fromJson(Map<String, dynamic> json) {
    return ReferralLocation(
      block: json['block'] ?? 'Block A',
      floor: json['floor'] ?? '2nd Floor',
      room: json['room'] ?? 'Room 201',
      unit: json['unit'] ?? 'Chair 1',
      reportingTime: json['reporting_time'] ?? '10:00 AM - 10:30 AM',
      reportingDate: json['reporting_date'] ?? DateTime.now().toString(),
    );
  }
}

class DepartmentModel {
  final String id;
  final String name;
  final String code;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class ClinicalCaseModel {
  final String caseId;
  final String patientId;
  final String chiefComplaint;
  final String clinicalFindings;
  final String provisionalDiagnosis;
  final String treatmentPlanned;
  final String status;
  final DateTime createdAt;

  ClinicalCaseModel({
    required this.caseId,
    required this.patientId,
    required this.chiefComplaint,
    required this.clinicalFindings,
    required this.provisionalDiagnosis,
    required this.treatmentPlanned,
    required this.status,
    required this.createdAt,
  });

  factory ClinicalCaseModel.fromJson(Map<String, dynamic> json) {
    return ClinicalCaseModel(
      caseId: json['case_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      chiefComplaint: json['chief_complaint'] ?? '',
      clinicalFindings: json['clinical_findings'] ?? '',
      provisionalDiagnosis: json['provisional_diagnosis'] ?? '',
      treatmentPlanned: json['treatment_planned'] ?? '',
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
