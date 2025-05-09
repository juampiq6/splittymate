import 'package:splittymate/models/debt.dart';
import 'package:splittymate/models/transactions/transaction.dart';

// For each currency we will have a map with the user id as key and the balance as value
// The balance will be negative if the user owes money and positive if the user is owed money
typedef BalancesByCurrency = Map<String, UserBalances>;
typedef UserBalances = Map<String, double>;

class BalancesCalculator {
  final List<String> membersIds;
  final List<Transaction> transactions;

  final Set<String> currencies;

  BalancesCalculator({
    required this.membersIds,
    required this.transactions,
  }) : currencies = {for (final tx in transactions) tx.currency};

  // The resulting map will have as key the user id and as value the negative or positive balance
  BalancesByCurrency get getSimplifiedBalances {
    final groupBalances = BalancesByCurrency();

    for (var tx in transactions) {
      for (var bal in tx.balances.entries) {
        final userId = bal.key;
        final amount = bal.value;
        if (groupBalances[tx.currency] == null) {
          groupBalances[tx.currency] = {userId: amount};
        } else {
          final currencyUserBalance =
              groupBalances[tx.currency]![userId] ?? 0.0;
          groupBalances[tx.currency]![userId] = currencyUserBalance + amount;
        }
      }
    }

    return groupBalances;
  }

  // The resulting map will have as key the ower and as value a map with the owes and the amounts
  List<Debt> getSimplifiedDebtsForUsers() {
    final debts = <Debt>[];
    final groupBalances = getSimplifiedBalances;
    final currencies = groupBalances.keys.toList();

    for (final c in currencies) {
      final owers = <String, double>{};
      final owes = <String, double>{};
      final balances = groupBalances[c]!;
      // The owes and owers are separated into two maps
      for (final e in balances.entries) {
        final userId = e.key;
        final balance = e.value;
        if (balance < 0) {
          owers[userId] = -balance;
        } else if (balance > 0) {
          owes[userId] = balance;
        }
      }

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
          // the owe maximum debt is the minimum between the ower and owe balance (the owe can have debt with multiple owers)
          final amount = oweBalance > owerBalance ? owerBalance : oweBalance;
          debts.add(
            Debt(ower: ower.key, owe: owe.key, amount: amount, currency: c),
          );
          // update the balances
          // the ower balance is reduced by the amount
          owers[ower.key] = owerBalance - amount;
          // the owe balance is reduced by the amount
          owes[owe.key] = oweBalance - amount;
        }
      }
    }
    return debts;
  }
}
