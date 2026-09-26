import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/pathshala_domain.dart';
import '../controller/list_pathshalas_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../widgets/custom_pathshala_card.dart';
import '../../../../core/shared/widget/custom_widgets/custom_search_filter_bar.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import 'add_new_patshala_view.dart';
import 'patshala_details_view.dart';
import '../../../../core/constants/app_sizes.dart';

// TODO: replace with the signed-in user's real organization id once
// an auth/session concept exists in the app.
const _organizationId = 'org-gp-central';

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
  final ListPathshalasController listPathshalasController = sl.get<ListPathshalasController>();
  late final SnackbarNotifier snackbarNotifier;

  final int _selectedIndex = 1;

  /// Kept so a refresh after adding a Pathshala keeps the active search applied.
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
    listPathshalasController.load(
      organizationId: _organizationId,
      searchQuery: _searchQuery,
      snackbarNotifier: snackbarNotifier,
    );
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _refreshList();
  }

  void _openAddPathshala() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddNewPatshalaView()))
        .then((_) => _refreshList());
  }

  String _locationOf(Pathshala pathshala) {
    final address = pathshala.address;
    final subLocality = address.addressLine2?.trim();
    final secondary = (subLocality != null && subLocality.isNotEmpty) ? subLocality : address.region;
    return '${address.city}, $secondary';
  }

  Widget _buildHeader(BuildContext context, AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "পাঠশালা সমূহ",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: colors.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage and monitor all registered Gita Pathshalas across regions.",
          style: TextStyle(color: Colors.black),
        ),
      ],
    );

    final addButton = InkWell(
      onTap: _openAddPathshala,
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
                'Add New Pathshala',
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
    final status = listPathshalasController.processStatusNotifier.status;
    final pathshalas = listPathshalasController.pathshalas;

    if (status is ProcessLoading && pathshalas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator(color: colors.primaryColor)),
      );
    }

    if (pathshalas.isEmpty) {
      // A search that found nothing is a different problem from an empty
      // registry, so only the latter invites the user to register one.
      final isSearching = _searchQuery != null && _searchQuery!.trim().isNotEmpty;

      return CustomEmptyState(
        icon: isSearching ? Icons.search_off : Icons.temple_hindu_outlined,
        title: isSearching ? 'No matching Pathshala found' : 'No Pathshala registered yet',
        message: isSearching
            ? 'No Pathshala matches "${_searchQuery!.trim()}". Try a different name or code.'
            : 'No Gita Pathshala has been registered. Add the first one to get started.',
        actionLabel: isSearching ? null : 'Add New Pathshala',
        onAction: isSearching ? null : _openAddPathshala,
      );
    }

    // A column is only added while every card can still be at least
    // [_minCardWidth] wide — below that the contents get squeezed and overflow.
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 24.0;
      final columns = ((constraints.maxWidth + spacing) / (_minCardWidth + spacing)).floor().clamp(1, 4);
      final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          // Sized to the card's content. Anything taller leaves dead space
          // between the location row and the buttons, because the card's
          // Spacer pins the actions to the bottom edge.
          mainAxisExtent: cardWidth < _stackedCardWidth ? 300 : 262,
        ),
        itemBuilder: (context, index) {
          final pathshala = pathshalas[index];
          return CustomPathshalaCard(
            name: pathshala.name,
            code: pathshala.code,
            location: _locationOf(pathshala),
            isActive: pathshala.isOperational,
            onView: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PatshalaDetailsView(pathshala: pathshala)),
              );
            },
            onEdit: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AddNewPatshalaView(existingPathshala: pathshala)))
                  .then((_) => _refreshList());
            },
          );
        },
        itemCount: pathshalas.length,
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
                      CustomSearchFilterBar(onSearchChanged: _onSearchChanged),
                      const SizedBox(height: 10),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                          [listPathshalasController, listPathshalasController.processStatusNotifier],
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
