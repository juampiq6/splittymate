import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/transactions/exports.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/providers/user_groups_provider.dart';

final splitGroupProvider =
    AutoDisposeNotifierProviderFamily<SplitGroupNotifier, SplitGroup, String>(
  SplitGroupNotifier.new,
);

class SplitGroupNotifier extends AutoDisposeFamilyNotifier<SplitGroup, String> {
  @override
  SplitGroup build(String arg) {
    return ref
        .watch(userSplitGroupsProvider)
        .value!
        .firstWhere((g) => g.id == arg);
  }

  Future<void> updateGroupCurrency(String currency) async {
    final group = state.copyWith(defaultCurrency: currency);
    await ref.read(supabaseProvider).updateSplitGroup(group);
    state = group;
  }

  Future<void> updateGroupName(String name) async {
    final group = state.copyWith(name: name);
    await ref.read(supabaseProvider).updateSplitGroup(group);
    state = group;
  }

  Future<void> updateGroupDescription(String desc) async {
    final group = state.copyWith(description: desc);
    await ref.read(supabaseProvider).updateSplitGroup(group);
    state = group;
  }

  Future<void> removeUserFromGroup(String groupId) async {
    await ref.read(supabaseProvider).removeUserFromGroup(groupId);
    ref.invalidateSelf();
  }

  Future<void> updateTxs(List<Transaction> txs) async {
    final group = state.copyWith(transactions: txs);
    state = group;
  }
}
