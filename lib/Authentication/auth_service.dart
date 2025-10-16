import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _subabase = Supabase.instance.client;

  //login
  Future<AuthResponse> loginwithEmailandPassword(
    String email,
    String password,
  ) async {
    return await _subabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  //Sign up
  Future<AuthResponse> signupwithEmailandPassword(
    String email,
    String password,
  ) async {
    return await _subabase.auth.signUp(email: email, password: password);
  }
  //Logout
  Future<void> logout() async {
    await _subabase.auth.signOut();
  }
}
