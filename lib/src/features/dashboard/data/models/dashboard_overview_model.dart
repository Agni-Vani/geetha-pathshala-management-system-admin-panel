import '../../domain/entities/dashboard_overview.dart';

class DashboardStatModel implements DashboardStat {
  @override
  final String label;
  @override
  final String value;
  @override
  final String delta;
  @override
  final String iconKey;
  @override
  final int tintHex;

  const DashboardStatModel({
    required this.label,
    required this.value,
    required this.delta,
    required this.iconKey,
    required this.tintHex,
  });

  factory DashboardStatModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatModel(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      delta: json['delta'] as String? ?? '',
      iconKey: json['icon_key'] as String? ?? '',
      tintHex: json['tint_hex'] as int? ?? 0xFF1565C0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'delta': delta,
      'icon_key': iconKey,
      'tint_hex': tintHex,
    };
  }
}

class WeeklyAttendancePointModel implements WeeklyAttendancePoint {
  @override
  final String label;
  @override
  final int value;

  const WeeklyAttendancePointModel({
    required this.label,
    required this.value,
  });

  factory WeeklyAttendancePointModel.fromJson(Map<String, dynamic> json) {
    return WeeklyAttendancePointModel(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}

class GenderDistributionModel implements GenderDistribution {
  @override
  final double malePercentage;
  @override
  final double femalePercentage;
  @override
  final String totalStudents;

  const GenderDistributionModel({
    required this.malePercentage,
    required this.femalePercentage,
    required this.totalStudents,
  });

  factory GenderDistributionModel.fromJson(Map<String, dynamic> json) {
    return GenderDistributionModel(
      malePercentage: (json['male_percentage'] as num?)?.toDouble() ?? 0.5,
      femalePercentage: (json['female_percentage'] as num?)?.toDouble() ?? 0.5,
      totalStudents: json['total_students'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'male_percentage': malePercentage,
      'female_percentage': femalePercentage,
      'total_students': totalStudents,
    };
  }
}

class DashboardRecentItemModel implements DashboardRecentItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String date;

  const DashboardRecentItemModel({
    required this.id,
    required this.title,
    required this.date,
  });

  factory DashboardRecentItemModel.fromJson(Map<String, dynamic> json) {
    return DashboardRecentItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }
}

class DashboardOverviewModel implements DashboardOverview {
  @override
  final List<DashboardStatModel> stats;
  @override
  final List<WeeklyAttendancePointModel> weeklyAttendance;
  @override
  final GenderDistributionModel genderDistribution;
  @override
  final List<DashboardRecentItemModel> recentNotices;
  @override
  final List<DashboardRecentItemModel> upcomingEvents;

  const DashboardOverviewModel({
    required this.stats,
    required this.weeklyAttendance,
    required this.genderDistribution,
    required this.recentNotices,
    required this.upcomingEvents,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewModel(
      stats: (json['stats'] as List? ?? [])
          .map((e) => DashboardStatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      weeklyAttendance: (json['weekly_attendance'] as List? ?? [])
          .map((e) => WeeklyAttendancePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      genderDistribution: GenderDistributionModel.fromJson(
        json['gender_distribution'] as Map<String, dynamic>? ?? {},
      ),
      recentNotices: (json['recent_notices'] as List? ?? [])
          .map((e) => DashboardRecentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      upcomingEvents: (json['upcoming_events'] as List? ?? [])
          .map((e) => DashboardRecentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.map((e) => e.toJson()).toList(),
      'weekly_attendance': weeklyAttendance.map((e) => e.toJson()).toList(),
      'gender_distribution': genderDistribution.toJson(),
      'recent_notices': recentNotices.map((e) => e.toJson()).toList(),
      'upcoming_events': upcomingEvents.map((e) => e.toJson()).toList(),
    };
  }
}
