import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/events/data/datasources/mock_events_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/events/data/repositories/events_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/events/domain/entities/entities.dart';
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
      final success = response as SuccessRepoCall<List<Event>>;
      expect(success.data!.length, equals(4));
      expect(success.data!.first.title, equals('জন্মাষ্টমী'));
    });

    test('createEvent adds a new event to the repository', () async {
      final response = await repository.createEvent(
        CreateEventParams(
          title: 'রথযাত্রা উৎসব',
          description: 'জগন্নাথ দেবের রথযাত্রা শোভাযাত্রা ও কীর্তন।',
          eventDate: DateTime(2025, 7, 7),
          time: 'সকাল ৯:০০',
          scope: 'All Pathshalas',
          iconName: 'celebration_outlined',
        ),
      );
      expect(response, isA<SuccessRepoCall<Event>>());
      final created = (response as SuccessRepoCall<Event>).data!;
      expect(created.title, equals('রথযাত্রা উৎসব'));
      expect(created.time, equals('সকাল ৯:০০'));

      final listResponse = await repository.listEvents(const ListEventsParams());
      final events = (listResponse as SuccessRepoCall<List<Event>>).data!;
      expect(events.length, equals(5));
      expect(events.any((e) => e.id == created.id), isTrue);
    });

    test('updateEvent modifies event information', () async {
      final updateResponse = await repository.updateEvent(
        UpdateEventParams(
          id: 'event-001',
          title: 'শ্রীকৃষ্ণ জন্মাষ্টমী মহোৎসব',
          description: 'সারাদিনব্যাপী হরিনাম সংকীর্তন ও অভিষেক।',
          eventDate: DateTime(2024, 8, 26),
          time: 'সকাল ৮:০০',
          scope: 'All Pathshalas',
          iconName: 'celebration_outlined',
        ),
      );
      expect(updateResponse, isA<SuccessRepoCall<Event>>());
      final updated = (updateResponse as SuccessRepoCall<Event>).data!;
      expect(updated.title, equals('শ্রীকৃষ্ণ জন্মাষ্টমী মহোৎসব'));
      expect(updated.time, equals('সকাল ৮:০০'));
    });

    test('deleteEvent removes event from repository', () async {
      final deleteResponse = await repository.deleteEvent(
        const DeleteEventParams(id: 'event-004'),
      );
      expect(deleteResponse, isA<SuccessRepoCall<bool>>());

      final listResponse = await repository.listEvents(const ListEventsParams());
      final events = (listResponse as SuccessRepoCall<List<Event>>).data!;
      expect(events.any((e) => e.id == 'event-004'), isFalse);
    });
  });
}
