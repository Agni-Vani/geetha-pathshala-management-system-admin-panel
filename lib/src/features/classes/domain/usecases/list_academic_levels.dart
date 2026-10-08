import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListAcademicLevels
    implements AsyncUsecase<List<AcademicLevel>, String> {
  final ClassesRepository repository;

  const ListAcademicLevels({required this.repository});

  @override
  AsyncRequest<List<AcademicLevel>> call(String programId) {
    return repository.listAcademicLevels(programId);
  }
}
