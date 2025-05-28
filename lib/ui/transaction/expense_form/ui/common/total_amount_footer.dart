part of 'expense_form_components.dart';

class ExpenseTotalAmountFooter extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpenseTotalAmountFooter({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bloc.state.consistencyError)
                Text(
                  'The total amount payed must equal to the total shared',
                  style: context.tt.bodyMedium!.copyWith(color: Colors.red),
                ),
              Row(
                children: [
                  Text('Total:', style: context.tt.titleLarge),
                  const Expanded(child: SizedBox()),
                  Text(
                    state.totalAmount.toStringAsFixed(2),
                    style: context.tt.titleLarge,
                  ),
                  const SizedBox(width: 10),
                  ExpenseCurrencyButton(bloc: bloc),
                ],
              ),
            ],
          );
        });
  }
}
