import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/ui/split_group/animated_tile.dart';
import 'package:splittymate/ui/utils.dart';

class SplitGroupsList extends ConsumerWidget {
  final String? groupIdAnimateIn;
  const SplitGroupsList({
    super.key,
    this.groupIdAnimateIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProv = ref.watch(userProvider).value!;
    final userId = userProv.user.id;
    final groups = userProv.groups;
    if (groups.isEmpty) {
      return const Center(child: Text('No groups'));
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        final groupId = groups[i].id;
        final group = ref.watch(splitGroupProvider(groupId));
        final participantsString = group.members
            .where((u) => u.id != userId)
            .map((u) => u.name)
            .join(', ');
        final bkgColor = colorFromString(group.id, 255, 0.7);
        final tile = ListTile(
          key: ValueKey(groupId),
          title: Text(group.name),
          leading: CircleAvatar(
            backgroundColor: bkgColor,
            child: Text(
              group.name[0],
            ),
          ),
          onTap: () {
            navigateGroupHome(context, group);
          },
          subtitle: Wrap(
            children: [
              const Icon(
                Icons.people,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(participantsString.isNotEmpty ? participantsString : 'You'),
            ],
          ),
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
        if (groupId == groupIdAnimateIn) {
          return AnimatedTile(
            duration: const Duration(milliseconds: 800),
            child: tile,
          );
        }
        return tile;
      },
      itemCount: groups.length,
    );
  }

  navigateGroupSettings(BuildContext context, SplitGroup group) {
    context.go('/split_group_settings/${group.id}');
    // context.go('/split_group/${group.id}/settings');
  }

  navigateGroupHome(BuildContext context, SplitGroup group) {
    context.go('/split_group/${group.id}');
  }
}
