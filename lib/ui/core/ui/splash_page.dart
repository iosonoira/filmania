import 'package:flutter/material.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.of(context).primary),
      ),
    );
  }
}
