# Rule: State Management — Violet Tracker

> **Agent Mandate**: You are a Senior Flutter Architect. State is the most brittle part of any
> application. You enforce Riverpod's generator-based API with zero tolerance for manual
> `StateNotifier` boilerplate, raw `ChangeNotifier`, or `setState` outside localised widget state.

---

## Context

Violet Tracker uses **Riverpod 3.0** exclusively, with code generation (`@riverpod` /
`@Riverpod()` annotations) provided by `riverpod_generator`. This eliminates hand-written
provider declarations and enforces consistency. Every async operation surfaces its lifecycle
(loading / error / data) to the UI via `AsyncValue` — no silent failures.

---

## Mandatory Guidelines

### 1. Always Use the Code Generator

- **Never** declare providers manually (`Provider(...)`, `StateNotifierProvider(...)`, etc.).
- Every provider **must** use the `@riverpod` annotation and `riverpod_generator`.
- Run `dart run build_runner watch` continuously during development.

```dart
// ✅ DO — generated, type-safe, terse
part 'trending_tracks_provider.g.dart';

@riverpod
Future<List<Track>> trendingTracks(Ref ref, {int page = 1}) async {
  final repo = ref.watch(trackRepositoryProvider);
  return repo.fetchTrending(page: page);
}

// ❌ DON'T — manual declaration is verbose and error-prone
final trendingTracksProvider = FutureProvider.family<List<Track>, int>((ref, page) async {
  ...
});
```

### 2. Provider Naming Conventions

| Provider type | Suffix convention | Example |
|---|---|---|
| Simple computed value | `Provider` (implicit via generator) | `currentUserProvider` |
| Async data fetch | `Provider` returning `Future<T>` | `trendingTracksProvider` |
| Mutable state | `Notifier` / `AsyncNotifier` | `FavouritesNotifier` |
| Stream | `Provider` returning `Stream<T>` | `realtimeUpdatesProvider` |

### 3. Provider Granularity

- One provider = one logical unit of state or data.
- **Never** create a "God provider" that holds multiple unrelated pieces of state.
- Providers that derive from other providers use `ref.watch`, not `ref.read`, to ensure
  reactivity.

```dart
// ✅ Fine-grained — only rebuilds consumers of this specific provider
@riverpod
bool isTrackFavourite(Ref ref, String trackId) {
  final favs = ref.watch(favouritesProvider);
  return favs.valueOrNull?.contains(trackId) ?? false;
}
```

### 4. Mandatory `AsyncValue` Handling

Every widget that consumes an `AsyncValue` (from a `FutureProvider` or `StreamProvider`) **must**
handle all three states. Unhandled states are a UX bug and a build-failure in strict mode.

```dart
// ✅ DO — exhaustive handling
@override
Widget build(BuildContext context, WidgetRef ref) {
  final tracks = ref.watch(trendingTracksProvider);

  return tracks.when(
    data:    (data)  => TrackGrid(tracks: data),
    loading: ()      => const VioletLoadingIndicator(),   // from DESIGN.md
    error:   (e, st) => VioletErrorView(error: e, onRetry: () => ref.invalidate(trendingTracksProvider)),
  );
}

// ❌ DON'T — crashes on error or loading
final data = ref.watch(trendingTracksProvider).value!;
```

### 5. `AsyncNotifier` for Mutating State

Use `AsyncNotifier` (generated as `@riverpod class FooNotifier extends _$FooNotifier`) for any
state that is both asynchronously loaded **and** mutated by user actions.

```dart
@riverpod
class FavouritesNotifier extends _$FavouritesNotifier {
  @override
  Future<Set<String>> build() async {
    return ref.watch(trackRepositoryProvider).watchFavourites().first;
  }

  Future<void> toggle(String trackId) async {
    final current = await future;
    final updated = current.contains(trackId)
        ? current.difference({trackId})
        : {...current, trackId};

    state = AsyncData(updated);
    await ref.read(trackRepositoryProvider).setFavourite(trackId, !current.contains(trackId));
  }
}
```

### 6. `ref.watch` vs `ref.read` vs `ref.listen`

| Method | When to use |
|---|---|
| `ref.watch` | Inside `build()` — reactive, triggers rebuild on change |
| `ref.read` | Inside callbacks / one-shot imperative calls (e.g., `onPressed`) |
| `ref.listen` | Side-effects (navigation, snackbars) in response to state change |

> **Never** call `ref.watch` inside a callback, loop, or conditional — this violates Riverpod's
> contract and will throw in debug mode.

### 7. Provider Scoping & Overrides

- Use `ProviderScope` overrides exclusively for **testing** and **per-route scoping**.
- Do not use `ProviderScope` nested inside widgets as a form of local state — use
  `StateProvider` or a local `Notifier` instead.

### 8. Avoiding Common Rebuild Pitfalls

- `select()` must be used when a widget only needs a sub-field of a larger state object:

```dart
// ✅ Only rebuilds when the username changes, not the entire User
final username = ref.watch(currentUserProvider.select((u) => u?.displayName));
```

- Prefer `ConsumerWidget` over `Consumer` inline wrappers to keep `build()` clean.
- For lists: wrap each list item in its own `ConsumerWidget` to avoid full-list rebuilds.

### 9. Error Handling & Logging

- All `AsyncNotifier` methods must catch exceptions and set `state = AsyncError(e, st)`.
- Never swallow errors silently. Use the project's logger (`core/utils/logger.dart`) for all
  caught exceptions before re-surfacing them.

```dart
Future<void> refresh() async {
  state = const AsyncLoading();
  state = await AsyncValue.guard(() => ref.read(trackRepositoryProvider).fetchTrending());
}
```

> `AsyncValue.guard` is the preferred pattern — it catches and wraps errors automatically.

---

## Do / Don't Reference Table

| ✅ Do | ❌ Don't |
|---|---|
| Use `@riverpod` generator annotations for all providers | Declare providers manually with `StateNotifierProvider` etc. |
| Handle all three `AsyncValue` states (`data`, `loading`, `error`) | Access `.value!` without checking state |
| Use `AsyncValue.guard()` for safe async operations | Wrap provider bodies in bare try/catch without setting `AsyncError` |
| Use `ref.watch` in `build()`, `ref.read` in callbacks | Call `ref.watch` inside a callback or conditional |
| Use `.select()` to narrow subscriptions | Watch an entire large state object from a fine-grained widget |
| Use `AsyncNotifier` for load + mutate flows | Mix `FutureProvider` with separate `StateProvider` for mutations |
| One provider = one logical concern | Create God providers that manage multiple unrelated states |
| Override providers in `ProviderScope` for tests | Instantiate concrete service classes inside widgets for testing |
