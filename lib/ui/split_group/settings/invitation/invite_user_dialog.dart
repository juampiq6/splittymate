import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/ui/split_group/settings/invitation/email_sent_dialog_DEPRECATED.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

class InviteUserDialog extends StatefulWidget {
  final String groupId;
  const InviteUserDialog({super.key, required this.groupId});

  @override
  State<InviteUserDialog> createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends State<InviteUserDialog> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: AlertDialog(
        title: const Text(
          'Invite user',
          textAlign: TextAlign.center,
        ),
        content: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [
            AutofillHints.email,
          ],
          decoration: const InputDecoration(
              labelText: 'Email',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
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
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: context.theme.colorScheme.secondaryContainer,
            ),
            child: Icon(
              Icons.close_rounded,
              color: context.theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Consumer(
            builder: (context, ref, child) => FilledButton(
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                final user = ref.watch(userProvider).value!.user;
                Form.of(context).validate();
                final email = emailController.text;
                if (isValidEmail(email)) {
                  final invitationLink =
                      ref.read(invitationServiceProv).createInvitationLink(
                            inviterEmail: user.email,
                            groupId: widget.groupId,
                            groupName: ref
                                .watch(splitGroupProvider(widget.groupId))
                                .name,
                            inviterName: user.name,
                          );
                  if (context.mounted) {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (context) => EmailSentDialog(
                        email: email,
                        invitationLink: invitationLink,
                        groupId: widget.groupId,
                      ),
                    );
                  }
                }
              },
              child: const Icon(Icons.check),
              // label: const Text('Invite'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendInvitationEmail(String email) async {
    // TODO send email
  }
}
