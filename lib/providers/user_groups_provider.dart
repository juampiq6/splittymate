import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/dto/group_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/providers/user_provider.dart';

final userSplitGroupsProvider =
    AutoDisposeAsyncNotifierProvider<UserGroupsProvider, List<SplitGroup>>(
        UserGroupsProvider.new);

class UserGroupsProvider extends AutoDisposeAsyncNotifier<List<SplitGroup>> {
  @override
  Future<List<SplitGroup>> build() async {
    return await ref.read(supabaseProvider).getUserSplitGroups();
  }

  Future<void> createGroup(GroupCreationDTO group) async {
    final g = await ref.read(supabaseProvider).createSplitGroup(group);
    state = AsyncValue.data([...state.value!, g]);
  }

  // Used with invitation link
  Future<void> addMemberToGroup(String groupId) async {
    // THERE SHOULD BE A MORE SECURE BACKEND CHECK IN THE FUTURE, MAYBE A SUPABASE FUNCTION
    // WHERE TO CHECK IF THE CREATE JWT IS VALID AND ADD THE MEMBER TO THE GROUP FROM THERE
    final userId = ref.read(userProvider).value!.user.id;
    await ref.read(supabaseProvider).addMemberToGroup(
          groupId,
          userId,
        );
    ref.invalidateSelf();
  }
}
