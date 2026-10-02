import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class DeleteNotice
    implements AsyncUsecase<bool, DeleteNoticeParams> {
  final NoticesRepository repository;

  const DeleteNotice({required this.repository});

  @override
  AsyncRequest<bool> call(DeleteNoticeParams params) {
    return repository.deleteNotice(params);
  }
}
