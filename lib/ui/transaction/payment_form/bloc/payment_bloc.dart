import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splittymate/models/dto/export.dart';

import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentFormBloc extends Bloc<PaymentEvent, PaymentState> {
  final String groupId;
  final List<User> members;
  final TransactionNotifier txNotifier;

  PaymentFormBloc({
    required this.members,
    required String currency,
    required this.txNotifier,
    required this.groupId,
    required PaymentState initialState,
  }) : super(initialState) {
    on<PaymentCurrencyChangedEvent>(onCurrencyChanged);
    on<PaymentAmountChangedEvent>(onAmountChanged);
    on<PaymentPayerToggledEvent>(onPayerToggled);
    on<PaymentPayeeToggledEvent>(onPayeeToggled);
    on<PaymentDateChangedEvent>(onDateChanged);
    on<PaymentSubmitEvent>(onSubmit);
    on<PaymentResetErrorEvent>(onResetError);
  }

  onCurrencyChanged(
    PaymentCurrencyChangedEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(currency: event.currency));
  }

  onAmountChanged(
    PaymentAmountChangedEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  onDateChanged(
    PaymentDateChangedEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  onPayerToggled(
    PaymentPayerToggledEvent event,
    Emitter<PaymentState> emit,
  ) {
    // TODO fix setting to null wont work with copyWith
    final payer = state.payerId == event.payerId ? null : event.payerId;
    if (payer != null && payer == state.payeeId) {
      emit(state.copyWith(payerId: payer, payeeId: null));
    } else {
      emit(state.copyWith(payerId: payer));
    }
  }

  onPayeeToggled(
    PaymentPayeeToggledEvent event,
    Emitter<PaymentState> emit,
  ) {
    // TODO fix setting to null wont work with copyWith
    final payee = state.payeeId == event.payeeId ? null : event.payeeId;
    emit(state.copyWith(payeeId: payee));
  }

  onSubmit(
    PaymentSubmitEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: FormSubmissionStatus.submitting));
    try {
      if (state is EditPaymentState) {
        await txNotifier.updateTransaction(
          PaymentCreationDTO(
            amount: state.amount!,
            currency: state.currency,
            groupId: groupId,
            payerId: state.payerId!,
            payeeId: state.payeeId!,
            date: state.date,
          ),
          (state as EditPaymentState).id,
        );
      } else {
        await txNotifier.createTransaction(
          PaymentCreationDTO(
            amount: state.amount!,
            currency: state.currency,
            groupId: groupId,
            payerId: state.payerId!,
            payeeId: state.payeeId!,
            date: state.date,
          ),
        );
      }
      emit(state.copyWith(status: FormSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  onResetError(
    PaymentResetErrorEvent event,
    Emitter<PaymentState> emit,
  ) {
    // TODO fix setting to null wont work with copyWith
    emit(state.copyWith(
      errorMessage: null,
      status: FormSubmissionStatus.initial,
    ));
  }
}
