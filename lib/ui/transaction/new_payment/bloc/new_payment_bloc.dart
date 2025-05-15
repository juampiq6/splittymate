import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:splittymate/models/dto/export.dart';

import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';

part 'new_payment_event.dart';
part 'new_payment_state.dart';

class NewPaymentBloc extends Bloc<NewPaymentEvent, NewPaymentState> {
  final String groupId;
  final List<User> members;
  final TransactionNotifier txNotifier;
  NewPaymentBloc({
    required this.members,
    required String currency,
    required this.txNotifier,
    required this.groupId,
  }) : super(NewPaymentState(
          members: members,
          currency: currency,
        )) {
    on<NewPaymentCurrencyChangedEvent>(onCurrencyChanged);
    on<NewPaymentAmountChangedEvent>(onAmountChanged);
    on<NewPaymentPayerToggledEvent>(onPayerToggled);
    on<NewPaymentPayeeToggledEvent>(onPayeeToggled);
    on<NewPaymentSubmitEvent>(onSubmit);
    on<NewPaymentResetErrorEvent>(onResetError);
  }

  onCurrencyChanged(
    NewPaymentCurrencyChangedEvent event,
    Emitter<NewPaymentState> emit,
  ) {
    emit(state.copyWith(currency: event.currency));
  }

  onAmountChanged(
    NewPaymentAmountChangedEvent event,
    Emitter<NewPaymentState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  onPayerToggled(
    NewPaymentPayerToggledEvent event,
    Emitter<NewPaymentState> emit,
  ) {
    final payer = state.payerId == event.payerId ? null : event.payerId;
    emit(state.copyWith(payerId: payer));
  }

  onPayeeToggled(
    NewPaymentPayeeToggledEvent event,
    Emitter<NewPaymentState> emit,
  ) {
    final payee = state.payeeId == event.payeeId ? null : event.payeeId;
    emit(state.copyWith(payeeId: payee));
  }

  onSubmit(
    NewPaymentSubmitEvent event,
    Emitter<NewPaymentState> emit,
  ) async {
    emit(state.copyWith(status: FormSubmissionStatus.submitting));
    try {
      await txNotifier.createTransaction(
        PaymentCreationDTO(
          amount: state.amount!,
          currency: state.currency,
          groupId: groupId,
          payerId: groupId,
          payeeId: state.payeeId!,
        ),
      );
      emit(state.copyWith(status: FormSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  onResetError(
    NewPaymentResetErrorEvent event,
    Emitter<NewPaymentState> emit,
  ) {
    emit(state.copyWith(
      errorMessage: null,
      status: FormSubmissionStatus.initial,
    ));
  }
}
