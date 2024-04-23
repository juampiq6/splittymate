import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/split_group_provider.dart';

class AcceptGroupInviteDialog extends ConsumerWidget {
  final String invitationLink;
  const AcceptGroupInviteDialog({super.key, required this.invitationLink});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Map<String, dynamic> payload;
    try {
      payload = ref.read(invitationLinkProv).verifyJWTToken(invitationLink);
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text(
            e.toString(),
          ),
        ),
      );
    }

    final groupId = payload['groupId']!;
    final groupName = payload['groupName']!;
    final inviterName = payload['inviterName']!;
    final email = payload['inviterEmail']!;

    return Scaffold(
      body: Column(
        children: [
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
                await ref
                    .read(splitGroupProvider(groupId).notifier)
                    .addMemberToGroup(
                      groupId,
                      email,
                    );
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
                  content: Text('Rejected invitation'),
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
