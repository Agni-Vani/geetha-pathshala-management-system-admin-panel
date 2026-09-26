import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../controller/create_person_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

class AddPersonRegistryView extends StatefulWidget {
  const AddPersonRegistryView({super.key});

  @override
  State<AddPersonRegistryView> createState() => _AddPersonRegistryViewState();
}

class _AddPersonRegistryViewState extends State<AddPersonRegistryView> {
  static const _genders = ['Male', 'Female', 'Other'];

  final int _selectedIndex = 2;
  CreatePersonController createPersonController = sl
      .get<CreatePersonController>();
  late final SnackbarNotifier snackbarNotifier;

  final _legalNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _primaryPhoneController = TextEditingController();
  final _primaryEmailController = TextEditingController();

  final _formScrollController = ScrollController();

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void initState() {
    snackbarNotifier = SnackbarNotifier(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    _legalNameController.dispose();
    _preferredNameController.dispose();
    _primaryPhoneController.dispose();
    _primaryEmailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!createPersonController.isValid) {
      snackbarNotifier.notifyError(
        message: 'Please fill in all required fields.',
      );
      return;
    }

    createPersonController.create(snackbarNotifier: snackbarNotifier);
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.primaryColor),
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
            generalText: 'Save Person',
            loadingText: 'Saving Information',
            errorText: 'Error Saving Information',
            processStatusNotifier: createPersonController.processStatusNotifier,
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
                  padding: AppSizes.pagePadding(context).copyWith(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'People',
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
                          Expanded(
                            child: Text(
                              'Add New Person',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add New Person',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Register a new person in the community directory.',
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
                                icon: Icons.badge_outlined,
                                title: 'General Information',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Legal Name',
                                  hint: 'e.g. Radha Krishna Das',
                                  isRequired: true,
                                  controller: _legalNameController,
                                  onTextChanged:
                                      createPersonController.onChangeLegalName,
                                ),
                                CustomFormField(
                                  label: 'Preferred Name',
                                  hint: 'e.g. Radhe',
                                  controller: _preferredNameController,
                                  onTextChanged: createPersonController
                                      .onChangePreferredName,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(
                                icon: Icons.event_outlined,
                                title: 'Personal Details',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              AnimatedBuilder(
                                animation: createPersonController,
                                builder: (context, _) => _fieldRow([
                                  CustomDateField(
                                    label: 'Date of Birth',
                                    value: createPersonController.dateOfBirth,
                                    onChanged: createPersonController
                                        .selectDateOfBirth,
                                  ),
                                  CustomFormField.dropdown(
                                    label: 'Gender',
                                    hint: 'Select Gender',
                                    items: _genders,
                                    value: createPersonController.gender,
                                    onChanged:
                                        createPersonController.selectGender,
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(
                                icon: Icons.contact_phone_outlined,
                                title: 'Contact Information',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Primary Phone',
                                  hint: '+880 1XXX-XXXXXX',
                                  prefixIcon: Icons.call_outlined,
                                  keyboardType: TextInputType.phone,
                                  controller: _primaryPhoneController,
                                  onTextChanged: createPersonController
                                      .onChangePrimaryPhone,
                                ),
                                CustomFormField(
                                  label: 'Primary Email',
                                  hint: 'name@example.com',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _primaryEmailController,
                                  onTextChanged: createPersonController
                                      .onChangePrimaryEmail,
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
