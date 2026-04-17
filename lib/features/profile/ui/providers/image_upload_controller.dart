import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:filmania/core/supabase/supabase_client.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/auth/domain/failures/auth_failure.dart';

part 'image_upload_controller.g.dart';

@riverpod
class ImageUploadController extends _$ImageUploadController {
  @override
  FutureOr<void> build() => null;

  Future<void> upload(dynamic xfile) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw const UnknownAuthFailure('Utente non autenticato');
      }

      debugPrint('Step 1: Leggo bytes...');
      final bytes = await xfile.readAsBytes();

      final supabase = ref.read(supabaseClientProvider);

      final nameParts = (xfile.name as String).split('.');
      final ext = nameParts.length > 1 ? nameParts.last : 'jpg';
      final fileName =
          '${user.id}-${DateTime.now().millisecondsSinceEpoch}.$ext';

      debugPrint('Step 2: Upload su bucket avatars...');
      await supabase.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: 'image/$ext', upsert: true),
          );

      final imageUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      debugPrint('Step 3: Update user metadata...');
      await supabase.auth.updateUser(
        UserAttributes(data: {'avatar_url': imageUrl}),
      );

      debugPrint('Step 4: Update tabella user...');
      await supabase
          .from('user')
          .update({'photo_url': imageUrl})
          .eq('id', user.id);
    });
  }
}
