# Multi-Select Framework (Section I) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a reusable long-press multi-select framework (`core/widgets/selection/`) — selection-mode state, a `SelectableCard` gesture wrapper, and a contextual `SelectionActionBar` — then wire it into every clickable movie/TV grid or list in the app: Home (`WatchingCard`, `_FeaturedBentoCard`, `_SecondaryBentoCard`), Discover (`MediaGridCard`), Watchlist detail (`WatchlistMediaCard`), and the Watched list grid.

**Architecture:** A plain-Dart `ChangeNotifier`-based `SelectionController<T>` holds the selected-items `Set<T>`; it is exposed to a subtree via an `InheritedNotifier` (`SelectionScope<T>`) so pages don't need to manage its lifecycle themselves. `T` is always `MediaSelectionItem`, a small value type (`mediaId` + `mediaType` + `title` + `posterPath`) whose `==`/`hashCode` are scoped to `mediaId`+`mediaType` only — this lets the same movie/series dedupe correctly across sections while still carrying the display data bulk actions need (no extra provider look-ups required). `SelectableCard<T>` wraps any existing card widget: long-press enters selection mode and selects that card; while active, a plain tap toggles selection instead of navigating. `SelectionActionBar<T>` renders a top contextual bar with a close button, a live count, and a caller-supplied list of `SelectionAction<T>` (icon + label + `void Function(Set<T> selected)`). No new Riverpod providers are introduced by the framework itself — it is pure widget/state plumbing that pages compose with their existing providers.

**Tech Stack:** Flutter (`ChangeNotifier`, `InheritedNotifier`, `StatefulWidget`), Riverpod (existing providers only, consumed at wiring sites), `flutter_test` widget/unit tests.

## Global Constraints

- Colors: always `AppColors.of(context)`, never `Theme.of(context).colorScheme` / `Colors.black` / hex literals (existing `Colors.white`/`Colors.transparent`/`Colors.black.withValues(alpha:)` usages already present in touched files may stay, no new raw colors).
- Spacing: always `AppSpacing` tokens, never raw doubles for padding.
- No 1px borders/dividers (No-Line Rule).
- `const` everywhere a widget/value can be `const`.
- Widget `build()` max 50 lines; extract private widgets, not private methods returning `Widget`.
- No cross-feature imports. The new `core/widgets/selection/` files may only import `core/domain/enums/media_type.dart` and Flutter SDK — never a feature's own types.
- `ref.watch` only inside `build()`; `ref.read` only inside callbacks.
- Every new public class/function gets a `///` doc comment explaining why it exists, per CLAUDE.md's "Documentation" rule.
- Run `dart analyze` and `dart format --set-exit-if-changed .` after each task; run `flutter test` after the last task.
- Long-press/tap targets must stay ≥48x48 (Accessibility rule) — `SelectableCard`'s selection badge and `SelectionActionBar`'s `IconButton`s already meet this via Flutter's default `IconButton` hit area; do not shrink it.

---

## File Structure

| File | Change |
|---|---|
| `lib/core/domain/enums/media_type.dart` | No change — reused as-is |
| `lib/core/widgets/selection/media_selection_item.dart` | New — `MediaSelectionItem` value type (id-scoped equality) |
| `lib/core/widgets/selection/selection_controller.dart` | New — `SelectionController<T>` (`ChangeNotifier`) |
| `lib/core/widgets/selection/selection_scope.dart` | New — `SelectionScope<T>` (`InheritedNotifier` host) |
| `lib/core/widgets/selection/selectable_card.dart` | New — `SelectableCard<T>` long-press/tap wrapper |
| `lib/core/widgets/selection/selection_action_bar.dart` | New — `SelectionAction<T>` + `SelectionActionBar<T>` |
| `lib/features/watched/ui/widgets/watched_bulk_actions.dart` | New — `toggleWatchedBulk()` helper shared by every wiring site |
| `lib/features/watchlist/ui/widgets/watchlist_picker_sheet.dart` | Add `showBulkWatchlistPicker()` — picks one watchlist, adds N items |
| `lib/features/discover/ui/pages/discover_page.dart` | Wrap grid in `SelectionScope`/`SelectableCard`, add `SelectionActionBar` |
| `lib/features/watchlist/ui/pages/watchlist_detail_page.dart` | Same wiring + "remove from this list" bulk action |
| `lib/features/watched/ui/pages/watched_list_page.dart` | Refactor inline grid item into `_WatchedGridCard`, wire selection |
| `lib/features/home/ui/pages/home_page.dart` | Wrap body in `Stack` + `SelectionScope`, add `SelectionActionBar` |
| `lib/features/home/ui/widgets/home_widgets.dart` | Wrap `WatchingCard`, `_FeaturedBentoCard`, `_SecondaryBentoCard` in `SelectableCard` |
| `test/core/widgets/selection/selection_controller_test.dart` | New |
| `test/core/widgets/selection/selectable_card_test.dart` | New |
| `test/core/widgets/selection/selection_action_bar_test.dart` | New |

---

## Task 1: `MediaSelectionItem`

**Files:**
- Create: `lib/core/widgets/selection/media_selection_item.dart`

**Interfaces:**
- Produces: `class MediaSelectionItem { final int mediaId; final MediaType mediaType; final String title; final String? posterPath; }` with `==`/`hashCode` scoped to `mediaId`+`mediaType`. Every later task depends on this type.

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/foundation.dart';
import '../../domain/enums/media_type.dart';

