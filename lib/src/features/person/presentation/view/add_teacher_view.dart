import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/models/teacher_model.dart';
import '../../domain/entities/teacher.dart';


class AddTeacherView extends StatefulWidget {
  const AddTeacherView({super.key});

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  static const _genders = ['Male', 'Female', 'Other'];

  final int _selectedIndex = 5;

  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _degreeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  final _formScrollController = ScrollController();

  DateTime? _dateOfBirth;
  String? _gender;

  @override
  void dispose() {
    _formScrollController.dispose();
    _nameController.dispose();
    _subjectController.dispose();
    _degreeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher name is required.')),
      );
      return;
    }

    Navigator.of(context).pop<Teacher>(
      TeacherModel(
        id: 'teacher-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        subject: _subjectController.text.trim().isEmpty ? 'সাধারণ' : _subjectController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? 'N/A' : _phoneController.text.trim(),
        pathshala: 'General',
        isActive: true,
        degree: _degreeController.text.trim().isEmpty ? null : _degreeController.text.trim(),
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      ),
    );
  }

  Widget _fieldRow(List<Widget> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < fields.length; i++) ...[
                fields[i],
                if (i != fields.length - 1) const SizedBox(height: 20),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < fields.length; i++) ...[
              Expanded(child: fields[i]),
              if (i != fields.length - 1) const SizedBox(width: 24),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFormActions() {
    final colors = AppColors.context(context);

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 15,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IntrinsicWidth(
            child: InkWell(
              borderRadius: AppSizes.rectangleButtonRadius,
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: AppSizes.rectangleButtonRadius,
                  border: Border.all(color: colors.primaryColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IntrinsicWidth(
            child: InkWell(
              borderRadius: AppSizes.rectangleButtonRadius,
              onTap: _handleSave,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: colors.primaryColor,
                  borderRadius: AppSizes.rectangleButtonRadius,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text(
                      'Save Teacher',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
            child: Container(
              color: colors.tileColor,
              child: Scrollbar(
                controller: _formScrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(3),
                child: SingleChildScrollView(
                  controller: _formScrollController,
                  padding: AppSizes.pagePadding(context).copyWith(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Teachers', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
                          ),
                          Expanded(
                            child: Text(
                              'Add New Teacher',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: colors.hintColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add New Teacher',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colors.primaryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Register a new teacher in the community directory.',
                        style: TextStyle(color: colors.hintColor),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: colors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomSectionHeader(icon: Icons.badge_outlined, title: 'General Information'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Full Name',
                                  hint: 'e.g. অনির্বাণ সেন',
                                  isRequired: true,
                                  controller: _nameController,
                                ),
                                CustomFormField(
                                  label: 'Subject',
                                  hint: 'e.g. সংস্কৃত',
                                  controller: _subjectController,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(icon: Icons.school_outlined, title: 'Education & Personal Details'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Degree',
                                  hint: 'e.g. M.A. in Sanskrit',
                                  prefixIcon: Icons.school_outlined,
                                  controller: _degreeController,
                                ),
                                CustomDateField(
                                  label: 'Date of Birth',
                                  value: _dateOfBirth,
                                  onChanged: (value) => setState(() => _dateOfBirth = value),
                                ),
                                CustomFormField.dropdown(
                                  label: 'Gender',
                                  hint: 'Select Gender',
                                  items: _genders,
                                  value: _gender,
                                  onChanged: (value) => setState(() => _gender = value),
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(icon: Icons.contact_phone_outlined, title: 'Contact Information'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Primary Phone',
                                  hint: '+880 1XXX-XXXXXX',
                                  prefixIcon: Icons.call_outlined,
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneController,
                                ),
                                CustomFormField(
                                  label: 'Primary Email',
                                  hint: 'name@example.com',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                ),
                              ]),
                              const SizedBox(height: 20),
                              CustomFormField(
                                label: 'Address',
                                hint: 'e.g. Temple Complex Road, Chattogram',
                                prefixIcon: Icons.location_on_outlined,
                                maxLines: 2,
                                controller: _addressController,
                              ),
                              const SizedBox(height: 28),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 18),
                              _buildFormActions(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (MediaQuery.sizeOf(context).height >= 520)
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
}
