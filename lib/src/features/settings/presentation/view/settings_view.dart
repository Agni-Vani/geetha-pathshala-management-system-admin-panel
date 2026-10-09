import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';

const _settingsTabs = [
  'প্রতিষ্ঠানের প্রোফাইল (Organization Profile)',
  'সাধারণ সেটিংস (General Settings)',
  'নোটিফিকেশন (Notification Settings)',
  'ব্যাকআপ ও রিস্টোর (Backup & Restore)',
];

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  static const int _selectedIndex = 12;
  int _selectedSettingsTab = 0;

  final _nameController = TextEditingController(
    text: 'গীতা পাঠশালা ম্যানেজমেন্ট সিস্টেম',
  );
  final _emailController = TextEditingController(
    text: 'admin@geethapathshala.org',
  );
  final _phoneController = TextEditingController(text: '+880 1712-345678');
  final _addressController = TextEditingController(
    text: 'ঢাকা, বাংলাদেশ',
  );

  // General settings state
  String _selectedLanguage = 'বাংলা (Bengali)';
  String _selectedDateFormat = 'DD/MM/YYYY';
  String _selectedTimezone = 'Asia/Dhaka (GMT+6)';

  // Notification settings state
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _attendanceAlerts = true;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBreadcrumbs(
                    items: [
                      BreadcrumbItem.home(context),
                      const BreadcrumbItem(
                        label: 'সেটিংস',
                        icon: Icons.settings_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                    style: TextStyle(color: colors.hintColor, fontSize: 13.5),
                  ),
                  const SizedBox(height: 20),

                  // Tab selector: horizontal pills on desktop/tablet, dropdown on mobile
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 750;

                      if (isNarrow) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.borderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedSettingsTab,
                              isExpanded: true,
                              dropdownColor: colors.backgroundColor,
                              items: List.generate(_settingsTabs.length, (i) {
                                return DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    _settingsTabs[i],
                                    style: TextStyle(fontSize: 13, color: colors.textColor),
                                  ),
                                );
                              }),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedSettingsTab = val);
                              },
                            ),
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colors.tileColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.borderColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_settingsTabs.length, (i) {
                            final isSelected = _selectedSettingsTab == i;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => setState(() => _selectedSettingsTab = i),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _settingsTabs[i],
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected ? Colors.white : colors.textColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Tab Content
                  _buildTabContent(colors),
                ],
              ),
            ),
          ),
          Container(
            color: colors.tileColor,
            height: 40,
            child: Center(
              child: Text(
                '© 2026 Geetha Pathshala Management. All rights reserved.',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(AppColors colors) {
    switch (_selectedSettingsTab) {
      case 0:
        return _buildOrgProfileTab(colors);
      case 1:
        return _buildGeneralSettingsTab(colors);
      case 2:
        return _buildNotificationSettingsTab(colors);
      case 3:
        return _buildBackupRestoreTab(colors);
      default:
        return _buildOrgProfileTab(colors);
    }
  }

  Widget _buildOrgProfileTab(AppColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'প্রতিষ্ঠানের প্রোফাইল (Organization Profile)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'সেন্ট্রাল পরিচালনা পর্ষদ ও প্রতিষ্ঠানের সার্বিক বিবরণ',
            style: TextStyle(fontSize: 12.5, color: colors.hintColor),
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
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primaryColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'লোগো পরিবর্তন করুন',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomFormField(
            label: 'প্রতিষ্ঠানের নাম (Organization Name)',
            hint: 'Enter organization name',
            controller: _nameController,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            label: 'অফিসিয়াল ইমেইল (Email)',
            hint: 'contact@geethapathshala.org',
            controller: _emailController,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            label: 'যোগাযোগ নম্বর (Phone)',
            hint: '+880 1712-345678',
            controller: _phoneController,
            prefixIcon: Icons.call_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            label: 'প্রধান কার্যালয়ের ঠিকানা (Address)',
            hint: 'Enter full address',
            controller: _addressController,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: AppSizes.bigRectangleTileRadius,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('প্রতিষ্ঠানের প্রোফাইল সফলভাবে সংরক্ষিত হয়েছে।')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: BoxDecoration(
                  color: colors.primaryColor,
                  borderRadius: AppSizes.bigRectangleTileRadius,
                ),
                child: const Text(
                  'সংরক্ষণ করুন',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsTab(AppColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'সাধারণ সেটিংস (General Settings)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'সিস্টেম ডিফল্ট ভাষা, তারিখ ফরম্যাট ও সময় অঞ্চল নির্ধারণ করুন',
            style: TextStyle(fontSize: 12.5, color: colors.hintColor),
          ),
          const SizedBox(height: 24),

          // Language Selector
          Text(
            'ভাষা (Language)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                dropdownColor: colors.backgroundColor,
                items: ['বাংলা (Bengali)', 'English'].map((l) {
                  return DropdownMenuItem(
                    value: l,
                    child: Text(l, style: TextStyle(fontSize: 13, color: colors.textColor)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedLanguage = val ?? _selectedLanguage),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Date Format Selector
          Text(
            'তারিখ প্রদর্শন পদ্ধতি (Date Format)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDateFormat,
                isExpanded: true,
                dropdownColor: colors.backgroundColor,
                items: ['DD/MM/YYYY', 'YYYY-MM-DD', 'MM/DD/YYYY'].map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d, style: TextStyle(fontSize: 13, color: colors.textColor)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedDateFormat = val ?? _selectedDateFormat),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Timezone Selector
          Text(
            'সময় অঞ্চল (Timezone)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTimezone,
                isExpanded: true,
                dropdownColor: colors.backgroundColor,
                items: [
                  'Asia/Dhaka (GMT+6)',
                  'Asia/Kolkata (GMT+5:30)',
                  'UTC',
                ].map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t, style: TextStyle(fontSize: 13, color: colors.textColor)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedTimezone = val ?? _selectedTimezone),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: AppSizes.bigRectangleTileRadius,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('সাধারণ সেটিংস সফলভাবে আপডেট করা হয়েছে।')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: BoxDecoration(
                  color: colors.primaryColor,
                  borderRadius: AppSizes.bigRectangleTileRadius,
                ),
                child: const Text(
                  'সংরক্ষণ করুন',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsTab(AppColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'নোটিফিকেশন সেটিংস (Notification Settings)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'সিস্টেম ইভেন্ট, নোটিশ ও উপস্থিতির অ্যালার্ট চ্যানেল কনফিগার করুন',
            style: TextStyle(fontSize: 12.5, color: colors.hintColor),
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: Text(
              'ইমেইল নোটিফিকেশন',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
            ),
            subtitle: Text(
              'গুরুত্বপূর্ণ নোটিশ এবং ঘোষণা ইমেইলে প্রেরণ করুন',
              style: TextStyle(fontSize: 12, color: colors.hintColor),
            ),
            value: _emailNotifications,
            activeColor: colors.primaryColor,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          Divider(color: colors.dividerColor),

          SwitchListTile(
            title: Text(
              'এসএমএস অ্যালার্ট',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
            ),
            subtitle: Text(
              'অভিভাবক ও শিক্ষকদের জরুরি এসএমএস বার্তা পাঠান',
              style: TextStyle(fontSize: 12, color: colors.hintColor),
            ),
            value: _smsNotifications,
            activeColor: colors.primaryColor,
            onChanged: (val) => setState(() => _smsNotifications = val),
          ),
          Divider(color: colors.dividerColor),

          SwitchListTile(
            title: Text(
              'উপস্থিতির তাৎক্ষণিক নোটিফিকেশন',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
            ),
            subtitle: Text(
              'শিক্ষার্থী অনুপস্থিত থাকলে স্বয়ংক্রিয়ভাবে অ্যালার্ট পাঠান',
              style: TextStyle(fontSize: 12, color: colors.hintColor),
            ),
            value: _attendanceAlerts,
            activeColor: colors.primaryColor,
            onChanged: (val) => setState(() => _attendanceAlerts = val),
          ),

          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: AppSizes.bigRectangleTileRadius,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('নোটিফিকেশন প্রেফারেন্স সফলভাবে সংরক্ষিত হয়েছে।')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: BoxDecoration(
                  color: colors.primaryColor,
                  borderRadius: AppSizes.bigRectangleTileRadius,
                ),
                child: const Text(
                  'সংরক্ষণ করুন',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupRestoreTab(AppColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ব্যাকআপ ও রিস্টোর (Backup & Restore)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ডেটাবেজ ও ক্লাউড রেজিস্ট্রি ব্যাকআপ সংগ্রহ ও সংরক্ষণ',
            style: TextStyle(fontSize: 12.5, color: colors.hintColor),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.cloud_done_outlined, color: Colors.green, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'স্বয়ংক্রিয় ক্লাউড স্ন্যাপশট',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'সর্বশেষ সফল ব্যাকআপ: আজ সকাল ০৪:০০ ঘটিকায়।',
                        style: TextStyle(fontSize: 12, color: colors.hintColor),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('নতুন ব্যাকআপ প্রক্রিয়া শুরু হয়েছে...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'এখনই ব্যাকআপ নিন',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