/// Identifies a movie or TV series inside a multi-select selection [Set].
///
/// Equality is scoped to [mediaId] + [mediaType] only, so the same title
/// deduplicates correctly across sections/providers without requiring an
/// exact match on [title]/[posterPath] — while still carrying enough data
/// for bulk actions (add to watchlist, mark watched) to run without doing
/// an extra provider look-up per selected item.
@immutable
class MediaSelectionItem {
  const MediaSelectionItem({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  final int mediaId;
  final MediaType mediaType;
  final String title;
  final String? posterPath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaSelectionItem &&
          other.mediaId == mediaId &&
          other.mediaType == mediaType);

  @override
  int get hashCode => Object.hash(mediaId, mediaType);
}
```

- [ ] **Step 2: Analyze**

Run: `dart analyze lib/core/widgets/selection/media_selection_item.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/core/widgets/selection/media_selection_item.dart
git commit -m "feat: add MediaSelectionItem value type for multi-select"
```

---

## Task 2: `SelectionController<T>`

**Files:**
- Create: `lib/core/widgets/selection/selection_controller.dart`
- Test: `test/core/widgets/selection/selection_controller_test.dart`

**Interfaces:**
- Consumes: nothing (generic over any `T`).
- Produces: `class SelectionController<T> extends ChangeNotifier { bool get isActive; Set<T> get selected; bool isSelected(T id); void enter(T id); void toggle(T id); void clear(); }`. `SelectionScope`/`SelectableCard`/`SelectionActionBar` all consume this exact API.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/core/widgets/selection/selection_controller.dart';

void main() {
  group('SelectionController', () {
    test('starts inactive with an empty selection', () {
      final controller = SelectionController<int>();
      expect(controller.isActive, isFalse);
      expect(controller.selected, isEmpty);
    });

    test('enter() activates selection mode with exactly one item', () {
      final controller = SelectionController<int>();
      controller.enter(1);
      expect(controller.isActive, isTrue);
      expect(controller.selected, {1});
    });

    test('toggle() adds then removes an item, notifying listeners each time', () {
      final controller = SelectionController<int>();
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.toggle(1);
      expect(controller.isSelected(1), isTrue);
      expect(notifications, 1);

      controller.toggle(1);
      expect(controller.isSelected(1), isFalse);
      expect(controller.isActive, isFalse);
      expect(notifications, 2);
    });

    test('clear() empties the selection and exits selection mode', () {
      final controller = SelectionController<int>();
      controller.enter(1);
      controller.toggle(2);
      controller.clear();
      expect(controller.isActive, isFalse);
      expect(controller.selected, isEmpty);
    });

    test('clear() on an already-empty selection does not notify', () {
      final controller = SelectionController<int>();
      var notifications = 0;
      controller.addListener(() => notifications++);
      controller.clear();
      expect(notifications, 0);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/selection/selection_controller_test.dart`
Expected: FAIL — `Error: Couldn't resolve the package 'filmania' in 'package:filmania/core/widgets/selection/selection_controller.dart'.` (file doesn't exist yet)

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/foundation.dart';

/// Holds the selection-mode state shared by [SelectableCard] and
/// [SelectionActionBar] for one screen. Selection mode is "active"
/// whenever the set is non-empty — there is no separate boolean flag,
/// so deselecting the last item always exits selection mode for free.
class SelectionController<T> extends ChangeNotifier {
  final Set<T> _selected = {};

  bool get isActive => _selected.isNotEmpty;

  Set<T> get selected => Set.unmodifiable(_selected);

  bool isSelected(T id) => _selected.contains(id);

  /// Enters selection mode with exactly [id] selected, discarding any
  /// prior selection. Called on long-press.
  void enter(T id) {
    _selected
      ..clear()
      ..add(id);
    notifyListeners();
  }

  /// Toggles [id] in the current selection. Called on tap while active.
  void toggle(T id) {
    if (!_selected.remove(id)) {
      _selected.add(id);
    }
    notifyListeners();
  }

  /// Exits selection mode entirely.
  void clear() {
    if (_selected.isEmpty) return;
    _selected.clear();
    notifyListeners();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/selection/selection_controller_test.dart`
Expected: `+5: All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/selection/selection_controller.dart test/core/widgets/selection/selection_controller_test.dart
git commit -m "feat: add SelectionController for multi-select state"
```

---

## Task 3: `SelectionScope<T>`

**Files:**
- Create: `lib/core/widgets/selection/selection_scope.dart`

**Interfaces:**
- Consumes: `SelectionController<T>` from Task 2.
- Produces: `class SelectionScope<T> extends StatefulWidget { const SelectionScope({required Widget child}); static SelectionController<T> controllerOf<T>(BuildContext context, {bool listen = true}); }`. `SelectableCard`/`SelectionActionBar` call `SelectionScope.controllerOf<T>(context)` to reach the controller — they never receive it via constructor.

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/widgets.dart';
import 'selection_controller.dart';

/// Hosts one [SelectionController] for a subtree and exposes it via
/// [controllerOf], so pages can drop a grid inside [SelectionScope]
/// without managing the controller's lifecycle themselves — it is
/// created in [State.initState] and disposed automatically.
class SelectionScope<T> extends StatefulWidget {
  const SelectionScope({super.key, required this.child});

  final Widget child;

  /// Reads the nearest [SelectionScope<T>]'s controller. Set [listen] to
  /// false inside callbacks (e.g. `onTap`) to avoid rebuilding on every
  /// selection change; leave it true when building UI that must react to
  /// selection state (e.g. inside [SelectableCard]/[SelectionActionBar]).
  static SelectionController<T> controllerOf<T>(
    BuildContext context, {
    bool listen = true,
  }) {
    final inherited = listen
        ? context
            .dependOnInheritedWidgetOfExactType<_SelectionScopeInherited<T>>()
        : context
            .getInheritedWidgetOfExactType<_SelectionScopeInherited<T>>();
    assert(
      inherited != null,
      'No SelectionScope<$T> found in context. Wrap the grid/list in a '
      'SelectionScope<$T> before using SelectableCard<$T> or '
      'SelectionActionBar<$T>.',
    );
    return inherited!.controller;
  }

  @override
  State<SelectionScope<T>> createState() => _SelectionScopeState<T>();
}

class _SelectionScopeState<T> extends State<SelectionScope<T>> {
  final SelectionController<T> _controller = SelectionController<T>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SelectionScopeInherited<T>(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _SelectionScopeInherited<T> extends InheritedNotifier<SelectionController<T>> {
  const _SelectionScopeInherited({
    required SelectionController<T> controller,
    required super.child,
  }) : super(notifier: controller);

  SelectionController<T> get controller => notifier!;
}
```

- [ ] **Step 2: Analyze**

Run: `dart analyze lib/core/widgets/selection/selection_scope.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/core/widgets/selection/selection_scope.dart
git commit -m "feat: add SelectionScope inherited host widget"
```

---

## Task 4: `SelectableCard<T>`

**Files:**
- Create: `lib/core/widgets/selection/selectable_card.dart`
- Test: `test/core/widgets/selection/selectable_card_test.dart`

**Interfaces:**
- Consumes: `SelectionScope.controllerOf<T>(context)` (Task 3).
- Produces: `class SelectableCard<T> extends StatelessWidget { const SelectableCard({required T id, required VoidCallback onTap, required Widget child}); }`. Every wiring task (6-9) wraps its existing card widget with this.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/core/widgets/selection/selectable_card.dart';
import 'package:filmania/core/widgets/selection/selection_scope.dart';
import 'package:filmania/core/theme/app_theme.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(
      body: SelectionScope<int>(child: child),
    ),
  );
}

void main() {
  testWidgets('plain tap calls onTap when selection mode is inactive',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(_harness(
      SelectableCard<int>(
        id: 1,
        onTap: () => tapped = true,
        child: const SizedBox(width: 100, height: 100),
      ),
    ));

    await tester.tap(find.byType(SelectableCard<int>));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('long-press enters selection mode and selects the card',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(_harness(
      SelectableCard<int>(
        id: 1,
        onTap: () => tapped = true,
        child: const SizedBox(width: 100, height: 100),
      ),
    ));

    await tester.longPress(find.byType(SelectableCard<int>));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('tap toggles selection instead of navigating once active',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(_harness(
      SelectableCard<int>(
        id: 1,
        onTap: () => tapped = true,
        child: const SizedBox(width: 100, height: 100),
      ),
    ));

    await tester.longPress(find.byType(SelectableCard<int>));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.byType(SelectableCard<int>));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/selection/selectable_card_test.dart`
Expected: FAIL — `selectable_card.dart` does not exist yet.

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'selection_controller.dart';
import 'selection_scope.dart';

/// Wraps any existing card [child] with long-press-to-select behaviour.
///
/// While the nearest [SelectionScope<T>] is inactive, a tap calls [onTap]
/// as before and a long-press enters selection mode with this card
/// selected. Once selection mode is active (any card in the scope is
/// selected), a tap on *any* [SelectableCard] toggles its own selection
/// instead of calling [onTap] — this is what lets a single tap select
/// multiple cards without repeated long-presses.
class SelectableCard<T> extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.id,
    required this.onTap,
    required this.child,
  });

  final T id;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = SelectionScope.controllerOf<T>(context);
    final colors = AppColors.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final active = controller.isActive;
        final selected = controller.isSelected(id);

        return Semantics(
          container: true,
          selected: active ? selected : null,
          child: GestureDetector(
            onTap: () => active ? controller.toggle(id) : onTap(),
            onLongPress: () {
              if (!active) controller.enter(id);
            },
            child: Stack(
              children: [
                child,
                if (active)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: selected ? 1 : 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(AppSpacing.radius),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (active)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected ? colors.primary : Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/selection/selectable_card_test.dart`
Expected: `+3: All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/selection/selectable_card.dart test/core/widgets/selection/selectable_card_test.dart
git commit -m "feat: add SelectableCard long-press selection wrapper"
```

---

## Task 5: `SelectionAction<T>` + `SelectionActionBar<T>`

**Files:**
- Create: `lib/core/widgets/selection/selection_action_bar.dart`
- Test: `test/core/widgets/selection/selection_action_bar_test.dart`

**Interfaces:**
- Consumes: `SelectionScope.controllerOf<T>(context)` (Task 3).
- Produces: `class SelectionAction<T> { const SelectionAction({required IconData icon, required String label, required void Function(Set<T> selected) onPressed}); }` and `class SelectionActionBar<T> extends StatelessWidget { const SelectionActionBar({required List<SelectionAction<T>> actions}); }`. Wiring tasks 6-9 build one `List<SelectionAction<T>>` each and pass it here.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/core/widgets/selection/selection_action_bar.dart';
import 'package:filmania/core/widgets/selection/selection_scope.dart';
import 'package:filmania/core/widgets/selection/selection_controller.dart';
import 'package:filmania/core/theme/app_theme.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: SelectionScope<int>(child: child)),
  );
}

void main() {
  testWidgets('renders nothing while selection mode is inactive',
      (tester) async {
    await tester.pumpWidget(_harness(
      const SelectionActionBar<int>(actions: []),
    ));
    expect(find.byType(SelectionActionBar<int>), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('shows count, close button, and actions once active',
      (tester) async {
    var pressedWith = <int>{};
    await tester.pumpWidget(_harness(
      Builder(builder: (context) {
        return Column(
          children: [
            SelectionActionBar<int>(
              actions: [
                SelectionAction<int>(
                  icon: Icons.bookmark_add_rounded,
                  label: 'Aggiungi a lista',
                  onPressed: (selected) => pressedWith = selected,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () =>
                  SelectionScope.controllerOf<int>(context, listen: false)
                      .enter(1),
              child: const Text('enter'),
            ),
          ],
        );
      }),
    ));

    await tester.tap(find.text('enter'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_add_rounded));
    await tester.pump();
    expect(pressedWith, {1});

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/selection/selection_action_bar_test.dart`
Expected: FAIL — `selection_action_bar.dart` does not exist yet.

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'selection_scope.dart';

/// One action shown in a [SelectionActionBar], applied in bulk to every
/// item currently selected.
class SelectionAction<T> {
  const SelectionAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final void Function(Set<T> selected) onPressed;
}

/// Contextual bar shown while a [SelectionScope<T>] is active: a close
/// button that exits selection mode, a live selected-count, and the
/// caller's [actions] applied in bulk to the current selection.
///
/// Place it wherever the screen's layout has room (e.g. above a grid, or
/// `Positioned` at the top of a `Stack`) — it renders as `SizedBox.shrink`
/// while inactive, so it can always be mounted unconditionally.
class SelectionActionBar<T> extends StatelessWidget {
  const SelectionActionBar({super.key, required this.actions});

  final List<SelectionAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    final controller = SelectionScope.controllerOf<T>(context);
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (!controller.isActive) return const SizedBox.shrink();
        final selected = controller.selected;

        return Material(
          color: colors.surface,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Tooltip(
                    message: 'Chiudi selezione',
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: controller.clear,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${selected.length}',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfacePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  for (final action in actions)
                    Tooltip(
                      message: action.label,
                      child: IconButton(
                        icon: Icon(action.icon),
                        onPressed: () => action.onPressed(selected),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/selection/selection_action_bar_test.dart`
Expected: `+2: All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/selection/selection_action_bar.dart test/core/widgets/selection/selection_action_bar_test.dart
git commit -m "feat: add SelectionActionBar contextual bulk-action bar"
```

---

## Task 6: Shared bulk-action helpers

**Files:**
- Create: `lib/features/watched/ui/widgets/watched_bulk_actions.dart`
- Modify: `lib/features/watchlist/ui/widgets/watchlist_picker_sheet.dart`

**Interfaces:**
- Consumes: `MediaSelectionItem` (Task 1), `watchedRepositoryProvider`/`isMediaWatchedProvider`/`watchedItemsProvider` (existing, `lib/features/watched/ui/providers/watched_providers.dart` + `lib/features/watched/data/repositories/watched_repository_impl.dart`), `authStateProvider` (existing, `lib/features/auth/ui/providers/auth_notifier.dart`), `userWatchlistsProvider`/`watchlistProvider` (existing, `lib/features/watchlist/ui/providers/watchlist_providers.dart`).
- Produces: `Future<void> toggleWatchedBulk(WidgetRef ref, {required List<MediaSelectionItem> items})` and `Future<void> showBulkWatchlistPicker(BuildContext context, WidgetRef ref, {required List<MediaSelectionItem> items})`. Tasks 7-10's action bars call these directly — this is the DRY point so the loop-and-invalidate logic exists exactly once.

- [ ] **Step 1: Write `watched_bulk_actions.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../domain/entities/watched_item.dart';
import '../providers/watched_providers.dart';

/// Toggles watched status for every item in [items], one at a time,
/// mirroring the per-item logic in `WatchedButton`. An already-watched
/// item is removed from watched; an unwatched item is marked watched.
/// Used by every multi-select action bar's "mark watched/unwatched" action
/// so the toggle-and-invalidate logic exists in exactly one place.
Future<void> toggleWatchedBulk(
  WidgetRef ref, {
  required List<MediaSelectionItem> items,
}) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return;
  final repo = ref.read(watchedRepositoryProvider);

  for (final item in items) {
    final isWatched = await ref.read(
      isMediaWatchedProvider(
        mediaId: item.mediaId,
        mediaType: item.mediaType,
      ).future,
    );

    if (isWatched) {
      await repo.removeFromWatched(
        userId: user.id,
        mediaId: item.mediaId,
        mediaType: item.mediaType,
      );
    } else {
      await repo.markAsWatched(
        WatchedItem(
          id: '',
          userId: user.id,
          mediaId: item.mediaId,
          mediaTitle: item.title,
          mediaType: item.mediaType,
          posterPath: item.posterPath,
          watchedAt: DateTime.now(),
        ),
      );
    }

    ref.invalidate(
      isMediaWatchedProvider(mediaId: item.mediaId, mediaType: item.mediaType),
    );
    ref.invalidate(watchedItemsProvider(item.mediaType));
  }
}
```

- [ ] **Step 2: Add `showBulkWatchlistPicker` to `watchlist_picker_sheet.dart`**

Append to `lib/features/watchlist/ui/widgets/watchlist_picker_sheet.dart` (after the existing `showWatchlistPicker` function, keep both — the single-item flow is unchanged):

```dart
import '../../../../core/widgets/selection/media_selection_item.dart';

/// Bulk variant of [showWatchlistPicker]: lets the user pick ONE
/// watchlist, then adds every item in [items] to it. Used by the
/// multi-select action bar's "Aggiungi a lista" action — unlike the
/// single-item sheet, it does not show per-item membership state,
/// since [items] can be a mix of titles already in different lists.
Future<void> showBulkWatchlistPicker(
  BuildContext context,
  WidgetRef ref, {
  required List<MediaSelectionItem> items,
}) async {
  final watchlists = await ref.read(userWatchlistsProvider.future);
  if (!context.mounted) return;

  final chosenId = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (sheetContext) {
      final colors = AppColors.of(sheetContext);
      final textTheme = Theme.of(sheetContext).textTheme;
      return Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: SafeArea(
          top: false,
          child: watchlists.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'Nessuna lista disponibile. Creane una dal dettaglio '
                    'di un titolo.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    for (final watchlist in watchlists)
                      ListTile(
                        leading: Icon(
                          Icons.bookmark_outline_rounded,
                          color: colors.onSurfacePrimary,
                        ),
                        title: Text(
                          watchlist.name,
                          style: TextStyle(color: colors.onSurfacePrimary),
                        ),
                        onTap: () =>
                            Navigator.of(sheetContext).pop(watchlist.id),
                      ),
                  ],
                ),
        ),
      );
    },
  );

  if (chosenId == null || !context.mounted) return;
  final notifier = ref.read(watchlistProvider.notifier);
  for (final item in items) {
    await notifier.addItem(
      watchlistId: chosenId,
      id: item.mediaId,
      title: item.title,
      posterPath: item.posterPath,
      type: item.mediaType,
    );
  }
}
```

- [ ] **Step 3: Analyze**

Run: `dart analyze lib/features/watched/ui/widgets/watched_bulk_actions.dart lib/features/watchlist/ui/widgets/watchlist_picker_sheet.dart`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/features/watched/ui/widgets/watched_bulk_actions.dart lib/features/watchlist/ui/widgets/watchlist_picker_sheet.dart
git commit -m "feat: add shared bulk watched/watchlist action helpers"
```

---

## Task 7: Wire Discover page

**Files:**
- Modify: `lib/features/discover/ui/pages/discover_page.dart`

**Interfaces:**
- Consumes: `SelectionScope`, `SelectableCard`, `SelectionActionBar`, `SelectionAction`, `MediaSelectionItem` (Tasks 1-5); `toggleWatchedBulk`, `showBulkWatchlistPicker` (Task 6).

- [ ] **Step 1: Add imports**

In `lib/features/discover/ui/pages/discover_page.dart`, add:

```dart
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../../core/widgets/selection/selectable_card.dart';
import '../../../../core/widgets/selection/selection_action_bar.dart';
import '../../../../core/widgets/selection/selection_scope.dart';
import '../../../watched/ui/widgets/watched_bulk_actions.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';
```

- [ ] **Step 2: Wrap the `Scaffold.body` in `SelectionScope` + `Stack` + action bar**

Replace (`discover_page.dart:36-42`, the `Scaffold` return):

```dart
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
```

with:

```dart
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: SelectionScope<MediaSelectionItem>(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
```

(closing the added `Stack`/`SelectionScope` after the existing `slivers` list and the pre-existing closing `)` for `CustomScrollView`/`body:` — see Step 3 for the exact closing edit.)

- [ ] **Step 3: Close the new wrappers and add the action bar**

Find the end of the sliver list / `CustomScrollView` (the closing of `body: CustomScrollView(... slivers: [ ... ],)` before the `Scaffold`'s own closing `)`), and change it from:

```dart
        ],
      ),
    );
  }
```

to:

```dart
              ],
            ),
            SelectionActionBar<MediaSelectionItem>(
              actions: [
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.bookmark_add_rounded,
                  label: 'Aggiungi a lista',
                  onPressed: (selected) => showBulkWatchlistPicker(
                    context,
                    ref,
                    items: selected.toList(),
                  ),
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_rounded,
                  label: 'Segna come visto/non visto',
                  onPressed: (selected) =>
                      toggleWatchedBulk(ref, items: selected.toList()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
```

- [ ] **Step 4: Wrap each `MediaGridCard` in `SelectableCard`**

Replace (`discover_page.dart:676-703`, the `SliverChildBuilderDelegate`):

```dart
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              if (selectedMediaType == DiscoverMediaType.movie) {
                return MediaGridCard.movie(
                  movie: item,
                  onTap: () {
                    context.push(
                      AppRoutes.movieDetails.replaceFirst(
                        ':id',
                        item.id.toString(),
                      ),
                    );
                  },
                );
              } else {
                return MediaGridCard.tv(
                  tv: item,
                  onTap: () {
                    context.push(
                      AppRoutes.tvDetails.replaceFirst(
                        ':id',
                        item.id.toString(),
                      ),
                    );
                  },
                );
              }
            }, childCount: items.length),
```

with:

```dart
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              if (selectedMediaType == DiscoverMediaType.movie) {
                final selectionId = MediaSelectionItem(
                  mediaId: item.id,
                  mediaType: MediaType.movie,
                  title: item.title,
                  posterPath: item.posterPath,
                );
                return SelectableCard<MediaSelectionItem>(
                  id: selectionId,
                  onTap: () => context.push(
                    AppRoutes.movieDetails.replaceFirst(
                      ':id',
                      item.id.toString(),
                    ),
                  ),
                  child: MediaGridCard.movie(movie: item),
                );
              } else {
                final selectionId = MediaSelectionItem(
                  mediaId: item.id,
                  mediaType: MediaType.tv,
                  title: item.name,
                  posterPath: item.posterPath,
                );
                return SelectableCard<MediaSelectionItem>(
                  id: selectionId,
                  onTap: () => context.push(
                    AppRoutes.tvDetails.replaceFirst(
                      ':id',
                      item.id.toString(),
                    ),
                  ),
                  child: MediaGridCard.tv(tv: item),
                );
              }
            }, childCount: items.length),
```

`MediaType` is already imported transitively via `discover_widgets.dart`'s re-export path — if `dart analyze` flags it as undefined in Step 5, add `import 'package:filmania/core/domain/enums/media_type.dart';` explicitly.

- [ ] **Step 5: Analyze and format**

Run: `dart analyze lib/features/discover/ui/pages/discover_page.dart && dart format lib/features/discover/ui/pages/discover_page.dart`
Expected: `No issues found!`, then a formatted-file confirmation.

- [ ] **Step 6: Commit**

```bash
git add lib/features/discover/ui/pages/discover_page.dart
git commit -m "feat: wire multi-select into Discover grid"
```

---

## Task 8: Wire Watchlist detail page

**Files:**
- Modify: `lib/features/watchlist/ui/pages/watchlist_detail_page.dart`

**Interfaces:**
- Consumes: same as Task 7, plus `watchlistProvider.notifier.removeItemFromWatchlist` (existing, `lib/features/watchlist/ui/providers/watchlist_providers.dart:100-118`).

- [ ] **Step 1: Add imports**

```dart
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../../core/widgets/selection/selectable_card.dart';
import '../../../../core/widgets/selection/selection_action_bar.dart';
import '../../../../core/widgets/selection/selection_scope.dart';
import '../../../watched/ui/widgets/watched_bulk_actions.dart';
import '../widgets/watchlist_picker_sheet.dart';
```

- [ ] **Step 2: Wrap `Scaffold.body`**

Same pattern as Task 7 Step 2/3: change `body: CustomScrollView(...)` (`watchlist_detail_page.dart:37`) to `body: SelectionScope<MediaSelectionItem>(child: Stack(children: [CustomScrollView(...), SelectionActionBar<MediaSelectionItem>(actions: [...])]))`, with these three actions:

```dart
              actions: [
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.delete_outline_rounded,
                  label: 'Rimuovi dalla lista',
                  onPressed: (selected) async {
                    final notifier = ref.read(watchlistProvider.notifier);
                    for (final item in selected) {
                      await notifier.removeItemFromWatchlist(
                        watchlistId: watchlistId,
                        mediaId: item.mediaId,
                        mediaType: item.mediaType,
                      );
                    }
                  },
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.bookmark_add_rounded,
                  label: 'Aggiungi a lista',
                  onPressed: (selected) => showBulkWatchlistPicker(
                    context,
                    ref,
                    items: selected.toList(),
                  ),
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_rounded,
                  label: 'Segna come visto/non visto',
                  onPressed: (selected) =>
                      toggleWatchedBulk(ref, items: selected.toList()),
                ),
              ],
```

- [ ] **Step 3: Wrap each `WatchlistMediaCard` in `SelectableCard`**

Replace (`watchlist_detail_page.dart:118-143`, inside `SliverChildBuilderDelegate`):

```dart
                    (context, index) {
                      final item = items[index];
                      return WatchlistMediaCard(
                        item: item,
                        onTap: () {
                          if (item.mediaType == MediaType.movie) {
                            context.push(
                              AppRoutes.movieDetails.replaceFirst(
                                  ':id', item.mediaId.toString()),
                            );
                          } else {
                            context.push(
                              AppRoutes.tvDetails.replaceFirst(
                                  ':id', item.mediaId.toString()),
                            );
                          }
                        },
                        onRemove: () => ref
                            .read(watchlistProvider.notifier)
                            .removeItemFromWatchlist(
                              watchlistId: watchlistId,
                              mediaId: item.mediaId,
                              mediaType: item.mediaType,
                            ),
                      );
                    },
```

with:

```dart
                    (context, index) {
                      final item = items[index];
                      return SelectableCard<MediaSelectionItem>(
                        id: MediaSelectionItem(
                          mediaId: item.mediaId,
                          mediaType: item.mediaType,
                          title: item.title,
                          posterPath: item.posterPath,
                        ),
                        onTap: () {
                          if (item.mediaType == MediaType.movie) {
                            context.push(
                              AppRoutes.movieDetails.replaceFirst(
                                  ':id', item.mediaId.toString()),
                            );
                          } else {
                            context.push(
                              AppRoutes.tvDetails.replaceFirst(
                                  ':id', item.mediaId.toString()),
                            );
                          }
                        },
                        child: WatchlistMediaCard(
                          item: item,
                          onRemove: () => ref
                              .read(watchlistProvider.notifier)
                              .removeItemFromWatchlist(
                                watchlistId: watchlistId,
                                mediaId: item.mediaId,
                                mediaType: item.mediaType,
                              ),
                        ),
                      );
                    },
```

(`WatchlistMediaCard.onTap` is left unset — the card's own tap area is now covered by `SelectableCard`'s `GestureDetector`; `onRemove`'s bookmark icon keeps working since it's a separate inner `GestureDetector` per Task-context notes.)

- [ ] **Step 4: Analyze and format**

Run: `dart analyze lib/features/watchlist/ui/pages/watchlist_detail_page.dart && dart format lib/features/watchlist/ui/pages/watchlist_detail_page.dart`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/watchlist/ui/pages/watchlist_detail_page.dart
git commit -m "feat: wire multi-select into Watchlist detail grid"
```

---

## Task 9: Wire Watched list page

**Files:**
- Modify: `lib/features/watched/ui/pages/watched_list_page.dart`

**Interfaces:**
- Consumes: same as Task 7. Produces `_WatchedGridCard`, a private widget extracted from the current inline `GestureDetector`/`Container` so it can be wrapped by `SelectableCard`.

- [ ] **Step 1: Add imports**

```dart
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../../core/widgets/selection/selectable_card.dart';
import '../../../../core/widgets/selection/selection_action_bar.dart';
import '../../../../core/widgets/selection/selection_scope.dart';
import '../widgets/watched_bulk_actions.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';
```

- [ ] **Step 2: Extract `_WatchedGridCard` and wire selection into `_buildGrid`**

Replace the `_buildGrid` method (`watched_list_page.dart:112-168`) body's `itemBuilder` — keep the empty-state branch and `GridView.builder`/`gridDelegate` unchanged, replace only the `itemBuilder` closure:

```dart
    itemBuilder: (context, index) {
      final item = items[index];
      return GestureDetector(
        onTap: () {
          final path = item.mediaType == MediaType.movie
              ? AppRoutes.movieDetails.replaceAll(':id', item.mediaId.toString())
              : AppRoutes.tvDetails.replaceAll(':id', item.mediaId.toString());
          context.push(path);
        },
        child: Container( /* ... poster via Image.network ... */ ),
      );
    },
```

with:

```dart
    itemBuilder: (context, index) {
      final item = items[index];
      return SelectableCard<MediaSelectionItem>(
        id: MediaSelectionItem(
          mediaId: item.mediaId,
          mediaType: item.mediaType,
          title: item.mediaTitle,
          posterPath: item.posterPath,
        ),
        onTap: () {
          final path = item.mediaType == MediaType.movie
              ? AppRoutes.movieDetails.replaceAll(':id', item.mediaId.toString())
              : AppRoutes.tvDetails.replaceAll(':id', item.mediaId.toString());
          context.push(path);
        },
        child: _WatchedGridCard(item: item),
      );
    },
```

Then extract the existing `Container`/`ClipRRect`/`Image.network` markup (verbatim, unchanged) into a new private widget appended to the bottom of the file:

```dart
class _WatchedGridCard extends StatelessWidget {
  const _WatchedGridCard({required this.item});

  final WatchedItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: item.posterPath != null
          ? Image.network(
              'https://image.tmdb.org/t/p/w342${item.posterPath}',
              fit: BoxFit.cover,
            )
          : Container(color: AppColors.of(context).surface),
    );
  }
}
```

(Copy the exact existing poster-rendering markup from `watched_list_page.dart:112-168` into this widget rather than the illustrative version above — the goal is a lossless extraction, not a rewrite.)

- [ ] **Step 3: Add the action bar to `_buildMoviesScaffold`**

In `_buildMoviesScaffold` (`watched_list_page.dart:30-56`), wrap `body:` in `SelectionScope`/`Stack`, same pattern as Task 7:

```dart
      body: SelectionScope<MediaSelectionItem>(
        child: Stack(
          children: [
            asyncItems.when(
              data: (items) => _buildGrid(context, items, colors, textTheme, l10n),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => AppErrorView(error: err),
            ),
            SelectionActionBar<MediaSelectionItem>(
              actions: [
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.bookmark_add_rounded,
                  label: 'Aggiungi a lista',
                  onPressed: (selected) => showBulkWatchlistPicker(
                    context,
                    ref,
                    items: selected.toList(),
                  ),
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_off_rounded,
                  label: 'Segna come non visto',
                  onPressed: (selected) =>
                      toggleWatchedBulk(ref, items: selected.toList()),
                ),
              ],
            ),
          ],
        ),
      ),
```

- [ ] **Step 4: Add the action bar to `_buildTvSeriesScaffold`**

In `_buildTvSeriesScaffold` (`watched_list_page.dart:58-110`), the `AppBar.bottom` is occupied by the `TabBar`, so wrap `body: TabBarView(...)` the same way — `body: SelectionScope<MediaSelectionItem>(child: Stack(children: [TabBarView(...), SelectionActionBar<MediaSelectionItem>(actions: [...])]))` — reuse the identical two-action list from Step 3 (same helper functions apply regardless of movie/tv).

- [ ] **Step 5: Analyze and format**

Run: `dart analyze lib/features/watched/ui/pages/watched_list_page.dart && dart format lib/features/watched/ui/pages/watched_list_page.dart`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/watched/ui/pages/watched_list_page.dart
git commit -m "feat: wire multi-select into Watched list grids"
```

---

## Task 10: Wire Home page

**Files:**
- Modify: `lib/features/home/ui/pages/home_page.dart`
- Modify: `lib/features/home/ui/widgets/home_widgets.dart`

**Interfaces:**
- Consumes: same as Task 7.

- [ ] **Step 1: Add imports to `home_page.dart`**

```dart
import '../../../core/widgets/selection/media_selection_item.dart';
import '../../../core/widgets/selection/selection_action_bar.dart';
import '../../../core/widgets/selection/selection_scope.dart';
import '../../watched/ui/widgets/watched_bulk_actions.dart';
import '../../watchlist/ui/widgets/watchlist_picker_sheet.dart';
```

- [ ] **Step 2: Wrap `Scaffold.body`**

Replace (`home_page.dart:20-42`, the `Scaffold`):

```dart
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ...existing slivers...
        ],
      ),
    );
