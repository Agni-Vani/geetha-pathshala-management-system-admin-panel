import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class AssignTeacher
    implements AsyncUsecase<TeacherAssignment, AssignTeacherParams> {
  final EducationRepository repository;

  const AssignTeacher({required this.repository});

  @override
  AsyncRequest<TeacherAssignment> call(AssignTeacherParams params) {
    return repository.assignTeacher(params);
  }
}
