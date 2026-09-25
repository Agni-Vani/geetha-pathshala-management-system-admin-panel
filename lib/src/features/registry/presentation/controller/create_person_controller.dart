import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/registry_domain.dart';

class CreatePersonController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());
  final CreatePerson createPerson;

  CreatePersonController({required this.createPerson});

  // TODO: replace with the signed-in user's real organization id once
  // an auth/session concept exists in the app.
  final String _organizationId = 'org-gp-central';

  String _legalName = '';
  String? _preferredName;
  DateTime? _dateOfBirth;
  String? _gender;
  String? _primaryPhone;
  String? _primaryEmail;

  String get legalName => _legalName;
  String? get preferredName => _preferredName;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get gender => _gender;
  String? get primaryPhone => _primaryPhone;
  String? get primaryEmail => _primaryEmail;

  bool get isValid => _legalName.trim().isNotEmpty;

  void onChangeLegalName(String legalName) {
    _legalName = legalName;
    notifyListeners();
  }

  void onChangePreferredName(String preferredName) {
    _preferredName = preferredName.trim().isEmpty ? null : preferredName;
    notifyListeners();
  }

  void selectDateOfBirth(DateTime dateOfBirth) {
    _dateOfBirth = dateOfBirth;
    notifyListeners();
  }

  void selectGender(String? gender) {
    _gender = gender;
    notifyListeners();
  }

  void onChangePrimaryPhone(String primaryPhone) {
    _primaryPhone = primaryPhone.trim().isEmpty ? null : primaryPhone;
    notifyListeners();
  }

  void onChangePrimaryEmail(String primaryEmail) {
    _primaryEmail = primaryEmail.trim().isEmpty ? null : primaryEmail;
    notifyListeners();
  }

  Future<void> create({SnackbarNotifier? snackbarNotifier}) async {
    final params = CreatePersonParams(
      organizationId: _organizationId,
      legalName: _legalName.trim(),
      preferredName: _preferredName,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      primaryPhone: _primaryPhone,
      primaryEmail: _primaryEmail,
    );

    await handleFutureRequest(
      request: () => createPerson.call(params),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      successSnackbarNotifier: snackbarNotifier,
    );
  }
}
