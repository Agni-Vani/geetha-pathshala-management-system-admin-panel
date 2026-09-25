import 'package:flutter/material.dart';

import '../../features/dashboard/presentation/view/dashboard_view.dart';
import '../../features/education/presentation/view/attendance_view.dart';
import '../../features/education/presentation/view/students_view.dart';
import '../../features/education/presentation/view/teachers_view.dart';
import '../../features/pathshala/presentation/view/all_patshala_view.dart';
import '../../features/person/presentation/view/all_people_view.dart';
import '../../features/reports/presentation/view/reports_view.dart';
import '../../features/settings/presentation/view/settings_view.dart';
import 'app_route_names.dart';

abstract final class AppRouteBuilders {
  static Map<String, WidgetBuilder> get routes => {
    AppRouteNames.dashboard: (_) => const DashboardView(),
    AppRouteNames.pathshalas: (_) => const AllPatshalaView(),
    AppRouteNames.peopleRegistry: (_) => const AllPeopleView(),
    AppRouteNames.students: (_) => const StudentsView(),
    AppRouteNames.teachers: (_) => const TeachersView(),
    AppRouteNames.attendance: (_) => const AttendanceView(),
    AppRouteNames.reports: (_) => const ReportsView(),
    AppRouteNames.settings: (_) => const SettingsView(),
  };
}

typedef RegistryRouteBuilders = AppRouteBuilders;
