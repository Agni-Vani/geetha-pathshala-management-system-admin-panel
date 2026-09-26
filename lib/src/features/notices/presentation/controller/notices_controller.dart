import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/notices_domain.dart';

class NoticesController extends ChangeNotifier {
  final GetNotices getNotices;

  NoticesController({required this.getNotices});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Notice> _notices = [];
  List<Notice> get notices => _notices;

  Future<void> load({
    String organizationId = 'org-gp-central',
    String? pathshalaId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => getNotices.call(
        GetNoticesParams(
          organizationId: organizationId,
          pathshalaId: pathshalaId,
        ),
      ),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _notices = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }
}
