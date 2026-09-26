import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/attendance_domain.dart';

class AttendanceController extends ChangeNotifier {
  final GetAttendanceOverview getAttendanceOverview;

  AttendanceController({required this.getAttendanceOverview});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  AttendanceOverview? _overview;
  AttendanceOverview? get overview => _overview;

  List<AttendanceSummaryStat> get summaryStats =>
      _overview?.summaryStats ?? const [];

  List<AttendanceRowItem> get attendanceRows =>
      _overview?.attendanceRows ?? const [];

  String? _selectedPathshala;
  String? get selectedPathshala => _selectedPathshala;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  Future<void> load({
    String? pathshalaId,
    DateTime? date,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedPathshala = pathshalaId;
    _selectedDate = date;
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => getAttendanceOverview.call(
        GetAttendanceOverviewParams(
          pathshalaId: pathshalaId,
          date: date,
        ),
      ),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _overview = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }
}
