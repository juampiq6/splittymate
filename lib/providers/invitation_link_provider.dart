import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/services/invitation_link_service.dart';

final invitationServiceProv = Provider<InvitationLinkService>(
  (ref) => InvitationLinkService(
    functionService: ref.read(supabaseFunctionProvider),
  ),
);

// This container is used to store the group invitation link and reset it when the invitation is accepted or rejected.
// It is used to avoid using a provider for this simple case.
final groupInvitationLinkContainer = _GroupInvitationLinkContainer();

class _GroupInvitationLinkContainer {
  String? _groupInvitation;

  _GroupInvitationLinkContainer();

  void set(String? groupInvitation) {
    _groupInvitation = groupInvitation;
  }

  void reset() {
    _groupInvitation = null;
  }

  String? get groupInvitation {
    return _groupInvitation;
  }
}
