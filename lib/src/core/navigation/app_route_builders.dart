import 'package:flutter/widgets.dart';

import '../../features/authentication/presentation/view/login_view.dart';
import 'app_route_names.dart';
import 'main_shell_view.dart';

abstract final class AppRouteBuilders {
  static Map<String, WidgetBuilder> get routes => {
    AppRouteNames.login: (_) => const LoginView(),
    AppRouteNames.dashboard: (_) => const MainShellView(initialIndex: 0),
    AppRouteNames.pathshalas: (_) => const MainShellView(initialIndex: 1),
    AppRouteNames.areas: (_) => const MainShellView(initialIndex: 2),
    AppRouteNames.peopleRegistry: (_) => const MainShellView(initialIndex: 3),
    AppRouteNames.students: (_) => const MainShellView(initialIndex: 4),
    AppRouteNames.teachers: (_) => const MainShellView(initialIndex: 5),
    AppRouteNames.attendance: (_) => const MainShellView(initialIndex: 6),
    AppRouteNames.notices: (_) => const MainShellView(initialIndex: 7),
    AppRouteNames.events: (_) => const MainShellView(initialIndex: 8),
    AppRouteNames.reports: (_) => const MainShellView(initialIndex: 9),
    AppRouteNames.settings: (_) => const MainShellView(initialIndex: 10),
  };
}

typedef RegistryRouteBuilders = AppRouteBuilders;

