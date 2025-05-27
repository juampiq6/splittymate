part of 'expense_form_components.dart';

class ExpensePayersChips extends StatelessWidget {
  final List<User> members;
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpensePayersChips({
    super.key,
    required this.members,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormBloc, ExpenseState, List<User>>(
      bloc: bloc,
      selector: (state) => state.payers,
      builder: (context, payers) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in members) member: payers.contains(member),
          },
          onUserSelected: (u) {
            bloc.add(
              ExpensePayerToggledEvent(u.id),
            );
          },
        );
      },
    );
  }
}
