import '../../domain/entities/division.dart';

class DivisionModel extends Division {
  @override
  final String id;
  @override
  final String name;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  const DivisionModel({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse((json['created_at'] ?? json['createdAt']) as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.parse((json['updated_at'] ?? json['updatedAt']) as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
