import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class CommunicationDatasource {
  Future<NoticeModel> publishNotice(PublishNoticeParams params);
  Future<List<NoticeModel>> getNotices(GetNoticesParams params);
  Future<NoticeReadReceiptModel> recordReadReceipt(
    RecordReadReceiptParams params,
  );
  Future<List<NoticeTargetModel>> getNoticeTargets(String noticeId);
}
