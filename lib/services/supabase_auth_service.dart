import 'package:splittymate/env_vars.dart';
import 'package:splittymate/services/interfaces/export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService implements AuthServiceInterface {
  SupabaseAuthService({required this.auth});
  final GoTrueClient auth;

  @override
  String? get getAuthEmail => auth.currentUser?.email;
  @override
  String? get getAuthId => auth.currentUser?.id;

  @override
  AuthStatus get authStatus {
    if (auth.currentUser == null) {
      return AuthStatus.signedOut;
    } else if (auth.currentSession!.isExpired) {
      return AuthStatus.tokenExpired;
    }
    return AuthStatus.authenticated;
  }

  @override
  Future<void> magicLinkLogin(String email) async {
    try {
      await auth.signInWithOtp(
          email: email,
          shouldCreateUser: true,
          emailRedirectTo: '${EnvVars.deepLinkBase}/login/otp_input/$email');
    } catch (e) {
      if (e is AuthException) {
        throw AuthServiceException(
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
        throw AuthServiceException(
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
        throw AuthServiceException(
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
        throw AuthServiceException(
          'Failed to renew session',
          details: e.message,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> confirmOTP({
    required String otp,
    required String email,
  }) async {
    try {
      await auth.verifyOTP(
        token: otp,
        email: email,
        type: OtpType.email,
      );
      return;
    } catch (e) {
      if (e is AuthException) {
        throw AuthServiceException(
          e.message,
          details: e.toString(),
        );
      }
      rethrow;
    }
  }
}

class AuthServiceException implements Exception {
  final String message;
  final String? details;

  AuthServiceException(this.message, {this.details});

  @override
  String toString() {
    return '$message${details != null ? ': $details' : ''}';
  }
}
