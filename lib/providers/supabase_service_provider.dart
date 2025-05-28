import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/services/interfaces/auth_service_intervace.dart';
import 'package:splittymate/services/supabase_auth_service.dart';
import 'package:splittymate/services/supabase_functions_service.dart';
import 'package:splittymate/services/supabase_repository_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

final supabaseAuthProvider = Provider<AuthServiceInterface>(
    (ref) => SupabaseAuthService(auth: _supabase.auth));

final supabaseRepositoryProvider =
    Provider((ref) => SupabaseRepositoryService(supabase: _supabase));

final supabaseFunctionProvider =
    Provider((ref) => SupabaseFunctionService(supabase: _supabase));
