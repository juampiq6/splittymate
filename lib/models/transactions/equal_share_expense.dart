import 'dart:convert';

import 'package:splittymate/models/transactions/exports.dart';

class EqualShareExpense implements Transaction {
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
  final List<String> participantsIds;
  @override
  final Map<String, double> payShares;
  @override
  final DateTime date;
  @override
  final String updatedBy;

  EqualShareExpense({
    required this.id,
    required this.title,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.groupId,
    required this.participantsIds,
    required this.payShares,
    required this.date,
    required this.updatedBy,
  });

  factory EqualShareExpense.fromJson(Map<String, dynamic> map) {
    final payShares = Map<String, double>.from(json.decode(map['pay_shares']));
    final shares = Map<String, double>.from(json.decode(map['shares']));
    return EqualShareExpense(
      id: map['id'],
      title: map['title'],
      currency: map['currency'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      updatedBy: map['updated_by'],
      groupId: map['group_id'],
      payShares: payShares,
      participantsIds: shares.keys.toList(),
      date: DateTime.parse(map['date']),
    );
  }

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
  TransactionType get type => TransactionType.equal_share_expense;

  @override
  Map<String, double> get shares {
    final shares = <String, double>{};
    for (final participantId in participantsIds) {
      shares[participantId] = amount / participantsIds.length;
    }
    return shares;
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
  double get amount {
    return payShares.values.reduce((a, b) => a + b);
  }

  @override
  int compareTo(Transaction other) {
    return other.date.compareTo(date);
  }
}

// final exampleEqualShareExpenses = [
//   EqualShareExpense(
//     id: "1",
//     title: "Petrol",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     participantsIds: ["1", "2", "3"],
//     payShares: {"1": 50},
//   ),
//   EqualShareExpense(
//     id: "2",
//     title: "Groceries",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     participantsIds: ["1", "2", "3"],
//     payShares: {"2": 200},
//   ),
//   EqualShareExpense(
//     id: "3",
//     title: "Alcohol",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     participantsIds: ["1", "2", "3"],
//     payShares: {"3": 300},
//   ),
//   EqualShareExpense(
//     id: "4",
//     title: "gt",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     participantsIds: ["1", "2"],
//     payShares: {"2": 50},
//   ),
//   EqualShareExpense(
//     id: "5",
//     title: "hj",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     participantsIds: ["1"],
//     payShares: {"3": 20},
//   ),
//   EqualShareExpense(
//     id: "6",
//     title: "llj",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     participantsIds: ["3"],
//     payShares: {"2": 56},
//   ),
//   Payment(
//     id: "7",
//     currency: "USD",
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     groupId: "1",
//     amount: 50,
//     payeeId: "2",
//     payerId: "1",
//   ),
// ];
