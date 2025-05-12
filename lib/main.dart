import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/routes/router.dart';
import 'package:splittymate/env_vars.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: EnvVars.supabaseUrl,
    anonKey: EnvVars.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
    debug: true,
  );

  runApp(const ProviderScope(child: SplittymateApp()));
}

class SplittymateApp extends ConsumerWidget {
  const SplittymateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Splittymate',
      theme: brightTheme,
      routerConfig: router,
    );
  }
}
