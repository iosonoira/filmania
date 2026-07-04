# Cast, Crew & Person Details Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Show full TMDB crew (not just cast) on movie/TV detail pages, and make cast/crew cards navigate to a new read-only Person Details page (bio, birth info, photo, filmography).

**Architecture:** Extend the existing shared `core/domain/entities/cast_member.dart` credits pipeline with a sibling `CrewMember` type and a `Credits { cast, crew }` wrapper entity so the movie/TV `credits` endpoint is parsed once and both cast and crew are derived from it (no duplicate HTTP calls). Add a new lightweight, read-only `features/person/` feature (Clean Architecture: domain → data → ui) mirroring `features/movies/` but with no Supabase/mutation layer, backed by TMDB `person/{id}` and `person/{id}/combined_credits`. Wire a new `AppRoutes.personDetails` route and make the existing `_CastCard` (and new `_CrewCard`) tappable via `context.push`.

**Tech Stack:** Flutter, Riverpod 3.0 (`@riverpod` codegen), Freezed, JsonSerializable, Dio (`tmdbClientProvider`), GoRouter.

## Global Constraints

- **No cross-feature imports** rule from CLAUDE.md is aspirational only for *new* code between sibling feature domains — this codebase already imports `features/discover/ui/widgets/discover_widgets.dart` (`MediaGridCard`) from `features/movies` and `features/tv_series` (see `trending_movies_page.dart`, `trending_tv_series_page.dart`). Task 8 follows this existing precedent to reuse `MediaGridCard` from `features/person`; do not "fix" the layering by moving `MediaGridCard` — out of scope.
- DTOs use `@JsonSerializable` via `@freezed` + `part '*.g.dart'`, and define their own `toEntity()` (this is the actual codebase convention, e.g. `CastMemberDto.toEntity()`, `MovieDto.toEntity()` — not the more restrictive line in CLAUDE.md).
- Every new/changed `@freezed` or `@JsonSerializable` class requires `dart run build_runner build --delete-conflicting-outputs` before `flutter test`/`dart analyze` will pass.
- No mocktail/HTTP-mocking package exists in `pubspec.yaml`. Existing tests only cover pure functions, DTO `fromJson`/`toEntity`, and widgets via `ProviderScope` overrides — follow that same scope; do not add datasource/repository network tests.
- Colors: `AppColors.of(context)` only. Spacing: `AppSpacing` tokens only. No 1px borders/dividers (No-Line Rule). `CachedNetworkImage` must set `memCacheWidth`/`memCacheHeight` or `memCacheWidth` per `PERFORMANCE_FIXES.md`.
- `context.push(AppRoutes.xxx.replaceAll(':id', id.toString()))` is the established navigation pattern (see `glassmorphic_app_bar.dart`, `trending_movies_page.dart`).

---

## File Structure

```
lib/core/domain/entities/crew_member.dart          [NEW]
lib/core/data/models/crew_member_dto.dart           [NEW]
lib/core/domain/entities/credits.dart               [NEW]
lib/core/data/models/credits_dto.dart                [NEW]
lib/core/widgets/crew_section.dart                   [NEW]
lib/core/widgets/cast_section.dart                   [MODIFY: clickable _CastCard]
lib/core/l10n/arb/app_en.arb                         [MODIFY: +4 keys]
lib/core/l10n/arb/app_it.arb                         [MODIFY: +4 keys]

lib/features/movies/data/datasources/i_movies_remote_datasource.dart   [MODIFY]
lib/features/movies/data/datasources/movies_remote_datasource_impl.dart [MODIFY]
lib/features/movies/domain/repositories/i_movies_repository.dart       [MODIFY]
lib/features/movies/data/repositories/movies_repository_impl.dart      [MODIFY]
lib/features/movies/ui/providers/movies_provider.dart                  [MODIFY]
lib/features/movies/ui/pages/movie_details_page.dart                   [MODIFY]

lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart   [MODIFY]
lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart [MODIFY]
lib/features/tv_series/domain/repositories/i_tv_series_repository.dart       [MODIFY]
lib/features/tv_series/data/repositories/tv_series_repository_impl.dart      [MODIFY]
lib/features/tv_series/ui/providers/tv_series_provider.dart                  [MODIFY]
lib/features/tv_series/ui/pages/tv_series_details_page.dart                  [MODIFY]

lib/features/person/domain/entities/person.dart                 [NEW]
lib/features/person/domain/entities/person_credit.dart          [NEW]
lib/features/person/domain/repositories/i_person_repository.dart [NEW]
lib/features/person/data/models/person_dto.dart                 [NEW]
lib/features/person/data/models/person_credit_dto.dart          [NEW]
lib/features/person/data/models/person_combined_credits_dto.dart [NEW]
lib/features/person/data/datasources/i_person_remote_datasource.dart [NEW]
lib/features/person/data/datasources/person_remote_datasource_impl.dart [NEW]
lib/features/person/data/repositories/person_repository_impl.dart [NEW]
lib/features/person/ui/providers/person_provider.dart           [NEW]
lib/features/person/ui/pages/person_details_page.dart           [NEW]

lib/core/router/app_router.dart                                 [MODIFY]

test/core/data/models/crew_member_dto_test.dart                 [NEW]
test/core/data/models/credits_dto_test.dart                     [NEW]
test/core/widgets/crew_section_test.dart                        [NEW]
test/core/widgets/cast_section_test.dart                        [NEW]
test/features/person/data/models/person_dto_test.dart           [NEW]
test/features/person/data/models/person_combined_credits_dto_test.dart [NEW]
test/features/person/ui/pages/person_details_page_test.dart     [NEW]
```

---

### Task 1: `CrewMember` entity + `CrewMemberDto`

**Files:**
- Create: `lib/core/domain/entities/crew_member.dart`
- Create: `lib/core/data/models/crew_member_dto.dart`
- Test: `test/core/data/models/crew_member_dto_test.dart`

**Interfaces:**
- Produces: `CrewMember({id, name, job, department, profilePath})` with `fullProfileUrl` getter; `CrewMemberDto.fromJson`, `.toEntity()`.

- [ ] **Step 1: Create the `CrewMember` entity**

```dart
// lib/core/domain/entities/crew_member.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crew_member.freezed.dart';

@freezed
abstract class CrewMember with _$CrewMember {
  const factory CrewMember({
    required int id,
    required String name,
    required String job,
    required String department,
    required String? profilePath,
  }) = _CrewMember;

  const CrewMember._();

  String? get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;
}
```

- [ ] **Step 2: Create the `CrewMemberDto`**

