import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class EducationRepository {
  AsyncRequest<StudentAdmission> admitStudent(AdmitStudentParams params);
  AsyncRequest<StudentTransfer> transferStudent(TransferStudentParams params);
  AsyncRequest<List<EducationalGroup>> listEducationalGroups(
    ListGroupsParams params,
  );
  AsyncRequest<AttendanceSession> recordAttendance(
    RecordAttendanceParams params,
  );
  AsyncRequest<List<AttendanceRecord>> getSessionAttendance(String sessionId);
  AsyncRequest<List<AcademicYear>> listAcademicYears(String organizationId);
}
