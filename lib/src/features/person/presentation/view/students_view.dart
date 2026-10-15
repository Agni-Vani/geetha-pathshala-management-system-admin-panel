import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../../../../core/shared/widget/custom_widgets/custom_search_filter_bar.dart';
import '../../../../core/shared/widget/custom_widgets/custom_status_badge.dart';
import '../../../../core/shared/widget/custom_widgets/pinned_header_card_page.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../domain/person_domain.dart';
import '../controller/students_controller.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  final ScrollController _tableScrollController = ScrollController();
  late final StudentsController _controller;
  int _selectedIndex = 5;

  @override
  void initState() {
    super.initState();
    _controller = sl<StudentsController>();
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
          final students = _controller.students;

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 640;
                    final gap = AppSizes.sectionGap(context);
                    final status = _controller.processStatusNotifier.status;
                    final showState =
                        students.isEmpty ||
                        status is ProcessLoading ||
                        status is ProcessFailed;
                    final cardInset = PinnedHeaderCardPage.cardInset(context);
                    final listPadding = EdgeInsets.fromLTRB(
                      cardInset,
                      0,
                      cardInset,
                      cardInset,
                    );

                    return PinnedHeaderCardPage(
                      header: _buildHeader(colors, isNarrow),
                      card: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              cardInset,
                              cardInset,
                              cardInset,
                              gap,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: CustomSearchFilterBar(
                                flat: true,
                                searchHint: 'Search students...',
                                districtHint: 'All Classes',
                                branchHint: 'All Pathshalas',
                                onSearchChanged: (query) {
                                  _controller.load(
                                    search: query,
                                    studentClass: _controller.selectedClass,
                                    pathshalaId: _controller.selectedPathshala,
                                  );
                                },
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: listPadding,
                            sliver: showState
                                ? SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Align(
                                      alignment: const Alignment(0, .2),
                                      child: _buildListBody(colors, students),
                                    ),
                                  )
                                : SliverToBoxAdapter(
                                    child: _buildStudentsPanel(
                                      colors,
                                      students,
                                    ),
                                  ),
                          ),
                        ],
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
            const BreadcrumbItem(
              label: 'শিক্ষার্থী',
              icon: Icons.people_outline,
            ),
          ],
        ),
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

  Widget _buildStudentsPanel(AppColors colors, List<Student> students) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // Sits inside the page's card, so it carries no surface or shadow
        // of its own — just a hairline around the table.
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerColor.withValues(alpha: .7)),
      ),
      child: _buildListBody(colors, students),
    );
  }

  Widget _buildListBody(AppColors colors, List<Student> students) {
    final status = _controller.processStatusNotifier.status;
    if (status is ProcessLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'শিক্ষার্থীদের তথ্য লোড হচ্ছে...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.hintColor),
            ),
          ],
        ),
      );
    }
    if (status is ProcessFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomEmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'শিক্ষার্থীদের তথ্য আনা যায়নি',
              message: 'ইন্টারনেট সংযোগ যাচাই করে আবার চেষ্টা করুন।',
              showBorder: false,
              showBackground: false,
            ),
            TextButton.icon(
              onPressed: () => _controller.load(
                search: _controller.searchQuery,
                studentClass: _controller.selectedClass,
                pathshalaId: _controller.selectedPathshala,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      );
    }
    if (students.isEmpty) {
      final hasFilters =
          _controller.searchQuery.trim().isNotEmpty ||
          (_controller.selectedClass?.isNotEmpty ?? false) ||
          (_controller.selectedPathshala?.isNotEmpty ?? false);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: CustomEmptyState(
          icon: hasFilters ? Icons.search_off_rounded : Icons.school_outlined,
          title: hasFilters
              ? 'কোনো শিক্ষার্থী পাওয়া যায়নি'
              : 'এখনও কোনো শিক্ষার্থী যুক্ত হয়নি',
          message: hasFilters
              ? 'সার্চের শব্দ বা নির্বাচিত ফিল্টার পরিবর্তন করে আবার চেষ্টা করুন।'
              : 'শিক্ষার্থী যুক্ত হলে তাদের তথ্য এখানে দেখা যাবে।',
          showBorder: false,
          showBackground: false,
        ),
      );
    }
    return LayoutBuilder(
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
                for (final student in students)
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
    );
  }
}
