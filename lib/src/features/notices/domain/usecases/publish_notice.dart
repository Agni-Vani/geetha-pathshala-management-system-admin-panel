import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class PublishNotice
    implements AsyncUsecase<Notice, PublishNoticeParams> {
  final NoticesRepository repository;

  const PublishNotice({required this.repository});

  @override
  AsyncRequest<Notice> call(PublishNoticeParams params) {
    return repository.publishNotice(params);
  }
}
