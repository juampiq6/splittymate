part of 'new_expense_form.dart';

class ExpenseTitleField extends StatelessWidget {
  const ExpenseTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewExpenseBloc, NewExpenseState, String>(
      selector: (state) => state.name,
      builder: (context, name) => TextFormField(
        initialValue: name,
        decoration: const InputDecoration(
          labelText: 'Title',
        ),
        onChanged: (value) => context.read<NewExpenseBloc>().add(
              NewExpenseNameChangedEvent(value),
            ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
        maxLength: 100,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
