import '../../domain/params/params.dart';
import '../models/models.dart';

abstract interface class StudentsDatasource {
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params);
  Future<StudentTransferModel> transferStudent(TransferStudentParams params);
  Future<List<StudentAdmissionModel>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  );
  Future<List<StudentModel>> listStudents(ListStudentsParams params);
}
