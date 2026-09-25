import 'package:flutter/material.dart';

import 'registry_route_names.dart';

abstract final class RegistrySidebarNavigation {
  static String routeForIndex(int index) {
    switch (index) {
      case 0:
        return RegistryRouteNames.dashboard;
      case 1:
        return RegistryRouteNames.pathshalas;
      case 2:
        return RegistryRouteNames.peopleRegistry;
      case 3:
        return RegistryRouteNames.students;
      case 4:
        return RegistryRouteNames.teachers;
      case 5:
        return RegistryRouteNames.attendance;
      case 6:
      //   return RegistryRouteNames.notices;
      // case 7:
      //   return RegistryRouteNames.events;
      // case 8:
      //   return RegistryRouteNames.reports;
      case 7:
        return RegistryRouteNames.settings;
      default:
        return RegistryRouteNames.pathshalas;
    }
  }

  static void pushReplacement(BuildContext context, int index) {
    Navigator.of(context).pushReplacementNamed(routeForIndex(index));
  }
}
