import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListStudentAdmissions
    implements AsyncUsecase<List<StudentAdmission>, ListStudentAdmissionsParams> {
  final StudentsRepository repository;

  const ListStudentAdmissions({required this.repository});

  @override
  AsyncRequest<List<StudentAdmission>> call(ListStudentAdmissionsParams params) {
    return repository.listStudentAdmissions(params);
  }
}
