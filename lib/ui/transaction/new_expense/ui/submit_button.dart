part of 'new_expense_form.dart';

class ExpenseSubmitButton extends StatelessWidget {
  const ExpenseSubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder<NewExpenseBloc, NewExpenseState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.isValid ||
                    state.status != FormSubmissionStatus.submitting &&
                        state.status != FormSubmissionStatus.failure
                ? () {
                    context.read<NewExpenseBloc>().add(
                          const NewExpenseSubmitEvent(),
                        );
                  }
                : null,
            child: const Text('Save'),
          );
        },
      ),
    );
  }
}
