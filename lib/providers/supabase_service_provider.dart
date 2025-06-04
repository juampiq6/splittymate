import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/services/interfaces/export.dart';

import 'package:splittymate/services/supabase_auth_service.dart';
import 'package:splittymate/services/supabase_functions_service.dart';
import 'package:splittymate/services/supabase_repository_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

final authServiceProvider = Provider<AuthServiceInterface>(
    (ref) => SupabaseAuthService(auth: _supabase.auth));

final repositoryServiceProvider = Provider<RepositoryServiceInterface>(
    (ref) => SupabaseRepositoryService(supabase: _supabase));

final functionServiceProvider = Provider<FaaServiceInterface>(
    (ref) => SupabaseFunctionService(supabase: _supabase));
