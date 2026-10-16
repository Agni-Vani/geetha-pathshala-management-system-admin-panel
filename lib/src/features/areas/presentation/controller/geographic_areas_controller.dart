import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/areas_domain.dart';

/// Controller for managing administrative Divisions, Districts, and Upazilas in the registry.
class GeographicAreasController extends ChangeNotifier {
  final ListDivisions listDivisions;
  final CreateDivision createDivision;
  final ListDistricts listDistricts;
  final CreateDistrict createDistrict;
  final UpdateDistrict? updateDistrict;
  final DeleteDistrict? deleteDistrict;
  final ListUpazilas listUpazilas;
  final CreateUpazila createUpazila;
  final UpdateUpazila? updateUpazila;
  final DeleteUpazila? deleteUpazila;
  final Duration upazilaLoadTimeout;

  GeographicAreasController({
    required this.listDivisions,
    required this.createDivision,
    required this.listDistricts,
    required this.createDistrict,
    this.updateDistrict,
    this.deleteDistrict,
    required this.listUpazilas,
    required this.createUpazila,
    this.updateUpazila,
    this.deleteUpazila,
    this.upazilaLoadTimeout = const Duration(seconds: 15),
  });

  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: ProcessEnabled(),
  );

  List<Division> _allDivisions = [];
  List<Division> get allDivisions => _allDivisions;

  List<District> _allDistricts = [];
  List<District> get districts => _filteredDistricts();

  List<String> get divisions {
    final set = {
      ..._allDivisions.map((d) => d.name),
      ..._allDistricts.map((d) => d.division).where((div) => div.isNotEmpty),
    };
    return set.toList()..sort();
  }

  District? _selectedDistrict;
  District? get selectedDistrict => _selectedDistrict;

  List<Upazila> _upazilas = [];
  List<Upazila> get upazilas => _upazilas;

  String? _selectedDivisionFilter;
  String? get selectedDivisionFilter => _selectedDivisionFilter;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _upazilaRequestVersion = 0;
  bool _isLoadingUpazilas = false;
  bool get isLoadingUpazilas => _isLoadingUpazilas;
  String? _upazilasError;
  String? get upazilasError => _upazilasError;
  bool _disposed = false;

  /// Loads divisions and districts from the repository.
  Future<void> load({SnackbarNotifier? snackbarNotifier}) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    // 1. Load divisions
    final divResult = await handleFutureRequest(
      request: () => listDivisions.call(),
      errorSnackbarNotifier: snackbarNotifier,
    );
    if (_disposed) return;
    if (divResult != null) {
      _allDivisions = divResult;
    }

    // 2. Load districts
    final result = await handleFutureRequest(
      // Keep the full registry so changing a local filter never loses districts.
      request: () => listDistricts.call(),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );
    if (_disposed) return;

    if (result != null) {
      _allDistricts = result;
      processStatusNotifier.setEnabled();

      await _syncSelectedDistrict(
        reloadUpazilas: true,
        snackbarNotifier: snackbarNotifier,
      );
    } else {
      processStatusNotifier.setEnabled();
    }
    if (!_disposed) notifyListeners();
  }

  /// Sets the currently active district and fetches its upazilas.
  Future<void> selectDistrict(
    District district, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (!_filteredDistricts().any((visible) => visible.id == district.id)) {
      return;
    }
    _selectedDistrict = district;
    await loadUpazilasForDistrict(
      district.id,
      snackbarNotifier: snackbarNotifier,
    );
  }

  /// Loads only the current district; older requests cannot replace its results.
  Future<void> loadUpazilasForDistrict(
    String districtId, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (_disposed || _selectedDistrict?.id != districtId) return;
    final requestVersion = ++_upazilaRequestVersion;
    _upazilas = [];
    _upazilasError = null;
    _isLoadingUpazilas = true;
    notifyListeners();

    List<Upazila> result = [];
    String? loadError;
    try {
      final response = await listUpazilas
          .call(ListUpazilasParams(districtId: districtId))
          .timeout(upazilaLoadTimeout);
      if (response.success) {
        result = (response.data ?? [])
            .where((u) => u.status.toLowerCase() != 'inactive')
            .toList();
      } else {
        loadError =
            'উপজেলার তথ্য আনা যায়নি। সংযোগ যাচাই করে আবার চেষ্টা করুন।';
      }
    } on TimeoutException {
      loadError =
          'তথ্য আনতে বেশি সময় লাগছে। সংযোগ যাচাই করে আবার চেষ্টা করুন।';
    } catch (_) {
      loadError = 'উপজেলার তথ্য আনা যায়নি। সংযোগ যাচাই করে আবার চেষ্টা করুন।';
    }

    if (_disposed ||
        requestVersion != _upazilaRequestVersion ||
        _selectedDistrict?.id != districtId) {
      return;
    }
    _isLoadingUpazilas = false;
    _upazilas = result;
    _upazilasError = loadError;
    notifyListeners();
  }

  Future<void> _syncSelectedDistrict({
    bool reloadUpazilas = false,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    final visible = _filteredDistricts();
    final selected =
        visible
            .where((district) => district.id == _selectedDistrict?.id)
            .firstOrNull ??
        visible.firstOrNull;
    if (selected == null) {
      ++_upazilaRequestVersion;
      _selectedDistrict = null;
      _upazilas = [];
      _upazilasError = null;
      _isLoadingUpazilas = false;
      notifyListeners();
    } else if (_selectedDistrict?.id != selected.id || reloadUpazilas) {
      await selectDistrict(selected, snackbarNotifier: snackbarNotifier);
    } else {
      _selectedDistrict = selected;
      notifyListeners();
    }
  }

  /// Adds a new division and refreshes the division list.
  Future<bool> addNewDivision({
    required String name,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createDivision.call(
        CreateDivisionParams(name: name.trim(), status: 'active'),
      ),
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    processStatusNotifier.setEnabled();
    if (result != null) {
      snackbarNotifier?.notifySuccess(message: 'বিভাগ সফলভাবে তৈরি হয়েছে।');
      _allDivisions.add(result);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Adds a new district and refreshes the district list.
  Future<bool> addNewDistrict({
    required String name,
    required String division,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createDistrict.call(
        CreateDistrictParams(
          name: name.trim(),
          division: division.trim(),
          status: 'active',
        ),
      ),
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    processStatusNotifier.setEnabled();
    if (result != null) {
      snackbarNotifier?.notifySuccess(message: 'জেলা সফলভাবে তৈরি হয়েছে।');
      await load(snackbarNotifier: snackbarNotifier);
      await selectDistrict(result, snackbarNotifier: snackbarNotifier);
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Adds a new upazila under the selected district and refreshes the upazila list.
  Future<bool> addNewUpazila({
    required String districtId,
    required String name,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _isLoadingUpazilas = true;
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => createUpazila.call(
        CreateUpazilaParams(
          districtId: districtId,
          name: name.trim(),
          status: 'active',
        ),
      ),
      errorSnackbarNotifier: snackbarNotifier,
    );

    _isLoadingUpazilas = false;
    if (result != null) {
      snackbarNotifier?.notifySuccess(message: 'উপজেলা সফলভাবে তৈরি হয়েছে।');
      await loadUpazilasForDistrict(
        districtId,
        snackbarNotifier: snackbarNotifier,
      );
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Updates an existing district and refreshes the district list.
  Future<bool> editDistrict({
    required String districtId,
    required String name,
    required String division,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (updateDistrict == null) return false;
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => updateDistrict!.call(
        UpdateDistrictParams(
          districtId: districtId,
          name: name.trim(),
          division: division.trim(),
        ),
      ),
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    processStatusNotifier.setEnabled();
    if (result != null) {
      snackbarNotifier?.notifySuccess(message: 'জেলা সফলভাবে হালনাগাদ করা হয়েছে।');
      final index = _allDistricts.indexWhere((d) => d.id == districtId);
      if (index != -1) {
        _allDistricts[index] = result;
      }
      if (_selectedDistrict?.id == districtId) {
        _selectedDistrict = result;
      }
      await _syncSelectedDistrict(
        reloadUpazilas: false,
        snackbarNotifier: snackbarNotifier,
      );
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Deletes or soft-deletes a district and refreshes the list.
  Future<bool> removeDistrict({
    required String districtId,
    bool softDeleteOnly = false,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (deleteDistrict == null) return false;
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => deleteDistrict!.call(
        DeleteDistrictParams(
          districtId: districtId,
          softDeleteOnly: softDeleteOnly,
        ),
      ),
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    processStatusNotifier.setEnabled();
    if (result == true) {
      snackbarNotifier?.notifySuccess(message: 'জেলা সফলভাবে মুছে ফেলা হয়েছে।');
      _allDistricts.removeWhere((d) => d.id == districtId);
      if (_selectedDistrict?.id == districtId) {
        _selectedDistrict = null;
      }
      await _syncSelectedDistrict(
        reloadUpazilas: true,
        snackbarNotifier: snackbarNotifier,
      );
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Updates an existing upazila and refreshes the upazila list.
  Future<bool> editUpazila({
    required String upazilaId,
    required String name,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (updateUpazila == null) return false;
    _isLoadingUpazilas = true;
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => updateUpazila!.call(
        UpdateUpazilaParams(
          upazilaId: upazilaId,
          name: name.trim(),
        ),
      ),
      errorSnackbarNotifier: snackbarNotifier,
    );

    _isLoadingUpazilas = false;
    if (result != null) {
      snackbarNotifier?.notifySuccess(message: 'উপজেলা সফলভাবে হালনাগাদ করা হয়েছে।');
      final index = _upazilas.indexWhere((u) => u.id == upazilaId);
      if (index != -1) {
        _upazilas[index] = result;
      }
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Deletes or soft-deletes an upazila and removes it from the list.
  Future<bool> removeUpazila({
    required String upazilaId,
    bool softDeleteOnly = false,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (deleteUpazila == null) return false;
    _isLoadingUpazilas = true;
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => deleteUpazila!.call(
        DeleteUpazilaParams(
          upazilaId: upazilaId,
          softDeleteOnly: softDeleteOnly,
        ),
      ),
      errorSnackbarNotifier: snackbarNotifier,
    );

    _isLoadingUpazilas = false;
    if (result == true) {
      snackbarNotifier?.notifySuccess(message: 'উপজেলা সফলভাবে মুছে ফেলা হয়েছে।');
      _upazilas.removeWhere((u) => u.id == upazilaId);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Sets division filter for district list.
  Future<void> setDivisionFilter(
    String? division, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedDivisionFilter = division;
    await _syncSelectedDistrict(snackbarNotifier: snackbarNotifier);
  }

  /// Sets text search query for district list.
  Future<void> setSearchQuery(
    String query, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _searchQuery = query.trim().toLowerCase();
    await _syncSelectedDistrict(snackbarNotifier: snackbarNotifier);
  }

  List<District> _filteredDistricts() {
    return _allDistricts.where((district) {
      if (district.status.toLowerCase() == 'inactive') {
        return false;
      }
      if (_selectedDivisionFilter != null &&
          _selectedDivisionFilter!.isNotEmpty &&
          district.division.toLowerCase() !=
              _selectedDivisionFilter!.toLowerCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !district.name.toLowerCase().contains(_searchQuery)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_upazilaRequestVersion;
    super.dispose();
  }
}
