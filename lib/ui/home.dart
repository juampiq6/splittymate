import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/ui/split_group/split_group_list.dart';
import 'package:splittymate/ui/themes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String? groupIdRedirection;
  const HomeScreen({super.key, this.groupIdRedirection});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.groupIdRedirection != null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Invitation accepted'),
                content: const Text('You have been added to a group'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.go('/split_group/${widget.groupIdRedirection}');
                    },
                    child: const Text('Go to group'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = ref.watch(userProvider);

    if (userProv.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (userProv.hasError) {
      return Scaffold(
        body: Center(
          child: Text(userProv.error.toString()),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitMate'),
        leading: Consumer(
          builder: (context, ref, child) {
            final userName = userProv.value!.user.name;
            return IconButton(
              icon: CircleAvatar(
                child: Text(userName[0]),
              ),
              onPressed: () async {
                context.go('/profile_settings');
              },
            );
          },
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () async {
                  try {
                    await ref.read(supabaseAuthProvider).signOut();
                    if (context.mounted) context.go('/login');
                    ref.invalidate(userProvider);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error signing out'),
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/split_group/new');
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text('Groups', style: context.tt.titleLarge),
          ),
          Divider(
            color: context.tt.titleSmall!.color,
            thickness: 0.5,
            endIndent: 10,
            indent: 10,
          ),
          Expanded(
            child: SplitGroupsList(
              groupIdRedirection: widget.groupIdRedirection,
            ),
          ),
        ],
      ),
    );
  }
}
