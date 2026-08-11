import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/create_pathshala_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../constants/bd_districts.dart';
import '../constants/bd_upazilas.dart';
import '../widgets/custom_widgets/custom_autocomplete_field.dart';
import '../widgets/custom_widgets/custom_date_field.dart';
import '../widgets/custom_widgets/custom_form_field.dart';
import '../widgets/custom_widgets/custom_section_divider.dart';
import '../widgets/custom_widgets/custom_section_header.dart';
import '../widgets/custom_widgets/custom_sidebar.dart';
import '../widgets/custom_widgets/custom_toggle_field.dart';
import '../widgets/custom_widgets/custom_top_bar.dart';

class AddNewPatshalaView extends StatefulWidget {
  const AddNewPatshalaView({super.key});

  @override
  State<AddNewPatshalaView> createState() => _AddNewPatshalaViewState();
}

class _AddNewPatshalaViewState extends State<AddNewPatshalaView> {
  int _selectedIndex = 1;
  CreatePathshalaController createPathshalaController = sl.get<CreatePathshalaController>();
  late final SnackbarNotifier snackbarNotifier;

  final _nameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  final _formScrollController = ScrollController();

  DateTime? _establishedOn;
  bool _isActive = true;
  String? _selectedDistrict;
  String? _selectedUpazila;

  @override
  void initState() {
    snackbarNotifier = SnackbarNotifier(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    _nameController.dispose();
    _branchNameController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_nameController.text.trim().isEmpty ||
        _selectedDistrict == null ||
        _selectedUpazila == null ||
        _mobileController.text.trim().isEmpty) {
      snackbarNotifier.notifyError(
        message: 'Please fill in all required fields.',
      );
      return;
    }

    final params = CreatePathshalaParams(
      // TODO: replace with the signed-in user's real organization id once
      // an auth/session concept exists in the app.
      organizationId: 'org-gp-central',
      code: 'PS-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      addressLine1: _addressController.text.trim(),
      city: _selectedUpazila!,
      district: _selectedDistrict!,
      startedOn: _establishedOn,
    );

    createPathshalaController.create(
      params: params,
      snackbarNotifier: snackbarNotifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.tileColor,
      body: Row(
        children: [
          CustomSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
            onLogout: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Column(
              children: [
                CustomTopBar(title: 'Overview', onBack: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: Container(
                    color: colors.tileColor,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Pathshalas', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
                            ),
                            Text('Add New Pathshala', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Add New Pathshala',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colors.primaryColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Register a new study center to expand the community's access to ancient wisdom.",
                          style: TextStyle(color: colors.hintColor),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: colors.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Scrollbar(
                              controller: _formScrollController,
                              thumbVisibility: true,
                              thickness: 6,
                              radius: const Radius.circular(3),
                              child: SingleChildScrollView(
                              controller: _formScrollController,
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.only(left: 24, right: 28, top: 24, bottom: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomSectionHeader(icon: Icons.menu_book_outlined, title: 'General Information'),
                                  const SizedBox(height: 12),
                                  Divider(color: colors.dividerColor),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomFormField(
                                          label: 'Pathshala Name',
                                          hint: 'e.g. Gita Govinda Center',
                                          isRequired: true,
                                          controller: _nameController,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: CustomFormField(
                                          label: 'Branch Name',
                                          hint: 'e.g. North District Branch',
                                          controller: _branchNameController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomDateField(
                                          label: 'Date of Establishment',
                                          value: _establishedOn,
                                          onChanged: (date) => setState(() => _establishedOn = date),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: CustomToggleField(
                                          label: 'Status',
                                          value: _isActive,
                                          onChanged: (active) => setState(() => _isActive = active),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const CustomSectionDivider(),
                                  const SizedBox(height: 24),
                                  const CustomSectionHeader(icon: Icons.location_on_outlined, title: 'Location Details'),
                                  const SizedBox(height: 12),
                                  Divider(color: colors.dividerColor),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomFormField.dropdown(
                                          label: 'District',
                                          hint: 'Select District',
                                          isRequired: true,
                                          items: bdDistricts,
                                          value: _selectedDistrict,
                                          onChanged: (district) => setState(() {
                                            _selectedDistrict = district;
                                            _selectedUpazila = null;
                                          }),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: CustomAutocompleteField(
                                          key: ValueKey(_selectedDistrict),
                                          label: 'Upazila',
                                          hint: _selectedDistrict == null ? 'Select District first' : 'Select or type Upazila',
                                          isRequired: true,
                                          enabled: _selectedDistrict != null,
                                          options: bdUpazilas[_selectedDistrict] ?? const [],
                                          value: _selectedUpazila,
                                          onChanged: (upazila) => setState(() => _selectedUpazila = upazila),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  CustomFormField(
                                    label: 'Full Address',
                                    hint: 'Enter detailed street address, building number, etc.',
                                    maxLines: 4,
                                    controller: _addressController,
                                  ),
                                  const SizedBox(height: 24),
                                  const CustomSectionDivider(),
                                  const SizedBox(height: 24),
                                  const CustomSectionHeader(icon: Icons.badge_outlined, title: 'Contact Details'),
                                  const SizedBox(height: 12),
                                  Divider(color: colors.dividerColor),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomFormField(
                                          label: 'Mobile Number',
                                          hint: '+880 1XXX-XXXXXX',
                                          isRequired: true,
                                          prefixIcon: Icons.call_outlined,
                                          keyboardType: TextInputType.phone,
                                          controller: _mobileController,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: CustomFormField(
                                          label: 'Email Address',
                                          hint: 'contact@pathshala.org',
                                          prefixIcon: Icons.mail_outline,
                                          keyboardType: TextInputType.emailAddress,
                                          controller: _emailController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 35,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Center(
                              child: Text('Cancel', style: TextStyle(fontSize: 12, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      RProcessNotifierButton(
                        key: UniqueKey(),
                        height: 50,
                        width: 200,
                        generalText: 'Save Pathshala',
                        loadingText: "Saving Information",
                        errorText: "Error Saving Information",
                        processStatusNotifier: createPathshalaController.processStatusNotifier,
                        onSave: (processNotifier) => _handleSave(),
                        onDone: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
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
          ),
        ],
      ),
    );
  }
}
