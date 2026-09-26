import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import '../../domain/pathshala_domain.dart';
import '../../../areas/domain/areas_domain.dart';

/// Controller for the Create / Edit Pathshala form.
///
/// Owns all form state (text controllers, selections, dates) so that the UI
/// only needs to bind to these fields and forward user interactions — it never
/// builds params or runs validation itself.
class CreatePathshalaController extends ChangeNotifier {
  final CreatePathshala createPathshala;
  final UpdatePathshala updatePathshala;
  final ListDistricts? listDistricts;
  final ListUpazilas? listUpazilas;

  CreatePathshalaController({
    required this.createPathshala,
    required this.updatePathshala,
    this.listDistricts,
    this.listUpazilas,
  }) {
    _initDistricts();
  }

  // ── Process state ──────────────────────────────────────────────────────────

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  // ── Form field controllers ─────────────────────────────────────────────────

  final TextEditingController nameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // ── Form state ─────────────────────────────────────────────────────────────

  String? _existingPathshalaId;
  String? _existingAddressLine2;

  bool get isEditing => _existingPathshalaId != null;

  DateTime? _establishedOn;
  DateTime? get establishedOn => _establishedOn;

  bool _isActive = true;
  bool get isActive => _isActive;

  String? _selectedDistrict;
  String? get selectedDistrict => _selectedDistrict;
  String? _selectedDistrictId;
  String? get selectedDistrictId => _selectedDistrictId;

  String? _selectedUpazila;
  String? get selectedUpazila => _selectedUpazila;
  String? _selectedUpazilaId;
  String? get selectedUpazilaId => _selectedUpazilaId;

  List<String> _districts = const [];
  List<String> get availableDistricts => _districts;

  List<String> _upazilas = const [];
  List<String> get availableUpazilas => _upazilas;

  List<District> _districtEntities = const [];
  List<Upazila> _upazilaEntities = const [];

  Future<void> _initDistricts() async {
    if (listDistricts == null) return;
    final res = await listDistricts!.call();
    if (res is SuccessRepoCall<List<District>> &&
        res.data != null &&
        res.data!.isNotEmpty) {
      _districtEntities = res.data!;
      _districts = res.data!.map((d) => d.name).toList()..sort();
      notifyListeners();
    }
  }

  Future<void> refreshDistricts() async {
    await _initDistricts();
    if (_selectedDistrict != null) {
      _updateUpazilasForDistrict(_selectedDistrict);
    }
  }

  // ── Initialization for edit mode ───────────────────────────────────────────

  void initializeForEdit(Pathshala pathshala) {
    _existingPathshalaId = pathshala.id;
    nameController.text = pathshala.name;
    addressController.text = pathshala.address.detailedAddress ?? pathshala.address.addressLine1;
    _existingAddressLine2 = pathshala.address.addressLine2;
    _selectedDistrict = pathshala.address.region;
    _selectedDistrictId = pathshala.districtId;
    _selectedUpazila = pathshala.address.city;
    _selectedUpazilaId = pathshala.upazilaId;
    _updateUpazilasForDistrict(pathshala.address.region);
    _establishedOn = pathshala.startedOn;
    _isActive = pathshala.isOperational;
  }

  // ── Event handlers (called by the UI) ─────────────────────────────────────

  void onEstablishedDateChanged(DateTime? date) {
    _establishedOn = date;
    notifyListeners();
  }

  void onActiveToggled(bool active) {
    _isActive = active;
    notifyListeners();
  }

  void onDistrictChanged(String? district) {
    _selectedDistrict = district;
    _selectedDistrictId = _districtEntities
        .cast<District?>()
        .firstWhere(
          (d) => d?.name.toLowerCase() == district?.toLowerCase(),
          orElse: () => null,
        )
        ?.id;
    _selectedUpazila = null; // reset dependent field
    _selectedUpazilaId = null;
    _updateUpazilasForDistrict(district);
    notifyListeners();
  }

  Future<void> _updateUpazilasForDistrict(String? district) async {
    if (district == null || district.isEmpty || _selectedDistrictId == null || listUpazilas == null) {
      _upazilas = const [];
      _upazilaEntities = const [];
      notifyListeners();
      return;
    }
    final res = await listUpazilas!.call(
      ListUpazilasParams(districtId: _selectedDistrictId),
    );
    if (res is SuccessRepoCall<List<Upazila>> && res.data != null) {
      _upazilaEntities = res.data!;
      _upazilas = res.data!.map((u) => u.name).toList()..sort();
    } else {
      _upazilaEntities = const [];
      _upazilas = const [];
    }
    notifyListeners();
  }

  void onUpazilaChanged(String? upazila) {
    _selectedUpazila = upazila;
    _selectedUpazilaId = _upazilaEntities
        .cast<Upazila?>()
        .firstWhere(
          (u) => u?.name.toLowerCase() == upazila?.toLowerCase(),
          orElse: () => null,
        )
        ?.id;
    notifyListeners();
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  /// Returns a descriptive error message if the form is invalid, null otherwise.
  String? validate() {
    if (nameController.text.trim().isEmpty) {
      return 'Pathshala name is required.';
    }
    if (_selectedDistrict == null) {
      return 'Please select a district.';
    }
    if (_selectedUpazila == null) {
      return 'Please select an upazila.';
    }
    if (!isEditing && mobileController.text.trim().isEmpty) {
      return 'Mobile number is required.';
    }
    return null;
  }

  // ── Submit / Create / Update ───────────────────────────────────────────────

  Future<void> submit({SnackbarNotifier? snackbarNotifier}) async {
    final error = validate();
    if (error != null) {
      snackbarNotifier?.notifyError(message: error);
      return;
    }

    if (isEditing) {
      final params = UpdatePathshalaParams(
        pathshalaId: _existingPathshalaId!,
        name: nameController.text.trim(),
        districtId: _selectedDistrictId,
        upazilaId: _selectedUpazilaId,
        detailedAddress: addressController.text.trim(),
        addressLine1: addressController.text.trim(),
        addressLine2: _existingAddressLine2,
        city: _selectedUpazila!,
        district: _selectedDistrict!,
        startedOn: _establishedOn,
      );

      await handleFutureRequest(
        request: () => updatePathshala.call(params),
        processStatusNotifier: processStatusNotifier,
        errorSnackbarNotifier: snackbarNotifier,
        successSnackbarNotifier: snackbarNotifier,
      );
      return;
    }

    final params = CreatePathshalaParams(
      // TODO: replace with the signed-in user's real organization id once
      // an auth/session concept exists in the app.
      organizationId: 'org-gp-central',
      code: 'PS-${DateTime.now().millisecondsSinceEpoch}',
      name: nameController.text.trim(),
      districtId: _selectedDistrictId,
      upazilaId: _selectedUpazilaId,
      detailedAddress: addressController.text.trim(),
      addressLine1: addressController.text.trim(),
      city: _selectedUpazila!,
      district: _selectedDistrict!,
      startedOn: _establishedOn,
    );

    await handleFutureRequest(
      request: () => createPathshala.call(params),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      successSnackbarNotifier: snackbarNotifier,
    );
  }

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

  Future<void> update({
    required UpdatePathshalaParams params,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    await handleFutureRequest(
      request: () => updatePathshala.call(params),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      successSnackbarNotifier: snackbarNotifier,
    );
  }

  // ── Cleanup ────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    nameController.dispose();
    branchNameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }
}