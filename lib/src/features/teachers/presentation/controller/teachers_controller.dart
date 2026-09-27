import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/teachers_domain.dart';

class TeachersController extends ChangeNotifier {
  final ListTeachers listTeachers;

  TeachersController({required this.listTeachers});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Teacher> _teachers = [];
  List<Teacher> get teachers => _teachers;

  String? _selectedPathshala;
  String? get selectedPathshala => _selectedPathshala;

  String? _selectedSubject;
  String? get selectedSubject => _selectedSubject;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> load({
    String? pathshalaId,
    String? subject,
    String? search,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedPathshala = pathshalaId;
    _selectedSubject = subject;
    _searchQuery = search ?? '';
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listTeachers.call(
        ListTeachersParams(
          pathshalaId: pathshalaId,
          subject: subject,
          search: search,
        ),
      ),
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
}
