import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/ui/transaction/transaction_detail/transaction_amount_row.dart';
import 'package:splittymate/ui/transaction/transaction_detail/transaction_date_modification.dart';
import 'package:splittymate/ui/transaction/transaction_detail/transaction_date_row.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

import '../../../models/transactions/exports.dart';

class ExpenseDetail extends ConsumerWidget {
  final Transaction expense;
  const ExpenseDetail({
    required this.expense,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(splitGroupProvider(expense.groupId));
    final payers = expense.payersIds
        .map(
          (id) => group.members.firstWhere((m) => m.id == id),
        )
        .toList();
    final participants = expense.participantsIds
        .map((id) => group.members.firstWhere((m) => m.id == id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseDateRow(date: expense.createdAt),
            const SizedBox(height: 10),
            ExpenseAmountRow(
              amount: expense.amount,
              currency: expense.currency,
            ),
            const SizedBox(height: 10),
            ExpenseDateModificationText(
              created: expense.createdAt,
              updated: expense.updatedAt,
            ),
            const SizedBox(height: 20),
            if (expense is Payment)
              Text(
                '${payers.first.name} payed to ${participants.first.name}',
                style: context.tt.labelLarge,
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpensePayersBox(
                        payers: payers,
                        payShares: expense.payShares,
                        currency: expense.currency,
                      ),
                      ExpenseParticipantsBox(
                        participants: participants,
                        shares: expense.shares,
                        currency: expense.currency,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ExpenseParticipantsBox extends StatelessWidget {
  const ExpenseParticipantsBox({
    super.key,
    required this.participants,
    required this.shares,
    required this.currency,
  });

  final List<User> participants;
  final Map<String, double> shares;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Participants'),
        const Divider(),
        ...participants.map((p) => Row(
              children: [
                const CircleAvatar(),
                const SizedBox(width: 10),
                Text(p.name),
                const Expanded(child: SizedBox()),
                Text(
                  shares[p.id]!.priceFormatted(),
                ),
                const SizedBox(width: 4),
                Text(currency),
              ],
            )),
      ],
    );
  }
}

class ExpensePayersBox extends StatelessWidget {
  const ExpensePayersBox({
    super.key,
    required this.payers,
    required this.payShares,
    required this.currency,
  });

  final List<User> payers;
  final Map<String, double> payShares;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Payers'),
        const Divider(),
        ...payers.map((payer) => Row(
              children: [
                const CircleAvatar(),
                const SizedBox(width: 10),
                Text(payer.name),
                const Expanded(child: SizedBox()),
                Text(
                  payShares[payer.id]!.priceFormatted(),
                ),
                const SizedBox(width: 4),
                Text(currency),
              ],
            )),
      ],
    );
  }
}
