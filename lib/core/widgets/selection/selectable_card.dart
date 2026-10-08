import 'package:flutter/material.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/selection/selection_scope.dart';

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
    this.semanticLabel,
  });

  final T id;
  final VoidCallback onTap;
  final Widget child;

  /// Accessible name for the card, read by screen readers ahead of its
  /// selected/unselected state. Optional — omit for callers whose [child]
  /// already exposes its own label (e.g. via a visible `Text`).
  final String? semanticLabel;

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
          button: true,
          label: semanticLabel,
          selected: active ? selected : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
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
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radius,
                            ),
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
