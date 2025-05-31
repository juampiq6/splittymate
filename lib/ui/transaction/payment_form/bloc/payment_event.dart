part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {
  const PaymentEvent();
}

@immutable
final class PaymentCurrencyChangedEvent extends PaymentEvent {
  final String currency;
  const PaymentCurrencyChangedEvent(this.currency);
}

final class PaymentDateChangedEvent extends PaymentEvent {
  final DateTime date;
  const PaymentDateChangedEvent(this.date);
}

@immutable
final class PaymentAmountChangedEvent extends PaymentEvent {
  final double amount;
  const PaymentAmountChangedEvent(this.amount);
}

@immutable
final class PaymentPayerToggledEvent extends PaymentEvent {
  final String payerId;
  const PaymentPayerToggledEvent(this.payerId);
}

@immutable
final class PaymentPayeeToggledEvent extends PaymentEvent {
  final String payeeId;
  const PaymentPayeeToggledEvent(this.payeeId);
}

@immutable
final class PaymentSubmitEvent extends PaymentEvent {
  const PaymentSubmitEvent();
}

@immutable
final class PaymentResetErrorEvent extends PaymentEvent {
  const PaymentResetErrorEvent();
}
