part of 'new_expense_form.dart';

class ExpensePayersAmountInput extends StatelessWidget {
  const ExpensePayersAmountInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewExpenseBloc, NewExpenseState, List<User>>(
      selector: (state) => state.payers,
      builder: (context, payers) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final p in payers)
              AmountInputField(
                userId: p.id,
                userName: p.name,
                onChanged: (value) {
                  context.read<NewExpenseBloc>().add(
                        NewExpensePayerAmountChangedEvent(
                          double.tryParse(value) ?? 0,
                          p.id,
                        ),
                      );
                },
              ),
          ],
        );
      },
    );
  }
}

class AmountInputField extends StatelessWidget {
  final String userName;
  final String userId;
  final Function(String) onChanged;
  const AmountInputField({
    super.key,
    required this.userId,
    required this.userName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Amount by $userName',
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
