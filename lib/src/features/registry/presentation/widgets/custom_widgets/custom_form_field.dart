import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final int maxLines;
  final bool isDropdown;
  final bool isRequired;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<String>? onTextChanged;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    this.isRequired = false,
    this.controller,
    this.keyboardType,
    this.onTextChanged,
  })  : isDropdown = false,
        items = const [],
        value = null,
        onChanged = null;

  const CustomFormField.dropdown({
    super.key,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.items = const [],
    this.value,
    this.onChanged,
  })  : prefixIcon = null,
        maxLines = 1,
        isDropdown = true,
        controller = null,
        keyboardType = null,
        onTextChanged = null;

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
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textColor,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: colors.errorColor),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        if (isDropdown)
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items
                .map((item) =>
                    DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            decoration: decoration,
            hint: Text(hint,
                style: TextStyle(color: colors.hintColor, fontSize: 13)),
          )
        else
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onChanged: onTextChanged,
            style: TextStyle(fontSize: 13, color: colors.textColor),
            decoration: decoration,
          ),
      ],
    );
  }
}
