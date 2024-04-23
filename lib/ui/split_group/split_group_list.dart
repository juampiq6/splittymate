import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/split_group.dart';

class SplitGroupsList extends ConsumerWidget {
  final String? groupIdRedirection;
  final List<SplitGroup> groups;
  const SplitGroupsList({
    super.key,
    required this.groups,
    this.groupIdRedirection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO add redirection logic when user is invited

    if (groups.isEmpty) {
      return const Center(child: Text('No groups'));
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        final group = groups[i];
        final participantsString = group.members.map((e) => e.name).join(', ');
        return ListTile(
          title: Text(group.name),
          leading: CircleAvatar(
            child: Text(group.name[0]),
          ),
          onTap: () {
            navigateGroupHome(context, group);
          },
          subtitle: Text(participantsString),
          trailing: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              navigateGroupSettings(context, group);
            },
          ),
        );
      },
      itemCount: groups.length,
    );
  }

  navigateGroupSettings(BuildContext context, SplitGroup group) {
    context.go('/split_group/${group.id}/settings');
  }

  navigateGroupHome(BuildContext context, SplitGroup group) {
    context.go('/split_group/${group.id}');
  }
}
