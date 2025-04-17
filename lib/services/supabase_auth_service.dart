import 'package:splittymate/services/env_vars.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseAuthServiceInterface {
  Future<void> magicLinkLogin(String email);
  User getLoggedUser();
  Future<bool> confirmOTP({required String otp, required String email});
  Future<void> signOut();
  Future<void> renewSession();
  Future<void> updateUserEmail(String email);
}

class SupabaseAuthService implements SupabaseAuthServiceInterface {
  SupabaseAuthService({required this.auth});
  final GoTrueClient auth;

  @override
  User getLoggedUser() {
    return auth.currentUser!;
  }

  Stream<AuthState> authStateStream() {
    return auth.onAuthStateChange;
  }

  bool get isLogged => auth.currentUser != null;
  bool get isAuthenticated =>
      auth.currentSession != null && auth.currentSession!.isExpired == false;

  @override
  Future<void> magicLinkLogin(String email) async {
    try {
      await auth.signInWithOtp(
          email: email,
          shouldCreateUser: true,
          emailRedirectTo: '${EnvVars.deepLinkBase}/login/otp_input/$email');
    } catch (e) {
      if (e is AuthException) {
        throw SupabaseException(
          'Failed to send magic link',
          details: e.message,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> updateUserEmail(String email) async {
    try {
      await auth.updateUser(UserAttributes(email: email));
    } catch (e) {
      if (e is AuthException) {
        throw SupabaseException(
          'Failed to update user email',
          details: e.message,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut(scope: SignOutScope.global);
    } catch (e) {
      if (e is AuthException) {
        throw SupabaseException(
          'Failed to sign out',
          details: e.message,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> renewSession() async {
    try {
      await auth.refreshSession();
    } catch (e) {
      if (e is AuthException) {
        throw SupabaseException(
          'Failed to renew session',
          details: e.message,
        );
      }
      rethrow;
    }
  }

  @override
  Future<bool> confirmOTP({
    required String otp,
    required String email,
  }) async {
    try {
      final response = await auth.verifyOTP(
        token: otp,
        email: email,
        type: OtpType.email,
      );
      return response.session != null;
    } catch (e) {
      if (e is AuthException) {
        throw SupabaseException(
          'Failed to confirm OTP',
          details: e.toString(),
        );
      }
      rethrow;
    }
  }
}

class SupabaseException implements Exception {
  final String message;
  final String? details;

  SupabaseException(this.message, {this.details});

  @override
  String toString() {
    return '$message${details != null ? ': $details' : ''}';
  }
}
