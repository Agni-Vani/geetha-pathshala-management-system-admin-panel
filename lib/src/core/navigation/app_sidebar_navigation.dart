import 'package:flutter/material.dart';

import 'app_route_names.dart';

abstract final class AppSidebarNavigation {
  static String routeForIndex(int index) {
    switch (index) {
      case 0:
        return AppRouteNames.dashboard;
      case 1:
        return AppRouteNames.pathshalas;
      case 2:
        return AppRouteNames.peopleRegistry;
      case 3:
        return AppRouteNames.students;
      case 4:
        return AppRouteNames.teachers;
      case 5:
        return AppRouteNames.attendance;
      case 6:
        return AppRouteNames.notices;
      case 7:
        return AppRouteNames.events;
      case 8:
        return AppRouteNames.reports;
      case 9:
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
}

typedef RegistrySidebarNavigation = AppSidebarNavigation;
