import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8000/api/v1';
  String? _token;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<UserModel> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get current user');
    }
  }

  // Referral endpoints
  Future<List<ReferralModel>> getReferrals({
    String? priority,
    String? status,
  }) async {
    String url = '$_baseUrl/referrals/';
    if (priority != null || status != null) {
      url += '?';
      if (priority != null) url += 'priority=$priority&';
      if (status != null) url += 'status=$status';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final referrals = (data['referrals'] as List)
          .map((ref) => ReferralModel.fromJson(ref))
          .toList();
      return referrals;
    } else {
      throw Exception('Failed to fetch referrals');
    }
  }

  Future<ReferralModel> getReferralDetail(String referralId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/referrals/$referralId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return ReferralModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch referral detail');
    }
  }

  Future<void> acceptReferral(String referralId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/referrals/$referralId/accept'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept referral');
    }
  }

  Future<void> rejectReferral(String referralId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/referrals/$referralId/reject'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject referral');
    }
  }

  Future<void> assignLocation({
    required String referralId,
    required String roomId,
    required String unitId,
    required String reportingDate,
    required String reportingTimeStart,
    required String reportingTimeEnd,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/referrals/$referralId/location'),
      headers: _getHeaders(),
      body: jsonEncode({
        'room_id': roomId,
        'unit_id': unitId,
        'reporting_date': reportingDate,
        'reporting_time_start': reportingTimeStart,
        'reporting_time_end': reportingTimeEnd,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to assign location');
    }
  }

  // Case endpoints
  Future<String> createCase({
    required String patientId,
    required String chiefComplaint,
    required String clinicalFindings,
    required String provisionalDiagnosis,
    required String treatmentPlanned,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cases/'),
      headers: _getHeaders(),
      body: jsonEncode({
        'patient_id': patientId,
        'chief_complaint': chiefComplaint,
        'clinical_findings': clinicalFindings,
        'provisional_diagnosis': provisionalDiagnosis,
        'treatment_planned': treatmentPlanned,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['case_id'];
    } else {
      throw Exception('Failed to create case');
    }
  }

  // Referral creation
  Future<String> createReferral({
    required String caseId,
    required String receivingDepartmentId,
    required String reasonForReferral,
    required String clinicalSummary,
    required String priority,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/referrals/'),
      headers: _getHeaders(),
      body: jsonEncode({
        'case_id': caseId,
        'receiving_department_id': receivingDepartmentId,
        'reason_for_referral': reasonForReferral,
        'clinical_summary': clinicalSummary,
        'priority': priority,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['referral_id'];
    } else {
      throw Exception('Failed to create referral');
    }
  }

  // Department endpoints
  Future<List<DepartmentModel>> getDepartments() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/departments/'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['departments'] as List)
          .map((dept) => DepartmentModel.fromJson(dept))
          .toList();
    } else {
      throw Exception('Failed to fetch departments');
    }
  }

  // Analytics
  Future<Map<String, dynamic>> getAnalytics() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/analytics/referrals'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch analytics');
    }
  }
}
