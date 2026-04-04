# Rule: Networking — Violet Tracker

> **Agent Mandate**: You are a Senior Flutter Architect. The network layer is where reliability
> is won or lost. You enforce singleton Dio instances, typed interceptors, exhaustive error
> mapping, and Supabase best practices. Unhandled network states do not ship.

---

## Context

Violet Tracker communicates with two external systems:

1. **TMDB API** — accessed via `Dio`, a feature-rich HTTP client. A singleton `Dio` instance
   configured with interceptors handles authentication, logging, and error normalisation.
2. **Supabase** — used for user authentication, Row-Level Security (RLS)-governed database
   access, and Realtime streams.

All network errors are mapped to domain-level `Failure` types before reaching the UI. The UI
never inspects raw `DioException` or Supabase error codes.

---

## Mandatory Guidelines

### 1. Dio — Singleton Instance

- There is **exactly one** `Dio` instance in the application, provided via Riverpod:

```dart
// ✅ core/network/dio_provider.dart
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    ref.read(authInterceptorProvider),
    ref.read(loggingInterceptorProvider),
    ref.read(retryInterceptorProvider),
  ]);

  return dio;
}
```

- `keepAlive: true` ensures the instance is never disposed while the app is running.
- **Never** instantiate `Dio()` inside a datasource, widget, or repository.

### 2. Interceptors

Three interceptors are mandatory; they must be added **in order**:

#### 2a. Auth Interceptor (TMDB)
Appends the TMDB Bearer token to every request. The token is read from secure storage, never
hard-coded.

```dart
class AuthInterceptor extends Interceptor {
  const AuthInterceptor({required String apiToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $apiToken';
    handler.next(options);
  }
}
```

#### 2b. Logging Interceptor
- Uses `pretty_dio_logger` in **debug mode only**.
- Never logs in `kReleaseMode` — prevents sensitive data leakage.

```dart
if (kDebugMode) dio.interceptors.add(PrettyDioLogger(requestBody: true));
```

#### 2c. Retry Interceptor
- Automatically retries idempotent requests (`GET`) up to **3 times** on network errors
  (`SocketException`, timeout) with exponential back-off.
- **Never** retries `POST`/`PUT`/`DELETE` automatically (risk of duplicate mutations).

### 3. Error Mapping

All `DioException` types **must** be mapped to a sealed `NetworkFailure` type in the datasource
layer before propagating up:

```dart
// ✅ core/network/network_failure.dart
sealed class NetworkFailure {
  const NetworkFailure();
}
class ServerFailure     extends NetworkFailure { final int statusCode; const ServerFailure(this.statusCode); }
class ConnectionFailure extends NetworkFailure { const ConnectionFailure(); }
class TimeoutFailure    extends NetworkFailure { const TimeoutFailure(); }
class ParseFailure      extends NetworkFailure { final Object error; const ParseFailure(this.error); }
class UnauthorizedFailure extends NetworkFailure { const UnauthorizedFailure(); }
```

```dart
// ✅ In datasource — map before throwing
NetworkFailure _mapDioError(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.receiveTimeout    => const TimeoutFailure(),
  DioExceptionType.connectionError   => const ConnectionFailure(),
  DioExceptionType.badResponse       => switch (e.response?.statusCode) {
    401 => const UnauthorizedFailure(),
    _   => ServerFailure(e.response?.statusCode ?? 0),
  },
  _ => ConnectionFailure(),
};
```

Repositories catch `NetworkFailure` and convert to domain-level `Either<Failure, T>` using
`fpdart` or a project-local `Result` type.

### 4. Response Parsing

- All JSON parsing **must** happen inside `try/catch`; parse errors are wrapped in `ParseFailure`.
- Use `@JsonSerializable` DTOs — never parse raw `Map<String, dynamic>` inline in datasources.

```dart
// ✅
try {
  return TrendingResponseDto.fromJson(response.data as Map<String, dynamic>);
} on Object catch (e) {
  throw ParseFailure(e);
}
```

### 5. Supabase — Client Initialisation

- The Supabase client is initialised **once** in `main.dart` via `Supabase.initialize()`.
- Access it through a Riverpod provider — never via `Supabase.instance.client` directly in
  feature code:

```dart
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;
```

### 6. Supabase — Authentication

- Auth state is a Riverpod `StreamProvider` wrapping `supabase.auth.onAuthStateChange`.
- Sign-in, sign-out, and token refresh are handled by an `AuthNotifier` (see `state-management.md`).
- **Never** read `supabase.auth.currentSession` synchronously in UI code — always consume the
  stream provider.

```dart
@riverpod
Stream<AuthState> authState(Ref ref) =>
    ref.watch(supabaseClientProvider).auth.onAuthStateChange;
```

### 7. Supabase — Row-Level Security (RLS)

- **Every** table that stores user data **must** have RLS enabled.
- RLS policies are the authoritative access-control layer; client-side guards are secondary.
- Datasources must **never** disable RLS for convenience during development.
- Policy naming convention: `[table]_[role]_[action]` e.g. `favourites_authenticated_select`.

### 8. Supabase — Realtime Streams

- Realtime subscriptions are exposed as Dart `Stream<T>` via the datasource layer.
- Subscriptions are created lazily and cancelled via Riverpod's `ref.onDispose`.
- **Never** leave a Realtime channel open after the consuming provider is disposed.

```dart
@riverpod
Stream<List<FavouriteDto>> favouriteStream(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final channel = client.channel('public:favourites');

  ref.onDispose(() => channel.unsubscribe());

  return channel
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'favourites',
        callback: (_) {},
      )
      .asStream()
      .asyncMap((_) => client.from('favourites').select().then(
            (rows) => rows.map(FavouriteDto.fromJson).toList(),
          ));
}
```

### 9. Environment & Secrets

- API keys and Supabase URL/anon key are stored in `.env` and loaded via `flutter_dotenv`.
- **Never** commit API keys or tokens to source control.
- `AppConstants` exposes only the resolved runtime values — no raw string literals in code.

---

## Do / Don't Reference Table

| ✅ Do | ❌ Don't |
|---|---|
| Use a single `Dio` instance via `@Riverpod(keepAlive: true)` | Instantiate `Dio()` inside datasources or widgets |
| Add Auth → Logging → Retry interceptors in order | Omit interceptors or add them ad-hoc per request |
| Log with `PrettyDioLogger` in debug mode only | Log request/response bodies in release mode |
| Map `DioException` to a sealed `NetworkFailure` in the datasource | Let raw `DioException` propagate to providers or UI |
| Use `@JsonSerializable` DTOs for all JSON parsing | Parse raw `Map<String, dynamic>` inline |
| Expose Supabase auth state as a `StreamProvider` | Read `supabase.auth.currentSession` synchronously in widgets |
| Enable RLS on every user-data table | Rely solely on client-side guards for data access control |
| Cancel Realtime channels in `ref.onDispose` | Leave Realtime subscriptions open after provider disposal |
| Store all secrets in `.env`; never commit them | Hard-code API keys or Supabase credentials in source files |
| Retry only idempotent (`GET`) requests | Auto-retry `POST`/`PUT`/`DELETE` requests |
