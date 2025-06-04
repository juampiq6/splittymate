import 'package:splittymate/models/dto/group_creation_dto.dart';
import 'package:splittymate/models/dto/transaction_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/transactions/exports.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/models/dto/user_creation_dto.dart';
import 'package:splittymate/services/interfaces/export.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class SupabaseRepositoryService implements RepositoryServiceInterface {
  final supa.SupabaseClient supabase;
  SupabaseRepositoryService({required this.supabase});

  // User methods
  @override
  Future<User?> maybeGetUser() async {
    final res = await supabase
        .from('user')
        .select()
        .eq('auth_id', supabase.auth.currentUser!.id)
        .maybeSingle();
    return res != null ? User.fromJson(res) : null;
  }

  @override
  Future<User> createUser(UserCreationDTO dto) async {
    final res =
        await supabase.from('user').insert(dto.toJson()).select().single();
    return User.fromJson(res);
  }

  @override
  Future<User> updateUser(User user) async {
    final res = await supabase
        .from('user')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    // TODO check this response
    print(res);
    return User.fromJson(res);
  }

  // SplitGroup methods
  // TODO optimize this query in supabase end because is bring all the data and then filtering
  @override
  Future<List<SplitGroup>> getUserSplitGroups() async {
    final res = await supabase.from('split_group').select(
          '*, members:member(user(*)), expenses:expense(*), payments:payment(*)',
        );
    return res.map((e) => SplitGroup.fromJson(e)).toList();
  }

  // TODO improve this query as expenses and payments are not needed
  @override
  Future<SplitGroup> createSplitGroup(GroupCreationDTO group) async {
    final g = await supabase
        .from('split_group')
        .insert(group.toJson())
        .select(
          '*, members:member(user(*)), expenses:expense(*), payments:payment(*)',
        )
        .single();

    return SplitGroup.fromJson(g);
  }

  @override
  Future<SplitGroup> fetchSplitGroup(String groupId) async {
    final g =
        await supabase.from('split_group').select().eq('id', groupId).single();
    return SplitGroup.fromJson(g);
  }

  @override
  Future<SplitGroup> updateSplitGroup(SplitGroup group) async {
    final res = await supabase
        .from('split_group')
        .update(group.toJson())
        .eq('id', group.id)
        .select(
            '*, members:member(user(*)), expenses:expense(*), payments:payment(*)')
        .single();
    return SplitGroup.fromJson(res);
  }

  @override
  Future<void> addMemberToGroup(String groupId, String userId) async {
    await supabase.from('member').insert(
      {
        'split_group_id': groupId,
        'user_id': userId,
      },
    );
  }

  @override
  Future<void> removeUserFromGroup(String groupId) async {
    await supabase.from('member').delete().eq('split_group_id', groupId);
  }

  @override
  Future<void> deleteSplitGroup(String groupId) async {
    final res = await supabase.from('split_group').delete().eq('id', groupId);
    // TODO check this response
    print(res);
  }

  // Transaction methods
  @override
  Future<Transaction> createTransaction(TransactionCreationDTO txDTO) async {
    final res = await supabase
        .from(txDTO.type == TransactionType.payment ? 'payment' : 'expense')
        .insert(txDTO.toJson())
        .select()
        .single();
    return Transaction.fromJson(res);
  }

  @override
  Future<Transaction> updateTransaction(
      TransactionCreationDTO txDTO, String txId) async {
    final res = await supabase
        .from(txDTO.type == TransactionType.payment ? 'payment' : 'expense')
        .update(txDTO.toJson())
        .eq('id', txId)
        .select()
        .single();
    return Transaction.fromJson(res);
  }

  @override
  Future<dynamic> removeTransaction(Transaction transaction) async {
    final res = await supabase
        .from(transaction is Payment ? 'payment' : 'expense')
        .delete()
        .eq('id', transaction.id);
    // TODO check this response
    print(res);
    return res;
  }
}
