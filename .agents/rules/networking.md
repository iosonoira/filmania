# Rule: Networking — Violet Tracker

> **Mandate**: Senior Flutter Architect role. Network layer reliability. Enforce singleton Dio, typed interceptors, error mapping, Supabase best practices.

---

## Context

TMDB API (`Dio`) + Supabase (Auth, RLS DB, Realtime). Map errors to domain `Failure` types. UI never sees raw exceptions.

---

## Mandatory Guidelines

### 1. Dio Singleton

- One `Dio` instance via `@Riverpod(keepAlive: true)`.
- Configure `BaseOptions` (baseUrl, timeouts, headers).
- Add mandatory interceptors (Auth, Logging, Retry). No ad-hoc instances.

### 2. Interceptors

1. **Auth (TMDB)**: Appends Bearer token from secure storage.
2. **Logging**: `pretty_dio_logger` (**debug only**). None in `kReleaseMode`.
3. **Retry**: Up to 3 retries for **idempotent** (`GET`) requests on timeout/socket errors. Exponential back-off. **Never** retry mutations (`POST`/`PUT`/`DELETE`).

### 3. Error Mapping

Map `DioException` to sealed `NetworkFailure` (`ServerFailure`, `ConnectionFailure`, `TimeoutFailure`, `ParseFailure`, `UnauthorizedFailure`) in datasource. Repos translate to domain `Result`.

### 4. Response Parsing

- Use `try/catch` and wrap in `ParseFailure`.
- Use `@JsonSerializable` DTOs in `data/models`.

### 5. Supabase — Client

Init once in `main.dart`. Access via `@Riverpod(keepAlive: true) supabaseClient`. No direct `Supabase.instance.client` in features.

### 6. Supabase — Auth

- Auth state = Riverpod `StreamProvider` wrapping `onAuthStateChange`.
- Reactive logic via `AuthNotifier`.
- No sync reading of `currentSession` in UI.

### 7. Supabase — RLS

- RLS **must** be enabled on every user-data table.
- Naming: `[table]_[role]_[action]`.
- No disabling RLS for convenience.

### 8. Supabase — Realtime

- Exposed as `Stream<T>` via datasource.
- Lazy creation; cancel in `ref.onDispose`. No dangling channels.

### 9. Environment & Secrets

- Secrets in `.env` (`flutter_dotenv`). No commits of keys.
- `AppConstants` for runtime values.

---

## Do / Don't

| ✅ Do | ❌ Don't |
|---|---|
| Single `Dio` instance (Riverpod) | `new Dio()` in features |
| Auth → Logging → Retry order | Ad-hoc interceptors |
| `PrettyDioLogger` debug only | Release-mode logging |
| Map exceptions to `NetworkFailure` | Raw exceptions in UI |
| `@JsonSerializable` DTOs | Inline `Map` parsing |
| Supabase auth `StreamProvider` | Sync session reads |
| RLS on all user tables | Client-only access control |
| Cancel Realtime in `onDispose` | Dangling subscriptions |
| `.env` for all secrets | Commit keys |
| Retry only `GET` | Auto-retry `POST/PUT/DELETE` |
