import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/pathshala_domain.dart';
import '../controller/list_pathshalas_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../widgets/custom_pathshala_card.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import 'add_new_patshala_view.dart';
import '../../../../core/config/app_config.dart';
import 'patshala_details_view.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared/widget/app_background.dart';

const _organizationId = AppConfig.defaultOrganizationId;
const _pageTitle = 'পাঠশালা সমূহ';

/// Narrowest a pathshala card may get before the grid drops a column.
const _minCardWidth = 320.0;

class AllPatshalaView extends StatefulWidget {
  const AllPatshalaView({super.key});

  @override
  State<AllPatshalaView> createState() => _AllPatshalaViewState();
}

class _AllPatshalaViewState extends State<AllPatshalaView> {
  final ListPathshalasController listPathshalasController = sl
      .get<ListPathshalasController>();
  late final SnackbarNotifier snackbarNotifier;
  final TextEditingController _searchController = TextEditingController();

  final int _selectedIndex = 1;

  // The background illustration starts right under the filter-tab divider;
  // these locate it after layout.
  final GlobalKey _topBarKey = GlobalKey();
  final GlobalKey _dividerKey = GlobalKey();
  double? _backgroundTop;

  String? _searchQuery;
  // Mobile only: the search field stays hidden until its icon is tapped.
  bool _mobileSearchOpen = false;
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

