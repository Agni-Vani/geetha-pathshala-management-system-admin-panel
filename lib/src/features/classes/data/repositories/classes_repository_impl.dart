import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/classes_repository.dart';
import '../datasources/datasources.dart';

final class ClassesRepositoryImpl
    with ErrorHandler
    implements ClassesRepository {
  final ClassesDatasource datasource;

  const ClassesRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<List<EducationalGroup>> listEducationalGroups(
    ListGroupsParams params,
  ) {
    return _request(() => datasource.listEducationalGroups(params));
  }

  @override
  AsyncRequest<List<AcademicYear>> listAcademicYears(String organizationId) {
    return _request(() => datasource.listAcademicYears(organizationId));
  }

  @override
  AsyncRequest<List<ClassSchedule>> listClassSchedules(
    ListClassSchedulesParams params,
  ) {
    return _request(() => datasource.listClassSchedules(params));
  }

  @override
  AsyncRequest<List<AcademicProgram>> listAcademicPrograms() {
    return _request(() => datasource.listAcademicPrograms());
  }

  @override
  AsyncRequest<AcademicProgram> createAcademicProgram(
    CreateAcademicProgramParams params,
  ) {
    return _request(() => datasource.createAcademicProgram(params));
  }

  @override
  AsyncRequest<List<AcademicLevel>> listAcademicLevels(String programId) {
    return _request(() => datasource.listAcademicLevels(programId));
  }

  @override
  AsyncRequest<AcademicLevel> createAcademicLevel(
    CreateAcademicLevelParams params,
  ) {
    return _request(() => datasource.createAcademicLevel(params));
  }

  @override
  AsyncRequest<EducationalGroup> createEducationalGroup(
    CreateEducationalGroupParams params,
  ) {
    return _request(() => datasource.createEducationalGroup(params));
  }

  @override
  AsyncRequest<EducationalGroup> assignClassTeacher(
    AssignClassTeacherParams params,
  ) {
    return _request(() => datasource.assignClassTeacher(params));
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
