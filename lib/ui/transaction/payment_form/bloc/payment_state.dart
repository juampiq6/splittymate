part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {
  final String? payerId;
  final String? payeeId;
  final String currency;
  final double? amount;
  final DateTime date;
  final List<User> members;
  final FormSubmissionStatus status;
  final String? errorMessage;

  const PaymentState({
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

  bool get isValid =>
      payerId != null && payeeId != null && amount != null && amount! > 0;

  PaymentState copyWith({
    String? payerId,
    String? payeeId,
    String? currency,
    double? amount,
    DateTime? date,
    FormSubmissionStatus? status,
    String? errorMessage,
  });
}

final class EditPaymentState extends PaymentState {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String updatedBy;

  const EditPaymentState({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required super.members,
    required super.currency,
    required super.date,
    required super.payerId,
    required super.payeeId,
    required super.amount,
    required super.status,
    required super.errorMessage,
  });

  @override
  EditPaymentState copyWith({
    String? payerId,
    String? payeeId,
    String? currency,
    double? amount,
    DateTime? date,
    FormSubmissionStatus? status,
    String? errorMessage,
  }) {
    return EditPaymentState(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      members: members,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      payerId: payerId ?? this.payerId,
      payeeId: payeeId ?? this.payeeId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

final class NewPaymentState extends PaymentState {
  const NewPaymentState({
    required super.members,
    required super.currency,
    required super.date,
    required super.payerId,
    required super.payeeId,
    required super.amount,
    required super.status,
    required super.errorMessage,
  });

  NewPaymentState.initial(List<User> members, String currency)
      : super(
          members: members,
          currency: currency,
          date: DateTime.now(),
          payerId: null,
          payeeId: null,
          amount: null,
          status: FormSubmissionStatus.initial,
          errorMessage: null,
        );

  @override
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
      errorMessage: errorMessage,
    );
  }
}