  void _toggleMobileSearch() {
    final open = !_mobileSearchOpen;
    setState(() => _mobileSearchOpen = open);
    // A hidden field must not keep filtering the list.
    if (!open && _searchController.text.isNotEmpty) {
      _searchController.clear();
      _onSearchChanged('');
    }
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

  Widget _filterSegment({
    required AppColors colors,
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      selected: isSelected,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          backgroundColor: Colors.transparent,
          foregroundColor: isSelected ? colors.textColor : colors.hintColor,
          overlayColor: colors.splashColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryColor.withValues(alpha: .12)
                    : colors.softGrey,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.primaryColor : colors.hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    AppColors colors,
    List<Pathshala> allPathshalas,
  ) {
    final totalCount = allPathshalas.length;
    final activeCount = allPathshalas.where((p) => p.isOperational).length;
    final inactiveCount = totalCount - activeCount;
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    // On mobile the add button sits beside the breadcrumbs as a plain text
    // button instead of taking a full row.
    final isMobile = ResponsiveAppShell.hasTopBar(context);

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _pageTitle,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontSize: 24,
            height: 1.35,
            fontWeight: FontWeight.w700,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'মোট $totalCount পাঠশালা • খুঁজুন ও পরিচালনা করুন',
          overflow: TextOverflow.visible,
          style: TextStyle(fontSize: 13, height: 1.5, color: colors.hintColor),
        ),
      ],
    );
    final addButton = ElevatedButton.icon(
      onPressed: _openAddPathshala,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 48),
        backgroundColor: colors.primaryColor,
        foregroundColor: colors.buttonContentColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        overlayColor: colors.buttonContentColor.withValues(alpha: .1),
      ),
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text(
        'Add New Pathshala',
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
    final compactAddButton = TextButton.icon(
      onPressed: _openAddPathshala,
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: Colors.transparent,
        foregroundColor: colors.primaryColor,
        overlayColor: colors.splashColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text(
        'Add New Pathshala',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
    final filters = Wrap(
      spacing: 6,
      runSpacing: 8,
      children: [
        _filterSegment(
          colors: colors,
          label: 'All',
          count: totalCount,
          isSelected: _statusFilter == null,
          onTap: () => setState(() {
            _statusFilter = null;
            _currentPage = 1;
          }),
        ),
        _filterSegment(
          colors: colors,
          label: 'Active',
          count: activeCount,
          isSelected: _statusFilter == true,
          onTap: () => setState(() {
            _statusFilter = true;
            _currentPage = 1;
          }),
        ),
        _filterSegment(
          colors: colors,
          label: 'Inactive',
          count: inactiveCount,
          isSelected: _statusFilter == false,
          onTap: () => setState(() {
            _statusFilter = false;
            _currentPage = 1;
          }),
        ),
      ],
    );
    final search = TextField(
      controller: _searchController,
      // On mobile the field only mounts once its icon is tapped.
      autofocus: isMobile,
      onChanged: _onSearchChanged,
      style: TextStyle(fontSize: 14, color: colors.textColor),
      decoration:
          AppFieldDecoration.build(
            context,
            hint: 'Search by name or code',
            prefix: Icons.search_rounded,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          ).copyWith(
            fillColor: colors.backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colors.borderColor.withValues(alpha: .6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: colors.hintColor,
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
          ),
    );

    final breadcrumbs = AppBreadcrumbs(
      items: [
        BreadcrumbItem.home(context),
        const BreadcrumbItem(label: 'পাঠশালা', icon: Icons.school_outlined),
      ],
    );

    return Column(
      key: _topBarKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [breadcrumbs, compactAddButton],
            ),
          )
        else
          breadcrumbs,
        // On mobile the top bar carries the app's name and the search and add
        // controls sit beside the breadcrumbs and filters, so the header
        // block is skipped entirely.
        if (isMobile)
          const SizedBox(height: 8)
        else ...[
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1050 * textScale) {
                return Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 24),
                    SizedBox(width: 280, child: search),
                    const SizedBox(width: 12),
                    addButton,
                  ],
                );
              }
              if (constraints.maxWidth >= 620 * textScale) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: title),
                        const SizedBox(width: 24),
                        addButton,
                      ],
                    ),
                    const SizedBox(height: 18),
                    search,
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  title,
                  const SizedBox(height: 18),
                  search,
                  const SizedBox(height: 12),
                  addButton,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
        ],
        Container(
          key: _dividerKey,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colors.dividerColor.withValues(alpha: .7),
              ),
            ),
          ),
          child: isMobile
              ? Row(
                  children: [
                    Expanded(child: filters),
                    IconButton(
                      key: const ValueKey('pathshala-search-toggle'),
                      tooltip: _mobileSearchOpen ? 'Close search' : 'Search',
                      onPressed: _toggleMobileSearch,
                      color: _mobileSearchOpen
                          ? colors.primaryColor
                          : colors.hintColor,
                      icon: Icon(
                        _mobileSearchOpen
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        size: 22,
                      ),
                    ),
                  ],
                )
              : filters,
        ),
        if (isMobile && _mobileSearchOpen) ...[
          const SizedBox(height: 12),
          search,
        ],
      ],
    );
  }

  Widget _pageNumber(String text, Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ),
  );

  /// 40×40 square used by the pager: filled for the current page, outlined
  /// otherwise, dimmed when [onPressed] is null.
  Widget _pageSquare({
    Key? key,
    required AppColors colors,
    required String tooltip,
    required Widget child,
    VoidCallback? onPressed,
    bool filled = false,
  }) {
    final radius = BorderRadius.circular(10);
    return Tooltip(
      message: tooltip,
      child: Material(
        key: key,
        color: filled ? colors.primaryColor : colors.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: filled
              ? BorderSide.none
              : BorderSide(
                  color: colors.ornamentColor.withValues(
                    alpha: onPressed == null ? .4 : 1,
                  ),
                ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          hoverColor: colors.primaryColor.withValues(alpha: .08),
          child: SizedBox(width: 40, height: 40, child: Center(child: child)),
        ),
      ),
    );
  }

  /// Opens a small grid of every page number just above the "more" button and
  /// resolves to the page the user picked.
  Future<int?> _showPagePicker(
    BuildContext buttonContext, {
    required int totalPages,
    required int currentPage,
  }) {
    final colors = AppColors.context(context);
    final button = buttonContext.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final rect =
        button.localToGlobal(Offset.zero, ancestor: overlay) & button.size;
    final screen = overlay.size;
    const cell = 40.0;
    const gap = 8.0;
    const inset = 14.0;
    final width = (5 * cell + 4 * gap + inset * 2).clamp(
      0.0,
      screen.width - 32,
    );
    final left = (rect.right - width).clamp(
      16.0,
      (screen.width - width - 16).clamp(16.0, double.infinity),
    );

    return showDialog<int>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .12),
      builder: (dialogContext) => Stack(
        children: [
          Positioned(
            left: left,
            bottom: screen.height - rect.top + 8,
            width: width,
            child: Material(
              color: colors.dialogBackgroundColor,
              elevation: 8,
              shadowColor: colors.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: colors.ornamentColor.withValues(alpha: .7),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(inset),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Go to page',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.hintColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: (rect.top - 120).clamp(cell, 232.0),
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (var page = 1; page <= totalPages; page++)
                              _pageSquare(
                                key: ValueKey('pathshala-page-option-$page'),
                                colors: colors,
                                tooltip: 'Page $page',
                                filled: page == currentPage,
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(page),
                                child: _pageNumber(
                                  '$page',
                                  page == currentPage
                                      ? colors.buttonContentColor
                                      : colors.maroonColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The card grid, or — with [paginationOnly] — just the pager
  /// bar, which the page pins to its bottom edge.
  Widget _buildContent(
    AppColors colors,
    List<Pathshala> allPathshalas, {
    bool paginationOnly = false,
  }) {
    final status = listPathshalasController.processStatusNotifier.status;

    if (status is ProcessLoading && allPathshalas.isEmpty) {
      if (paginationOnly) return const SizedBox.shrink();
      return Container(
        height: 260,
        alignment: Alignment.center,
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
        : allPathshalas.where((p) => p.isOperational == _statusFilter).toList();

    if (filtered.isEmpty) {
      if (paginationOnly) return const SizedBox.shrink();
      final isSearching =
          _searchQuery != null && _searchQuery!.trim().isNotEmpty;
      final isFiltering = _statusFilter != null;

      return CustomEmptyState(
        showBorder: false,
        showBackground: false,
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
      );
    }

    // Pagination calculations
    final totalEntries = filtered.length;
    final totalPages = (totalEntries / _pageSize).ceil().clamp(1, 9999);
    final currentPage = _currentPage.clamp(1, totalPages);
    final startIndex = (currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalEntries);
    final pageItems = filtered.sublist(startIndex, endIndex);

    final canPrevious = currentPage > 1;
    final canNext = currentPage < totalPages;

    Widget buildPaginationBar(BoxConstraints constraints) {
      // Previous page · current page · next page · all pages.
      final controls = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pageSquare(
            key: const ValueKey('pathshala-page-previous'),
            colors: colors,
            tooltip: 'Previous page',
            onPressed: canPrevious
                ? () => setState(() => _currentPage = currentPage - 1)
                : null,
            child: Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color: canPrevious
                  ? colors.maroonColor
                  : colors.hintColor.withValues(alpha: .45),
            ),
          ),
          const SizedBox(width: 8),
          _pageSquare(
            key: const ValueKey('pathshala-page-current'),
            colors: colors,
            tooltip: 'Current page',
            filled: true,
            child: _pageNumber('$currentPage', colors.buttonContentColor),
          ),
          const SizedBox(width: 8),
          _pageSquare(
            key: const ValueKey('pathshala-page-next'),
            colors: colors,
            tooltip: 'Next page',
            onPressed: canNext
                ? () => setState(() => _currentPage = currentPage + 1)
                : null,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: canNext
                  ? colors.maroonColor
                  : colors.hintColor.withValues(alpha: .45),
            ),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (buttonContext) => _pageSquare(
              key: const ValueKey('pathshala-page-more'),
              colors: colors,
              tooltip: 'All pages',
              onPressed: () async {
                final picked = await _showPagePicker(
                  buttonContext,
                  totalPages: totalPages,
                  currentPage: currentPage,
                );
                if (picked != null && mounted) {
                  setState(() => _currentPage = picked);
                }
              },
              child: Icon(
                Icons.more_horiz_rounded,
                size: 20,
                color: colors.maroonColor,
              ),
            ),
          ),
        ],
      );

      return Padding(
        key: const ValueKey('pathshala-pagination'),
        padding: const EdgeInsets.only(top: 24, left: 4, right: 4),
        child: Align(alignment: Alignment.centerRight, child: controls),
      );
    }

    if (paginationOnly) {
      return LayoutBuilder(
        builder: (context, constraints) => buildPaginationBar(constraints),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = AppSizes.isCompact(context) ? 14.0 : 20.0;
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final columns =
            ((constraints.maxWidth + spacing) /
                    (_minCardWidth * textScale + spacing))
                .floor()
                .clamp(1, 4);
        final cardWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: pageItems.map((pathshala) {
                return SizedBox(
                  width: cardWidth,
                  child: CustomPathshalaCard(
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
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  /// Measures where the tab divider sits inside the page (independent of
  /// scroll) so the background can be pinned just below it.
  void _measureBackgroundTop() {
    final topBarBox =
        _topBarKey.currentContext?.findRenderObject() as RenderBox?;
    final dividerBox =
        _dividerKey.currentContext?.findRenderObject() as RenderBox?;
    if (topBarBox == null || dividerBox == null) return;
    if (!topBarBox.hasSize || !dividerBox.hasSize) return;
    final top =
        AppSizes.pagePadding(context).top +
        dividerBox
            .localToGlobal(
              Offset(0, dividerBox.size.height),
              ancestor: topBarBox,
            )
            .dy;
    if (_backgroundTop == null || (_backgroundTop! - top).abs() > .5) {
      setState(() => _backgroundTop = top);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measureBackgroundTop();
    });

    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: _onSidebarItemSelected,
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      showBackgroundImage: false,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_backgroundTop != null)
                  Positioned(
                    top: _backgroundTop,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: const AppBackgroundIllustration(),
                  ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      listPathshalasController,
                      listPathshalasController.processStatusNotifier,
                    ]),
                    builder: (context, _) {
                      final allPathshalas = listPathshalasController.pathshalas;
                      final hasVisiblePathshalas = allPathshalas.any(
                        (pathshala) =>
                            _statusFilter == null ||
                            pathshala.isOperational == _statusFilter,
                      );
                      final padding = AppSizes.pagePadding(context);
                      if (hasVisiblePathshalas) {
                        // The content is at least one viewport tall so the
                        // pager sits at the bottom of the page
                        // instead of floating right under the cards.
                        return LayoutBuilder(
                          builder: (context, viewport) => SingleChildScrollView(
                            padding: padding,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight:
                                    (viewport.maxHeight - padding.vertical)
                                        .clamp(0.0, double.infinity),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTopBar(
                                        context,
                                        colors,
                                        allPathshalas,
                                      ),
                                      const SizedBox(height: 18),
                                      _buildContent(colors, allPathshalas),
                                    ],
                                  ),
                                  _buildContent(
                                    colors,
                                    allPathshalas,
                                    paginationOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                padding.left,
                                padding.top,
                                padding.right,
                                18,
                              ),
                              child: _buildTopBar(
                                context,
                                colors,
                                allPathshalas,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              padding.left,
                              0,
                              padding.right,
                              0,
                            ),
                            sliver: SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: padding.bottom,
                                  ),
                                  child: _buildContent(colors, allPathshalas),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.tileColor,
              gradient: AppSizes.isCompact(context)
                  ? null
                  : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.alphaBlend(
                          colors.drawerColor,
                          colors.appBackgroundColor,
                        ),
                        colors.tileColor,
                      ],
                      stops: const [0, .15],
                    ),
            ),
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Center(
              child: Text(
                '© 2024 Geetha Pathshala Management. All rights reserved.',
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
