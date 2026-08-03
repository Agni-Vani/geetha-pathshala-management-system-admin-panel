import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class EducationDatasource {
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params);
  Future<StudentTransferModel> transferStudent(TransferStudentParams params);
  Future<List<EducationalGroupModel>> listEducationalGroups(
    ListGroupsParams params,
  );
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  );
  Future<List<AttendanceRecordModel>> getSessionAttendance(String sessionId);
  Future<List<AcademicYearModel>> listAcademicYears(String organizationId);
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  );
  Future<TeacherAssignmentModel> assignTeacher(AssignTeacherParams params);
}
