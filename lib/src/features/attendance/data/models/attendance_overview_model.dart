import '../../domain/entities/entities.dart';

class AttendanceOverviewModel extends AttendanceOverview {
  @override
  final List<AttendanceSummaryStatModel> summaryStats;
  @override
  final List<AttendanceRowItemModel> attendanceRows;

  const AttendanceOverviewModel({
    required this.summaryStats,
    required this.attendanceRows,
  });

  factory AttendanceOverviewModel.fromJson(Map<String, dynamic> json) {
    return AttendanceOverviewModel(
      summaryStats: (json['summaryStats'] as List? ?? [])
          .map((e) => AttendanceSummaryStatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      attendanceRows: (json['attendanceRows'] as List? ?? [])
          .map((e) => AttendanceRowItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'summaryStats': summaryStats.map((e) => e.toJson()).toList(),
    'attendanceRows': attendanceRows.map((e) => e.toJson()).toList(),
  };
}

class AttendanceSummaryStatModel extends AttendanceSummaryStat {
  @override
  final String iconName;
  @override
  final String value;
  @override
  final String label;
  @override
  final int tintValue;

  const AttendanceSummaryStatModel({
    required this.iconName,
    required this.value,
    required this.label,
    required this.tintValue,
  });

  factory AttendanceSummaryStatModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryStatModel(
      iconName: json['iconName'] as String,
      value: json['value'] as String,
      label: json['label'] as String,
      tintValue: json['tintValue'] as int? ?? 0xFF1565C0,
    );
  }

  Map<String, dynamic> toJson() => {
    'iconName': iconName,
    'value': value,
    'label': label,
    'tintValue': tintValue,
  };
}

class AttendanceRowItemModel extends AttendanceRowItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final String studentClass;
  @override
  final String pathshala;
  @override
  final bool isPresent;

  const AttendanceRowItemModel({
    required this.id,
    required this.name,
    required this.studentClass,
    required this.pathshala,
    required this.isPresent,
  });

  factory AttendanceRowItemModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRowItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      studentClass: json['studentClass'] as String,
      pathshala: json['pathshala'] as String,
      isPresent: json['isPresent'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'studentClass': studentClass,
    'pathshala': pathshala,
    'isPresent': isPresent,
  };
}
