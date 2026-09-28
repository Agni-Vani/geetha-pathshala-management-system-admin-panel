import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListTeacherAssignments
    implements AsyncUsecase<List<TeacherAssignment>, ListTeacherAssignmentsParams> {
  final TeachersRepository repository;

  const ListTeacherAssignments({required this.repository});

  @override
  AsyncRequest<List<TeacherAssignment>> call(ListTeacherAssignmentsParams params) {
    return repository.listTeacherAssignments(params);
  }
}
