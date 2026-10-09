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

  @override
  Future<List<TeacherModel>> listTeachers(ListTeachersParams params) async {
    try {
      final data = await _invoke('listTeachers', {
        'pathshalaId': params.pathshalaId,
        'subject': params.subject,
        'search': params.search,
      });
      final list =
          (data is Map && data['data'] is List)
              ? data['data'] as List
              : data as List;
      return list
          .map((json) => TeacherModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback: Query live Supabase database tables directly if Edge Function fails on cross-schema join
      return _listTeachersDirect(params);
    }
  }

  Future<List<TeacherModel>> _listTeachersDirect(ListTeachersParams params) async {
    try {
      List<dynamic> assignments = [];
      if (params.pathshalaId != null && params.pathshalaId!.isNotEmpty) {
        assignments = await client
            .schema('education')
            .from('teacher_assignments')
            .select()
            .eq('pathshala_id', params.pathshalaId!);

        if (assignments.isEmpty) {
          return [];
        }
      }

      var profileQuery = client
          .schema('education')
          .from('teacher_profiles')
          .select();

      if (assignments.isNotEmpty) {
        final profileIds = assignments
            .map((a) => a['teacher_profile_id']?.toString())
            .whereType<String>()
            .toList();
        profileQuery = profileQuery.inFilter('id', profileIds);
      }

      final List<dynamic> profiles = await profileQuery;
      if (profiles.isEmpty) return [];

      final personIds = profiles
          .map((p) => p['person_id']?.toString())
          .whereType<String>()
          .toList();

      final List<dynamic> people = await client
          .schema('registry')
          .from('people')
          .select()
          .inFilter('id', personIds);

      final peopleMap = {
        for (final p in people) (p['id']?.toString() ?? ''): p,
      };

      final assignmentsMap = {
        for (final a in assignments)
          (a['teacher_profile_id']?.toString() ?? ''): a,
      };

      return profiles.map((p) {
        final profileId = p['id']?.toString() ?? '';
        final personId = p['person_id']?.toString() ?? '';
        final person = peopleMap[personId];
        final assignment = assignmentsMap[profileId];

        final name = (person?['preferred_name'] ?? person?['legal_name'] ?? 'Unknown').toString();
        final role = (assignment?['role'] ?? 'Gita Instructor').toString();
        final isActive = (p['status']?.toString().toLowerCase() == 'active');

        return TeacherModel(
          id: profileId,
          name: name,
          subject: role,
          pathshala: params.pathshalaId ?? 'Assigned Pathshala',
          isActive: isActive,
          phone: person?['primary_phone']?.toString(),
          email: person?['primary_email']?.toString(),
          gender: person?['gender']?.toString(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
