import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/services/invitation_link_service.dart';

final invitationServiceProv = Provider<InvitationLinkService>(
  (ref) => InvitationLinkService(
    functionService: ref.read(supabaseFunctionProvider),
  ),
);

// This provider is then filled with the group invitation link
final groupInvitationProvider = StateProvider<String?>((ref) => null);
