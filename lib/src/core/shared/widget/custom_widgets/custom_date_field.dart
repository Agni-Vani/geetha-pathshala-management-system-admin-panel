import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_field_decoration.dart';

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
      helpText: label.toUpperCase(),
      // Dates here are usually years back (a date of birth, most of all), so
      // the year list is a far shorter path than paging through months.
      initialDatePickerMode: value == null ? DatePickerMode.year : DatePickerMode.day,
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
            decoration: AppFieldDecoration.build(
              context,
              hint: 'mm/dd/yyyy',
              suffix: Icons.calendar_today_outlined,
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
