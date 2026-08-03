import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class RecordReadReceipt
    implements AsyncUsecase<NoticeReadReceipt, RecordReadReceiptParams> {
  final CommunicationRepository repository;

  const RecordReadReceipt({required this.repository});

  @override
  AsyncRequest<NoticeReadReceipt> call(RecordReadReceiptParams params) {
    return repository.recordReadReceipt(params);
  }
}
