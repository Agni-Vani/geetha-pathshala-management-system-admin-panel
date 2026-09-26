import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../../pathshala/domain/pathshala_domain.dart';
import '../../domain/entities/class_schedule.dart';
import '../controller/class_schedule_controller.dart';

class ClassScheduleView extends StatefulWidget {
  final Pathshala pathshala;
  final ClassScheduleController? controller;

  const ClassScheduleView({
    super.key,
    required this.pathshala,
    this.controller,
  });

  @override
  State<ClassScheduleView> createState() => _ClassScheduleViewState();
}

class _ClassScheduleViewState extends State<ClassScheduleView> {
  final ScrollController _tableScrollController = ScrollController();
  late final ClassScheduleController _controller;

  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? sl<ClassScheduleController>();
    _controller.load(pathshalaId: widget.pathshala.id);
  }

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
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final schedules = _controller.schedules;
          final isLoading = _controller.processStatusNotifier.status is ProcessLoading;

          return Column(
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
                          if (isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(48.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (schedules.isEmpty)
                            _buildEmptyState()
                          else
                            _buildTable(colors, schedules),
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
          );
        },
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

  Widget _buildTable(AppColors colors, List<ClassSchedule> schedules) {
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
                  for (final row in schedules)
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
