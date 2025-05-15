part of 'new_expense_bloc.dart';

@immutable
sealed class NewExpenseEvent {
  const NewExpenseEvent();
}

// @immutable
// final class NewExpenseInitialEvent extends NewExpenseEvent {
//   const NewExpenseInitialEvent();
// }

@immutable
final class NewExpenseNameChangedEvent extends NewExpenseEvent {
  final String name;
  const NewExpenseNameChangedEvent(this.name);
}

@immutable
final class NewExpenseDateChangedEvent extends NewExpenseEvent {
  final DateTime date;
  const NewExpenseDateChangedEvent(this.date);
}

@immutable
final class NewExpenseCurrencyChangedEvent extends NewExpenseEvent {
  final String currency;
  const NewExpenseCurrencyChangedEvent(this.currency);
}

@immutable
final class NewExpensePayerAmountChangedEvent extends NewExpenseEvent {
  final double amount;
  final String userId;
  const NewExpensePayerAmountChangedEvent(this.amount, this.userId);
}

@immutable
final class NewExpensePayerToggledEvent extends NewExpenseEvent {
  final String payerId;
  const NewExpensePayerToggledEvent(this.payerId);
}

@immutable
final class NewExpenseParticipantToggledEvent extends NewExpenseEvent {
  final String participantId;
  const NewExpenseParticipantToggledEvent(this.participantId);
}

@immutable
final class NewExpenseSubmitEvent extends NewExpenseEvent {
  const NewExpenseSubmitEvent();
}

@immutable
final class NewExpenseResetErrorEvent extends NewExpenseEvent {
  const NewExpenseResetErrorEvent();
}
