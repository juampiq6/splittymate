import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/ui/themes.dart';

class AcceptGroupInviteDialog extends ConsumerWidget {
  final String groupInvitation;
  const AcceptGroupInviteDialog({super.key, required this.groupInvitation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Map<String, dynamic> payload;
    try {
      payload = ref.read(invitationServiceProv).verifyJWTToken(groupInvitation);
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Group invitation '),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(e.toString(), style: context.tt.bodyMedium),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    final groupId = payload['group_id']!;
    final groupName = payload['group_name']!;
    final inviterName = payload['inviter_name']!;
    final email = payload['inviter_email']!;

    return Dialog(
      child: Column(
        children: [
          Text('Invitation to $groupName'),
          Text('$inviterName ($email) has invited you to join $groupName'),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return Material(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              );
              try {
                await ref.read(userProvider.notifier).addMemberToGroup(groupId);
                // TODO change to home and then animate group tile
                if (context.mounted) context.go('/split_group/$groupId');
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                  context.go('/');
                }
              }
            },
            child: const Text('Accept and go to group'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invitation rejected'),
                ),
              );
              context.go('/');
            },
            child: const Text('Reject invitation'),
          ),
        ],
      ),
    );
  }
}
