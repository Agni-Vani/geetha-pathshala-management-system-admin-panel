import '../../domain/params/params.dart';
import '../models/models.dart';
import 'areas_datasource.dart';
import 'mock_data/bd_areas_mock_data.dart';


final class MockAreasDatasource implements AreasDatasource {
  final List<DivisionModel> _divisions;
  final List<DistrictModel> _districts;
  final List<UpazilaModel> _upazilas;

  final Duration processingDelay;

  MockAreasDatasource({this.processingDelay = const Duration(milliseconds: 10)})
      : _divisions = _seedDivisions(),
        _districts = _seedDistricts(),
        _upazilas = _seedUpazilas();

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  @override
  Future<List<DivisionModel>> listDivisions({ListDivisionsParams? params}) async {
    await _simulateProcessing();
    var list = List<DivisionModel>.from(_divisions);
    if (params?.status != null && params!.status!.isNotEmpty) {
      list = list
          .where((d) => d.status.toLowerCase() == params.status!.toLowerCase())
          .toList();
    }
    return list;
  }

  @override
  Future<DivisionModel> createDivision(CreateDivisionParams params) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final key = 'div-${params.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
    final division = DivisionModel(
      id: key,
      name: params.name,
      status: params.status,
      createdAt: now,
      updatedAt: now,
    );
    _divisions.add(division);
    return division;
  }

  @override
  Future<List<DistrictModel>> listDistricts({ListDistrictsParams? params}) async {
    await _simulateProcessing();
    var list = List<DistrictModel>.from(_districts);
    if (params?.division != null && params!.division!.isNotEmpty) {
      list = list
          .where((d) => d.division.toLowerCase() == params.division!.toLowerCase())
          .toList();
    }
    if (params?.status != null && params!.status!.isNotEmpty) {
      list = list
          .where((d) => d.status.toLowerCase() == params.status!.toLowerCase())
          .toList();
    }
    return list;
  }

  @override
  Future<DistrictModel> createDistrict(CreateDistrictParams params) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final key = 'dist-${params.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
    final district = DistrictModel(
      id: key,
      name: params.name,
      division: params.division,
      status: params.status,
      createdAt: now,
      updatedAt: now,
    );
    _districts.add(district);
    return district;
  }

  @override
  Future<DistrictModel> updateDistrict(UpdateDistrictParams params) async {
    await _simulateProcessing();
    final index = _districts.indexWhere((d) => d.id == params.districtId);
    if (index == -1) {
      throw StateError('District not found with id ${params.districtId}');
    }
    final existing = _districts[index];
    final updated = existing.copyWith(
      name: params.name ?? existing.name,
      division: params.division ?? existing.division,
      status: params.status ?? existing.status,
      updatedAt: DateTime.now(),
    );
    _districts[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteDistrict(DeleteDistrictParams params) async {
    await _simulateProcessing();
    if (params.softDeleteOnly) {
      final index = _districts.indexWhere((d) => d.id == params.districtId);
      if (index != -1) {
        _districts[index] = _districts[index].copyWith(
          status: 'inactive',
          updatedAt: DateTime.now(),
        );
      }
    } else {
      _districts.removeWhere((d) => d.id == params.districtId);
      _upazilas.removeWhere((u) => u.districtId == params.districtId);
    }
  }

  @override
  Future<List<UpazilaModel>> listUpazilas({ListUpazilasParams? params}) async {
    await _simulateProcessing();
    var list = List<UpazilaModel>.from(_upazilas);
    if (params?.districtId != null && params!.districtId!.isNotEmpty) {
      list = list.where((u) => u.districtId == params.districtId).toList();
    }
    if (params?.status != null && params!.status!.isNotEmpty) {
      list = list
          .where((u) => u.status.toLowerCase() == params.status!.toLowerCase())
          .toList();
    }
    return list;
  }

  @override
  Future<UpazilaModel> createUpazila(CreateUpazilaParams params) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final key = 'upz-${params.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
    final upazila = UpazilaModel(
      id: key,
      districtId: params.districtId,
      name: params.name,
      status: params.status,
      createdAt: now,
      updatedAt: now,
    );
    _upazilas.add(upazila);
    return upazila;
  }

  @override
  Future<UpazilaModel> updateUpazila(UpdateUpazilaParams params) async {
    await _simulateProcessing();
    final index = _upazilas.indexWhere((u) => u.id == params.upazilaId);
    if (index == -1) {
      throw StateError('Upazila not found with id ${params.upazilaId}');
    }
    final existing = _upazilas[index];
    final updated = existing.copyWith(
      name: params.name ?? existing.name,
      status: params.status ?? existing.status,
      updatedAt: DateTime.now(),
    );
    _upazilas[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteUpazila(DeleteUpazilaParams params) async {
    await _simulateProcessing();
    if (params.softDeleteOnly) {
      final index = _upazilas.indexWhere((u) => u.id == params.upazilaId);
      if (index != -1) {
        _upazilas[index] = _upazilas[index].copyWith(
          status: 'inactive',
          updatedAt: DateTime.now(),
        );
      }
    } else {
      _upazilas.removeWhere((u) => u.id == params.upazilaId);
    }
  }
}

List<DivisionModel> _seedDivisions() {
  final now = DateTime(2026, 1, 1);
  const canonical = [
    'Barishal',
    'Chattogram',
    'Dhaka',
    'Khulna',
    'Mymensingh',
    'Rajshahi',
    'Rangpur',
    'Sylhet',
  ];
  return canonical.map((name) {
    final id = 'div-${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
    return DivisionModel(
      id: id,
      name: name,
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );
  }).toList();
}

List<DistrictModel> _seedDistricts() {
  final now = DateTime(2026, 1, 1);
  return bdDistricts.map((name) {
    final div = bdDistrictToDivision[name] ?? 'Dhaka';
    final id = 'dist-${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
    return DistrictModel(
      id: id,
      name: name,
      division: div,
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );
  }).toList();
}

List<UpazilaModel> _seedUpazilas() {
  final now = DateTime(2026, 1, 1);
  final List<UpazilaModel> results = [];
  bdUpazilas.forEach((districtName, upazilas) {
    final districtId =
        'dist-${districtName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
    for (final name in upazilas) {
      final id =
          'upz-${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';
      results.add(
        UpazilaModel(
          id: id,
          districtId: districtId,
          name: name,
          status: 'active',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  });
  return results;
}
