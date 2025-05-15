part of 'new_payment_bloc.dart';

@immutable
final class NewPaymentState {
  final String? payerId;
  final String? payeeId;
  final String currency;
  final double? amount;
  final List<User> members;
  final FormSubmissionStatus status;
  final String? errorMessage;

  const NewPaymentState({
    required this.members,
    required this.currency,
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
    FormSubmissionStatus? status,
    String? errorMessage,
  }) {
    return NewPaymentState(
      members: members,
      payerId: payerId ?? this.payerId,
      payeeId: payeeId ?? this.payeeId,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
