abstract class DashboardStat {
  const DashboardStat();

  String get label;
  String get value;
  String get delta;
  String get iconKey;
  int get tintHex;
}

abstract class WeeklyAttendancePoint {
  const WeeklyAttendancePoint();

  String get label;
  int get value;
}

abstract class GenderDistribution {
  const GenderDistribution();

  double get malePercentage;
  double get femalePercentage;
  String get totalStudents;
}

abstract class DashboardRecentItem {
  const DashboardRecentItem();

  String get id;
  String get title;
  String get date;
}

abstract class DashboardOverview {
  const DashboardOverview();

  List<DashboardStat> get stats;
  List<WeeklyAttendancePoint> get weeklyAttendance;
  GenderDistribution get genderDistribution;
  List<DashboardRecentItem> get recentNotices;
  List<DashboardRecentItem> get upcomingEvents;
}
