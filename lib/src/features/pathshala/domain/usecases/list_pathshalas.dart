import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Lists Pathshalas available to the current registry workflow.
final class ListPathshalas
    implements AsyncUsecase<List<Pathshala>, ListPathshalasParams> {
  final PathshalaRepository repository;

  const ListPathshalas(this.repository);

  @override
  AsyncRequest<List<Pathshala>> call(ListPathshalasParams params) {
    return repository.listPathshalas(params);
  }
}
