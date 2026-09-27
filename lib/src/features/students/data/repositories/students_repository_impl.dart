import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

final class StudentsRepositoryImpl
    with ErrorHandler
    implements StudentsRepository {
  final StudentsDatasource datasource;

  const StudentsRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<StudentAdmission> admitStudent(AdmitStudentParams params) {
    return _request(() => datasource.admitStudent(params));
  }

  @override
  AsyncRequest<StudentTransfer> transferStudent(TransferStudentParams params) {
    return _request(() => datasource.transferStudent(params));
  }

  @override
  AsyncRequest<List<StudentAdmission>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  ) {
    return _request(() => datasource.listStudentAdmissions(params));
  }

  @override
  AsyncRequest<List<Student>> listStudents(ListStudentsParams params) {
    return _request(() => datasource.listStudents(params));
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
