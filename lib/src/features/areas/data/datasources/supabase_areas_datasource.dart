import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'areas_datasource.dart';

final class SupabaseAreasDatasource implements AreasDatasource {
  final SupabaseClient client;

  SupabaseAreasDatasource([SupabaseClient? client])
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, [Map<String, dynamic>? payload]) async {
    final response = await client.functions.invoke(
      'registry-api',
      body: {'action': action, ...?payload},
    );
    if (response.status != 200) {
      throw StateError('Edge function error ($action): ${response.data}');
    }
    return response.data;
  }

  @override
  Future<List<DistrictModel>> listDistricts({ListDistrictsParams? params}) async {
    final data = await _invoke('listDistricts', {
      'division': params?.division,
      'status': params?.status,
    });
    final list = (data is Map && data['data'] is List)
        ? data['data'] as List
        : (data is List ? data : <dynamic>[]);
    return list
        .map((json) => DistrictModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DistrictModel> createDistrict(CreateDistrictParams params) async {
    final data = await _invoke('createDistrict', {
      'name': params.name,
      'division': params.division,
      'status': params.status,
    });
    return DistrictModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<UpazilaModel>> listUpazilas({ListUpazilasParams? params}) async {
    final data = await _invoke('listUpazilas', {
      'districtId': params?.districtId,
      'status': params?.status,
    });
    final list = (data is Map && data['data'] is List)
        ? data['data'] as List
        : (data is List ? data : <dynamic>[]);
    return list
        .map((json) => UpazilaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UpazilaModel> createUpazila(CreateUpazilaParams params) async {
    final data = await _invoke('createUpazila', {
      'districtId': params.districtId,
      'name': params.name,
      'status': params.status,
    });
    return UpazilaModel.fromJson(data as Map<String, dynamic>);
  }
}
