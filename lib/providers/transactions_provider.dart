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
    final tx = await ref.read(supabaseProvider).createTransaction(dto);
    state = [...state, tx]..sort();
    ref.read(splitGroupProvider(arg).notifier).updateTxs(state);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final tx = await ref.read(supabaseProvider).updateTransaction(transaction);

    final index = state.indexWhere((t) => t.id == tx.id);
    if (index != -1) {
      state[index] = tx;
    } else {
      // TODO handle this case
    }
    state.sort();
    ref.read(splitGroupProvider(arg).notifier).updateTxs(state);
  }

  Future<void> removeTransaction(Transaction transaction) async {
    await ref.read(supabaseProvider).removeTransaction(transaction);
    state.remove(transaction);
    ref.read(splitGroupProvider(arg).notifier).updateTxs(state);
  }
}
