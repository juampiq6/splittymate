import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/services/env_vars.dart';
import 'package:splittymate/services/invitation_link_service.dart';

final invitationLinkProv = Provider<InvitationLinkService>(
  (ref) => InvitationLinkService(password: EnvVars.invitationLinkSecret),
);
