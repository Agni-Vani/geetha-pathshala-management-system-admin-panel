import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/communication/data/datasources/mock_communication_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/communication/data/repositories/communication_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/communication/domain/entities/entities.dart';
import 'package:geetha_pathshala_management_web/src/features/communication/domain/params/params.dart';

void main() {
  group('CommunicationRepositoryImpl Tests', () {
    late MockCommunicationDatasource mockDatasource;
    late CommunicationRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockCommunicationDatasource(
        processingDelay: Duration.zero,
      );
      repository = CommunicationRepositoryImpl(datasource: mockDatasource);
    });

    test('getNotices returns seeded notices for organization', () async {
      final response = await repository.getNotices(
        const GetNoticesParams(organizationId: 'org-gp-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });

    test('publishNotice creates and returns a published notice', () async {
      final response = await repository.publishNotice(
        const PublishNoticeParams(
          organizationId: 'org-gp-central',
          title: 'Weekly Satsang Update',
          content: 'This Sunday satsang will commence at 8:00 AM.',
          createdByUserId: 'usr-admin-anirban',
          targets: [
            NoticeTargetParam(
              targetType: NoticeTargetType.organization,
              targetId: 'org-gp-central',
            ),
          ],
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.title, equals('Weekly Satsang Update'));
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
