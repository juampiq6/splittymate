import 'dart:convert';

import 'package:splittymate/models/transactions/transaction.dart';

abstract class Expense implements Transaction {
  @override
  final String id;
  @override
  final String title;
  @override
  final String currency;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String groupId;
  @override
  final Map<String, double> shares;
  @override
  final Map<String, double> payShares;
  @override
  final DateTime date;
  @override
  final String updatedBy;

  Expense({
    required this.id,
    required this.title,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.groupId,
    required this.shares,
    required this.payShares,
    required this.date,
    required this.updatedBy,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'currency': currency,
      'group_id': groupId,
      'shares': json.encode(shares),
      'pay_shares': json.encode(payShares),
      'date': date.toIso8601String(),
      'updated_by': updatedBy,
    };
  }

  @override
  Map<String, double> get balances {
    final balances = <String, double>{};
    final allUsers = <String>{...participantsIds, ...payShares.keys};
    for (final id in allUsers) {
      balances[id] = (payShares[id] ?? 0) - (shares[id] ?? 0);
    }
    return balances;
  }

  @override
  List<String> get payersIds => payShares.keys.toList();

  @override
  List<String> get participantsIds => shares.keys.toList();

  @override
  double get amount {
    return payShares.values.reduce((a, b) => a + b);
  }

  @override
  int compareTo(Transaction other) {
    return other.date.compareTo(date);
  }
}
