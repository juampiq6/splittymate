part of 'new_payment_bloc.dart';

@immutable
sealed class NewPaymentEvent {
  const NewPaymentEvent();
}

@immutable
final class NewPaymentCurrencyChangedEvent extends NewPaymentEvent {
  final String currency;
  const NewPaymentCurrencyChangedEvent(this.currency);
}

final class NewPaymentDateChangedEvent extends NewPaymentEvent {
  final DateTime date;
  const NewPaymentDateChangedEvent(this.date);
}

@immutable
final class NewPaymentAmountChangedEvent extends NewPaymentEvent {
  final double amount;
  const NewPaymentAmountChangedEvent(this.amount);
}

@immutable
final class NewPaymentPayerToggledEvent extends NewPaymentEvent {
  final String payerId;
  const NewPaymentPayerToggledEvent(this.payerId);
}

@immutable
final class NewPaymentPayeeToggledEvent extends NewPaymentEvent {
  final String payeeId;
  const NewPaymentPayeeToggledEvent(this.payeeId);
}

@immutable
final class NewPaymentSubmitEvent extends NewPaymentEvent {
  const NewPaymentSubmitEvent();
}

@immutable
final class NewPaymentResetErrorEvent extends NewPaymentEvent {
  final String? errorMessage;
  const NewPaymentResetErrorEvent(this.errorMessage);
}
