import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvVars {
  static final supabaseUrl = dotenv.get('SUPABASE_URL');
  static final supabaseAnonKey = dotenv.get('SUPABASE_ANON_KEY');
  static final deepLinkBase = dotenv.get('DEEP_LINK_BASE');
  static final invitationLinkSecret = dotenv.get('JWT_SECRET');
}
