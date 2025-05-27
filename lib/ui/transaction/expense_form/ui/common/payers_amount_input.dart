part of 'expense_form_components.dart';

class ExpensePayersAmountInput extends StatelessWidget {
  final ExpenseFormBloc<ExpenseState> bloc;
  const ExpensePayersAmountInput({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormBloc, ExpenseState, List<User>>(
      bloc: bloc,
      selector: (state) => state.payers,
      builder: (context, payers) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final p in payers) ...[
                  AmountInputField(
                    userId: p.id,
                    userName: p.name,
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
            ),
          ),
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
