part of 'expense_form_components.dart';

class ExpenseTotalAmountFooter extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseTotalAmountFooter({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Total:', style: context.tt.titleLarge),
        const Expanded(child: SizedBox()),
        BlocSelector<ExpenseFormBloc, ExpenseState, double>(
          bloc: bloc,
          selector: (state) => state.totalAmount,
          builder: (context, total) {
            return Text(
              total.toStringAsFixed(2),
              style: context.tt.titleLarge,
            );
          },
        ),
        const SizedBox(width: 10),
        ExpenseCurrencyButton(bloc: bloc),
      ],
    );
  }
}
