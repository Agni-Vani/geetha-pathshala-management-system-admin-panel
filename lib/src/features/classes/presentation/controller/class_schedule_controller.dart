import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/classes_domain.dart';

class ClassScheduleController extends ChangeNotifier {
  final ListClassSchedules listClassSchedules;

  ClassScheduleController({required this.listClassSchedules});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<ClassSchedule> _schedules = [];
  List<ClassSchedule> get schedules => _schedules;

  String? _pathshalaId;
  String? get pathshalaId => _pathshalaId;

  Future<void> load({
    String? pathshalaId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _pathshalaId = pathshalaId;
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listClassSchedules.call(
        ListClassSchedulesParams(pathshalaId: pathshalaId),
      ),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _schedules = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }
}
