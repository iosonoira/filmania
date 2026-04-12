import 'package:envied/envied.dart';

part 'env.g.dart';

/// Obfuscated environment variables for Filmania.
///
/// Values are read from `.env` at code-generation time by `envied_generator`
/// and stored in the binary in XOR-obfuscated form.
///
/// Run `dart run build_runner build --delete-conflicting-outputs`
/// after changing `.env` to regenerate `env.g.dart`.
@Envied(path: '.env')
abstract class Env {
  /// TMDB API Bearer token.
  @EnviedField(varName: 'TMDB_API_KEY', obfuscate: true)
  static final String tmdbApiKey = _Env.tmdbApiKey;

  /// Supabase project URL.
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;

  /// Supabase anonymous key.
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _Env.supabaseAnonKey;
}
