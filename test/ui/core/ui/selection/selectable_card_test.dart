import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/ui/core/ui/selection/selectable_card.dart';
import 'package:filmania/ui/core/ui/selection/selection_scope.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(body: SelectionScope<int>(child: child)),
  );
}

void main() {
  testWidgets('plain tap calls onTap when selection mode is inactive', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _harness(
        SelectableCard<int>(
          id: 1,
          onTap: () => tapped = true,
          child: const SizedBox(width: 100, height: 100),
        ),
      ),
    );

    await tester.tap(find.byType(SelectableCard<int>));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('long-press enters selection mode and selects the card', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _harness(
        SelectableCard<int>(
          id: 1,
          onTap: () => tapped = true,
          child: const SizedBox(width: 100, height: 100),
        ),
      ),
    );

    await tester.longPress(find.byType(SelectableCard<int>));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('tap toggles selection instead of navigating once active', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _harness(
        SelectableCard<int>(
          id: 1,
          onTap: () => tapped = true,
          child: const SizedBox(width: 100, height: 100),
        ),
      ),
    );

    await tester.longPress(find.byType(SelectableCard<int>));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.byType(SelectableCard<int>));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  });
}
