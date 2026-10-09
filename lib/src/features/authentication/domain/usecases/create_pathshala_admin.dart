import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CreatePathshalaAdmin
    implements AsyncUsecase<Map<String, dynamic>, CreatePathshalaAdminParams> {
  final IamRepository repository;

  const CreatePathshalaAdmin({required this.repository});

  @override
  AsyncRequest<Map<String, dynamic>> call(CreatePathshalaAdminParams params) {
    return repository.createPathshalaAdmin(params);
  }
}
