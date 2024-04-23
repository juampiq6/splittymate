import 'package:splittymate/models/debt.dart';
import 'package:splittymate/models/transactions/transaction.dart';

class BalancesCalculator {
  final List<String> membersIds;
  final List<Transaction> transactions;

  BalancesCalculator({required this.membersIds, required this.transactions});

  // The resulting map will have as key the user id and as value the negative or positive balance
  Map<String, double> get getSimplifiedBalances {
    final groupBalances = {
      for (final id in membersIds) id: 0.0,
    };

    for (var tx in transactions) {
      final expBalance = tx.balances;
      expBalance.forEach((userId, amount) {
        final groupUserBalance = groupBalances[userId] ?? 0.0;
        groupBalances[userId] = groupUserBalance + amount;
      });
    }

    return groupBalances;
  }

  // The resulting map will have as key the ower and as value a map with the owes and the amounts
  List<Debt> getDebtsForUsers() {
    final debts = <Debt>[];
    final groupBalances = getSimplifiedBalances;
    final owers = <String, double>{};
    final owes = <String, double>{};

    groupBalances.forEach((userId, balance) {
      if (balance < 0) {
        owers[userId] = -balance;
      } else if (balance > 0) {
        owes[userId] = balance;
      }
    });

    for (final ower in owers.entries) {
      final owerBalance = ower.value;
      for (final owe in owes.entries) {
        // if the ower has already paid, then we continue to the next ower
        if (owerBalance <= 0) {
          break;
        }
        final oweBalance = owe.value;
        // if the owe aldready has been paid, then we continue to the next owe
        if (oweBalance <= 0) {
          continue;
        }
        final amount = oweBalance > owerBalance ? owerBalance : oweBalance;
        debts.add(Debt(ower: ower.key, owe: owe.key, amount: amount));
        owers[ower.key] = owerBalance - amount;
        owes[owe.key] = oweBalance - amount;
      }
    }
    return debts;
  }
}
