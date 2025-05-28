import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/dto/transaction_creation_dto.dart';
import 'package:splittymate/models/transactions/exports.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';

final transactionProvider = NotifierProvider.family
    .autoDispose<TransactionNotifier, List<Transaction>, String>(
  TransactionNotifier.new,
);

class TransactionNotifier
    extends AutoDisposeFamilyNotifier<List<Transaction>, String> {
  @override
  List<Transaction> build(String arg) {
    final group = ref.watch(splitGroupProvider(arg));
    return group.transactions..sort();
  }

  // List<Transaction> transactionsByCurrency(Currency currency) =>
  //     state.where((tx) => tx.currency == currency.code).toList();

  Future<void> createTransaction(TransactionCreationDTO dto) async {
    final tx =
        await ref.read(supabaseRepositoryProvider).createTransaction(dto);
    state = [...state, tx]..sort();
    ref.read(splitGroupProvider(arg).notifier).updateTxs(state);
  }

  Future<void> updateTransaction(
      TransactionCreationDTO transaction, String txId) async {
    final tx = await ref
        .read(supabaseRepositoryProvider)
        .updateTransaction(transaction, txId);
    final index = state.indexWhere((t) => t.id == tx.id);
    if (index == -1) {
      // in case there is no transaction with this id, we invalidate the provider
      // to refresh the list. this case should never happen.
      log('No transaction with id $txId found');
      ref.invalidateSelf();
      return;
    }
    state[index] = tx;
    state.sort();
    state = state.toList();
    ref.read(splitGroupProvider(arg).notifier).updateTxs(state);
  }

  Future<void> removeTransaction(Transaction transaction) async {
    await ref.read(supabaseRepositoryProvider).removeTransaction(transaction);
    state.remove(transaction);
    ref.read(splitGroupProvider(arg).notifier).updateTxs(state);
  }
}
