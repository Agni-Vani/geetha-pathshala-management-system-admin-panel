import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool isRequired;

  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
  });

  String get _formatted {
    if (value == null) return '';
    final month = value!.month.toString().padLeft(2, '0');
    final day = value!.day.toString().padLeft(2, '0');
    return '$month/$day/${value!.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

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
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _pickDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'mm/dd/yyyy',
              hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
              suffixIcon:
                  Icon(Icons.calendar_today_outlined, size: 16, color: colors.hintColor),
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
            ),
            child: Text(
              _formatted,
              style: TextStyle(fontSize: 13, color: colors.textColor),
            ),
          ),
        ),
      ],
    );
  }
}
