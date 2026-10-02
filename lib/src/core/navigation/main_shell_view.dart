import 'package:flutter/material.dart';

import '../../features/areas/presentation/view/areas_view.dart';
import '../../features/attendance/presentation/view/attendance_view.dart';
import '../../features/dashboard/presentation/view/dashboard_view.dart';
import '../../features/events/presentation/view/events_view.dart';
import '../../features/notices/presentation/view/notices_view.dart';
import '../../features/pathshala/presentation/view/all_patshala_view.dart';
import '../../features/person/presentation/view/all_people_view.dart';
import '../../features/person/presentation/view/students_view.dart';
import '../../features/person/presentation/view/teachers_view.dart';
import '../../features/reports/presentation/view/reports_view.dart';
import '../../features/settings/presentation/view/settings_view.dart';
import '../shared/widget/custom_widgets/responsive_app_shell.dart';

/// Top-level shell that hosts the persistent sidebar and top bar.
///
/// Navigating between top-level tabs updates the internal [IndexedStack]
/// without replacing the route, keeping the sidebar stationary and mounted.
class MainShellView extends StatefulWidget {
  final int initialIndex;

  const MainShellView({super.key, this.initialIndex = 0});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  late int _selectedIndex;
  final Set<int> _activatedIndices = {};

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _activatedIndices.add(_selectedIndex);
  }

  @override
  void didUpdateWidget(MainShellView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _selectedIndex = widget.initialIndex;
      _activatedIndices.add(_selectedIndex);
    }
  }

  void _onItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      _activatedIndices.add(index);
    });
  }

  Widget _buildView(int index) {
    switch (index) {
      case 0:
        return const DashboardView();
      case 1:
        return const AllPatshalaView();
      case 2:
        return const AreasView();
      case 3:
        return const AllPeopleView();
      case 4:
        return const StudentsView();
      case 5:
        return const TeachersView();
      case 6:
        return const AttendanceView();
      case 7:
        return const NoticesView();
      case 8:
        return const EventsView();
      case 9:
        return const ReportsView();
      case 10:
        return const SettingsView();
      default:
        return const AllPatshalaView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: _onItemSelected,
      topBarTitle: 'Overview',
      body: ShellScope(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        child: IndexedStack(
          index: _selectedIndex,
          children: List.generate(11, (i) {
            if (_activatedIndices.contains(i)) {
              return _buildView(i);
            }
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
  }
}
