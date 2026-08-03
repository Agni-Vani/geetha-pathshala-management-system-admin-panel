import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class AdmitStudent
    implements AsyncUsecase<StudentAdmission, AdmitStudentParams> {
  final EducationRepository repository;

  const AdmitStudent({required this.repository});

  @override
  AsyncRequest<StudentAdmission> call(AdmitStudentParams params) {
    return repository.admitStudent(params);
  }
}
