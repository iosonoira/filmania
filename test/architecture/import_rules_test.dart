import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps the folder structure of the official Flutter architecture case
/// study (docs.flutter.dev/app-architecture/case-study) honest: data and
/// domain are shared, the UI is organised by feature, and a rule written
/// only in CLAUDE.md is easy to break without noticing.
void main() {
  final imports = _projectImports();

  test('a feature never imports another feature', () {
    final violations = [
      for (final i in imports)
        if (_feature(i.from) case final from?)
          if (_feature(i.to) case final to? when to != from) i,
    ];
    expect(violations, isEmpty, reason: _describe(violations));
  });

  test('ui/core never imports a feature', () {
    final violations = [
      for (final i in imports)
        if (i.from.startsWith('ui/core/') && _feature(i.to) != null) i,
    ];
    expect(violations, isEmpty, reason: _describe(violations));
  });

  test('data never imports ui or routing', () {
    final violations = [
      for (final i in imports)
        if (i.from.startsWith('data/') &&
            (i.to.startsWith('ui/') || i.to.startsWith('routing/')))
          i,
    ];
    expect(violations, isEmpty, reason: _describe(violations));
  });

  test('repositories are not aware of each other', () {
    // The session (auth_providers.dart) is the one shared input: providers
    // need the signed-in user's id to scope their reads.
    final violations = [
      for (final i in imports)
        if (_repository(i.from) case final from?)
          if (_repository(i.to) case final to?
              when to != from &&
                  i.to != 'data/repositories/auth/auth_providers.dart')
            i,
    ];
    expect(violations, isEmpty, reason: _describe(violations));
  });

  test('domain models and failures depend only on the domain', () {
    final violations = [
      for (final i in imports)
        if ((i.from.startsWith('domain/models/') ||
                i.from.startsWith('domain/failures/')) &&
            !i.to.startsWith('domain/models/') &&
            !i.to.startsWith('domain/failures/'))
          i,
    ];
    expect(violations, isEmpty, reason: _describe(violations));
  });

  test('use cases never import ui or routing', () {
    final violations = [
      for (final i in imports)
        if (i.from.startsWith('domain/use_cases/') &&
            (i.to.startsWith('ui/') || i.to.startsWith('routing/')))
          i,
    ];
    expect(violations, isEmpty, reason: _describe(violations));
  });
}

typedef _Import = ({String from, String to});

final _directive = RegExp(
  r"^(?:import|export)\s+'package:filmania/([^']+)'",
  multiLine: true,
);

/// Every `package:filmania/` import in lib/, as paths relative to lib/.
/// Generated code is skipped: it follows its generator, not these rules.
List<_Import> _projectImports() {
  final lib = Directory('lib');
  final result = <_Import>[];
  for (final entity in lib.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final path = entity.path
        .replaceAll(r'\', '/')
        .substring(lib.path.length + 1);
    if (path.endsWith('.g.dart') ||
        path.endsWith('.freezed.dart') ||
        path.startsWith('l10n/generated/')) {
      continue;
    }
    for (final match in _directive.allMatches(entity.readAsStringSync())) {
      result.add((from: path, to: match.group(1)!));
    }
  }
  return result;
}

/// The feature folder of a path under ui/, or null for ui/core and
/// anything outside ui/.
String? _feature(String path) {
  final parts = path.split('/');
  if (parts.length < 3 || parts.first != 'ui' || parts[1] == 'core') {
    return null;
  }
  return parts[1];
}

/// The repository folder of a path under data/repositories/, or null.
String? _repository(String path) {
  final parts = path.split('/');
  if (parts.length < 3 || parts[0] != 'data' || parts[1] != 'repositories') {
    return null;
  }
  return parts[2];
}

String _describe(List<_Import> violations) =>
    violations.map((i) => '${i.from} -> ${i.to}').join('\n');
