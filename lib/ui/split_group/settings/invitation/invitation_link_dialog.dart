import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/themes.dart';

class InvitationLinkDialog extends ConsumerStatefulWidget {
  final String groupId;
  const InvitationLinkDialog({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<InvitationLinkDialog> createState() =>
      _InvitationLinkDialogState();
}

class _InvitationLinkDialogState extends ConsumerState<InvitationLinkDialog> {
  late final String invitationLink;
  late final String groupName;
  late final String userName;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(userProvider).value!;
      userName = user.name;
      groupName = ref.read(splitGroupProvider(widget.groupId)).name;
      try {
        invitationLink =
            await ref.read(invitationServiceProv).createInvitationLink(
                  inviterEmail: user.email,
                  groupId: widget.groupId,
                  groupName: groupName,
                  inviterName: user.name,
                );
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return AlertDialog(
      title: const Text(
        'Send invitation link',
        textAlign: TextAlign.center,
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Copy this invitation link or share it with your favorite app.',
          ),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: context.theme.colorScheme.secondaryContainer,
          ),
          onPressed: () async {
            final shareText =
                "$userName has invited you to join $groupName on SplittyMate. Click here to open the invitation in the app: \n$invitationLink";
            final res = await Share.share(shareText);
            if (res.status == ShareResultStatus.success) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully shared'),
                  ),
                );
                context.pop();
                context.go(AppRoute.splitGroupSettings.path(
                  parameters: {'groupId': widget.groupId},
                ));
              }
            }
          },
          icon: const Icon(Icons.share),
          label: const Text('Share'),
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
              parameters: {'groupId': widget.groupId},
            ));
          },
          label: const Text('Copy link'),
          icon: const Icon(Icons.copy_outlined),
        ),
      ],
    );
  }
}
