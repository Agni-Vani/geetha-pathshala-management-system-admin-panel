import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'student_admission_model.freezed.dart';
part 'student_admission_model.g.dart';

@freezed
abstract class StudentAdmissionModel extends StudentAdmission
    with _$StudentAdmissionModel {
  const StudentAdmissionModel._() : super();

  const factory StudentAdmissionModel({
    required String id,
    required String organizationId,
    required String pathshalaId,
    required String personId,
    required String rollNumber,
    required DateTime admissionDate,
    required AdmissionStatus status,
    required DateTime createdAt,
  }) = _StudentAdmissionModel;

  factory StudentAdmissionModel.fromJson(Map<String, dynamic> json) =>
      _$StudentAdmissionModelFromJson(json);
}
