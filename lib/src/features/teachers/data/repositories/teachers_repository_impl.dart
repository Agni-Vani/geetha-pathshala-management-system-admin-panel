import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

final class TeachersRepositoryImpl
    with ErrorHandler
    implements TeachersRepository {
  final TeachersDatasource datasource;

  const TeachersRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<TeacherProfile> createTeacherProfile(
    CreateTeacherProfileParams params,
  ) {
    return _request(() => datasource.createTeacherProfile(params));
  }

  @override
  AsyncRequest<TeacherAssignment> assignTeacher(AssignTeacherParams params) {
    return _request(() => datasource.assignTeacher(params));
  }

  @override
  AsyncRequest<List<TeacherAssignment>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  ) {
    return _request(() => datasource.listTeacherAssignments(params));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
