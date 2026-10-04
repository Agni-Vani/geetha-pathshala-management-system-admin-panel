import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/pathshala_domain.dart';
import '../controller/list_pathshalas_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../widgets/custom_pathshala_card.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import 'add_new_patshala_view.dart';
import '../../../../core/config/app_config.dart';
import 'patshala_details_view.dart';
import '../../../../core/constants/app_sizes.dart';

const _organizationId = AppConfig.defaultOrganizationId;

/// Narrowest a pathshala card may get before the grid drops a column.
const _minCardWidth = 300.0;

/// Below this card width the card stacks its two action buttons and so needs
/// to be taller — see `_stackedActionsBreakpoint` in CustomPathshalaCard.
const _stackedCardWidth = 276.0;

class AllPatshalaView extends StatefulWidget {
  const AllPatshalaView({super.key});

  @override
  State<AllPatshalaView> createState() => _AllPatshalaViewState();
}

class _AllPatshalaViewState extends State<AllPatshalaView> {
  final ListPathshalasController listPathshalasController =
      sl.get<ListPathshalasController>();
  late final SnackbarNotifier snackbarNotifier;
  final TextEditingController _searchController = TextEditingController();

  final int _selectedIndex = 1;

  String? _searchQuery;
  bool? _statusFilter; // null = all, true = active, false = inactive
  int _currentPage = 1;
  static const int _pageSize = 8;

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
    listPathshalasController.load(
      organizationId: _organizationId,
      searchQuery: _searchQuery,
      snackbarNotifier: snackbarNotifier,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
    });
    _refreshList();
  }

  void _openAddPathshala() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddNewPatshalaView()))
        .then((_) => _refreshList());
  }

  String _locationOf(Pathshala pathshala) {
    final address = pathshala.address;
    final subLocality = address.addressLine2?.trim();
    final secondary = (subLocality != null && subLocality.isNotEmpty)
        ? subLocality
        : address.region;
    return '${address.city}, $secondary';
  }

  Widget _buildTopBar(
    BuildContext context,
    AppColors colors,
    List<Pathshala> allPathshalas,
  ) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBreadcrumbs(
          items: [
            BreadcrumbItem.home(context),
            const BreadcrumbItem(
              label: 'পাঠশালা',
              icon: Icons.school_outlined,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "পাঠশালা সমূহ",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colors.textColor,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );

    final totalCount = allPathshalas.length;
    final activeCount = allPathshalas.where((p) => p.isOperational).length;
    final inactiveCount = allPathshalas.where((p) => !p.isOperational).length;

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
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color:
                isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.35)
                  : Colors.transparent,
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
              const SizedBox(width: 4),
              Text(
                '($count)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : colors.hintColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final searchBox = Container(
      height: 38,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, size: 17, color: colors.hintColor),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(fontSize: 13, color: colors.textColor),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 13, color: colors.hintColor),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 15),
              padding: EdgeInsets.zero,
              color: colors.hintColor,
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );

    final addButton = InkWell(
      onTap: _openAddPathshala,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16, color: Colors.white),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Add New Pathshala',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final statusFilters = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          filterTab(
            label: 'All',
            count: totalCount,
            isSelected: _statusFilter == null,
            onTap: () => setState(() {
              _statusFilter = null;
              _currentPage = 1;
            }),
          ),
          const SizedBox(width: 4),
          filterTab(
            label: 'Active',
            count: activeCount,
            isSelected: _statusFilter == true,
            activeColor: const Color(0xFF16A34A),
            onTap: () => setState(() {
              _statusFilter = true;
              _currentPage = 1;
            }),
          ),
          const SizedBox(width: 4),
          filterTab(
            label: 'Inactive',
            count: inactiveCount,
            isSelected: _statusFilter == false,
            activeColor: const Color(0xFFEA580C),
            onTap: () => setState(() {
              _statusFilter = false;
              _currentPage = 1;
            }),
          ),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          titleBlock,
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              statusFilters,
              searchBox,
              addButton,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    AppColors colors,
    List<Pathshala> allPathshalas,
  ) {
    final status = listPathshalasController.processStatusNotifier.status;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (status is ProcessLoading && allPathshalas.isEmpty) {
      return Container(
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13201F) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? colors.dividerColor : const Color(0xFFEAECF0),
          ),
        ),
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: colors.primaryColor,
          ),
        ),
      );
    }

    final filtered = _statusFilter == null
        ? allPathshalas
        : allPathshalas
            .where((p) => p.isOperational == _statusFilter)
            .toList();

    if (filtered.isEmpty) {
      final isSearching =
          _searchQuery != null && _searchQuery!.trim().isNotEmpty;
      final isFiltering = _statusFilter != null;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13201F) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? colors.dividerColor : const Color(0xFFEAECF0),
          ),
        ),
        child: CustomEmptyState(
          icon: isSearching ? Icons.search_off : Icons.temple_hindu_outlined,
          title: isSearching
              ? 'No matching Pathshala found'
              : (isFiltering
                  ? 'No Pathshalas in this category'
                  : 'No Pathshala registered yet'),
          message: isSearching
              ? 'No Pathshala matches "${_searchQuery!.trim()}". Try a different name or code.'
              : (isFiltering
                  ? 'No ${_statusFilter == true ? "active" : "inactive"} Pathshalas found.'
                  : 'No Gita Pathshala has been registered. Add the first one to get started.'),
          actionLabel: isSearching || isFiltering ? null : 'Add New Pathshala',
          onAction: isSearching || isFiltering ? null : _openAddPathshala,
        ),
      );
    }

    // Pagination calculations
    final totalEntries = filtered.length;
    final totalPages = (totalEntries / _pageSize).ceil().clamp(1, 9999);
    final currentPage = _currentPage.clamp(1, totalPages);
    final startIndex = (currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalEntries);
    final pageItems = filtered.sublist(startIndex, endIndex);

    final canPrev = currentPage > 1;
    final canNext = currentPage < totalPages;

    Widget buildPaginationBar(BoxConstraints constraints) {
      final isNarrow = constraints.maxWidth < 450;

      return Container(
        height: 52,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13201F) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? colors.dividerColor : const Color(0xFFEAECF0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isNarrow
                    ? '${totalEntries == 0 ? 0 : startIndex + 1}-$endIndex of $totalEntries'
                    : 'Showing result ${totalEntries == 0 ? 0 : startIndex + 1}-$endIndex of $totalEntries Entries',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.hintColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: canPrev
                  ? () => setState(() => _currentPage = currentPage - 1)
                  : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: BorderSide(
                  color: canPrev
                      ? const Color(0xFFD0D5DD)
                      : const Color(0xFFEAECF0),
                ),
              ),
              child: Text(
                'Previous',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: canPrev ? colors.textColor : colors.hintColor,
                ),
              ),
            ),
            const SizedBox(width: 6),
            OutlinedButton(
              onPressed: canNext
                  ? () => setState(() => _currentPage = currentPage + 1)
                  : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: BorderSide(
                  color: canNext
                      ? const Color(0xFFD0D5DD)
                      : const Color(0xFFEAECF0),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: canNext ? colors.textColor : colors.hintColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 20.0;
        final columns = ((constraints.maxWidth + spacing) /
                (_minCardWidth + spacing))
            .floor()
            .clamp(1, 4);
        final cardWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                mainAxisExtent: cardWidth < _stackedCardWidth ? 300 : 262,
              ),
              itemBuilder: (context, index) {
                final pathshala = pageItems[index];
                return CustomPathshalaCard(
                  name: pathshala.name,
                  code: pathshala.code,
                  location: _locationOf(pathshala),
                  isActive: pathshala.isOperational,
                  onView: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            PatshalaDetailsView(pathshala: pathshala),
                      ),
                    );
                  },
                  onEdit: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => AddNewPatshalaView(
                              existingPathshala: pathshala,
                            ),
                          ),
                        )
                        .then((_) => _refreshList());
                  },
                );
              },
              itemCount: pageItems.length,
            ),
            buildPaginationBar(constraints),
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
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  listPathshalasController,
                  listPathshalasController.processStatusNotifier,
                ]),
                builder: (context, _) {
                  final allPathshalas = listPathshalasController.pathshalas;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(context, colors, allPathshalas),
                      const SizedBox(height: 18),
                      _buildContent(colors, allPathshalas),
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
