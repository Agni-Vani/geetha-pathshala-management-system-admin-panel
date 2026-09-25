import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'group_enrollment_model.freezed.dart';
part 'group_enrollment_model.g.dart';

@freezed
abstract class GroupEnrollmentModel extends GroupEnrollment
    with _$GroupEnrollmentModel {
  const GroupEnrollmentModel._() : super();

  const factory GroupEnrollmentModel({
    required String id,
    required String groupId,
    required String studentAdmissionId,
    required String personId,
    required AdmissionStatus status,
    required DateTime enrolledAt,
  }) = _GroupEnrollmentModel;

  factory GroupEnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$GroupEnrollmentModelFromJson(json);
}
