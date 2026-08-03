import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

final class CommunicationRepositoryImpl
    with ErrorHandler
    implements CommunicationRepository {
  final CommunicationDatasource datasource;

  const CommunicationRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<Notice> publishNotice(PublishNoticeParams params) {
    return _request(() => datasource.publishNotice(params));
  }

  @override
  AsyncRequest<List<Notice>> getNotices(GetNoticesParams params) {
    return _request(() => datasource.getNotices(params));
  }

  @override
  AsyncRequest<NoticeReadReceipt> recordReadReceipt(
    RecordReadReceiptParams params,
  ) {
    return _request(() => datasource.recordReadReceipt(params));
  }

  @override
  AsyncRequest<List<NoticeTarget>> getNoticeTargets(String noticeId) {
    return _request(() => datasource.getNoticeTargets(noticeId));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
