import 'dart:io';
import 'package:flutter/foundation.dart';

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
        username: user.userMetadata?['username'] as String?,
        photoUrl: user.userMetadata?['avatar_url'] as String?,
      );
    } on AuthException catch (e) {
      debugPrint('AuthRepository.signIn Error: ${e.message} (Code: ${e.code})');
      if (e.message.contains('Invalid login credentials') ||
          e.statusCode == '400' ||
          e.code == 'invalid_credentials' ||
          e.code == 'invalid_grant') {
        throw const InvalidCredentials();
      }
      throw UnknownAuthFailure(e.message);
    } on SocketException catch (e) {
      debugPrint('AuthRepository.signIn Network Error: $e');
      throw const NetworkError();
    } catch (e, stack) {
      debugPrint('AuthRepository.signIn Unexpected Error: $e\n$stack');
      throw UnknownAuthFailure(e.toString());
    }
  }

  @override
  Future<AuthUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user == null) return null;

      final user = response.user!;
      return AuthUser(
        id: user.id,
        email: user.email ?? '',
        username: user.userMetadata?['username'] as String?,
        photoUrl: user.userMetadata?['avatar_url'] as String?,
      );
    } on AuthException catch (e) {
      debugPrint('AuthRepository.signUp Error: ${e.message} (Code: ${e.code})');
      if (e.code == 'user_already_exists') {
        throw const EmailAlreadyInUse();
      }
      if (e.code == 'over_email_send_rate_limit') {
        throw const RateLimitExceeded();
      }
      throw UnknownAuthFailure(e.message);
    } on SocketException catch (e) {
      debugPrint('AuthRepository.signUp Network Error: $e');
      throw const NetworkError();
    } catch (e, stack) {
      debugPrint('AuthRepository.signUp Unexpected Error: $e\n$stack');
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
        username: user.userMetadata?['username'] as String?,
        photoUrl: user.userMetadata?['avatar_url'] as String?,
      );
    });
  }
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
}
