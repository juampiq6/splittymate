part of 'expense_form_components.dart';

class ExpenseSubmitButton extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseSubmitButton({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder<ExpenseFormBloc, ExpenseState>(
        bloc: bloc,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.isValid &&
                    state.status != FormSubmissionStatus.submitting &&
                    state.status != FormSubmissionStatus.failure
                ? () {
                    if (state is NewExpenseState) {
                      bloc.add(const ExpenseSubmitCreationEvent());
                    } else if (state is EditExpenseState) {
                      bloc.add(ExpenseSubmitEditionEvent(state.id));
                    }
                  }
                : null,
            child: const Text('Save'),
          );
        },
      ),
    );
  }
}
