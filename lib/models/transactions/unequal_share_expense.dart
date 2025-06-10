import 'dart:convert';

import 'package:splittymate/models/transactions/exports.dart';

class UnequalShareExpense extends Expense {
  UnequalShareExpense({
    required super.id,
    required super.title,
    required super.currency,
    required super.createdAt,
    required super.updatedAt,
    required super.groupId,
    required super.payShares,
    required super.shares,
    required super.date,
    required super.updatedBy,
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
  TransactionType get type => TransactionType.unequal_share_expense;
}
