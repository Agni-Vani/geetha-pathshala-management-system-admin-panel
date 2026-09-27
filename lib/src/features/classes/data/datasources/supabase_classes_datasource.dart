import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'classes_datasource.dart';

final class SupabaseClassesDatasource implements ClassesDatasource {
  final SupabaseClient client;

  SupabaseClassesDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    final response = await client.functions.invoke(
      'education-api',
      body: {'action': action, ...body},
    );
    if (response.status != 200) {
      throw StateError('Edge Function error: ${response.data}');
    }
    return response.data;
  }

  @override
  Future<List<EducationalGroupModel>> listEducationalGroups(
    ListGroupsParams params,
  ) async {
    final data = await _invoke('listEducationalGroups', {
      'pathshalaId': params.pathshalaId,
      'academicYearId': params.academicYearId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              EducationalGroupModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<AcademicYearModel>> listAcademicYears(
    String organizationId,
  ) async {
    final data = await _invoke('listAcademicYears', {
      'organizationId': organizationId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => AcademicYearModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ClassScheduleModel>> listClassSchedules(
    ListClassSchedulesParams params,
  ) async {
    final data = await _invoke('listClassSchedules', {
      'pathshalaId': params.pathshalaId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => ClassScheduleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
