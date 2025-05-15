part of 'new_expense_bloc.dart';

@immutable
final class NewExpenseState {
  final String name;
  final DateTime date;
  final List<User> payers;
  final List<User> participants;
  final Map<String, double> payShares;

  final String currency;
  final FormSubmissionStatus status;
  final String? errorMessage;

  NewExpenseState({
    required this.currency,
    this.status = FormSubmissionStatus.initial,
    this.name = '',
    DateTime? date,
    this.payers = const [],
    this.participants = const [],
    this.payShares = const {},
    this.errorMessage,
  }) : date = date ?? DateTime.now();

  double get totalAmount {
    return payShares.values
        .fold<double>(0, (double sum, double value) => sum + value);
  }

  bool get isValid {
    return name.isNotEmpty &&
        payers.isNotEmpty &&
        participants.isNotEmpty &&
        totalAmount > 0;
  }

  NewExpenseState copyWith({
    String? name,
    DateTime? date,
    List<User>? payers,
    List<User>? participants,
    Map<String, double>? payShares,
    FormSubmissionStatus? status,
    String? currency,
    String? errorMessage,
  }) {
    return NewExpenseState(
      status: status ?? this.status,
      name: name ?? this.name,
      date: date ?? this.date,
      payers: payers ?? this.payers,
      participants: participants ?? this.participants,
      payShares: payShares ?? this.payShares,
      currency: currency ?? this.currency,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
