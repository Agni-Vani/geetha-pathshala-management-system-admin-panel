import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/person_domain.dart';
import '../controller/list_people_controller.dart';
import '../controller/update_person_controller.dart';

import '../../../../core/theme/app_colors.dart';
import 'add_person_view.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../widgets/custom_person_card.dart';
import '../../../../core/shared/widget/custom_widgets/custom_search_filter_bar.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_sizes.dart';

const _organizationId = AppConfig.defaultOrganizationId;

/// Narrowest a person card may get before the grid drops a column.
const _minCardWidth = 240.0;

class AllPeopleView extends StatefulWidget {
  const AllPeopleView({super.key});

  @override
  State<AllPeopleView> createState() => _AllPeopleViewState();
}

class _AllPeopleViewState extends State<AllPeopleView> {
  final ListPeopleController listPeopleController = sl.get<ListPeopleController>();
  late final SnackbarNotifier snackbarNotifier;

  final int _selectedIndex = 3;

  /// Kept so a refresh after adding a person keeps the active search applied.
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    _refreshList();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  void _refreshList() {
    listPeopleController.load(
      organizationId: _organizationId,
      searchQuery: _searchQuery,
      snackbarNotifier: snackbarNotifier,
    );
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _refreshList();
  }

  /// Seed data stores gender lowercase while the form saves it capitalised —
  /// normalise so the grid reads the same either way.
  String? _displayGender(String? gender) {
    final value = gender?.trim();
    if (value == null || value.isEmpty) return null;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  void _openAddPerson() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddPersonRegistryView()))
        .then((_) => _refreshList());
  }

  void _showEditPersonDialog(Person person) {
    final colors = AppColors.context(context);
    final updateController = sl.get<UpdatePersonController>();
    updateController.initialize(person);

    final legalNameCtrl = TextEditingController(text: person.legalName);
    final preferredNameCtrl =
        TextEditingController(text: person.preferredName ?? '');
    final phoneCtrl = TextEditingController(text: person.primaryPhone ?? '');
    final emailCtrl = TextEditingController(text: person.primaryEmail ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: colors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.edit, color: colors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ব্যক্তির তথ্য সংশোধন (Edit Person)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: legalNameCtrl,
                          decoration: InputDecoration(
                            labelText: 'Legal Name *',
                            hintText: 'e.g. Radha Krishna Das',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Legal name is required'
                                  : null,
                          onChanged: updateController.onChangeLegalName,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: preferredNameCtrl,
                          decoration: InputDecoration(
                            labelText: 'Preferred Name',
                            hintText: 'e.g. Radhe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: updateController.onChangePreferredName,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        updateController.dateOfBirth ??
                                        DateTime(2000),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setDialogState(
                                      () => updateController.selectDateOfBirth(
                                        picked,
                                      ),
                                    );
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Date of Birth',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    updateController.dateOfBirth != null
                                        ? '${updateController.dateOfBirth!.year}-${updateController.dateOfBirth!.month.toString().padLeft(2, '0')}-${updateController.dateOfBirth!.day.toString().padLeft(2, '0')}'
                                        : 'Select Date of Birth',
                                    style: TextStyle(
                                      color:
                                          updateController.dateOfBirth != null
                                              ? colors.textColor
                                              : colors.hintColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue:
                                    updateController.gender != null &&
                                            [
                                              'Male',
                                              'Female',
                                              'Other',
                                            ].contains(updateController.gender)
                                        ? updateController.gender
                                        : null,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Male',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Female',
                                    child: Text('Female'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Other',
                                    child: Text('Other'),
                                  ),
                                ],
                                onChanged: (val) {
                                  setDialogState(
                                    () => updateController.selectGender(val),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: phoneCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Primary Phone',
                                  hintText: '+880 1XXX-XXXXXX',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: updateController.onChangePrimaryPhone,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Primary Email',
                                  hintText: 'name@example.com',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: updateController.onChangePrimaryEmail,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<PersonStatus>(
                          initialValue: updateController.status,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: PersonStatus.active,
                              child: Text('Active (সক্রিয়)'),
                            ),
                            DropdownMenuItem(
                              value: PersonStatus.inactive,
                              child: Text('Inactive (নিষ্ক্রিয়)'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(
                                () => updateController.selectStatus(val),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: colors.hintColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      updateController.update(
                        snackbarNotifier: snackbarNotifier,
                        onSuccess: () {
                          Navigator.pop(ctx);
                          _refreshList();
                        },
                      );
                    }
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBreadcrumbs(
          items: [
            BreadcrumbItem.home(context),
            const BreadcrumbItem(
              label: 'ব্যক্তি রেজিস্ট্রি',
              icon: Icons.person_outline,
            ),
          ],
        ),
        Text(
          "ব্যক্তি রেজিস্ট্রি",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: colors.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage everyone registered in the community directory.",
          style: TextStyle(color: Colors.black),
        ),
      ],
    );

    final addButton = InkWell(
      onTap: _openAddPerson,
      borderRadius: AppSizes.rectangleButtonRadius,
      child: Container(
        height: 52,
        width: isNarrow ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: colors.primaryColor, borderRadius: AppSizes.rectangleButtonRadius),
        child: Row(
          mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Add New Person',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleBlock, const SizedBox(height: 16), addButton],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        addButton,
      ],
    );
  }

  Widget _buildGrid(AppColors colors) {
    final status = listPeopleController.processStatusNotifier.status;
    final people = listPeopleController.people;

    if (status is ProcessLoading && people.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator(color: colors.primaryColor)),
      );
    }

    if (people.isEmpty) {
      // A search that found nothing is a different problem from an empty
      // registry, so only the latter invites the user to register someone.
      final isSearching = _searchQuery != null && _searchQuery!.trim().isNotEmpty;

      return CustomEmptyState(
        icon: isSearching ? Icons.search_off : Icons.person_add_alt_1_outlined,
        title: isSearching ? 'No matching person found' : 'No one registered yet',
        message: isSearching
            ? 'No person matches "${_searchQuery!.trim()}". Try a different name.'
            : 'The community directory is empty. Register the first person to get started.',
        actionLabel: isSearching ? null : 'Add New Person',
        onAction: isSearching ? null : _openAddPerson,
      );
    }

    // A column is only added while every card can still be at least
    // [_minCardWidth] wide — below that the contents get squeezed and overflow.
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 20.0;
      final columns = ((constraints.maxWidth + spacing) / (_minCardWidth + spacing)).floor().clamp(1, 4);

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          // Fits the card's content plus a second chip row on narrow cards;
          // the card's Spacer absorbs the slack when the chips fit on one line.
          mainAxisExtent: 218,
        ),
        itemBuilder: (context, index) {
          final person = people[index];
          return CustomPersonCard(
            name: person.displayName,
            legalName: person.legalName,
            phone: person.primaryPhone,
            email: person.primaryEmail,
            gender: _displayGender(person.gender),
            dateOfBirth: person.dateOfBirth,
            isActive: person.status == PersonStatus.active,
            onTap: () => _showEditPersonDialog(person),
            onEdit: () => _showEditPersonDialog(person),
          );
        },
        itemCount: people.length,
      );
    });
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
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      CustomSearchFilterBar(
                        searchHint: 'Search by name...',
                        showFilters: false,
                        onSearchChanged: _onSearchChanged,
                      ),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                          [listPeopleController, listPeopleController.processStatusNotifier],
                        ),
                        builder: (context, _) => _buildGrid(colors),
                      ),
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
}
