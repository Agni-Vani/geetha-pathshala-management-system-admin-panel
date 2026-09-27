import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/events/data/datasources/mock_events_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/events/data/repositories/events_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/events/domain/params/params.dart';

void main() {
  group('EventsRepositoryImpl Tests', () {
    late MockEventsDatasource mockDatasource;
    late EventsRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockEventsDatasource(processingDelay: Duration.zero);
      repository = EventsRepositoryImpl(datasource: mockDatasource);
    });

    test('listEvents returns seeded festival events', () async {
      final response = await repository.listEvents(const ListEventsParams());
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, equals(4));
      expect(success.data.first.title, equals('জন্মাষ্টমী'));
    });
  });
}
