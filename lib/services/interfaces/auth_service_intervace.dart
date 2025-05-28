abstract class AuthServiceInterface {
  String? get getAuthEmail;
  String? get getAuthId;
  AuthStatus get authStatus;
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
