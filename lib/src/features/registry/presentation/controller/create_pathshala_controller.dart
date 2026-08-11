import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';

class CreatePathshalaController extends ChangeNotifier{
  /// Initialized with default value[ProcessDisabled]
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());
  final CreatePathshala createPathshala;

  CreatePathshalaController({required this.createPathshala});

  Future<void> create({
    required CreatePathshalaParams params,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    await handleFutureRequest(
      request: () => createPathshala.call(params),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      successSnackbarNotifier: snackbarNotifier,
    );
  }
}