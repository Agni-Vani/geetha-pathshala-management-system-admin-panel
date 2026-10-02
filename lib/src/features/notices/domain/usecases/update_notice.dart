import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class UpdateNotice
    implements AsyncUsecase<Notice, UpdateNoticeParams> {
  final NoticesRepository repository;

  const UpdateNotice({required this.repository});

  @override
  AsyncRequest<Notice> call(UpdateNoticeParams params) {
    return repository.updateNotice(params);
  }
}
