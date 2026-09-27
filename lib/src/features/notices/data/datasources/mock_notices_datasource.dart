import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'notices_datasource.dart';

final class MockNoticesDatasource implements NoticesDatasource {
  final Duration processingDelay;
  final List<NoticeModel> _notices;
  final List<NoticeTargetModel> _targets;
  final List<NoticeReadReceiptModel> _receipts;

  MockNoticesDatasource({
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
        title: 'জন্মাষ্টমী উদযাপন',
        content:
            'আগামী ২০ আগস্ট জন্মাষ্টমী উদযাপন করা হবে বলে আনন্দের সাথে জানানো যাচ্ছে।',
        status: NoticeStatus.published,
        publishedAt: DateTime(2024, 8, 20),
        createdByUserId: 'usr-admin-anirban',
        createdAt: DateTime(2024, 8, 20),
      ),
      NoticeModel(
        id: 'notice-002',
        organizationId: 'org-gp-central',
        pathshalaId: 'pathshala-dhaka-central',
        title: 'শিক্ষার্থীদের জন্য প্রবন্ধ প্রতিযোগিতা',
        content: 'সকল শিক্ষার্থীর জন্য প্রবন্ধ প্রতিযোগিতা অনুষ্ঠিত হবে।',
        status: NoticeStatus.published,
        publishedAt: DateTime(2024, 8, 18),
        createdByUserId: 'usr-admin-anirban',
        createdAt: DateTime(2024, 8, 18),
      ),
      NoticeModel(
        id: 'notice-003',
        organizationId: 'org-gp-central',
        pathshalaId: 'pathshala-dhaka-central',
        title: 'অভিভাবক-শিক্ষক সভা',
        content: 'সকল অভিভাবককে উপস্থিত থাকার জন্য অনুরোধ করা হচ্ছে।',
        status: NoticeStatus.published,
        publishedAt: DateTime(2024, 8, 15),
        createdByUserId: 'usr-admin-anirban',
        createdAt: DateTime(2024, 8, 15),
      ),
      NoticeModel(
        id: 'notice-004',
        organizationId: 'org-gp-central',
        pathshalaId: 'pathshala-dhaka-central',
        title: 'ছুটির নোটিশ',
        content: 'স্বাধীনতা দিবস উপলক্ষে পাঠশালা বন্ধ থাকবে।',
        status: NoticeStatus.published,
        publishedAt: DateTime(2024, 8, 10),
        createdByUserId: 'usr-admin-anirban',
        createdAt: DateTime(2024, 8, 10),
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
