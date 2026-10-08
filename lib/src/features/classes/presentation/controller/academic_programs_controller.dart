import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

class AcademicProgramsController extends ChangeNotifier {
  final ListAcademicPrograms listAcademicPrograms;
  final CreateAcademicProgram createAcademicProgram;
  final ListAcademicLevels listAcademicLevels;
  final CreateAcademicLevel createAcademicLevel;

  AcademicProgramsController({
    required this.listAcademicPrograms,
    required this.createAcademicProgram,
    required this.listAcademicLevels,
    required this.createAcademicLevel,
  });

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<AcademicProgram> _programs = [];
  List<AcademicProgram> get programs => _programs;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<AcademicProgram> get filteredPrograms {
    if (_searchQuery.trim().isEmpty) return _programs;
    final q = _searchQuery.toLowerCase();
    return _programs.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q) ||
          p.levelTermLabel.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> load({SnackbarNotifier? snackbarNotifier}) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listAcademicPrograms.call(),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _programs = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<AcademicProgram?> addProgram(
    CreateAcademicProgramParams params, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createAcademicProgram.call(params),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      await load(snackbarNotifier: snackbarNotifier);
      return result;
    }
    processStatusNotifier.setEnabled();
    notifyListeners();
    return null;
  }

  Future<AcademicLevel?> addLevel(
    CreateAcademicLevelParams params, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createAcademicLevel.call(params),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      await load(snackbarNotifier: snackbarNotifier);
      return result;
    }
    processStatusNotifier.setEnabled();
    notifyListeners();
    return null;
  }
}
