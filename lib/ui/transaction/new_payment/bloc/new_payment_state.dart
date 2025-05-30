part of 'new_payment_bloc.dart';

@immutable
final class NewPaymentState {
  final String? payerId;
  final String? payeeId;
  final String currency;
  final double? amount;
  final DateTime date;
  final List<User> members;
  final FormSubmissionStatus status;
  final String? errorMessage;

  const NewPaymentState({
    required this.members,
    required this.currency,
    required this.date,
    this.status = FormSubmissionStatus.initial,
    this.payerId,
    this.payeeId,
    this.amount,
    this.errorMessage,
  });

  List<User> get possiblePayees =>
      members.where((member) => member.id != payerId).toList();

  bool get isValid => payerId != null && payeeId != null && amount != null;

  NewPaymentState copyWith({
    String? payerId,
    String? payeeId,
    String? currency,
    double? amount,
    DateTime? date,
    FormSubmissionStatus? status,
    String? errorMessage,
  }) {
    return NewPaymentState(
      members: members,
      date: date ?? this.date,
      payerId: payerId ?? this.payerId,
      payeeId: payeeId ?? this.payeeId,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
