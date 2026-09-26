import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListStudents
    implements AsyncUsecase<List<Student>, ListStudentsParams> {
  final StudentsRepository repository;

  const ListStudents({required this.repository});

  @override
  AsyncRequest<List<Student>> call(ListStudentsParams params) {
    return repository.listStudents(params);
  }
}
