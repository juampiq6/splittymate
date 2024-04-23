import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/user_provider.dart';

final splitGroupProvider =
    NotifierProviderFamily<SplitGroupNotifier, SplitGroup, String>(
  SplitGroupNotifier.new,
);

class SplitGroupNotifier extends FamilyNotifier<SplitGroup, String> {
  @override
  SplitGroup build(String arg) {
    return ref.read(userProvider).value!.groups.firstWhere((g) => g.id == arg);
  }

  // Future<void> createGroup(GroupCreationDTO group) async {
  //   final g = await ref.read(supabaseProvider).createSplitGroup(group);
  //   state = AsyncValue.data([...state.value!, g]);
  // }

  // Future<void> updateGroup(SplitGroup group) async {
  //   final groups = state.value!;
  //   final index = groups.indexWhere((g) => g.id == group.id);
  //   if (index != -1) {
  //     final g = await ref.read(supabaseProvider).updateSplitGroup(group);
  //     groups[index] = g;
  //     state = AsyncValue.data(groups);
  //   } else {
  //     // TODO handle this case
  //   }
  // }

  // // TODO check when is this going to be used
  // Future<void> deleteSplitGroup(String groupId) async {
  //   await ref.read(supabaseProvider).deleteSplitGroup(groupId);
  //   final groups = state.value!;
  //   groups.removeWhere((g) => g.id == groupId);
  //   state = AsyncValue.data(groups);
  // }

  Future<void> addMemberToGroup(String groupId, String email) async {
    // TODO fix this with email
    // TODO check how can a user without registering can be added to a group
  }

  Future<void> removeUserFromGroup(String userId) async {
    // TODO remove from supabase
    state.members.removeWhere((e) => e.id == userId);
  }
}
