import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/domain/models/crew_member.dart';
import 'package:filmania/ui/core/ui/crew_section.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';

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

  testWidgets('renders a card per crew member with name and job', (
    tester,
  ) async {
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
