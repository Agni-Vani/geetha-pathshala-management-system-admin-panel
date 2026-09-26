import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../features/authentication/presentation/controller/auth_controller.dart';
import 'app_route_names.dart';

abstract final class AppSidebarNavigation {
  static String routeForIndex(int index) {
    switch (index) {
      case 0:
        return AppRouteNames.dashboard;
      case 1:
        return AppRouteNames.pathshalas;
      case 2:
        return AppRouteNames.areas;
      case 3:
        return AppRouteNames.peopleRegistry;
      case 4:
        return AppRouteNames.students;
      case 5:
        return AppRouteNames.teachers;
      case 6:
        return AppRouteNames.attendance;
      case 7:
        return AppRouteNames.notices;
      case 8:
        return AppRouteNames.events;
      case 9:
        return AppRouteNames.reports;
      case 10:
        return AppRouteNames.settings;
      default:
        return AppRouteNames.pathshalas;
    }
  }

  static void navigateToIndex(BuildContext context, int index) {
    final route = routeForIndex(index);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == route) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  static void pushReplacement(BuildContext context, int index) {
    navigateToIndex(context, index);
  }

  static Future<void> logout(BuildContext context) async {
    await sl<AuthController>().logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouteNames.login,
        (route) => false,
      );
    }
  }
}

typedef RegistrySidebarNavigation = AppSidebarNavigation;
