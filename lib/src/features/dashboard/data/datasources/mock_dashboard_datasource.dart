import '../models/dashboard_overview_model.dart';
import 'dashboard_datasource.dart';

class MockDashboardDatasource implements DashboardDatasource {
  final Duration processingDelay;

  MockDashboardDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  });

  static const DashboardOverviewModel _defaultOverview = DashboardOverviewModel(
    stats: [
      DashboardStatModel(
        iconKey: 'account_balance',
        value: '২৪',
        label: 'Total Pathshalas',
        delta: '+২ এই মাসে',
        tintHex: 0xFF1565C0,
      ),
      DashboardStatModel(
        iconKey: 'people',
        value: '১,২৪৮',
        label: 'Total Students',
        delta: '+১৫৬ এই মাসে',
        tintHex: 0xFF1E7B34,
      ),
      DashboardStatModel(
        iconKey: 'badge',
        value: '৮৬',
        label: 'Total Teachers',
        delta: '+৮ এই মাসে',
        tintHex: 0xFFAD6800,
      ),
      DashboardStatModel(
        iconKey: 'how_to_reg',
        value: '৯২.৫%',
        label: 'Attendance Today',
        delta: '+২.৩% গতকাল থেকে',
        tintHex: 0xFFBA1A1A,
      ),
    ],
    weeklyAttendance: [
      WeeklyAttendancePointModel(label: 'সোম', value: 70),
      WeeklyAttendancePointModel(label: 'মঙ্গল', value: 76),
      WeeklyAttendancePointModel(label: 'বুধ', value: 82),
      WeeklyAttendancePointModel(label: 'বৃহঃ', value: 88),
      WeeklyAttendancePointModel(label: 'শুক্র', value: 79),
      WeeklyAttendancePointModel(label: 'শনি', value: 91),
      WeeklyAttendancePointModel(label: 'রবি', value: 85),
    ],
    genderDistribution: GenderDistributionModel(
      malePercentage: 0.62,
      femalePercentage: 0.38,
      totalStudents: '১,২৪৮',
    ),
    recentNotices: [
      DashboardRecentItemModel(
        id: 'notice-1',
        title: 'জন্মাষ্টমী উদযাপন',
        date: '২০ আগস্ট, ২০২৪',
      ),
      DashboardRecentItemModel(
        id: 'notice-2',
        title: 'শিক্ষার্থীদের জন্য প্রবন্ধ প্রতিযোগিতা',
        date: '১৮ আগস্ট, ২০২৪',
      ),
      DashboardRecentItemModel(
        id: 'notice-3',
        title: 'অভিভাবক-শিক্ষক সভা',
        date: '১৫ আগস্ট, ২০২৪',
      ),
    ],
    upcomingEvents: [
      DashboardRecentItemModel(
        id: 'event-1',
        title: 'জন্মাষ্টমী',
        date: '২৬ আগস্ট, ২০২৪',
      ),
      DashboardRecentItemModel(
        id: 'event-2',
        title: 'গীতা জয়ন্তী',
        date: '১১ ডিসেম্বর, ২০২৪',
      ),
      DashboardRecentItemModel(
        id: 'event-3',
        title: 'বার্ষিক দিবস',
        date: '২৬ জানুয়ারি, ২০২৫',
      ),
    ],
  );

  @override
  Future<DashboardOverviewModel> getOverview({String? pathshalaId}) async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
    return _defaultOverview;
  }
}
