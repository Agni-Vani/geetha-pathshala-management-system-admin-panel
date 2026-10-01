import '../../domain/entities/entities.dart';

class PersonEducationModel extends PersonEducation {
  @override
  final String id;
  @override
  final String personId;
  @override
  final String academicLevel;
  @override
  final String? disciplineOrGroup;
  @override
  final String institutionName;
  @override
  final String? governingBoard;
  @override
  final int? startYear;
  @override
  final int? passingYear;
  @override
  final bool isOngoing;
  @override
  final String? resultOrScore;
  @override
  final String? remarks;
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

  const PersonEducationModel({
    required this.id,
    required this.personId,
    required this.academicLevel,
    this.disciplineOrGroup,
    required this.institutionName,
    this.governingBoard,
    this.startYear,
    this.passingYear,
    this.isOngoing = false,
    this.resultOrScore,
    this.remarks,
    this.createdByUserId,
    required this.createdByRoleAtTime,
    required this.createdByNameSnapshot,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PersonEducationModel.fromJson(Map<String, dynamic> json) {
    return PersonEducationModel(
      id: json['id'] as String,
      personId: (json['person_id'] ?? json['personId']) as String,
      academicLevel: (json['academic_level'] ?? json['academicLevel']) as String,
      disciplineOrGroup: (json['discipline_or_group'] ?? json['disciplineOrGroup']) as String?,
      institutionName: (json['institution_name'] ?? json['institutionName']) as String,
      governingBoard: (json['governing_board'] ?? json['governingBoard']) as String?,
      startYear: json['start_year'] as int? ?? json['startYear'] as int?,
      passingYear: json['passing_year'] as int? ?? json['passingYear'] as int?,
      isOngoing: json['is_ongoing'] as bool? ?? json['isOngoing'] as bool? ?? false,
      resultOrScore: (json['result_or_score'] ?? json['resultOrScore']) as String?,
      remarks: json['remarks'] as String?,
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
    'academic_level': academicLevel,
    'discipline_or_group': disciplineOrGroup,
    'institution_name': institutionName,
    'governing_board': governingBoard,
    'start_year': startYear,
    'passing_year': passingYear,
    'is_ongoing': isOngoing,
    'result_or_score': resultOrScore,
    'remarks': remarks,
    'created_by_user_id': createdByUserId,
    'created_by_role_at_time': createdByRoleAtTime,
    'created_by_name_snapshot': createdByNameSnapshot,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
