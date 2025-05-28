import 'package:splittymate/models/transactions/exports.dart';

class Payment implements Transaction {
  @override
  final String id;

  @override
  final double amount;

  @override
  final DateTime createdAt;

  @override
  final String currency;

  @override
  final String groupId;

  final String payeeId;

  final String payerId;

  @override
  final DateTime updatedAt;

  @override
  final String updatedBy;

  @override
  final DateTime date;

  Payment({
    required this.id,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    required this.groupId,
    required this.payeeId,
    required this.payerId,
    required this.updatedBy,
    required this.date,
  });

  @override
  TransactionType get type => TransactionType.payment;

  @override
  Map<String, double> get balances => {
        payerId: amount,
        payeeId: -amount,
      };

  @override
  List<String> get payersIds => payShares.keys.toList();

  @override
  String get title => 'Payment';

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      updatedBy: map['updated_by'],
      currency: map['currency'],
      groupId: map['group_id'],
      payeeId: map['payee_id'],
      payerId: map['payer_id'],
      date: DateTime.parse(map['date']),
    );
  }

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

  @override
  List<String> get participantsIds => [payeeId];

  @override
  Map<String, double> get payShares => {
        payerId: amount,
      };

  @override
  Map<String, double> get shares => {
        payeeId: amount,
      };

  @override
  int compareTo(Transaction other) {
    return other.date.compareTo(date);
  }
}
