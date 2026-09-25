import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'education_datasource.dart';

final class SupabaseEducationDatasource implements EducationDatasource {
  final SupabaseClient client;

  SupabaseEducationDatasource({SupabaseClient? client})
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
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params) async {
    final data = await _invoke('admitStudent', {
      'organizationId': params.organizationId,
      'pathshalaId': params.pathshalaId,
      'personId': params.personId,
      'rollNumber': params.rollNumber,
    });
    return StudentAdmissionModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<StudentTransferModel> transferStudent(
    TransferStudentParams params,
  ) async {
    final data = await _invoke('transferStudent', {
      'personId': params.personId,
      'fromPathshalaId': params.fromPathshalaId,
      'toPathshalaId': params.toPathshalaId,
      'reason': params.reason,
    });
    return StudentTransferModel.fromJson(data as Map<String, dynamic>);
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
  Future<List<StudentAdmissionModel>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  ) async {
    final data = await _invoke('listStudentAdmissions', {
      'pathshalaId': params.pathshalaId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              StudentAdmissionModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
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
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  ) async {
    final data = await _invoke('recordAttendance', {
      'groupId': params.groupId,
      'sessionDate': params.sessionDate.toIso8601String(),
      'takenByUserId': params.takenByUserId,
      'entries':
          params.entries
              .map(
                (e) => {
                  'personId': e.personId,
                  'status': e.status.name,
                  'remarks': e.remarks,
                },
              )
              .toList(),
    });
    return AttendanceSessionModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<AttendanceRecordModel>> getSessionAttendance(
    String sessionId,
  ) async {
    final data = await _invoke('getSessionAttendance', {
      'sessionId': sessionId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              AttendanceRecordModel.fromJson(json as Map<String, dynamic>),
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
}
