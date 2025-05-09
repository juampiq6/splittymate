import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/routes.dart';
import 'package:splittymate/ui/themes.dart';

class EmailSentDialog extends StatelessWidget {
  final String email;
  final String invitationLink;
  final String groupId;
  const EmailSentDialog({
    super.key,
    required this.email,
    required this.invitationLink,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Invitation sent',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'An invitation link has been sent to:',
          ),
          const SizedBox(height: 10),
          Text(
            email,
            style: context.tt.bodyLarge,
          ),
          const SizedBox(height: 10),
          const Text('This link can also be shared by copying it below.')
        ],
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: context.theme.colorScheme.secondaryContainer,
          ),
          onPressed: () {
            context.pop();
            context.go(AppRoute.splitGroupSettings.path(
              parameters: {'groupId': groupId},
            ));
          },
          child: const Icon(Icons.check_rounded),
        ),
        FilledButton.icon(
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: invitationLink,
              ),
            );
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Link copied to clipboard'),
              ),
            );
            context.go(AppRoute.splitGroupSettings.path(
              parameters: {'groupId': groupId},
            ));
          },
          label: const Text('Copy link'),
          icon: const Icon(Icons.share),
        ),
      ],
    );
  }
}
