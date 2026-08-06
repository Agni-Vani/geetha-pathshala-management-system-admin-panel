import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final int maxLines;
  final bool isDropdown;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
  }) : isDropdown = false;

  const CustomFormField.dropdown({
    super.key,
    required this.label,
    required this.hint,
  })  : prefixIcon = null,
        maxLines = 1,
        isDropdown = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final decoration = InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 18, color: colors.hintColor)
          : null,
      filled: true,
      fillColor: colors.tileColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.primaryColor),
      ),
    );

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
        if (isDropdown)
          DropdownButtonFormField<String>(
            items: const [],
            onChanged: (_) {},
            decoration: decoration,
            hint: Text(hint,
                style: TextStyle(color: colors.hintColor, fontSize: 13)),
          )
        else
          TextFormField(
            maxLines: maxLines,
            decoration: decoration,
          ),
      ],
    );
  }
}
