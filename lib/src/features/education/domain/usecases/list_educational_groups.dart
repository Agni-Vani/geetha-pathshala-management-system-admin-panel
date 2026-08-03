import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListEducationalGroups
    implements AsyncUsecase<List<EducationalGroup>, ListGroupsParams> {
  final EducationRepository repository;

  const ListEducationalGroups({required this.repository});

  @override
  AsyncRequest<List<EducationalGroup>> call(ListGroupsParams params) {
    return repository.listEducationalGroups(params);
  }
}
