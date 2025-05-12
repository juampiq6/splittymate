import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/dto/group_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';

final userProvider =
    AsyncNotifierProvider<UserNotifier, UserState>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<UserState> {
  @override
  Future<UserState> build() async {
    final user = await ref.read(supabaseProvider).getUser();
    final groups = await _fetchGroups();
    return UserState(
      user: user,
      groups: groups,
    );
  }

  Future<void> updateUser(User user) async {
    final u = await ref.read(supabaseProvider).updateUser(user);

    state = AsyncValue.data(
      UserState(
        user: u,
        groups: state.value!.groups,
      ),
    );
  }

  Future<void> updateUserEmail(String email) async {
    await ref.read(authProvider.notifier).updateUserEmail(email);
    final u = await ref
        .read(supabaseProvider)
        .updateUser(state.value!.user.copyWith(email: email));

    state = AsyncValue.data(
      UserState(
        user: u,
        groups: state.value!.groups,
      ),
    );
  }

  Future<List<SplitGroup>> _fetchGroups() {
    return ref.read(supabaseProvider).getUserSplitGroups();
  }

  Future<void> createGroup(GroupCreationDTO group) async {
    final g = await ref.read(supabaseProvider).createSplitGroup(group);
    state = AsyncValue.data(
      UserState(
        user: state.value!.user,
        groups: [...state.value!.groups, g],
      ),
    );
  }

  Future<void> updateGroup(SplitGroup group) async {
    final groups = state.value!.groups;
    final index = groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      final g = await ref.read(supabaseProvider).updateSplitGroup(group);
      groups[index] = g;
    } else {
      // TODO throw an error if the group is not found (rare case)
    }
  }

  Future<void> addMemberToGroup(String groupId) async {
    // THERE SHOULD BE A MORE SECURE BACKEND CHECK IN THE FUTURE, MAYBE A SUPABASE FUNCTION
    // WHERE TO CHECK IF THE CREATE JWT IS VALID AND ADD THE MEMBER TO THE GROUP FROM THERE
    await ref.read(supabaseProvider).addMemberToGroup(
          groupId,
          state.value!.user.id,
        );
    final groups = await _fetchGroups();
    state.value!.groups.addAll(groups);
  }

  // TODO check when is this going to be used
  Future<void> deleteSplitGroup(String groupId) async {
    await ref.read(supabaseProvider).deleteSplitGroup(groupId);
    final groups = state.value!.groups;
    groups.removeWhere((g) => g.id == groupId);
  }
}

class UserState {
  final User user;
  final List<SplitGroup> groups;

  UserState({
    required this.user,
    required this.groups,
  });
}
