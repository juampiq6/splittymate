part of 'new_expense_form.dart';

class ExpenseDateButton extends StatelessWidget {
  const ExpenseDateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewExpenseBloc, NewExpenseState>(
      builder: (context, state) => Column(
        children: [
          IconButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: state.date,
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                if (context.mounted) {
                  context.read<NewExpenseBloc>().add(
                        NewExpenseDateChangedEvent(selectedDate),
                      );
                }
              } else {
                return;
              }
            },
            padding: const EdgeInsets.all(15),
            icon: const Icon(Icons.calendar_today),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            state.date.shortFormatted(),
            style: context.tt.bodyMedium,
          ),
        ],
      ),
    );
  }
}
