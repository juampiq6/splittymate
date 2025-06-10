part of 'expense_form_components.dart';

class ExpenseParticipantsAmountInput extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseParticipantsAmountInput({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.isEquallyShared || state.participants.isEmpty) {
          return const SizedBox.shrink();
        }
        return Wrap(
          spacing: 4,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            for (final p in state.participants) ...[
              AmountInputField(
                labelText: p.name,
                initialValue: state.participantShares[p.id] ?? 0,
                onChanged: (value) {
                  bloc.add(
                    ExpenseParticipantAmountChangedEvent(
                      double.tryParse(value) ?? 0,
                      p.id,
                    ),
                  );
                },
              ),
            ]
          ],
        );
      },
    );
  }
}
