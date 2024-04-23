// ignore_for_file: constant_identifier_names

import 'dart:convert';

class EqualShareExpenseCreationDTO implements TransactionCreationDTO {
  final String title;
  final String currency;
  final String groupId;
  final Map<String, double> payersAmount;
  final List<String> participantsIds;
  final DateTime date;
  final String updatedBy;

  EqualShareExpenseCreationDTO({
    required this.title,
    required this.currency,
    required this.groupId,
    required this.payersAmount,
    required this.date,
    required this.participantsIds,
    required this.updatedBy,
  });

  @override
  TransactionType get type => TransactionType.equal_share_expense;

  Map<String, double> get shares {
    final totalAmount = payersAmount.values.reduce((a, b) => a + b);
    final share = totalAmount / participantsIds.length;
    return {
      for (final id in participantsIds) id: share,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'currency': currency,
      'group_id': groupId,
      'pay_shares': json.encode(payersAmount),
      'shares': json.encode(shares),
      'updated_by': updatedBy,
      'expense_type': type.name,
      'date': "${date.year}-${date.month}-${date.day}",
    };
  }
}

class UnequalShareExpenseCreationDTO implements TransactionCreationDTO {
  final String title;
  final String currency;
  final String groupId;
  final Map<String, double> payersAmount;
  final Map<String, double> shares;
  final DateTime date;
  final String updatedBy;

  UnequalShareExpenseCreationDTO({
    required this.title,
    required this.currency,
    required this.groupId,
    required this.payersAmount,
    required this.date,
    required this.shares,
    required this.updatedBy,
  });

  @override
  TransactionType get type => TransactionType.unequal_share_expense;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'currency': currency,
      'group_id': groupId,
      'pay_shares': json.encode(payersAmount),
      'shares': json.encode(shares),
      'updated_by': updatedBy,
      'expense_type': type.name,
      'date': "${date.year}-${date.month}-${date.day}",
    };
  }
}

class PaymentCreationDTO implements TransactionCreationDTO {
  final double amount;
  final String currency;
  final String groupId;
  final String payerId;
  final String payeeId;
  final DateTime date;
  final String updatedBy;

  PaymentCreationDTO({
    required this.amount,
    required this.currency,
    required this.groupId,
    required this.payerId,
    required this.payeeId,
    required this.date,
    required this.updatedBy,
  });

  @override
  TransactionType get type => TransactionType.payment;

  @override
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'group_id': groupId,
      'payer_id': payerId,
      'payee_id': payeeId,
      'date': "${date.year}-${date.month}-${date.day}",
      'updated_by': updatedBy,
    };
  }
}

abstract class TransactionCreationDTO {
  TransactionType get type;
  Map<String, dynamic> toJson();
}

enum TransactionType {
  equal_share_expense,
  unequal_share_expense,
  payment,
}
