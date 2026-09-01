import 'package:flutter/material.dart';

import '../../constants/assets.dart';
import '../../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: colors.appBackgroundColor),
        IgnorePointer(
          child: Opacity(
            opacity: isDark ? 0.08 : 0.16,
            child: Image.asset(
              Assets.backgroundImage,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.appBackgroundColor.withValues(
                    alpha: isDark ? 0.84 : 0.72,
                  ),
                  colors.appBackgroundColor.withValues(
                    alpha: isDark ? 0.9 : 0.8,
                  ),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
