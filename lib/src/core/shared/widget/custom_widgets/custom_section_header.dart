import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class CustomSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const CustomSectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidget = Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        );

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colors.primaryColor, size: 20),
            const SizedBox(width: 8),
            if (constraints.hasBoundedWidth)
              Expanded(child: textWidget)
            else
              textWidget,
          ],
        );
      },
    );
  }
}
