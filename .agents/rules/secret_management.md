---
trigger: always_on
---

# Rule: Secrets Management (envied) — Filmania

> **Agent Mandate**: Senior Flutter Architect. Secrets = most critical attack surface. API keys, tokens, credentials must never appear in source, binary, or version control. Enforce `envied` as sole secrets mechanism. Zero tolerance for `String.fromEnvironment`, hardcoded credentials, or committed `.env` files.

---

## Context

Filmania uses two external services:
1. **TMDB API** — Bearer token (`TMDB_API_KEY`)
2. **Supabase** — project URL (`SUPABASE_URL`) + anon key (`SUPABASE_ANON_KEY`)

`envied` reads `.env` at **code-generation time**, XOR-obfuscates values in generated Dart — extraction requires reverse engineering, not just string scan.

---

## Package Information

| Package | Role | Location |
|---|---|---|
| `envied` | Runtime annotations + obfuscation | `dependencies` |
| `envied_generator` | Code generation | `dev_dependencies` |
| `build_runner` | Runs generator | `dev_dependencies` (already present) |

---

## Mandatory Guidelines

### 1. Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  envied: ^0.5.4          # check pub.dev for the latest stable version
  # ... other dependencies

dev_dependencies:
  envied_generator: ^0.5.4  # must match envied version major.minor
  build_runner: ^2.4.15      # already present
  # ... other dev_dependencies
```

Run:
```bash
flutter pub get
```

---

### 2. `.env` File — Source of Truth for Secrets

Create `.env` in **project root** (same level as `pubspec.yaml`):

```dotenv
# .env — NEVER commit this file to version control
TMDB_API_KEY=your_tmdb_bearer_token_here
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

Add `.env` to `.gitignore`:

```gitignore
# Secrets — never commit
.env
.env.*
!.env.example
```

Create `.env.example` (commit this — key names only, no values):

```dotenv
# .env.example — commit this file; it documents required secrets
# Copy to .env and fill in real values locally and in CI/CD
TMDB_API_KEY=
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

> `.env` never committed. `.env.example` always committed. Devs copy `.env.example` → `.env`, fill real values from secrets vault.

---

### 3. Env Class Definition

Create `lib/core/env/env.dart`:

```dart
import 'package:envied/envied.dart';

part 'env.g.dart';

/// Obfuscated environment variables for Filmania.
///
/// Values are read from the `.env` file at code-generation time by `envied_generator`
/// and stored in the binary in an obfuscated form. They are never plain strings.
///
/// Run `dart run build_runner build` after changing `.env` to regenerate `env.g.dart`.
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// TMDB API Bearer token.
  /// Used by [TmdbAuthInterceptor] to authenticate every request.
  @EnviedField(varName: 'TMDB_API_KEY', obfuscate: true)
  static final String tmdbApiKey = _Env.tmdbApiKey;

  /// Supabase project URL.
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;

  /// Supabase anonymous key.
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _Env.supabaseAnonKey;
}
```

| Parameter | Value | Reason |
|---|---|---|
| `path` | `'.env'` | Path to `.env`, relative to project root |
| `obfuscate` (on `@Envied`) | `true` | XOR obfuscation for all fields |
| `obfuscate` (on `@EnviedField`) | `true` | Explicit per-field (belt-and-suspenders) |
| `varName` | e.g. `'TMDB_API_KEY'` | Maps to exact key in `.env` |

> `obfuscate: true` XOR-encodes value with random key at generation time. Without it, plain string is extractable with `strings`.

---

### 4. Code Generation

After creating `env.dart` and `.env`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Produces `lib/core/env/env.g.dart` with obfuscated `_Env` class.

> `env.g.dart` **must** be committed — not reproducible without `.env` secrets, so CI/CD can build without exposing secrets.
>
> Add to `.gitignore`:
> ```gitignore
> # Generated files — ignore all .g.dart EXCEPT env.g.dart
> *.g.dart
> !lib/core/env/env.g.dart
> ```
>
> **Alternative (CI)**: gitignore `env.g.dart`, regenerate in pipeline. Pick one — don't mix.

---

### 5. Integration — Replace All Existing Secret References

#### 5a. `main.dart` — Supabase Initialization

```dart
// ❌ BEFORE — plain strings / String.fromEnvironment
await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
);

// ✅ AFTER — obfuscated via envied
import 'package:filmania/core/env/env.dart';

await Supabase.initialize(
  url: Env.supabaseUrl,
  anonKey: Env.supabaseAnonKey,
);
```

#### 5b. `tmdb_auth_interceptor.dart` — TMDB Bearer Token

```dart
// ❌ BEFORE — secret read inline on every request
@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  const token = String.fromEnvironment('TMDB_API_KEY');
  if (token.isNotEmpty) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  handler.next(options);
}

