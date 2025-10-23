import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/utils/logger.dart';

class AuthService {
  final SupabaseClient _subabase = Supabase.instance.client;

  //login
  Future<AuthResponse> loginwithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      Logger.log('Attempting login for email: $email', tag: 'AUTH_SERVICE');

      final response = await _subabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        Logger.log(
          'Login successful for user: ${response.user?.email}',
          tag: 'AUTH_SERVICE',
        );
      } else {
        Logger.warn(
          'Login response received but no session found',
          tag: 'AUTH_SERVICE',
        );
      }

      return response;
    } catch (e, stackTrace) {
      Logger.error(
        'Login failed for email: $email',
        tag: 'AUTH_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  //Sign up
  Future<AuthResponse> signupwithEmailandPassword(
    String username,
    String phone,
    String email,
    String password,
  ) async {
    try {
      Logger.log('Attempting signup for email: $email', tag: 'AUTH_SERVICE');

      final response = await _subabase.auth.signUp(
        data: {'User_Name':username, 'phone': phone},
        email: email,
        password: password,
      );

      if (response.session != null) {
        Logger.log(
          'Signup successful for user: ${response.user?.email}',
          tag: 'AUTH_SERVICE',
        );
      } else {
        Logger.warn(
          'Signup response received but no session found',
          tag: 'AUTH_SERVICE',
        );
      }

      return response;
    } catch (e, stackTrace) {
      Logger.error(
        'Signup failed for email: $email',
        tag: 'AUTH_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  //Logout
  Future<void> logout() async {
    try {
      Logger.log('Attempting logout', tag: 'AUTH_SERVICE');
      await _subabase.auth.signOut();
      Logger.log('Logout successful', tag: 'AUTH_SERVICE');
    } catch (e, stackTrace) {
      Logger.error(
        'Logout failed',
        tag: 'AUTH_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
