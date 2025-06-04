import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:splittymate/env_vars.dart';
import 'package:splittymate/services/interfaces/export.dart';

class InvitationLinkService {
  final FaaServiceInterface functionService;

  InvitationLinkService({
    required this.functionService,
  });

  Future<String> _createJWTToken({
    required String inviterEmail,
    required String groupId,
    required String groupName,
    required String inviterName,
  }) async {
    try {
      final res = await functionService.callFunction(
        'jwt-token-issuer/create-jwt',
        {
          'group_id': groupId,
          'group_name': groupName,
          'inviter_email': inviterEmail,
          'inviter_name': inviterName,
        },
      );
      return res['jwt'];
    } catch (e) {
      log(e.toString());
      throw 'Failed to create invitation link';
    }
  }

  Future<String> createInvitationLink({
    required String inviterEmail,
    required String groupId,
    required String groupName,
    required String inviterName,
  }) async {
    final token = await _createJWTToken(
      inviterEmail: inviterEmail,
      groupId: groupId,
      groupName: groupName,
      inviterName: inviterName,
    );
    return '${EnvVars.deepLinkBase}/join?groupInvitation=$token';
  }

  // This function only checks if the payload is valid and not expired
  Map<String, dynamic> decodeJWTToken(String link) {
    try {
      final token = JWT.decode(link);
      final payload = token.payload as Map<String, dynamic>;
      if (payload['inviter_email'] == null ||
          payload['group_id'] == null ||
          payload['group_name'] == null ||
          payload['inviter_name'] == null) {
        throw 'Invalid invitation link payload';
      }
      return payload;
    } catch (e) {
      if (e is JWTException) {
        throw 'Invitation link has expired';
      } else {
        throw 'Invalid invitation link';
      }
    }
  }

  // This function verifies the JWT token server side and adds the user to the group
  Future<void> acceptInvitationLink(String jwt) async {
    try {
      await functionService.callFunction(
        'jwt-token-issuer/verify-jwt',
        {
          'jwt': jwt,
        },
      );
      return;
    } catch (e) {
      log(e.toString());
      throw 'Failed to accept invitation link';
    }
  }
}
