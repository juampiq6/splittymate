import 'package:splittymate/models/dto/export.dart';
import 'package:splittymate/models/export.dart';

abstract interface class RepositoryServiceInterface {
  // User methods
  Future<User?> maybeGetUser();
  Future<User> createUser(UserCreationDTO dto);
  Future<User> updateUser(User user);

  // SplitGroup methods
  Future<List<SplitGroup>> getUserSplitGroups();
  Future<SplitGroup> createSplitGroup(GroupCreationDTO group);
  Future<SplitGroup> updateSplitGroup(SplitGroup group);
  Future<void> addMemberToGroup(String groupId, String userId);
  Future<void> removeUserFromGroup(String groupId);
  Future<void> deleteSplitGroup(String groupId);

  // Transaction methods
  Future<Transaction> createTransaction(TransactionCreationDTO txDTO);
  Future<Transaction> updateTransaction(
      TransactionCreationDTO txDTO, String txId);
  Future<dynamic> removeTransaction(Transaction transaction);
}
