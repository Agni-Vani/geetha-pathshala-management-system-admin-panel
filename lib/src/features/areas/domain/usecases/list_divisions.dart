import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Lists administrative divisions.
final class ListDivisions
    implements AsyncUsecase<List<Division>, ListDivisionsParams?> {
  final AreasRepository repository;

  const ListDivisions(this.repository);

  @override
  AsyncRequest<List<Division>> call([ListDivisionsParams? params]) {
    return repository.listDivisions(params);
  }
}
