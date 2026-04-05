import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../../../core/supabase/supabase_client.dart';

part 'auth_repository.g.dart';

class AuthRepository implements IAuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  @override
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) return null;

      // response.user is non-null: checked on line above
      final user = response.user!;
      return AuthUser(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String?,
        photoUrl: user.userMetadata?['avatar_url'] as String?,
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials') ||
          e.statusCode == '400' ||
          e.code == 'invalid_credentials' ||
          e.code == 'invalid_grant') {
        throw const InvalidCredentials();
      }
      throw UnknownAuthFailure(e.message);
    } on SocketException {
      throw const NetworkError();
    } catch (e) {
      throw UnknownAuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Stream<AuthUser?> watchAuthState() {
    return _supabase.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return AuthUser(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String?,
        photoUrl: user.userMetadata?['avatar_url'] as String?,
      );
    });
  }
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
}
