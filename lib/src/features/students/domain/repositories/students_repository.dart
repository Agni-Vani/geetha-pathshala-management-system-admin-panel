import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class StudentsRepository {
  AsyncRequest<StudentAdmission> admitStudent(AdmitStudentParams params);
  AsyncRequest<StudentTransfer> transferStudent(TransferStudentParams params);
  AsyncRequest<List<StudentAdmission>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  );
}
