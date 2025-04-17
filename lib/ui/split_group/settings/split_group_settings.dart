import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/currency.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/ui/split_group/settings/change_default_currency_dialog.dart';
import 'package:splittymate/ui/split_group/settings/change_group_description_dialog.dart';
import 'package:splittymate/ui/split_group/settings/change_group_name_dialog.dart';
import 'package:splittymate/ui/split_group/settings/invitation/invitation_link_dialog.dart';

class SplitGroupSettings extends ConsumerWidget {
  final String groupId;
  const SplitGroupSettings({super.key, required this.groupId});

  inviteUserToGroup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return InvitationLinkDialog(groupId: groupId);
        });
  }

  changeDefaultCurrency(BuildContext context, WidgetRef ref) async {
    final currency = await showDialog<Currency?>(
      context: context,
      builder: (context) {
        return const SelectCurrencyDialog(
          title: 'Default currency',
        );
      },
    );
    if (currency != null) {
      await ref
          .read(splitGroupProvider(groupId).notifier)
          .updateGroupCurrency(currency.code);
    }
  }

  changeGroupName(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return const ChangeGroupNameDialog();
      },
    );
    if (name != null) {
      await ref
          .read(splitGroupProvider(groupId).notifier)
          .updateGroupName(name);
    }
  }

  changeGroupDescription(BuildContext context, WidgetRef ref) async {
    final desc = await showDialog<String>(
      context: context,
      builder: (context) {
        return const ChangeGroupDescriptionDialog();
      },
    );
    if (desc != null) {
      await ref
          .read(splitGroupProvider(groupId).notifier)
          .updateGroupDescription(desc);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(splitGroupProvider(groupId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group settings'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Change name'),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(group.name),
            ),
            onTap: () {
              changeGroupName(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Change description'),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(group.description ?? ''),
            ),
            onTap: () {
              changeGroupDescription(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_outlined),
            title: const Text('Invite members'),
            onTap: () {
              inviteUserToGroup(context);
            },
          ),
          Consumer(
            child: const Icon(Icons.currency_exchange_outlined),
            builder: (context, ref, child) {
              final defaultCurrency = group.defaultCurrency;
              return ListTile(
                leading: child,
                title: const Text('Change default currency'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(defaultCurrency),
                ),
                onTap: () {
                  changeDefaultCurrency(context, ref);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
