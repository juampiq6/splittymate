import 'package:flutter/material.dart';
import 'package:splittymate/models/split_group.dart';

class SplitGroupSettings extends StatelessWidget {
  final SplitGroup group;
  const SplitGroupSettings({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Change group name'),
            subtitle: Text(group.name),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Invite members'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
