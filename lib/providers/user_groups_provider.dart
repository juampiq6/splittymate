import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/dto/group_creation_dto.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';

final userSplitGroupsProvider =
    AutoDisposeAsyncNotifierProvider<UserGroupsProvider, List<SplitGroup>>(
        UserGroupsProvider.new);

class UserGroupsProvider extends AutoDisposeAsyncNotifier<List<SplitGroup>> {
  @override
  Future<List<SplitGroup>> build() async {
    return await ref.read(repositoryServiceProvider).getUserSplitGroups();
  }

  Future<void> createGroup(GroupCreationDTO group) async {
    final g = await ref.read(repositoryServiceProvider).createSplitGroup(group);
    state = AsyncValue.data([...state.value!, g]);
  }
}
