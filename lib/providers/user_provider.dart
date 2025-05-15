import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';

final userProvider =
    AutoDisposeAsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);

class UserNotifier extends AutoDisposeAsyncNotifier<User> {
  @override
  Future<User> build() async {
    final user = await ref.read(supabaseProvider).getUser();
    return user;
  }

  Future<void> updateUser(User user) async {
    final u = await ref.read(supabaseProvider).updateUser(user);
    state = AsyncValue.data(u);
  }

  Future<void> updateUserEmail(String email) async {
    await ref.read(authProvider.notifier).updateUserEmail(email);
    final u = await ref
        .read(supabaseProvider)
        .updateUser(state.value!.copyWith(email: email));

    state = AsyncValue.data(u);
  }
}
