part of 'new_expense_form.dart';

class ExpenseTotalAmountFooter extends StatelessWidget {
  const ExpenseTotalAmountFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Total:', style: context.tt.titleLarge),
        const Expanded(child: SizedBox()),
        BlocSelector<NewExpenseBloc, NewExpenseState, double>(
          selector: (state) => state.totalAmount,
          builder: (context, total) {
            return Text(
              total.toStringAsFixed(2),
              style: context.tt.titleLarge,
            );
          },
        ),
        const SizedBox(width: 10),
        const ExpenseCurrencyButton(),
      ],
    );
  }
}
