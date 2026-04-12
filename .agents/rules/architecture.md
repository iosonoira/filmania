# Rule: Architecture — Violet Tracker

> **Mandate**: Senior Flutter Architect role. Enforce feature-first structure + repository pattern. Deviations = bad debt.

---

## Context

**Feature-First** architecture. Self-contained features (data, logic, UI). Cross-cutting in `core/`.
Entities: **immutable** ([Freezed](https://pub.dev/packages/freezed)).
**Repository** pattern: No direct Supabase/Isar in widgets/providers.

---

## Mandatory Guidelines

### 1. Structure

```
lib/
├── core/
│   ├── network/          # Dio singleton
│   ├── storage/          # Isar schema
│   ├── supabase/         # Supabase wrapper
│   ├── theme/            # Tokens (from DESIGN.md)
│   └── utils/            # Shared logic
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/    # Remote/Local I/O
│       │   ├── models/         # DTOs (@JsonSerializable)
│       │   └── repositories/   # Repos impl
│       ├── domain/
│       │   ├── entities/       # Freezed entities
│       │   └── repositories/   # Abstract interfaces
│       └── ui/
│           ├── pages/          # Screens
│           ├── widgets/        # UI pieces
│           └── providers/      # Riverpod providers
└── main.dart
```

> **Rule**: No cross-feature imports. Use `core/` or shared `domain/` entities. Features are siblings.

### 2. Layer Responsibilities

| Layer | Responsibility | May Import |
|---|---|---|
| `data/datasources` | Raw I/O | `core/` |
| `data/models` | DTO serialization | Dart SDK |
| `data/repositories` | Impl interfaces; map DTO → Entity | `domain/`, `data/datasources` |
| `domain/entities` | Immutable objects | Dart SDK |
| `domain/repositories` | Abstract contracts | `domain/entities` |
| `ui/providers` | State orchestration | `domain/repositories`, other providers |
| `ui/widgets/pages` | Rendering | `ui/providers`, `core/theme` |

### 3. Repository Pattern — Non-Negotiable

- Operations in `domain/repositories/i_*.dart` (abstract).
- Impl in `data/repositories/`.
- Providers use interface type.

### 4. Immutable Entities (Freezed)

- **Must** use `@freezed`.
- No mutation; use `.copyWith()`.
- No JSON logic (keep in DTOs).

### 5. DTO ↔ Entity Mapping

- DTOs in `data/models/` (@JsonSerializable).
- Mapping only in Repositories.
- Use `extension` methods on DTOs.

### 6. Dependency Injection (Riverpod)

- All services = providers.
- No concrete instantiation in widgets. Use `ProviderScope` for testing.

```dart
@riverpod
ITrackRepository trackRepository(Ref ref) {
  return TrackRepository(
    remote: ref.watch(trackRemoteDataSourceProvider),
    local: ref.watch(trackLocalDataSourceProvider),
  );
}
```

### 7. `core/` Conventions

- `core/theme/`: Single source of truth. Matches `DESIGN.md`.
- `core/network/`: One `dioProvider`.
- `core/storage/`: One `isarProvider`.

---

## Do / Don't

| ✅ Do | ❌ Don't |
|---|---|
| Feature-First structure | Flat `screens/` folder |
| Abstract repo contracts | Call datasources from widgets |
| Freezed entities | Mutable class entities |
| Map in repository layer | Map in widgets/providers |
| Riverpod for DI | `new` services in widgets |
| Cross-feature via `core/` | Internal feature imports |
| `.copyWith()` for state | Mutate fields directly |
| Extension methods on DTOs | `fromJson`/`toJson` in entities |
