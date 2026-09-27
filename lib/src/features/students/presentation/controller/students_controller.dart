import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/students_domain.dart';

class StudentsController extends ChangeNotifier {
  final ListStudents listStudents;

  StudentsController({required this.listStudents});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Student> _students = [];
  List<Student> get students => _students;

  String? _selectedClass;
  String? get selectedClass => _selectedClass;

  String? _selectedPathshala;
  String? get selectedPathshala => _selectedPathshala;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> load({
    String? pathshalaId,
    String? studentClass,
    String? search,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedPathshala = pathshalaId;
    _selectedClass = studentClass;
    _searchQuery = search ?? '';
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listStudents.call(
        ListStudentsParams(
          pathshalaId: pathshalaId,
          studentClass: studentClass,
          search: search,
        ),
      ),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _students = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }
}
