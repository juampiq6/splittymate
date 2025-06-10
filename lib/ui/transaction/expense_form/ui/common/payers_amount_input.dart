part of 'expense_form_components.dart';

class ExpensePayersAmountInput extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpensePayersAmountInput({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseState>(
      bloc: bloc,
      builder: (context, state) {
        return Wrap(
          spacing: 4,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            for (final p in state.payers) ...[
              AmountInputField(
                labelText: p.name,
                initialValue: state.payShares[p.id] ?? 0,
                onChanged: (value) {
                  bloc.add(
                    ExpensePayerAmountChangedEvent(
                      double.tryParse(value) ?? 0,
                      p.id,
                    ),
                  );
                },
              ),
            ]
          ],
        );
      },
    );
  }
}

class AmountInputField extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final double? initialValue;
  const AmountInputField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.initialValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 148,
            child: TextFormField(
              initialValue: initialValue.toString(),
              decoration: InputDecoration(
                labelText: labelText,
                isDense: true,
                prefix: const Text('\$ '),
              ),
              inputFormatters: [
                // Only lets number inputs that are greater than 0 and have at most 3 decimal places
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final value = double.tryParse(newValue.text);
                  if (value != null && value >= 0) {
                    if (newValue.text.contains('.') &&
                        newValue.text.split('.').last.length > 3) {
                      return TextEditingValue(
                        text: value.toStringAsFixed(3),
                      );
                    }
                    return newValue;
                  }
                  return oldValue;
                }),
              ],
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
