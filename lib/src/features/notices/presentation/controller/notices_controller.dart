import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../../pathshala/domain/params/list_pathshalas_params.dart';
import '../../../pathshala/domain/usecases/list_pathshalas.dart';
import '../../domain/notices_domain.dart';

class NoticesController extends ChangeNotifier {
  final GetNotices getNotices;
  final PublishNotice publishNotice;
  final UpdateNotice updateNotice;
  final DeleteNotice deleteNotice;
  final ListPathshalas? listPathshalas;

  NoticesController({
    required this.getNotices,
    required this.publishNotice,
    required this.updateNotice,
    required this.deleteNotice,
    this.listPathshalas,
  });

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  final ProcessStatusNotifier actionStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<Notice> _notices = [];
  List<Notice> get notices => _notices;

  List<Pathshala> _pathshalas = [];
  List<Pathshala> get pathshalas => _pathshalas;

  String? _selectedPathshalaId;
  String? get selectedPathshalaId => _selectedPathshalaId;

  Future<void> load({
    String organizationId = AppConfig.defaultOrganizationId,
    String? pathshalaId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedPathshalaId = pathshalaId;
    processStatusNotifier.setLoading();
    notifyListeners();

    if (listPathshalas != null && _pathshalas.isEmpty) {
      final pResult = await handleFutureRequest(
        request: () => listPathshalas!.call(
          ListPathshalasParams(organizationId: organizationId),
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

  Future<bool> createNewNotice({
    required String title,
    required String content,
    NoticeStatus status = NoticeStatus.published,
    String? pathshalaId,
    String organizationId = AppConfig.defaultOrganizationId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    actionStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => publishNotice.call(
        PublishNoticeParams(
          organizationId: organizationId,
          pathshalaId: pathshalaId,
          title: title,
          content: content,
          status: status,
          createdByUserId: '30000000-0000-0000-0000-000000000001',
          targets: [],
        ),
      ),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: actionStatusNotifier,
    );

    if (result != null) {
      actionStatusNotifier.setEnabled();
      await load(
        organizationId: organizationId,
        pathshalaId: _selectedPathshalaId,
        snackbarNotifier: null,
      );
      return true;
    } else {
      actionStatusNotifier.setError();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExistingNotice({
    required String id,
    required String title,
    required String content,
    required NoticeStatus status,
    String? pathshalaId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    actionStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => updateNotice.call(
        UpdateNoticeParams(
          id: id,
          title: title,
          content: content,
          status: status,
          pathshalaId: pathshalaId,
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
        snackbarNotifier: null,
      );
      return true;
    } else {
      actionStatusNotifier.setError();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExistingNotice({
    required String id,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    actionStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => deleteNotice.call(DeleteNoticeParams(id: id)),
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: actionStatusNotifier,
    );

    if (result == true) {
      _notices.removeWhere((n) => n.id == id);
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
