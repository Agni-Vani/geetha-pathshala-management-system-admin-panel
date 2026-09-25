import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';

class ListPathshalasController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());
  final ListPathshalas listPathshalas;

  ListPathshalasController({required this.listPathshalas});

  List<Pathshala> pathshalas = [];

  Future<void> load({
    required String organizationId,
    String? searchQuery,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    await handleFutureRequest(
      request: () => listPathshalas.call(
        ListPathshalasParams(organizationId: organizationId, searchQuery: searchQuery),
      ),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (data) {
        pathshalas = data;
        notifyListeners();
      },
    );
  }
}
