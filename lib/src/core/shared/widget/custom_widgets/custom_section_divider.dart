import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class CustomSectionDivider extends StatelessWidget {
  const CustomSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Row(
      children: [
        Expanded(child: Divider(color: colors.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.spa_outlined,
            size: 16,
            color: colors.primaryColor,
          ),
        ),
        Expanded(child: Divider(color: colors.dividerColor)),
      ],
    );
  }
}
