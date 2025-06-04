part of 'payment_form_components.dart';

class PaymentAmountInput extends StatelessWidget {
  final PaymentFormBloc bloc;
  const PaymentAmountInput({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentFormBloc, PaymentState>(
      bloc: bloc,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                initialValue: (state.amount ?? 0).toString(),
                validator: (value) => value != null && double.parse(value) > 0
                    ? null
                    : 'Number should be greater than 0',
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  isDense: true,
                  prefix: Text('\$ '),
                ),
                inputFormatters: [
                  // Only lets number inputs that are greater than 0 and have at most 3 decimal places
                  numberWith3DecimalsInputFormatter,
                ],
                onChanged: (value) {
                  bloc.add(
                    PaymentAmountChangedEvent(
                      double.tryParse(value) ?? 0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            PaymentCurrencyButton(bloc: bloc),
          ],
        );
      },
    );
  }
}
