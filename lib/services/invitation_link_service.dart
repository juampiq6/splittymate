import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:splittymate/services/env_vars.dart';

class InvitationLinkService {
  final String password;

  InvitationLinkService({required this.password});
  String createJWTToken({
    required String email,
    required String groupId,
    required String groupName,
    required String inviterName,
  }) {
    final jwt = JWT({
      'email': email,
      'group_id': groupId,
      'group_name': groupName,
      'inviter_name': inviterName,
    });
    return jwt.sign(
      SecretKey(password),
      algorithm: JWTAlgorithm.HS512,
      expiresIn: const Duration(hours: 2),
    );
  }

  String createInvitationLink(
      {required String email,
      required String groupId,
      required String groupName,
      required String inviterName}) {
    final token = createJWTToken(
      email: email,
      groupId: groupId,
      groupName: groupName,
      inviterName: inviterName,
    );
    return '${EnvVars.deepLinkBase}/invitation?link=$token';
  }

  Map<String, String> verifyJWTToken(String link) {
    try {
      final token = JWT.verify(
        link,
        SecretKey(password),
      );
      final payload = token.payload as Map<String, String>;
      return payload;
    } catch (e) {
      if (e is JWTExpiredException) {
        throw Exception('Invitation link has expired');
      } else {
        throw Exception('Invalid invitation link');
      }
    }
  }
}
