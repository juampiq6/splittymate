part of 'new_expense_form.dart';

class ExpensePayersChips extends StatelessWidget {
  final List<User> members;
  const ExpensePayersChips({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewExpenseBloc, NewExpenseState, List<User>>(
      selector: (state) => state.payers,
      builder: (context, payers) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in members) member: payers.contains(member),
          },
          onUserSelected: (u) {
            context.read<NewExpenseBloc>().add(
                  NewExpensePayerToggledEvent(u.id),
                );
          },
        );
      },
    );
  }
}
