import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_field_decoration.dart';

class CustomTimeField extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;
  final bool isRequired;

  const CustomTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
  });

  String get _formatted {
    if (value == null) return '';
    final hour = value!.hourOfPeriod == 0 ? 12 : value!.hourOfPeriod;
    final minute = value!.minute.toString().padLeft(2, '0');
    final period = value!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      helpText: label.toUpperCase(),
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
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
            children: [
              if (isRequired) TextSpan(text: ' *', style: TextStyle(color: colors.errorColor)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _pickTime(context),
          child: InputDecorator(
            decoration: AppFieldDecoration.build(
              context,
              hint: 'hh:mm',
              suffix: Icons.access_time_outlined,
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