// ✅ AFTER — token injected via constructor, sourced from Env
class TmdbAuthInterceptor extends Interceptor {
  const TmdbAuthInterceptor({required this.apiToken});
  final String apiToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $apiToken';
    }
    handler.next(options);
  }
}
```

```dart
// ✅ In tmdb_client.dart — pass the obfuscated value at construction time
@Riverpod(keepAlive: true)
Dio tmdbClient(Ref ref) {
  final dio = Dio(BaseOptions(/* ... */));

  dio.interceptors.addAll([
    TmdbAuthInterceptor(apiToken: Env.tmdbApiKey), // ← from envied
    if (kDebugMode) LogInterceptor(/* ... */),
    RetryInterceptor(/* ... */),
  ]);

  return dio;
}
```

---

### 6. Build Flavors (dev / staging / prod)

Separate `.env` per flavor:

```
.env.dev       ← development keys (TMDB sandbox, Supabase dev project)
.env.staging   ← staging keys
.env.prod      ← production keys (highest privilege — tightest access control)
```

One `Env` class per flavor:

```dart
// lib/core/env/env_dev.dart
@Envied(path: '.env.dev', obfuscate: true)
abstract class EnvDev { /* same fields */ }

// lib/core/env/env_prod.dart
@Envied(path: '.env.prod', obfuscate: true)
abstract class EnvProd { /* same fields */ }
```

```dart
// lib/core/env/env.dart — flavor selector
import 'env_dev.dart' if (dart.library.io) 'env_dev.dart';

// In practice, use --dart-define=FLAVOR=prod at build time
// and a conditional import or abstract interface to switch.
```

> At Filmania's current stage, single `.env` with README note on dev/prod keys is sufficient. Add multi-flavor when dedicated staging environment exists.

---

### 7. CI/CD Integration

```yaml
# .github/workflows/build.yml
- name: Create .env from secrets
  run: |
    echo "TMDB_API_KEY=${{ secrets.TMDB_API_KEY }}" >> .env
    echo "SUPABASE_URL=${{ secrets.SUPABASE_URL }}" >> .env
    echo "SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}" >> .env

- name: Generate env.g.dart
  run: dart run build_runner build --delete-conflicting-outputs

- name: Build
  run: flutter build apk --release
```

Store secrets in GitHub → Settings → Secrets and variables → Actions (encrypted).

> CI/CD secrets set once by project owner. Never appear in logs, workflow files, or PR diffs. `.env` created ephemerally in runner, destroyed when job ends.

---

### 8. Prohibited Patterns

Forbidden in any file under `lib/`:

```dart
// ❌ Plain string literals for credentials
const supabaseUrl = 'https://abcdefgh.supabase.co';
const tmdbKey = 'eyJhbGciOiJIUzI1NiJ9...';

// ❌ String.fromEnvironment — embeds plain value in binary
const token = String.fromEnvironment('TMDB_API_KEY');

// ❌ Reading from a .env file at runtime (not supported by envied's model)
// and exposes the .env file to the device filesystem
final env = DotEnv()..load();
final key = env['TMDB_API_KEY'];

// ❌ Hardcoded fallback values
final key = Env.tmdbApiKey.isEmpty ? 'hardcoded-fallback' : Env.tmdbApiKey;
```

---

### 9. File Structure Summary

```
filmania/
├── .env                          # ← NEVER commit (gitignored)
├── .env.example                  # ← ALWAYS commit (no values)
├── .gitignore                    # contains .env rule
├── lib/
│   └── core/
│       └── env/
│           ├── env.dart          # ← @Envied class definition (commit)
│           └── env.g.dart        # ← generated obfuscated values (commit*)
└── pubspec.yaml                  # envied + envied_generator declared
```

`*` See §4 for commit decision on `env.g.dart`.

---

## Do / Don't Reference Table

| ✅ Do | ❌ Don't |
|---|---|
| Use `@Envied(obfuscate: true)` for all secrets | Use `String.fromEnvironment` for credentials |
| Store secrets in `.env` (gitignored) | Commit `.env` to version control |
| Commit `.env.example` with empty values | Leave `.env.example` outdated or missing |
| Inject secrets at construction time (e.g., `TmdbAuthInterceptor(apiToken: Env.tmdbApiKey)`) | Read `Env.*` inline inside `onRequest` or `build()` |
| Regenerate `env.g.dart` after every `.env` change | Forget to re-run `build_runner` after changing secrets |
| Store CI secrets in GitHub Secrets (encrypted) | Hardcode secrets in GitHub Actions workflow YAML |
| Use `obfuscate: true` on every `@EnviedField` | Leave fields without obfuscation |
| Keep `.env` out of crash reports and logs | Log or print any `Env.*` value |
| Document the `.env.example` keys in `README.md` | Leave new developers without setup instructions |
| Create one `Env` class per flavor for multi-env setups | Reuse prod keys in development |