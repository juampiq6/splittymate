import 'package:splittymate/env_vars.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthServiceInterface {
  String? get getAuthEmail;
  String? get getAuthId;
  AuthStatus get authStatus;
  // TODO needed?
  Stream<AuthStatus> get authStatusStream;
  Future<void> magicLinkLogin(String email);
  Future<void> confirmOTP({required String otp, required String email});
  Future<void> renewSession();
  Future<void> updateUserEmail(String email);
  Future<void> signOut();
}

enum AuthStatus {
  signedOut,
  // session token is expired
  tokenExpired,
  // logged in and session token is valid
  authenticated,
}

class SupabaseAuthService implements AuthServiceInterface {
  SupabaseAuthService({required this.auth});
  final GoTrueClient auth;

  @override
  String? get getAuthEmail => auth.currentUser?.email;
  @override
  String? get getAuthId => auth.currentUser?.id;

  // Supabase auth state change stream is simplified
  @override
  Stream<AuthStatus> get authStatusStream async* {
    await for (final c in auth.onAuthStateChange) {
      if (c.event == AuthChangeEvent.signedIn) {
        yield AuthStatus.authenticated;
      } else if (c.event == AuthChangeEvent.signedOut) {
        yield AuthStatus.signedOut;
      } else if (c.event == AuthChangeEvent.tokenRefreshed) {
        yield AuthStatus.authenticated;
      }
    }
  }

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