```dart
// lib/core/data/models/crew_member_dto.dart
import 'package:filmania/core/domain/entities/crew_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crew_member_dto.freezed.dart';
part 'crew_member_dto.g.dart';

@freezed
abstract class CrewMemberDto with _$CrewMemberDto {
  const factory CrewMemberDto({
    required int id,
    required String name,
    required String job,
    required String department,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CrewMemberDto;

  factory CrewMemberDto.fromJson(Map<String, dynamic> json) =>
      _$CrewMemberDtoFromJson(json);

  const CrewMemberDto._();

  CrewMember toEntity() {
    return CrewMember(
      id: id,
      name: name,
      job: job,
      department: department,
      profilePath: profilePath,
    );
  }
}
```

- [ ] **Step 3: Write the DTO test**

```dart
// test/core/data/models/crew_member_dto_test.dart
import 'package:filmania/core/data/models/crew_member_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CrewMemberDto', () {
    test('fromJson parses id, name, job, department, profile_path', () {
      final dto = CrewMemberDto.fromJson({
        'id': 138,
        'name': 'Quentin Tarantino',
        'job': 'Director',
        'department': 'Directing',
        'profile_path': '/abc.jpg',
      });

      expect(dto.id, 138);
      expect(dto.name, 'Quentin Tarantino');
      expect(dto.job, 'Director');
      expect(dto.department, 'Directing');
      expect(dto.profilePath, '/abc.jpg');
    });

    test('toEntity maps to CrewMember with the same fields', () {
      const dto = CrewMemberDto(
        id: 138,
        name: 'Quentin Tarantino',
        job: 'Director',
        department: 'Directing',
        profilePath: '/abc.jpg',
      );

      final entity = dto.toEntity();

      expect(entity.id, 138);
      expect(entity.job, 'Director');
      expect(entity.fullProfileUrl, 'https://image.tmdb.org/t/p/w185/abc.jpg');
    });

    test('fullProfileUrl is null when profilePath is null', () {
      const dto = CrewMemberDto(
        id: 1,
        name: 'X',
        job: 'Producer',
        department: 'Production',
        profilePath: null,
      );

      expect(dto.toEntity().fullProfileUrl, isNull);
    });
  });
}
```

- [ ] **Step 4: Generate code and run the test**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/core/data/models/crew_member_dto_test.dart`
Expected: all 3 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/domain/entities/crew_member.dart lib/core/domain/entities/crew_member.freezed.dart lib/core/data/models/crew_member_dto.dart lib/core/data/models/crew_member_dto.freezed.dart lib/core/data/models/crew_member_dto.g.dart test/core/data/models/crew_member_dto_test.dart
git commit -m "feat: add CrewMember entity and DTO"
```

---

### Task 2: `Credits` wrapper entity + `CreditsDto`

**Files:**
- Create: `lib/core/domain/entities/credits.dart`
- Create: `lib/core/data/models/credits_dto.dart`
- Test: `test/core/data/models/credits_dto_test.dart`

**Interfaces:**
- Consumes: `CastMember`/`CastMemberDto` (from `lib/core/domain/entities/cast_member.dart`, `lib/core/data/models/cast_member_dto.dart`), `CrewMember`/`CrewMemberDto` (Task 1).
- Produces: `Credits({cast: List<CastMember>, crew: List<CrewMember>})`; `CreditsDto.fromJson` (parses a raw `{cast: [...], crew: [...]}` TMDB credits response), `.toEntity()`.

- [ ] **Step 1: Create the `Credits` entity**

```dart
// lib/core/domain/entities/credits.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/domain/entities/crew_member.dart';

part 'credits.freezed.dart';

@freezed
abstract class Credits with _$Credits {
  const factory Credits({
    required List<CastMember> cast,
    required List<CrewMember> crew,
  }) = _Credits;
}
```

- [ ] **Step 2: Create the `CreditsDto`**

```dart
// lib/core/data/models/credits_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/core/data/models/crew_member_dto.dart';
import 'package:filmania/core/domain/entities/credits.dart';

part 'credits_dto.freezed.dart';
part 'credits_dto.g.dart';

@freezed
abstract class CreditsDto with _$CreditsDto {
  const factory CreditsDto({
    @Default([]) List<CastMemberDto> cast,
    @Default([]) List<CrewMemberDto> crew,
  }) = _CreditsDto;

  factory CreditsDto.fromJson(Map<String, dynamic> json) =>
      _$CreditsDtoFromJson(json);

  const CreditsDto._();

  Credits toEntity() {
    return Credits(
      cast: cast.map((dto) => dto.toEntity()).toList(),
      crew: crew.map((dto) => dto.toEntity()).toList(),
    );
  }
}
```

- [ ] **Step 3: Write the DTO test**

```dart
// test/core/data/models/credits_dto_test.dart
import 'package:filmania/core/data/models/credits_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditsDto', () {
    test('fromJson parses both cast and crew arrays', () {
      final dto = CreditsDto.fromJson({
        'cast': [
          {'id': 1, 'name': 'Actor One', 'character': 'Hero', 'profile_path': null},
        ],
        'crew': [
          {
            'id': 2,
            'name': 'Director One',
            'job': 'Director',
            'department': 'Directing',
            'profile_path': null,
          },
        ],
      });

      expect(dto.cast, hasLength(1));
      expect(dto.crew, hasLength(1));
      expect(dto.cast.first.character, 'Hero');
      expect(dto.crew.first.job, 'Director');
    });

    test('fromJson defaults to empty lists when keys are missing', () {
      final dto = CreditsDto.fromJson(<String, dynamic>{});

      expect(dto.cast, isEmpty);
      expect(dto.crew, isEmpty);
    });

    test('toEntity maps cast and crew to their entities', () {
      final dto = CreditsDto.fromJson({
        'cast': [
          {'id': 1, 'name': 'Actor One', 'character': 'Hero', 'profile_path': null},
        ],
        'crew': [
          {
            'id': 2,
            'name': 'Director One',
            'job': 'Director',
            'department': 'Directing',
            'profile_path': null,
          },
        ],
      });

      final entity = dto.toEntity();

      expect(entity.cast.single.name, 'Actor One');
      expect(entity.crew.single.name, 'Director One');
    });
  });
}
```

- [ ] **Step 4: Generate code and run the test**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/core/data/models/credits_dto_test.dart`
Expected: all 3 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/domain/entities/credits.dart lib/core/domain/entities/credits.freezed.dart lib/core/data/models/credits_dto.dart lib/core/data/models/credits_dto.freezed.dart lib/core/data/models/credits_dto.g.dart test/core/data/models/credits_dto_test.dart
git commit -m "feat: add Credits wrapper entity and DTO"
```

---

### Task 3: Localization strings

