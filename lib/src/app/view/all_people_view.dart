import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/list_people_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../features/registry/presentation/view/add_person_view.dart';
import '../../features/registry/presentation/view/registry_sidebar_navigation.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_empty_state.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_person_card.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_search_filter_bar.dart';
import '../../features/registry/presentation/widgets/custom_widgets/responsive_app_shell.dart';
import '../../core/constants/app_sizes.dart';

// TODO: replace with the signed-in user's real organization id once
// an auth/session concept exists in the app.
const _organizationId = 'org-gp-central';

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

  final int _selectedIndex = 2;

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

  Widget _buildHeader(BuildContext context, AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      onLogout: () => Navigator.of(context).maybePop(),
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
