import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Assigns a registered person as a teacher at one or more Pathshalas.
final class AssignPersonAsTeacher implements AsyncUsecase<void, AssignPersonAsTeacherParams> {
  final PersonRepository repository;

  const AssignPersonAsTeacher(this.repository);

  @override
  AsyncRequest<void> call(AssignPersonAsTeacherParams params) {
    return repository.assignPersonAsTeacher(params);
  }
}
