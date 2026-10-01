import '../../domain/entities/entities.dart';

class PersonWorkExperienceModel extends PersonWorkExperience {
  @override
  final String id;
  @override
  final String personId;
  @override
  final String organizationName;
  @override
  final String roleOrDesignation;
  @override
  final String? departmentOrUnit;
  @override
  final String engagementType;
  @override
  final String? location;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final bool isOngoing;
  @override
  final String? responsibilities;
  @override
  final String? createdByUserId;
  @override
  final String createdByRoleAtTime;
  @override
  final String createdByNameSnapshot;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  const PersonWorkExperienceModel({
    required this.id,
    required this.personId,
    required this.organizationName,
    required this.roleOrDesignation,
    this.departmentOrUnit,
    this.engagementType = 'full_time',
    this.location,
    required this.startDate,
    this.endDate,
    this.isOngoing = false,
    this.responsibilities,
    this.createdByUserId,
    required this.createdByRoleAtTime,
    required this.createdByNameSnapshot,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PersonWorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return PersonWorkExperienceModel(
      id: json['id'] as String,
      personId: (json['person_id'] ?? json['personId']) as String,
      organizationName: (json['organization_name'] ?? json['organizationName']) as String,
      roleOrDesignation: (json['role_or_designation'] ?? json['roleOrDesignation']) as String,
      departmentOrUnit: (json['department_or_unit'] ?? json['departmentOrUnit']) as String?,
      engagementType: (json['engagement_type'] ?? json['engagementType'] ?? 'full_time') as String,
      location: json['location'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : (json['startDate'] != null
              ? DateTime.parse(json['startDate'] as String)
              : DateTime.now()),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : (json['endDate'] != null
              ? DateTime.parse(json['endDate'] as String)
              : null),
      isOngoing: json['is_ongoing'] as bool? ?? json['isOngoing'] as bool? ?? false,
      responsibilities: json['responsibilities'] as String?,
      createdByUserId: (json['created_by_user_id'] ?? json['createdByUserId']) as String?,
      createdByRoleAtTime: (json['created_by_role_at_time'] ?? json['createdByRoleAtTime'] ?? 'Admin') as String,
      createdByNameSnapshot: (json['created_by_name_snapshot'] ?? json['createdByNameSnapshot'] ?? 'System') as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : (json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : (json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'person_id': personId,
    'organization_name': organizationName,
    'role_or_designation': roleOrDesignation,
    'department_or_unit': departmentOrUnit,
    'engagement_type': engagementType,
    'location': location,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'is_ongoing': isOngoing,
    'responsibilities': responsibilities,
    'created_by_user_id': createdByUserId,
    'created_by_role_at_time': createdByRoleAtTime,
    'created_by_name_snapshot': createdByNameSnapshot,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
