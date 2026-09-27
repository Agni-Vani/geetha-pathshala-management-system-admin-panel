import '../../domain/params/params.dart';
import '../models/models.dart';

/// Backing data-source contract for notices.
abstract interface class NoticesDatasource {
  Future<NoticeModel> publishNotice(PublishNoticeParams params);
  Future<List<NoticeModel>> getNotices(GetNoticesParams params);
  Future<NoticeReadReceiptModel> recordReadReceipt(
    RecordReadReceiptParams params,
  );
}
