import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'academic_year_model.freezed.dart';
part 'academic_year_model.g.dart';

@freezed
abstract class AcademicYearModel extends AcademicYear
    with _$AcademicYearModel {
  const AcademicYearModel._() : super();

  const factory AcademicYearModel({
    required String id,
    required String organizationId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required AcademicYearStatus status,
    required DateTime createdAt,
  }) = _AcademicYearModel;

  factory AcademicYearModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicYearModelFromJson(json);
}
