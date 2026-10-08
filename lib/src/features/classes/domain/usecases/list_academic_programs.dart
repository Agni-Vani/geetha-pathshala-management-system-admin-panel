import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListAcademicPrograms
    implements AsyncUsecase<List<AcademicProgram>, NoParams> {
  final ClassesRepository repository;

  const ListAcademicPrograms({required this.repository});

  @override
  AsyncRequest<List<AcademicProgram>> call([NoParams params = const NoParams()]) {
    return repository.listAcademicPrograms();
  }
}
