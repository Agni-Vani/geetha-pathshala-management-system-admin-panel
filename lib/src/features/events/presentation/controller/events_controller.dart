import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/events_domain.dart';

class EventsController extends ChangeNotifier {
  final ListEvents listEvents;

  EventsController({required this.listEvents});

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Event> _events = [];
  List<Event> get events => _events;

  String? _selectedScope;
  String? get selectedScope => _selectedScope;

  Future<void> load({
    String? pathshalaId,
    String? scope,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedScope = scope;
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listEvents.call(
        ListEventsParams(pathshalaId: pathshalaId, scope: scope),
      ),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _events = result;
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setError();
    }
    notifyListeners();
  }
}
