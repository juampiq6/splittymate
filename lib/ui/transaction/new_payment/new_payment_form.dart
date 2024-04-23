import 'package:flutter/material.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/transaction/user_selectable_chips.dart';
import 'package:splittymate/ui/utils.dart';

class NewPaymentForm extends StatefulWidget {
  final SplitGroup splitGroup;
  const NewPaymentForm({super.key, required this.splitGroup});

  @override
  State<NewPaymentForm> createState() => _NewPaymentFormState();
}

class _NewPaymentFormState extends State<NewPaymentForm> {
  User? payer;
  User? payee;
  double? amount;
  String currency = 'USD';

  bool get isFormValid => payer != null && payee != null && amount != null;

  @override
  Widget build(BuildContext context) {
    final membersWithoutPayer =
        widget.splitGroup.members.where((member) => member != payer).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Payment'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.center,
            child: ExpenseUserSelectableChips(
              selectedUsers: {
                for (final member in widget.splitGroup.members)
                  member: payer == member,
              },
              onUserSelected: (User user) {
                payer = user;
                if (payee == payer) {
                  payee = null;
                  amount = null;
                }
                setState(() {});
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'To',
            style: context.tt.bodyMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.center,
            child: ExpenseUserSelectableChips(
              selectedUsers: {
                for (final member in membersWithoutPayer)
                  member: payee == member,
              },
              onUserSelected: (User user) {
                payee = user;
                setState(() {});
              },
            ),
          ),
          if (payer != null && payee != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Amount by ${payer!.name}',
                    isDense: true,
                    prefix: const Text('\$ '),
                  ),
                  inputFormatters: [
                    // Only lets number inputs that are greater than 0 and have at most 3 decimal places
                    numberWith3DecimalsInputFormatter,
                  ],
                  onChanged: (value) {
                    amount = double.tryParse(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: isFormValid ? () {} : null,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
