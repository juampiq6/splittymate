part of 'expense_form_components.dart';

class ExpenseTypeSwitch extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseTypeSwitch({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Split equally', style: context.tt.titleMedium),
        const SizedBox(width: 5),
        BlocSelector<ExpenseFormBloc, ExpenseState, bool>(
          bloc: bloc,
          selector: (state) => state.isEquallyShared,
          builder: (context, isEquallyShared) {
            return Switch(
              value: isEquallyShared,
              onChanged: (b) {
                bloc.add(const ExpenseTypeChangedToggledEvent());
              },
            );
          },
        ),
      ],
    );
  }
}
