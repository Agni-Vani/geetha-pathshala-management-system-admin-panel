import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import '../../domain/person_domain.dart';

class UpdatePersonController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());
  final UpdatePerson updatePerson;

  UpdatePersonController({required this.updatePerson});

  Person? _person;
  String _legalName = '';
  String? _preferredName;
  DateTime? _dateOfBirth;
  String? _gender;
  String? _primaryPhone;
  String? _primaryEmail;
  PersonStatus _status = PersonStatus.active;

  Person? get person => _person;
  String get legalName => _legalName;
  String? get preferredName => _preferredName;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get gender => _gender;
  String? get primaryPhone => _primaryPhone;
  String? get primaryEmail => _primaryEmail;
  PersonStatus get status => _status;

  bool get isValid => _legalName.trim().isNotEmpty;

  void initialize(Person person) {
    _person = person;
    _legalName = person.legalName;
    _preferredName = person.preferredName;
    _dateOfBirth = person.dateOfBirth;
    _gender = person.gender;
    _primaryPhone = person.primaryPhone;
    _primaryEmail = person.primaryEmail;
    _status = person.status;
    processStatusNotifier.setEnabled();
    notifyListeners();
  }

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

  void selectStatus(PersonStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> update({
    SnackbarNotifier? snackbarNotifier,
    VoidCallback? onSuccess,
  }) async {
    if (_person == null) return;

    final params = UpdatePersonParams(
      personId: _person!.id,
      legalName: _legalName.trim(),
      preferredName: _preferredName,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      primaryPhone: _primaryPhone,
      primaryEmail: _primaryEmail,
      status: _status,
    );

    await handleFutureRequest(
      request: () => updatePerson.call(params),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      successSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) => onSuccess?.call(),
    );
  }
}
