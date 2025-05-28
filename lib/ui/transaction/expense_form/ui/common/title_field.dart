part of 'expense_form_components.dart';

class ExpenseTitleField extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseTitleField({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormBloc, ExpenseState, String>(
      bloc: bloc,
      selector: (state) => state.name,
      builder: (context, name) => TextFormField(
        initialValue: name,
        decoration: const InputDecoration(
          labelText: 'Title',
        ),
        onChanged: (value) => bloc.add(
          ExpenseNameChangedEvent(value),
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
