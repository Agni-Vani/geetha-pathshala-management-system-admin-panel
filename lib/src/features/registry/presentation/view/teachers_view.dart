import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/custom_button.dart';
import '../widgets/custom_widgets/custom_search_filter_bar.dart';
import '../widgets/custom_widgets/custom_status_badge.dart';
import '../widgets/custom_widgets/responsive_app_shell.dart';
import 'add_teacher_view.dart';
import 'registry_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

class _TeacherRow {
  final String name;
  final String subject;
  final String pathshala;
  final bool isActive;

  const _TeacherRow({
    required this.name,
    required this.subject,
    required this.pathshala,
    required this.isActive,
  });
}

// TODO: static design-stage data — swap for a real ListTeachers usecase
// once the education feature exposes one (currently only TeacherProfile
// creation/assignment mutations exist).
const _demoTeachers = [
  _TeacherRow(
    name: 'রমেশ শাস্ত্রী',
    subject: 'সংস্কৃত',
    pathshala: 'Dhaka Central Gita Pathshala',
    isActive: true,
  ),
  _TeacherRow(
    name: 'সরস্বতী দেবী',
    subject: 'ভগবদ্গীতা',
    pathshala: 'Chattogram North Gita Pathshala',
    isActive: true,
  ),
  _TeacherRow(
    name: 'মহেশ শর্মা',
    subject: 'হিন্দি',
    pathshala: 'Sylhet East Gita Pathshala',
    isActive: true,
  ),
  _TeacherRow(
    name: 'অঞ্জলি ভার্মা',
    subject: 'গণিত',
    pathshala: 'Dhaka Central Gita Pathshala',
    isActive: true,
  ),
  _TeacherRow(
    name: 'বিক্রম যোশী',
    subject: 'সান্ধ্যকালীন ক্লাস',
    pathshala: 'Chattogram North Gita Pathshala',
    isActive: false,
  ),
];

class TeachersView extends StatefulWidget {
  const TeachersView({super.key});

  @override
  State<TeachersView> createState() => _TeachersViewState();
}

class _TeachersViewState extends State<TeachersView> {
  final ScrollController _tableScrollController = ScrollController();

  final List<_TeacherRow> _teachers = List.of(_demoTeachers);

  int _selectedIndex = 4;

  Future<void> _addNewTeacher() async {
    final teacher = await Navigator.of(context).push<TeacherOption>(
      MaterialPageRoute(builder: (_) => const AddTeacherView()),
    );
    if (teacher == null) return;

    setState(() {
      _teachers.add(
        _TeacherRow(
          name: teacher.name,
          subject: teacher.subject ?? '—',
          pathshala: '—',
          isActive: true,
        ),
      );
    });
  }

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
              padding: AppSizes.pagePadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      CustomSearchFilterBar(
                        searchHint: 'Search teachers...',
                        districtHint: 'All Subjects',
                        branchHint: 'All Pathshalas',
                      ),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      _buildTable(colors),
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
          'শিক্ষক',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'সকল পাঠশালার নিবন্ধিত শিক্ষকদের তালিকা ও পরিচালনা।',
          style: TextStyle(color: colors.hintColor),
        ),
      ],
    );

    final addButton = SizedBox(
      width: isNarrow ? double.infinity : null,
      child: CustomButton(
        label: 'Add Teacher',
        icon: Icons.add,
        onPressed: _addNewTeacher,
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleBlock, const SizedBox(height: 16), addButton],
      );
    }

    // CustomButton needs a bounded width here — a bare Row child otherwise
    // gets an unbounded main-axis width, crashing Material's tap-target
    // padding. IntrinsicWidth bounds it to its natural content size.
    return Row(
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        IntrinsicWidth(child: addButton),
      ],
    );
  }

  Widget _buildTable(AppColors colors) {
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
                  DataColumn(label: Text('বিষয়')),
                  DataColumn(label: Text('পাঠশালা')),
                  DataColumn(label: Text('স্ট্যাটাস')),
                  DataColumn(label: Text('কার্যক্রম')),
                ],
                rows: [
                  for (final teacher in _teachers)
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
                                  Icons.badge_outlined,
                                  size: 16,
                                  color: colors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                teacher.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: colors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(teacher.subject)),
                        DataCell(Text(teacher.pathshala)),
                        DataCell(
                          CustomStatusBadge(
                            label: teacher.isActive ? 'Active' : 'Inactive',
                            tone: teacher.isActive
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
