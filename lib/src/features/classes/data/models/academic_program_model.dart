import '../../domain/entities/entities.dart';
import 'academic_level_model.dart';

class AcademicProgramModel extends AcademicProgram {
  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String levelTermLabel;
  @override
  final String? description;
  @override
  final String status;
  @override
  final List<AcademicLevelModel> levels;
  @override
  final DateTime createdAt;

  const AcademicProgramModel({
    required this.id,
    required this.name,
    required this.code,
    required this.levelTermLabel,
    this.description,
    this.status = 'active',
    this.levels = const [],
    required this.createdAt,
  });

  factory AcademicProgramModel.fromJson(Map<String, dynamic> json) {
    final rawLevels = json['levels'] as List? ?? [];
    return AcademicProgramModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      levelTermLabel: json['levelTermLabel'] as String? ??
          json['level_term_label'] as String? ??
          'লেভেল',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      levels: rawLevels
          .map((l) => AcademicLevelModel.fromJson(l as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'levelTermLabel': levelTermLabel,
    'description': description,
    'status': status,
    'levels': levels.map((l) => l.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  AcademicProgramModel copyWith({
    String? id,
    String? name,
    String? code,
    String? levelTermLabel,
    String? description,
    String? status,
    List<AcademicLevelModel>? levels,
    DateTime? createdAt,
  }) {
    return AcademicProgramModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      levelTermLabel: levelTermLabel ?? this.levelTermLabel,
      description: description ?? this.description,
      status: status ?? this.status,
      levels: levels ?? this.levels,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
