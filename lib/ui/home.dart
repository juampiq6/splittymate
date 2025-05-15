import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/split_group/settings/invitation/accept_group_invite.dart';
import 'package:splittymate/ui/split_group/split_group_list.dart';
import 'package:splittymate/ui/themes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String? groupInvitation;

  const HomeScreen({super.key, this.groupInvitation});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleInvitationDialog();
    });
    super.initState();
  }

  handleInvitationDialog() async {
    final invitation = ref.read(groupInvitationProvider.notifier).state;
    if (invitation != null) {
      late final Map<String, dynamic> payload;
      try {
        payload = ref.read(invitationServiceProv).verifyJWTToken(invitation);
        final groupId = await showDialog(
          context: context,
          builder: (context) {
            return AcceptGroupInviteDialog(
              payload: payload,
            );
          },
        );
        if (groupId != null) {
          // animate the group tile
        }
      } catch (e) {
        ref.invalidate(groupInvitationProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      }
    }
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
        title: const Text('SplittyMate'),
        leading: Consumer(
          builder: (context, ref, child) {
            final userName = userProv.value!.name;
            return IconButton(
              icon: CircleAvatar(
                child: Text(userName[0]),
              ),
              onPressed: () async {
                context.go(AppRoute.profileSettings.path());
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
                    await ref.read(authProvider.notifier).signOut();
                    if (context.mounted) context.go(AppRoute.login.path());
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
          context.go(AppRoute.newSplitGroup.path());
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
              groupIdAnimateIn: widget.groupInvitation,
            ),
          ),
        ],
      ),
    );
  }
}
