part of 'expense_bloc.dart';

@immutable
abstract base class ExpenseState {
  final String name;
  final DateTime date;
  final List<User> payers;
  final List<User> participants;
  final bool isEquallyShared;
  final Map<String, double> payShares;
  final Map<String, double> participantShares;
  final String currency;
  final FormSubmissionStatus status;
  final String? errorMessage;

  ExpenseState({
    required this.name,
    DateTime? date,
    required this.payers,
    required this.participants,
    required this.isEquallyShared,
    required this.payShares,
    required this.participantShares,
    required this.currency,
    required this.status,
    required this.errorMessage,
  }) : date = date ?? DateTime.now();

  double get totalAmount {
    return payShares.values
        .fold<double>(0, (double sum, double value) => sum + value);
  }

  double get totalSharedAmount {
    return participantShares.values
        .fold<double>(0, (double sum, double value) => sum + value);
  }

  bool get isValid {
    return name.isNotEmpty &&
        payers.isNotEmpty &&
        participants.isNotEmpty &&
        totalAmount > 0 &&
        !consistencyError;
  }

  bool get consistencyError {
    if (!isEquallyShared && totalAmount != totalSharedAmount) {
      return true;
    }
    return false;
  }

  ExpenseState copyWith({
    String? name,
    DateTime? date,
    List<User>? payers,
    List<User>? participants,
    bool? isEquallyShared,
    Map<String, double>? payShares,
    Map<String, double>? participantShares,
    FormSubmissionStatus? status,
    String? currency,
    String? errorMessage,
  });
}

@immutable
final class EditExpenseState extends ExpenseState {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String updatedBy;
  final String id;

  EditExpenseState({
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.id,
    required super.name,
    required super.date,
    required super.payers,
    required super.participants,
    required super.isEquallyShared,
    required super.payShares,
    required super.participantShares,
    required super.currency,
    required super.status,
    required super.errorMessage,
  });

  // Error message is only kept once and in the next event it is reset
  @override
  EditExpenseState copyWith({
    String? name,
    DateTime? date,
    List<User>? payers,
    List<User>? participants,
    bool? isEquallyShared,
    Map<String, double>? payShares,
    Map<String, double>? participantShares,
    FormSubmissionStatus? status,
    String? currency,
    String? errorMessage,
  }) {
    return EditExpenseState(
      createdAt: createdAt,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      id: id,
      status: status ?? this.status,
      name: name ?? this.name,
      date: date ?? this.date,
      payers: payers ?? this.payers,
      participants: participants ?? this.participants,
      isEquallyShared: isEquallyShared ?? this.isEquallyShared,
      payShares: payShares ?? this.payShares,
      participantShares: participantShares ?? this.participantShares,
      currency: currency ?? this.currency,
      errorMessage: errorMessage,
    );
  }
}

@immutable
final class NewExpenseState extends ExpenseState {
  NewExpenseState({
    required super.currency,
    super.status = FormSubmissionStatus.initial,
    super.name = '',
    super.date,
    super.payers = const [],
    super.participants = const [],
    super.isEquallyShared = true,
    super.payShares = const {},
    super.participantShares = const {},
    super.errorMessage,
  });

  // Error message is only kept once and in the next event it is reset
  @override
  NewExpenseState copyWith({
    String? name,
    DateTime? date,
    List<User>? payers,
    List<User>? participants,
    bool? isEquallyShared,
    Map<String, double>? payShares,
    Map<String, double>? participantShares,
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
      isEquallyShared: isEquallyShared ?? this.isEquallyShared,
      payShares: payShares ?? this.payShares,
      participantShares: participantShares ?? this.participantShares,
      currency: currency ?? this.currency,
      errorMessage: errorMessage,
    );
  }
}
