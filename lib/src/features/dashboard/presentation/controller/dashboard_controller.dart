import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/dashboard_domain.dart';

class DashboardController extends ChangeNotifier {
  final GetDashboardOverview getDashboardOverview;

  DashboardController({required this.getDashboardOverview});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  DashboardOverview? _overview;
  DashboardOverview? get overview => _overview;

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
      request: () => getDashboardOverview.call(
        GetDashboardOverviewParams(pathshalaId: pathshalaId),
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
