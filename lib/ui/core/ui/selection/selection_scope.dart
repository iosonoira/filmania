import 'package:flutter/widgets.dart';
import 'package:filmania/ui/core/ui/selection/selection_controller.dart';

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
        : context.getInheritedWidgetOfExactType<_SelectionScopeInherited<T>>();
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

class _SelectionScopeInherited<T>
    extends InheritedNotifier<SelectionController<T>> {
  const _SelectionScopeInherited({
    required SelectionController<T> controller,
    required super.child,
  }) : super(notifier: controller);

  SelectionController<T> get controller => notifier!;
}
