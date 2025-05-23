import 'package:splittymate/models/dto/group_creation_dto.dart';
import 'package:splittymate/models/dto/transaction_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/transactions/exports.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/models/dto/user_creation_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

abstract class SupabaseServiceInterface {}

class SupabaseService {
  final supa.SupabaseClient supabase;
  SupabaseService({required this.supabase});

  // User methods
  Future<User> getUser() async {
    final res = await supabase
        .from('user')
        .select()
        .eq('auth_id', supabase.auth.currentUser!.id)
        .single();
    return User.fromJson(res);
  }

  // CHECK RESPONSE
  Future<bool> userExists() async {
    try {
      await supabase
          .from('user')
          .select()
          .eq('auth_id', supabase.auth.currentUser!.id)
          .maybeSingle();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User> createUser(UserCreationDTO dto) async {
    final res =
        await supabase.from('user').insert(dto.toJson()).select().single();
    return User.fromJson(res);
  }

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
  Future<List<SplitGroup>> getUserSplitGroups() async {
    final res = await supabase.from('split_group').select(
          '*, members:member(user(*)), expenses:expense(*), payments:payment(*)',
        );
    return res.map((e) => SplitGroup.fromJson(e)).toList();
  }

  // TODO improve this query as expenses and payments are not needed
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

  Future<void> addMemberToGroup(String groupId, String userId) async {
    await supabase.from('member').insert(
      {
        'split_group_id': groupId,
        'user_id': userId,
      },
    );
  }

  Future<void> removeUserFromGroup(String groupId) async {
    await supabase.from('member').delete().eq('split_group_id', groupId);
  }

  Future<void> deleteSplitGroup(String groupId) async {
    final res = await supabase.from('split_group').delete().eq('id', groupId);
    // TODO check this response
    print(res);
  }

  // Transaction methods
  Future<Transaction> createTransaction(
      TransactionCreationDTO transaction) async {
    print(transaction.toJson());
    final res = await supabase
        .from(
            transaction.type == TransactionType.payment ? 'payment' : 'expense')
        .insert(transaction.toJson())
        .select()
        .single();
    print(res);
    return Transaction.fromJson(res);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    final res = await supabase
        .from(transaction is Payment ? 'payment' : 'expense')
        .update(transaction.toJson())
        .eq('id', transaction.id)
        .select()
        .single();
    // TODO check this response
    print(res);
    return Transaction.fromJson(res);
  }

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
