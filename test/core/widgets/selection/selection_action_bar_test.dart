import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/core/widgets/selection/selection_action_bar.dart';
import 'package:filmania/core/widgets/selection/selection_scope.dart';
import 'package:filmania/core/theme/app_theme.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(body: SelectionScope<int>(child: child)),
  );
}

void main() {
  testWidgets('renders nothing while selection mode is inactive', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(const SelectionActionBar<int>(actions: [])),
    );
    expect(find.byType(SelectionActionBar<int>), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('shows count, close button, and actions once active', (
    tester,
  ) async {
    var pressedWith = <int>{};
    await tester.pumpWidget(
      _harness(
        Builder(
          builder: (context) {
            return Column(
              children: [
                SelectionActionBar<int>(
                  actions: [
                    SelectionAction<int>(
                      icon: Icons.bookmark_add_rounded,
                      label: 'Aggiungi a lista',
                      onPressed: (selected) async => pressedWith = selected,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => SelectionScope.controllerOf<int>(
                    context,
                    listen: false,
                  ).enter(1),
                  child: const Text('enter'),
                ),
              ],
            );
          },
        ),
      ),
    );

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
