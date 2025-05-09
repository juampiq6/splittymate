import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> checkUserStatusAndRedirect() async {
    final prov = ref.read(supabaseAuthProvider);

    if (prov.isLogged) {
      // TODO add check to redirect user to finish sign up
      if (!prov.isAuthenticated) {
        try {
          await prov.renewSession();
        } catch (e) {
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) context.go(AppRoute.login.path());
          return;
        }
      }
      if (mounted) context.go(AppRoute.home.path());
    } else {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) context.go(AppRoute.login.path());
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
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
