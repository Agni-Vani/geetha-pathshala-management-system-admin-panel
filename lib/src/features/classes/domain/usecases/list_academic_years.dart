import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListAcademicYears
    implements AsyncUsecase<List<AcademicYear>, String> {
  final ClassesRepository repository;

  const ListAcademicYears({required this.repository});

  @override
  AsyncRequest<List<AcademicYear>> call(String organizationId) {
    return repository.listAcademicYears(organizationId);
  }
}
