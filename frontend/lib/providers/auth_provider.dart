import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final Ref ref;
  late ApiService _apiService;

  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    _apiService = ApiService();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token != null) {
        _apiService.setToken(token);
        final user = await _apiService.getCurrentUser();
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(UserModel(
          id: '',
          email: '',
          firstName: '',
          lastName: '',
          role: 'STUDENT',
          phone: '',
        ));
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiService.login(email, password);
      final token = response['access_token'];
      final userRole = response['role'];

      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      _apiService.setToken(token);

      final user = UserModel(
        id: response['user_id'],
        email: response['email'],
        firstName: response['first_name'],
        lastName: response['last_name'],
        role: userRole,
        phone: '',
      );

      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      _apiService.clearToken();
      state = const AsyncValue.data(UserModel(
        id: '',
        email: '',
        firstName: '',
        lastName: '',
        role: 'STUDENT',
        phone: '',
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
