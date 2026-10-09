import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/academic_programs_controller.dart';
import '../widgets/academic_programs_management_widget.dart';

class AcademicProgramsView extends StatelessWidget {
  final AcademicProgramsController? controller;

  const AcademicProgramsView({super.key, this.controller});

  static const int _selectedIndex = 2;

  void _onSidebarItemSelected(BuildContext context, int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: (idx) => _onSidebarItemSelected(context, idx),
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBreadcrumbs(
                    items: [
                      BreadcrumbItem.home(context),
                      const BreadcrumbItem(
                        label: 'একাডেমিক প্রোগ্রাম ও স্তর',
                        icon: Icons.auto_stories_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AcademicProgramsManagementWidget(controller: controller),
                ],
              ),
            ),
          ),
          Container(
            color: colors.tileColor,
            height: 40,
            child: Center(
              child: Text(
                '© 2026 Geetha Pathshala Management. All rights reserved.',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
