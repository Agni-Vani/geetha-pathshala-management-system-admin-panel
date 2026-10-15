import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class AssignRoleJourney implements AsyncUsecase<Map<String, dynamic>, AssignRoleJourneyParams> {
  final IamRepository repository;

  const AssignRoleJourney({required this.repository});

  @override
  AsyncRequest<Map<String, dynamic>> call(AssignRoleJourneyParams params) {
    return repository.assignRoleJourney(params);
  }
}
