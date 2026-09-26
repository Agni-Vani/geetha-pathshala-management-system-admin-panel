abstract class AttendanceOverview {
  const AttendanceOverview();

  List<AttendanceSummaryStat> get summaryStats;
  List<AttendanceRowItem> get attendanceRows;
}

abstract class AttendanceSummaryStat {
  const AttendanceSummaryStat();

  String get iconName;
  String get value;
  String get label;
  int get tintValue;
}

abstract class AttendanceRowItem {
  const AttendanceRowItem();

  String get id;
  String get name;
  String get studentClass;
  String get pathshala;
  bool get isPresent;
}
