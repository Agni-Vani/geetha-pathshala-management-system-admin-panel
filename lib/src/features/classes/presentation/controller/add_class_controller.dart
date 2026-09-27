import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../../teachers/domain/teachers_domain.dart';

class AddClassController extends ChangeNotifier {
  final ListTeachers listTeachers;

  AddClassController({required this.listTeachers});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Teacher> _teachers = [];
  List<Teacher> get teachers => _teachers;

  Future<void> loadTeachers({SnackbarNotifier? snackbarNotifier}) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listTeachers.call(const ListTeachersParams()),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _teachers = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }

  void addTeacher(Teacher teacher) {
    _teachers = [..._teachers, teacher];
    notifyListeners();
  }
}
