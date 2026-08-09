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

  Future<void> create({SnackbarNotifier? snackbarNotifier}) async{
    processStatusNotifier.setLoading();
    // await handleFutureRequest(request: ()=> createPathshala.call(
    //   CreatePathshalaParams(
    //     organizationId: '',
    //     code: '',
    //     name: '',
    //     address: PathshalaAddress(
          
    //     ),
    //     coordinate: null,
    //     startedOn: null
    //   ),
    // ),
    // errorSnackbarNotifier: snackbarNotifier,
    // successSnackbarNotifier: snackbarNotifier
    // );
  }
}