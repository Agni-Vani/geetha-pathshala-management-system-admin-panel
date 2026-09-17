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
import '../widgets/custom_widgets/custom_toggle_field.dart';
import '../widgets/custom_widgets/responsive_app_shell.dart';
import 'registry_sidebar_navigation.dart';

class AddNewPatshalaView extends StatefulWidget {
  final Pathshala? existingPathshala;

  const AddNewPatshalaView({super.key, this.existingPathshala});

  @override
  State<AddNewPatshalaView> createState() => _AddNewPatshalaViewState();
}

class _AddNewPatshalaViewState extends State<AddNewPatshalaView> {
  final int _selectedIndex = 1;
  CreatePathshalaController createPathshalaController = sl
      .get<CreatePathshalaController>();
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
  String? _existingAddressLine2;

  bool get _isEditing => widget.existingPathshala != null;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void initState() {
    snackbarNotifier = SnackbarNotifier(context: context);
    final existing = widget.existingPathshala;
    if (existing != null) {
      _nameController.text = existing.name;
      _addressController.text = existing.address.addressLine1;
      _existingAddressLine2 = existing.address.addressLine2;
      _selectedDistrict = existing.address.region;
      _selectedUpazila = existing.address.city;
      _establishedOn = existing.startedOn;
      _isActive = existing.isOperational;
    }
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
    final missingMobile = !_isEditing && _mobileController.text.trim().isEmpty;
    if (_nameController.text.trim().isEmpty ||
        _selectedDistrict == null ||
        _selectedUpazila == null ||
        missingMobile) {
      snackbarNotifier.notifyError(
        message: 'Please fill in all required fields.',
      );
      return;
    }

    if (_isEditing) {
      final params = UpdatePathshalaParams(
        pathshalaId: widget.existingPathshala!.id,
        name: _nameController.text.trim(),
        addressLine1: _addressController.text.trim(),
        addressLine2: _existingAddressLine2,
        city: _selectedUpazila!,
        district: _selectedDistrict!,
        startedOn: _establishedOn,
      );

      createPathshalaController.update(
        params: params,
        snackbarNotifier: snackbarNotifier,
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

  /// Cancel and save, sitting inside the form card rather than in a
  /// separate bar below it.
  Widget _buildFormActions() {
    // The Wrap shrink-wraps, so on its own it lands at the Column's start
    // edge. Stretching it makes its end-alignment actually right-align.
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 15,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // The Center inside would stretch to the Wrap's full width; the
          // Row this used to sit in passed unbounded constraints, so it
          // shrink-wrapped there. IntrinsicWidth restores that.
          IntrinsicWidth(
            child: InkWell(
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
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          RProcessNotifierButton(
            key: UniqueKey(),
            height: 50,
            width: 200,
            generalText: _isEditing ? 'Update Pathshala' : 'Save Pathshala',
            loadingText: _isEditing
                ? 'Updating Information'
                : 'Saving Information',
            errorText: _isEditing
                ? 'Error Updating Information'
                : 'Error Saving Information',
            processStatusNotifier:
                createPathshalaController.processStatusNotifier,
            onSave: (processNotifier) => _handleSave(),
            onDone: () {
              Navigator.pop(context);
            },
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
      onLogout: () => Navigator.of(context).maybePop(),
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: colors.tileColor,
              // One scroll for the whole page. The form used to live in its own
              // scroll box inside a height-constrained card, which on a short
              // (landscape) viewport shrank to a sliver and hid the fields.
              child: Scrollbar(
                controller: _formScrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(3),
                child: SingleChildScrollView(
                  controller: _formScrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.chevron_right,
                              size: 14,
                              color: colors.hintColor,
                            ),
                          ),
                          Text(
                            _isEditing ? 'Edit Pathshala' : 'Add New Pathshala',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.hintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isEditing ? 'Edit Pathshala' : 'Add New Pathshala',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEditing
                            ? "Update this study center's registry details."
                            : "Register a new study center to expand the community's access to ancient wisdom.",
                        style: TextStyle(color: colors.hintColor),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 24),
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomSectionHeader(
                                icon: Icons.menu_book_outlined,
                                title: 'General Information',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Pathshala Name',
                                  hint: 'e.g. Gita Govinda Center',
                                  isRequired: true,
                                  controller: _nameController,
                                ),
                                CustomFormField(
                                  label: 'Branch Name',
                                  hint: 'e.g. North District Branch',
                                  controller: _branchNameController,
                                ),
                              ]),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomDateField(
                                  label: 'Date of Establishment',
                                  value: _establishedOn,
                                  onChanged: (date) =>
                                      setState(() => _establishedOn = date),
                                ),
                                CustomToggleField(
                                  label: 'Status',
                                  value: _isActive,
                                  onChanged: (active) =>
                                      setState(() => _isActive = active),
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(
                                icon: Icons.location_on_outlined,
                                title: 'Location Details',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField.dropdown(
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
                                CustomAutocompleteField(
                                  key: ValueKey(_selectedDistrict),
                                  label: 'Upazila',
                                  hint: _selectedDistrict == null
                                      ? 'Select District first'
                                      : 'Select or type Upazila',
                                  isRequired: true,
                                  enabled: _selectedDistrict != null,
                                  options:
                                      bdUpazilas[_selectedDistrict] ?? const [],
                                  value: _selectedUpazila,
                                  onChanged: (upazila) => setState(
                                    () => _selectedUpazila = upazila,
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 20),
                              CustomFormField(
                                label: 'Full Address',
                                hint:
                                    'Enter detailed street address, building number, etc.',
                                maxLines: 4,
                                controller: _addressController,
                              ),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(
                                icon: Icons.badge_outlined,
                                title: 'Contact Details',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Mobile Number',
                                  hint: '+880 1XXX-XXXXXX',
                                  isRequired: !_isEditing,
                                  prefixIcon: Icons.call_outlined,
                                  keyboardType: TextInputType.phone,
                                  controller: _mobileController,
                                ),
                                CustomFormField(
                                  label: 'Email Address',
                                  hint: 'contact@pathshala.org',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                ),
                              ]),
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
          // A phone in landscape has ~430pt of height; the copyright strip is
          // the first thing worth giving back to the form.
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
