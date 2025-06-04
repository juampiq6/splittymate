import 'dart:developer';

import 'package:splittymate/services/interfaces/export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunctionService implements FaaServiceInterface {
  final SupabaseClient _supabase;
  SupabaseFunctionService({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<Map<String, dynamic>> callFunction(
    String functionName,
    Map<String, dynamic> payload,
  ) async {
    final res = await _supabase.functions.invoke(functionName, body: payload);
    if (res.status != 200 && res.status != 201) {
      log('Error: ${res.status} ${res.data['error']}');
      throw FunctionCallError(res.data['error']);
    } else {
      return Map<String, dynamic>.from(res.data);
    }
  }
}
