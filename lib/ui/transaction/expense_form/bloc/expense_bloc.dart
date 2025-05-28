// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:splittymate/models/dto/export.dart';
import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseFormBloc<T extends ExpenseState> extends Bloc<ExpenseEvent, T> {
  final String groupId;
  final TransactionNotifier txNotifier;
  final List<User> members;

  ExpenseFormBloc({
    required this.groupId,
    required this.txNotifier,
    required this.members,
    required T initialState,
  }) : super(initialState) {
    on<ExpenseDateChangedEvent>(onDateChanged);
    on<ExpensePayerAmountChangedEvent>(onPayedAmountChanged);
    on<ExpenseParticipantAmountChangedEvent>(onSharedAmountChanged);
    on<ExpensePayerToggledEvent>(onPayerToggled);
    on<ExpenseParticipantToggledEvent>(onParticipantToggled);
    on<ExpenseNameChangedEvent>(onNameChanged);
    on<ExpenseSubmitEvent>(onSubmit);
    on<ExpenseResetErrorEvent>(onResetError);
    on<ExpenseCurrencyChangedEvent>(onCurrencyChanged);
    on<ExpenseTypeChangedToggledEvent>(onTypeToggled);
  }

  onNameChanged(
    ExpenseNameChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  onDateChanged(
    ExpenseDateChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  onPayedAmountChanged(
    ExpensePayerAmountChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    final payShares = Map<String, double>.from(state.payShares);
    payShares[event.userId] = event.amount;
    emit(state.copyWith(payShares: payShares));
  }

  onSharedAmountChanged(
    ExpenseParticipantAmountChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    final participantShares = Map<String, double>.from(state.participantShares);
    participantShares[event.userId] = event.amount;
    emit(state.copyWith(participantShares: participantShares));
  }

  onPayerToggled(
    ExpensePayerToggledEvent event,
    Emitter<ExpenseState> emit,
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
    ExpenseParticipantToggledEvent event,
    Emitter<ExpenseState> emit,
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
    ExpenseCurrencyChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(currency: event.currency));
  }

  onTypeToggled(
    ExpenseTypeChangedToggledEvent event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(isEquallyShared: !state.isEquallyShared));
  }

  onSubmit(
    ExpenseSubmitEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: FormSubmissionStatus.submitting));
    try {
      late final TransactionCreationDTO dto;
      if (state.isEquallyShared) {
        dto = EqualShareExpenseCreationDTO(
          title: state.name,
          currency: state.currency,
          groupId: groupId,
          payersAmount: state.payShares,
          date: state.date,
          participantsIds: state.participants.map((e) => e.id).toList(),
        );
      } else {
        dto = UnequalShareExpenseCreationDTO(
          title: state.name,
          currency: state.currency,
          groupId: groupId,
          payersAmount: state.payShares,
          date: state.date,
          shares: state.participantShares,
        );
      }
      if (event is ExpenseSubmitCreationEvent) {
        await txNotifier.createTransaction(dto);
      } else if (event is ExpenseSubmitEditionEvent) {
        await txNotifier.updateTransaction(dto, event.txId);
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
    ExpenseResetErrorEvent event,
    Emitter<ExpenseState> emit,
  ) {
    emit(
      state.copyWith(
        status: FormSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }
}
