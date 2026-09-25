import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class TeachersRepository {
  AsyncRequest<TeacherProfile> createTeacherProfile(
    CreateTeacherProfileParams params,
  );
  AsyncRequest<TeacherAssignment> assignTeacher(AssignTeacherParams params);
  AsyncRequest<List<TeacherAssignment>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  );
}
