import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomSearchFilterBar extends StatelessWidget {
  final String searchHint;
  final String districtHint;
  final String branchHint;
  final ValueChanged<String>? onSearchChanged;

  const CustomSearchFilterBar({
    super.key,
    this.searchHint = 'Search by name or code...',
    this.districtHint = 'All Districts',
    this.branchHint = 'All Branches',
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    InputDecoration fieldDecoration(String hint, {Widget? prefixIcon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: colors.tileColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: fieldDecoration(
                searchHint,
                prefixIcon: Icon(Icons.search, size: 18, color: colors.hintColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              initialValue: null,
              items: const [],
              onChanged: (_) {},
              hint: Text(districtHint,
                  style: TextStyle(color: colors.textColor, fontSize: 13)),
              decoration: fieldDecoration(districtHint),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              initialValue: null,
              items: const [],
              onChanged: (_) {},
              hint: Text(branchHint,
                  style: TextStyle(color: colors.textColor, fontSize: 13)),
              decoration: fieldDecoration(branchHint),
            ),
          ),
        ],
      ),
    );
  }
}
