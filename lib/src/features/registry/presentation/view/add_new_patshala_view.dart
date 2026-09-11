import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
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

  final CreatePathshalaController _controller =
      sl.get<CreatePathshalaController>();
  late final SnackbarNotifier _snackbarNotifier;

  final ScrollController _formScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    super.dispose();
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
                CustomTopBar(
                  title: 'Overview',
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: Container(
                    color: colors.tileColor,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Breadcrumb ─────────────────────────────────────
                        Row(
                          children: [
                            Text(
                              'Pathshalas',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.hintColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.chevron_right,
                                size: 14,
                                color: colors.hintColor,
                              ),
                            ),
                            Text(
                              'Add New Pathshala',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.hintColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Add New Pathshala',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Register a new study center to expand the community's access to ancient wisdom.",
                          style: TextStyle(color: colors.hintColor),
                        ),
                        // ── Form card ──────────────────────────────────────
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: colors.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Scrollbar(
                              controller: _formScrollController,
                              thumbVisibility: true,
                              thickness: 6,
                              radius: const Radius.circular(3),
                              child: SingleChildScrollView(
                                controller: _formScrollController,
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 28,
                                  top: 24,
                                  bottom: 32,
                                ),
                                child: ListenableBuilder(
                                  listenable: _controller,
                                  builder: (context, _) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ── General Information ──────────────
                                      const CustomSectionHeader(
                                        icon: Icons.menu_book_outlined,
                                        title: 'General Information',
                                      ),
                                      const SizedBox(height: 12),
                                      Divider(color: colors.dividerColor),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CustomFormField(
                                              label: 'Pathshala Name',
                                              hint: 'e.g. Gita Govinda Center',
                                              isRequired: true,
                                              controller: _controller.nameController,
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: CustomFormField(
                                              label: 'Branch Name',
                                              hint:
                                                  'e.g. North District Branch',
                                              controller: _controller
                                                  .branchNameController,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // ── Date of Establishment ────────────
                                          Expanded(
                                            child: CustomDateField(
                                              label: 'Date of Establishment',
                                              value: _controller.establishedOn,
                                              onChanged: _controller.onEstablishedDateChanged,
                                            ),
                                          ),
                                          const SizedBox(width: 24),

                                          // ── Status ──────────────────────────────
                                          Expanded(
                                            child: CustomToggleField(
                                              label: 'Status',
                                              value: _controller.isActive,
                                              onChanged:
                                                  _controller.onActiveToggled,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      const CustomSectionDivider(),
                                      const SizedBox(height: 24),
                                      // ── Location Details ─────────────────
                                      const CustomSectionHeader(
                                        icon: Icons.location_on_outlined,
                                        title: 'Location Details',
                                      ),
                                      const SizedBox(height: 12),
                                      Divider(color: colors.dividerColor),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            
                                          // ── District ───────────────────────────
                                          Expanded(
                                            child: CustomFormField.dropdown(
                                              label: 'District',
                                              hint: 'Select District',
                                              isRequired: true,
                                              items: bdDistricts,
                                              value: _controller
                                                  .selectedDistrict,
                                              onChanged: _controller
                                                  .onDistrictChanged,
                                            ),
                                          ),
                                          const SizedBox(width: 24),

                                          // ── Upazila ───────────────────────────
                                          Expanded(
                                            child: CustomAutocompleteField(
                                              key: ValueKey(_controller.selectedDistrict),
                                              label: 'Upazila',
                                              hint: _controller.selectedDistrict == null
                                                  ? 'Select District first'
                                                  : 'Select or type Upazila',
                                              isRequired: true,
                                              enabled: _controller.selectedDistrict != null,
                                              options: bdUpazilas[_controller.selectedDistrict] ?? const [],
                                              value: _controller.selectedUpazila,
                                              onChanged: _controller.onUpazilaChanged,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      // ── Full Address ──────────────────
                                      CustomFormField(
                                        label: 'Full Address',
                                        hint:
                                            'Enter detailed street address, building number, etc.',
                                        maxLines: 4,
                                        controller: _controller.addressController,
                                      ),
                                      const SizedBox(height: 24),
                                      const CustomSectionDivider(),
                                      const SizedBox(height: 24),

                                      // ── Contact Details ──────────────────
                                      const CustomSectionHeader(
                                        icon: Icons.badge_outlined,
                                        title: 'Contact Details',
                                      ),
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
                                              keyboardType:
                                                  TextInputType.phone,
                                              controller:
                                                  _controller.mobileController,
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: CustomFormField(
                                              label: 'Email Address',
                                              hint: 'contact@pathshala.org',
                                              prefixIcon: Icons.mail_outline,
                                              keyboardType:TextInputType.emailAddress,
                                              controller: _controller.emailController,
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
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Action bar ───────────────────────────────────────────────
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
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
                        loadingText: 'Saving Information',
                        errorText: 'Error Saving Information',
                        processStatusNotifier:
                            _controller.processStatusNotifier,
                        onSave: (_) =>
                            _controller.submit(snackbarNotifier: _snackbarNotifier),
                        onDone: () => Navigator.pop(context),
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