```

with:

```dart
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: SelectionScope<MediaSelectionItem>(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ...existing slivers, unchanged...
              ],
            ),
            SelectionActionBar<MediaSelectionItem>(
              actions: [
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.bookmark_add_rounded,
                  label: 'Aggiungi a lista',
                  onPressed: (selected) => showBulkWatchlistPicker(
                    context,
                    ref,
                    items: selected.toList(),
                  ),
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_rounded,
                  label: 'Segna come visto/non visto',
                  onPressed: (selected) =>
                      toggleWatchedBulk(ref, items: selected.toList()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
```

- [ ] **Step 3: Wrap `WatchingCard` in `SelectableCard`**

In `home_widgets.dart`'s `_TrendingMoviesList` (lines 101-130), where each `Movie` builds a `WatchingCard` (line 119), wrap the returned `WatchingCard` with `SelectableCard<MediaSelectionItem>`:

```dart
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../../core/widgets/selection/selectable_card.dart';
```

```dart
itemBuilder: (context, index) {
  final movie = movies[index];
  return SelectableCard<MediaSelectionItem>(
    id: MediaSelectionItem(
      mediaId: movie.id,
      mediaType: MediaType.movie,
      title: movie.title,
      posterPath: movie.posterPath,
    ),
    onTap: () => context.push(
      AppRoutes.movieDetails.replaceAll(':id', movie.id.toString()),
    ),
    child: WatchingCard(
      mediaId: movie.id,
      title: movie.title,
      subtitle: /* existing subtitle expression, unchanged */,
      imageUrl: /* existing imageUrl expression, unchanged */,
      posterPath: movie.posterPath,
    ),
  );
},
```

`WatchingCard`'s own outer `GestureDetector.onTap` (`home_widgets.dart:154-157`) becomes dead code once wrapped — remove that `onTap` from `WatchingCard`'s `build()` (change the outer `GestureDetector(onTap: () {...}, child: ...)` to a plain non-tappable container, e.g. swap `GestureDetector` for the bare `child` it wraps) so the tap area isn't double-handled.

- [ ] **Step 4: Wrap `_FeaturedBentoCard` and `_SecondaryBentoCard`**

In `_CuratedContent` (`home_widgets.dart:591-618`), wrap both card instantiations:

```dart
SelectableCard<MediaSelectionItem>(
  id: MediaSelectionItem(
    mediaId: movies[0].id,
    mediaType: MediaType.movie,
    title: movies[0].title,
    posterPath: movies[0].posterPath,
  ),
  onTap: () => context.push(
    AppRoutes.movieDetails.replaceAll(':id', movies[0].id.toString()),
  ),
  child: _FeaturedBentoCard(movie: movies[0]),
),
if (movies.length > 1)
  SelectableCard<MediaSelectionItem>(
    id: MediaSelectionItem(
      mediaId: movies[1].id,
      mediaType: MediaType.movie,
      title: movies[1].title,
      posterPath: movies[1].posterPath,
    ),
    onTap: () => context.push(
      AppRoutes.movieDetails.replaceAll(':id', movies[1].id.toString()),
    ),
    child: _SecondaryBentoCard(movie: movies[1], containerColor: /* existing */),
  ),
```

As in Step 3, remove the now-redundant outer `GestureDetector.onTap` from both `_FeaturedBentoCard` (`home_widgets.dart:629-632`) and `_SecondaryBentoCard` (`home_widgets.dart:820-823`) `build()` methods, keeping their internal `_FeaturedBentoButton`/watchlist buttons untouched (those are separate, deliberate taps, not card navigation).

- [ ] **Step 5: Analyze and format**

Run: `dart analyze lib/features/home/ui/pages/home_page.dart lib/features/home/ui/widgets/home_widgets.dart && dart format lib/features/home/ui/pages/home_page.dart lib/features/home/ui/widgets/home_widgets.dart`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/home/ui/pages/home_page.dart lib/features/home/ui/widgets/home_widgets.dart
git commit -m "feat: wire multi-select into Home trending/curated cards"
```

---

## Task 11: Full verification pass

**Files:** none (verification only)

- [ ] **Step 1: Full analyze**

Run: `dart analyze`
Expected: `No issues found!`

- [ ] **Step 2: Full format check**

Run: `dart format --set-exit-if-changed .`
Expected: exit code 0, no files listed.

- [ ] **Step 3: Full test suite**

Run: `flutter test`
Expected: all tests pass, including the new `test/core/widgets/selection/*` tests from Tasks 2/4/5.

- [ ] **Step 4: Manual smoke check (documented, not automated)**

Run `flutter run`, then on Discover/Watchlist-detail/Watched-list/Home: long-press a card → confirm selection mode activates with a checkmark overlay and the action bar appears; tap a second card → confirm it toggles selection (no navigation); tap the close button → confirm selection mode exits and normal tap-to-navigate resumes. Note the result in the PR description — this plan cannot execute a live device/emulator run itself.

- [ ] **Step 5: Commit (only if Step 4 uncovered fixes)**

```bash
git add -A
git commit -m "fix: address issues found in multi-select smoke test"
```
