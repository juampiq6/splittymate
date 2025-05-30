import 'package:device_preview/device_preview.dart';
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

  runApp(
    DevicePreview(
      builder: (context) => const ProviderScope(child: SplittymateApp()),
      enabled: false,
    ),
  );
}

class SplittymateApp extends ConsumerWidget {
  const SplittymateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Splittymate',
      theme: brightTheme,
      routerConfig: router,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
    );
  }
}
