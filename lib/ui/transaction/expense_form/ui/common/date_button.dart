part of 'expense_form_components.dart';

class ExpenseDateButton extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseDateButton({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseState>(
      bloc: bloc,
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
                  bloc.add(
                    ExpenseDateChangedEvent(selectedDate),
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
