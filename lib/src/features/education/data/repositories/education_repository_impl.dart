import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

final class EducationRepositoryImpl
    with ErrorHandler
    implements EducationRepository {
  final EducationDatasource datasource;

  const EducationRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<StudentAdmission> admitStudent(AdmitStudentParams params) {
    return _request(() => datasource.admitStudent(params));
  }

  @override
  AsyncRequest<StudentTransfer> transferStudent(TransferStudentParams params) {
    return _request(() => datasource.transferStudent(params));
  }

  @override
  AsyncRequest<List<EducationalGroup>> listEducationalGroups(
    ListGroupsParams params,
  ) {
    return _request(() => datasource.listEducationalGroups(params));
  }

  @override
  AsyncRequest<AttendanceSession> recordAttendance(
    RecordAttendanceParams params,
  ) {
    return _request(() => datasource.recordAttendance(params));
  }

  @override
  AsyncRequest<List<AttendanceRecord>> getSessionAttendance(String sessionId) {
    return _request(() => datasource.getSessionAttendance(sessionId));
  }

  @override
  AsyncRequest<List<AcademicYear>> listAcademicYears(String organizationId) {
    return _request(() => datasource.listAcademicYears(organizationId));
  }

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

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
