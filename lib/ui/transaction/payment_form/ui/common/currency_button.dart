part of 'payment_form_components.dart';

class PaymentCurrencyButton extends StatelessWidget {
  final PaymentFormBloc bloc;
  const PaymentCurrencyButton({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PaymentFormBloc, PaymentState, String>(
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
                bloc.add(PaymentCurrencyChangedEvent(selectedCurrency.code));
              }
            }
          },
        );
      },
    );
  }
}
