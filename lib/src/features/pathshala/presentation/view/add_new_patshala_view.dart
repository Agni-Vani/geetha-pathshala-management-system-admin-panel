import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/constants/app_sizes.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/pathshala_domain.dart';
import '../controller/create_pathshala_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../areas/presentation/constants/bd_upazilas.dart';
import '../../../../core/shared/widget/custom_widgets/custom_autocomplete_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/custom_toggle_field.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';

class AddNewPatshalaView extends StatefulWidget {
  final Pathshala? existingPathshala;

  const AddNewPatshalaView({super.key, this.existingPathshala});

  @override
  State<AddNewPatshalaView> createState() => _AddNewPatshalaViewState();
}

class _AddNewPatshalaViewState extends State<AddNewPatshalaView> {
  final int _selectedIndex = 1;
  final CreatePathshalaController _controller =
      sl.get<CreatePathshalaController>();
  late final SnackbarNotifier _snackbarNotifier;
  final ScrollController _formScrollController = ScrollController();

  bool get _isEditing => widget.existingPathshala != null;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    if (widget.existingPathshala != null) {
      _controller.initializeForEdit(widget.existingPathshala!);
    }
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    _controller.dispose();
    super.dispose();
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
    final colors = AppColors.context(context);

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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryColor,
                      ),
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
            loadingText:
                _isEditing ? 'Updating Information' : 'Saving Information',
            errorText: _isEditing
                ? 'Error Updating Information'
                : 'Error Saving Information',
            processStatusNotifier: _controller.processStatusNotifier,
            onSave: (processNotifier) =>
                _controller.submit(snackbarNotifier: _snackbarNotifier),
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
                  padding: AppSizes.pagePadding(context),
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
                          child: ListenableBuilder(
                            listenable: _controller,
                            builder: (context, _) {
                              return Column(
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
                                      controller: _controller.nameController,
                                    ),
                                    CustomFormField(
                                      label: 'Branch Name',
                                      hint: 'e.g. North District Branch',
                                      controller:
                                          _controller.branchNameController,
                                    ),
                                  ]),
                                  const SizedBox(height: 20),
                                  _fieldRow([
                                    CustomDateField(
                                      label: 'Date of Establishment',
                                      value: _controller.establishedOn,
                                      onChanged:
                                          _controller.onEstablishedDateChanged,
                                    ),
                                    CustomToggleField(
                                      label: 'Status',
                                      value: _controller.isActive,
                                      onChanged: _controller.onActiveToggled,
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
                                      items: _controller.availableDistricts,
                                      value: _controller.selectedDistrict,
                                      onChanged: _controller.onDistrictChanged,
                                    ),
                                    CustomAutocompleteField(
                                      key: ValueKey(
                                          _controller.selectedDistrict),
                                      label: 'Upazila',
                                      hint: _controller.selectedDistrict == null
                                          ? 'Select District first'
                                          : 'Select or type Upazila',
                                      isRequired: true,
                                      enabled:
                                          _controller.selectedDistrict != null,
                                      options: _controller.availableUpazilas.isNotEmpty
                                          ? _controller.availableUpazilas
                                          : (bdUpazilas[
                                                  _controller.selectedDistrict] ??
                                              const []),
                                      value: _controller.selectedUpazila,
                                      onChanged: _controller.onUpazilaChanged,
                                    ),
                                  ]),
                                  const SizedBox(height: 20),
                                  CustomFormField(
                                    label: 'Detailed Address (বিস্তারিত ঠিকানা)',
                                    hint:
                                        'Enter detailed street address, holding/building number, village/area, etc.',
                                    maxLines: 4,
                                    controller: _controller.addressController,
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
                                      controller: _controller.mobileController,
                                    ),
                                    CustomFormField(
                                      label: 'Email Address',
                                      hint: 'contact@pathshala.org',
                                      prefixIcon: Icons.mail_outline,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _controller.emailController,
                                    ),
                                  ]),
                                  const SizedBox(height: 28),
                                  Divider(color: colors.dividerColor),
                                  const SizedBox(height: 18),
                                  _buildFormActions(),
                                ],
                              );
                            },
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
