import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

final referralsProvider = FutureProvider<List<ReferralModel>>((ref) async {
  final apiService = ApiService();
  return apiService.getReferrals();
});

final referralDetailProvider = FutureProvider.family<ReferralModel, String>(
  (ref, referralId) async {
    final apiService = ApiService();
    return apiService.getReferralDetail(referralId);
  },
);

final departmentsProvider = FutureProvider<List<DepartmentModel>>((ref) async {
  final apiService = ApiService();
  return apiService.getDepartments();
});
