import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class CommunicationRepository {
  AsyncRequest<Notice> publishNotice(PublishNoticeParams params);
  AsyncRequest<List<Notice>> getNotices(GetNoticesParams params);
  AsyncRequest<NoticeReadReceipt> recordReadReceipt(
    RecordReadReceiptParams params,
  );
  AsyncRequest<List<NoticeTarget>> getNoticeTargets(String noticeId);
}
