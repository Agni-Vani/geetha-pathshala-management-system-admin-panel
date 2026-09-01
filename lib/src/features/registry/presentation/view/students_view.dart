import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/custom_button.dart';
import '../widgets/custom_widgets/custom_search_filter_bar.dart';
import '../widgets/custom_widgets/custom_status_badge.dart';
import '../widgets/custom_widgets/responsive_app_shell.dart';
import 'registry_sidebar_navigation.dart';

class _StudentRow {
  final String name;
  final String studentClass;
  final String pathshala;
  final bool isActive;

  const _StudentRow({
    required this.name,
    required this.studentClass,
    required this.pathshala,
    required this.isActive,
  });
}

// TODO: static design-stage data — swap for a real ListStudents usecase
// once the education feature exposes one.
const _demoStudents = [
  _StudentRow(
    name: 'অনন্যা শর্মা',
    studentClass: 'শ্রেণি ৫',
    pathshala: 'Chattogram North Gita Pathshala',
    isActive: true,
  ),
  _StudentRow(
    name: 'বিবান পাটেল',
    studentClass: 'শ্রেণি ৬',
    pathshala: 'Dhaka Central Gita Pathshala',
    isActive: true,
  ),
  _StudentRow(
    name: 'ইশিকা ভার্মা',
    studentClass: 'শ্রেণি ৪',
    pathshala: 'Sylhet East Gita Pathshala',
    isActive: true,
  ),
  _StudentRow(
    name: 'কৃষ্ণ তিওয়ারি',
    studentClass: 'শ্রেণি ৭',
    pathshala: 'Chattogram North Gita Pathshala',
    isActive: true,
  ),
  _StudentRow(
    name: 'মায়রা জোশী',
    studentClass: 'শ্রেণি ৩',
    pathshala: 'Dhaka Central Gita Pathshala',
    isActive: false,
  ),
  _StudentRow(
    name: 'অর্জুন সিং',
    studentClass: 'শ্রেণি ৫',
    pathshala: 'Sylhet East Gita Pathshala',
    isActive: true,
  ),
];

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  final ScrollController _tableScrollController = ScrollController();

  int _selectedIndex = 3;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors, isNarrow),
                      const SizedBox(height: 24),
                      CustomSearchFilterBar(
                        searchHint: 'Search students...',
                        districtHint: 'All Classes',
                        branchHint: 'All Pathshalas',
                      ),
                      const SizedBox(height: 24),
                      _buildTable(colors, isNarrow),
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

  Widget _buildHeader(AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'শিক্ষার্থী',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'সকল পাঠশালার নিবন্ধিত শিক্ষার্থীদের তালিকা ও পরিচালনা।',
          style: TextStyle(color: colors.hintColor),
        ),
      ],
    );

    final addButton = SizedBox(
      width: isNarrow ? double.infinity : null,
      child: CustomButton(
        label: 'Add Student',
        icon: Icons.add,
        onPressed: () {},
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleBlock, const SizedBox(height: 16), addButton],
      );
    }

    // CustomButton (ElevatedButton/OutlinedButton) needs a bounded width
    // here — as a bare Row child it gets an unbounded main-axis width from
    // Row's non-flex-child layout, which crashes Material's tap-target
    // padding. IntrinsicWidth bounds it to its natural content size.
    return Row(
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        IntrinsicWidth(child: addButton),
      ],
    );
  }

  Widget _buildTable(AppColors colors, bool isNarrow) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Scrollbar(
          controller: _tableScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _tableScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(colors.tileColor),
                columns: const [
                  DataColumn(label: Text('নাম')),
                  DataColumn(label: Text('শ্রেণি')),
                  DataColumn(label: Text('পাঠশালা')),
                  DataColumn(label: Text('স্ট্যাটাস')),
                  DataColumn(label: Text('কার্যক্রম')),
                ],
                rows: [
                  for (final student in _demoStudents)
                    DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: colors.primaryColor.withValues(
                                  alpha: 0.12,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 18,
                                  color: colors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                student.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: colors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(student.studentClass)),
                        DataCell(Text(student.pathshala)),
                        DataCell(
                          CustomStatusBadge(
                            label: student.isActive ? 'Active' : 'Inactive',
                            tone: student.isActive
                                ? StatusTone.positive
                                : StatusTone.neutral,
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
