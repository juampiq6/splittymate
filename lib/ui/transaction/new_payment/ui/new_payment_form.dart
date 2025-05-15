import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/split_group/settings/change_default_currency_dialog.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';
import 'package:splittymate/ui/transaction/new_payment/bloc/new_payment_bloc.dart';
import 'package:splittymate/ui/transaction/user_selectable_chips.dart';
import 'package:splittymate/ui/utils.dart';

part 'payee_chips.dart';
part 'payer_chips.dart';
part 'currency_button.dart';
part 'amount_input.dart';
part 'submit_button.dart';
part 'date_row.dart';

class NewPaymentForm extends ConsumerWidget {
  final SplitGroup splitGroup;
  const NewPaymentForm({super.key, required this.splitGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Payment'),
      ),
      body: BlocProvider<NewPaymentBloc>(
        create: (context) => NewPaymentBloc(
          members: splitGroup.members,
          currency: splitGroup.defaultCurrency,
          txNotifier: ref.read<TransactionNotifier>(
              transactionProvider(splitGroup.id).notifier),
          groupId: splitGroup.id,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payer',
                style: context.tt.titleLarge,
              ),
              const Divider(),
              const Align(
                alignment: Alignment.center,
                child: PaymentPayerChips(),
              ),
              const SizedBox(
                height: 10,
              ),
              const PaymentAmountInput(),
              const SizedBox(
                height: 10,
              ),
              Text(
                'To',
                style: context.tt.titleLarge,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.center,
                child: PaymentPayeeChips(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'On',
                style: context.tt.titleLarge,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.center,
                child: PaymentDateRow(),
              ),
              const Expanded(child: SizedBox()),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: PaymentSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
