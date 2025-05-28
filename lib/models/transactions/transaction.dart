import 'package:splittymate/models/transactions/exports.dart';

abstract class Transaction implements Comparable<Transaction> {
  String get id;
  String get title;
  String get currency;
  DateTime get createdAt;
  String get groupId;
  Map<String, double> get payShares;
  List<String> get participantsIds;
  DateTime get updatedAt;
  String get updatedBy;
  // String get createdBy;
  DateTime get date;

  // Calculated properties
  double get amount;
  List<String> get payersIds;
  Map<String, double> get balances;
  Map<String, double> get shares;
  TransactionType get type;

  Map<String, dynamic> toJson();
  factory Transaction.fromJson(Map<String, dynamic> map) {
    final type = map['expense_type'];
    if (type == null) return Payment.fromJson(map);

    switch (type) {
      case 'equal_share_expense':
        return EqualShareExpense.fromJson(map);
      case 'unequal_share_expense':
        return UnequalShareExpense.fromJson(map);
      default:
        throw Exception('Unknown transaction type: $type');
    }
  }
}

enum TransactionType {
  equal_share_expense,
  unequal_share_expense,
  payment,
}
