import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class TeachersDatasource {
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  );
  Future<TeacherAssignmentModel> assignTeacher(AssignTeacherParams params);
  Future<List<TeacherAssignmentModel>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  );
}
