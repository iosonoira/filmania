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
