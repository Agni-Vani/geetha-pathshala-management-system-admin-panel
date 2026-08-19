import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/list_pathshalas_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_pathshala_card.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_search_filter_bar.dart';
import '../../features/registry/presentation/widgets/custom_widgets/responsive_app_shell.dart';
import '../../features/registry/presentation/view/add_new_patshala_view.dart';
import '../../features/registry/presentation/view/add_person_view.dart';

// TODO: replace with the signed-in user's real organization id once
// an auth/session concept exists in the app.
const _organizationId = 'org-gp-central';

class AllPatshalaView extends StatefulWidget {
  const AllPatshalaView({super.key});

  @override
  State<AllPatshalaView> createState() => _AllPatshalaViewState();
}

class _AllPatshalaViewState extends State<AllPatshalaView> {
  final ListPathshalasController listPathshalasController = sl.get<ListPathshalasController>();
  late final SnackbarNotifier snackbarNotifier;

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    listPathshalasController.load(organizationId: _organizationId, snackbarNotifier: snackbarNotifier);
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AddPersonRegistryView()),
        );
        break;
      default:
        setState(() => _selectedIndex = index);
    }
  }

  void _refreshList() {
    listPathshalasController.load(organizationId: _organizationId, snackbarNotifier: snackbarNotifier);
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
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddNewPatshalaView()))
            .then((_) => _refreshList());
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 52,
        width: isNarrow ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: colors.primaryColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Add New Pathshala',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text('No Pathshalas found.', style: TextStyle(color: colors.hintColor)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 320,
      ),
      itemBuilder: (context, index) {
        final pathshala = pathshalas[index];
        return CustomPathshalaCard(
          name: pathshala.name,
          code: pathshala.code,
          location: _locationOf(pathshala),
          isActive: pathshala.isOperational,
          onView: () {},
          onEdit: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddNewPatshalaView(existingPathshala: pathshala)))
                .then((_) => _refreshList());
          },
        );
      },
      itemCount: pathshalas.length,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, colors, isNarrow),
                      const SizedBox(height: 24),
                      CustomSearchFilterBar(
                        onSearchChanged: (query) => listPathshalasController.load(
                          organizationId: _organizationId,
                          searchQuery: query,
                          snackbarNotifier: snackbarNotifier,
                        ),
                      ),
                      const SizedBox(height: 24),
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
