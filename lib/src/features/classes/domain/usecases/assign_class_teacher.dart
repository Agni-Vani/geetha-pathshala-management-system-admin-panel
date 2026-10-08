import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class AssignClassTeacher
    implements AsyncUsecase<EducationalGroup, AssignClassTeacherParams> {
  final ClassesRepository repository;

  const AssignClassTeacher({required this.repository});

  @override
  AsyncRequest<EducationalGroup> call(AssignClassTeacherParams params) {
    return repository.assignClassTeacher(params);
  }
}
