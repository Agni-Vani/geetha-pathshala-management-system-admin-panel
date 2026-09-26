import '../../domain/entities/entities.dart';

class TeacherModel extends Teacher {
  @override
  final String id;
  @override
  final String name;
  @override
  final String subject;
  @override
  final String pathshala;
  @override
  final bool isActive;
  @override
  final String? degree;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? email;

  const TeacherModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.pathshala,
    required this.isActive,
    this.degree,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.phone,
    this.email,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      pathshala: json['pathshala'] as String,
      isActive: json['isActive'] as bool? ?? true,
      degree: json['degree'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'pathshala': pathshala,
    'isActive': isActive,
    'degree': degree,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'address': address,
    'phone': phone,
    'email': email,
  };
}
