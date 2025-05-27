part of 'expense_form_components.dart';

class ExpenseParticipantsChips extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  final List<User> members;
  const ExpenseParticipantsChips({
    super.key,
    required this.members,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormBloc, ExpenseState, List<User>>(
      bloc: bloc,
      selector: (state) => state.participants,
      builder: (context, participants) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in members) member: participants.contains(member),
          },
          onUserSelected: (u) {
            bloc.add(
              ExpenseParticipantToggledEvent(u.id),
            );
          },
        );
      },
    );
  }
}
