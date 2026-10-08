import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CreateEducationalGroup
    implements AsyncUsecase<EducationalGroup, CreateEducationalGroupParams> {
  final ClassesRepository repository;

  const CreateEducationalGroup({required this.repository});

  @override
  AsyncRequest<EducationalGroup> call(CreateEducationalGroupParams params) {
    return repository.createEducationalGroup(params);
  }
}
