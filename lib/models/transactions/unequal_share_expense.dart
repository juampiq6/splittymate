import 'dart:convert';

import 'package:splittymate/models/transactions/transaction.dart';

class UnequalShareExpense implements Transaction {
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
  final Map<String, double> payShares;
  @override
  final Map<String, double> shares;
  @override
  final DateTime date;
  @override
  final String updatedBy;

  UnequalShareExpense({
    required this.id,
    required this.title,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.groupId,
    required this.payShares,
    required this.shares,
    required this.date,
    required this.updatedBy,
  });

  factory UnequalShareExpense.fromJson(Map<String, dynamic> map) {
    final payShares = Map<String, double>.from(json.decode(map['pay_shares']));
    final shares = Map<String, double>.from(json.decode(map['shares']));
    return UnequalShareExpense(
      id: map['id'],
      title: map['title'],
      currency: map['currency'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      updatedBy: map['updated_by'],
      groupId: map['group_id'],
      payShares: payShares,
      shares: shares,
      date: DateTime.parse(map['date']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'currency': currency,
      'group_id': groupId,
      'pay_shares': json.encode(payShares),
      'shares': json.encode(shares),
      'date': "${date.year}-${date.month}-${date.day}",
      'updated_by': updatedBy,
    };
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
  Map<String, double> get balances {
    final balances = <String, double>{};
    final allUsers = <String>{...participantsIds, ...payShares.keys};
    for (final id in allUsers) {
      balances[id] = (payShares[id] ?? 0) - (shares[id] ?? 0);
    }
    return balances;
  }

  @override
  int compareTo(Transaction other) {
    return other.date.compareTo(createdAt);
  }
}
