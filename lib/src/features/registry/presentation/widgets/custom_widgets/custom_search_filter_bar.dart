import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_field_decoration.dart';

class CustomSearchFilterBar extends StatelessWidget {
  final String searchHint;
  final String districtHint;
  final String branchHint;
  final ValueChanged<String>? onSearchChanged;

  /// Listings without a regional breakdown (the people registry, for one)
  /// reuse this bar for its search field alone.
  final bool showFilters;

  const CustomSearchFilterBar({
    super.key,
    this.searchHint = 'Search by name or code...',
    this.districtHint = 'All Districts',
    this.branchHint = 'All Branches',
    this.onSearchChanged,
    this.showFilters = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    InputDecoration fieldDecoration(String hint, {IconData? prefixIcon}) {
      return AppFieldDecoration.build(
        context,
        hint: hint,
        prefix: prefixIcon,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );
    }

    final searchField = TextField(
      onChanged: onSearchChanged,
      decoration: fieldDecoration(
        searchHint,
        prefixIcon: Icons.search,
      ),
    );

    final districtDropdown = DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: null,
      items: const [],
      onChanged: (_) {},
      hint: Text(districtHint,
          style: TextStyle(color: colors.textColor, fontSize: 13)),
      decoration: fieldDecoration(districtHint),
    );

    final branchDropdown = DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: null,
      items: const [],
      onChanged: (_) {},
      hint: Text(branchHint,
          style: TextStyle(color: colors.textColor, fontSize: 13)),
      decoration: fieldDecoration(branchHint),
    );

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (!showFilters) return searchField;

          if (constraints.maxWidth < 380) {
            return Column(
              children: [
                searchField,
                const SizedBox(height: 12),
                districtDropdown,
                const SizedBox(height: 12),
                branchDropdown,
              ],
            );
          }

          if (constraints.maxWidth < 640) {
            return Column(
              children: [
                searchField,
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: districtDropdown),
                    const SizedBox(width: 12),
                    Expanded(child: branchDropdown),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: searchField),
              const SizedBox(width: 16),
              SizedBox(width: 180, child: districtDropdown),
              const SizedBox(width: 16),
              SizedBox(width: 180, child: branchDropdown),
            ],
          );
        },
      ),
    );
  }
}
