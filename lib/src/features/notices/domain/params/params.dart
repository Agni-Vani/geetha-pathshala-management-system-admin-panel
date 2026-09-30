import '../entities/communication_enums.dart';

final class NoticeTargetParam {
  final NoticeTargetType targetType;
  final String? targetId;

  const NoticeTargetParam({
    required this.targetType,
    this.targetId,
  });
}

final class PublishNoticeParams {
  final String organizationId;
  final String? pathshalaId;
  final String title;
  final String content;
  final String createdByUserId;
  final List<NoticeTargetParam> targets;

  const PublishNoticeParams({
    required this.organizationId,
    this.pathshalaId,
    required this.title,
    required this.content,
    required this.createdByUserId,
    required this.targets,
  });
}

final class GetNoticesParams {
  final String organizationId;
  final String? pathshalaId;
  final int page;
  final int pageSize;

  const GetNoticesParams({
    required this.organizationId,
    this.pathshalaId,
    this.page = 1,
    this.pageSize = 20,
  });
}

final class RecordReadReceiptParams {
  final String noticeId;
  final String personId;
  final String userAccountId;

  const RecordReadReceiptParams({
    required this.noticeId,
    required this.personId,
    required this.userAccountId,
  });
}
