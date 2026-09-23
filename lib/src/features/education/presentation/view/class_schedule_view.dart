import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../registry/domain/registry_domain.dart';
import '../../../registry/presentation/widgets/custom_widgets/custom_empty_state.dart';
import '../../../registry/presentation/widgets/custom_widgets/responsive_app_shell.dart';
import '../../../registry/presentation/view/registry_sidebar_navigation.dart';

class _ScheduleRow {
  final String subject;
  final String day;
  final String time;
  final String teacher;

  const _ScheduleRow({
    required this.subject,
    required this.day,
    required this.time,
    required this.teacher,
  });
}

// TODO: static design-stage data — no class-schedule entity/usecase exists
// yet in the domain layer; wire this up once one is added.
const _demoSchedule = [
  _ScheduleRow(subject: 'শ্রীমদ্ভগবদ্গীতা', day: 'শনিবার', time: 'সকাল ১০:০০ - ১১:৩০', teacher: 'অনির্বাণ সেন'),
  _ScheduleRow(subject: 'সংস্কৃত', day: 'শনিবার', time: 'সকাল ১১:৩০ - ১২:৩০', teacher: 'ইশিতা পাল'),
  _ScheduleRow(subject: 'ভজন ও কীর্তন', day: 'রবিবার', time: 'বিকাল ৪:০০ - ৫:০০', teacher: 'অনির্বাণ সেন'),
];

class ClassScheduleView extends StatefulWidget {
  final Pathshala pathshala;

  const ClassScheduleView({super.key, required this.pathshala});

  @override
  State<ClassScheduleView> createState() => _ClassScheduleViewState();
}

class _ClassScheduleViewState extends State<ClassScheduleView> {
  final ScrollController _tableScrollController = ScrollController();

  final int _selectedIndex = 1;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
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
                      _buildBreadcrumb(colors),
                      const SizedBox(height: 20),
                      _buildHeader(colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      _demoSchedule.isEmpty ? _buildEmptyState() : _buildTable(colors),
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

  Widget _buildBreadcrumb(AppColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Pathshalas', style: TextStyle(fontSize: 12, color: colors.hintColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
        ),
        Flexible(
          child: Text(
            widget.pathshala.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colors.textColor, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
        ),
        Text('ক্লাস সময়সূচী', style: TextStyle(fontSize: 12, color: colors.hintColor)),
      ],
    );
  }

  Widget _buildHeader(AppColors colors, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ক্লাস সময়সূচী',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          widget.pathshala.name,
          style: TextStyle(color: colors.hintColor),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const CustomEmptyState(
      icon: Icons.event_busy_outlined,
      title: 'কোনো ক্লাস সময়সূচী নেই',
      message: 'এই পাঠশালার জন্য এখনো কোনো ক্লাস নির্ধারিত হয়নি।',
    );
  }

  Widget _buildTable(AppColors colors) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
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
                  DataColumn(label: Text('বিষয়')),
                  DataColumn(label: Text('বার')),
                  DataColumn(label: Text('সময়')),
                  DataColumn(label: Text('শিক্ষক')),
                ],
                rows: [
                  for (final row in _demoSchedule)
                    DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                                child: Icon(Icons.menu_book_outlined, size: 16, color: colors.primaryColor),
                              ),
                              const SizedBox(width: 10),
                              Text(row.subject, style: TextStyle(fontWeight: FontWeight.w600, color: colors.textColor)),
                            ],
                          ),
                        ),
                        DataCell(Text(row.day)),
                        DataCell(Text(row.time)),
                        DataCell(Text(row.teacher)),
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
