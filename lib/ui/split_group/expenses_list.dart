import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/routes.dart';
import 'package:splittymate/ui/transaction/tile/expense_tile.dart';
import 'package:splittymate/ui/transaction/tile/payment_tile.dart';

import '../../models/transactions/exports.dart';

class GroupTransactionList extends ConsumerWidget {
  const GroupTransactionList({super.key, required this.group});

  final SplitGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider(group.id));
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions'));
    } else {
      return ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          final tx = transactions[i];
          if (tx is Payment) {
            final payer = group.members.firstWhere((m) => m.id == tx.payerId);
            final payee = group.members.firstWhere((m) => m.id == tx.payeeId);
            return PaymentTile(
              onTap: () {
                navigateTxDetail(context, tx.id);
              },
              amount: tx.amount,
              currency: tx.currency,
              date: tx.createdAt,
              payee: payee,
              payer: payer,
            );
          } else {
            final payers = tx.payersIds
                .map((id) => group.members.firstWhere((m) => m.id == id));
            final participants = tx.participantsIds
                .map((id) => group.members.firstWhere((m) => m.id == id));
            return ExpenseTile(
              title: tx.title,
              onTap: () {
                navigateTxDetail(context, tx.id);
              },
              amount: tx.amount,
              currency: tx.currency,
              date: tx.createdAt,
              participants: participants.toList(),
              payers: payers.toList(),
            );
          }
        },
        itemCount: transactions.length,
      );
    }
  }

  navigateTxDetail(BuildContext context, String txId) {
    context.go(
      AppRoute.transactionDetail.path(
        parameters: {'groupId': group.id, 'txId': txId},
      ),
    );
  }
}