**Files:**
- Modify: `lib/core/l10n/arb/app_en.arb`
- Modify: `lib/core/l10n/arb/app_it.arb`

**Interfaces:**
- Produces: `AppLocalizations.crewTitle`, `.biographyTitle`, `.filmographyTitle`, `.noBiography` (used in Tasks 4 and 8).

- [ ] **Step 1: Add keys to `app_en.arb`**

Find line 81 (`"castTitle": "Cast",`) and insert after it:

```json
  "castTitle": "Cast",
  "crewTitle": "Crew",
  "biographyTitle": "Biography",
  "filmographyTitle": "Filmography",
  "noBiography": "No biography available.",
```

- [ ] **Step 2: Add keys to `app_it.arb`**

Find line 81 (`"castTitle": "Cast",`) and insert after it:

```json
  "castTitle": "Cast",
  "crewTitle": "Staff",
  "biographyTitle": "Biografia",
  "filmographyTitle": "Filmografia",
  "noBiography": "Nessuna biografia disponibile.",
```

- [ ] **Step 3: Regenerate localization files**

Run: `flutter gen-l10n`
Expected: `lib/core/l10n/generated/app_localizations_en.dart` and `app_localizations_it.dart` now contain `crewTitle`, `biographyTitle`, `filmographyTitle`, `noBiography` getters, no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/core/l10n/arb/app_en.arb lib/core/l10n/arb/app_it.arb lib/core/l10n/generated/app_localizations.dart lib/core/l10n/generated/app_localizations_en.dart lib/core/l10n/generated/app_localizations_it.dart
git commit -m "feat: add crew/biography/filmography l10n strings"
```

---

### Task 4: `CrewSection` widget

**Files:**
- Create: `lib/core/widgets/crew_section.dart`
- Test: `test/core/widgets/crew_section_test.dart`

**Interfaces:**
- Consumes: `CrewMember` (Task 1), `AppLocalizations.crewTitle` (Task 3).
- Produces: `CrewSection({required List<CrewMember> crew, String? title})` — horizontal scrollable list, same visual pattern as `CastSection`. `_CrewCard` is **not yet tappable** — navigation is wired in Task 10 once the person route exists.

- [ ] **Step 1: Create `CrewSection` modeled on `CastSection`**

```dart
// lib/core/widgets/crew_section.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmania/core/domain/entities/crew_member.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:filmania/core/l10n/generated/app_localizations.dart';

class CrewSection extends StatelessWidget {
  final List<CrewMember> crew;
  final String? title;

  const CrewSection({
    super.key,
    required this.crew,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (crew.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title ?? l10n.crewTitle,
            style: textTheme.titleLarge?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: crew.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => _CrewCard(member: crew[index]),
          ),
        ),
      ],
    );
  }
}

class _CrewCard extends StatelessWidget {
  final CrewMember member;

  const _CrewCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: member.fullProfileUrl != null
                ? CachedNetworkImage(
                    imageUrl: member.fullProfileUrl!,
                    fit: BoxFit.cover,
                    memCacheWidth: 200,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => _CrewFallback(colors: colors),
                  )
                : _CrewFallback(colors: colors),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            member.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurfacePrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            member.job,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrewFallback extends StatelessWidget {
  final AppColorScheme colors;

  const _CrewFallback({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.person_rounded,
        color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
        size: 40,
      ),
    );
  }
}
```

- [ ] **Step 2: Write the widget test**

```dart
// test/core/widgets/crew_section_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/entities/crew_member.dart';
import 'package:filmania/core/widgets/crew_section.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

const _crew = [
  CrewMember(
    id: 138,
    name: 'Quentin Tarantino',
    job: 'Director',
    department: 'Directing',
    profilePath: null,
  ),
  CrewMember(
    id: 2,
    name: 'Sally Menke',
    job: 'Editor',
    department: 'Editing',
    profilePath: null,
  ),
];

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('renders nothing when crew is empty', (tester) async {
    await tester.pumpWidget(_wrap(const CrewSection(crew: [])));

    expect(find.byType(CrewSection), findsOneWidget);
    expect(find.text('Crew'), findsNothing);
  });

  testWidgets('renders a card per crew member with name and job', (tester) async {
    await tester.pumpWidget(_wrap(const CrewSection(crew: _crew)));
    await tester.pump();

    expect(find.text('Crew'), findsOneWidget);
    expect(find.text('Quentin Tarantino'), findsOneWidget);
    expect(find.text('Director'), findsOneWidget);
    expect(find.text('Sally Menke'), findsOneWidget);
    expect(find.text('Editor'), findsOneWidget);
  });

  testWidgets('uses a custom title when provided', (tester) async {
    await tester.pumpWidget(
      _wrap(const CrewSection(crew: _crew, title: 'Behind the scenes')),
    );
    await tester.pump();

    expect(find.text('Behind the scenes'), findsOneWidget);
    expect(find.text('Crew'), findsNothing);
  });
}
```

- [ ] **Step 3: Run the test**

Run: `flutter test test/core/widgets/crew_section_test.dart`
Expected: all 3 tests PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/core/widgets/crew_section.dart test/core/widgets/crew_section_test.dart
git commit -m "feat: add CrewSection widget"
```

---

### Task 5: Movies credits pipeline returns `Credits`, wired into `movie_details_page.dart`

**Files:**
- Modify: `lib/features/movies/data/datasources/i_movies_remote_datasource.dart`
- Modify: `lib/features/movies/data/datasources/movies_remote_datasource_impl.dart:95-104`
- Modify: `lib/features/movies/domain/repositories/i_movies_repository.dart`
- Modify: `lib/features/movies/data/repositories/movies_repository_impl.dart:52-56`
- Modify: `lib/features/movies/ui/providers/movies_provider.dart:53-57`
- Modify: `lib/features/movies/ui/pages/movie_details_page.dart:379-397`

**Interfaces:**
- Consumes: `CreditsDto`/`Credits` (Task 2), `CrewSection` (Task 4).
- Produces: `movieCreditsProvider(int movieId)` now resolves `Future<Credits>` instead of `Future<List<CastMember>>`.

- [ ] **Step 1: Update the datasource interface**

In `lib/features/movies/data/datasources/i_movies_remote_datasource.dart`, replace:

```dart
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

abstract interface class IMoviesRemoteDataSource {
  Future<List<MovieDto>> getTrendingMovies({int page = 1});
  Future<List<MovieDto>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<MovieDto> getMovieDetails(int movieId);
  Future<List<MovieDto>> searchMovies(String query, {int page = 1});
  Future<List<CastMemberDto>> getMovieCredits(int movieId);
  Future<List<GenreDto>> getGenres();
}
```

with:

