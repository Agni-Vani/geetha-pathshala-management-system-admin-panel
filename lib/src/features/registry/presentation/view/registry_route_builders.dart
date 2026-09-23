import 'package:flutter/material.dart';

import '../../../../app/view/all_patshala_view.dart';
import '../../../../app/view/all_people_view.dart';
import '../../../communication/presentation/view/events_view.dart';
import '../../../communication/presentation/view/notices_view.dart';
import '../../../education/presentation/view/attendance_view.dart';
import '../../../education/presentation/view/students_view.dart';
import '../../../education/presentation/view/teachers_view.dart';
import 'dashboard_view.dart';
import 'registry_route_names.dart';
import 'reports_view.dart';
import 'settings_view.dart';

abstract final class RegistryRouteBuilders {
  static Map<String, WidgetBuilder> get routes => {
    RegistryRouteNames.dashboard: (_) => const DashboardView(),
    RegistryRouteNames.pathshalas: (_) => const AllPatshalaView(),
    RegistryRouteNames.peopleRegistry: (_) => const AllPeopleView(),
    RegistryRouteNames.students: (_) => const StudentsView(),
    RegistryRouteNames.teachers: (_) => const TeachersView(),
    RegistryRouteNames.attendance: (_) => const AttendanceView(),
    RegistryRouteNames.notices: (_) => const NoticesView(),
    RegistryRouteNames.events: (_) => const EventsView(),
    RegistryRouteNames.reports: (_) => const ReportsView(),
    RegistryRouteNames.settings: (_) => const SettingsView(),
  };
}
