import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';

final userProvider =
    AutoDisposeAsyncNotifierProvider<UserNotifier, UserState>(UserNotifier.new);

class UserNotifier extends AutoDisposeAsyncNotifier<UserState> {
  @override
  Future<UserState> build() async {
    final user = await ref.read(supabaseProvider).getUser();
    return UserState(
      user: user,
    );
  }

  Future<void> updateUser(User user) async {
    final u = await ref.read(supabaseProvider).updateUser(user);

    state = AsyncValue.data(
      UserState(
        user: u,
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
      ),
    );
  }
}

class UserState {
  final User user;
  // final List<SplitGroup> groups;

  UserState({
    required this.user,
    // required this.groups,
  });
}
