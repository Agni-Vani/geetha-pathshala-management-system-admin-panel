import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class CustomToggleField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: colors.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              value ? 'Active' : 'Inactive',
              style: TextStyle(fontSize: 13, color: colors.textColor),
            ),
          ],
        ),
      ],
    );
  }
}
