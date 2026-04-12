# Rule: State Management — Violet Tracker

> **Mandate**: Senior Flutter Architect role. Use Riverpod 3.0 generator-based API. Zero tolerance for manual boilerplate or `setState` abusals.

---

## Context

**Riverpod 3.0** with code generation (`riverpod_generator`). Lifecycle (loading/error/data) via `AsyncValue`. No silent failures.

---

## Mandatory Guidelines

### 1. Code Generator (Mandatory)

- **Never** manually declare providers (`Provider`, `StateNotifierProvider`).
- Use `@riverpod` + `part 'file.g.dart';`.
- Run `build_runner watch`.

### 2. Naming

- Async data/computed: `Provider`.
- Mutable: `Notifier` / `AsyncNotifier`.
- Stream: `Provider`.

### 3. Granularity

- One provider = one unit. No "God providers".
- Ref use `ref.watch` for reactivity, never `ref.read` for derived state.

### 4. `AsyncValue` Handling

Exhaustive handling of **data**, **loading**, **error**.

```dart
tracks.when(
  data: (data) => Grid(data),
  loading: () => LoadingIndicator(),
  error: (e, st) => ErrorView(e, retry),
);
```

### 5. `AsyncNotifier` (Mutation)

Use for asynchronously loaded + user-mutated state.

```dart
@riverpod
class FavouritesNotifier extends _$FavouritesNotifier {
  @override
  Future<Set<String>> build() async => ...;
  
  Future<void> toggle(String id) async { ... }
}
```

### 6. `ref` Methods

| Method | When to use |
|---|---|
| `ref.watch` | `build()` (reactive) |
| `ref.read` | Callbacks (`onPressed`) |
| `ref.listen` | Side-effects (navigation, snackbars) |

> **Never** call `ref.watch` in callbacks/loops/conditionals.

### 7. Scoping

`ProviderScope` overrides only for **testing** or **per-route scoping**.

### 8. Rebuild Optimization

- Use `.select()` for sub-fields.
- `ConsumerWidget` preferred.
- For lists: Small `ConsumerWidget` per item.

### 9. Error Handling

- Catch exceptions; set `state = AsyncError(e, st)`.
- Use `AsyncValue.guard()` for safe wrapping.
- Use project logger (`core/utils/logger.dart`).

---

## Do / Don't

| ✅ Do | ❌ Don't |
|---|---|
| `@riverpod` generator | Manual provider declarations |
| Handle data/loading/error | Access `.value!` directly |
| `AsyncValue.guard()` | Bare try/catch without `AsyncError` |
| `ref.watch` in build | `ref.watch` in callbacks |
| `.select()` for narrowing | Watch large objects unnecessarily |
| `AsyncNotifier` for mutation | Mix providers for mutation flow |
| One unit per provider | "God providers" |
| `ProviderScope` for tests | Instantiate concrete classes in widgets |
