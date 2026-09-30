import '../../domain/params/params.dart';
import '../models/models.dart';
import 'events_datasource.dart';

final class MockEventsDatasource implements EventsDatasource {
  final Duration processingDelay;
  final List<EventModel> _events;

  MockEventsDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _events = _seedEvents();

  @override
  Future<List<EventModel>> listEvents(ListEventsParams params) async {
    await _simulateProcessing();
    return _events.where((e) {
      if (params.scope != null && params.scope != 'All Pathshalas' && e.scope != params.scope) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<EventModel> _seedEvents() {
    return [
      EventModel(
        id: 'event-001',
        title: 'জন্মাষ্টমী',
        description: 'শ্রীকৃষ্ণের জন্মোৎসব উদযাপন।',
        eventDate: DateTime(2024, 8, 26),
        time: 'সকাল ১০:০০',
        scope: 'All Pathshalas',
        iconName: 'auto_awesome_outlined',
      ),
      EventModel(
        id: 'event-002',
        title: 'গীতা জয়ন্তী',
        description: 'ভগবদ্গীতা অবতরণের স্মরণে অনুষ্ঠান।',
        eventDate: DateTime(2024, 12, 11),
        time: 'সকাল ১০:০০',
        scope: 'All Pathshalas',
        iconName: 'menu_book_outlined',
      ),
      EventModel(
        id: 'event-003',
        title: 'বার্ষিক দিবস',
        description: 'সাংস্কৃতিক অনুষ্ঠানসহ বার্ষিক উৎসব।',
        eventDate: DateTime(2025, 1, 26),
        time: 'সকাল ১০:০০',
        scope: 'Main Pathshala',
        iconName: 'celebration_outlined',
      ),
      EventModel(
        id: 'event-004',
        title: 'সরস্বতী পূজা',
        description: 'দেবী সরস্বতীর পূজা অর্চনা।',
        eventDate: DateTime(2025, 2, 2),
        time: 'সকাল ১০:০০',
        scope: 'All Pathshalas',
        iconName: 'local_florist_outlined',
      ),
    ];
  }
}
