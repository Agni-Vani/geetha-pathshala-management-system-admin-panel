import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_field_decoration.dart';

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
  final Color? fillColor;
  final Color? enabledBorderColor;

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
    this.fillColor,
    this.enabledBorderColor,
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
    this.fillColor,
    this.enabledBorderColor,
  })  : prefixIcon = null,
        maxLines = 1,
        isDropdown = true,
        controller = null,
        keyboardType = null,
        onTextChanged = null;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final decoration = AppFieldDecoration.build(
      context,
      hint: hint,
      prefix: prefixIcon,
    ).copyWith(
      fillColor: fillColor,
      enabledBorder: enabledBorderColor == null
          ? null
          : OutlineInputBorder(
              borderRadius: AppFieldDecoration.borderRadius,
              borderSide: BorderSide(color: enabledBorderColor!),
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
              fontWeight: FontWeight.w400,
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
            isExpanded: true,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colors.textColor,
            ),
            initialValue: (value != null && items.toSet().contains(value)) ? value : null,
            items: items
                .toSet()
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: colors.textColor,
            ),
            decoration: decoration,
          ),
      ],
    );
  }
}
