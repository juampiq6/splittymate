import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/services/supabase_auth_service.dart';

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
          if (mounted) context.go(AppRoute.home.path());
        } catch (e) {
          if (mounted) context.go(AppRoute.login.path());
          return;
        }
      case AuthStatus.authenticated:
        if (mounted) context.go(AppRoute.home.path());
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
