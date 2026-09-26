import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../areas/presentation/widgets/geographic_areas_management_widget.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

const _settingsTabs = [
  'Organization Profile',
  'Districts & Upazilas (ভৌগোলিক এলাকা)',
  'User Management',
  'General Settings',
  'Notification Settings',
  'Backup & Restore',
];

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _selectedIndex = 9;
  int _selectedSettingsTab = 0;

  final _nameController = TextEditingController(
    text: 'Geetha Pathshala Management System',
  );
  final _emailController = TextEditingController(
    text: 'admin@geethapathshala.org',
  );
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _addressController = TextEditingController(
    text: '123, Dharma Marg, Vrindavan, Uttar Pradesh, India',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: _onSidebarItemSelected,
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 900;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'সেটিংস',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'প্রতিষ্ঠানের তথ্য ও অ্যাপ্লিকেশন কনফিগারেশন পরিচালনা করুন।',
                        style: TextStyle(color: colors.hintColor),
                      ),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      SizedBox(
                        width: isNarrow ? double.infinity : 320,
                        child: _buildTabSelector(colors),
                      ),
                      const SizedBox(height: 20),
                      _buildTabContent(colors),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            color: colors.tileColor,
            height: 40,
            child: Center(
              child: Text(
                '© 2024 Geetha Pathshala Management. All rights reserved.',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(AppColors colors) {
    InputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );

    return DropdownButtonFormField<int>(
      initialValue: _selectedSettingsTab,
      isExpanded: true,
      borderRadius: BorderRadius.circular(8),
      dropdownColor: colors.backgroundColor,
      icon: Icon(Icons.expand_more, color: colors.hintColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: border(colors.borderColor),
        enabledBorder: border(colors.borderColor),
        focusedBorder: border(colors.primaryColor),
      ),
      items: [
        for (var i = 0; i < _settingsTabs.length; i++)
          DropdownMenuItem(
            value: i,
            child: Text(
              _settingsTabs[i],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: colors.textColor),
            ),
          ),
      ],
      onChanged: (value) {
        if (value == null || value == _selectedSettingsTab) return;
        setState(() => _selectedSettingsTab = value);
      },
    );
  }

  Widget _buildTabContent(AppColors colors) {
    if (_selectedSettingsTab == 1) {
      return const GeographicAreasManagementWidget();
    }

    if (_selectedSettingsTab != 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors.shadowColor,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${_settingsTabs[_selectedSettingsTab]} — শীঘ্রই আসছে।',
            style: TextStyle(color: colors.hintColor),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organization Profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                child: Icon(
                  Icons.temple_hindu_outlined,
                  color: colors.primaryColor,
                  size: 30,
                ),
              ),
              // CustomButton needs a bounded width here — a bare Row child
              // otherwise gets an unbounded main-axis width, crashing
              // Material's tap-target padding.
              IntrinsicWidth(
                child: CustomButton.outlined(
                  label: 'Change Logo',
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomFormField(
            label: 'Organization Name',
            hint: 'Enter organization name',
            controller: _nameController,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            label: 'Email',
            hint: 'contact@organization.org',
            controller: _emailController,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            label: 'Phone',
            hint: '+91 XXXXX XXXXX',
            controller: _phoneController,
            prefixIcon: Icons.call_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            label: 'Address',
            hint: 'Enter full address',
            controller: _addressController,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: IntrinsicWidth(
              child: CustomButton(label: 'Save Changes', onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}
