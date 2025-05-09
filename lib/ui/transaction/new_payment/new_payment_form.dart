import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/currency.dart';
import 'package:splittymate/models/dto/transaction_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/routes.dart';
import 'package:splittymate/ui/common/loading_dialog.dart';
import 'package:splittymate/ui/split_group/settings/change_default_currency_dialog.dart';
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
  String? currency;

  bool get isFormValid => payer != null && payee != null && amount != null;

  @override
  Widget build(BuildContext context) {
    final membersWithoutPayer =
        widget.splitGroup.members.where((member) => member != payer).toList();
    currency = currency ?? widget.splitGroup.defaultCurrency;
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
          if (payer != null && payee != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    validator: (value) =>
                        value != null && double.parse(value) > 0
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
                      amount = double.tryParse(value);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                  child: Text(currency!),
                  onPressed: () {
                    changeCurrency(context);
                  },
                ),
              ],
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
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Consumer(
              builder: (context, ref, child) {
                final txNotifier = ref
                    .read(transactionProvider(widget.splitGroup.id).notifier);
                return ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          saveExpense(
                            txNotifier,
                            PaymentCreationDTO(
                              payerId: payer!.id,
                              payeeId: payee!.id,
                              amount: amount!,
                              currency: currency!,
                              groupId: widget.splitGroup.id,
                              updatedBy: ref.read(userProvider).value!.user.id,
                            ),
                          );
                        }
                      : null,
                  child: const Text('Save'),
                );
              },
              child: ElevatedButton(
                onPressed: isFormValid ? () {} : null,
                child: const Text('Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeCurrency(BuildContext context) async {
    final selectedCurrency = await showDialog<Currency>(
      context: context,
      builder: (context) => const SelectCurrencyDialog(
        title: 'Select currency',
      ),
    );
    if (selectedCurrency != null) {
      currency = selectedCurrency.code;
      setState(() {});
    }
  }

  void saveExpense(
    TransactionNotifier notif,
    PaymentCreationDTO dto,
  ) async {
    showDialog(
      context: context,
      builder: (context) => const LoadingFullscreenDialog(),
    );
    try {
      await notif.createTransaction(dto);
      if (mounted) {
        context.go(AppRoute.splitGroupSettings.path(
          parameters: {'groupId': widget.splitGroup.id},
        ));
      }
    } catch (e) {
      if (mounted) {
        context.pop();
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error creating expense, try again later'),
          ),
        );
      }
    }
  }
}
