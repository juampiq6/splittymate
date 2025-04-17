import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/services/env_vars.dart';
import 'package:splittymate/services/invitation_link_service.dart';

final invitationServiceProv = Provider<InvitationLinkService>(
  (ref) => InvitationLinkService(password: EnvVars.invitationLinkSecret),
);

// This provider is then filled with the group invitation link
final groupInvitationProvider = StateProvider<String?>((ref) => null);
