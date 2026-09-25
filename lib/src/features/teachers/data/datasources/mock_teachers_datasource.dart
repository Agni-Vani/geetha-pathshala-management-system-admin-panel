import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'teachers_datasource.dart';

final class MockTeachersDatasource implements TeachersDatasource {
  final Duration processingDelay;
  final List<TeacherProfileModel> _teacherProfiles;
  final List<TeacherAssignmentModel> _teacherAssignments;

  MockTeachersDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _teacherProfiles = [],
       _teacherAssignments = [];

  @override
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  ) async {
    await _simulateProcessing();
    final profile = TeacherProfileModel(
      id: 'teacher-${DateTime.now().millisecondsSinceEpoch}',
      personId: params.personId,
      organizationId: params.organizationId,
      status: TeacherStatus.active,
      joinedDate: DateTime.now(),
    );
    _teacherProfiles.add(profile);
    return profile;
  }

  @override
  Future<TeacherAssignmentModel> assignTeacher(
    AssignTeacherParams params,
  ) async {
    await _simulateProcessing();
    final assignment = TeacherAssignmentModel(
      id: 'assign-${DateTime.now().millisecondsSinceEpoch}',
      teacherProfileId: params.teacherProfileId,
      pathshalaId: params.pathshalaId,
      groupId: params.groupId,
      role: params.role,
      effectiveFrom: params.effectiveFrom,
      effectiveTo: params.effectiveTo,
    );
    _teacherAssignments.add(assignment);
    return assignment;
  }

  @override
  Future<List<TeacherAssignmentModel>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  ) async {
    await _simulateProcessing();
    return _teacherAssignments
        .where((a) => a.pathshalaId == params.pathshalaId)
        .toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }
}
