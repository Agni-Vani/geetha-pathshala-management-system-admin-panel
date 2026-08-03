import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'education_datasource.dart';

final class SupabaseEducationDatasource implements EducationDatasource {
  final SupabaseClient client;

  SupabaseEducationDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  @override
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params) async {
    final response = await client
        .schema('education')
        .from('student_admissions')
        .insert({
          'organization_id': params.organizationId,
          'pathshala_id': params.pathshalaId,
          'person_id': params.personId,
          'roll_number': params.rollNumber,
          'status': 'admitted',
        })
        .select()
        .single();
    return StudentAdmissionModel.fromJson(response);
  }

  @override
  Future<StudentTransferModel> transferStudent(
    TransferStudentParams params,
  ) async {
    final response = await client
        .schema('education')
        .from('student_transfers')
        .insert({
          'person_id': params.personId,
          'from_pathshala_id': params.fromPathshalaId,
          'to_pathshala_id': params.toPathshalaId,
          'reason': params.reason,
          'status': 'pending',
        })
        .select()
        .single();
    return StudentTransferModel.fromJson(response);
  }

  @override
  Future<List<EducationalGroupModel>> listEducationalGroups(
    ListGroupsParams params,
  ) async {
    var query = client
        .schema('education')
        .from('educational_groups')
        .select()
        .eq('pathshala_id', params.pathshalaId);

    if (params.academicYearId != null) {
      query = query.eq('academic_year_id', params.academicYearId!);
    }
    final response = await query;
    return (response as List)
        .map(
          (json) =>
              EducationalGroupModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  ) async {
    final sessionResponse = await client
        .schema('education')
        .from('attendance_sessions')
        .insert({
          'group_id': params.groupId,
          'session_date': params.sessionDate.toIso8601String(),
          'taken_by_user_id': params.takenByUserId,
          'status': 'submitted',
        })
        .select()
        .single();

    final session = AttendanceSessionModel.fromJson(sessionResponse);

    final recordsToInsert =
        params.entries
            .map(
              (entry) => {
                'session_id': session.id,
                'person_id': entry.personId,
                'status': entry.status.name,
                'remarks': entry.remarks,
              },
            )
            .toList();

    await client
        .schema('education')
        .from('attendance_records')
        .insert(recordsToInsert);

    return session;
  }

  @override
  Future<List<AttendanceRecordModel>> getSessionAttendance(
    String sessionId,
  ) async {
    final response = await client
        .schema('education')
        .from('attendance_records')
        .select()
        .eq('session_id', sessionId);
    return (response as List)
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
    final response = await client
        .schema('education')
        .from('academic_years')
        .select()
        .eq('organization_id', organizationId);
    return (response as List)
        .map((json) => AcademicYearModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  ) async {
    final response = await client
        .schema('education')
        .from('teacher_profiles')
        .insert({
          'person_id': params.personId,
          'organization_id': params.organizationId,
          'status': 'active',
        })
        .select()
        .single();
    return TeacherProfileModel.fromJson(response);
  }

  @override
  Future<TeacherAssignmentModel> assignTeacher(
    AssignTeacherParams params,
  ) async {
    final response = await client
        .schema('education')
        .from('teacher_assignments')
        .insert({
          'teacher_profile_id': params.teacherProfileId,
          'pathshala_id': params.pathshalaId,
          'group_id': params.groupId,
          'role': params.role,
          'effective_from': params.effectiveFrom.toIso8601String(),
          'effective_to': params.effectiveTo?.toIso8601String(),
        })
        .select()
        .single();
    return TeacherAssignmentModel.fromJson(response);
  }
}
