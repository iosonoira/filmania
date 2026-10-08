import 'package:flutter/material.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/selection/selection_scope.dart';

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

  /// Awaited by the bar so it can show a busy state and block re-entrant
  /// taps while a bulk action is in flight (see `_SelectionActionBarState`).
  final Future<void> Function(Set<T> selected) onPressed;
}

/// Contextual bar shown while a [SelectionScope<T>] is active: a close
/// button that exits selection mode, a live selected-count, and the
/// caller's [actions] applied in bulk to the current selection.
///
/// Place it wherever the screen's layout has room (e.g. above a grid, or
/// `Positioned` at the top of a `Stack`) — it renders as `SizedBox.shrink`
/// while inactive, so it can always be mounted unconditionally.
class SelectionActionBar<T> extends StatefulWidget {
  const SelectionActionBar({
    super.key,
    required this.actions,
    this.closeTooltip = 'Chiudi selezione',
    this.pinnedToBottom = false,
  });

  final List<SelectionAction<T>> actions;

  /// Set when the bar sits at the bottom of the screen (e.g. as a
  /// `Scaffold.bottomNavigationBar`): it then pads for the bottom system
  /// inset instead of the top one, which would otherwise add an empty block
  /// as tall as the app bar above the controls.
  final bool pinnedToBottom;

  /// Tooltip for the close button. `core/widgets/selection/` is a
  /// framework layer and may not depend on `core/l10n/` (see the
  /// multi-select plan's Global Constraints), so callers that need a
  /// localized tooltip pass their own `AppLocalizations` string here; the
  /// Italian default keeps this widget usable stand-alone/in tests.
  final String closeTooltip;

  @override
  State<SelectionActionBar<T>> createState() => _SelectionActionBarState<T>();
}

class _SelectionActionBarState<T> extends State<SelectionActionBar<T>> {
  bool _busy = false;

  Future<void> _runAction(SelectionAction<T> action, Set<T> selected) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action.onPressed(selected);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = SelectionScope.controllerOf<T>(context);
    final colors = AppColors.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (!controller.isActive) return const SizedBox.shrink();
        final selected = controller.selected;

        return Material(
          color: colors.surface,
          child: SafeArea(
            top: !widget.pinnedToBottom,
            bottom: widget.pinnedToBottom,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Tooltip(
                    message: widget.closeTooltip,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: _busy ? null : controller.clear,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _SelectionCountOrSpinner(busy: _busy, count: selected.length),
                  for (final action in widget.actions)
                    _SelectionActionTile<T>(
                      action: action,
                      busy: _busy,
                      onTap: () => _runAction(action, selected),
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

/// Live selected-count while idle, a small spinner while a bulk action from
/// [SelectionActionBar] is in flight.
class _SelectionCountOrSpinner extends StatelessWidget {
  const _SelectionCountOrSpinner({required this.busy, required this.count});

  final bool busy;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    if (busy) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.onSurfacePrimary,
        ),
      );
    }
    return Text(
      '$count',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: colors.onSurfacePrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// One icon+label tile in [SelectionActionBar], dimmed and untappable while
/// [busy] so a bulk action can't be re-entered mid-flight.
class _SelectionActionTile<T> extends StatelessWidget {
  const _SelectionActionTile({
    required this.action,
    required this.busy,
    required this.onTap,
  });

  final SelectionAction<T> action;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final contentColor = colors.onSurfacePrimary.withValues(
      alpha: busy ? 0.4 : 1.0,
    );

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: busy ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(action.icon, color: contentColor),
              const SizedBox(height: 2),
              Text(
                action.label,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: contentColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
