# Rule: Architecture — Violet Tracker

> **Agent Mandate**: You are a Senior Flutter Architect. The architecture is the skeleton of the
> product. Every deviation from these rules introduces technical debt that compounds. Enforce
> feature-first structure and the repository pattern without exception.

---

## Context

Violet Tracker uses a **Feature-First** architecture. Each self-contained feature owns its data,
logic, and UI layers. Cross-cutting concerns (networking, storage, theming) live in `core/`.
Entities are always **immutable** and generated via [Freezed](https://pub.dev/packages/freezed).
Data access is always mediated by a **Repository** — widgets and providers never touch raw
Supabase or Isar APIs directly.

---

## Mandatory Guidelines

### 1. Directory Structure

```
lib/
├── core/
│   ├── network/          # Dio singleton, interceptors
│   ├── storage/          # Isar schema + helpers
│   ├── supabase/         # Supabase client wrapper
│   ├── theme/            # AppTheme, AppColors, AppSpacing (from DESIGN.md)
│   └── utils/            # Extensions, formatters, constants
│
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/    # Remote (Dio/Supabase) & Local (Isar) datasources
│       │   ├── models/         # JSON-serialisable DTOs (@JsonSerializable)
│       │   └── repositories/   # Concrete repository implementations
│       ├── domain/
│       │   ├── entities/       # Immutable Freezed entities
│       │   └── repositories/   # Abstract repository interfaces
│       └── ui/
│           ├── pages/          # Route-level screens
│           ├── widgets/        # Feature-specific widgets
│           └── providers/      # Riverpod @riverpod providers (see state-management.md)
│
└── main.dart
```

> **Rule**: No file may import across feature boundaries except through `core/` or a shared
> `domain/` entity. Features are siblings, not parents.

### 2. Feature-First Layer Responsibilities

| Layer | Responsibility | May Import From |
|---|---|---|
| `data/datasources` | Raw I/O (HTTP, DB) | `core/network`, `core/storage`, `core/supabase` |
| `data/models` | DTO serialisation / deserialisation | Dart SDK only |
| `data/repositories` | Implement domain interfaces; map DTO → Entity | `domain/`, `data/datasources` |
| `domain/entities` | Immutable business objects (Freezed) | Nothing outside Dart SDK |
| `domain/repositories` | Abstract contracts for data access | `domain/entities` only |
| `ui/providers` | State orchestration via Riverpod | `domain/repositories`, other providers |
| `ui/widgets` / `ui/pages` | Rendering and user interaction | `ui/providers`, `core/theme` |

### 3. Repository Pattern — Non-Negotiable

- Every data-access operation **must** be declared in a `domain/repositories/i_*_repository.dart`
  abstract class.
- The concrete implementation lives in `data/repositories/`.
- Providers receive the interface type, not the concrete class.

```dart
// ✅ domain/repositories/i_track_repository.dart
abstract interface class ITrackRepository {
  Future<List<Track>> fetchTrending({required int page});
  Future<Track> fetchById(String id);
  Stream<List<Track>> watchFavourites();
}

// ✅ data/repositories/track_repository.dart
class TrackRepository implements ITrackRepository {
  const TrackRepository({
    required TrackRemoteDataSource remote,
    required TrackLocalDataSource local,
  });
  // ...
}
```

### 4. Immutable Entities with Freezed

- **All** domain entities **must** use `@freezed`.
- Entities are never mutated; use `.copyWith()` for derived state.
- JSON serialisation belongs on **DTOs** (`data/models`), not entities.

```dart
// ✅ domain/entities/track.dart
@freezed
class Track with _$Track {
  const factory Track({
    required String id,
    required String title,
    required String artistName,
    String? posterPath,
    @Default(false) bool isFavourite,
  }) = _Track;
}

// ❌ DON'T put fromJson/toJson here — that is a DTO concern
```

### 5. DTO ↔ Entity Mapping

- DTOs live in `data/models/` and carry `@JsonSerializable` annotations.
- Repositories are the **only** place where `TrackDto.toEntity()` conversions happen.
- Extension methods on DTOs (`.toEntity()`) are preferred over static factory methods.

```dart
// ✅ data/models/track_dto.dart
extension TrackDtoMapper on TrackDto {
  Track toEntity() => Track(
        id: id,
        title: title,
        artistName: artistName,
        posterPath: posterPath,
      );
}
```

### 6. Dependency Injection via Riverpod

- Datasources, repositories, and services are provided as Riverpod providers.
- The `ProviderScope` override mechanism is used for testing — concrete classes are never
  instantiated inside widgets.

```dart
// ✅ Provide the interface, not the concrete class
@riverpod
ITrackRepository trackRepository(Ref ref) {
  return TrackRepository(
    remote: ref.watch(trackRemoteDataSourceProvider),
    local: ref.watch(trackLocalDataSourceProvider),
  );
}
```

### 7. `core/` Conventions

- `core/theme/` is the **single source of truth** for all design tokens. It is generated from
  `DESIGN.md` and must never diverge from it.
- `core/network/` exposes a single `dioProvider`; no feature creates its own `Dio` instance.
- `core/storage/` exposes an `isarProvider`; no feature opens its own `Isar` instance.

---

## Do / Don't Reference Table

| ✅ Do | ❌ Don't |
|---|---|
| Use Feature-First directory structure | Put all features in a flat `screens/` or `pages/` folder |
| Declare repository contracts as abstract interfaces | Let widgets call datasources directly |
| Use Freezed for all domain entities | Use mutable `class` models as domain entities |
| Map DTOs → Entities inside the repository layer | Map inside widgets or providers |
| Inject dependencies via Riverpod providers | `new` concrete service classes inside widgets |
| Keep cross-feature imports routed through `core/` | Import one feature's internals from another feature |
| Use `.copyWith()` to derive new entity state | Mutate entity fields directly |
| Use `extension` methods on DTOs for mapping | Put `fromJson`/`toJson` on domain entities |
