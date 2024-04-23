import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/balances_calculator.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/themes.dart';

class BalancesSumUpHeader extends ConsumerWidget {
  final SplitGroup group;
  const BalancesSumUpHeader({super.key, required this.group});

  String nameFromUserId(String id) {
    return group.members.firstWhere((element) => element.id == id).name;
  }

  List<String> get membersIds => group.members.map((e) => e.id).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider(group.id));
    final calc = BalancesCalculator(
      membersIds: membersIds,
      transactions: transactions,
    );
    final debts = calc.getDebtsForUsers();
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (debts.isEmpty)
            Text(
              'All settled up',
              style: context.tt.labelMedium,
            )
          else
            for (final d in debts)
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: nameFromUserId(d.ower),
                      style: context.tt.labelMedium,
                    ),
                    TextSpan(
                      text: ' owes ',
                      style: context.tt.bodyMedium,
                    ),
                    TextSpan(
                      text: '${nameFromUserId(d.owe)}  ',
                      style: context.tt.bodyMedium,
                    ),
                    TextSpan(
                      text: d.amount.toStringAsFixed(3),
                      style: context.tt.labelMedium,
                    ),
                    TextSpan(
                      text: ' ${group.defaultCurrency}',
                      style: context.tt.labelMedium,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
