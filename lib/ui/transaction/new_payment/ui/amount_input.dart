part of 'new_payment_form.dart';

class PaymentAmountInput extends StatelessWidget {
  const PaymentAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPaymentBloc, NewPaymentState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
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
                  context.read<NewPaymentBloc>().add(
                        NewPaymentAmountChangedEvent(
                          double.tryParse(value) ?? 0,
                        ),
                      );
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const PaymentCurrencyButton(),
          ],
        );
      },
    );
  }
}
