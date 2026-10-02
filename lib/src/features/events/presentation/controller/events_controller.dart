import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../../pathshala/domain/params/list_pathshalas_params.dart';
import '../../../pathshala/domain/usecases/list_pathshalas.dart';
import '../../domain/events_domain.dart';

class EventsController extends ChangeNotifier {
  final ListEvents listEvents;
  final CreateEvent createEvent;
  final UpdateEvent updateEvent;
  final DeleteEvent deleteEvent;
  final ListPathshalas? listPathshalas;

  EventsController({
    required this.listEvents,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
    this.listPathshalas,
  });

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  final ProcessStatusNotifier actionStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Event> _events = [];
  List<Event> get events => _events;

  List<Pathshala> _pathshalas = [];
  List<Pathshala> get pathshalas => _pathshalas;

  String? _selectedScope;
  String? get selectedScope => _selectedScope;

  String? _selectedPathshalaId;
  String? get selectedPathshalaId => _selectedPathshalaId;

  Future<void> load({
    String? pathshalaId,
    String? scope,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedPathshalaId = pathshalaId;
    _selectedScope = scope;
    processStatusNotifier.setLoading();
    notifyListeners();

    if (listPathshalas != null && _pathshalas.isEmpty) {
      final pResult = await handleFutureRequest(
        request: () => listPathshalas!.call(
          const ListPathshalasParams(organizationId: AppConfig.defaultOrganizationId),
        ),
        successSnackbarNotifier: null,
        errorSnackbarNotifier: null,
        processStatusNotifier: null,
      );
      if (pResult != null) {
        _pathshalas = pResult;
      }
    }

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

  Future<bool> createNewEvent({
    required String title,
    String? description,
    required DateTime eventDate,
    String? time,
    String scope = 'All Pathshalas',
    String? pathshalaId,
    String? iconName,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    actionStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createEvent.call(
        CreateEventParams(
          title: title,
          description: description,
          eventDate: eventDate,
          time: time,
          scope: scope,
          pathshalaId: pathshalaId,
          iconName: iconName,
        ),
      ),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: actionStatusNotifier,
    );

    if (result != null) {
      actionStatusNotifier.setEnabled();
      await load(
        pathshalaId: _selectedPathshalaId,
        scope: _selectedScope,
        snackbarNotifier: null,
      );
      return true;
    } else {
      actionStatusNotifier.setError();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExistingEvent({
    required String id,
    required String title,
    String? description,
    required DateTime eventDate,
    String? time,
    String scope = 'All Pathshalas',
    String? pathshalaId,
    String? iconName,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    actionStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => updateEvent.call(
        UpdateEventParams(
          id: id,
          title: title,
          description: description,
          eventDate: eventDate,
          time: time,
          scope: scope,
          pathshalaId: pathshalaId,
          iconName: iconName,
        ),
      ),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: actionStatusNotifier,
    );

    if (result != null) {
      actionStatusNotifier.setEnabled();
      await load(
        pathshalaId: _selectedPathshalaId,
        scope: _selectedScope,
        snackbarNotifier: null,
      );
      return true;
    } else {
      actionStatusNotifier.setError();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExistingEvent({
    required String id,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    actionStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => deleteEvent.call(DeleteEventParams(id: id)),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: actionStatusNotifier,
    );

    if (result == true) {
      _events.removeWhere((e) => e.id == id);
      actionStatusNotifier.setEnabled();
      notifyListeners();
      return true;
    } else {
      actionStatusNotifier.setError();
      notifyListeners();
      return false;
    }
  }
}
