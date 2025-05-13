import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/services/supabase_auth_service.dart';

final authProvider = NotifierProvider<AuthProvider, AuthState>(
  () => AuthProvider(),
);

// AuthState wont include authorization info, since that is managed by the backend
class AuthState {
  final AuthStatus status;
  final String? email;
  final String? authId;
  final String? error;

  AuthState({
    this.email,
    this.authId,
    this.status = AuthStatus.signedOut,
    this.error,
  });

  bool get hasError => error != null;
}

class AuthProvider extends Notifier<AuthState> {
  late final AuthServiceInterface authService;

  @override
  AuthState build() {
    authService = ref.read(supabaseAuthProvider);
    final authStatus = authService.authStatus;
    return AuthState(
      status: authStatus,
      email: authService.getAuthEmail,
      authId: authService.getAuthId,
    );
  }

  Future<void> renewSession() async {
    try {
      await authService.renewSession();
      state = AuthState(
        status: AuthStatus.authenticated,
        email: authService.getAuthEmail!,
        authId: authService.getAuthId!,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.tokenExpired,
        error: e.toString(),
      );
    }
  }

  // TODO check flow
  Future<void> updateUserEmail(String email) {
    return authService.updateUserEmail(email);
  }

  Future<void> magicLinkLogin(String email) async {
    try {
      await authService.magicLinkLogin(email);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.signedOut,
        error: e.toString(),
      );
    }
  }

  Future<void> confirmOTP({required String otp, required String email}) async {
    try {
      await authService.confirmOTP(otp: otp, email: email);

      state = AuthState(
        status: AuthStatus.authenticated,
        email: email,
        authId: authService.getAuthId!,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.signedOut,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await authService.signOut();
      state = AuthState(
        status: AuthStatus.signedOut,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.signedOut,
        error: e.toString(),
      );
    }
  }
}
