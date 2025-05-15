import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/user_groups_provider.dart';
import 'package:splittymate/ui/themes.dart';

class AcceptGroupInviteDialog extends ConsumerWidget {
  final Map<String, dynamic> payload;
  const AcceptGroupInviteDialog({super.key, required this.payload});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupId = payload['group_id']!;
    final groupName = payload['group_name']!;
    final inviterName = payload['inviter_name']!;
    final email = payload['inviter_email']!;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Invitation to $groupName',
              style: context.tt.displayMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '$inviterName ($email) has invited you to join $groupName',
              style: context.tt.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Material(
                      child: Container(
                        color: Colors.black.withAlpha(128),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                );
                try {
                  await ref
                      .read(userSplitGroupsProvider.notifier)
                      .addMemberToGroup(groupId);
                  if (context.mounted) {
                    context.pop();
                    context.pop(groupId);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                    context.pop();
                    context.pop();
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
                context.pop();
              },
              child: const Text('Reject invitation'),
            ),
          ],
        ),
      ),
    );
  }
}
