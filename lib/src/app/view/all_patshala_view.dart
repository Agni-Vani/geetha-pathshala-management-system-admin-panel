import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_pathshala_card.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_search_filter_bar.dart';
import '../../features/registry/presentation/widgets/custom_widgets/responsive_app_shell.dart';
import '../../features/registry/presentation/view/add_new_patshala_view.dart';
import '../../features/registry/presentation/view/add_person_view.dart';

class _PathshalaCardData {
  final String name;
  final String code;
  final String location;
  final int studentsCount;
  final int teachersCount;
  final bool isActive;

  const _PathshalaCardData({
    required this.name,
    required this.code,
    required this.location,
    required this.studentsCount,
    required this.teachersCount,
    required this.isActive,
  });
}

class AllPatshalaView extends StatefulWidget {
  const AllPatshalaView({super.key});

  @override
  State<AllPatshalaView> createState() => _AllPatshalaViewState();
}

class _AllPatshalaViewState extends State<AllPatshalaView> {
  // TODO: replace with real data from ListPathshalas once the list screen
  // is wired to the registry usecases.
  static const _demoPathshalas = [
    _PathshalaCardData(
      name: 'Gita Sangha Pathshala',
      code: 'PTH-001',
      location: 'Dhaka, Main Branch',
      studentsCount: 120,
      teachersCount: 5,
      isActive: true,
    ),
    _PathshalaCardData(
      name: 'Radha Madhav Pathshala',
      code: 'PTH-002',
      location: 'Chattogram, North Branch',
      studentsCount: 84,
      teachersCount: 4,
      isActive: true,
    ),
    _PathshalaCardData(
      name: 'Nitai Gaur Pathshala',
      code: 'PTH-003',
      location: 'Sylhet, Central Branch',
      studentsCount: 56,
      teachersCount: 3,
      isActive: false,
    ),
    _PathshalaCardData(
      name: 'Gopal Sundar Pathshala',
      code: 'PTH-004',
      location: 'Khulna, South Branch',
      studentsCount: 98,
      teachersCount: 4,
      isActive: true,
    ),
    _PathshalaCardData(
      name: 'Shyam Sundar Pathshala',
      code: 'PTH-005',
      location: 'Rajshahi, East Branch',
      studentsCount: 72,
      teachersCount: 3,
      isActive: true,
    ),
    _PathshalaCardData(
      name: 'Vrindavan Dham Pathshala',
      code: 'PTH-006',
      location: 'Barishal, Main Branch',
      studentsCount: 40,
      teachersCount: 2,
      isActive: false,
    ),
  ];

  int _selectedIndex = 1;

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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNewPatshalaView()));
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
                      const CustomSearchFilterBar(),
                      const SizedBox(height: 24),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          mainAxisExtent: 320,
                        ),
                        itemBuilder: (context, index) {
                          final pathshala = _demoPathshalas[index];
                          return CustomPathshalaCard(
                            name: pathshala.name,
                            code: pathshala.code,
                            location: pathshala.location,
                            studentsCount: pathshala.studentsCount,
                            teachersCount: pathshala.teachersCount,
                            isActive: pathshala.isActive,
                            onView: () {},
                            onEdit: () {},
                          );
                        },
                        itemCount: _demoPathshalas.length,
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
