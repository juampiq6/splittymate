// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:splittymate/models/transactions/transaction.dart';

class EqualShareExpenseCreationDTO implements TransactionCreationDTO {
  final String title;
  final String currency;
  final String groupId;
  final Map<String, double> payersAmount;
  final List<String> participantsIds;
  final DateTime date;

  EqualShareExpenseCreationDTO({
    required this.title,
    required this.currency,
    required this.groupId,
    required this.payersAmount,
    required this.date,
    required this.participantsIds,
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

  UnequalShareExpenseCreationDTO({
    required this.title,
    required this.currency,
    required this.groupId,
    required this.payersAmount,
    required this.date,
    required this.shares,
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

  PaymentCreationDTO({
    required this.amount,
    required this.currency,
    required this.groupId,
    required this.payerId,
    required this.payeeId,
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
    };
  }
}

abstract interface class TransactionCreationDTO {
  TransactionType get type;
  Map<String, dynamic> toJson();
}
