import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Registers a new administrative division.
final class CreateDivision
    implements AsyncUsecase<Division, CreateDivisionParams> {
  final AreasRepository repository;

  const CreateDivision(this.repository);

  @override
  AsyncRequest<Division> call(CreateDivisionParams params) {
    return repository.createDivision(params);
  }
}
