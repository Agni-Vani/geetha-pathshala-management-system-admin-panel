import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListTeachers
    implements AsyncUsecase<List<Teacher>, ListTeachersParams> {
  final TeachersRepository repository;

  const ListTeachers({required this.repository});

  @override
  AsyncRequest<List<Teacher>> call(ListTeachersParams params) {
    return repository.listTeachers(params);
  }
}
