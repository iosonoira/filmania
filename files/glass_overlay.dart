import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:filmania/core/theme/app_colors.dart';

/// A reusable glassmorphic overlay widget.
/// Wrapped with [RepaintBoundary] to isolate expensive [BackdropFilter] repaints.
class GlassOverlay extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? color;
  final double sigma;

  const GlassOverlay({
    super.key,
    required this.child,
    this.borderRadius,
    this.color,
    this.sigma = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            color: color ?? AppColors.of(context).background.withValues(alpha: 0.8),
            child: child,
          ),
        ),
      ),
    );
  }
}
