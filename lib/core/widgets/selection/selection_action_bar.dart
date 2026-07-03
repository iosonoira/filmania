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
  const SelectionActionBar({
    super.key,
    required this.actions,
    this.closeTooltip = 'Chiudi selezione',
  });

  final List<SelectionAction<T>> actions;

  /// Tooltip for the close button. `core/widgets/selection/` is a
  /// framework layer and may not depend on `core/l10n/` (see the
  /// multi-select plan's Global Constraints), so callers that need a
  /// localized tooltip pass their own `AppLocalizations` string here; the
  /// Italian default keeps this widget usable stand-alone/in tests.
  final String closeTooltip;

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
                    message: closeTooltip,
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
