import '../../domain/entities/entities.dart';

class AcademicLevelModel extends AcademicLevel {
  @override
  final String id;
  @override
  final String programId;
  @override
  final String name;
  @override
  final String code;
  @override
  final int sequence;
  @override
  final String? description;
  @override
  final String status;
  @override
  final DateTime createdAt;

  const AcademicLevelModel({
    required this.id,
    required this.programId,
    required this.name,
    required this.code,
    required this.sequence,
    this.description,
    this.status = 'active',
    required this.createdAt,
  });

  factory AcademicLevelModel.fromJson(Map<String, dynamic> json) {
    return AcademicLevelModel(
      id: json['id'] as String,
      programId: json['programId'] as String? ?? json['program_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      sequence: (json['sequence'] as num?)?.toInt() ?? 1,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'programId': programId,
    'name': name,
    'code': code,
    'sequence': sequence,
    'description': description,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  AcademicLevelModel copyWith({
    String? id,
    String? programId,
    String? name,
    String? code,
    int? sequence,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return AcademicLevelModel(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      name: name ?? this.name,
      code: code ?? this.code,
      sequence: sequence ?? this.sequence,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
