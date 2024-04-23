import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/models/dto/user_creation_dto.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';

final userCreationProvider =
    FutureProvider.family<bool, UserCreationDTO>((ref, dto) async {
  await ref.read(supabaseProvider).createUser(dto);
  return true;
});
