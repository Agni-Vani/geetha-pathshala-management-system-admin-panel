import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/custom_search_filter_bar.dart';
import '../../../../core/shared/widget/custom_widgets/custom_status_badge.dart';
import '../../../../core/shared/widget/custom_widgets/pinned_header_card_page.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../domain/person_domain.dart';
import '../controller/teachers_controller.dart';
import 'add_teacher_view.dart';

class TeachersView extends StatefulWidget {
  const TeachersView({super.key});

  @override
  State<TeachersView> createState() => _TeachersViewState();
}

class _TeachersViewState extends State<TeachersView> {
  final ScrollController _tableScrollController = ScrollController();
  late final TeachersController _controller;
  int _selectedIndex = 6;

  @override
  void initState() {
    super.initState();
    _controller = sl<TeachersController>();
    _controller.load();
  }

  Future<void> _addNewTeacher() async {
    final teacher = await Navigator.of(
      context,
    ).push<Teacher>(MaterialPageRoute(builder: (_) => const AddTeacherView()));
    if (teacher == null) return;
    _controller.load();
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
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      showBackgroundImage: false,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final teachers = _controller.teachers;

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 640;
                    final gap = AppSizes.sectionGap(context);
                    final cardInset = PinnedHeaderCardPage.cardInset(context);

                    return PinnedHeaderCardPage(
                      header: _buildHeader(colors, isNarrow),
                      card: SingleChildScrollView(
                        padding: EdgeInsets.all(cardInset),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSearchFilterBar(
                              flat: true,
                              searchHint: 'Search teachers...',
                              districtHint: 'All Subjects',
                              branchHint: 'All Pathshalas',
                              onSearchChanged: (query) {
                                _controller.load(
                                  search: query,
                                  subject: _controller.selectedSubject,
                                  pathshalaId: _controller.selectedPathshala,
                                );
                              },
                            ),
                            SizedBox(height: gap),
                            _buildTable(colors, teachers),
                          ],
                        ),
                      ),
                    );
                  },
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

  Widget _buildHeader(AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBreadcrumbs(
          items: [
            BreadcrumbItem.home(context),
            const BreadcrumbItem(label: 'শিক্ষক', icon: Icons.badge_outlined),
          ],
        ),
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

    return Row(
      // The button rests on the same line as the bottom of the description.
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        IntrinsicWidth(child: addButton),
      ],
    );
  }

  Widget _buildTable(AppColors colors, List<Teacher> teachers) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // Sits inside the page's card, so it carries no surface or shadow
        // of its own — just a hairline around the table.
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerColor.withValues(alpha: .7)),
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
                  for (final teacher in teachers)
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
