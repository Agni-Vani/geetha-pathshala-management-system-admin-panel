import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/notices/data/datasources/mock_notices_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/notices/data/repositories/notices_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/notices/domain/entities/entities.dart';
import 'package:geetha_pathshala_management_web/src/features/notices/domain/params/params.dart';

void main() {
  group('NoticesRepositoryImpl Tests', () {
    late MockNoticesDatasource mockDatasource;
    late NoticesRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockNoticesDatasource(
        processingDelay: Duration.zero,
      );
      repository = NoticesRepositoryImpl(datasource: mockDatasource);
    });

    test('getNotices returns seeded notices for organization', () async {
      final response = await repository.getNotices(
        const GetNoticesParams(organizationId: 'org-gp-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<List<Notice>>;
      expect(success.data!.length, greaterThanOrEqualTo(1));
    });

    test('publishNotice creates and returns a published notice', () async {
      final response = await repository.publishNotice(
        const PublishNoticeParams(
          organizationId: 'org-gp-central',
          title: 'Weekly Satsang Update',
          content: 'This Sunday satsang will commence at 8:00 AM.',
          createdByUserId: 'usr-admin-anirban',
          status: NoticeStatus.published,
          targets: [
            NoticeTargetParam(
              targetType: NoticeTargetType.organization,
              targetId: 'org-gp-central',
            ),
          ],
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall<Notice>;
      expect(success.data!.title, equals('Weekly Satsang Update'));
      expect(success.data!.status, equals(NoticeStatus.published));
    });

    test('updateNotice modifies notice details', () async {
      final createResponse = await repository.publishNotice(
        const PublishNoticeParams(
          organizationId: 'org-gp-central',
          title: 'Initial Notice',
          content: 'Initial Content',
          createdByUserId: 'usr-admin-anirban',
          status: NoticeStatus.draft,
        ),
      );
      final created = (createResponse as SuccessRepoCall<Notice>).data!;

      final updateResponse = await repository.updateNotice(
        UpdateNoticeParams(
          id: created.id,
          title: 'Updated Notice Title',
          content: 'Updated Content Body',
          status: NoticeStatus.published,
        ),
      );

      expect(updateResponse, isA<SuccessRepoCall<Notice>>());
      final updated = (updateResponse as SuccessRepoCall<Notice>).data!;
      expect(updated.title, equals('Updated Notice Title'));
      expect(updated.content, equals('Updated Content Body'));
      expect(updated.status, equals(NoticeStatus.published));
    });

    test('deleteNotice removes notice from datasource', () async {
      final createResponse = await repository.publishNotice(
        const PublishNoticeParams(
          organizationId: 'org-gp-central',
          title: 'To Be Deleted',
          content: 'Will be removed soon',
          createdByUserId: 'usr-admin-anirban',
        ),
      );
      final created = (createResponse as SuccessRepoCall<Notice>).data!;

      final deleteResponse = await repository.deleteNotice(
        DeleteNoticeParams(id: created.id),
      );
      expect(deleteResponse, isA<SuccessRepoCall<bool>>());

      final getResponse = await repository.getNotices(
        const GetNoticesParams(organizationId: 'org-gp-central'),
      );
      final list = (getResponse as SuccessRepoCall<List<Notice>>).data!;
      expect(list.any((n) => n.id == created.id), isFalse);
    });

    test('recordReadReceipt logs a read receipt', () async {
      final response = await repository.recordReadReceipt(
        const RecordReadReceiptParams(
          noticeId: 'notice-001',
          personId: 'person-anirban-sen',
          userAccountId: 'usr-admin-anirban',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
    });
  });
}
