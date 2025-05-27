import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/profile/avatar_loader.dart';
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
        actions: [
          IconButton(
              onPressed: () {
                context.go(
                  AppRoute.editExpenseForm.path(parameters: {
                    'groupId': group.id,
                    'txId': expense.id,
                  }),
                );
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseDateRow(date: expense.date),
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
                      ExpenseUsersBox(
                        users: payers,
                        shares: expense.payShares,
                        currency: expense.currency,
                        title: 'Payers',
                      ),
                      ExpenseUsersBox(
                        users: participants,
                        shares: expense.shares,
                        currency: expense.currency,
                        title: 'Participants',
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

class ExpenseUsersBox extends StatelessWidget {
  const ExpenseUsersBox({
    super.key,
    required this.users,
    required this.shares,
    required this.currency,
    required this.title,
  });

  final String title;
  final List<User> users;
  final Map<String, double> shares;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const Divider(),
        ...users.map((u) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  AvatarLoader(
                    email: u.email,
                    nickname: u.nickname,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(u.name),
                  const Expanded(child: SizedBox()),
                  Text(
                    shares[u.id]!.priceFormatted(),
                  ),
                  const SizedBox(width: 4),
                  Text(currency),
                ],
              ),
            )),
      ],
    );
  }
}
