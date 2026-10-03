import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/person_domain.dart';
import '../controller/list_people_controller.dart';

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
  PersonStatus? _statusFilter;

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

  void _openEditPerson(Person person) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AddPersonRegistryView(existingPerson: person),
          ),
        )
        .then((_) => _refreshList());
  }

  Future<void> _togglePersonStatus(Person person) async {
    final newStatus = person.status == PersonStatus.active
        ? PersonStatus.inactive
        : PersonStatus.active;
    final isDeactivating = newStatus == PersonStatus.inactive;
    final colors = AppColors.context(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isDeactivating
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
              color: isDeactivating ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isDeactivating
                    ? 'Deactivate Person (নিষ্ক্রিয়)'
                    : 'Activate Person (সক্রিয়)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colors.textColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isDeactivating
              ? 'Are you sure you want to mark "${person.displayName}" as Inactive? They will remain in records but marked as inactive.'
              : 'Are you sure you want to reactivate "${person.displayName}"?',
          style: TextStyle(color: colors.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: colors.hintColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDeactivating ? Colors.orange : colors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isDeactivating ? 'Deactivate' : 'Activate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final response = await sl<UpdatePerson>().call(
        UpdatePersonParams(personId: person.id, status: newStatus),
      );
      if (response is SuccessRepoCall) {
        snackbarNotifier.notifySuccess(
          message:
              '${person.displayName} marked as ${isDeactivating ? "inactive" : "active"}.',
        );
        _refreshList();
      } else {
        snackbarNotifier.notifyError(message: response.message);
      }
    }
  }

  Widget _buildFilterChips(AppColors colors, List<Person> allPeople) {
    final totalCount = allPeople.length;
    final activeCount =
        allPeople.where((p) => p.status == PersonStatus.active).length;
    final inactiveCount =
        allPeople.where((p) => p.status == PersonStatus.inactive).length;

    Widget chip({
      required String label,
      required int count,
      required bool isSelected,
      required VoidCallback onTap,
      Color? activeColor,
    }) {
      final color = activeColor ?? colors.primaryColor;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? color : colors.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : colors.dividerColor,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textColor,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : colors.softAccentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : colors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(
            label: 'All (সকল)',
            count: totalCount,
            isSelected: _statusFilter == null,
            onTap: () => setState(() => _statusFilter = null),
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Active (সক্রিয়)',
            count: activeCount,
            isSelected: _statusFilter == PersonStatus.active,
            activeColor: Colors.green[700],
            onTap: () => setState(() => _statusFilter = PersonStatus.active),
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Inactive (নিষ্ক্রিয়)',
            count: inactiveCount,
            isSelected: _statusFilter == PersonStatus.inactive,
            activeColor: Colors.orange[800],
            onTap: () => setState(() => _statusFilter = PersonStatus.inactive),
          ),
        ],
      ),
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
    final allPeople = listPeopleController.people;
    final people = _statusFilter == null
        ? allPeople
        : allPeople.where((p) => p.status == _statusFilter).toList();

    if (status is ProcessLoading && allPeople.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator(color: colors.primaryColor)),
      );
    }

    if (people.isEmpty) {
      final isSearching = _searchQuery != null && _searchQuery!.trim().isNotEmpty;
      final isFiltering = _statusFilter != null;

      return CustomEmptyState(
        icon: isSearching || isFiltering
            ? Icons.search_off
            : Icons.person_add_alt_1_outlined,
        title: isSearching
            ? 'No matching person found'
            : (isFiltering ? 'No people in this category' : 'No one registered yet'),
        message: isSearching
            ? 'No person matches "${_searchQuery!.trim()}". Try a different name.'
            : (isFiltering
                ? 'No ${_statusFilter == PersonStatus.active ? "active" : "inactive"} people found.'
                : 'The community directory is empty. Register the first person to get started.'),
        actionLabel: isSearching || isFiltering ? null : 'Add New Person',
        onAction: isSearching || isFiltering ? null : _openAddPerson,
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
            onTap: () => _openEditPerson(person),
            onEdit: () => _openEditPerson(person),
            onToggleStatus: () => _togglePersonStatus(person),
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
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: listPeopleController,
                        builder: (context, _) => _buildFilterChips(
                          colors,
                          listPeopleController.people,
                        ),
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
