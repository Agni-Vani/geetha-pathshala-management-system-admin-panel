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
import '../widgets/person_list_tile.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_sizes.dart';

const _organizationId = AppConfig.defaultOrganizationId;

class AllPeopleView extends StatefulWidget {
  const AllPeopleView({super.key});

  @override
  State<AllPeopleView> createState() => _AllPeopleViewState();
}

class _AllPeopleViewState extends State<AllPeopleView> {
  final ListPeopleController listPeopleController = sl.get<ListPeopleController>();
  late final SnackbarNotifier snackbarNotifier;
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    setState(() {
      _searchQuery = query;
    });
    _refreshList();
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
        backgroundColor: colors.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  fontSize: 16,
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
          style: TextStyle(color: colors.textColor, fontSize: 13.5),
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
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isDeactivating ? 'Deactivate' : 'Activate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
        const SizedBox(height: 6),
        Text(
          "ব্যক্তি রেজিস্ট্রি",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colors.textColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          "Manage everyone registered in the community directory.",
          style: TextStyle(
            fontSize: 13,
            color: colors.hintColor,
          ),
        ),
      ],
    );

    final addButton = InkWell(
      onTap: _openAddPerson,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16, color: Colors.white),
            SizedBox(width: 6),
            Text(
              'Add New Person',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBlock,
          const SizedBox(height: 14),
          Row(children: [Expanded(child: addButton)]),
        ],
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

  Widget _buildToolbar(
    BuildContext context,
    AppColors colors,
    List<Person> allPeople,
    bool isNarrow,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalCount = allPeople.length;
    final activeCount =
        allPeople.where((p) => p.status == PersonStatus.active).length;
    final inactiveCount =
        allPeople.where((p) => p.status == PersonStatus.inactive).length;

    final searchField = Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1B1B) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? colors.borderColor : const Color(0xFFE5E7EB),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(fontSize: 13, color: colors.textColor),
        decoration: InputDecoration(
          hintText: 'Search by name...',
          hintStyle: TextStyle(fontSize: 13, color: colors.hintColor),
          prefixIcon: Icon(Icons.search, size: 18, color: colors.hintColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  padding: EdgeInsets.zero,
                  color: colors.hintColor,
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          isDense: true,
        ),
      ),
    );

    Widget filterTab({
      required String label,
      required int count,
      required bool isSelected,
      required VoidCallback onTap,
      Color? activeColor,
    }) {
      final color = activeColor ?? colors.primaryColor;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.4) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : colors.hintColor,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.2)
                      : (isDark ? const Color(0xFF1E2D2D) : const Color(0xFFF3F4F6)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : colors.hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filterTabs = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        filterTab(
          label: 'All',
          count: totalCount,
          isSelected: _statusFilter == null,
          onTap: () => setState(() => _statusFilter = null),
        ),
        const SizedBox(width: 4),
        filterTab(
          label: 'Active',
          count: activeCount,
          isSelected: _statusFilter == PersonStatus.active,
          activeColor: const Color(0xFF16A34A),
          onTap: () => setState(() => _statusFilter = PersonStatus.active),
        ),
        const SizedBox(width: 4),
        filterTab(
          label: 'Inactive',
          count: inactiveCount,
          isSelected: _statusFilter == PersonStatus.inactive,
          activeColor: const Color(0xFFEA580C),
          onTap: () => setState(() => _statusFilter = PersonStatus.inactive),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13201F) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? colors.dividerColor : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchField,
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: filterTabs,
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(width: 320, child: searchField),
                const Spacer(),
                filterTabs,
              ],
            ),
    );
  }

  Widget _buildList(AppColors colors) {
    final status = listPeopleController.processStatusNotifier.status;
    final allPeople = listPeopleController.people;
    final people = _statusFilter == null
        ? allPeople
        : allPeople.where((p) => p.status == _statusFilter).toList();

    if (status is ProcessLoading && allPeople.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colors.primaryColor,
            ),
          ),
        ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            'Showing ${people.length} ${people.length == 1 ? "person" : "persons"}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.hintColor,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: people.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final person = people[index];
            return PersonListTile(
              person: person,
              onTap: () => _openEditPerson(person),
              onEdit: () => _openEditPerson(person),
              onToggleStatus: () => _togglePersonStatus(person),
            );
          },
        ),
      ],
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
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, colors, isNarrow),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: listPeopleController,
                        builder: (context, _) => _buildToolbar(
                          context,
                          colors,
                          listPeopleController.people,
                          isNarrow,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                          [listPeopleController, listPeopleController.processStatusNotifier],
                        ),
                        builder: (context, _) => _buildList(colors),
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
