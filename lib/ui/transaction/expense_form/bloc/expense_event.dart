part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {
  const ExpenseEvent();
}

@immutable
final class ExpenseNameChangedEvent extends ExpenseEvent {
  final String name;
  const ExpenseNameChangedEvent(this.name);
}

@immutable
final class ExpenseDateChangedEvent extends ExpenseEvent {
  final DateTime date;
  const ExpenseDateChangedEvent(this.date);
}

@immutable
final class ExpenseCurrencyChangedEvent extends ExpenseEvent {
  final String currency;
  const ExpenseCurrencyChangedEvent(this.currency);
}

@immutable
final class ExpensePayerAmountChangedEvent extends ExpenseEvent {
  final double amount;
  final String userId;
  const ExpensePayerAmountChangedEvent(this.amount, this.userId);
}

@immutable
final class ExpenseParticipantAmountChangedEvent extends ExpenseEvent {
  final String userId;
  final double amount;
  const ExpenseParticipantAmountChangedEvent(this.amount, this.userId);
}

@immutable
final class ExpensePayerToggledEvent extends ExpenseEvent {
  final String payerId;
  const ExpensePayerToggledEvent(this.payerId);
}

@immutable
final class ExpenseParticipantToggledEvent extends ExpenseEvent {
  final String participantId;
  const ExpenseParticipantToggledEvent(this.participantId);
}

@immutable
final class ExpenseSubmitEvent extends ExpenseEvent {
  const ExpenseSubmitEvent();
}

@immutable
final class ExpenseResetErrorEvent extends ExpenseEvent {
  const ExpenseResetErrorEvent();
}
