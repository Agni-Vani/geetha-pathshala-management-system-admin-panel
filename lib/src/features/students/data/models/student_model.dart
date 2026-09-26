import '../../domain/entities/entities.dart';

class StudentModel extends Student {
  @override
  final String id;
  @override
  final String name;
  @override
  final String studentClass;
  @override
  final String pathshala;
  @override
  final String roll;
  @override
  final bool isActive;

  const StudentModel({
    required this.id,
    required this.name,
    required this.studentClass,
    required this.pathshala,
    required this.roll,
    required this.isActive,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      studentClass: json['studentClass'] as String,
      pathshala: json['pathshala'] as String,
      roll: json['roll'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'studentClass': studentClass,
    'pathshala': pathshala,
    'roll': roll,
    'isActive': isActive,
  };
}
