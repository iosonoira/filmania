---
name: Generate Feature
description: Instructions for creating a new feature in Filmania following Clean Architecture.
---

# Generate Feature for Filmania

When creating a new feature in Filmania, strictly follow the Layered Clean Architecture pattern. Each feature must be fully self-contained under `lib/features/<feature_name>/` and avoid bypassing layers.

## 1. Directory Structure
Generate the following structure:
```
lib/features/<feature_name>/
├── data/
│   ├── models/           # DTOs with @JsonSerializable
│   └── repositories/     # Concrete repo implementations
├── domain/
│   ├── entities/         # Core models with @freezed
│   ├── failures/         # Sealed class for exceptions
│   └── repositories/     # Abstract interfaces (IFeatureRepository)
└── ui/
    ├── pages/            # Full screen GoRouter pages
    ├── widgets/          # Reusable local components
    └── providers/        # AsyncNotifier / Notifier providers
```

## 2. Models & Entities
- Use `@freezed` for domain entities (`domain/entities/<feature_name>.dart`).
- Use `@JsonSerializable` for DTOs (`data/models/<feature_name>_dto.dart`). DTOs should include a `toEntity()` mapper method.

## 3. Repositories
- Define the abstract interface in `domain/repositories/i_<feature_name>_repository.dart`.
- Implement it in `data/repositories/<feature_name>_repository.dart`.
- Fetch the `SupabaseClient` via `ref.watch(supabaseClientProvider)` rather than `Supabase.instance`.
- Map Supabase exceptions to custom exceptions defined in `domain/failures/<feature_name>_failure.dart` (using `sealed class`).

## 4. Providers
- Create a feature provider using Riverpod Code Generation (`@riverpod`). 
- Keep state immutable. Use `AsyncValue` or complex objects rather than primitive flags.
- UI components should only listen to UI providers. Direct calls to repositories from UI are strictly forbidden.
