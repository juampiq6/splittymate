import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/dto/transaction_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/routes.dart';
import 'package:splittymate/ui/common/loading_dialog.dart';
import 'package:splittymate/ui/transaction/user_selectable_chips.dart';
import 'package:splittymate/ui/themes.dart';

class NewExpenseForm extends StatefulWidget {
  final SplitGroup splitGroup;
  const NewExpenseForm({super.key, required this.splitGroup});

  @override
  State<NewExpenseForm> createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends State<NewExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  late final Map<User, bool> selectedParticipants;
  late final Map<User, bool> selectedPayers;
  late final Map<String, double> payersAmount;
  String? title;

  // TODO Check if this is OK
  bool get formIsValid =>
      title != null &&
      title!.isNotEmpty &&
      selectedParticipants.values.any((e) => true) &&
      selectedPayers.values.any((e) => true) &&
      payersAmount.values.any((e) => e > 0);

  @override
  void initState() {
    selectedParticipants = {
      for (final member in widget.splitGroup.members) member: true,
    };
    selectedPayers = {
      for (final member in widget.splitGroup.members) member: false,
    };
    payersAmount = {
      for (final member in widget.splitGroup.members) member.id: 0,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      onChanged: (value) => setState(
                        () {
                          title = value;
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      maxLength: 100,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2021),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        date = selectedDate;
                        setState(() {});
                      }
                    },
                    padding: const EdgeInsets.all(15),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Participants',
                    style: context.tt.titleLarge,
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: ExpenseUserSelectableChips(
                      selectedUsers: selectedParticipants,
                      onUserSelected: (User user) {
                        selectedParticipants[user] =
                            !selectedParticipants[user]!;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Payers',
                    style: context.tt.titleLarge,
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: ExpenseUserSelectableChips(
                      selectedUsers: selectedPayers,
                      onUserSelected: (User user) {
                        selectedPayers[user] = !selectedPayers[user]!;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final p in selectedPayers.entries)
                        if (p.value)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Amount by ${p.key.name}',
                                      isDense: true,
                                      prefix: const Text('\$ '),
                                    ),
                                    inputFormatters: [
                                      // Only lets number inputs that are greater than 0 and have at most 3 decimal places
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        final value =
                                            double.tryParse(newValue.text);
                                        if (value != null && value >= 0) {
                                          if (newValue.text.contains('.') &&
                                              newValue.text
                                                      .split('.')
                                                      .last
                                                      .length >
                                                  3) {
                                            return TextEditingValue(
                                              text: value.toStringAsFixed(3),
                                            );
                                          }
                                          return newValue;
                                        }
                                        return oldValue;
                                      }),
                                    ],
                                    onChanged: (value) {
                                      payersAmount[p.key.id] =
                                          double.tryParse(value) ?? 0;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                    ],
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Row(
                children: [
                  Text('Total:', style: context.tt.titleLarge),
                  const Expanded(child: SizedBox()),
                  Text(
                    widget.splitGroup.defaultCurrency,
                    style: context.tt.titleLarge,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    payersAmount.values
                        .reduce((a, b) => a + b)
                        .toStringAsFixed(2),
                    style: context.tt.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Consumer(builder: (context, ref, child) {
                  final txNotif = ref
                      .read(transactionProvider(widget.splitGroup.id).notifier);
                  return ElevatedButton(
                    onPressed: formIsValid
                        ? () {
                            saveExpense(
                              txNotif,
                              EqualShareExpenseCreationDTO(
                                title: title!,
                                currency: widget.splitGroup.defaultCurrency,
                                groupId: widget.splitGroup.id,
                                payersAmount: {
                                  for (final e in payersAmount.entries)
                                    if (e.value > 0) e.key: e.value
                                },
                                date: date,
                                participantsIds: [
                                  for (final e in selectedParticipants.entries)
                                    if (e.value) e.key.id
                                ],
                                updatedBy:
                                    ref.read(userProvider).value!.user.id,
                              ),
                            );
                          }
                        : null,
                    child: const Text('Save'),
                  );
                }),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveExpense(
    TransactionNotifier notif,
    EqualShareExpenseCreationDTO dto,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error creating expense, try again later'),
          ),
        );
      }
    }
  }
}
