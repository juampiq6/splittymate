// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:splittymate/models/dto/export.dart';
import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';

part 'new_expense_event.dart';
part 'new_expense_state.dart';

class NewExpenseBloc extends Bloc<NewExpenseEvent, NewExpenseState> {
  final String groupId;
  final TransactionNotifier txNotifier;
  final List<User> members;

  NewExpenseBloc({
    required this.groupId,
    required this.txNotifier,
    required this.members,
    required String currency,
  }) : super(NewExpenseState(currency: currency)) {
    on<NewExpenseDateChangedEvent>(onDateChanged);
    on<NewExpensePayerAmountChangedEvent>(onPayedAmountChanged);
    on<NewExpensePayerToggledEvent>(onPayerToggled);
    on<NewExpenseParticipantToggledEvent>(onParticipantToggled);
    on<NewExpenseNameChangedEvent>(onNameChanged);
    on<NewExpenseSubmitEvent>(onSubmit);
    on<NewExpenseResetErrorEvent>(onResetError);
    on<NewExpenseCurrencyChangedEvent>(onCurrencyChanged);
  }

  onNameChanged(
    NewExpenseNameChangedEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  onDateChanged(
    NewExpenseDateChangedEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  onPayedAmountChanged(
    NewExpensePayerAmountChangedEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    final payShares = Map<String, double>.from(state.payShares);
    payShares[event.userId] = event.amount;
    emit(state.copyWith(payShares: payShares));
  }

  onPayerToggled(
    NewExpensePayerToggledEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    final payers = List<User>.from(state.payers);
    final payShares = Map<String, double>.from(state.payShares);
    final user = members.firstWhere((user) => user.id == event.payerId);
    if (payers.contains(user)) {
      payers.remove(user);
      // the pay share is reset to 0
      payShares.remove(event.payerId);
    } else {
      payers.add(user);
    }
    emit(
      state.copyWith(payers: payers, payShares: payShares),
    );
  }

  onParticipantToggled(
    NewExpenseParticipantToggledEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    final participants = List<User>.from(state.participants);
    final user = members.firstWhere((user) => user.id == event.participantId);
    if (participants.contains(user)) {
      participants.remove(user);
    } else {
      participants.add(user);
    }
    emit(state.copyWith(participants: participants));
  }

  onCurrencyChanged(
    NewExpenseCurrencyChangedEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    emit(state.copyWith(currency: event.currency));
  }

  onSubmit(
    NewExpenseSubmitEvent event,
    Emitter<NewExpenseState> emit,
  ) async {
    emit(state.copyWith(status: FormSubmissionStatus.submitting));
    try {
      final dto = EqualShareExpenseCreationDTO(
        title: state.name,
        currency: state.currency,
        groupId: groupId,
        payersAmount: state.payShares,
        date: state.date,
        participantsIds: state.participants.map((e) => e.id).toList(),
      );

      await txNotifier.createTransaction(dto);
      emit(state.copyWith(status: FormSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  onResetError(
    NewExpenseResetErrorEvent event,
    Emitter<NewExpenseState> emit,
  ) {
    emit(
      state.copyWith(
        status: FormSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }
}