```dart
import 'package:filmania/core/data/models/credits_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

abstract interface class IMoviesRemoteDataSource {
  Future<List<MovieDto>> getTrendingMovies({int page = 1});
  Future<List<MovieDto>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<MovieDto> getMovieDetails(int movieId);
  Future<List<MovieDto>> searchMovies(String query, {int page = 1});
  Future<CreditsDto> getMovieCredits(int movieId);
  Future<List<GenreDto>> getGenres();
}
```

- [ ] **Step 2: Update the datasource implementation**

In `lib/features/movies/data/datasources/movies_remote_datasource_impl.dart`, replace the import `import 'package:filmania/core/data/models/cast_member_dto.dart';` with `import 'package:filmania/core/data/models/credits_dto.dart';`, and replace the `getMovieCredits` method (lines 95-104):

```dart
  @override
  Future<List<CastMemberDto>> getMovieCredits(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/credits');
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
```

with:

```dart
  @override
  Future<CreditsDto> getMovieCredits(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/credits');
      return CreditsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
```

- [ ] **Step 3: Update the repository interface**

In `lib/features/movies/domain/repositories/i_movies_repository.dart`, replace:

```dart
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';

abstract class IMoviesRepository {
  Future<List<Movie>> getTrendingMovies({int page = 1});
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<List<CastMember>> getMovieCredits(int movieId);
  Future<List<Genre>> getGenres();
}
```

with:

```dart
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/core/domain/entities/credits.dart';

abstract class IMoviesRepository {
  Future<List<Movie>> getTrendingMovies({int page = 1});
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<Credits> getMovieCredits(int movieId);
  Future<List<Genre>> getGenres();
}
```

- [ ] **Step 4: Update the repository implementation**

In `lib/features/movies/data/repositories/movies_repository_impl.dart`, replace the import `import 'package:filmania/core/domain/entities/cast_member.dart';` with `import 'package:filmania/core/domain/entities/credits.dart';`, and replace `getMovieCredits` (lines 52-56):

```dart
  @override
  Future<List<CastMember>> getMovieCredits(int movieId) async {
    final dtos = await _remoteDataSource.getMovieCredits(movieId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
```

with:

```dart
  @override
  Future<Credits> getMovieCredits(int movieId) async {
    final dto = await _remoteDataSource.getMovieCredits(movieId);
    return dto.toEntity();
  }
```

- [ ] **Step 5: Update the provider**

In `lib/features/movies/ui/providers/movies_provider.dart`, replace the import `import 'package:filmania/core/domain/entities/cast_member.dart';` with `import 'package:filmania/core/domain/entities/credits.dart';`, and replace `movieCreditsProvider` (lines 53-57):

```dart
@riverpod
Future<List<CastMember>> movieCredits(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieCredits(movieId);
}
```

with:

```dart
@riverpod
Future<Credits> movieCredits(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieCredits(movieId);
}
```

- [ ] **Step 6: Wire `CrewSection` into `movie_details_page.dart`**

Add the import `import 'package:filmania/core/widgets/crew_section.dart';` next to the existing `import '../../../../core/widgets/cast_section.dart';` (line 15), and replace `_MovieCastSection` (lines 379-397):

```dart
class _MovieCastSection extends ConsumerWidget {
  final int movieId;

  const _MovieCastSection({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(movieCreditsProvider(movieId));

    return creditsAsync.when(
      data: (cast) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: CastSection(cast: cast),
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
```

with:

```dart
class _MovieCastSection extends ConsumerWidget {
  final int movieId;

  const _MovieCastSection({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(movieCreditsProvider(movieId));

    return creditsAsync.when(
      data: (credits) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: CastSection(cast: credits.cast),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: CrewSection(crew: credits.crew),
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 7: Regenerate code and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `dart analyze lib/features/movies`
Expected: no errors.
Run: `flutter test`
Expected: all existing tests still PASS (no test referenced the old `List<CastMember>` return type directly).

- [ ] **Step 8: Commit**

```bash
git add lib/features/movies
git commit -m "feat: extend movie credits pipeline with crew, show CrewSection"
```

---

### Task 6: TV series credits pipeline returns `Credits`, wired into `tv_series_details_page.dart`

**Files:**
- Modify: `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart`
- Modify: `lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart:126-135`
- Modify: `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`
- Modify: `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart:72-76`
- Modify: `lib/features/tv_series/ui/providers/tv_series_provider.dart:78-82`
- Modify: `lib/features/tv_series/ui/pages/tv_series_details_page.dart:376-394`

**Interfaces:**
- Consumes: `CreditsDto`/`Credits` (Task 2), `CrewSection` (Task 4).
- Produces: `tvSeriesCreditsProvider(int tvId)` now resolves `Future<Credits>` instead of `Future<List<CastMember>>`. `getTVEpisodeCredits`/`tvEpisodeCreditsProvider` are **unchanged** (still `List<CastMember>` — episode-level cast only, out of scope per spec).

- [ ] **Step 1: Update the datasource interface**

In `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart`, add the import `import 'package:filmania/core/data/models/credits_dto.dart';` alongside the existing `cast_member_dto.dart` import (still needed for `getTVEpisodeCredits`), and change only the `getTVSeriesCredits` line:

```dart
  Future<List<CastMemberDto>> getTVSeriesCredits(int tvId);
```

to:

```dart
  Future<CreditsDto> getTVSeriesCredits(int tvId);
