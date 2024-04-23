import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/services/env_vars.dart';

class InviteUserDialog extends StatefulWidget {
  final String groupId;
  const InviteUserDialog({super.key, required this.groupId});

  @override
  State<InviteUserDialog> createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends State<InviteUserDialog> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Invite User'),
      content: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [
          AutofillHints.email,
        ],
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          }
          if (!isValidEmail(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) => TextButton(
            onPressed: () {
              Form.of(context).validate();
              final email = emailController.text;
              if (isValidEmail(email)) {
                final invitationLink =
                    ref.read(invitationLinkProv).createInvitationLink(
                          email: email,
                          groupId: widget.groupId,
                          groupName: ref
                              .watch(splitGroupProvider(widget.groupId))
                              .name,
                          inviterName: ref.watch(userProvider).value!.user.name,
                        );
                if (context.mounted) {
                  showEmailSentDialog(email, invitationLink);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid email'),
                  ),
                );
              }
            },
            child: const Text('Create invitation link'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> sendInvitationEmail(String email) async {
    // TODO send email
  }

  void showEmailSentDialog(String email, String invitationLink) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invitation sent'),
        content: Column(
          children: [
            const Text('Copy and send the invitation link to your friend'),
            Text('The link has already been sent to $email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text:
                      '${EnvVars.deepLinkBase}/invitation?link=$invitationLink',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link copied to clipboard'),
                ),
              );
              context.go('/split_group/${widget.groupId}');
            },
            child: const Text('Copy invitation link'),
          ),
          TextButton(
            onPressed: () {
              context.go('/split_group/${widget.groupId}');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
