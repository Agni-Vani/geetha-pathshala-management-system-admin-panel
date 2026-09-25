import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'teachers_datasource.dart';

final class SupabaseTeachersDatasource implements TeachersDatasource {
  final SupabaseClient client;

  SupabaseTeachersDatasource({SupabaseClient? client})
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
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  ) async {
    final data = await _invoke('createTeacherProfile', {
      'personId': params.personId,
      'organizationId': params.organizationId,
    });
    return TeacherProfileModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<TeacherAssignmentModel> assignTeacher(
    AssignTeacherParams params,
  ) async {
    final data = await _invoke('assignTeacher', {
      'teacherProfileId': params.teacherProfileId,
      'pathshalaId': params.pathshalaId,
      'groupId': params.groupId,
      'role': params.role,
      'effectiveFrom': params.effectiveFrom.toIso8601String(),
      'effectiveTo': params.effectiveTo?.toIso8601String(),
    });
    return TeacherAssignmentModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<TeacherAssignmentModel>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  ) async {
    final data = await _invoke('listTeacherAssignments', {
      'pathshalaId': params.pathshalaId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              TeacherAssignmentModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
