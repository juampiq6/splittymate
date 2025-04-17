import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:splittymate/services/env_vars.dart';

// THIS SERVICE SHOULD BE IMPLEMENTED AS A BACKEND FUNCITON IN THE FUTURE
class InvitationLinkService {
  final String password;

  InvitationLinkService({required this.password});
  String createJWTToken({
    required String inviterEmail,
    required String groupId,
    required String groupName,
    required String inviterName,
  }) {
    final jwt = JWT({
      'group_id': groupId,
      'group_name': groupName,
      'inviter_email': inviterEmail,
      'inviter_name': inviterName,
    });
    return jwt.sign(
      SecretKey(password),
      algorithm: JWTAlgorithm.HS512,
      expiresIn: const Duration(hours: 2),
    );
  }

  String createInvitationLink(
      {required String inviterEmail,
      required String groupId,
      required String groupName,
      required String inviterName}) {
    final token = createJWTToken(
      inviterEmail: inviterEmail,
      groupId: groupId,
      groupName: groupName,
      inviterName: inviterName,
    );
    return '${EnvVars.deepLinkBase}/invitation?link=$token';
  }

  Map<String, dynamic> verifyJWTToken(String link) {
    try {
      final token = JWT.verify(
        link,
        SecretKey(password),
      );
      final payload = token.payload as Map<String, dynamic>;
      if (payload['inviter_email'] == null ||
          payload['group_id'] == null ||
          payload['group_name'] == null ||
          payload['inviter_name'] == null) {
        throw 'Invalid invitation link payload';
      }
      return payload;
    } catch (e) {
      if (e is JWTExpiredException) {
        throw 'Invitation link has expired';
      } else {
        throw 'Invalid invitation link';
      }
    }
  }
}
