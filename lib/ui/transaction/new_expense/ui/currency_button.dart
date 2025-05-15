part of 'new_expense_form.dart';

class ExpenseCurrencyButton extends StatelessWidget {
  const ExpenseCurrencyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewExpenseBloc, NewExpenseState, String>(
      selector: (state) => state.currency,
      builder: (context, currency) {
        return OutlinedButton(
          style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          child: Text(currency),
          onPressed: () async {
            final selectedCurrency = await showDialog<Currency>(
              context: context,
              builder: (context) => const SelectCurrencyDialog(
                title: 'Select currency',
              ),
            );
            if (selectedCurrency != null) {
              if (context.mounted) {
                context
                    .read<NewExpenseBloc>()
                    .add(NewExpenseCurrencyChangedEvent(selectedCurrency.code));
              }
            }
          },
        );
      },
    );
  }
}
