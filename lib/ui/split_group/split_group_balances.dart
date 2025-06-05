import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/balances_calculator.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/themes.dart';

class SplitGroupBalances extends ConsumerWidget {
  final SplitGroup group;
  const SplitGroupBalances({super.key, required this.group});

  String nameFromUserId(String id) {
    return group.members.firstWhere((element) => element.id == id).name;
  }

  List<String> get membersIds => group.members.map((e) => e.id).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider(group.id));
    final calc = BalancesCalculator(
      membersIds: membersIds,
      transactions: transactions,
    );
    final balances = calc.getSimplifiedBalances;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balances'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final currencyUserBalance in balances.entries)
            for (final e in currencyUserBalance.value.entries)
              // if amount is not 0
              if (e.value != 0)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: UserBalanceContainer(
                    name: nameFromUserId(e.key),
                    balance: e.value,
                    currency: currencyUserBalance.key,
                  ),
                ),
        ],
      ),
    );
  }
}

class UserBalanceContainer extends StatelessWidget {
  final double balance;
  final String name;
  final String currency;
  const UserBalanceContainer({
    super.key,
    required this.balance,
    required this.name,
    required this.currency,
  });

  bool get isPositive => balance > 0;
  bool get isNegative => balance < 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isNegative
              ? Colors.red
              : isPositive
                  ? Colors.green
                  : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        getBalanceText(balance, name, currency),
        style: context.tt.bodyLarge,
      ),
    );
  }

  String getBalanceText(double balance, String name, String currency) {
    if (balance > 0) {
      return '$name is owed ${balance.toStringAsFixed(3)} $currency';
    } else if (balance < 0) {
      return '$name owes ${(-balance).toStringAsFixed(3)} $currency';
    } else {
      return '$name is settled up';
    }
  }
}
