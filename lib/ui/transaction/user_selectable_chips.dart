import 'package:flutter/material.dart';
import 'package:splittymate/models/user.dart';

class ExpenseUserSelectableChips extends StatelessWidget {
  final Map<User, bool> selectedUsers;
  final Function(User) onUserSelected;
  const ExpenseUserSelectableChips(
      {super.key, required this.selectedUsers, required this.onUserSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        ...selectedUsers.entries.map(
          (e) {
            return ChoiceChip(
              label: Text(e.key.name),
              onSelected: (selected) {
                onUserSelected(e.key);
              },
              selected: e.value,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
            );
          },
        ),
      ],
    );
  }
}
