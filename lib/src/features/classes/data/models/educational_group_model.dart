import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'educational_group_model.freezed.dart';
part 'educational_group_model.g.dart';

@freezed
abstract class EducationalGroupModel extends EducationalGroup
    with _$EducationalGroupModel {
  const EducationalGroupModel._() : super();

  const factory EducationalGroupModel({
    required String id,
    required String pathshalaId,
    required String academicYearId,
    required String name,
    required String gradeLevel,
    required GroupStatus status,
    required DateTime createdAt,
  }) = _EducationalGroupModel;

  factory EducationalGroupModel.fromJson(Map<String, dynamic> json) =>
      _$EducationalGroupModelFromJson(json);
}
