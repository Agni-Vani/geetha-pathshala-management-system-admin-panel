import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

/// Contract defining notice publishing and reading operations.
abstract interface class NoticesRepository {
  AsyncRequest<Notice> publishNotice(PublishNoticeParams params);
  AsyncRequest<List<Notice>> getNotices(GetNoticesParams params);
  AsyncRequest<NoticeReadReceipt> recordReadReceipt(
    RecordReadReceiptParams params,
  );
}
