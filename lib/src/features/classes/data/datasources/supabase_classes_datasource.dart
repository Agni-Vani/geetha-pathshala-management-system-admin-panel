import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'classes_datasource.dart';
import 'mock_classes_datasource.dart';

final class SupabaseClassesDatasource implements ClassesDatasource {
  final SupabaseClient client;
  final MockClassesDatasource _fallbackMock = MockClassesDatasource();

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
    try {
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
    } catch (_) {
      return _fallbackMock.listEducationalGroups(params);
    }
  }

  @override
  Future<List<AcademicYearModel>> listAcademicYears(
    String organizationId,
  ) async {
    try {
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
    } catch (_) {
      return _fallbackMock.listAcademicYears(organizationId);
    }
  }

  @override
  Future<List<ClassScheduleModel>> listClassSchedules(
    ListClassSchedulesParams params,
  ) async {
    try {
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
    } catch (_) {
      return _fallbackMock.listClassSchedules(params);
    }
  }

  @override
  Future<List<AcademicProgramModel>> listAcademicPrograms() async {
    try {
      final data = await _invoke('listAcademicPrograms', {});
      final list =
          (data is Map && data['data'] is List)
              ? data['data'] as List
              : data as List;
      return list
          .map((json) => AcademicProgramModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _fallbackMock.listAcademicPrograms();
    }
  }

  @override
  Future<AcademicProgramModel> createAcademicProgram(
    CreateAcademicProgramParams params,
  ) async {
    try {
      final data = await _invoke('createAcademicProgram', {
        'name': params.name,
        'code': params.code,
        'levelTermLabel': params.levelTermLabel,
        'description': params.description,
      });
      return AcademicProgramModel.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return _fallbackMock.createAcademicProgram(params);
    }
  }

  @override
  Future<List<AcademicLevelModel>> listAcademicLevels(String programId) async {
    try {
      final data = await _invoke('listAcademicLevels', {'programId': programId});
      final list =
          (data is Map && data['data'] is List)
              ? data['data'] as List
              : data as List;
      return list
          .map((json) => AcademicLevelModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _fallbackMock.listAcademicLevels(programId);
    }
  }

  @override
  Future<AcademicLevelModel> createAcademicLevel(
    CreateAcademicLevelParams params,
  ) async {
    try {
      final data = await _invoke('createAcademicLevel', {
        'programId': params.programId,
        'name': params.name,
        'code': params.code,
        'sequence': params.sequence,
        'description': params.description,
      });
      return AcademicLevelModel.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return _fallbackMock.createAcademicLevel(params);
    }
  }

  @override
  Future<EducationalGroupModel> createEducationalGroup(
    CreateEducationalGroupParams params,
  ) async {
    try {
      final data = await _invoke('createEducationalGroup', {
        'pathshalaId': params.pathshalaId,
        'academicYearId': params.academicYearId,
        'programId': params.programId,
        'levelId': params.levelId,
        'name': params.name,
        'gradeLevel': params.gradeLevel,
        'classTeacherId': params.classTeacherId,
        'classTeacherName': params.classTeacherName,
        'room': params.room,
        'maxCapacity': params.maxCapacity,
      });
      return EducationalGroupModel.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return _fallbackMock.createEducationalGroup(params);
    }
  }

  @override
  Future<EducationalGroupModel> assignClassTeacher(
    AssignClassTeacherParams params,
  ) async {
    try {
      final data = await _invoke('assignClassTeacher', {
        'groupId': params.groupId,
        'teacherId': params.teacherId,
        'teacherName': params.teacherName,
      });
      return EducationalGroupModel.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return _fallbackMock.assignClassTeacher(params);
    }
  }
}