```

- [ ] **Step 2: Update the datasource implementation**

In `lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart`, add the import `import 'package:filmania/core/data/models/credits_dto.dart';`, and replace `getTVSeriesCredits` (lines 126-135):

```dart
  @override
  Future<List<CastMemberDto>> getTVSeriesCredits(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId/credits');
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
```

with:

```dart
  @override
  Future<CreditsDto> getTVSeriesCredits(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId/credits');
      return CreditsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
```

`getTVEpisodeCredits` below it (still using `CastMemberDto`/`response.data['cast']`) stays untouched.

- [ ] **Step 3: Update the repository interface**

In `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`, add `import 'package:filmania/core/domain/entities/credits.dart';` next to the existing `cast_member.dart` import (still needed for `getTVEpisodeCredits`), and change only:

```dart
  Future<List<CastMember>> getTVSeriesCredits(int tvId);
```

to:

```dart
  Future<Credits> getTVSeriesCredits(int tvId);
```

- [ ] **Step 4: Update the repository implementation**

In `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart`, add `import 'package:filmania/core/domain/entities/credits.dart';`, and replace `getTVSeriesCredits` (lines 72-76):

```dart
  @override
  Future<List<CastMember>> getTVSeriesCredits(int tvId) async {
    final dtos = await _remoteDataSource.getTVSeriesCredits(tvId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
```

with:

```dart
  @override
  Future<Credits> getTVSeriesCredits(int tvId) async {
    final dto = await _remoteDataSource.getTVSeriesCredits(tvId);
    return dto.toEntity();
  }
```

- [ ] **Step 5: Update the provider**

In `lib/features/tv_series/ui/providers/tv_series_provider.dart`, add `import 'package:filmania/core/domain/entities/credits.dart';`, and replace `tvSeriesCredits` (lines 78-82):

```dart
@Riverpod(keepAlive: true)
Future<List<CastMember>> tvSeriesCredits(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesCredits(tvId);
}
```

with:

```dart
@Riverpod(keepAlive: true)
Future<Credits> tvSeriesCredits(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesCredits(tvId);
}
```

- [ ] **Step 6: Wire `CrewSection` into `tv_series_details_page.dart`**

Add the import `import 'package:filmania/core/widgets/crew_section.dart';` next to the existing `import '../../../../core/widgets/cast_section.dart';` (line 15), and replace `_TVSeriesCastSection` (lines 376-394):

```dart
class _TVSeriesCastSection extends ConsumerWidget {
  final int seriesId;

  const _TVSeriesCastSection({required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(tvSeriesCreditsProvider(seriesId));

    return creditsAsync.when(
      data: (cast) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: CastSection(cast: cast),
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
```

with:

```dart
class _TVSeriesCastSection extends ConsumerWidget {
  final int seriesId;

  const _TVSeriesCastSection({required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(tvSeriesCreditsProvider(seriesId));

    return creditsAsync.when(
      data: (credits) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: CastSection(cast: credits.cast),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: CrewSection(crew: credits.crew),
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 7: Regenerate code and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `dart analyze lib/features/tv_series`
Expected: no errors.
Run: `flutter test`
Expected: all existing tests still PASS.

- [ ] **Step 8: Commit**

```bash
git add lib/features/tv_series
git commit -m "feat: extend TV series credits pipeline with crew, show CrewSection"
```

---

### Task 7: `person` feature — domain + data layers

**Files:**
- Create: `lib/features/person/domain/entities/person.dart`
- Create: `lib/features/person/domain/entities/person_credit.dart`
- Create: `lib/features/person/domain/repositories/i_person_repository.dart`
- Create: `lib/features/person/data/models/person_dto.dart`
- Create: `lib/features/person/data/models/person_credit_dto.dart`
- Create: `lib/features/person/data/models/person_combined_credits_dto.dart`
- Create: `lib/features/person/data/datasources/i_person_remote_datasource.dart`
- Create: `lib/features/person/data/datasources/person_remote_datasource_impl.dart`
- Create: `lib/features/person/data/repositories/person_repository_impl.dart`
- Test: `test/features/person/data/models/person_dto_test.dart`
- Test: `test/features/person/data/models/person_combined_credits_dto_test.dart`

**Interfaces:**
- Consumes: `tmdbClientProvider` (`lib/core/network/tmdb_client.dart`), `NetworkFailure` (`lib/core/network/network_failure.dart`), `MediaType` (`lib/core/domain/enums/media_type.dart`).
- Produces: `Person({id, name, biography, birthday, placeOfBirth, profilePath})` + `fullProfileUrl`; `PersonCredit({mediaId, title, posterPath, releaseYear, voteAverage, mediaType})` + `fullPosterUrl`; `IPersonRepository.getPersonDetails(int)` → `Future<Person>`; `IPersonRepository.getPersonCombinedCredits(int)` → `Future<List<PersonCredit>>`; riverpod providers `personRemoteDataSourceProvider`, `personRepositoryProvider` (consumed by Task 8's `personDetailsProvider`/`personFilmographyProvider`).

- [ ] **Step 1: Create the `Person` entity**

```dart
// lib/features/person/domain/entities/person.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required int id,
    required String name,
    required String biography,
    required DateTime? birthday,
    required String? placeOfBirth,
    required String? profilePath,
  }) = _Person;

  const Person._();

  String? get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w500$profilePath' : null;
}
```

- [ ] **Step 2: Create the `PersonCredit` entity**

```dart
// lib/features/person/domain/entities/person_credit.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';

part 'person_credit.freezed.dart';

@freezed
abstract class PersonCredit with _$PersonCredit {
  const factory PersonCredit({
    required int mediaId,
    required String title,
    required String? posterPath,
    required int? releaseYear,
    required double voteAverage,
    required MediaType mediaType,
  }) = _PersonCredit;

  const PersonCredit._();

  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;
}
```

- [ ] **Step 3: Create the repository interface**

```dart
// lib/features/person/domain/repositories/i_person_repository.dart
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';

abstract class IPersonRepository {
  Future<Person> getPersonDetails(int personId);
  Future<List<PersonCredit>> getPersonCombinedCredits(int personId);
}
```

- [ ] **Step 4: Create `PersonDto`**

```dart
// lib/features/person/data/models/person_dto.dart
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_dto.freezed.dart';
part 'person_dto.g.dart';

@freezed
abstract class PersonDto with _$PersonDto {
  const factory PersonDto({
    required int id,
    required String name,
    String? biography,
    String? birthday,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _PersonDto;

  factory PersonDto.fromJson(Map<String, dynamic> json) =>
      _$PersonDtoFromJson(json);

  const PersonDto._();

  Person toEntity() {
    return Person(
      id: id,
      name: name,
      biography: biography ?? '',
      birthday: birthday != null ? DateTime.tryParse(birthday!) : null,
      placeOfBirth: placeOfBirth,
      profilePath: profilePath,
    );
  }
}
```

- [ ] **Step 5: Create `PersonCreditDto`**

```dart
// lib/features/person/data/models/person_credit_dto.dart
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_credit_dto.freezed.dart';
part 'person_credit_dto.g.dart';

@freezed
abstract class PersonCreditDto with _$PersonCreditDto {
  const factory PersonCreditDto({
    required int id,
    String? title,
    String? name,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'media_type') required MediaType mediaType,
  }) = _PersonCreditDto;

  factory PersonCreditDto.fromJson(Map<String, dynamic> json) =>
      _$PersonCreditDtoFromJson(json);

  const PersonCreditDto._();

  PersonCredit toEntity() {
    final dateStr = releaseDate ?? firstAirDate;
    return PersonCredit(
      mediaId: id,
      title: title ?? name ?? '',
      posterPath: posterPath,
      releaseYear: dateStr != null ? DateTime.tryParse(dateStr)?.year : null,
      voteAverage: voteAverage ?? 0.0,
      mediaType: mediaType,
    );
  }
}
```

`MediaType` deserializes from JSON by exact enum-name match (see `WatchlistItemDto.mediaType`); TMDB's `media_type` field is literally `"movie"` or `"tv"`, so no custom converter is needed.

- [ ] **Step 6: Create `PersonCombinedCreditsDto`**

```dart
// lib/features/person/data/models/person_combined_credits_dto.dart
import 'package:filmania/features/person/data/models/person_credit_dto.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_combined_credits_dto.freezed.dart';
part 'person_combined_credits_dto.g.dart';

@freezed
abstract class PersonCombinedCreditsDto with _$PersonCombinedCreditsDto {
  const factory PersonCombinedCreditsDto({
    @Default([]) List<PersonCreditDto> cast,
    @Default([]) List<PersonCreditDto> crew,
  }) = _PersonCombinedCreditsDto;

  factory PersonCombinedCreditsDto.fromJson(Map<String, dynamic> json) =>
      _$PersonCombinedCreditsDtoFromJson(json);

  const PersonCombinedCreditsDto._();

  List<PersonCredit> toEntity() {
    final seenKeys = <String>{};
    final credits = <PersonCredit>[];

    for (final dto in [...cast, ...crew]) {
      final key = '${dto.mediaType.name}_${dto.id}';
      if (seenKeys.add(key)) {
        credits.add(dto.toEntity());
      }
    }

    credits.sort((a, b) => (b.releaseYear ?? 0).compareTo(a.releaseYear ?? 0));
    return credits;
  }
}
```

Merges `cast` (acting roles) and `crew` (e.g. directing) into one deduplicated, most-recent-first filmography — a person's combined credits can include the same title in both arrays (e.g. actor-director), so dedupe by `mediaType + id`.

- [ ] **Step 7: Write DTO tests**

```dart
// test/features/person/data/models/person_dto_test.dart
import 'package:filmania/features/person/data/models/person_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonDto', () {
    test('fromJson parses all fields', () {
      final dto = PersonDto.fromJson({
        'id': 138,
        'name': 'Quentin Tarantino',
        'biography': 'American filmmaker.',
        'birthday': '1963-03-27',
        'place_of_birth': 'Knoxville, Tennessee, USA',
        'profile_path': '/abc.jpg',
      });

      expect(dto.id, 138);
      expect(dto.name, 'Quentin Tarantino');
      expect(dto.biography, 'American filmmaker.');
      expect(dto.birthday, '1963-03-27');
      expect(dto.placeOfBirth, 'Knoxville, Tennessee, USA');
      expect(dto.profilePath, '/abc.jpg');
    });

    test('toEntity parses birthday into a DateTime and builds fullProfileUrl', () {
      const dto = PersonDto(
        id: 138,
        name: 'Quentin Tarantino',
        biography: 'American filmmaker.',
        birthday: '1963-03-27',
        placeOfBirth: 'Knoxville, Tennessee, USA',
        profilePath: '/abc.jpg',
      );

      final entity = dto.toEntity();

      expect(entity.birthday, DateTime(1963, 3, 27));
      expect(entity.fullProfileUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
    });

    test('toEntity defaults biography to empty string and birthday to null when absent', () {
      const dto = PersonDto(id: 1, name: 'Unknown');

      final entity = dto.toEntity();

      expect(entity.biography, '');
      expect(entity.birthday, isNull);
      expect(entity.fullProfileUrl, isNull);
    });
  });
}
```

```dart
// test/features/person/data/models/person_combined_credits_dto_test.dart
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/person/data/models/person_combined_credits_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonCombinedCreditsDto', () {
    test('toEntity merges cast and crew, most recent first', () {
      final dto = PersonCombinedCreditsDto.fromJson({
        'cast': [
          {
            'id': 1,
            'title': 'Older Movie',
            'release_date': '2000-01-01',
            'vote_average': 7.0,
            'media_type': 'movie',
          },
        ],
        'crew': [
          {
            'id': 2,
            'name': 'Newer Show',
            'first_air_date': '2020-01-01',
            'vote_average': 8.0,
            'media_type': 'tv',
          },
        ],
      });

      final credits = dto.toEntity();

      expect(credits, hasLength(2));
      expect(credits.first.title, 'Newer Show');
      expect(credits.first.mediaType, MediaType.tv);
      expect(credits.last.title, 'Older Movie');
    });

    test('toEntity deduplicates the same media appearing in both cast and crew', () {
      final dto = PersonCombinedCreditsDto.fromJson({
        'cast': [
          {
            'id': 1,
            'title': 'Actor-Director Movie',
            'release_date': '2010-01-01',
            'media_type': 'movie',
          },
        ],
        'crew': [
          {
            'id': 1,
            'title': 'Actor-Director Movie',
            'release_date': '2010-01-01',
            'media_type': 'movie',
          },
        ],
      });

      final credits = dto.toEntity();

      expect(credits, hasLength(1));
    });

    test('fromJson defaults to empty lists when keys are missing', () {
      final dto = PersonCombinedCreditsDto.fromJson(<String, dynamic>{});

      expect(dto.toEntity(), isEmpty);
    });
  });
}
```

- [ ] **Step 8: Create the remote datasource interface**

```dart
// lib/features/person/data/datasources/i_person_remote_datasource.dart
import 'package:filmania/features/person/data/models/person_combined_credits_dto.dart';
import 'package:filmania/features/person/data/models/person_dto.dart';

abstract interface class IPersonRemoteDataSource {
  Future<PersonDto> getPersonDetails(int personId);
  Future<PersonCombinedCreditsDto> getPersonCombinedCredits(int personId);
}
```

- [ ] **Step 9: Create the remote datasource implementation**

```dart
// lib/features/person/data/datasources/person_remote_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:filmania/core/network/network_failure.dart';
import 'package:filmania/features/person/data/datasources/i_person_remote_datasource.dart';
import 'package:filmania/features/person/data/models/person_combined_credits_dto.dart';
import 'package:filmania/features/person/data/models/person_dto.dart';

class PersonRemoteDataSourceImpl implements IPersonRemoteDataSource {
  final Dio _client;

  const PersonRemoteDataSourceImpl(this._client);

  @override
  Future<PersonDto> getPersonDetails(int personId) async {
    try {
      final response = await _client.get('person/$personId');
      return PersonDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<PersonCombinedCreditsDto> getPersonCombinedCredits(int personId) async {
    try {
      final response = await _client.get('person/$personId/combined_credits');
      return PersonCombinedCreditsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
```

- [ ] **Step 10: Create the repository implementation + providers**

```dart
// lib/features/person/data/repositories/person_repository_impl.dart
import 'package:filmania/core/network/tmdb_client.dart';
import 'package:filmania/features/person/data/datasources/i_person_remote_datasource.dart';
import 'package:filmania/features/person/data/datasources/person_remote_datasource_impl.dart';
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:filmania/features/person/domain/repositories/i_person_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person_repository_impl.g.dart';

class PersonRepositoryImpl implements IPersonRepository {
  final IPersonRemoteDataSource _remoteDataSource;

  const PersonRepositoryImpl(this._remoteDataSource);

  @override
  Future<Person> getPersonDetails(int personId) async {
    final dto = await _remoteDataSource.getPersonDetails(personId);
    return dto.toEntity();
  }

  @override
  Future<List<PersonCredit>> getPersonCombinedCredits(int personId) async {
    final dto = await _remoteDataSource.getPersonCombinedCredits(personId);
    return dto.toEntity();
  }
}

@riverpod
IPersonRemoteDataSource personRemoteDataSource(Ref ref) {
  return PersonRemoteDataSourceImpl(ref.watch(tmdbClientProvider));
}

@riverpod
IPersonRepository personRepository(Ref ref) {
  return PersonRepositoryImpl(ref.watch(personRemoteDataSourceProvider));
}
```

- [ ] **Step 11: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/person`
Expected: all 6 tests PASS.
Run: `dart analyze lib/features/person`
Expected: no errors.

- [ ] **Step 12: Commit**

```bash
git add lib/features/person/domain lib/features/person/data test/features/person/data
git commit -m "feat: add person feature domain and data layers"
```

---

### Task 8: `person` feature — UI providers + `PersonDetailsPage`

**Files:**
- Create: `lib/features/person/ui/providers/person_provider.dart`
- Create: `lib/features/person/ui/pages/person_details_page.dart`
- Test: `test/features/person/ui/pages/person_details_page_test.dart`

**Interfaces:**
- Consumes: `IPersonRepository`/`personRepositoryProvider` (Task 7), `Person`/`PersonCredit` (Task 7), `MediaGridCard` (`lib/features/discover/ui/widgets/discover_widgets.dart` — cross-feature reuse, see Global Constraints), `GlassmorphicAppBar`, `AppErrorView`, `AppRoutes` (Task 9 adds `personDetails`; `movieDetails`/`tvDetails` already exist).
- Produces: `personDetailsProvider(int personId)` → `AsyncValue<Person>`; `personFilmographyProvider(int personId)` → `AsyncValue<List<PersonCredit>>`; `PersonDetailsPage({required int personId})`.

- [ ] **Step 1: Create the UI providers**

```dart
// lib/features/person/ui/providers/person_provider.dart
import 'package:filmania/features/person/data/repositories/person_repository_impl.dart';
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person_provider.g.dart';

@riverpod
Future<Person> personDetails(Ref ref, int personId) {
  final repository = ref.watch(personRepositoryProvider);
  return repository.getPersonDetails(personId);
}

@riverpod
Future<List<PersonCredit>> personFilmography(Ref ref, int personId) {
  final repository = ref.watch(personRepositoryProvider);
  return repository.getPersonCombinedCredits(personId);
}
```

- [ ] **Step 2: Create `PersonDetailsPage`**

```dart
// lib/features/person/ui/pages/person_details_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';
import 'package:filmania/core/router/app_router.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/error_view.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:filmania/features/person/ui/providers/person_provider.dart';

class PersonDetailsPage extends ConsumerWidget {
  final int personId;

  const PersonDetailsPage({super.key, required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personDetailsProvider(personId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
      body: personAsync.when(
        data: (person) => _PersonDetailsContent(person: person),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(personDetailsProvider(personId)),
        ),
      ),
    );
  }
}

class _PersonDetailsContent extends StatelessWidget {
  final Person person;

  const _PersonDetailsContent({required this.person});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top),
        ),
        SliverToBoxAdapter(child: _PersonHeader(person: person)),
        SliverToBoxAdapter(child: _PersonFilmographySection(personId: person.id)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
      ],
    );
  }
}

class _PersonHeader extends StatelessWidget {
  final Person person;

  const _PersonHeader({required this.person});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: person.fullProfileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: person.fullProfileUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 320,
                      errorWidget: (context, url, error) => Icon(
                        Icons.person_rounded,
                        size: 64,
                        color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              person.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurfacePrimary,
              ),
            ),
          ),
          if (person.birthday != null || person.placeOfBirth != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                [
                  if (person.birthday != null) _formatDate(person.birthday!),
                  if (person.placeOfBirth != null) person.placeOfBirth!,
                ].join(' · '),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceSecondary),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.biographyTitle,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            person.biography.isNotEmpty ? person.biography : l10n.noBiography,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _PersonFilmographySection extends ConsumerWidget {
  final int personId;

  const _PersonFilmographySection({required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmographyAsync = ref.watch(personFilmographyProvider(personId));

    return filmographyAsync.when(
      data: (credits) {
        if (credits.isEmpty) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context)!;
        final textTheme = Theme.of(context).textTheme;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.filmographyTitle,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: credits.length,
                itemBuilder: (context, index) => _FilmographyCard(credit: credits[index]),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _FilmographyCard extends StatelessWidget {
  final PersonCredit credit;

  const _FilmographyCard({required this.credit});

  @override
  Widget build(BuildContext context) {
    return MediaGridCard(
      mediaId: credit.mediaId,
      title: credit.title,
      posterUrl: credit.fullPosterUrl,
      posterPath: credit.posterPath,
      releaseYear: credit.releaseYear?.toString(),
      voteAverage: credit.voteAverage,
      mediaType: credit.mediaType,
      onTap: () => context.push(
        credit.mediaType == MediaType.movie
            ? AppRoutes.movieDetails.replaceAll(':id', credit.mediaId.toString())
            : AppRoutes.tvDetails.replaceAll(':id', credit.mediaId.toString()),
      ),
    );
  }
}
```

- [ ] **Step 3: Write a widget smoke test**

```dart
// test/features/person/ui/pages/person_details_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:filmania/features/person/ui/pages/person_details_page.dart';
import 'package:filmania/features/person/ui/providers/person_provider.dart';
import 'package:filmania/features/watchlist/ui/providers/watchlist_providers.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

const _person = Person(
  id: 138,
  name: 'Quentin Tarantino',
  biography: 'American filmmaker.',
  birthday: null,
  placeOfBirth: 'Knoxville, Tennessee, USA',
  profilePath: null,
);

const _credits = [
  PersonCredit(
    mediaId: 680,
    title: 'Pulp Fiction',
    posterPath: null,
    releaseYear: 1994,
    voteAverage: 8.5,
    mediaType: MediaType.movie,
  ),
];

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/person/138',
    routes: [
      GoRoute(
        path: '/person/:id',
        builder: (context, state) => const PersonDetailsPage(personId: 138),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      personDetailsProvider(138).overrideWith((ref) => Future.value(_person)),
      personFilmographyProvider(138).overrideWith((ref) => Future.value(_credits)),
      isMediaInWatchlistProvider(
        680,
        MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
      isMediaWatchedProvider(
        mediaId: 680,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
    ],
    child: MaterialApp.router(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows person name, place of birth and biography', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Quentin Tarantino'), findsOneWidget);
    expect(find.textContaining('Knoxville, Tennessee, USA'), findsOneWidget);
    expect(find.text('American filmmaker.'), findsOneWidget);
  });

  testWidgets('shows filmography credit title', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Pulp Fiction'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Generate code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/person`
Expected: all 8 tests PASS (6 from Task 7 + 2 new).
Run: `dart analyze lib/features/person`
Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/person/ui test/features/person/ui
git commit -m "feat: add PersonDetailsPage and person UI providers"
```

---

### Task 9: Wire the `/person/:id` route

**Files:**
- Modify: `lib/core/router/app_router.dart`

**Interfaces:**
- Consumes: `PersonDetailsPage` (Task 8).
- Produces: `AppRoutes.personDetails = '/person/:id'` (consumed by Task 10's `context.push` calls).

- [ ] **Step 1: Import `PersonDetailsPage`**

In `lib/core/router/app_router.dart`, add after line 14 (`import '../../features/tv_series/ui/pages/tv_series_details_page.dart';`):

```dart
import '../../features/person/ui/pages/person_details_page.dart';
```

- [ ] **Step 2: Add the route constant**

Replace line 35-36:

```dart
  static const movieDetails = '/movie/:id';
  static const tvDetails = '/tv/:id';
```

with:

```dart
  static const movieDetails = '/movie/:id';
  static const tvDetails = '/tv/:id';
  static const personDetails = '/person/:id';
```

- [ ] **Step 3: Add the `GoRoute`**

After the `AppRoutes.tvDetails` route block (ends at line 127, right before the `AppRoutes.tvEpisodeDetails` route), insert:

```dart
      GoRoute(
        path: AppRoutes.personDetails,
        builder: (context, state) {
          final rawId = state.pathParameters['id'];
          final id = rawId != null ? int.tryParse(rawId) : null;
          if (id == null) return const Scaffold(body: Center(child: Text('Pagina non trovata')));
          return PersonDetailsPage(personId: id);
        },
      ),
```

- [ ] **Step 4: Regenerate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `dart analyze lib/core/router`
Expected: no errors.
Run: `flutter test`
Expected: all tests still PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "feat: add /person/:id route"
```

---

### Task 10: Make `_CastCard` and `_CrewCard` tappable

**Files:**
- Modify: `lib/core/widgets/cast_section.dart:57-126`
- Modify: `lib/core/widgets/crew_section.dart` (Task 4's `_CrewCard`)
- Test: `test/core/widgets/cast_section_test.dart`

**Interfaces:**
- Consumes: `AppRoutes.personDetails` (Task 9).
- Produces: tapping either card navigates to `/person/:id` via `context.push`.

- [ ] **Step 1: Wrap `_CastCard` in a `GestureDetector`**

In `lib/core/widgets/cast_section.dart`, add the imports:

```dart
import 'package:go_router/go_router.dart';
import 'package:filmania/core/router/app_router.dart';
```

Replace the `_CastCard` build method's `SizedBox` root (lines 67-125):

```dart
    return SizedBox(
      width: 100,
      child: Column(
```

with a `GestureDetector`-wrapped version — the full replacement:

```dart
class _CastCard extends StatelessWidget {
  final CastMember member;

  const _CastCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
        AppRoutes.personDetails.replaceAll(':id', member.id.toString()),
      ),
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: member.fullProfileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: member.fullProfileUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      errorWidget: (context, url, error) => _CastFallback(colors: colors),
                    )
                  : _CastFallback(colors: colors),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              member.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurfacePrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              member.character,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Wrap `_CrewCard` in a `GestureDetector`**

In `lib/core/widgets/crew_section.dart`, add the same two imports (`go_router`, `app_router`), and apply the identical wrapping pattern to `_CrewCard`'s build method — full replacement:

```dart
class _CrewCard extends StatelessWidget {
  final CrewMember member;

  const _CrewCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
        AppRoutes.personDetails.replaceAll(':id', member.id.toString()),
      ),
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: member.fullProfileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: member.fullProfileUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      errorWidget: (context, url, error) => _CrewFallback(colors: colors),
                    )
                  : _CrewFallback(colors: colors),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              member.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurfacePrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              member.job,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Write a navigation test for `CastSection`**

```dart
// test/core/widgets/cast_section_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/widgets/cast_section.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

const _cast = [
  CastMember(id: 500, name: 'Uma Thurman', character: 'The Bride', profilePath: null),
];

void main() {
  testWidgets('tapping a cast card navigates to /person/:id', (tester) async {
    final router = GoRouter(
      initialLocation: '/movie/1',
      routes: [
        GoRoute(
          path: '/movie/1',
          builder: (context, state) => Scaffold(body: const CastSection(cast: _cast)),
        ),
        GoRoute(
          path: '/person/:id',
          builder: (context, state) =>
              Scaffold(body: Text('Person ${state.pathParameters['id']}')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Uma Thurman'));
    await tester.pumpAndSettle();

    expect(find.text('Person 500'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Regenerate and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/core/widgets`
Expected: all tests PASS, including the new navigation test.
Run: `dart analyze lib/core/widgets`
Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/cast_section.dart lib/core/widgets/crew_section.dart test/core/widgets/cast_section_test.dart
git commit -m "feat: make cast/crew cards navigate to person details"
```

---

### Task 11: Final verification

**Files:** none (verification only)

- [ ] **Step 1: Full static analysis**

Run: `dart analyze`
Expected: `No issues found!`

- [ ] **Step 2: Format check**

Run: `dart format --set-exit-if-changed .`
Expected: exit code 0, no files need reformatting.

- [ ] **Step 3: Full test suite**

Run: `flutter test`
Expected: all tests PASS, no failures/skips beyond what already existed before this plan.

- [ ] **Step 4: Manual smoke test**

Run: `flutter run` (or `flutter run --profile`), open any movie detail page, verify:
- Cast section shows as before.
- A new Crew section appears below it with director/writer/etc. cards.
- Tapping any cast or crew card opens the Person Details page with photo, name, birth info, biography, and a filmography grid.
- Tapping a filmography item navigates to that movie/TV series' detail page.
- Repeat on a TV series detail page.

- [ ] **Step 5: No commit** — this task is verification-only, nothing to commit.
