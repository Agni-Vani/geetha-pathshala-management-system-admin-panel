import 'package:flutter/material.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/areas_domain.dart';

/// Controller for managing administrative Districts and Upazilas in the registry.
class GeographicAreasController extends ChangeNotifier {
  final ListDistricts listDistricts;
  final CreateDistrict createDistrict;
  final ListUpazilas listUpazilas;
  final CreateUpazila createUpazila;

  GeographicAreasController({
    required this.listDistricts,
    required this.createDistrict,
    required this.listUpazilas,
    required this.createUpazila,
  });

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<District> _allDistricts = [];
  List<District> get districts => _filteredDistricts();

  District? _selectedDistrict;
  District? get selectedDistrict => _selectedDistrict;

  List<Upazila> _upazilas = [];
  List<Upazila> get upazilas => _upazilas;

  String? _selectedDivisionFilter;
  String? get selectedDivisionFilter => _selectedDivisionFilter;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoadingUpazilas = false;
  bool get isLoadingUpazilas => _isLoadingUpazilas;

  /// Loads all districts from the repository.
  Future<void> load({SnackbarNotifier? snackbarNotifier}) async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listDistricts.call(
        ListDistrictsParams(division: _selectedDivisionFilter),
      ),
      successSnackbarNotifier: null,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );

    if (result != null) {
      _allDistricts = result;
      processStatusNotifier.setEnabled();

      // If previously selected district is still in the list, keep it; otherwise select the first.
      if (_allDistricts.isNotEmpty) {
        if (_selectedDistrict == null ||
            !_allDistricts.any((d) => d.id == _selectedDistrict!.id)) {
          await selectDistrict(_allDistricts.first, snackbarNotifier: snackbarNotifier);
        } else {
          await loadUpazilasForDistrict(_selectedDistrict!.id, snackbarNotifier: snackbarNotifier);
        }
      } else {
        _selectedDistrict = null;
        _upazilas = [];
      }
    } else {
      processStatusNotifier.setEnabled();
    }
    notifyListeners();
  }

  /// Sets the currently active district and fetches its upazilas.
  Future<void> selectDistrict(
    District district, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _selectedDistrict = district;
    notifyListeners();
    await loadUpazilasForDistrict(district.id, snackbarNotifier: snackbarNotifier);
  }

  /// Loads upazilas belonging to the specified district.
  Future<void> loadUpazilasForDistrict(
    String districtId, {
    SnackbarNotifier? snackbarNotifier,
  }) async {
    _isLoadingUpazilas = true;
    notifyListeners();

    final result = await handleFutureRequest(
      request: () => listUpazilas.call(
        ListUpazilasParams(districtId: districtId),
      ),
      errorSnackbarNotifier: snackbarNotifier,
    );

    _isLoadingUpazilas = false;
    if (result != null) {
      _upazilas = result;
    }
    notifyListeners();
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
      await loadUpazilasForDistrict(districtId, snackbarNotifier: snackbarNotifier);
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Sets division filter for district list.
  void setDivisionFilter(String? division) {
    _selectedDivisionFilter = division;
    notifyListeners();
  }

  /// Sets text search query for district list.
  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  List<District> _filteredDistricts() {
    return _allDistricts.where((district) {
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
}
