part of 'new_expense_form.dart';

class ExpenseParticipantsChips extends StatelessWidget {
  final List<User> members;
  const ExpenseParticipantsChips({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewExpenseBloc, NewExpenseState, List<User>>(
      selector: (state) => state.participants,
      builder: (context, participants) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in members) member: participants.contains(member),
          },
          onUserSelected: (u) {
            context.read<NewExpenseBloc>().add(
                  NewExpenseParticipantToggledEvent(u.id),
                );
          },
        );
      },
    );
  }
}
