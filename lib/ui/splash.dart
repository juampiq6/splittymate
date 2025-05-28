import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/services/interfaces/auth_service_intervace.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> checkUserStatusAndRedirect() async {
    final status = ref.read(authProvider).status;
    switch (status) {
      case AuthStatus.signedOut:
        if (mounted) context.go(AppRoute.login.path());
        return;
      case AuthStatus.tokenExpired:
        try {
          await ref.read(authProvider.notifier).renewSession();
          await ref.read(userProvider.notifier).build();
          if (mounted) context.go(AppRoute.home.path());
        } catch (e) {
          if (e is UserNotFoundException) {
            // If the user is not found, it means that the user is not signed up yet.
            if (mounted) context.go(AppRoute.finishSignUp.path());
          } else {
            if (mounted) context.go(AppRoute.login.path());
          }
          return;
        }
      case AuthStatus.authenticated:
        try {
          await ref.read(userProvider.notifier).build();
          if (mounted) context.go(AppRoute.home.path());
        } catch (e) {
          if (e is UserNotFoundException) {
            // If the user is not found, it means that the user is not signed up yet.
            if (mounted) context.go(AppRoute.finishSignUp.path());
          }
          return;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkUserStatusAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO make animation or logo
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
