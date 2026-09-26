import 'package:flutter/widgets.dart';
import '../../features/authentication/presentation/view/login_view.dart';
import '../../features/dashboard/presentation/view/dashboard_view.dart';
import '../../features/attendance/presentation/view/attendance_view.dart';
import '../../features/students/presentation/view/students_view.dart';
import '../../features/teachers/presentation/view/teachers_view.dart';
import '../../features/events/presentation/view/events_view.dart';
import '../../features/notices/presentation/view/notices_view.dart';
import '../../features/pathshala/presentation/view/all_patshala_view.dart';
import '../../features/person/presentation/view/all_people_view.dart';
import '../../features/reports/presentation/view/reports_view.dart';
import '../../features/settings/presentation/view/settings_view.dart';
import 'app_route_names.dart';

abstract final class AppRouteBuilders {
  static Map<String, WidgetBuilder> get routes => {
    AppRouteNames.login: (_) => const LoginView(),
    AppRouteNames.dashboard: (_) => const DashboardView(),
    AppRouteNames.pathshalas: (_) => const AllPatshalaView(),
    AppRouteNames.peopleRegistry: (_) => const AllPeopleView(),
    AppRouteNames.students: (_) => const StudentsView(),
    AppRouteNames.teachers: (_) => const TeachersView(),
    AppRouteNames.attendance: (_) => const AttendanceView(),
    AppRouteNames.notices: (_) => const NoticesView(),
    AppRouteNames.events: (_) => const EventsView(),
    AppRouteNames.reports: (_) => const ReportsView(),
    AppRouteNames.settings: (_) => const SettingsView(),
  };
}

typedef RegistryRouteBuilders = AppRouteBuilders;
