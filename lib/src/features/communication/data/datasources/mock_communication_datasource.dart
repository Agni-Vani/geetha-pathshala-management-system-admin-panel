import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'communication_datasource.dart';

final class MockCommunicationDatasource implements CommunicationDatasource {
  final Duration processingDelay;
  final List<NoticeModel> _notices;
  final List<NoticeTargetModel> _targets;
  final List<NoticeReadReceiptModel> _receipts;

  MockCommunicationDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _notices = _seedNotices(),
       _targets = _seedTargets(),
       _receipts = [];

  @override
  Future<NoticeModel> publishNotice(PublishNoticeParams params) async {
    await _simulateProcessing();
    final noticeId = 'notice-${DateTime.now().millisecondsSinceEpoch}';
    final notice = NoticeModel(
      id: noticeId,
      organizationId: params.organizationId,
      pathshalaId: params.pathshalaId,
      title: params.title,
      content: params.content,
      status: NoticeStatus.published,
      publishedAt: DateTime.now(),
      createdByUserId: params.createdByUserId,
      createdAt: DateTime.now(),
    );
    _notices.add(notice);

    for (final t in params.targets) {
      _targets.add(
        NoticeTargetModel(
          id: 'target-${DateTime.now().millisecondsSinceEpoch}-${t.targetType.name}',
          noticeId: noticeId,
          targetType: t.targetType,
          targetId: t.targetId,
        ),
      );
    }
    return notice;
  }

  @override
  Future<List<NoticeModel>> getNotices(GetNoticesParams params) async {
    await _simulateProcessing();
    return _notices.where((n) {
      if (n.organizationId != params.organizationId) return false;
      if (params.pathshalaId != null &&
          n.pathshalaId != null &&
          n.pathshalaId != params.pathshalaId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<NoticeReadReceiptModel> recordReadReceipt(
    RecordReadReceiptParams params,
  ) async {
    await _simulateProcessing();
    final receipt = NoticeReadReceiptModel(
      id: 'rr-${DateTime.now().millisecondsSinceEpoch}',
      noticeId: params.noticeId,
      personId: params.personId,
      userAccountId: params.userAccountId,
      readAt: DateTime.now(),
    );
    _receipts.add(receipt);
    return receipt;
  }

  @override
  Future<List<NoticeTargetModel>> getNoticeTargets(String noticeId) async {
    await _simulateProcessing();
    return _targets.where((t) => t.noticeId == noticeId).toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<NoticeModel> _seedNotices() {
    return [
      NoticeModel(
        id: 'notice-001',
        organizationId: 'org-gp-central',
        pathshalaId: 'pathshala-dhaka-central',
        title: 'Annual Gita Chanting Competition 2026 Announcement',
        content:
            'Registration is now open for all students across Pathshalas.',
        status: NoticeStatus.published,
        publishedAt: DateTime(2026, 7, 1),
        createdByUserId: 'usr-admin-anirban',
        createdAt: DateTime(2026, 7, 1),
      ),
    ];
  }

  static List<NoticeTargetModel> _seedTargets() {
    return [
      const NoticeTargetModel(
        id: 'target-001',
        noticeId: 'notice-001',
        targetType: NoticeTargetType.organization,
        targetId: 'org-gp-central',
      ),
    ];
  }
}
