import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/create_person_controller.dart';

import '../../../../app/view/all_patshala_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/custom_date_field.dart';
import '../widgets/custom_widgets/custom_form_field.dart';
import '../widgets/custom_widgets/custom_section_divider.dart';
import '../widgets/custom_widgets/custom_section_header.dart';
import '../widgets/custom_widgets/responsive_app_shell.dart';

class AddPersonRegistryView extends StatefulWidget {
  const AddPersonRegistryView({super.key});

  @override
  State<AddPersonRegistryView> createState() => _AddPersonRegistryViewState();
}

class _AddPersonRegistryViewState extends State<AddPersonRegistryView> {
  static const _genders = ['Male', 'Female', 'Other'];

  int _selectedIndex = 2;
  CreatePersonController createPersonController = sl.get<CreatePersonController>();
  late final SnackbarNotifier snackbarNotifier;

  final _legalNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _primaryPhoneController = TextEditingController();
  final _primaryEmailController = TextEditingController();

  final _formScrollController = ScrollController();

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AllPatshalaView()),
        );
        break;
      default:
        setState(() => _selectedIndex = index);
    }
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('People', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
                      ),
                      Text('Add New Person', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add New Person',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colors.primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Register a new person in the community directory.',
                    style: TextStyle(color: colors.hintColor),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colors.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
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
                              const CustomSectionHeader(icon: Icons.badge_outlined, title: 'General Information'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Legal Name',
                                  hint: 'e.g. Radha Krishna Das',
                                  isRequired: true,
                                  controller: _legalNameController,
                                  onTextChanged: createPersonController.onChangeLegalName,
                                ),
                                CustomFormField(
                                  label: 'Preferred Name',
                                  hint: 'e.g. Radhe',
                                  controller: _preferredNameController,
                                  onTextChanged: createPersonController.onChangePreferredName,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(icon: Icons.event_outlined, title: 'Personal Details'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              AnimatedBuilder(
                                animation: createPersonController,
                                builder: (context, _) => _fieldRow([
                                  CustomDateField(
                                    label: 'Date of Birth',
                                    value: createPersonController.dateOfBirth,
                                    onChanged: createPersonController.selectDateOfBirth,
                                  ),
                                  CustomFormField.dropdown(
                                    label: 'Gender',
                                    hint: 'Select Gender',
                                    items: _genders,
                                    value: createPersonController.gender,
                                    onChanged: createPersonController.selectGender,
                                  ),
                                ]),
                              ),
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
                                  controller: _primaryPhoneController,
                                  onTextChanged: createPersonController.onChangePrimaryPhone,
                                ),
                                CustomFormField(
                                  label: 'Primary Email',
                                  hint: 'name@example.com',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _primaryEmailController,
                                  onTextChanged: createPersonController.onChangePrimaryEmail,
                                ),
                              ]),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
}
